# Infrastructure as Code for Newsfeed App
This project is intended to setup Google Cloud Test Environment and deploy the microservices of Newsfeed. It includes the following parts:

- Google Cloud  
- Packer 
- Terraform
- Deployment 
You need clone this repo in your laptop and operate the following steps in the directory.
## Google Cloud

### Sign Up and SDK Installation 
 
[Sign up](https://cloud.google.com/free/) Google to Cloud account and follow the [instruction](https://cloud.google.com/sdk/) to install Google Cloud SDK and initialise it. Please note you need to create a project which will be used for following steps. 

### Configuration 
Use the following gcloud command to acquire new user credentials to use for Application Default Credentials.

```
gcloud auth application-default login
```  
Set a default compute region:

```
gcloud config set compute/region europe-west1
```

Set a default compute zone:

```
gcloud config set compute/zone europe-west1-b
```
### Create SSH Key Pair 

Generate an SSH key pair for connections to the VM instances on Goole Cloud, it will allow user to ssh into VM instances with username `developer`.

```
ssh-keygen -t rsa -f ~/.ssh/developer -C developer -P ""
```

Create an SSH public key for your project:

```
gcloud compute project-info add-metadata --metadata ssh-keys="developer:$(cat ~/.ssh/developer.pub)"
```

## Packer 
Packer allow the user to create customized VM image with pre-installed required package.

### Installation
Download [Packer](https://www.packer.io/downloads.html) and move it in your `PATH` directory.

### Configure and Run Packer 
Edit the script `./packer/news-feed-base-image.json`, change the `example_poject` to be the project you created by `gclound init` in previous step and save it.  

Run the following command to build the image.
```
packer build ./packer/news-feed-base-image.json
```
A new image will be created named by news-feed-base-image

## Terraform 

Terraform is the tool can describe the VM instance and configure it with pre-defined property e.g firewall, ssh key etc. We will use Terraform to create VM instance based on the image created in the last step.

### Install Terraform 
Download [Terraform](https://www.terraform.io/downloads.html) and move it to your `PATH` directory.

### Configure and Run Terraform

Edit the script `./packer/main.tf`, change the `example_poject` to be the project you created by `gclound init` in previous step and save it.
 
Run the following command to initialise Terraform:

```
  cd ./terraform && terraform init
```

Run the following command to use terraform to launch the VM instance:

```
terraform apply
```

It will return the VM instance public ip, you can connect to it by `ssh developer@<instance_public_ip>`

## Deployment 
Run the following command to copy the `deploy` folder to the VM instance:


```
INSTANCE_ADDRESS=$(gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)" compute instances describe  newsfeed-instance-1)

scp -r ./deploy developer@${INSTANCE_ADDRESS}:
```

Log in to VM Instance by:

```
ssh developer@${INSTANCE_ADDRESS}
```

Run the following command:

```
cd deploy/ && sudo  chmod a+x deploy.sh
```

Deploy the microservice by 

```
sudo ./deploy.sh 

```


During the deployment, the git repo of source code will be pulled and three java services are build. The java services will be run in three separate docker containers which are configured by docker composer. The java services read the environment variables defined in VM instance `/home/developer/infra-problem/build/docker-compose.yml`. 

The services can be rebuild and restart by `sudo docker-compose restart`. 


