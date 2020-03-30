# Building Infrastructure using Terraform - Modules.

## Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Sign in to OCI Console and Generate API Keys](#sign-in-to-oci-console-and-generate-api-keys)

[Collecting Tenancy and User information](#collecting-tenancy-and-user-information)

[Preparing Environment for Terraform](#preparing-environment-for-terraform)

[Working with Modules](#working-with-modules)

[Changing Configuration in Modules](#changing-configuration-in-modules)

[Deleting the resources](#deleting-the-resources)

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
```
```
mkdir ocikeys
```
```
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

5. We have created the API signing key and now we need to generate the fingerprint for your user account. 

6. Switch to OCI Console by clicking the Switch Windows button and selecting the Chrome window. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta1.PNG?sp=r&st=2020-02-22T00:44:56Z&se=2021-12-31T08:44:56Z&spr=https&sv=2019-02-02&sr=b&sig=nrRJb7q7VLzFNjVbZ%2BJOVBCW%2Fl04WVVU0CBvjVR5xvo%3D)

7. Click Human icon (top right) and then Click your username. In the user details, Scroll down and Click on **Add Public Key**. Copy the public key generated earlier and paste it. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta2.PNG?sp=r&st=2020-02-22T00:45:38Z&se=2021-12-31T08:45:38Z&spr=https&sv=2019-02-02&sr=b&sig=2rjwWGSgzwnKrVc5ZWY6lOmvJDjOzIGcoxZBCRvDHro%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta32.PNG?sp=r&st=2020-03-02T01:41:26Z&se=2020-12-31T09:41:26Z&spr=https&sv=2019-02-02&sr=b&sig=YbrQ6h0tEyFa7U0EiJBsluDsLxZSSBgecufUes4WESA%3D)

8. Once you upload the public key, the fingerprint is automatically displayed there. It looks something like this:

`12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef`

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta33.PNG?sp=r&st=2020-03-02T01:42:00Z&se=2020-12-31T09:42:00Z&spr=https&sv=2019-02-02&sr=b&sig=v5Oy1iVw7PHaDsi2uKAC3TRJ6wVloI3wIhEBJqVIFMM%3D)

## Collecting Tenancy and User Information

- In this section we will collect some Tenancy information that will be used in our terraform configurations for our later sections.

1. The Tenancy OCID is provided below:

* **Tenant OCID:** {{Tenancy OCID}}

2. The User OCID is provided below: 

* **User OCID:** {{User OCID}}

3. Switch to OCI Console. You should be on the user details page. Scroll Down to see the fingerprint value. Copy and Paste it in Notepad.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta38.PNG?sp=r&st=2020-03-22T03:08:52Z&se=2021-12-31T12:08:52Z&spr=https&sv=2019-02-02&sr=b&sig=q48%2FsYC6fJRmMf9Wr%2FKJHUO2udOplWTBb7UXFdKOAhU%3D)

4. Now check the region you are logged into in your OCI Console. If you see US East (Ashburn) on the top then switch to Notepad and write down ```region = us-ashburn-1```.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta7.PNG?sp=r&st=2020-02-22T00:48:09Z&se=2021-12-31T08:48:09Z&spr=https&sv=2019-02-02&sr=b&sig=9i7pPE%2FdI6%2BOE061SFcTfJS%2F6ILel%2Fp3B8pCRmOMKRM%3D)

**NOTE**: If you see US West (Phoenix) then region = 'us-phoenix-1'

5. The Compartment OCID is provided below:

* **Compartment OCID:** {{Compartment OCID}}

6. Switch to Git-Bash. You should be in the ```ocikeys``` folder. Enter the below command to get the value of the private api key. Copy the value and Paste it in Notepad.

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


3. Create a directory named ```terraformModules``` by excuting the below command in Visual Studio Code

