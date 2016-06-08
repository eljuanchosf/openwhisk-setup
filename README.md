# OpenWhisk Native Setup

The purpose of this repo is to have an automated script to setup OpenWhisk the simplest, fastest and easiest possible way.

## WARNING: ONLY FOR DEVELOPMENT PURPOSES

## How to use it

### AWS

1. Clone the repo.
2. `cd` into the cloned repo directory.
3. `terraform plan && terraform apply`
4. `ssh` into your EC2 instance
5. Run the `openwhisk-native.sh` file in the user's home directory.

The [Terraform](https://www.terraform.io/) provided script will create an EC2 instance and copy the `openwhisk-native.sh` file to the user's home directory. Also, it will create a security group with the necessary ports opened.

### Vagrant

1. Clone the repo.
2. `cd` into the cloned repo directory.
3. `vagrant up`
4. `vagrant ssh`
5. Run the `openwhisk-native.sh` file in the user's home directory.
