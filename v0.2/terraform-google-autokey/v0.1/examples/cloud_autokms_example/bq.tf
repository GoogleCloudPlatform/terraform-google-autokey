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
resource "google_project_service" "bq_project_api_service" {
  for_each = toset([
    "bigquery.googleapis.com",
  ])

  service                    = each.key
  project                    = module.autokey.resource_project_id
  disable_on_destroy         = false
  disable_dependent_services = true
  depends_on                 = [module.autokey]
}


# Wait delay after enabling APIs
resource "time_sleep" "wait_enable_service_api_bq" {
  depends_on      = [google_project_service.bq_project_api_service]
  create_duration = "15s"
  #  destroy_duration = "15s"
}


# Create autokey handle for BQ dataset
resource "google_kms_key_handle" "bq_key_handle" {
  provider               = google-private
  project                = module.autokey.resource_project_id
  name                   = "bq-auto-key-handle"
  location               = module.autokey.region
  resource_type_selector = "bigquery.googleapis.com/Dataset"
  depends_on = [
    module.autokey,
    google_project_service.bq_project_api_service
  ]
}



# Create dataset in bigquery protected by autokey
resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = "dataset_${module.autokey.random_id}"
  location                   = module.autokey.region
  project                    = module.autokey.resource_project_id
  delete_contents_on_destroy = true
  default_encryption_configuration {
    kms_key_name = google_kms_key_handle.bq_key_handle.kms_key
  }

  depends_on = [
    time_sleep.wait_enable_service_api_bq,
  ]
}





# Create table in bigquery
resource "google_bigquery_table" "clear_table" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  project             = module.autokey.resource_project_id
  table_id            = "clear-data"
  description         = "This table contain clear dummy text sensitive data"
  deletion_protection = false
  depends_on          = [google_bigquery_dataset.dataset]
}