/*
resource "aws_instance" "gunicorn" {
  ami                    = "ami-05342ca821afde9d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.gunicorn.id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"

  provisioner "remote-exec" {
    inline = [
      "docker run -e REDIS_URL='redis://${local.redis_url}:6379' -d -p 8000:8000 --name counter-app hangchan/counter-app:latest"
    ]
    connection {
      user        = "rancher"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  tags = {
    Name = "gunicorn"
  }

}
*/
