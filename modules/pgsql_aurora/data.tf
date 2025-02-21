data "aws_subnet" "subnet" {
  id = var.db_subnet_ids[0]
}