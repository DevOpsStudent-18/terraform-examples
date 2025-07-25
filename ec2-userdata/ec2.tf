resource "aws_instance" "ec2test" {

  instance_type          = "t2.micro"
  ami                    = "ami-08a6efd148b1f7504"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
 
  
  
  tags = {
    Name = "Testserver1"
  }
  user_data  = "${file("user_data.sh")}"
  
}