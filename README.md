# 🚀 EKS Setup by Terraform — Lesson 1  

**From Zero to Production Ready Kubernetes Cluster on AWS — Prerequisites Installation & Setup**  

🎯 **Goal of Lesson 1**  
By the end of this episode, you will have all the essential tools installed, configured, and tested to start your EKS journey.  

---

## 📌 Prerequisites to Install
We’ll install and verify the following tools:

1. **AWS CLI**           – To interact with AWS services from your terminal.  
2. **Terraform**         – Infrastructure as Code tool to provision EKS and AWS resources.  
3. **kubectl**           – Command-line tool to manage Kubernetes clusters.  
4. **eksctl (Optional)** – CLI to simplify certain EKS operations (handy for debugging or quick setups).

---

## 1️⃣ Install AWS CLI

Note: You must have Python 3.8 or later installed.

### **Linux** & **MAC**

To Install Latest Version: 

```bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

For a specific version:

```bash
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle-1.16.312.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
```

Verify that the AWS CLI installed:

```bash
aws --version
```

### **Windows**

Installing, Updating, and Uninstalling the AWS CLI version 1 on Windows [AWS CLI Installer]
(https://docs.aws.amazon.com/cli/v1/userguide/install-windows.html).



## Verify that the AWS CLI installed:

```bash
aws --version
```


## 2️⃣ Install Terraform

### Follow this installation guide for different OS
https://developer.hashicorp.com/terraform/install

### **Linux**

First, system needs up-to-date and installed packages, which are needed for Installation.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
```

Next, add the Hashicorp GPG key needed by the repository

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

Add the official repository for HashiCorp

```bash
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

Now that we have added the repo to the list, let’s update to add the relevant repository content:

```bash
sudo apt-get update
```

Install Terraform:

```bash
sudo apt-get install terraform
```

That should complete the installation. 



## 3️⃣ Install kubectl

### Follow the Installation Guide

https://v1-32.docs.kubernetes.io/docs/tasks/tools/


```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Test to ensure the version you installed is up-to-date

```bash
kubectl version --client
```


## 4️⃣ (Optional) Install eksctl

https://eksctl.io/installation/