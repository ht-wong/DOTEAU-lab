resource "random_pet" "server_name" {
  length = 2
  prefix = "demo-server"
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = random_pet.server_name.id
  }
}
