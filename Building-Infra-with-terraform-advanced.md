# Building Infrastructure using Terraform - Advanced.

## Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Sign in to OCI Console and Generate API Keys](#sign-in-to-oci-console-and-generate-api-keys)

[Collecting Tenancy and User information](#collecting-tenancy-and-user-information)

[Preparing Environment for Terraform](#preparing-environment-for-terraform)

[Working with Variables](#working-with-variables)

[Understanding Resource Dependencies](#understanding-resource-dependencies)

[Provisioners](#provisioners)

[Output Variables](#output-variables)

## Overview

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language (HCL), or optionally JSON.

In this Lab we will be going through the advanced concepts of terraform by provisioning resources in Oracle Cloud Infrastructure (OCI).

**Some Key points;**

***Recommended Browsers: Chrome, Edge**

- We recommend using Chrome or Edge as the broswer. Also set your browser zoom to 80%

- All screen shots are examples ONLY. Screen shots can be enlarged by Clicking on them

- Login credentials are provided later in the guide (scroll down). Every User MUST keep these credentials handy.

- Do NOT use compartment name and other data from screen shots.Only use  data(including compartment name) provided in the content section of the lab

- Mac OS Users should use ctrl+C / ctrl+V to copy and paste inside the OCI Console

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

3. Change directory to `PhotonUser` and create a directory `oci`, Enter command: 

```
cd /c/Users/PhotonUser

mkdir ocikeys

cd ocikeys
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta31.PNG?sp=r&st=2020-03-02T01:40:27Z&se=2020-12-31T09:40:27Z&spr=https&sv=2019-02-02&sr=b&sig=cIyIe9xo4nhSedafmqtJHMcwn4jN32yYhUTOnJU3YOY%3D)

4. Now generate API Keys, Enter commands: 
```
openssl genrsa -out oci_api_key.pem 2048 
```
```
openssl rsa -pubout -in oci_api_key.pem -out oci_api_key_public.pem
```                
```
cat oci_api_key_public.pem
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-2.PNG?sp=r&st=2020-02-11T06:03:03Z&se=2021-12-31T14:03:03Z&spr=https&sv=2019-02-02&sr=b&sig=l3gwnenaidXbmB7V3SaYyTNCn4bzTPsG9aOQh4Z7QKg%3D)

5. We have created the API signing key and now we need to generate the fingerprint for your user. 

6. Switch to OCI Console by clicking the Switch Windows button and selecting the Chrome window. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta1.PNG?sp=r&st=2020-02-22T00:44:56Z&se=2021-12-31T08:44:56Z&spr=https&sv=2019-02-02&sr=b&sig=nrRJb7q7VLzFNjVbZ%2BJOVBCW%2Fl04WVVU0CBvjVR5xvo%3D)

7. Click Human icon (top right) and then Click your username. In the user details, Scroll down and Click on **Add Public Key**. Copy the public key generated earlier and paste it. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta2.PNG?sp=r&st=2020-02-22T00:45:38Z&se=2021-12-31T08:45:38Z&spr=https&sv=2019-02-02&sr=b&sig=2rjwWGSgzwnKrVc5ZWY6lOmvJDjOzIGcoxZBCRvDHro%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta32.PNG?sp=r&st=2020-03-02T01:41:26Z&se=2020-12-31T09:41:26Z&spr=https&sv=2019-02-02&sr=b&sig=YbrQ6h0tEyFa7U0EiJBsluDsLxZSSBgecufUes4WESA%3D)

8. Once you upload the public key, the fingerprint is automatically displayed there. It looks something like this:

```
12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta33.PNG?sp=r&st=2020-03-02T01:42:00Z&se=2020-12-31T09:42:00Z&spr=https&sv=2019-02-02&sr=b&sig=v5Oy1iVw7PHaDsi2uKAC3TRJ6wVloI3wIhEBJqVIFMM%3D)

## Collecting Tenancy and User Information

1. In the OCI Console, Click Human icon (top right) and click Tenancy. You should see Tenancy Information Page. Click ```Copy``` to copy the Tenancy OCID. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-4.PNG?sp=r&st=2020-02-11T08:56:25Z&se=2021-12-31T16:56:25Z&spr=https&sv=2019-02-02&sr=b&sig=wf3ZdY%2F5vNhkvacfSQadJkEwpFk%2FmAqdTs5OdzkfCYQ%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-6.PNG?sp=r&st=2020-02-11T08:57:59Z&se=2021-12-31T16:57:59Z&spr=https&sv=2019-02-02&sr=b&sig=CdR%2BhR0KHP3iSQWnuOCQLXpdbJeNClv57rPk7QWi4vY%3D)

2. Click the Apps Icon and open Notepad to paste the Tenancy OCID.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-5.png?sp=r&st=2020-02-11T08:57:13Z&se=2021-12-31T16:57:13Z&spr=https&sv=2019-02-02&sr=b&sig=NyDR%2B1plSu9V8B7coL08ya%2FpC54lhkOfdZCJRTpiOpQ%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta4.PNG?sp=r&st=2020-02-22T00:46:22Z&se=2021-12-31T08:46:22Z&spr=https&sv=2019-02-02&sr=b&sig=NP%2Fll3dl1ZW7irjsquOETqmWTB2oxsTjSUYc76pUP8I%3D)

3. Now Switch to OCI Console and Click Human icon (top right) again and click your username. Under User Information page Click ```Copy``` to copy the User OCID. Switch to Notepad and paste the OCID.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-7.PNG?sp=r&st=2020-02-11T08:59:47Z&se=2021-12-31T16:59:47Z&spr=https&sv=2019-02-02&sr=b&sig=k9uFhcANQeetVXpf7FJVo30OcAg812PzdH9w8hRAxh0%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-8.PNG?sp=r&st=2020-02-11T09:00:27Z&se=2021-12-31T17:00:27Z&spr=https&sv=2019-02-02&sr=b&sig=bcO192%2FMB8wQCshx1nPS4hlSmxFd2Jgkm0ZXG8q%2BYFM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta5.PNG?sp=r&st=2020-02-22T00:46:59Z&se=2021-12-31T08:46:59Z&spr=https&sv=2019-02-02&sr=b&sig=LFyGwJLM9MOrrncxYFdA%2BQI5gMLpIHJ%2FD8yD9hVlrh4%3D)

4. Switch to OCI Console. You should be on the user details page. Scroll Down to see the fingerprint value. Copy and Paste it in Notepad.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta6.PNG?sp=r&st=2020-02-22T00:47:34Z&se=2021-12-31T08:47:34Z&spr=https&sv=2019-02-02&sr=b&sig=4J8hR4g0D9ZxViTjEa0VrYcU6q7zncCsiNns6C11jY8%3D)

5. Now check the region you are logged into in your OCI Console. If you see US East (Ashburn) on the top then switch to Notepad and write down ```region = us-ashburn-1```.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta7.PNG?sp=r&st=2020-02-22T00:48:09Z&se=2021-12-31T08:48:09Z&spr=https&sv=2019-02-02&sr=b&sig=9i7pPE%2FdI6%2BOE061SFcTfJS%2F6ILel%2Fp3B8pCRmOMKRM%3D)

6. Switch to OCI Console. Click on the Menu button and Scroll Down to see ```Identity``` under `Governance and Administration`. Now click on Identity and then Compartments. You should see a list of Compartments.

- Hover over your compartment OCID and click copy. Switch to Notepad and paste it.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta15.PNG?sp=r&st=2020-02-22T00:48:47Z&se=2021-12-31T08:48:47Z&spr=https&sv=2019-02-02&sr=b&sig=74R9fAvw%2Bow8EqZnHR32KFwXMdwm3B%2BTHSS88zoyC70%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta16.PNG?sp=r&st=2020-02-22T00:49:21Z&se=2021-12-31T08:49:21Z&spr=https&sv=2019-02-02&sr=b&sig=EEVfFvp4VhFMqDNXXMt%2B16LOcvA7cA%2BDWIg632tPlqY%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta17.PNG?sp=r&st=2020-02-22T00:50:01Z&se=2021-12-31T08:50:01Z&spr=https&sv=2019-02-02&sr=b&sig=VYz6CSLbteZ3vFEA3v2Ry7yFAPYpIHcq75SU5mFxIr0%3D)

7. Switch to Git-Bash. You should be in the ```oci``` folder. Enter the below command to get the value of the private api key. Copy the value and Paste it in Notepad.

```
cat oci_api_key.pem
``` 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta8.PNG?sp=r&st=2020-02-22T00:50:42Z&se=2021-12-31T08:50:42Z&spr=https&sv=2019-02-02&sr=b&sig=kpmt59l%2FhqMSkHpX1lM389JOCqW1nobXJX8rxSeN0Wo%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta9.PNG?sp=r&st=2020-02-22T00:51:11Z&se=2021-12-31T08:51:11Z&spr=https&sv=2019-02-02&sr=b&sig=g2%2BQFQ6uRX7T44JfeTYpkzRNs0Mp1PDGaI2MntI986k%3D)

## Preparing Environment for Terraform

1. Click on ```Apps Icon``` and Open ```Visual Studio Code```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/oci16.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure6.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

2. Click on Terminal and choose New Terminal to open terminal in Visual Studio Code.  

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure9.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure7.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


3. Create a directory named ```terraformOCI``` by excuting the below command in Visual Studio Code

```
mkdir terraformOCI

cd terraformOCI
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/oci11.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)  

4. On top left corner, click on `File` and choose `Open Folder`

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/2.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

5. You will be navigated to `/PhotonUser` directory where terraformOCI folder is created. Select `terraformOCI` and click on `Select Folder`.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/oci13.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)  

6. Now `terraformOCI` folder is opened in Visual Studio Code.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta10.PNG?sp=r&st=2020-02-22T00:51:43Z&se=2021-12-31T08:51:43Z&spr=https&sv=2019-02-02&sr=b&sig=VUBLfi2SDA3%2Be6twi9%2BKeBLB8%2B%2Bs8WOKyjasj18rXhc%3D)

