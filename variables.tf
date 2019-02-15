variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}

variable "app" {
  default = "counter"
}

# Used to ssh to the instances
variable "deployer_key" {
  default = "UPDATE_WITH_SSH_PUBLIC_KEY"
}

variable "my_network_cidr" {
  default = "UPDATE_WITH_YOUR_NETWORK_CIDR"
}

# Used to provision the instances
variable "private_key_file" {
  default = "UPDATE_WITH_SSH_PRIVATE_KEY_FILE_LOCATION"
}

/* Depecrated, used for elastic beanstalk
variable "version" {
  type = "string"
  default = "0.0.1"
}
variable "env" {
  default = "production"
}
*/
