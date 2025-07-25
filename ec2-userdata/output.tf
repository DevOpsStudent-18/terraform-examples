output "public_ip" {
  value = "${aws_instance.ec2test.public_ip}"
}