```
mkdir terraformModules
```
```
cd terraformModules
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta39.PNG?sp=r&st=2020-03-22T03:10:56Z&se=2021-12-31T12:10:56Z&spr=https&sv=2019-02-02&sr=b&sig=CirpLKV1QZpocBoemt%2FavX6TtvqrB36OCU08s4hcdHw%3D)

4. On top left corner, click on `File` and choose `Open Folder`

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/2.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

5. In the Address Bar type `C:/Users/PhotonUser`. You will be navigated to `/PhotonUser` directory where terraformModules folder is created. Select `terraformModules` folder and click on `Select Folder`.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta56.PNG?sp=r&st=2020-03-22T03:12:42Z&se=2021-12-31T12:12:42Z&spr=https&sv=2019-02-02&sr=b&sig=gkF%2FIxQQgwTxJXIs3I5Z4dyA7OSsM8cAQPb2A1YDfGc%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta40.PNG?sp=r&st=2020-03-22T03:11:57Z&se=2021-12-31T12:11:57Z&spr=https&sv=2019-02-02&sr=b&sig=hr3hPwR02GH7T1sOyXvT05H9zfJBPuWYdli02XhqRSI%3D)

6. Now `terraformModules` folder is opened in Visual Studio Code.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta41.PNG?sp=r&st=2020-03-22T03:13:23Z&se=2021-12-31T12:13:23Z&spr=https&sv=2019-02-02&sr=b&sig=idGeYoBcKVt4x0meCihtwz8Pj8f1GtHJe3NOWAtmvLY%3D)

7. Click on Extensions button and search Terraform. Click on install for ``Terraform`` Extension. Click on Explorer button once the installation is complete.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta57.PNG?sp=r&st=2020-03-22T08:17:43Z&se=2021-12-31T17:17:43Z&spr=https&sv=2019-02-02&sr=b&sig=gEPmaZZjCmEobfwDoyMaM69N14wXnk9%2FAv1lqsK7t7g%3D)

- In the course of this Lab for coming sections we will be understanding the concepts of Terraform with the help of some terraform configuration snippets. 

- These configurations will help us deploy a Virtual Machine, VCN in a compartment and run some shell scripts.

## Working with Modules

- Terraform helps us create configuration files and deploy resources in cloud. But as the infrastructure grows it becomes difficult to manage all these configurations. As a result, growing infrastructure can pose a few problems like lack of organization, a lack of reusability and can also pose difficulty for various teams in an organization.

- Modules in Terraform are self-contained packages of Terraform configurations that are managed as a group. Modules are used to create reusable components, improve organization, and to treat pieces of infrastructure as a black box.

- In this section we will learn to divide our configuration in different modules and use these modules wherever necessary.

1. Network Module

- Here we will be creating the network module and try to provision it in our tenancy.

- In Visual Studio Code, you should be in the `terraformModules` folder. Now Click on `Terminal` and select `New Terminal`. 

- Download the network Module by executing the below command. You should get a zip file in your folder. Once done unzip the file.

```
curl "https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/network.zip?sp=r&st=2020-03-01T19:44:58Z&se=2021-01-01T03:44:58Z&spr=https&sv=2019-02-02&sr=b&sig=AwlfUqbQbir0by0XJ1kZcgqXJqAOi80M2MSUdKU00ac%3D" -o network.zip
```
```
unzip network.zip
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta42.PNG?sp=r&st=2020-03-22T03:14:25Z&se=2021-12-31T12:14:25Z&spr=https&sv=2019-02-02&sr=b&sig=BV9UitAmcA%2BE4g8hprxE6xp0%2BwEZ2q4Sj8EsSrgrwCo%3D)

- After uzipping, you should see a `network` folder in `terraformModules`.

- Let us create a New file called ```variables.tf``` in Visual Studio Code under the folder ```terraformModules``` by clicking on the `New File` symbol present beside the folder name. Add the snippet below to contents of the `variables.tf` file and **Save** it.

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

variable "private_key_path" {
  default = "./private-key"
}

variable "region" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}


variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0nysWs1m+sdoaK15mMIvLEiN+ofDhi9qNEXbPby+a76cJl4zD26P3cErUjE2HVLizuLoec5XzrcKLOz53/0f9hulwZRzapsbIZlPDLBoL+HcuqRyD23YMf6ETg780E3cKZvDVtVCKZg0R2H8QGs9yrnKHt0zhXp6FwKuinfVvMhY3rOM23bYRoI3Y4WiREMSDWLkNTXxAJqUPtcxPVVU388OpWznAsEYiioiwt/KsNU1MECpcK93vihdUMJ15GamPptplS+0Bu1nmYHOvkp9UHEsq+SNKw57sO8S2dgJtpDmT3Hyth8ZvgW+pYOEGAD7PwxFfUm2km/XuRUDF7HfB computekey"
}

