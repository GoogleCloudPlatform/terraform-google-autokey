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


output "autokey_config" {
  description = "KMS Autokey config"
  value       = google_kms_autokey_config.autokey_config
}


output "key_project_id" {
  description = "key_project_id"
  value       = data.google_project.key_project.project_id
}

output "resource_project_id" {
  description = "resource_project_id"
  value       = data.google_project.resource_project.project_id
}


output "random_id" {
  description = "random id"
  value       = random_id.random_suffix.hex
}