- In the course of this Lab for coming sections we will be understanding the concepts of Terraform with the help of some terraform configuration snippets. 

- These configurations will help us deploy a Virtual Machine, VCN in a compartment and run some shell scripts.

## Working with Variables

- We can create infrastructure by hard-coding values to the parameters of the resources but this can be avoided and we can parameterize our resources by referencing variables in our configurations. In this section we will learn to work with variables.

1. Defining Variables

- Let us create a New file called ```variables.tf``` in Visual Studio Code under the folder ```terraformOCI``` by clicking on the `New File` symbol present beside the folder name and try to reference the `region` as a variable. Add this snippet to contents of the variables.tf file.

```
variable "region" {
  default = "us-ashburn-1"
}
```
- Once the Copy is done, Save the file by Clicking on File option ans then Save.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta11.PNG?sp=r&st=2020-02-22T00:53:09Z&se=2021-12-31T08:53:09Z&spr=https&sv=2019-02-02&sr=b&sig=akrVUUP08WKnT38iU7pZt%2F6XcTUx2iYyChozPDBVyFE%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta12.PNG?sp=r&st=2020-02-22T00:53:42Z&se=2021-12-31T08:53:42Z&spr=https&sv=2019-02-02&sr=b&sig=6cj1JaR%2BtT82grAA%2BDj%2BO1acT661eKS%2BfeuvkJF5FUI%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta13.PNG?sp=r&st=2020-02-22T00:54:10Z&se=2021-12-31T08:54:10Z&spr=https&sv=2019-02-02&sr=b&sig=pKKaZaPz9YE0xG%2BgFqpzQMzWf3GCP5xMK9RcnlbBmNQ%3D)

