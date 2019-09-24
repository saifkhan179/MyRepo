# Building Infrastructure using Terraform.

## Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Installing Terraform](#installing-terraform)

[Building Templates in OCI](#building-templates-in-oci)

[Create Kubernetes Cluster](#create-kubernetes-cluster)

[Install Kubectl, OCI CLI and configure OCI CLI](#install-kubectl,-oci-cli-and-configure-oci-cli)

[Download get-kubeconfig.sh file and Initialize your environment](#download-get-kubeconfig.sh-file-and-initialize-your-environment)

[Starting the Kubernetes Dashboard](#starting-the-kubernetes-dashboard)

[Deploying a Sample Nginx App on Cluster Using kubectl](#deploying-a-sample-nginx-app-on-cluster-using-kubectl)

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

## Installing Terraform

* **Tenant Name:** {{Cloud Tenant}}
* **User Name:** {{User Name}}
* **Password:** {{Password}}
* **Compartment:**{{Compartment}}

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

- The Provider block is used to specify a particular provider like ```oci``` , ```aws``` or ```azure```. A provider is responsible for creating and managinf resources. You can also provide multiple provider blocks in a terraform configuration.

```

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
  disable_auto_retries = "false"
}
```
2. **Resource Section**

- The Resource Block defines a resource that exists within the infrastructure. A resource can a virtual machine or block volume or a virtual network.

- The resource block has two strings before opening the block: resource type and resource name. In the below example "oci_core_virtual_network" is the resource type and "ExampleVCN" is the resource name.

```
resource "oci_core_virtual_network" "ExampleVCN" {
  cidr_block = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFExampleVCN"
  dns_label = "tfexamplevcn"
}
```
- This will create a virtual cloud network in your OCI Tenancy.

3. **Datasources Section**

- This section is used to fetch the OCI Tenant details for some specific resources. For example, we can provide the Availability Domain for a Tenant to provision our resources. 

```
data "oci_identity_availability_domain" "AD" {
    compartment_id = "${var.tenancy_ocid}"
    ad_number = 1
 
}
```
4. **Variables Section**

- Input variables serve as parameters for the Terraform Configuration. A set of dynamic values can be set with the help of vaiables. In the above Resource section, the value for compartment ocid is set as a variable. 

- This helps us to use various compartments in OCI Tenant as per our use and not alter the main resource every time for deployment.

```
variable "compartment_ocid" {
  default = ""
}
```

5. **Outputs Section**

- Outputs define values that will be highlighted to the user when Terraform is done provisioning resources.

- Resource blocks managed by Terraform export attributes whose values can be used elsewhere in the configuration. Outputs are a way to expose some of that information to the user. 

```
output "VCN_CIDR" {
  value = ["${oci_core_virtual_network.ExampleVCN.cidr_block}"]
}
```












