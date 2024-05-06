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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#public_dns
output "instance_public_DNS" {
  value = aws_instance.web.public_dns
}

#output "instance_arn" {
#  value = aws_instance.web.arn
#}
