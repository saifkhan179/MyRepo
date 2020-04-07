# ADVANCED ANSIBLE PLAYBOOKS

[Overview](#overview)

[Pre-Requisites](#pre-requisites)

[Login to OCI Console](#login-to-oci-console)

[Create a VCN](#create-a-VCN)

[Create Public and Private SSH Keypair to Login to the Compute Instance](#create-public-and-private-ssh-keypair-to-login-to-the-compute-instance)

[Create a Compute Instance](#create-a-compute-instance)

[Login to the Compute Instance and Install Ansible](#login-to-the-compute-instance-and-install-ansible)

[Creating SSH keys](#creating-ssh-keys)

[Asynchronous actions and polling of a task in Ansible Playbook](#asynchronous-actions-and-polling-of-a-task-in-ansible-playbook)

[Task Delegation](#task-delegation)

[Blocks for error handling in Ansible Playbooks](#blocks-for-error-handling-in-ansible-playbooks)

[Encrypt sensitive data using Vaults](#encrypt-sensitive-data-using-vaults)
## Overview

Welcome to the Advanced Ansible Playbooks Learning Lab on OCI from Sysgain!

Ansible Playbooks are an organized unit of scripts that is used for server configuration management by the automation tool Ansible. Ansible Playbooks are used to automate the configuration of multiple servers at a time. Playbooks are written in YAML format.

Playbook contains one or more plays/tasks which executes a simple command or a script. Every playbook has an attribute hosts, where servers or group of servers are defined. These plays are executed in sequencial manner on the servers defined in the playbook.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/1.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

It is possible to run several hundreds of tasks in a single playbook, but it is efficient to reuse a task multiple time in multiple playbooks so tasks or group of tasks can be organized into roles. These roles can be included into a playbook. In this tutorial we will learning about how the tasks in a role are executed in asynchronous mode and how they can be polled later during the playbook execution.

We will learn about task delegation to another server, for example in a playbook certain tasks can be executed on a different server than the server on which playbook is executed. We will learn about how to use blocks for error handing in a playbook and to encrypt sensitive data using Ansible Vault feature. 

Click Start above to begin the lab!

## Pre-Requisites
1) Basic knowledge of Linux servers

2) YAML language

3) SSH private/public key knowledge

4) Basic knowledge of ansible.

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

**Tenancy Name:** {{tenancy-name}}<br>
 **OCI login_ID:** {{oci-login-id}} <br>
 **OCI login_Password:** {{oci-login-password}}<br>
 **Compartment Name:** {{compartment-name}} <br>

**Note:** Your password should be updated automatically for you, but sometimes  you may be asked to change it after signing in the first time. If prompted, pleaseupdate the password. You can use this one to expedite things: Oracle123!!!! . It will not be saved after this lab expires.

**Step 2.** Reduce the Browser Display Window Size/Resolution to fit your needs(Below example is for Chrome). 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/2.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Create a VCN

In this section, you will create a Virtual Cloud Network (VCN) within the OCI console.

**Step 1.** Click on the OCI Services Menu, Select Networking and choose Virtual Cloud Networking

 ![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/3.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Please ensure you have the correct Compartment Selected. (Bottom Left of OCI console). 

Choose Compartment:  {{compartment-name}}

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

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/6.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

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

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/7.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** You should now have the Public and Private keys generated.They can be found in<br> 
             /C/Users/PhotonUser/.ssh/id_rsa (Private Key)<br>
             /C/Users/PhotonUser/.ssh/id_rsa.pub (Public Key)

**Note:**<br>
       id_rsa.pub will be used to create the Compute instance and id_rsa to connect via SSH into the Compute instance.<br>
       Run 'cd /C/Users/PhotonUser/.ssh' (No Spaces in directory path) and then 'ls' to verify the two files exist.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/8.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 5.** In the git-bash terminal window, type 

```
cat /C/Users/PhotonUser/.ssh/id_rsa.pub
```

Highlight the SSH key and copy (using the mouse or the keyboard (ctrl-c)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/9.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** In the OCI Console Window, click the Apps icon  and click Notepad. 

**TIP:**
You can swap between the OCI window and any other application (Notepad etc.) by clicking the Switch Window  icon.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/10.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 7.** Paste the public key in Notepad (using your mouse/touch pad or Ctrl v).

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/11.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

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

  3.4 Shape: Select VM.Standard1.1 (1 OCPU, 7GB RAM).

  3.5 SSH Keys: Select the PASTE SSH KEYS radio button and Paste the Public Key you saved in Notepad in the previous section.

**TIP:** You can swap between the OCI window and any other application (notepad etc.) by clicking the Switch Window icon beside apps icon. 
<br>
  3.6 Virtual Cloud Network: Select the VCN you created in the previous section.

  3.7 Subnet: Select the first available subnet.

  3.8 Click Create Instance.

**Note:** Leave other options in the dialog box as is other than the options mentioned above. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/12.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Follow the step 2 and 3 again to create another instance.

**Step 5.** Once both the Instances are in ‘Running’ state, note down the public IP addresses.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/13.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)
![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/14.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 6.** You can also see that instances has now been provisioned and are in Running state.

We now have two Compute instances with a Public IP addresses running in OCI.
Next we will SSH to the compute instance from the internet.

## Login to the Compute Instance and Install Ansible

In this section we will SSH into one of the Compute instances using its Public IP address and private SSH key to Install and Configure Ansible. This instance acts as a Ansible Control Machine and the other as a node.

**Note:** One server can randomly be selected to be Ansible Control Machine.

**Step 1.** Bring up a new git terminal or switch to the existing one (if you still have it open).

**Tip:** If the terminal was closed simply launch a new one using the Apps icon .

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/15.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** In the git-bash Terminal Window Type the command:

```
cd /C/Users/PhotonUser/.ssh/
```

Type ls and verify the id_rsa file exists.

**Tip:** No Space in directory path (/C/Users/PhotonUser/.ssh).

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/16.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** To login to the running instance, we will SSH into it. Type the command:

```
ssh –i id_rsa opc@<PUBLIC_IP_OF_COMPUTE_INSTANCE_1>
```

**Note:** User name is ‘opc’. <PUBLIC_IP_OF_COMPUTE_INSTANCE_1> should be the actual IP address which was noted in previous section for example:  129.0.1.10 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/17.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Enter ‘yes’ when prompted for security message. 

**Step 5.** Verify the prompt shows 

 ```
 opc@<YOUR_VM_NAME>
 ``` 
 (below example shows the command prompt for Compute instance)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/18.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)


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

```
sudo mv /etc/ansible/hosts /etc/ansible/hosts.orig
```
```
sudo touch /etc/ansible/hosts
```
```
vi /etc/ansible/hosts
```
In this tutorial by default "vi" text editor is used to update files.

To learn vi text editor "https://ryanstutorials.net/linuxtutorial/vi.php"

Any other user preferred text editor can be used to update files.

**Step 11.** Update the created hosts file in the step 8 with the following data:

```
[local]
127.0.0.1
[webserver]
<<ipaddress of second server>>
 ```

**Step 12.** In the Step 11, we have added local server's ip address (127.0.0.1) and the second server (public IP address) to the hosts inventory file, Ansible uses the host file to SSH into the servers and run the requiredAansible jobs.

**Step 13.** To validate Ansible is installed and configured correctly, run the following command:

```
ansible --version
```

**Note:** It is ok, if the above command returns different version of ansible. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/19.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Creating SSH keys

In this section, we will create a public and private SSH key pairs for ansible control machine to SSH into the nodes defined in inventory file.

Ansible control machine is a server on which Ansible is installed and executes Ansible tasks on the managed nodes.

An inventory file is a list of managed nodes which are also called "hosts". Ansible is not installed on managed nodes.

**Step 1.** In the terminal of Ansible Control Machine (where ansible is installed), enter the command 

```
ssh-keygen
```

Press "Enter", when asked for the following:

a) Enter file in which to save the key 

b) Enter passphrase

c) Enter passphrase again

**Tip:** No Passphrase is required.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/20.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 2.** Public and Private keys should have been generated and are stored in the directory /root/.ssh/. Public key need to be copied to authorized keys file, which gives Ansible access to login into the managed node.

**Note:** In this example Ansible control machine and the managed node is the same server. If authorized_keys file is already available, overwrite it with the public key or a new file is generated.


Execute the following commands to copy the public key:

```
cd /root/.ssh
```
```
cp id_rsa.pub authorized_keys
```

Enter "yes" when promted to overwrite authorized_keys file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/21.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 3.** Open authorized_keys and copy the data using the following command:

```
cat /root/.ssh/authorized_keys
```
            
Highlight the SSH key and copy (using the mouse)

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/22.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Step 4.** Open the terminal of the second server. We need to paste the copied public key to the authorized keys file in the second server. Follow the steps to copy the public key:

**Tip:** You can swap between the OCI window and any other application (Notepad etc.) by clicking the Switch Window icon.

```
sudo su -
```
```
cd /root/.ssh/
```
```
vi authorized_keys​
```
Copy the key into authorized_keys file 
 
![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/23.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

**Note:** The public key needs to be copied into authorized_keys file in all servers(nodes) so that ansible control machine can SSH into the machines.

**Step 5.** In the Ansible Control Machine, Check to see if Ansible is able to connect to the servers, defined in the inventory file that was created in the previous section. Execute the following command which pings the servers in the inventory file.

```
ansible all -m ping
```

Enter "yes" when prompted to add server ip to the known_hosts file. You might need to type twice as 2 hosts are added to the known_hosts file.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/24.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Above command pings the servers defined in the inventory file that is created in the previous steps. Since only local machine is added in the inventory file ansible does a ping on the local machine using the SSH key created. 

## Asynchronous actions and polling of a task in Ansible Playbook

All the tasks in a playbook by default are executed synchronously. Tasks in a playbook that are not related to each other can be run asynchronously to avoid blocking or timeout issues. In Asynchronous mode all the tasks are executed at once and then poll until they are completed. In asynchronous mode maximun runtime of a task and how freqently you would like to poll need to be specified. 

Step 1. Create a folder named Ansible and store all the playbooks that are required in this tutorial. Create a YAML file inside the folder using the following commands

```
mkdir /root/ansible
```
```
cd /root/ansible
```
```
vi async.yaml
```

Step 2. Copy the following code into the created async.yaml file 

```
---
- hosts: local
  tasks:
    - name: Sleep for 15 sec
      command: /bin/sleep 15
      async: 45
      poll: 0

    - name: Install wget
      yum:
        name: wget
        state: installed
      async: 60
      poll: 0
      become: true
```

Step 3. In the above code, hosts section is mandatory to determine where the playbook needs to be executed. If async keyword is not defined in the playbook, the task runs synchronously, specify the maximum time for async keywork for the command to execute in asynchrous mode, poll value determines the number of seconds the tasks waits before moving to the next task. Default value of poll is 10 seconds. Specify the value of poll to 0 for the execution to move forward without waiting for the task to complete.

**Note:** Operation that require locks should not be attempted to run with poll value 0 if you want to run other tasks in the playbooks that requires same resources. 

Step 4: Run the command to execute the playbook

```
ansible-playbook async.yaml
```

You can see that the execution of the playbook does not stop for 15 seconds but completes the playbook execution.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/25.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

To validate that wget is installed on the server, type wget and check that wget command is available and asking for URL. 

Step 5. Asynchronous tasks can be checked later in the playbook if the task has been completed. Update the file with the following code. 

```
---
- hosts: local
  tasks:
    - name: sleep for 30 seconds
      command: /bin/sleep 30
      async: 1000
      poll: 0
      register: yum_sleeper

    - name: check on asyn task
      async_status:
        jid: "{{ yum_sleeper.ansible_job_id }}"
      register: job_result
      until: job_result.finished
      retries: 10
```

Execute the playbook with the command **```ansible-playbook async.yaml```**

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/26.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Step 6. In the above execution, the task when was performed asynchronously was to sleep for 30 seconds. In the next task we checked to see if the above task was completed. Status of the command "Sleep 30 seconds" were tried for 5 times before it finished the task.

## Task Delegation

In this section, we will learn about task delegation. In a playbook, if a perticular task needs to be performed on another host, "delegate_to" keyword can be used. This remote execution of a task is part of a playbook and is executed on another specified host.

Step 1: Create a new file under the folder ansible with the following command

touch /root/ansible/delegation.yaml
Update the above created file with the code 

```
---
- hosts: local
  tasks:
    - name: install wget
      yum:
        name: wget
        state: installed
      delegate_to: ansiblenode
```

Step 2.  In the above code we run this playbook on local host which is mentioned in the hosts section on the play. But since this task is being delegated to the node "ansiblenode" which was defined in the host section. This task is executed on the ansible node and wget is installed on ansible node.

Step 3. Execute the playbook with the command 

```
ansible-playbook delegate.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/27.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

As we can see in the execution output that the task was delegated to a different node and wget was installed on remote machine.

Step 4. By default, Ansible will manage all the machines referenced in a play in parallel. If the playbook needs to be executed in rolling update use case. It can be managed by using "serial" keyword in the play. Ansible uses the number specified in the keyword and executes those many servers in parallel. 

Step 5. Update the delegate.yaml file with the following code, to run the playbook in rolling update for each server.

```
---
- hosts: all
  tasks:
    - name: install wget
      yum:
        name: wget
        state: installed
  serial: 1
```

In the above code we defined serial as 1 which states that only 1 server is executed at a time. 

Step 6.  Execute the playbook with the following command 

```
ansible-playbook delegate.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/28.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

In the above execution output, first wget is installed in the local machine and then it is installed on the remote machine. 

Rolling update can even be defined, if there are different batch of servers that needs to be executed for example

```
- name: batch execution
  hosts: all
  serial:
    - 1
    - 5
    - 10 
```

In the above code the task is executed in baches, the first batch would contain a single host, the next would contain 5 hosts, and the remaining batches would contain 10 hosts untill all the available hosts completes task execution. 

## Blocks for error handling in Ansible Playbooks

Blocks allow for logical grouping of tasks and in play error handling. Multiple tasks are grouped into a section named "blocks" and if any of the tasks in the block fails, "rescue" section tasks are executed. The section "always" is executed everytime irrespective of an error either in the block or rescue section.

Step 1: Create a new playbook under the folder ansible with the following command

```
touch /root/ansible/blocks.yaml
```

Update the created file with the following code

```
---
- hosts: local
  tasks:
    - name: Attempt and graceful rollback 
      block:
        - debug:
             msg: 'I execute normally'
        - command: /bin/false
        - debug:
             msg: 'I never execute, due to the above failing command'
      rescue:
        - debug:
             msg: 'I caught an error'
      always:
        - debug:
             msg: ' I always execute'
```

In the block section, "command: /bin/false"  fails to execute and the execution is transferred to the rescue section, where all the tasks under it are executed before proceeding to "always" section.

Step 2.  Execute the playbook with the command 

```
ansible-playbook blocks.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/29.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D) 

In the above execution output, we can see that the tasks executed after the error are in the "rescue" section and "block" section.

Step 3. We will update the file "blocks.yaml" with the following code so that it passes execution in the "block" section and continous to execute "always" section.

```
---
- hosts: local
  tasks:
    - name: Attempt and graceful rollback 
      block:
        - debug:
             msg: 'I execute normally'
        - command: /bin/true
      rescue:
        - debug:
             msg: 'I caught an error'
      always:
        - debug:
             msg: ' I always execute'
```

Changing the command from "/bin/false" to "/bin/true" will pass execution in the block section and always section code is executed. 

Step 4.  Execute the playbook with the command 

```
ansible-playbook blocks.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/30.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

## Encrypt sensitive data using Vaults

In this section, we will learn about Ansible vault and how it is used to encrypt sensitive data(usernames and passwords). Ansible vault is a feature of ansible which can encrypt any structured data file used by Ansible. In the steps below, we will see how a playbook can be encrypted with a password and how the encrypted playbooks are executed. 

Step 1: Create a new file  "encrypt.yaml" under the folder ansible with the command

```
touch /root/ansible/encrypt.yaml
```

Step 2: Update the file "encrypt.yaml" file with the following code 

```
---
- hosts: local
  tasks:
    - name: Print Username and password
      debug:
        msg: ' Username is Sysgain123 and Password is Ansible123'
```

In this above file Username and Password are sensitive data and cannot be stored as a plain text. Ansible vault feature helps us to encrypt the playbook.

Step 3: Encrypt the playbook with the following command

```
ansible-vault encrypt encrypt.yaml
```

In the above command, ansible-vault is a feature of ansible, encrypt is the keyword used to encrypt a file and encrypt.yaml is the filename which is being encrypted. 

Command prompts to enter the password, type the password and type "Enter".  Type the same password again when asked to confirm. 

**Note:** Password that is being entered is not visible.

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/31.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Step 4. Open the encrypted file and it looks similar to the following image

```
vi /etc/ansible/encrypt.yaml
```

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/32.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Step 5. Execute the playbook with the following command

```
ansible-playbook encrypt.yaml --ask-vault-pass
```

The above command prompts for a password and type the same password used to encrypt the file. Ansible decrypts the file and the playbook is executed. 

![](https://qloudableassets.blob.core.windows.net/devops/OCI/advanced-ansible-playbooks/images/33.jpg?st=2019-09-06T10%3A31%3A31Z&se=2022-09-07T10%3A31%3A00Z&sp=rl&sv=2018-03-28&sr=c&sig=fwljWymO6LKz5xubtKh3mAsK3r858hNP%2Bl6%2FtadP4MM%3D)

Step 6. If the playbook needs to be updated it can be decrypted using the following command and the passord provided during encryption.

```
ansible-vault decrypt encrypt.yaml
```

The above command decrypts the file into normal text file. It can be encrypted again either with the same password or a new password. 

You have successfully completed this tutorial. In this Training lab we have learnt how to Create a VCN in Oracle Cloud and create multiple compute instances inside a VCN. We have learnt on how to install Ansible, How Ansible connects with other nodes to execute ansible playbook. 

We have learnt about Asynchrouns actions and polling of tasks, task delegation to a different server, blocks for error handing and encryption of sensitive data. 
