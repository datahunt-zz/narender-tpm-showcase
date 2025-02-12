appx_ecr_registry = { base_uri = "<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com" arns = [ "arn:aws:ecr:us-east-1:<AWS_ACCOUNT_ID>:repository/mirthconnect", "arn:aws:ecr:us-east-1:<AWS_ACCOUNT_ID>:repository/appx" ] }
cluster = { name = "Central-Server-Demo" key_name = "demo-key" vpc_id = "<VPC_ID>" subnet_ids = ["<SUBNET_ID_1>", "<SUBNET_ID_2>"] instance_type = "t3.micro" min_instances = 1 max_instances = 4 desired_capacity = 1 }
container = { appx_container_image_name = "appx:latest" appx_db_connection_string = "jdbc:sqlserver://<DB_HOST>:1433;databaseName=appx-db;trustServerCertificate=true;"
mirth_container_image_name = "mirthconnect:latest" mirth_volume_efs_id = "<EFS_ID>" mirth_db_connection_string = "jdbc:jtds:sqlserver://<DB_HOST>:1433;databaseName=mirth-db"
appxws_container_image_name = "appxws:latest" appxws_db_connection_string = "jdbc:sqlserver://<DB_HOST>:1433;databaseName=appxws-db;trustServerCertificate=true;"
artemis_container_image_name = "artemis:latest" artemis_db_connection_string = "jdbc:sqlserver://<DB_HOST>:1433;databaseName=artemis-db;trustServerCertificate=true;"
secret_certificate_arn = "arn:aws:secretsmanager:us-east-1:<AWS_ACCOUNT_ID>:secret:<SECRET_CERT>" secret_key_arn = "arn:aws:secretsmanager:us-east-1:<AWS_ACCOUNT_ID>:secret:<SECRET_KEY>" alb_certificate_arn = "arn:aws:acm:us-east-1:<AWS_ACCOUNT_ID>:certificate/<CERT_ID>" }
database = { userName = "admin" password = "<REPLACE_WITH_SECRET>" }


