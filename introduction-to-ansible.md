# INTRODUCTION TO ANSIBLE

# Table of Contents

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Login to OCI Console](#login-to-oci-console)

[Create a VCN](#create-a-VCN)

[Create Public and Private SSH Keypair to Login to the Compute Instance](#create-public-and-private-ssh-keypair-to-login-to-the-compute-instance)

[Create a Compute Instance](#create-a-compute-instance)

[Login to the Compute Instance and Install Ansible](#login-to-the-compute-instance-and-install-ansible)

[Creating SSH Keys for Ansible to access other instances](#creating-ssh-keys-for-ansible-to-access-other-instances)

[create-ansible-playbook](#create-ansible-playbook)

[Conditions in Ansible](#conditions-in-ansible)

[Loops and Variables in Ansible](#loops-and-variables-in-ansible)

[Configuring Apache using Ansible](#configuring-apache-using-ansible)



## Overview

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

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/1.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Create a VCN

In this section, you will create a Virtual Cloud Network (VCN) within the OCI console.

**Step 1.** Click on the OCI Services Menu, Select Networking and choose Virtual Cloud Networking

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/2.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Please ensure you have the correct Compartment Selected. (Bottom Left of OCI console). 

Choose Compartment: {{compartment-name}}

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/ta69.PNG?sp=r&st=2020-03-31T05:20:47Z&se=2021-12-31T14:20:47Z&spr=https&sv=2019-02-02&sr=b&sig=TJoLWnTtgux3WdgboBrEAEcE8FS6bF8vca4nboi4FNU%3D)

**Step 3.** Click Create Networking Quickstart. Now click **VCN with Internet Connectivity** and click **Start Workflow**

**Step 4.** Fill out the details for Dialog Box that appears with the following information.<br>
     4.1 For the NAME, enter an easy to remember name, like for example, "my_vcn"<br>
     4.2 Ensure Create in Compartment is set to the right compartment.<br>
	 4.3 Enter a value for the CIDR block, for example 10.0.0.0/16<br>
     4.4 Enter a value for Public Subnet CIDR Block, for example 10.0.1.0/24<br>
     4.5 Enter a value for Public Subnet CIDR Block, for example 10.0.2.0/24<br>
     4.6 Click Next and then Click Create.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/ta68.PNG?sp=r&st=2020-03-31T04:29:47Z&se=2021-12-31T13:29:47Z&spr=https&sv=2019-02-02&sr=b&sig=fvUesivkSsBdS2JEi%2BYPAxo4OHDZKsd5vwJUnC%2BvLkQ%3D)

**Step 5.** A Virtual Cloud Network will be created and the name that was given will appear as the name of the VCN on the OCI Console.

## Create Public and Private SSH Keypair to Login to the Compute Instance

In this section we will create a public/private SSH key pair. These keys will be used to launch a Compute instance and connect to it.

**Step 1.** In the OCI Console Window, select the Apps icon and open git-Bash. A Git-Bash terminal will appear.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/5.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Enter the command ssh-keygen in git-bash window.

```
ssh-keygen
```

**TIP:**
You can swap between the OCI window and any other application (git-bash etc.) by clicking the Switch Window icon beside apps icon. 

 
**Step 3.** Press "Enter", when asked for the following:

 a) Enter file in which to save the key 

 b) Enter passphrase

 c) Enter passphrase again

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/6.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** You should now have the Public and Private keys generated.They can be found in<br> 
             /C/Users/PhotonUser/.ssh/id_rsa (Private Key)<br>
             /C/Users/PhotonUser/.ssh/id_rsa.pub (Public Key)

**Note:**<br>
       id_rsa.pub will be used to create the Compute instance and id_rsa to connect via SSH into the Compute instance.<br>
       Run 'cd /C/Users/PhotonUser/.ssh' (No Spaces in directory path) and then 'ls' to verify the two files exist.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/7.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** In the git-bash terminal window, type cat /C/Users/PhotonUser/.ssh/id_rsa.pub, Highlight the SSH key and copy (using the mouse or the keyboard (ctrl-c)

```
cat /c/Users/PhotonUser/.ssh/id_rsa,pub
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/8.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** In the OCI Console Window, click the Apps icon  and click Notepad. 

**TIP:**
You can swap between the OCI window and any other application (Notepad etc.) by clicking the Switch Window  icon.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/9.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 7.** Paste the public key in Notepad (using your mouse/touch pad or Ctrl v).

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/10.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 8.** Minimize Notepad and git-bash (if open) windows.

We now have a Public/Private SSH key pair. Next we will
create a compute instance using the public key we just saved.

## Create a Compute Instance

In this section we will create a Compute instance with a Public IP address using the public SSH key generated in the previous section.

**Step 1.** Switch to OCI console (if not already).

**TIP:** You can swap between the OCI window and any other application (git-bash etc.) by clicking the Switch Window icon beside apps icon. 

**Step 2.** Click on the OCI Services Menu, Select Compute and choose Instances

**Step 3.** Click Create Instance. Fill out the dialog box:

 3.1 Name: Enter a name (e.g. "Ansible_VM").

 3.2 Availability Domain: Select the first available domain.

 3.3 Image Operating System: For the image, we recommend using the Latest Oracle Linux available.

 3.4 Shape: Select VM.Standard.E2.1 (1 OCPU, 7GB RAM).

 3.5 SSH Keys: Select the PASTE SSH KEYS radio button and Paste the Public Key you saved in Notepad in the previous section.

You can swap between the OCI window and any other application (notepad etc.) by clicking the Switch Window icon beside apps icon. 

 3.6 Virtual Cloud Network: Select the VCN you created in the previous section.

 3.7 Subnet: Select the first available subnet.

 3.8 Click Create Instance.

**Note:** Leave other options in the dialog box as is other than the options mentioned above. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/11.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Once Instance is in Running state, note down the public IP address.
 
**Tip:** We recommend writing down the IP address in a notepad for future use.

 
**Step 5.** You can also that instance has now been provisioned and is in Running state.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/12.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

We now have a Compute instance with a Public IP address running in OCI.

Next we will SSH to the compute instance from the internet.

## Login to the Compute Instance and Install Ansible

In this section we will SSH into the Compute instance using its Public IP address and private SSH key to Install and Configure Ansible. 

**Step 1.** Bring up a new git terminal or switch to the existing one (if you still have it open).

**Tip:** 

If the terminal was closed simply launch a new one using the Apps icon .

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/13.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
 
 **Step 2.** In the git-bash Terminal Window Type the command

```
cd /C/Users/PhotonUser/.ssh/
```

Type ls and verify the id_rsa file exists.
       

**Tip:** No Space in directory path (/C/Users/PhotonUser/.ssh).

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/14.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** To login to the running instance, we will SSH into it. Type the command            

```bash
ssh -i id_rsa opc@<PUBLIC_IP_OF_COMPUTE_INSTANCE>
```

**Note:** User name is â€˜opcâ€™. <PUBLIC_IP_OF_COMPUTE_INSTANCE> should be the actual IP address which was noted in previous section. (Example: 129.0.1.10)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/15.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Enter `yes` when prompted for security message. 
**Step 5.** Verify the prompt shows 

 ```opc@<YOUR_VM_NAME>``` (below example shows the command prompt for Compute instance)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/16.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.**  We now have a Compute instance in OCI with a Public IP  address which is accessible over the internet. 

**Step 7.** The "sudo" command allows user to run programs with elevated privileges and "su" command allows you to become another user. Running the following command will default to root account(system administrator account) which allows installing and configuring ansible using yum package manager.

```
sudo su -
```

```
yum install -y ansible
```
 
**Note:** Along with Anisble package, multiple pre-requisite packages are being installed which takes a couple of minutes.

**Step 8.** Ansible has a default inventory file created which is located at "/etc/ansible/hosts". Inventory file contains a list of nodes which are managed/configured by ansible.

It is always a good practice to back up the default inventory file to reference it in future if required.

Run the following commands to move and create a new inventory file

```
sudo mv /etc/ansible/hosts /etc/ansible/hosts.orig
```

```
sudo touch /etc/ansible/hosts
```

```
vi /etc/ansible/hosts
```
 
**Note:** In this tutorial by default "vi" text editor is used to update files.

To learn vi text editor "https://ryanstutorials.net/linuxtutorial/vi.php"

Any other user preferred text editor can be used to update files.

**Step 9.** Update the created hosts file in the step 8 with the following data

```
[local]
127.0.0.1
```
Step 10. In the Step 9, we have added local server's ip address(127.0.0.1) to the hosts inventory file, ansible uses the host file to SSH into the servers and run the required ansible jobs.

Step 11. To validate Ansible is installed and configured correctly, run the following command

 ```
 ansible --version
 ```

**Note:** It is ok, if the above command returns different version of ansible. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/17.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Creating SSH Keys for Ansible to access other instances

In this section, We will create a public and private SSH key pairs for ansible control machine to SSH into the nodes defined in inventory file.

Ansible control machine is a server on which ansible is installed and executes ansible tasks on the managed nodes.

An inventory file is a list of managed nodes which are also called "hosts". Ansible is not installed on managed nodes.

**Step 1.** In the terminal, enter the command "ssh-keygen".

Press "Enter", when asked for the following 

 a) Enter file in which to save the key 

 b) Enter passphrase

 c) Enter passphrase again

**Tip**
No Passphrase is required.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/18.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Public and Private keys should have been generated and are stored in the directory /root/.ssh/. Public key need to be copied to authorized keys file, which gives ansible access to login into the managed node.

**Note:**
In this example Ansible control machine and the managed node is the same server. If authorized_keys file is already available, overwrite it with the public key or a new file is generated.


Execute the following commands to copy the public key

```
cd /root/.ssh
```

```
cp id_rsa.pub authorized_keys
```

Enter "yes" when promted to overwrite authorized_keys file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/19.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


**Step 3.** Check to see if Ansible is able to connect to the servers, defined in the inventory file that was created in the previous section. 

Execute the following command which pings the servers in the inventory file.

```
ansible all -m ping
```

Enter "yes" when prompted to add server ip to the known_hosts file. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/29.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Above command pings the servers defined in the inventory file that is created in the previous steps. Since only local machine is added in the inventory file ansible does a ping on the local machine using the SSH key created. 

## create-ansible-playbook

In this section, We will learn what an ansible playbook is and how to create and execute a playbook which installs a package on the server.

Ansible Playbook are the files where ansible code is written. They are written in YAML format. Playbooks contains the tasks which the user wants to execute on a particular machine. Multiple tasks can be specified in a playbook which are executed sequentially.

**Important:-**
Both Ansible control machine and managed node are same in this tutorial. All the packages that are being installed and managed are done on the same machine. 

**Step 1.** Create a folder named Ansible and store all the playbooks that are required in this tutorial. Create a YAML file inside the folder using the following commands

```
mkdir /root/ansible
```
```
cd /root/ansible
```
```
vi install_package.yaml
```

**Step 2.** Copy/Type the following code into the created install_package.yaml file 

```yml
---
- hosts: local
  tasks:
    - name: install htop
      yum: name=htop state=latest
```

**Step 3.** In the above code, hosts section is mandatory to determine where the playbook needs to be executed. This can be a server name or a group of servers that are defined in the inventory file(created in previous section).  A group named local was defined in the inventory file in the previous section. Ansible runs this playbook on the servers defined under local group. 

**Note:**
Before installing htop with ansible. Check if htop is already installed on a server and remove if it is installed using the following commands

Uninstall htop package - 

```
yum -y remove htop
```

**Step 4.** Run the command "ansible-playbook -s install_package.yaml". Ansible checks the inventory file for the local group and installs the package htop with latest version on the servers. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/21.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** From the output, there were 2 tasks run in the playbook , first is gathering facts. Ansible gathers facts of the server on which playbook is running and then executes the tasks defined in the playbook which is installing htop package. 

**Step 6.** To validate if htop is installed on the server, type the command "htop --version". If a package with specific version needs to be installed then update the code in install_package.yaml file with the required package and the version of the package.

To list all the versions of httpd package available, execute the command "yum list httpd" and copy the version 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/22.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

```yml
example: 

- name: install one specific version of Apache
  yum:
     name: httpd-2.4.6-8-.0.1.el7_5.1
     state: present
```
**Step 7.** Multiple tasks can be defined in a single playbook, all the tasks are executed in a sequencial fashion. Like install a package, update the configuration of the package and start the service. All the 3 steps defined are executed in a sequencial fashion.

In the below example we are installing wget and telnet packages that are installed sequencially.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/23.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Conditions in Ansible

In this section, we will learn how Ansible conditions work and how they can be used inside Ansible playbooks to perform conditional tasks. Sometimes for a task to execute, it may depend on the output of a previous task or a defined variable or a fact of the system, the playbook is running on. 

In this example, we will check the system facts, see if a specific package is available and or if it is installed and if not, install it.

**Step 1.** Create a new file condition.yaml with the command "touch /root/ansible/condition.yaml"

**Step 2.**  Ansible collects the facts before executing a playbook on the server. These facts are the attributes of the machine.

To list all the default facts of the machine run the following code:

```
ansible -m setup local
```

This command prints all the facts that ansible collects about the machine. If you want it to display single fact, use grep.

The following command displays ansible distribution facts which playbook collects before execution: 

```
ansible -m setup local | grep ansible_distribution
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/24.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** Create a new file with the command "touch /root/ansible/condition.yaml". Add the following code into condition.yaml file. 

**Note:**
Remove wget package if it is already installed on the server using "yum -y remove wget"

```yml
---
- hosts: local
  tasks:
    - name: Check if package wget is installed on the server
      yum:
        list=wget
      register: installedpkg

    - name: Show output of the registered value
      debug: var=installedpkg.results[0].yumstate
```
**Step 4.** First task in the above code checks to see if the package is installed and registers the result into a variable "installedpkg". Second task prints the value stored in the variable. Run the following command to execute the playbook.

```
ansible-playbook -s condition.yaml
```
 
 ![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/25.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** Since the package state is "available" and not "installed", we can write a condition, to check if the package is installed else install the package. Update the code with the following 

```yml
---
- hosts: local
  tasks:
    - name: Check if package wget is installed on the server
      yum:
        list=wget
        register: installedpkg

    - name: Show output of the registered value
        debug: var=installedpkg.results|selectattr("yumstate","match","installed")|list|length

    - name: Install package wget if it is not installed
        yum:
          name=wget
          state=installed
        when: installedpkg.results|selectattr("yumstate", "match", "installed")|list|length == 0
```

**Step 6.** The above code checks to see if the package is installed and gets the length of the package installation results. If the package is installed then the length will be greater than 0.

**Step 7.**  In the last task of the playbook, we check the length to validate if the package needs to be installed. 

Run the command 

```
ansible-playbook -s condition.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/26.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 8.** In the last task of the output, wget is installed, if the same playbook is executed again , it skips the last step as the package is already installed which is shown in the following screenshot.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/27.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Loops and Variables in Ansible

In this section, we will discuss about the variables and loops in Ansible playbooks. Loops are used if a same task needs to be executed multiple times like creating multiple users, installing multiple packages etc.

**Step 1.** Update the playbook install_package.yaml that is created in the previous sections with the following code

**Note:** Remove packages if they are already installed using the command ```yum -y remove wget telnet htop```

**Step 2.** Packages are defined in a list variable and the variable is used in the task to install multiple packages at the same time. With_items iterates overs the list variable "packages" and stores the value in a temperory variable "item". Yum task is executed on each item from the packages variable. 

**Step 3.** If the packages are already installed on the server, Ansible skips installation of the specific package, to validate the playbook installs the required packages, they can be removed with the command

```
yum remove -y wget telnet htop
```

**Step 4.** Execute the playbook using the below command to install the packages.

```
ansible-playbook -s install_package.yaml
``` 


![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/28.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** All the packages are installed on the server. To verify if the package is installed run the command:

```
yum list <<package_name>>
```

## Configuring Apache using Ansible

In this section, we will install Apache on the server, Update the configuration of Apache using the template and start the Apache server. 

**Step 1.** Create a new file using the command "touch /root/ansible/httpd.yaml" and "touch /root/ansible/index.html"

**Step 2.**  Update index.html file with the following code

**Step 3.** Update httpd.yaml file with the following code

**Step 4.** Run the following command to execute the playbook httpd.yaml. This playbook installs Apache, updates a file and start Apache service. 

```
ansible-playbook -s httpd.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/introduction-to-ansible/images/29.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** We have created a template and updated the template for the index file of httpd. To validate if the created file is available, check the file with the command:

```
cat /usr/share/httpd/noindex/index.html
```


Conclusion:

Congratulations!

You have successfully completed the Introduction to Ansible lab! In this tutorial we have Created a VCN (Virtual Cloud Network) in Oracle cloud and Created a compute instance inside the VCN. We have create SSH keypair which is used to login into the compute instance. We have logged into the instance using the Keypair that was created. 

We have learnt basics of Ansible on how to install Ansible and manage the configuration using Ansible. We have used Ansible playbooks to install multiple packages, store values inside variables, loops and conditions in Ansible. Finally we have installed and configured apache on a server and started the Apache service. 

Feel free to continue exploring or start a new lab. 

Thank you for taking this self-paced lab!
