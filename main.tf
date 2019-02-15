provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

locals {
  redis_url = "${aws_elasticache_cluster.default.cache_nodes.0.address}"
}

resource "aws_elasticache_cluster" "default" {
  cluster_id           = "cluster-${var.app}"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.0"
  port                 = 6379
  security_group_ids   = ["${aws_security_group.redis.id}"]
}

resource "aws_instance" "gunicorn" {
  ami                    = "ami-035be7bafff33b6b6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.gunicorn.id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"

  provisioner "file" {
    source      = "app/install_app.sh"
    destination = "/tmp/install_app.sh"
    connection {
      user        = "ec2-user"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_app.sh",
      "/tmp/install_app.sh",
      "sudo bash -c \"echo export REDIS_URL=redis://${local.redis_url}:6379 >> /etc/rc.local\"",
      "sudo bash -c \"echo cd /home/ec2-user/app >> /etc/rc.local\"",
      "sudo bash -c \"echo source /home/ec2-user/app/venv/webapp/bin/activate >> /etc/rc.local\"",
      "sudo bash -c \"echo gunicorn --bind 0.0.0.0:8000 app:app --daemon >> /etc/rc.local\"",
      "sudo chmod +x /etc/rc.d/rc.local",
      "sudo shutdown -r +1",
    ]
    connection {
      user        = "ec2-user"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  tags = {
    Name = "gunicorn"
  }

}

resource "aws_instance" "nginx" {
  ami                    = "ami-0ac019f4fcb7cb7e6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"

  provisioner "file" {
    source      = "nginx/nginx.conf"
    destination = "/tmp/nginx.conf"
    connection {
      user        = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "file" {
    source      = "static/index.html"
    destination = "/tmp/index.html"
    connection {
      user        = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "file" {
    source      = "static/styles.css"
    destination = "/tmp/styles.css"
    connection {
      user        = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo sed -i 's/REPLACE_ME_PIP/${aws_instance.gunicorn.private_ip}/g' /tmp/nginx.conf",
      "sudo sed -i 's/REPLACE_ME_EDNS/${aws_instance.nginx.public_dns}/g' /tmp/nginx.conf",
      "sudo mkdir -p /var/www/html/static",
      "sudo cp /tmp/index.html /var/www/html/",
      "sudo cp /tmp/styles.css /var/www/html/static/",
      "sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf",
      "sudo shutdown -r +1",
    ]
    connection {
      user        = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  tags = {
    Name = "nginx"
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${var.deployer_key}"
}

resource "aws_security_group" "redis" {
    name        = "redis"
    description = "allow connection to redis server"

    ingress {
        from_port       = 6379 
        to_port         = 6379 
        protocol        = "tcp"
        security_groups = ["${aws_security_group.gunicorn.id}"]
        self            = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = ["${aws_security_group.gunicorn.id}"]
    }

}

resource "aws_security_group" "gunicorn" {
    name        = "gunicorn"
    description = "allow connection to gunicorn server"

    ingress {
        from_port       = 8000
        to_port         = 8000
        protocol        = "tcp"
        security_groups = ["${aws_security_group.nginx.id}"]
        self            = true
    }

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["${var.my_network_cidr}"]
        self            = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "nginx" {
    name        = "nginx"
    description = "allow connection to nginx server"

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        self            = true
    }

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["${var.my_network_cidr}"]
        self            = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}
