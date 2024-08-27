# Cloud Auto KMS Terraform Module
Autokey simplifies creating and managing customer encryption keys (CMEK) by automating provisioning and assignment.  With Autokey, your key rings, keys, and service accounts do not need to be pre-planned and provisioned. Instead, they are generated on demand as part of resource creation. This module makes it easy to set up [Auto KMS](https://LINK-TO-BE-UPDATED).

How to set up KMS Autokey:
- Choose an existing folder or create a new  resource folder.  You will be creating resource projects in this folder.  All of the resources created in these projects can use Autokey.
- Choose the parent for the resource folder, either it can be root of the organization or any existing folder
- Enable Cloud KMS API in the Autokey project.
- Create and assign the Autokey service agent. 
- Associate the Autokey folder with the Key project, through an Autokey configuration setting.
- The Auto key is ready to be used in resource projects.

##  Usage

```tf
# Configure Cloud KMS Autokey
module "autokey" {
  #  source                              = "GoogleCloudPlatform/autokey/google"
  source                         = "../../"
  billing_account                = ""
  organization_id                = ""
  parent_folder_id               = ""                                       # update folder_id
  parent_is_folder               = false                                    ## set to 'false' to use org as parent
  create_new_folder              = true                                     ## set to false to use existing folder
  folder_id                      = ""                                       ## provide folder_id if using existing folder
  autokey_folder_name            = "autokey folder"                         ## applicable only if creating new folder, otherwise declare null
  create_new_autokey_key_project = true                                     ## set to false to use existing project
  autokey_key_project_name       = "autokey-project"                        ## must be 6 to 30 letters, digits, hyphens and start with a letter.; applicable only if creating new folder, otherwise declare null
  autokey_key_project_id         = ""                                       ## update if using existing project
  create_new_resource_project    = true                                     ## update to 'false' to use an existing project
  resource_project_name          = "resource-project"                       ## must be 6 to 30 letters, digits, hyphens and start with a letter.; applicable only if creating new folder, otherwise declare null
  resource_project_id            = ""                                       ## update project_id if using existing project
  autokey_folder_admins          = ["user:foo@example.com"] ## List the users who should have the authority to enable and configure Autokey at a folder level;  example user listing ["user:foo@example.com", "user:bar@example.com"]
  autokey_folder_users           = ["user:user:bar@example.com"] ## List the users who should have the authority to protect their resources with Autokey;  example user listing ["user:foo@example.com", "user:bar@example.com"]
  autokey_project_kms_admins     = ["user:user:bar@example.com"] ## List the users who should have the authority to manage crypto operations in the Key Management Project; example user listing ["user:foo@example.com", "user:bar@example.com"]
  region                         = "us-central1"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

No inputs.

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.53

### Service Account and User Permissions

A service account with the following roles must be used to provision
the resources of this module:

- KMS Service Agent : `roles/cloudkms.admin`
- Key admins to use Autokey at folder level: `roles/cloudkms.autokeyAdmin`
- key admins to use Autokey in this project: `roles/cloudkms.admin`
- Users to protect resources with Autokey: `roles/cloudkms.autokeyUser`


The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Cloud KMS API: `cloudkms.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
