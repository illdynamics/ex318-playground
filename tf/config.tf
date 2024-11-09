terraform {
    required_version = "1.9.8"
    cloud {
        organization = "cfgbro"

        workspaces {
          project = "EX318-Playground"
          name   = "ovirt"
        }
    }
}
