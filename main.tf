data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name_pattern}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.ami_publisher}"]
}

# We are given as input a list of subnets to create the NAT in. Lets use them to find out about the VPC.
data "aws_subnet" "subnets" {
  count = "${length(var.subnet_ids)}"
  id = "${var.subnet_ids[0]}"
}

data "aws_vpc" "vpc" {
  id = "${data.aws_subnet.subnets.0.vpc_id}"
}

data "aws_region" "current" {
  current = true
}

data "template_file" "user_data" {
  template = "${file("${path.module}/nat-user-data.conf.tmpl")}"
  count = "${var.instance_count}"

  vars {
    name = "${var.name}"
    myaz = "${element(data.aws_subnet.subnets.*.availability_zone, count.index)}"
    vpc_cidr = "${data.aws_vpc.vpc.cidr_block}"
    region = "${data.aws_region.current.name}"
    awsnycast_deb_url = "${var.awsnycast_deb_url}"
  }
}

resource "aws_instance" "nat" {
    count = "${var.instance_count}"
    ami = "${data.aws_ami.ami.id}"
    instance_type = "${var.instance_type}"
    source_dest_check = false
    iam_instance_profile = "${aws_iam_instance_profile.nat_profile.id}"
    key_name = "${var.aws_key_name}"
    subnet_id = "${element(var.subnet_ids, count.index)}"
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
    tags = "${merge(var.tags, map("Name", format("%s-nat%d", var.name, count.index+1)))}"
    user_data = "${element(data.template_file.user_data.*.rendered, count.index)}"
}

