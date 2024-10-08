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





# Configure Cloud KMS Autokey
module "autokey" {
  #  source                              = "GoogleCloudPlatform/autokey/google"
  source                         = "../../"
  billing_account                = ""
  organization_id                = ""
  parent_folder_id               = ""                            ## update folder_id
  parent_is_folder               = false                         ## set to 'false' to use org as parent
  create_new_folder              = true                          ## set to false to use existing folder
  folder_id                      = ""                            ## provide folder_id if using existing folder
  autokey_folder_name            = "autokey folder"              ## applicable only if creating new folder, otherwise declare null
  create_new_autokey_key_project = true                          ## set to false to use existing project
  autokey_key_project_name       = "autokey-project"             ## must be 6 to 30 letters, digits, hyphens and start with a letter.; applicable only if creating new folder, otherwise declare null
  autokey_key_project_id         = ""                            ## update if using existing project
  create_new_resource_project    = true                          ## update to 'false' to use an existing project
  resource_project_name          = "resource-project"            ## must be 6 to 30 letters, digits, hyphens and start with a letter.; applicable only if creating new folder, otherwise declare null
  resource_project_id            = ""                            ## update project_id if using existing project
  autokey_folder_admins          = ["user:foo@example.com"]      ## List the users who should have the authority to enable and configure Autokey at a folder level;  example user listing ["user:foo@example.com", "user:bar@example.com"]
  autokey_folder_users           = ["user:user:bar@example.com"] ## List the users who should have the authority to protect their resources with Autokey;  example user listing ["user:foo@example.com", "user:bar@example.com"]
  autokey_project_kms_admins     = ["user:user:bar@example.com"] ## List the users who should have the authority to manage crypto operations in the Key Management Project; example user listing ["user:foo@example.com", "user:bar@example.com"]
  region                         = "us-central1"
}

