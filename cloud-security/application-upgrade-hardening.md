Upgrade from Release v.1.0.4 to Release v.1.0.5
Overview
This document contains step-by-step instructions to upgrade ApplicationX Central Server and related services on Cloud Platform from release v.1.0.4 to v.1.0.5.
Updated components in release v.1.0.5 include:
•	Webservice v.1.5.30 (webservice.1.5.30.tar)
•	Central v.1.0.6 (central.1.0.6.tar)
•	DB Tools v.1.5.16 (dbtools-1.5.16.zip)
•	Mirth Channels (mirth_channels.zip)
All other components remain the same as in release v.1.0.4.
Contents
This guide includes:
1.	Updating Mirth Channels
2.	Updating Central Image
3.	Updating Webservice Image
4.	Updating Metadata in Database
5.	Updating Port Configuration for Webservice
 
1. Updating Mirth Channels
Step 1: Delete Existing Channels
1.	Open Mirth Connect Administrator Launcher.
2.	Log in to Mirth.
3.	Navigate to Channels.
4.	Select all channels.
5.	Right-click → Select Delete Channel.
6.	Confirm deletion.
Step 2: Import Updated Channels
1.	Unzip mirth_channels.zip.
2.	Navigate to Mirth → Channels.
3.	Click Import Channels.
4.	Select all unzipped .xml files.
5.	Agree to import and overwrite libraries.
Step 3: Update Configuration
1.	Go to Settings → Configuration Map.
2.	Click Import Map.
3.	Select config_map.properties.
4.	Update OMDS_URL with the correct API endpoint.
________________________________________
2. Updating Central Image
Requirements:
•	Docker installed
•	Cloud CLI installed and configured
Step 1: Load Docker Image
# Load image
$ docker load -i central.1.0.6.tar  
# Tag image
$ docker tag registry.example.com/central:1.0.6 <ECR_URL>/central:1.0.6  
# Push to repository
$ docker push <ECR_URL>/central:1.0.6  
Step 2: Update Terraform Configuration
1.	Navigate to Terraform scripts.
2.	Edit terraform.tfvars to update the Central image to v.1.0.6.
________________________________________
3. Updating Webservice Image
Requirements:
•	Docker installed
•	Cloud CLI installed and configured
Step 1: Load Docker Image
# Load image
$ docker load -i webservice.1.5.30.tar  
# Tag image
$ docker tag registry.example.com/webservice:1.5.30 <ECR_URL>/webservice:1.5.30  
# Push to repository
$ docker push <ECR_URL>/webservice:1.5.30  
Step 2: Update Terraform Configuration
1.	Navigate to Terraform scripts.
2.	Edit terraform.tfvars to update the Webservice image to v.1.5.30.
 
4. Updating Metadata in Database
Requirements:
•	Java 17+ installed
•	Database accessible
Steps:
1.	Unpack dbtools-1.5.16.zip.
2.	Navigate to the extracted folder.
3.	Execute:
4.	java -jar lib/dbtools.jar --authentication-type username-password \
5.	--database <DB_NAME> --metadata-directory in \
6.	--hostname <DB_HOST> --mapping-file <MAPPING_FILE> \
-U <DB_USER> -pw <DB_PASSWORD> --full-deployment
Replace placeholders:
o	<DB_NAME>: Example webservice-db
o	<DB_HOST>: RDS endpoint
o	<DB_USER>: Database username
o	<DB_PASSWORD>: Database password
 
5. Updating Port Configuration for Webservice
The Webservice requires additional configuration. This will be automated in future releases.
Steps:
1.	Navigate to the Terraform script folder.
2.	Open modules/container_fargate/task_group.tf.
3.	Add the following parameters:
4.	{
5.	  name  = "SERVER_HTTPS_PORT"
6.	  value = "8090"
7.	},
8.	{
9.	  name  = "SERVER_HTTPS_PORT"
10.	  value = "443"
},
11.	Apply changes:
terraform apply


