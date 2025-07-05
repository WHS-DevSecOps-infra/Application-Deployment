# ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }

}

  # ECS
  resource "aws_security_group" "ecs_sg" {
    name        = "${var.project_name}-ecs-sg"
    description = "Security group for ECS tasks"
    vpc_id      = aws_vpc.vpc.id

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" 
      cidr_blocks = ["0.0.0.0/0"]
    }

}