- Similarly, you can create variables for all the static values used for configurations. In the below snippet, a list of variables are defined that are needed for configurations in coming sections. Add these variables in the `variables.tf` file and **Save** it. 

```
variable "tenancy_ocid" {
  default = ""
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "private_key_path" {
  default = "./private-key"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0nysWs1m+sdoaK15mMIvLEiN+ofDhi9qNEXbPby+a76cJl4zD26P3cErUjE2HVLizuLoec5XzrcKLOz53/0f9hulwZRzapsbIZlPDLBoL+HcuqRyD23YMf6ETg780E3cKZvDVtVCKZg0R2H8QGs9yrnKHt0zhXp6FwKuinfVvMhY3rOM23bYRoI3Y4WiREMSDWLkNTXxAJqUPtcxPVVU388OpWznAsEYiioiwt/KsNU1MECpcK93vihdUMJ15GamPptplS+0Bu1nmYHOvkp9UHEsq+SNKw57sO8S2dgJtpDmT3Hyth8ZvgW+pYOEGAD7PwxFfUm2km/XuRUDF7HfB computekey"
}

variable "ssh_private_key" {
  default = "./ckey"
}


variable "AD" {
  default = "1"
}

variable "InstanceShape" {
  default = "VM.Standard1.1"
}

variable "InstanceImageOCID" {  
  default = "ocid1.image.oc1.iad.aaaaaaaamspvs3amw74gzpux4tmn6gx4okfbe3lbf5ukeheed6va67usq7qq"
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta14.PNG?sp=r&st=2020-02-22T00:54:44Z&se=2021-12-31T08:54:44Z&spr=https&sv=2019-02-02&sr=b&sig=7a3M3s9zyjdYDhdUObtgzxuiVAZAS0ymQywKxF3wOpY%3D)

- After copying the above variables provide the missing values for tenancy_ocid, user_ocid, compartment_ocid and fingerprint from Section 2 and **Save** the file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta18.PNG?sp=r&st=2020-02-22T00:55:32Z&se=2021-12-31T08:55:32Z&spr=https&sv=2019-02-02&sr=b&sig=M%2Fv4MxQbqMu%2Fc3fXZRa%2FtPKUgQEhMo1UDDE8GBF15JU%3D)

2. Using Variables in configurations

- Create a new fle caleed `provider.tf` and copy the below code into file and **Save** it. The variables defined earlier in the variables.tf file are now being refrenced in the provider.tf file. 

```
provider "oci" {
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "${var.region}"
  disable_auto_retries = "true"
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta19.PNG?sp=r&st=2020-02-22T00:56:14Z&se=2021-12-31T08:56:14Z&spr=https&sv=2019-02-02&sr=b&sig=BJmX75KWuebwRiU7q0WH3bM0nK3Goe1NFmQOY03x%2FcE%3D)

