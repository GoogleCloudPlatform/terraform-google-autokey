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

## Use the below block to import an existing key handle to your TF state. In case you get an "Error 409: Key handle already exists" 
/*
import {
  to = google_kms_key_handle.gcs_key_handle
  id = "projects/${local.resource_project_id}/locations/us-east1/keyHandles/gcs-auto-key-handle"
}
*/


# Create autokey handle for storage bucket
resource "google_kms_key_handle" "gcs_key_handle" {
  provider               = google-beta
  project                = local.resource_project_id
  name                   = "gcs-auto-key-handle"
  location               = "us-east1"
  resource_type_selector = "storage.googleapis.com/Bucket"
  depends_on = [
    module.autokey,
    time_sleep.wait_enable_service,
  ]
}




# Create storage bucket protected by autokey
resource "google_storage_bucket" "simple_bucket_name" {
  name                        = "simple_bucket_${module.autokey.random_id}"
  location                    = "us-east1"
  force_destroy               = true
  project                     = local.resource_project_id
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_key_handle.gcs_key_handle.kms_key
  }
}