variable "ssh_private_key" {
  default = "./ckey"
}

# Choose an Availability Domain
variable "AD" {
  default = "1"
}

variable "InstanceShape" {
  default = "VM.Standard.E2.1"
}

variable "InstanceImageOCID" {
  type = "map"
  default = {    
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaacy7j7ce45uckgt7nbahtsatih4brlsa2epp5nzgheccamdsea2yq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaavzjw65d6pngbghgrujb76r7zgh2s64bdl4afombrdocn4wdfrwdq"
  }
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta43.PNG?sp=r&st=2020-03-22T03:15:09Z&se=2021-12-31T12:15:09Z&spr=https&sv=2019-02-02&sr=b&sig=ovgsu2Tsi%2FGOPnoqqwBRuYO7F4hBdcXa9FMYkVD99xQ%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta44.PNG?sp=r&st=2020-03-22T03:15:34Z&se=2021-12-31T12:15:34Z&spr=https&sv=2019-02-02&sr=b&sig=FdHPp5ZtpFydpEtHTsMgPV%2Bsc15m7rfrpsqQXMwTESI%3D)

- The values for `tenancy_ocid`, `user_ocid`, `fingerprint`, `region` and `compartment_ocid` can be found in Section 2 of this lab. Copy the values and then **Save** the file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta48.PNG?sp=r&st=2020-03-22T03:15:59Z&se=2021-12-31T12:15:59Z&spr=https&sv=2019-02-02&sr=b&sig=zSWZHBzC8hkvQTqUO9Ur4qgeGGgHf86qGWcfcIwv3DQ%3D)

- Now create ```provider.tf``` file and copy the below snippet and **Save** the file.

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

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta45.PNG?sp=r&st=2020-03-22T03:16:28Z&se=2021-12-31T12:16:28Z&spr=https&sv=2019-02-02&sr=b&sig=%2BdeceljNm0Z1%2BYa4MVhd4WdtsTu9SPzobC1ig%2BBb5Ds%3D)

- Create another file called ```private-key```. Copy the value of `oci_api_key.pem` file from Section 2 and **Save** it.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta47.PNG?sp=r&st=2020-03-22T03:16:53Z&se=2021-12-31T12:16:53Z&spr=https&sv=2019-02-02&sr=b&sig=8R817pxvGiTRlcyI%2B8zSTy9PkdEKJDqqwyLHiCHbDSs%3D)

- Now we need to create the ```main.tf``` file for our network module. Click on New File option and copy the below snippet:

```
module "network" {
    source = "./network"
    compartment_ocid = "${var.compartment_ocid}"
    tenancy_ocid = "${var.tenancy_ocid}" 
    AD = "${var.AD}"
}
```
- After copying **Save** the file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta46.PNG?sp=r&st=2020-03-22T03:17:24Z&se=2021-12-31T12:17:24Z&spr=https&sv=2019-02-02&sr=b&sig=iBh7R%2BDhmOaCquvPUctGgUyHI9MxXB4FtREldFGrMNU%3D)

- While writing the configuration for modules, the source of the modules should be specified first and then the variables used in the modules are defined later. As seen in the above snippet, the source for our module is defined first and then the variables. 

- If you Open the network folder, you should see three configuration files namely ``network.tf``, ``variables.tf`` and ``output.tf``. These are configuration files for our network module.

- Now let us run terraform commands and provision a Virtual Cloud Network. Run the ```terraform init``` and ```terraform apply``` commands in the Terminal window. Answer **yes** when prompted.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta49.PNG?sp=r&st=2020-03-22T03:17:49Z&se=2021-12-31T12:17:49Z&spr=https&sv=2019-02-02&sr=b&sig=BR%2FkHbXF%2FyKvDhlz%2FYLwUJQxME%2F5jZLLmj2uwp1HUak%3D)

