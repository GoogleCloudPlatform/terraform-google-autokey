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

##  This code creates PoC example for KMS Autokey ##
##  It is not developed for production workload ##



# Enable the necessary API service
resource "google_project_service" "compute_project_api_service" {
  for_each = toset([
    "compute.googleapis.com",
  ])

  service                    = each.key
  project                    = local.resource_project_id
  disable_on_destroy         = false
  disable_dependent_services = true
  depends_on = [
    module.autokey,
    google_project.resource_project,
  ]
}


# Wait delay after enabling API
resource "time_sleep" "wait_enable_service_api_compute" {
  depends_on       = [google_project_service.compute_project_api_service]
  create_duration  = "15s"
  destroy_duration = "15s"
}

## Use the below block to import an existing key handle to your TF state. In case you get an "Error 409: Key handle already exists" 
/*
import {
  to = google_kms_key_handle.disk_key_handle
  id = "projects/${local.resource_project_id}/locations/us-west1/keyHandles/disk-auto-key-handle"
}
*/



# Create autokey handle for compute disk 
resource "google_kms_key_handle" "disk_key_handle" {
  provider               = google-beta
  project                = local.resource_project_id
  name                   = "disk-auto-key-handle"
  location               = "us-west1"
  resource_type_selector = "compute.googleapis.com/Disk"
  depends_on = [
    module.autokey,
    google_project_service.compute_project_api_service
  ]
}


# Create compute disk protected by autokey
resource "google_compute_disk" "persistant_disk" {
  project                   = local.resource_project_id
  name                      = "persistant-disk"
  type                      = "pd-ssd"
  zone                      = "us-west1-a"
  size                      = 30
  physical_block_size_bytes = 4096
  disk_encryption_key {
    kms_key_self_link = google_kms_key_handle.disk_key_handle.kms_key
  }
  depends_on = [time_sleep.wait_enable_service_api_compute]
}