- Using the above concept we can define new variables and refer them in other configuration files as needed.

3. Assigning Variables 

- There are multiple ways in which we can assign variables. Below is the order in which variable values are chosen.

i. Command-line flags

- You can set variables directly on the command-line with the ```-var``` flag. Any command in Terraform that inspects the configuration accepts this flag, such as apply, plan, and refresh:

```
terraform apply -var 'region=us-ashburn-1'
```

ii. From a file

- To persist varibales, we can create a file and then define the values in this file. Create a file named terraform.tfvars with the following contents: 

```
region = "us-ashburn-1"
```
- For all files which match `terraform.tfvars` or `*.auto.tfvars` present in the current directory, Terraform automatically loads them to populate variables. If the file is named something else, you can use the -var-file flag directly to specify a file. 

iii. From Environment variables 

- Terraform will read environment variables in the form of `TF_VAR_name` to find the value for a variable. For example, the TF_VAR_region variable can be set to set the region variable.

```
TF_VAR_region = "us-ashburn-1"
```

iv. UI Input

- If you execute terraform apply with certain variables unspecified, Terraform will ask you to input their values interactively. These values are not saved, but this provides a convenient workflow when getting started with Terraform. 

- Note: UI input is not recommended for everyday use of Terraform.

v. Variable Defaults

- If no value is assigned to a variable via any of these methods and the variable has a default key in its declaration, that value will be used for the variable.

vi. Lists 

- Lists can be defined implicitly or either explicitly. You can specify lists in a terraform.tfvars file as well.

```
cidrs = [ "10.0.0.0/16", "10.1.0.0/16" ]
```
v. Maps 

- Maps can be used to define variables that are bound to a particular value. In our case, the image OCIDs that we use for our instances are specific to a particular region. It will be difficult for a user to replace the ocid to keep up with different regions.

- Maps are a way to create variables that are lookup tables. Let us look at the example below: 

```
variable "InstanceImageOCID" {
  type = "map"

  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaav4gjc4l232wx5g5drypbuiu375lemgdgnc7zg2wrdfmmtbtyrc5q"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaautkmgjebjmwym5i6lvlpqfzlzagvg5szedggdrbp6rcjcso3e4kq"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt1.aaaaaaaajdge4yzm5j7ci7ryzte7f3qgcekljjw7p6nexhnsvwt6hoybcu3q"
  }
}
```

