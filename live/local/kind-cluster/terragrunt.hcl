include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}/modules/kind-cluster"

  # Makes kind attach its node containers to the same Docker network as the
  # standalone MiniStack container (live/local/_bootstrap), so pods can reach
  # MiniStack by static IP.
  extra_arguments "docker_network" {
    commands = ["apply", "plan", "destroy", "refresh", "import"]

    env_vars = {
      KIND_EXPERIMENTAL_DOCKER_NETWORK = local.env.locals.docker_network_name
    }
  }
}

inputs = {
  cluster_name = local.env.locals.cluster_name
}
