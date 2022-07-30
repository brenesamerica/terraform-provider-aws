
locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-key-pair"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Key Pair Module
################################################################################

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.0"

  key_name           = local.name
  create_private_key = true

  tags = local.tags
}

module "key_pair_external" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.0"

  key_name   = "${local.name}-external"
  public_key = trimspace(tls_private_key.this.public_key_openssh)

  tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################

resource "tls_private_key" "this" {
  algorithm = "RSA"
}