- The variables declared as maps can be referenced as shown below

```
image = "${var.InstanceImageOCID[var.region]}"
```

- The image parameter gets the value of the ocid depending upon the value of the region specified.

- **In this lab we will use varible defaults method to assign our variables.***


## Understanding Resource Dependencies

- In this section we will understand resource dependencies within Terraform and also a scenario where resource parameters use information from other resources. 

- Provisioning infrastructure involves a diverse set of resources and resource types which depend on each other. Terraform configurations can contain multiple resources, multiple resource types, and these types can even span multiple providers. 

- In Terraform there are two types of dependencies, namely ```Implicit``` and ```Explicit``` dependencies. 

1. Implicit dependencies 

- In the below example, we are trying to create a Virtual Cloud Network (VCN) and its associated resources like Subnet, Route Table and an Internet gateway. 

```
resource "oci_core_virtual_network" "ExampleVCN" {
  cidr_block = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFExampleVCN"
  dns_label = "tfexamplevcn"
}

resource "oci_core_subnet" "ExampleSubnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block = "10.1.20.0/24"
  display_name = "TFExampleSubnet"
  dns_label = "tfexamplesubnet"
  security_list_ids = ["${oci_core_virtual_network.ExampleVCN.default_security_list_id}"]
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.ExampleVCN.id}"
  route_table_id = "${oci_core_route_table.ExampleRT.id}"
  dhcp_options_id = "${oci_core_virtual_network.ExampleVCN.default_dhcp_options_id}"
}

resource "oci_core_internet_gateway" "ExampleIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFExampleIG"
  vcn_id = "${oci_core_virtual_network.ExampleVCN.id}"
}

resource "oci_core_route_table" "ExampleRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.ExampleVCN.id}"
  display_name = "TFExampleRouteTable"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.ExampleIG.id}"
  }
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}
```

- Switch to Visual Studio Code, you should be in the `terraformOCI` folder. Create a file named `network.tf`, copy the above snippet and **Save** it.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta20.PNG?sp=r&st=2020-02-22T00:56:57Z&se=2021-12-31T08:56:57Z&spr=https&sv=2019-02-02&sr=b&sig=BU8Ce5NstqthrBPSjtPU8Ma1wx63w8y4sCXsF%2Bl40CY%3D)

- Also create another filed called `private-key` and paste the value of `private key` from Notepad.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta21.PNG?sp=r&st=2020-02-22T00:57:27Z&se=2021-12-31T08:57:27Z&spr=https&sv=2019-02-02&sr=b&sig=WEbbyTCf4hM41rtpPZ6pRnhdJ%2BBK%2FiDm7BuLXgxqBYo%3D)

- Now Select Terminal and click on New Terminal. A terminal window opens and you should be in the D:\PhotonUser\terraformOCI path. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta22.PNG?sp=r&st=2020-02-22T00:57:55Z&se=2021-12-31T08:57:55Z&spr=https&sv=2019-02-02&sr=b&sig=rMwGZR6kMjnjircbmAtjG6lK2d%2BvQdThWc2Pqil0ewg%3D)

- Run the ```terraform init``` and ```terraform apply``` commands to create the resources. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta23.PNG?sp=r&st=2020-02-22T00:58:27Z&se=2021-12-31T08:58:27Z&spr=https&sv=2019-02-02&sr=b&sig=2TljPlGRClk7%2FRyKgmAr4QF2xFrK5iqud75DWtt45T8%3D)

- Answer ```yes``` when prompted, terraform starts creating the resources. As you can see, terraform creates four resources namely ExampleVCN, ExampleIG, ExampleRT and ExampleSubnet. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta24.PNG?sp=r&st=2020-02-22T00:58:55Z&se=2021-12-31T08:58:55Z&spr=https&sv=2019-02-02&sr=b&sig=NaUPOERDH8S3R5Cles3IEqYRkaPrriy%2F6%2FR%2BirGoPEE%3D)

- As shown above, Terraform created ExampleVCN before creating the other resources. Due to the interpolation expression that passes the ID of the VCN to Internet Gateway, Route Table and Subnet, Terraform is able to infer a dependency, and knows it must create the VCN first and then others. 

