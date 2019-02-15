# Counter App 

My poor attempt at deploying a counter app with terraform.  This deploys a gunicorn server, nginx reverse proxy, elasticache cluster.

## Getting Started
### Prerequisites

```
terraform
```

### Configuration

```
Create an apikey file with variables access_key and secret_key
```

```
Edit variables.tf
Update the values for deployer_key, private_ssh_key_file, my_network_cidr to match your environment
```

## Deployment

```
terraform apply --var-file=/path/to/apikey
```

## Failures

Storing my failed attempts in the failed directory

```
docker - tried to dockerize the gunicorn app, this should work, need to create a startup script to 
run the docker image
```

```
beanstalk - tried to deploy app via elastic beanstalk.  This is the most Amazon native way of 
deploying flask apps.  Could not use it as Beanstalk uses apache httpd server instead of nginx.
```

## Todos

```
Replace installation scripts with ansible
Create startup script instead of using rc.local for gunicorn
Use remote backend for terraform
Remove ssh access
Use modules
Dockerize apps
Migrate to kubernetes
```
