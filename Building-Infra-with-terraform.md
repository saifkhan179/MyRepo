# Building Infrastructure using Terraform.

## Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Sign in to OCI Console and Generate API Keys](#sign-in-to-oci-console-and-generate-api-keys)

[Collecting Tenancy and User information](#collecting-tenancy-and-user-information)

[Installing Terraform and Setting up Provider for OCI](#installing-terraform-and-setting-up-provider-for-oci)

[Building Templates in OCI](#building-templates-in-oci)

[Deploying Infrastructure](#deploying-infrastructure)

[Changing Infrastructure](#changing-infrastructure)

[Destroying Infrastructure](#destroying-infrastructure)

## Overview

Terraform is an open-source infrastructure as code software tool created by HashiCorp. It enables users to define and provision a datacenter infrastructure using a high-level configuration language known as Hashicorp Configuration Language (HCL), or optionally JSON.

In this Lab we will be going through the various basic concepts of terraform by provisioning resources in Oracle Cloud Infrastructure (OCI).

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

2. Click the Apps icon in the toolbar and select ```Git-Bash``` to open a terminal window.

<img src="https://raw.githubusercontent.com/oracle/learning-library/master/oci-library/qloudable/OCI_Quick_Start/img/RESERVEDIP_HOL006.PNG" alt="image-alt-text">

3. Change directory to `PhotonUser` and create a directory `oci`, Enter command: 
```
cd /c/Users/PhotonUser
```
```
mkdir oci
```
```
cd oci
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-1.PNG?sp=r&st=2020-02-11T02:00:40Z&se=2021-12-31T10:00:40Z&spr=https&sv=2019-02-02&sr=b&sig=q%2FVm84zb%2FAhY6qsWlN8M8%2B1A5SLdPphRsw%2FLBVuJ4gU%3D)

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

```
cat oci_api_key.pem
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm21.PNG?sp=r&st=2020-02-12T07:06:08Z&se=2021-12-31T15:06:08Z&spr=https&sv=2019-02-02&sr=b&sig=GWYbCm2V4%2BPk1rqnm%2FxR56dXi3Q9c6YacPXRCXH0DNI%3D)

5. We have created the API signing key and now we need to generate the fingerprint for your user. 

6. Switch to OCI Console and Click Human icon (top right) and then Click your username. In the user details, Click **Add Public Key**. Copy the public key generated earlier and paste it. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/oci8.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D) 

7. Once you upload the public key, the fingerprint is automatically displayed there. It looks something like this: ```12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-3.PNG?sp=r&st=2020-02-11T06:20:16Z&se=2021-12-31T14:20:16Z&spr=https&sv=2019-02-02&sr=b&sig=AMmt%2BT13pGwdKhW2bZgSGc6xSwxYs8ph1wLJajZGUvU%3D)

## Collecting Tenancy and User Information

1. Switch to OCI Console and Click Human icon (top right) and click Tenancy. You should see Tenancy Information Page. Click ```Copy``` to copy the Tenancy OCID. Switch to Notepad and paste the OCID.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-4.PNG?sp=r&st=2020-02-11T08:56:25Z&se=2021-12-31T16:56:25Z&spr=https&sv=2019-02-02&sr=b&sig=wf3ZdY%2F5vNhkvacfSQadJkEwpFk%2FmAqdTs5OdzkfCYQ%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-6.PNG?sp=r&st=2020-02-11T08:57:59Z&se=2021-12-31T16:57:59Z&spr=https&sv=2019-02-02&sr=b&sig=CdR%2BhR0KHP3iSQWnuOCQLXpdbJeNClv57rPk7QWi4vY%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-5.png?sp=r&st=2020-02-11T08:57:13Z&se=2021-12-31T16:57:13Z&spr=https&sv=2019-02-02&sr=b&sig=NyDR%2B1plSu9V8B7coL08ya%2FpC54lhkOfdZCJRTpiOpQ%3D)

2. Switch to OCI Console and Click Human icon (top right) and click your username. Under User Information page Click ```Copy``` to copy the User OCID. Switch to Notepad and paste the OCID.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-7.PNG?sp=r&st=2020-02-11T08:59:47Z&se=2021-12-31T16:59:47Z&spr=https&sv=2019-02-02&sr=b&sig=k9uFhcANQeetVXpf7FJVo30OcAg812PzdH9w8hRAxh0%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/git-8.PNG?sp=r&st=2020-02-11T09:00:27Z&se=2021-12-31T17:00:27Z&spr=https&sv=2019-02-02&sr=b&sig=bcO192%2FMB8wQCshx1nPS4hlSmxFd2Jgkm0ZXG8q%2BYFM%3D)

3. Now check which region you are logged into. If you see US East (Ashburn) on the top then switch to Notepad and write down ```region = us-ashburn-1```.

4. The fingerprint of the user and value of the private api key is already created in the previous section.


## Installing Terraform and Setting up Provider for OCI

1. As part of this training lab deployment, a virtual machine has been provisioned to provide a working environment for the user. 

2. Click on ```Apps Icon``` and Open ```Visual Studio Code```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/oci16.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure6.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

- Click on Terminal and choose New Terminal to open terminal in Visual Studio Code. 

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure9.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/Azure/Terraform/Azure7.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

- Download the private ssh key used to login to the VM. To do this run the below command:

```
curl "https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/ckey?sp=r&st=2020-02-11T23:40:23Z&se=2022-01-01T07:40:23Z&spr=https&sv=2019-02-02&sr=b&sig=pKQqknoxzn2Xy2Svv%2Bn%2BMJcudaUuSWEso9tm3q81xhY%3D" -o ckey
```
- Now ssh into the machine by running the following command. 

* **Public_IP_of_VM:**{{InstancePublicIP}}

```
ssh -i ckey opc@<public_ip_of_the_machine>
```
- Enter yes to continue connecting to the machine. You are now logged into the machine. You should see 
```
[opc@tfexampleinstance ~]$
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm1.PNG?sp=r&st=2020-02-12T03:00:21Z&se=2021-12-31T11:00:21Z&spr=https&sv=2019-02-02&sr=b&sig=GvwEjT550URBj6lvODFf3Lbwr7Pt3XAyfDl3mA%2FKFuc%3D)

3. Now we need to install terraform on this machine. Execute the following command: 
```
wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm2.PNG?sp=r&st=2020-02-12T03:02:30Z&se=2021-12-31T11:02:30Z&spr=https&sv=2019-02-02&sr=b&sig=e8rg6F4x9tp5LwApNLQbpDXFM6ClugHlCF4WqveM0%2BI%3D)

- Unzip the terraform zip file downloaded in the previous step and install terraform. execute the below commands. 
```
unzip terraform_0.12.18_linux_amd64.zip
```
```
sudo yum install terraform -y
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm3.PNG?sp=r&st=2020-02-12T03:03:10Z&se=2021-12-31T11:03:10Z&spr=https&sv=2019-02-02&sr=b&sig=9WPGy99y4njIn5A3IsR99NA0iJewxxb3gDFxltAVGyc%3D)

- Once the ```terraform``` is installed, execute the ```terraform --version``` command in the terminal window. You should see the help output similar to as shown in the below picture: 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm4.PNG?sp=r&st=2020-02-12T03:03:47Z&se=2021-12-31T11:03:47Z&spr=https&sv=2019-02-02&sr=b&sig=ZTHlLqTLAuOpzrMKH0F9cOPOGgFXOG7QpKBIgYe8Afw%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm5.PNG?sp=r&st=2020-02-12T03:04:28Z&se=2021-12-31T11:04:28Z&spr=https&sv=2019-02-02&sr=b&sig=QNI1p4MRa3gv1BhIC8NCJw1LsFPM650rB%2Fx8gxeiCk4%3D)

4. Create a directory named ```terraformOCI``` and change the directory to that folder by excuting the below command:
```
mkdir -p terraformOCI
```
```
cd terraformOCI
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm6.PNG?sp=r&st=2020-02-12T03:06:49Z&se=2021-12-31T11:06:49Z&spr=https&sv=2019-02-02&sr=b&sig=ADYp%2BQNnJ3QiueB9Yg5DFhdalb1De%2FpF04UCEjVmhnQ%3D)

## Building Templates in OCI

- The set of files used to describe infrastructure in Terraform is known as Terraform Configuration. In this section we will learn to write the various configuration files in terraform.

1. **Provider Section** 

- The Provider block is used to specify a particular provider like ```oci``` , ```aws``` or ```azure```. A provider is responsible for creating and managing resources. You can also provide multiple provider blocks in a terraform configuration.

```
provider "oci" {
  tenancy_ocid = ""
  user_ocid = ""
  fingerprint = ""
  private_key_path = "./private-key"
  region = ""
  disable_auto_retries = "false"
}
```
- Inside the terraformOCI folder, create a file named `provider.tf` by executing the following command: 
```
nano provider.tf
```

- Paste the above provider block in the ```provider.tf``` file. Copy the values for the respective fields from earlier sections.

```
Note:
tenancy_ocid: OCID of your Tenancy
user_ocid: OCID of your Tenancy
fingerprint: fingerprint of the user
private_key_path: path for the private key
region: region of your Tenancy
```
- Save the file by pressing `Ctrl+O` followed by `Enter` and the `Ctrl+X` to close the editor.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm7.PNG?sp=r&st=2020-02-12T03:07:32Z&se=2021-12-31T11:07:32Z&spr=https&sv=2019-02-02&sr=b&sig=vvSmrNB2nunFTYpk1QYnp9qGVCk98tarqGy0WU61wx8%3D)

- Similarly, create a file named `private-key` and paste the contents of the private api key generated earlier. Save the file when done.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm8.PNG?sp=r&st=2020-02-12T03:08:06Z&se=2021-12-31T11:08:06Z&spr=https&sv=2019-02-02&sr=b&sig=XsPWwLgMIwaoN9ZUIrr0FV%2Fazu34Hc0iA9R4n4FPuTE%3D)

2. **Resource Section**

- The Resource Block defines a resource that exists within the infrastructure. A resource can be a virtual machine or block volume or a virtual network.

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

- To create a VCN, create a file named `examplevcn.tf` as did for the other files before. Copy the above resource block and save the file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm9.PNG?sp=r&st=2020-02-12T03:08:35Z&se=2021-12-31T11:08:35Z&spr=https&sv=2019-02-02&sr=b&sig=5oBRsjl8HGSBXzCm3aCCfLMeDhcBBz1zC0rluLH1%2Bks%3D)

- You should have three files namely provider.tf, examplevcn.tf and private-key. In the next section we will run some terraform commands to provision resources in Cloud.

## Deploying Infrastructure 

- The very first command which is run after building templates is the ```terraform init``` command. This command initializes Terraform in the current working directory and various local settings and data that will be used by subsequent commands.

1. In the same terminal, execute the `terraform init` command to initialize the environment. 

```
terraform init
```
After initializing the environment, we can run other commands to provision resources in OCI. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm10.PNG?sp=r&st=2020-02-12T03:09:11Z&se=2021-12-31T11:09:11Z&spr=https&sv=2019-02-02&sr=b&sig=YiSZmKupoGr96zj2AQI3%2FCzmiOxMJ1zBCdw28cx7Lw4%3D)

2. Now run the plan command. This command generates an execution plan for the configuration files and then determines what actions are necessary to achieve the desired state. 

```
terraform plan 
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm11.PNG?sp=r&st=2020-02-12T03:12:55Z&se=2021-12-31T11:12:55Z&spr=https&sv=2019-02-02&sr=b&sig=LT4Cd0V3hngz6cv9Afyz4Wpd%2F3dc1bVpmBJdIjyUsOY%3D)

