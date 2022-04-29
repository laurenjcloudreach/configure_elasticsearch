resource "aws_instance" "elk" {
    ami = data.aws_ami.ubuntu_image.id
    instance_type = var.ec2_type
    subnet_id = data.aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.my_private_sg.id]
    key_name               = var.my_keypair
    availability_zone = "us-east-2a"
    

    tags = {
    Name = "ELK Server"
  }
}