provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "${var.aws_region}"
}

output "aws_key_path" {
	value = "${var.aws_key_path}"
}

resource "aws_security_group" "ssh_http_https_only" {
  name = "${var.prefix}-${var.openwhisk_security_group}"
  description = "Allow SSH, HTTP and HTTPS only inbound traffic"

  ingress {
			from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

	ingress {
      self = true
			from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      self = true
			from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.prefix}-${var.openwhisk_security_group}"
  }
}

resource "aws_instance" "openwhisk" {
    ami = "${var.aws_openwhisk_ami}"
    instance_type = "${var.aws_openwhisk_instance_type}"
    key_name = "${var.aws_key_name}"
    associate_public_ip_address = true
    security_groups = ["${var.prefix}-${var.openwhisk_security_group}"]

		root_block_device {
        volume_type = "gp2"
        volume_size = 40
    }

		tags {
      Name = "${var.prefix}-${var.openwhisk_name}"
    }

    connection {
      user = "ubuntu"
      key_file = "${var.aws_key_path}"
    }

		provisioner "remote-exec" {
      inline = [
          "sudo addgroup docker",
					"sudo usermod -aG docker $USER"
      ]
    }

    provisioner "file" {
      source = "${path.module}/openwhisk-native.sh"
      destination = "/home/ubuntu/openwhisk-native.sh"
    }

		provisioner "remote-exec" {
			inline = "chmod +x /home/$USER/openwhisk-native.sh"
		}
}

# Outputs
output "openwhisk_ip" {
  value = "${aws_instance.openwhisk.public_ip}"
}
