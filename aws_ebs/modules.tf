resource "aws_ebs_volume" "example" {
  availability_zone = var.availability_zone
  size              = 40
  type = "gp3"
  tags = {
    Name = merge(var.regular_tag, var.additional_tags)
  }
}