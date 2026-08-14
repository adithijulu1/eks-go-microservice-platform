resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.cluster_name}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "app_db" {
  identifier                  = "${var.cluster_name}-db"
  engine                      = "postgres"
  engine_version              = "16.3"
  instance_class              = "db.t3.medium"
  allocated_storage           = 50
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  username                    = var.db_username
  manage_master_user_password = true
  multi_az                    = true
  backup_retention_period     = 7
  skip_final_snapshot         = false

  tags = {
    Environment = var.environment
  }
}
