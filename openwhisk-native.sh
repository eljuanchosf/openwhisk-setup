#! /bin/sh
#
# openwhisk-native.sh
# Copyright (C) 2016 juan <juanpgenovese@gmail.com>
#
# Distributed under terms of the MIT license.
#

set -e

OPEN_WHISK_HOME=~/workspace/openwhisk

# Database config
DB_USER=iamkyloren
DB_PASSWORD=ILoveYouGrandPa
DB_HOST=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
DB_PORT=5984

# Install dependencies
sudo add-apt-repository ppa:couchdb/stable -y
sudo apt-get update --fix-missing
sudo apt-get install git curl couchdb -y

# Add Docker's GPG
curl -fsSL https://get.docker.com/gpg | sudo apt-key add -

# Allow database access from everywhere. NOT READY for production.
sudo sed -i -- "s/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/g" /etc/couchdb/local.ini
sudo service couchdb restart
echo "Waiting for CouchDB to start..."
sleep 10

# Create the admin user
curl -X PUT http://$DB_HOST:$DB_PORT/_config/admins/$DB_USER -d '"'"$DB_PASSWORD"'"'
curl -X GET http://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/_config

# Create OpenWhisk directory
mkdir $OPEN_WHISK_HOME -p
cd $OPEN_WHISK_HOME

# Clone the repo
git clone https://github.com/openwhisk/openwhisk.git .

# Copy template and setup the database config for OW
cp template-couchdb-local.env couchdb-local.env
sed -i -- "s/OPEN_WHISK_DB_PROTOCOL=/OPEN_WHISK_DB_PROTOCOL=http/g" couchdb-local.env
sed -i -- "s/OPEN_WHISK_DB_HOST=/OPEN_WHISK_DB_HOST=$DB_HOST/g" couchdb-local.env
sed -i -- "s/OPEN_WHISK_DB_PORT=/OPEN_WHISK_DB_PORT=$DB_PORT/g" couchdb-local.env
sed -i -- "s/OPEN_WHISK_DB_USERNAME=/OPEN_WHISK_DB_USERNAME=$DB_USER/g" couchdb-local.env
sed -i -- "s/OPEN_WHISK_DB_PASSWORD=/OPEN_WHISK_DB_PASSWORD=$DB_PASSWORD/g" couchdb-local.env

# Create the basic DB structure
tools/db/createImmortalDBs.sh

# Install all the rest of the dependencies
cd tools/ubuntu-setup
./all.sh

cd $OPEN_WHISK_HOME

# Build, deploy and run
ant clean build deploy
