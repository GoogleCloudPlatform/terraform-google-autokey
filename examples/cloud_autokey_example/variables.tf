/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


##  This code creates PoC example for KMS Autokey ##
##  It is not developed for production workload ##


variable "create_new_resource_project" {
  description = " If true, the Terraform will create a new project for resources. If false, will use an existing project"
  type        = bool
  default     = true ## update to 'false' to use an existing project
}

variable "resource_project_name" {
  type        = string
  description = "Project name to deploy resources"
  default     = "resource-project" # no spaces only aalowed to have characters, numbers and special characters

}

variable "resource_project_id" {
  type        = string
  description = "Project id to deploy resources"
  default     = null
}

variable "skip_delete" {
  description = " If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = "false"
}