3. Now run the apply command. This command will Apply changes to the configuration files and provision the resources. Type `yes` and click `Enter` to approve the plan.

```
terraform apply
```

- If the plan was created successfully, Terraform will now pause and wait for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure. In this case the plan looks acceptable, so type yes at the confirmation prompt to proceed.

- If terraform apply failed with an error, read the error message and try to fix the error that occurred. At this stage, it is likely to be a syntax error in the configuration.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm12.PNG?sp=r&st=2020-02-12T03:13:32Z&se=2021-12-31T11:13:32Z&spr=https&sv=2019-02-02&sr=b&sig=qpykJmFoCTwh3YfvBF4HK8JPjrpvTaOlWUdIHFwuLuo%3D)

- Executing the plan will take few minutes until the provisioning of resources is complete. You can now check the resources in the compartment in the OCI Console.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm13.PNG?sp=r&st=2020-02-12T03:14:04Z&se=2021-12-31T11:14:04Z&spr=https&sv=2019-02-02&sr=b&sig=xCq%2Bl2Elw%2B5NVVkLlFJx0%2F8qHQPQIh%2BmYFUazWInyKQ%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm14.PNG?sp=r&st=2020-02-12T03:14:45Z&se=2021-12-31T11:14:45Z&spr=https&sv=2019-02-02&sr=b&sig=am2EowppIQbtv7G1FNXUtRYJytchtGfFSdTuzpiqTz0%3D)

