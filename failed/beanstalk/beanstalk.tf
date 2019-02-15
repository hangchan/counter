/*
resource "aws_s3_bucket" "default" {
  bucket = "s3-bucket-for-beanstalk-app"
}

resource "aws_s3_bucket_object" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  key    = "beanstalk/${var.app}-${var.version}.zip"
  source = "${var.app}-${var.version}.zip"
  etag   = "${md5(file("${var.app}-${var.version}.zip"))}"
}

resource "aws_elastic_beanstalk_application" "default" {
  name        = "${var.app}"
  description = "best ${var.app} ever!"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "${var.app}-${var.version}"
  application = "${aws_elastic_beanstalk_application.default.name}"
  description = "application version created by terraform"
  bucket      = "${aws_s3_bucket.default.id}"
  key         = "${aws_s3_bucket_object.default.id}"
}

resource "aws_elastic_beanstalk_environment" "default" {
  name                = "${var.env}"
  application         = "${aws_elastic_beanstalk_application.default.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.0 running Python 3.6"

    setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

    setting {
    namespace = "aws:elbv2:listenerrule:api"
    name      = "PathPatterns"
    value     = "/api/*"
  }

    setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "WSGIPATH"
    value     = "app.py"
  }

    setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_URL"
    value     = "${aws_elasticache_cluster.default.cache_nodes.0.address}"
  }

    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = ""
  }

}
*/