- Due to these dependencies Terraform can automatically infer when one resource depends on another. In the example above, the reference to oci_core_virtual_network.ExampleVCN.id creates an implicit dependency on the ExampleVCN resource.

- Terraform uses this dependency information to determine the correct order in which to create the different resources. In the above example, Terraform knows that the ```oci_core_virtual_network``` must be created before the ```oci_core_internet_gateway```.

- Implicit dependencies via interpolation expressions are the primary way to inform Terraform about these relationships, and should be used whenever possible.

2. Explicit Dependencies

- Sometimes there are dependencies between resources that are not visible to Terraform. The ```depends_on``` argument is accepted by any resource and accepts a list of resources to create explicit dependencies for.

- In cases where an application might reside in a storage bucket and an instance expects to use it, the dependency is not visible to terraform. In such cases, the depends_on parameter is used to explicitly depend upon another resource. 

- In the below snippet, terraform tries to create an Instance but due to the `depends_on` parameter it waits until object storage bucket is created first.

```
resource "oci_core_instance" "TFInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TFInstance"
  image               = "${var.InstanceImageOCID[var.region]}"
  shape               = "${var.InstanceShape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.ExampleSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tfexampleinstance"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
    #user_data           = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }

  depends_on = ["oci_objectstorage_bucket.ExampleBucket"]
}
```

## Provisioners 

- So far we have learned to create variables and define dependencies within infrastructure, but now let us see how we can initialize our virtual instances when they are created. 

- Along with creating infrastructure we also need to do some initial setup on our instances, provisioners let us upload files, run shell scripts, or install and trigger other software. 

- There are various provisioners provided by Terraform but we will discuss few of them here like local-exec, remote-exec and file provisioners.

1. File Provisioner 

- The file provisioner is used to copy files or directories from the machine executing Terraform to the newly created resource. The file provisioner supports both `ssh` and `winrm` type connections.

2. remote-exec provisioner

- The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. Remote-exec provisioner also supports both `ssh` and `winrm` type connections.

- To illustrate the example of provisioners we need to create an instance first. So Open Visual Studio Code and create a file named ```compute.tf```

- Copy the below code and **Save** the file.

```
resource "oci_core_instance" "TFInstance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TFInstance"
  image               = "${var.InstanceImageOCID}"
  shape               = "${var.InstanceShape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.ExampleSubnet.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "tfexampleinstance"
  }

  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
    
  }

  timeouts {
    create = "15m"
  }
}

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta25.PNG?sp=r&st=2020-02-22T00:59:36Z&se=2021-12-31T08:59:36Z&spr=https&sv=2019-02-02&sr=b&sig=1Tazt%2B%2Bat2QcjUK41NFljP5LUhokIKRpyKcqFhzHYB8%3D)

```
- After creating compute.tf file run the below command in Terminal window to download the ssh private key for the instance in `terraformOCI` folder. 

```
curl "https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/ckey?sp=r&st=2020-02-11T23:40:23Z&se=2022-01-01T07:40:23Z&spr=https&sv=2019-02-02&sr=b&sig=pKQqknoxzn2Xy2Svv%2Bn%2BMJcudaUuSWEso9tm3q81xhY%3D" -o ckey
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta26.PNG?sp=r&st=2020-02-22T01:00:04Z&se=2021-12-31T09:00:04Z&spr=https&sv=2019-02-02&sr=b&sig=uofEwldieHiSTIk01xXbS5fZrhbhkZWOdwdlJ9F6OjM%3D)

- Now let us create a file named provisioners.tf. Copy the below code and **Save** the file. 

```
resource "null_resource" "provisioner" {
    depends_on = ["oci_core_instance.TFInstance"]
    provisioner "file" {
        connection {
            agent = false
            timeout = "10m"
            host = "${oci_core_instance.TFInstance.public_ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key)}"
        }
        source = "./bootstrap.sh"
        destination = "~/bootstrap.sh"
    }    
    
    provisioner "remote-exec" {
        connection {
            agent = false
            timeout = "10m"
            host = "${oci_core_instance.TFInstance.public_ip}"
            user = "opc"
            private_key = "${file(var.ssh_private_key)}"
        }
        inline = [
            "chmod +x ~/bootstrap.sh",            
            "sudo ~/bootstrap.sh",
        ]
    }
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta28.PNG?sp=r&st=2020-02-22T01:01:29Z&se=2021-12-31T09:01:29Z&spr=https&sv=2019-02-02&sr=b&sig=gZOvW%2B0dfi%2BylM9YzIApdHjIN6iefTNhVQQZjkIMcMs%3D)