- Now you have successfully deployed virtual cloud network using terraform templates. 

## Changing Infrastructure

- In the previous section, we provisioned resources in OCI but in this section we will see what happens if we change the configuration of resources.
- Infrastructure keeps evolving and Terraform is built to manage and apply these changes. As the configuration changes terraform identifies the change and modifies the plan necessarily to achieve the desired state.

- Open the examplevcn.tf file and change the value of property `cidr_block` to 10.2.0.0/16. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm15.PNG?sp=r&st=2020-02-12T03:15:15Z&se=2021-12-31T11:15:15Z&spr=https&sv=2019-02-02&sr=b&sig=rHlIZoHUeslZEqQI50RzNaQbftvD0KE%2FYBuDdbIyOGU%3D)

- Now run `terraform apply` again to see how terraform handles changes. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm16.PNG?sp=r&st=2020-02-12T03:15:42Z&se=2021-12-31T11:15:42Z&spr=https&sv=2019-02-02&sr=b&sig=bjceL1lxmHf2JN8v7%2B%2BsySy3lp%2BftfcOEIsG5sa6rrw%3D)

- The prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place. While some attributes can be updated in-place (which are shown with the ~ prefix), changing the cidr_block for a vcn requires recreating it. Terraform handles these details for you, and the execution plan makes it clear what Terraform will do.