- This will provision a VCN in your Tenancy. Now let us create another module to provision a compute instance.

2. Compute module

- At this point, you should be in the `terraformModules` folder. If not then Switch to Visual Studio Code. 

- Download the compute Module by executing the below command. You should get a zip file in your folder. Once done unzip the file.

```
curl "https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/instance.zip?sp=r&st=2020-03-01T20:01:59Z&se=2021-01-01T04:01:59Z&spr=https&sv=2019-02-02&sr=b&sig=BpHXJ%2FBeXePdJKBhVuP2OLQxTOXma%2Fg4ZvmIlDiTa6c%3D" -o compute.zip
```
```
unzip compute.zip
```

- After uzipping, you should see an `instance` folder in terraformModules.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta50.PNG?sp=r&st=2020-03-22T03:18:15Z&se=2021-12-31T12:18:15Z&spr=https&sv=2019-02-02&sr=b&sig=Fnn04ZqqwYLfDw1pz47ccRxPTioejmj2RzgMl6C1Sn0%3D)

- Now we need to update the `main.tf` file to provision a compute instance. Add the below code snippet to the file and **Save** it.

```
module "instance" {
    source = "./instance"
    compartment_ocid = "${var.compartment_ocid}"
    AD = "${var.AD}"
    InstanceImageOCID = "${var.InstanceImageOCID}"
    InstanceShape = "${var.InstanceShape}"
    region = "${var.region}"
    ssh_public_key = "${var.ssh_public_key}" 
    ssh_private_key = "${var.ssh_private_key}"
    subnet = "${module.network.subnet_id}"  
    tenancy_ocid = "${var.tenancy_ocid}"
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta51.PNG?sp=r&st=2020-03-22T03:18:41Z&se=2021-12-31T12:18:41Z&spr=https&sv=2019-02-02&sr=b&sig=Z2ZqX%2F%2BwRqJBqdA73sdJx7P1h9fr%2B5YEVNZgivT5zMs%3D)

- Create a file called ```bootstrap.sh```. This file is used by the compute module to install packages after provisioning the instance. Click on New File option to create the file and then copy the below code snippet. **Save** the file once done.

```
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable  httpd.service
systemctl start  httpd.service
firewall-offline-cmd --add-service=http
systemctl enable  firewalld
systemctl restart  firewalld
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta52.PNG?sp=r&st=2020-03-22T03:19:04Z&se=2021-12-31T12:19:04Z&spr=https&sv=2019-02-02&sr=b&sig=So0kWlEXn1SZbBDr2IsWF70FHNzUNRV25gQyDb4GAYg%3D)

- Download the private ssh key for the compute instance by executing the below command in terminal. 

```
curl "https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/ckey?sp=r&st=2020-02-11T23:40:23Z&se=2022-01-01T07:40:23Z&spr=https&sv=2019-02-02&sr=b&sig=pKQqknoxzn2Xy2Svv%2Bn%2BMJcudaUuSWEso9tm3q81xhY%3D" -o ckey
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta53.PNG?sp=r&st=2020-03-22T03:19:25Z&se=2021-12-31T12:19:25Z&spr=https&sv=2019-02-02&sr=b&sig=DFcUb%2B2eOo6jdgQOA4rZOwckZqpCalh9BJOpJvdWYEo%3D)

- In addition to the files you had in the terraformModules folder, at this stage you should also have an updated ``main.tf`` file, ``bootstrap.sh`` file, ``ckey`` and ``instance`` folder.

- Now let us run terraform commands to provision a compute instance in the VCN created earlier. Run ```terraform init``` and ```terraform apply``` commands in the terminal window. Answer **yes** when prompted.

- This will provision a compute instance and copy the bootstrap.sh file to the created instance and install packages on the machine.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta58.PNG?sp=r&st=2020-03-22T08:00:55Z&se=2021-12-31T17:00:55Z&spr=https&sv=2019-02-02&sr=b&sig=XV9xiHuBJBRXmFS%2FjtszD6EPfYWZF8%2Bin%2Ft9N8XT1N0%3D)

- If you click on the instance folder, you should see a provisioner.tf file. This file has two provisioners namely ``file`` and ``remote-exec``.

- The `file` provisoiner is used to copy files from local to a provisioned machine, in this case we transferred the bootstrap.sh file onto the instance. The remote-exec provisioner connects to the machine and run some commands onto the machine, in our case we are trying to update packages and then install the apache server onto the machine.


3. Creating outputs with modules

- Create a new file called ```outputs.tf``` outside the instance folder by clicking outside the folder first and then clicking `New file` option. Copy the below Code and **Save** the file. 

```
output "InstancePrivateIP" {
  value = "${module.instance.InstancePrivateIP}"
}

