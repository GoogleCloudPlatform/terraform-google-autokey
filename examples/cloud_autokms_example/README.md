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
  autokms_folder_name            = "autokms folder"                         ## applicable only if creating new folder, otherwise declare null
  create_new_autokms_key_project = true                                     ## set to false to use existing project
  autokms_key_project_name       = "autokms-project"                        ## must be 6 to 30 letters, digits, hyphens and start with a letter.; applicable only if creating new folder, otherwise declare null
  autokms_key_project_id         = ""                                       ## update if using existing project
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autokey\_folder\_admins | List the users who should have the authority to enable and configure Autokey at a folder level | `list(string)` | n/a | yes |
| autokey\_folder\_users | List the users who should have the authority to protect their resources with Autokey | `list(string)` | n/a | yes |
| autokey\_project\_kms\_admins | List the users who should have the authority to manage crypto operations in the Key Management Project | `list(string)` | n/a | yes |
| autokms\_folder\_name | Resource folders should use KMS Autokey | `string` | `"Autokms folder"` | no |
| autokms\_key\_handle\_name | Auto kms key handle name | `string` | n/a | yes |
| autokms\_key\_project\_id | Project name to deploy resources | `string` | `null` | no |
| autokms\_key\_project\_name | Project name to deploy resources | `string` | `"autokms-project"` | no |
| billing\_account | billing account required | `string` | n/a | yes |
| create\_new\_autokms\_key\_project | If true, the Terraform will create a new project for autokms key. If false, will use an existing project | `bool` | `true` | no |
| create\_new\_folder | If true, the Terraform will create a new folder. If false, will use an existing folder | `bool` | `true` | no |
| create\_new\_resource\_project | If true, the Terraform will create a new project for resources. If false, will use an existing project | `bool` | `true` | no |
| folder\_id | Resource folders should use KMS Autokey | `string` | `null` | no |
| organization\_id | Organization ID to add tags at Org level | `string` | n/a | yes |
| parent\_folder\_id | Folder ID to create child folder for autokms | `string` | n/a | yes |
| parent\_is\_folder | Folder ID to create child folder for autokms | `bool` | `true` | no |
| random\_id | Auto generated random id | `string` | n/a | yes |
| region | Network region for resources | `string` | n/a | yes |
| resource\_project\_id | Project id to deploy resources | `string` | `null` | no |
| resource\_project\_name | Project name to deploy resources | `string` | `"resource-project"` | no |
| skip\_delete | If true, the Terraform resource can be deleted without deleting the Project via the Google API. | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| autokey\_config | Auto kms key config |
| key\_project\_id | key\_project\_id |
| my\_key\_handle | my\_key\_handle |
| random\_id | random id |
| region | resources region |
| resource\_project\_id | resource\_project\_id |

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