- Once again type `yes` to approve changes and hit `Enter`. As indicated in the execution plan, terraform recognizes the changes and updates the configuration to provision resources. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm17.PNG?sp=r&st=2020-02-12T03:16:21Z&se=2021-12-31T11:16:21Z&spr=https&sv=2019-02-02&sr=b&sig=o0DJrQ5izvcwOxHiUxXWx0XgrFiIs0uaL4zihYU7bVM%3D)

- Check the compartment in your OCI console to verify the updated `cidr` value of the vcn.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm18.PNG?sp=r&st=2020-02-12T03:17:12Z&se=2021-12-31T11:17:12Z&spr=https&sv=2019-02-02&sr=b&sig=OwB9c49Ix8ODYoJTMNAHx75GYlyuZNKy2xpoPCeYKOs%3D)

## Destroying Infrastructure

- Until now we have seen how to provision and change the infrastructure in terraform. Now we will see how to destroy the infrastructure. Destroying infrastructure is a rare scenario but when you are spinning infrastructure for different environments like QA, staging and non-prod environments destroying becomes useful.

- In the terminal window that you were working in before and type the ```terraform destroy``` command and  hit `Enter`.

- Same as the apply command, terraform generates the execution plan and waits for approval. Type `yes` and hit `Enter`. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm19.PNG?sp=r&st=2020-02-12T03:18:10Z&se=2021-12-31T11:18:10Z&spr=https&sv=2019-02-02&sr=b&sig=0UGze9kEkn%2FNcd2E05yqhuPsTxkuG3dI%2BnMNiZt3x74%3D)

- The terraform deletes the provisioned vcn. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/Terraform/Images/vm20.PNG?sp=r&st=2020-02-12T03:18:48Z&se=2021-12-31T11:18:48Z&spr=https&sv=2019-02-02&sr=b&sig=99G3ULis%2FrfgWR2dorfBSRdtTb9UYdgkaAldbHm2xqM%3D)

- You have now successfully detroyed the provisioned Virtual cloud network.


**Congratulations! You have successfully completed the lab**









