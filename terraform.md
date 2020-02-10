# Building Infrastructure using Terraform.

## Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Sign in to OCI Console and Generate API Keys](#sign-in-to-oci-console-and-generate-api-keys)

[Collecting Tenancy and User information](#collecting-tenancy-and-user-information)

[Installing Terraform](#installing-terraform)

[Building Templates in OCI](#building-templates-in-oci)

[Install Kubectl, OCI CLI and configure OCI CLI](#install-kubectl,-oci-cli-and-configure-oci-cli)

[Delete the resources](#delete-the-resources)

## Overview

Oracle Cloud Infrastructure Container Engine for Kubernetes is a fully-managed, scalable, and highly available service that you can use to deploy your containerized applications to the cloud. Use Container Engine for Kubernetes (sometimes abbreviated to just OKE) when your development team wants to reliably build, deploy, and manage cloud-native applications. You specify the compute resources that your applications require, and Container Engine for Kubernetes provisions them on Oracle Cloud Infrastructure in an existing OCI tenancy.

**Some Key points;**

***Recommended Browsers: Chrome, Edge**

- We recommend using Chrome or Edge as the broswer. Also set your browser zoom to 80%

- All screen shots are examples ONLY. Screen shots can be enlarged by Clicking on them

- Login credentials are provided later in the guide (scroll down). Every User MUST keep these credentials handy.

- Do NOT use compartment name and other data from screen shots.Only use  data(including compartment name) provided in the content section of the lab

- Mac OS Users should use ctrl+C / ctrl+V to copy and paste inside the OCI Console

- Login credentials are provided later in the guide (scroll down). Every User MUST keep these credentials handy.

**Cloud Tenant Name**
**User Name**
**Password**
**Compartment Name (Provided Later)**

**Note:** OCI UI is being updated thus some screenshots in the instructions might be different than actual UI

## Pre-Requisites

1. OCI Training : https://cloud.oracle.com/en_US/iaas/training

2. Familiarity with OCI console: https://docs.us-phoenix-1.oraclecloud.com/Content/GSG/Concepts/console.htm

3. Overview of Networking: https://docs.us-phoenix-1.oraclecloud.com/Content/Network/Concepts/overview.htm

4. Familiarity with Compartments: https://docs.us-phoenix-1.oraclecloud.com/Content/GSG/Concepts/concepts.htm

5. Connecting to a compute instance: https://docs.us-phoenix-1.oraclecloud.com/Content/Compute/Tasks/accessinginstance.htm



## Sign in to OCI Console and Generate API Keys

* **Tenant Name:** {{Cloud Tenant}}
* **User Name:** {{User Name}}
* **Password:** {{Password}}
* **Compartment:**{{Compartment}}


1. Sign in using your tenant name, user name and password. Use the login option under **Oracle Cloud Infrastructure**

<img src="https://raw.githubusercontent.com/oracle/learning-library/master/oci-library/qloudable/Grafana/img/Grafana_015.PNG" alt="image-alt-text">

2. Click the Apps icon in the toolbar and select Git-Bash to open a terminal window.

<img src="https://raw.githubusercontent.com/oracle/learning-library/master/oci-library/qloudable/OCI_Quick_Start/img/RESERVEDIP_HOL006.PNG" alt="image-alt-text">

3. Change directory to .oci, Enter command: 
```
cd ~/.oci
```

4. Generate API Keys, Enter commands: 
```
openssl genrsa -out oci_api_key.pem 2048 
```
```
openssl rsa -pubout -in oci_api_key.pem -out oci_api_key_public.pem
```                
```
cat oci_api_key_public.pem
```

5. Now we have created the API signing key and we need to generate the fingerprint for your user. 

6. Switch to OCI Console and Click Human icon (top right) and then Click your username. In the user details, Click **Add Public Key**. Copy the public key generated earlier and paste it. 

insert picture

7. Once you upload the public key, the fingerprint is automatically displayed there. It looks something like this: ```12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef```

Insert picture

## Collecting Tenancy and User Information

1. Switch to OCI Console and Click Human icon (top right) and click Tenancy. You should see Tenancy Information Page. Click ```Copy``` to copy the Tenancy OCID. Switch to Notepad and paste the OCID.

2. Switch to OCI Console and Click Human icon (top right) and click your username. Under User Information page Click ```Copy``` to copy the User OCID. Switch to Notepad and paste the OCID.

3. In the same page under API Keys copy the fingerprint value and paste it in the Notepad. 

4. Now check which region you are logged into. If you see US East (Ashburn) on the top then switch to Notepad and write down ```region = us-ashburn-1```.

5. Switch to Git Bash window and change the directory to ```.oci``` by entering command:
```
cd ~/.oci
```

6. Copy the Private key value and paste it in the Notepad. 
```
cat oci_api_key.pem
```


## Installing Terraform

1. To install Terraform, execute the following steps:

- In this environment Terraform is already installed for your convenience. To install Terraform locally, find the appropriate package for your system and download it. You can download terraform from the following URL 

```
https://www.terraform.io/downloads.html
```

- Terraform is packaged as a zip archive so after downloading Terraform, unzip the package. Terraform runs as a single binary called ```terraform```. 

- The final step is to add this binary in your system ```PATH```.

2. Verifying the Installation 

- Once the ```terraform``` binary has been added to PATH, execute the terraform command in your local terminal. You should see the help output similar to as shown in the below picture: 

insert picture

## Building Templates in OCI

- The set of files used to describe infrastructure in Terraform is known as Terraform Configuration. In this section we will learn to write the various configuration files in terraform.

1. **Provider Section** 

- The Provider block is used to specify a particular provider like ```oci``` , ```aws``` or ```azure```. A provider is responsible for creating and managing resources. You can also provide multiple provider blocks in a terraform configuration.

```

provider "oci" {
  tenancy_ocid = ""
  user_ocid = ""
  fingerprint = ""
  private_key_path = ""
  region = ""
  disable_auto_retries = "false"
}
```
2. **Resource Section**

- The Resource Block defines a resource that exists within the infrastructure. A resource can a virtual machine or block volume or a virtual network.

- The resource block has two strings before opening the block: resource type and resource name. In the below example "oci_core_virtual_network" is the resource type and "ExampleVCN" is the resource name.

```
resource "oci_core_virtual_network" "ExampleVCN" {
  cidr_block = "10.1.0.0/16"
  compartment_id = ""
  display_name = "TFExampleVCN"
  dns_label = "tfexamplevcn"
}
```
- This will create a virtual cloud network in your OCI Tenancy.

## Initialization 

- The very first which is run after building templates is the ```terraform init``` command. This command initializes Terraform in the current working directory and various local settings and data that will be used by subsequent commands.

1. Run the command terraform init command to initialize the environment. 

```
terraform init
```
After initializing the environment, we can run other commands to provision resources in OCI. 

2. Now run the plan command. This command generates an execution plan for the configuration files and then determines what actions are necessary to achieve the desired state. 

```
terraform plan 
```

3. Now run the apply command. This command will Apply changes to the configuration files and provision the resources. 

```
terraform apply
```

If terraform apply failed with an error, read the error message and fix the error that occurred. At this stage, it is likely to be a syntax error in the configuration.

If the plan was created successfully, Terraform will now pause and wait for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure. In this case the plan looks acceptable, so type yes at the confirmation prompt to proceed.



Executing the plan will take few minutes until the provisioning of resources is complete. You can now check the resources in the compartment in the OCI Console.










