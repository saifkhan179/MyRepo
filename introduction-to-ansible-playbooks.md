# INTRODUCTION TO ANSIBLE PLAYBOOKS

# Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Login to OCI Console](#login-to-oci-console)

[Create a VCN](#create-a-VCN)

[Create Public and Private SSH Keypair to Login to the Compute Instance](#create-public-and-private-ssh-keypair-to-login-to-the-compute-instance)

[Create a Compute Instance](#create-a-compute-instance)

[Login to the Compute Instance and Install Ansible](#login-to-the-compute-instance-and-install-ansible)

[Creating SSH keys](#creating-ssh-keys)

[Create a Playbook](#create-a-playbook)

[Install multiple roles in servers](#install-multiple-roles-in-servers)

[Variables and handlers](#variables-and-handlers)



## Overview

Welcome to the Introduction to Ansible Playbooks Learning Lab!

Ansible Playbooks are an organized unit of scripts that is used for server configuration management by the automation tool Ansible. Ansible Playbooks are used to automate the configuration of multiple servers at a time. Playbooks are written in YAML format.

Playbook contains one or more plays/tasks which executes a simple command or a script. Every playbook has an attribute hosts, where servers or group of servers are defined. These plays are executed in sequencial manner on the servers defined in the playbook.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/1.png?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

It is possible to run several hundreds of tasks in a single playbook, but it is efficient to reuse a task multiple time in multiple playbooks so tasks or group of tasks can be organized into roles. These roles can be included into a playbook. Directory structure of a sample ansible project is:

provision.yaml<br>
webserver.yaml
roles/
  provision_server/
  tasks/
    main.yaml
  handlers/
  files/
  templates/
  vars/
  defaults/
  webserver/
  tasks/
  files/
  templates/

In the above hierarchy provision.yaml and webserver.yaml are the playbooks defined in the project and roles directory contains 2 roles, provision and webserver.

Each role has multiple folders:

- tasks - contains single or multiple yaml files with each file containing multiple tasks
- handlers - contains handlers that can be used in this role like restart service 
- files - contains files that are copied into the target machine
- templates - contains a template file which can be used for deploying into the target machine. Template files are used with the variables defined in the playbook.
- vars - common variables that are used in this role. 
- defaults - variables that are default for the role can be defined in this folder. 

In the above folder structure the tasks folder is the mandatory folder and all the other folders are optional. In this tutorial we will learn about ansible playbooks and how different roles are executed in multiple servers from a single playbook. We will learn some Ansible features and how they are helpful in playbooks.

Click Start above to begin the lab!


## Pre-Requisites

1) Basic knowledge of Linux servers

2) YAML language

3) SSH private/public key knowledge

## Login to OCI Console

Before you Begin:

1- All screen shots are examples ONLY. Screen shots can be enlarged by Clicking on them

2- Every User MUST keep below credentials handy.
User Name
Password
Compartment Name (Provided Later)
Cloud Tenant Name

3- Do NOT use compartment name and other data from screen shots.Only use  data(including compartment name) provided in the content section of the lab

In this section we will login to the OCI console and adjust your screen size (if needed).

**Step 1.** Sign in to your account using the below credentials 
            (Please type in your credentials):

OCI Login Credentials<br>

**Tenancy Name:** {{tenancy-name}}<br>
 **OCI login_ID:** {{oci-login-id}} <br>
 **OCI login_Password:** {{oci-login-password}}<br>
 **Compartment Name:** {{compartment-name}} <br>


**Note:** Your password should be updated automatically for you, but sometimes  you may be asked to change it after signing in the first time. If prompted, pleaseupdate the password. You can use this one to expedite things: Oracle123!!!! . It will not be saved after this lab expires.

**Step 2.** Reduce the Browser Display Window Size/Resolution to fit your needs(Below example is for Chrome). 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/2.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Create a VCN

In this section, you will create a Virtual Cloud Network (VCN) within the OCI console.

**Step 1.** Click on the OCI Services Menu, Select Networking and choose Virtual Cloud Networking

 ![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/3.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Please ensure you have the correct Compartment Selected. (Bottom Left of OCI console). 

Choose Compartment: {{compartment-name}}

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/4.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** Click Create Networking Quickstart. Now click **VCN with Internet Connectivity** and click **Start Workflow**

**Step 4.** Fill out the details for Dialog Box that appears with the following information.<br>
     4.1 For the NAME, enter an easy to remember name, like for example, `my_vcn`<br>
     4.2 Ensure Create in Compartment is set to the right compartment.<br>
     4.3 Enter a value for the CIDR block, for example `10.0.0.0/16`<br>
     4.4 Enter a value for Public Subnet CIDR Block, for example `10.0.1.0/24`<br>
     4.5 Enter a value for Public Subnet CIDR Block, for example `10.0.2.0/24`<br>
     4.6 Click Next and then Click Create.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/ta68.PNG?sp=r&st=2020-03-31T04:29:47Z&se=2021-12-31T13:29:47Z&spr=https&sv=2019-02-02&sr=b&sig=fvUesivkSsBdS2JEi%2BYPAxo4OHDZKsd5vwJUnC%2BvLkQ%3D)
**Step 5.** A Virtual Cloud Network will be created and the name that was given will appear as the name of the VCN on the OCI Console.

## Create Public and Private SSH Keypair to Login to the Compute Instance

In this section we will create a public/private SSH key pair. These keys will be used to launch a Compute instance and connect to it.

**Step 1.** In the OCI Console Window, select the Apps icon and open git-Bash. A Git-Bash terminal will appear.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/6.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Enter the command ssh-keygen in git-bash window.

**TIP:**
You can swap between the OCI window and any other application (git-bash etc.) by clicking the Switch Window icon beside apps icon. 

 
**Step 3.** Press "Enter", when asked for the following:

 a) Enter file in which to save the key 

 b) Enter passphrase

 c) Enter passphrase again

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/7.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** You should now have the Public and Private keys generated.They can be found in<br> 
             /C/Users/PhotonUser/.ssh/id_rsa (Private Key)<br>
             /C/Users/PhotonUser/.ssh/id_rsa.pub (Public Key)

**Note:**<br>
       id_rsa.pub will be used to create the Compute instance and id_rsa to connect via SSH into the Compute instance.<br>
       Run 'cd /C/Users/PhotonUser/.ssh' (No Spaces in directory path) and then 'ls' to verify the two files exist.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/8.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** In the git-bash terminal window, type 

```
cat /C/Users/PhotonUser/.ssh/id_rsa.pub
``` 
Highlight the SSH key and copy (using the mouse or the keyboard (ctrl-c)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/9.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** In the OCI Console Window, click the Apps icon  and click Notepad. 

**TIP:**
You can swap between the OCI window and any other application (Notepad etc.) by clicking the Switch Window  icon.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/10.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 7.** Paste the public key in Notepad (using your mouse/touch pad or Ctrl v).

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/11.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 8.** Minimize Notepad and git-bash (if open) windows.

We now have a Public/Private SSH key pair. Next we will
create a compute instance using the public key we just saved.

## Create a Compute Instance

In this section we will create a Compute instance with a Public IP address using the public SSH key generated in the previous section.

**Step 1.** Switch to OCI console (if not already).

**TIP:** You can swap between the OCI window and any other application (git-bash etc.) by clicking the Switch Window icon beside apps icon. 

**Step 2.** Click on the OCI Services Menu, Select Compute and choose Instances

**Step 3.** Click Create Instance. Fill out the dialog box:

  3.1 Name: Enter a name (e.g. `Ansible_VM`).

  3.2 Availability Domain: Select the first available domain.

  3.3 Image Operating System: For the image, we recommend using the Latest Oracle Linux available.

  3.4 Shape: Select `VM.Standard.E2.1` (1 OCPU, 8GB RAM).

  3.5 SSH Keys: Select the PASTE SSH KEYS radio button and Paste the Public Key you saved in Notepad in the previous section.

You can swap between the OCI window and any other application (notepad etc.) by clicking the Switch Window icon beside apps icon. 
<br>
  3.6 Virtual Cloud Network: Select the VCN you created in the previous section.

  3.7 Subnet: Select the first available subnet.

  3.8 Click Create Instance.

**Note:** Leave other options in the dialog box as is other than the options mentioned above. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/12.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/13.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Follow the step 2 and 3 again to create another instance.

**Step 5.** Once both the Instances are in ‘Running’ state, note down the public IP addresses.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/14.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** You can also see that instances has now been provisioned and are in Running state.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/15.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

We now have two Compute instances with a Public IP addresses running in OCI.
Next we will SSH to the compute instance from the internet.

## Login to the Compute Instance and Install Ansible

In this section we will SSH into one of the Compute instances using its Public IP address and private SSH key to Install and Configure Ansible. This instance acts as a Ansible Control Machine and the other as a node.

**Note:** One server can randomly be selected to be Ansible Control Machine.

**Step 1.** Bring up a new git terminal or switch to the existing one (if you still have it open).

**Tip:** If the terminal was closed simply launch a new one using the Apps icon .

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/16.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** In the git-bash Terminal Window Type the command:

```
cd /C/Users/PhotonUser/.ssh/
```

Type ls and verify the id_rsa file exists.

**Tip:** No Space in directory path (/C/Users/PhotonUser/.ssh).


![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/17.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** To login to the running instance, we will SSH into it. Type the command:

```
ssh –i id_rsa opc@<PUBLIC_IP_OF_COMPUTE_INSTANCE_1>
```

**Note:** User name is ‘opc’. <PUBLIC_IP_OF_COMPUTE_INSTANCE_1> should be the actual IP address which was noted in previous section for example:  129.0.1.10 


![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/18.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Enter `yes` when prompted for security message. 

**Step 5.** Verify the prompt shows 

 ```
 opc@<YOUR_VM_NAME>
 ``` 
 (below example shows the command prompt for Compute instance)


![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/19.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.**  We now have a Compute instance in OCI with a Public IP  address which is accessible over the internet.

**Step 7.** The "sudo" command allows user to run programs with elevated privileges and "su" command allows you to become another user. Running the following command will default to root account (system administrator account) which allows installing and configuring ansible using yum package manager.

```
sudo su -
```
```
yum install -y ansible
```

**Note:** Along with Anisble package, multiple pre-requisite packages are being installed which takes a couple of minutes.

**Step 8.** Bring up a new git-bash terminal using the Apps icon.

**Step 9.** To login to the Second running instance, we will SSH into it. Type the command

```
ssh –i id_rsa opc@<PUBLIC_IP_OF_COMPUTE_INSTANCE_2>
```

Enter `yes` when prompted for security message. 

**Step 10.** Ansible has a default inventory file created which is located at "/etc/ansible/hosts". Inventory file contains a list of nodes which are managed/configured by ansible.

It is always a good practice to back up the default inventory file to reference it in future if required.

Run the following commands to move and create a new inventory file

```sh
sudo mv /etc/ansible/hosts /etc/ansible/hosts.orig
sudo touch /etc/ansible/hosts
vi /etc/ansible/hosts
```
In this tutorial by default "vi" text editor is used to update files.

To learn vi text editor "https://ryanstutorials.net/linuxtutorial/vi.php"

Any other user preferred text editor can be used to update files.

**Step 11.** Update the created hosts file in the step 8 with the following data:
```sh
[local]
127.0.0.1
[webserver]
<<ipaddress of second server>>
 ```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/20.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 12.** In the Step 11, we have added local server's ip address (127.0.0.1) and the second server (public IP address) to the hosts inventory file, Ansible uses the host file to SSH into the servers and run the requiredAansible jobs.

**Step 13.** To validate Ansible is installed and configured correctly, run the following command:

```
ansible --version
```

**Note:** It is ok, if the above command returns different version of ansible. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/21.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Creating SSH keys

In this section, we will create a public and private SSH key pairs for ansible control machine to SSH into the nodes defined in inventory file.

Ansible control machine is a server on which Ansible is installed and executes Ansible tasks on the managed nodes.

An inventory file is a list of managed nodes which are also called "hosts". Ansible is not installed on managed nodes.

**Step 1.** In the terminal of Ansible Control Machine (where ansible is installed), enter the command:

```
ssh-keygen
```

Press "Enter", when asked for the following:

    a) Enter file in which to save the key 

    b) Enter passphrase

    c) Enter passphrase again

**Tip:** No Passphrase is required.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/22.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Public and Private keys should have been generated and are stored in the directory /root/.ssh/. Public key need to be copied to authorized keys file, which gives Ansible access to login into the managed node.

**Note:** In this example Ansible control machine and the managed node is the same server. If authorized_keys file is already available, overwrite it with the public key or a new file is generated.


Execute the following commands to copy the public key:

```
cd /root/.ssh
```
```
cp id_rsa.pub authorized_keys
```

Enter `yes` when promted to overwrite authorized_keys file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/23.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** Open authorized_keys and copy the data using the following command:

```
cat /root/.ssh/authorized_keys
```
            
Highlight the SSH key and copy (using the mouse)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/24.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Open the terminal of the second server. We need to paste the copied public key to the authorized keys file in the second server. Follow the steps to copy the public key:

**Tip:** You can swap between the OCI window and any other application (Notepad etc.) by clicking the Switch Window icon.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/25.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

```sh
sudo su -
cd /root/.ssh/
vi authorized_keys​
```
Copy the key into authorized_keys file 
 

**Note:** The public key needs to be copied into authorized_keys file in all servers(nodes) so that ansible control machine can SSH into the machines.

**Step 5.** In the Ansible Control Machine, Check to see if Ansible is able to connect to the servers, defined in the inventory file that was created in the previous section. Execute the following command which pings the servers in the inventory file.

```
ansible all -m ping
```

Enter `yes` when prompted to add server ip to the known_hosts file. You might need to type twice as 2 hosts are added to the known_hosts file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/26.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Above command pings the servers defined in the inventory file that is created in the previous steps. Since only local machine is added in the inventory file ansible does a ping on the local machine using the SSH key created. 

## Create a Playbook

In this section, we will create an Ansible playbook and learn mroe about roles in Ansible.

**Note:** In this lab by default the "vi" text editor is used to update files. To learn vi text editor visit "https://ryanstutorials.net/linuxtutorial/vi.php". Any other user preferred text editor can be used to update files.

Ansible has an inbuilt tool ansible-galaxy which is used to create roles. Roles are pre-packaged units of work known to Ansible as roles. Roles can be accessed from Ansible playbooks. Roles consist of the tasks it needs to perform. Roles can be shared between playbooks. Ansible Galaxy creates the default directory hierarcy for a role. 

**Note:** Ansible Control Machine Terminal can be accessed by "Switch Windows" beside the apps menu. If the terminal is closed, git-bash can be opened and the server can be logged into from apps menu.

**Step 1.** Open the terminal of Ansible Control Machine, Create a folder named Ansible and store all the playbooks that are required in this tutorial. Create a folder roles under Ansible to store all roles in the folder. 

 
```sh
mkdir -p /root/ansible/roles
cd /root/ansible/roles
ansible-galaxy init create_user
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/27.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Under the folder create_user, navigate to the tasks directory by entering:

```
cd tasks/
```

Next, enter vi main.yml to edit the file "main.yaml", then update it with the following code (see screenshot below):

```yml
---
# tasks file for create_user
- name: Create a new user
   user:
       name: Sysgain
       state: present
   become: true
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/28.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/29.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above code, we are creating a new user named Sysgain. The attribute "become: true" implies to create the user Sysgain from a root account. 

**Step 3.** Create a new playbook in the parent directory where the roles folder is available. Enter the command: vi Create_User.yaml, then update it with the following code (see screenshot below):

```yml
---
- name: Create a new user
   hosts: local
   roles: 
      - role: create_user
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/30.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/31.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above playbook, we are executing the role "create_user" in the local group(inventory file) which is defined in the host section.

**Note:** Servers are defined under groups which are inturn defined under an inventory file. This file was created in the previous sections of this tutorial.

**Step 4.** Execute the following command to run the playbook and create a new user "Sysgain"

```
ansible-playbook /root/ansible/Create_user.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/32.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** Hosts section of the playbook is defined as "local" which create's the user in the local server(Ansible Control Machine). To create a user in all the servers mentioned in the ansible inventory file, Update the hosts section to "all" and run the command 

```
ansible-playbook /root/ansible/Create_user.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/33.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/34.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above execution, User Sysgain was only created in the remote server as the user already exists in the local machine.

**Step 6.** To check if the User(Sysgain) is created in the machines, run the following command

```awk -F ":" '/^Sysgain/{print $1}' /etc/passwd```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/35.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Install multiple roles in servers

In this section, We will learn to install multiple roles in different servers from a single playbook.

In the local machine we will install Apache and the remote node we will be installing tomcat package from a single playbook that is executed from Ansible Control Machine.

**Step 1.**  Inside the directory roles, create a new role named "apache". This role is used to install/configure and manage the apache service. 

 ```ansible-galaxy init /root/ansible/roles/apache```

 ```ansible-galaxy init /root/ansible/roles/tomcat```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/36.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Inside Apache role, Update the file "main.yaml" under the folder tasks with the following code:

```yml
---
# tasks file for apache
- name: Install package Apache
   yum:
       name: httpd
       state: latest

- name: start Apache service
   service:
       name: httpd
       state: started
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/37.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above code, we are installing the latest version of Apache and starting the service of Apache. 

**Step 3.** Inside Tomcat role, Update the file "main.yaml" (using vi command) under the folder tasks with the following code:

```yml
---
# tasks file for tomcat
- name: Install package Tomcat
   yum:
       name: tomcat
       state: latest

- name: Start tomcat service
   service:
       name: tomcat
       state: started
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/38.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above code, we are installing the latest version of tomcat and starting the service of tomcat.

**Step 4.** Create a new playbook "Package_install.yaml" under the parent folder Ansible where roles directory is available. Update the following code (using vi command) in Package_install.yaml file:

```yml
---
- name: Install Apache
   hosts: local
   roles: 
      - role: apache
   become: true

- name: Install tomcat
   hosts: webserver
   roles: 
      - role: tomcat
   become: true
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/39.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/40.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

From the above code, the role "apache" is being installed on the hosts group local and the role "tomcat" is being installed on the webserver group. 

**Note:** The groups "local" and "webserver" are defined under inventory file in the previous sections. We have defined Ansible Control Machine in the local group and the second node server in the webserver group.

**Step 5.**  Execute the playbook from Ansible Control Server which installs apache on the local machine and tomcat on the second compute instance. 

``` ansible-playbook /root/ansible/Package_install.yaml```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/41.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

From the above output, we can see that Apache is installed on the local machine and tomcat is installed on the remote machine.

**Tip:** We can view the IP address of the server on which the playbook is executing in the output section.

**Step 6.** To validate the packages Apache and tomcat are installed on their respective servers. Login into their respective server and the following command:

```service httpd status (shows status of apache service)```

```service tomcat status ( shows status of tomcat service)```

## Variables and handlers

In this section, we will learn about different types of variables and use of handlers in Ansible.

Handlers are tasks that are only executed when they are notified by other tasks in the playbook. For example, if a configuration of a package is updated then the handler is notified to restart the service for the configuration to take effect.

### Variables

Group Variables: These variables are defined in the parent/top directory where roles folder is available. Variables defined here can be accessed across roles. 

Local Variables: These variables are defined inside the role and the scope the variable is limited to the specific role. 

**Step 1.** Enter mkdir group_vars to create a folder named "group_vars"  in the top hierarchy of the folders where roles folder is available. Create a new file "login.yaml" by entering vi group_vars/login.yaml and update the code as follows:

```yml
---
username: "testuser@sysgain.com"
password: "AnsibleTutorial"
```
 
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/42.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/43.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


**Step 2.** These variables can be used in all the roles defined in the roles folder.  

**Step 3.**  Create a new role variables and update "main.yaml" file under tasks directory as follows:

```ansible-galaxy init /root/ansible/roles/variables```

```vi /root/ansible/roles/variables/tasks/main.yaml```
  
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/44.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

The above code takes variable values from the group variables defined in the group variable directory

**Step 4.** Create a new playbook variable.yaml in the main directory where roles are defined and update the code with the following (see screenshot below):

```yml
---
- name: Include group variable
   hosts: all
   tasks:
      - include_vars: "group_vars/login.yaml"

- name: Show variable
   hosts: local
   roles: 
      - role: variables
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/45.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above code, since login.yaml file was included in the playbook which is a group variables file, they can be automatically passed to the subsequent tasks in the playbook. These variables can be accessed in all the nodes that role is executed on.

**Step 5.** Execute the playbook with the following command 

```ansible-playbook create_user.yaml```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/46.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** Handlers are only executed if a certain task reports any changes. For example, if a configuration of a package is updated, then handler is notified to restart the package service which picks up updated configuration.

**Step 7.** Under the role Apache, there is a folder named handlers. Update the file "main.yaml" file with the following code (see screenshot below):

```yml
---
# handlers file for apache
- name: restart apache
   service:
      name: httpd
      state: restarted
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/47.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/48.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 8.** We will be maintaining a file using Apache module and if the file changes we will notify the handler to restart Apache service.

Go to the role Apache and templates folder by entering cd roles/apache/templates/. Create a new file "Sample.j2"  as shown below. j2 is the format of the template that Ansible recognizes. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/49.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/50.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


 **Step 9.** Update the Ansible role code at "/root/ansible/roles/apache/tasks/main.yaml" file with the following code (see below screenshot):


```yml
- name: Update a file
   template:
       src: Sample.j2
       dest: /etc/Sample.txt
   notify:
       - restart apache
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/51.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 10.** Create a new playbook apache.yaml file under the top folder in the hierarchy with the following code (see screenshot below):

```yml
---
- name: Install and configure Apache
   hosts: local
   roles: 
      - role: apache
   become: true
```
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/52.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/53.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


**Step 11.** Enter the below command to execute the playbook apache, which installs Apache and configures the file in the location (/etc/Sample.txt). Since this file was configured for the first time, it notifies handler and Apache service is restarted. Subsequent execution of the playbook will not restart the service as there are no changes to the file. 

```ansible-playbook apache.yaml```

**Note:** If the file (Sample.j2) is updated in the templates folder then subseqent runs of ansible will restart apache service

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/54.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above execution output we can see that file was updated and the handler was notified to restart the service. Immediate execution of the playbook again will skip that step as the file is not being updated as shown below:

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible-playbook/images/55.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

### Conclusion:

Congratulations!

You have successfully completed this lab. In this learning lab we have learnt how to Create a VCN in Oracle Cloud and create multiple compute instances inside a VCN. We have learnt on how to install Ansible, How Ansible connects with other nodes to execute Ansible playbooks. We have created playbooks with in-built Ansible Galaxy tool and updated them to install multiple packages. We have learnt how to use multiple roles, variables and how to create handlers.
