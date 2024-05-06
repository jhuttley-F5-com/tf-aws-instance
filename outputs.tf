#output "instance_ami" {
#  value = aws_instance.web.ami
#}

output "ami_id" {
  value = data.aws_ami.app_ami.id
}

output "pvc_id" {
  value = aws_vpc.my_vpc.id
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

#output "instance_arn" {
#  value = aws_instance.web.arn
#}