- Along with the provisioners.tf file you also need to create another file called ```bootstrap.sh```. We will be using this file to copy it from local onto the TFInstance resource and then execute it.

- Copy the below code in the `bootstrap.sh` file and then **Save** it.

```
yum update -y
yum install -y httpd
systemctl enable  httpd.service
systemctl start  httpd.service
firewall-offline-cmd --add-service=http
systemctl enable  firewalld
systemctl restart  firewalld
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta29.PNG?sp=r&st=2020-02-22T01:02:25Z&se=2021-12-31T09:02:25Z&spr=https&sv=2019-02-02&sr=b&sig=L6hmmJzDwCHegBQr79ji2Lcdba2Ttm65jQ7ArGfxU0o%3D)

- If you check your terraformOCI folder, you should see three additional files created namely, compute.tf, provisioner.tf and bootstrap.sh. 

- Now run the ```terraform init``` and ```terraform apply``` commands to create resources. Answer ```yes``` when prompted, terraform starts creating the resources.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta30.PNG?sp=r&st=2020-02-26T04:57:18Z&se=2020-12-31T12:57:18Z&spr=https&sv=2019-02-02&sr=b&sig=GdXdv9Yd8Puj%2BB10Aaee2JQBvX0QRlApD6ca2OR792Q%3D)

- As you can see the `TFInstance` gets created first and then the provisioners. File provisioner copies the shell script from terraformOCI folder onto the TFInstance and remote-exec provisioner runs the script on the machine. 

- As a result of running provisioners, we were able to copy the script to an instance and then install the `httpd` package on the machine and start the service.

3. local-exec provisioner

- The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource. 



## Output Variables

- In the earlier sections, we learned how to declare input variables inorder to parameterize Terraform configurations, also learn about various dependencies within resources and running provisioners to execute scripts on the resource. 

- In this section, we will learn to output values as a way to organize data that can be easily queried and shown back to the Terraform user.

- Building infrastructure involves working with various resources and Terraform stores hundreds of attribute values for all the resources. But as a user we only need few important details regarding resources such as Public IP address of the Instance, CIDR block of VPC etc.

1. Defining Outputs 

- Please see the example below to define an output variable. It shows us a way to output the Public IP of the Instance back to the user.

```
output "InstancePublicIP" {
  value = ["${data.oci_core_vnic.InstanceVnic.public_ip_address}"]
}
```

- This defines an output variable named "InstancePublicIP". The value field specifies what the value will be, and almost always contains one or more interpolations, since the output data is typically dynamic. In this case, we're outputting the public_ip_address attribute of the Instance.

- Now create a file called ```outputs.tf``` in terraformOCI folder. Copy the below snippet in the file and then Save it.

```
output "InstancePrivateIP" {
  value = ["${oci_core_instance.TFInstance.public_ip}"]
}

output "InstancePublicIP" {
  value = ["${oci_core_instance.TFInstance.private_ip}"]
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta34.PNG?sp=r&st=2020-03-02T04:34:58Z&se=2020-12-31T12:34:58Z&spr=https&sv=2019-02-02&sr=b&sig=34DD%2BsAiSJvRIx%2F3oiFbX%2Fzf2lq055%2FPKJPjkJMKlyo%3D)

- Run ```terraform apply``` command to view the outputs. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta35.PNG?sp=r&st=2020-03-02T04:35:40Z&se=2020-12-31T12:35:40Z&spr=https&sv=2019-02-02&sr=b&sig=SvauwW0RgTOh5kQ55s3E6gVbVNGN8yEKRCZREBx82sE%3D)

- Multiple output variables can be defined to retrieve values as per requirement.

- This completes provisioning all of the resources for this lab. Now run ```terraform destroy``` to tear down the running infrastructure.





