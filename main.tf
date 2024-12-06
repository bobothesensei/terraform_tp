# module "ec2_instance" {
#   source        = "../aws/ec2"
#   name          = "BorenneEC2Module"
#   instance      = "t3.micro"
#   environnement = "PROD"
#   subnet        = "subnet-02dbf55cf4ab64fc4"
#   ami           = "ami-05edb7c94b324f73c"
#   port          = "8080"
# }

# resource "aws_instance" "imported-ec2" {
#   ami           = "ami-05edb7c94b324f73c"
#   instance_type = "t3.micro"
#   subnet_id     = "subnet-02dbf55cf4ab64fc4"
#   tags = {
#     "Name" = "ec2BorenneManuel"
#   }
# }

# resource "aws_instance" "instance-ec2" {
#   ami           = "ami-05edb7c94b324f73c"
#   instance_type = "t3.micro"
#   subnet_id     = "subnet-02dbf55cf4ab64fc4"
#   tags = {
#     Name        = each.value
#     Environment = "Dev"
#   }
#   for_each = toset(var.vm_names)
# }

# variable "vm_names" {
#   type    = list(string)
#   default = ["bchh_webapp_1", "bchh_webapp_2", "bchh_webapp_3"]
# }


resource "aws_instance" "instance-ec2" {
  count         = 3
  ami           = element(var.amis, count.index)
  instance_type = var.instance
  subnet_id     = var.subnet
  tags = {
    Name          = "${var.name}-${count.index}"
    Environnement = var.environnement
  }
}

variable "amis" {
  description = "amis des instances EC2"
  type        = list(any)
  default     = ["ami-05edb7c94b324f73c", "ami-0b8558308efa5fb9d", "ami-075449515af5df0d1"]
}

variable "name" {
  type        = string
  description = "Le nom de l'instance EC2"
  default     = "ec2BorenneTerraform"
}

variable "instance" {
  type        = string
  description = "Le type d'intance EC2"
  default     = "t3.micro"
}

variable "subnet" {
  type        = string
  description = "Subnet ID"
  default     = "subnet-02dbf55cf4ab64fc4"
}

variable "environnement" {
  type        = string
  description = "Environnement"
  default     = "Dev"
}

terraform {
  backend "s3" {
    bucket         = "bchh-terraform-remote-state"
    key            = "tfstate/my_terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "bchh-terraform-lock"
  }
}