output "InstancePublicIP" {
  value = "${module.instance.InstancePublicIP}"
}
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta59.PNG?sp=r&st=2020-03-22T08:01:22Z&se=2021-12-31T17:01:22Z&spr=https&sv=2019-02-02&sr=b&sig=cuhshRNCmX1b1A7Kc%2FrY%2B5B359S2yhfHOQqgzf6tRjw%3D)

- Now run the ```terraform apply``` command in the terminal window to get the outputs. Answer **yes** when prompted.

- Running the command will spew out the Public and Private IPs of the compute instance. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta60.PNG?sp=r&st=2020-03-22T08:01:47Z&se=2021-12-31T17:01:47Z&spr=https&sv=2019-02-02&sr=b&sig=tCjsgQiUW3HUwxpfivJIXH8b426NH4pW6uUG7d32Sbk%3D)

- Copy the Public IP of the instance. Switch to Chrome browser and paste the IP address in a new tab. You should see the Apache httpd Web Server. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta61.PNG?sp=r&st=2020-03-22T08:02:27Z&se=2021-12-31T17:02:27Z&spr=https&sv=2019-02-02&sr=b&sig=EPmlDXBVzbFcpnqxqLRwotyB%2BLulxEAgRP0Mq1d4NHE%3D)

## Changing Configuration in Modules

- In this section we will see what happens when we modify the infrastructure and change our configuration files. 

- Switch to Visual Studio Code, you should be in the terraformModules folder. Let us try to modify the configuration and provision the instance again.

- Click on variables.tf file and scroll down to find the ``InstanceShape`` variable. Change the value from `VM.Standar.E2.1` to `VM.Standard.E2.2`

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta62.PNG?sp=r&st=2020-03-22T08:03:02Z&se=2021-12-31T17:03:02Z&spr=https&sv=2019-02-02&sr=b&sig=PBIUbifaEQMhBZaewfClzUfEv2ZQeKfotfNO5C1ge3c%3D)

- Now run the ```terraform apply``` command in the Terminal window. Answer **yes** when prompted.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta63.PNG?sp=r&st=2020-03-22T08:03:24Z&se=2021-12-31T17:03:24Z&spr=https&sv=2019-02-02&sr=b&sig=EBoT0%2B%2FPyp91UjNDrj3LWoby%2B9NYcWtWaEeXspQjVCs%3D)

- Terraform does an in-place modification of the resource and provisiones a new instance with the updated value for instance shape. 

- Switch to OCI Console and Click on Compute > Instances in Menu. Select your compartment under compartment section. Now Click on the TFInstance resource, you should see the updated shape with existing network addresses.  

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta65.PNG?sp=r&st=2020-03-22T08:28:41Z&se=2021-12-31T17:28:41Z&spr=https&sv=2019-02-02&sr=b&sig=BjEYtADbrS%2BwFETn62ZW5YGmkx3939BMX6ViNVlJKqo%3D)

- Hence you can use Modules in your configurations and not worry about the specifics. The configurations can be modified as per your use and can be updated accordingly.

## Deleting the resources

- In this section we will delete the resources that we have provisioned in the earlier sections. 

- Run ```terraform destroy``` command in the terminal window to delete the resources provisioned in the earlier sections. Answer `Yes` when prompted. The destroy command starts executing and the resources will be deleted.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/ta64.PNG?sp=r&st=2020-03-22T08:14:15Z&se=2021-12-31T17:14:15Z&spr=https&sv=2019-02-02&sr=b&sig=q%2B%2BPEwyhOhY3R1P%2BFXy6ps452TRLofNJAMsEJi0G50k%3D)
 

