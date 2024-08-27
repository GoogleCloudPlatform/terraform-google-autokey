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


variable "billing_account" {
  type        = string
  description = "billing account required"
}


variable "organization_id" {
  type        = string
  description = "Organization ID to add tags at Org level"
}

variable "parent_folder_id" {
  description = "Folder ID to create child folder for autokey"
  type        = string
}

variable "parent_is_folder" {
  description = "Folder ID to create child folder for autokey"
  type        = bool
  default     = true ## false to use org_id as parent for autokey resources
}



variable "create_new_folder" {
  description = " If true, the Terraform will create a new folder. If false, will use an existing folder"
  type        = bool
  default     = true ## update to 'false' to use an existing folder
}

variable "folder_id" {
  type        = string
  description = "Resource folders should use KMS Autokey"
  default     = null
}

variable "autokey_folder_name" {
  type        = string
  description = "Resource folders should use KMS Autokey"
  default     = "autokey folder" ## applicable only if creating new folder
}

variable "create_new_autokey_key_project" {
  description = " If true, the Terraform will create a new project for autokey key. If false, will use an existing project"
  type        = bool
  default     = true ## update to 'false' to use an existing project
}

variable "autokey_key_project_name" {
  type        = string
  description = "Project name to deploy resources"
  default     = "autokey-project" # no spaces only aalowed to have characters, numbers and special characters
}

variable "autokey_key_project_id" {
  type        = string
  description = "Project name to deploy resources"
  default     = null
}


variable "skip_delete" {
  description = " If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = "false"
}



variable "autokey_folder_admins" {
  type        = list(string)
  description = "List the users who should have the authority to enable and configure Autokey at a folder level"
}


variable "autokey_folder_users" {
  type        = list(string)
  description = "List the users who should have the authority to protect their resources with Autokey"
}


variable "autokey_project_kms_admins" {
  type        = set(string)
  description = "List the users who should have the authority to manage crypto operations in the Key Management Project"
}
