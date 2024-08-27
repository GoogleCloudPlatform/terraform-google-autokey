##  Copyright 2023 Google LLC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      https://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


resource "random_id" "random_suffix" {
  byte_length = 4
}


locals {
  #  project ID for autokey key project
  autokey_key_project_id     = var.create_new_autokey_key_project ? "${var.autokey_key_project_name}-${random_id.random_suffix.hex}" : var.autokey_key_project_id
  autokey_key_project_number = data.google_project.key_project.number

  # Prepping KMS Admins users and autokey service for KMS Admin Role
  new_autokey_project_kms_admins = setunion(var.autokey_project_kms_admins, ["serviceAccount:service-${local.autokey_key_project_number}@gcp-sa-cloudkms.iam.gserviceaccount.com"])
}


data "google_project" "key_project" {
  project_id = local.autokey_key_project_id
  depends_on = [google_project.key_project]
}




# Create Folder in GCP Organization
resource "google_folder" "autokey_folder" {
  count        = var.create_new_folder ? 1 : 0
  display_name = "${var.autokey_folder_name}-${random_id.random_suffix.hex}"
  #  parent       = "organizations/${var.organization_id}"
  parent = var.parent_is_folder ? "folders/${var.parent_folder_id}" : "organizations/${var.organization_id}"
}


# Create the project
resource "google_project" "key_project" {
  count           = var.create_new_autokey_key_project ? 1 : 0
  billing_account = var.billing_account
  folder_id       = var.create_new_folder ? google_folder.autokey_folder[count.index].name : "folders/${var.folder_id}"
  name            = var.autokey_key_project_name
  project_id      = local.autokey_key_project_id
  skip_delete     = var.skip_delete
  depends_on      = [google_folder.autokey_folder]
}



#Set permissions for key admins to use Autokey in this folder
resource "google_folder_iam_binding" "autokey_folder_admin" {
  count   = 1
  folder  = var.create_new_folder ? google_folder.autokey_folder[count.index].name : "folders/${var.folder_id}"
  role    = "roles/cloudkms.autokeyAdmin"
  members = var.autokey_folder_admins
}

#Set permissions for users to protect resources with Autokey in this folder
resource "google_folder_iam_binding" "autokey_folder_users" {
  count   = 1
  folder  = var.create_new_folder ? google_folder.autokey_folder[count.index].name : "folders/${var.folder_id}"
  role    = "roles/cloudkms.autokeyUser"
  members = var.autokey_folder_users
}



# Enable the necessary API services
resource "google_project_service" "autokey_api_service" {
  for_each = toset([
    "cloudkms.googleapis.com",
  ])

  service                    = each.key
  project                    = local.autokey_key_project_id
  disable_on_destroy         = false
  disable_dependent_services = true
  depends_on                 = [google_project.key_project]

}


# Wait delay after enabling APIs
resource "time_sleep" "wait_enable_service_api" {
  depends_on       = [google_project_service.autokey_api_service]
  create_duration  = "30s"
  destroy_duration = "15s"
}


#Create KMS Service Agent
resource "google_project_service_identity" "KMS_Service_Agent" {
  provider   = google-beta
  service    = "cloudkms.googleapis.com"
  project    = local.autokey_key_project_id
  depends_on = [time_sleep.wait_enable_service_api]
}

#Set permissions for key admins and KMS Service Agent the Cloud KMS Admin role
resource "google_project_iam_binding" "autokey_project_admin" {
  count   = 1
  project = local.autokey_key_project_id
  role    = "roles/cloudkms.admin"
  members = local.new_autokey_project_kms_admins
  #["setunion(${var.autokey_project_kms_admins}, serviceAccount:service-${local.autokey_key_project_number}@gcp-sa-cloudkms.iam.gserviceaccount.com)"]
  depends_on = [google_project_service_identity.KMS_Service_Agent]
}




# Wait delay kms service account IAM permissions
resource "time_sleep" "wait_srv_acc_priv" {
  create_duration = "15s"
  #  destroy_duration = "15s"
  depends_on = [google_project_iam_binding.autokey_project_admin]
}

resource "google_kms_autokey_config" "autokey_config" {
  count       = 1
  provider    = google-beta
  folder      = var.create_new_folder ? google_folder.autokey_folder[count.index].folder_id : "${var.folder_id}"
  key_project = "projects/${local.autokey_key_project_number}"
  depends_on  = [time_sleep.wait_srv_acc_priv]
}


# Wait delay for autokey config rollout
resource "time_sleep" "wait_autokey_config" {
  create_duration = "15s"
  #  destroy_duration = "15s"
  depends_on = [google_kms_autokey_config.autokey_config]
}


