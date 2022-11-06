resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.master.result
}


data "aws_secretsmanager_secret" "db_password" {
  name = "db-password"

}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password
}



resource "aws_db_instance" "db" {   
  allocated_storage    = 100
  name                 = var.database_name
  db_subnet_group_name = aws_subnet.private.id
  engine               = "postgres"
  engine_version       = "11.5"
  identifier           = "db"
  port="5432"
  instance_class       = "db.t2.xlarge"
  password             = data.aws_secretsmanager_secret_version.db_password
  skip_final_snapshot  = true
  storage_encrypted    = true
  username             = "postgres"
  backup_window        = "09:46-10:16"
  backup_retention_period = 7
  deletion_protection  = "true"
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
}

resource "aws_security_group" "db_security_group" {
  name = "${local.resource_name_prefix}-rds-sg"

  description = "RDS"
  vpc_id      = aws_vpc.aws_vpc.id

  # Only MySQL in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = "10.10.0.0/16"
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "10.10.0.0/16"
  }
}



