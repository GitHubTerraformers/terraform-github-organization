provider "github" {}

module "org" {
  source                                                   = "../.."
  name                                                     = "GitHub Terraformers"
  description                                              = "Building and sharing Terraform modules to simplify and automate GitHub infrastructure management."
  billing_email                                            = "ghtf+vmvarela@gmail.com"
  location                                                 = "Spain"
  default_repository_permission                            = "none"
  members_can_create_repositories                          = false
  members_can_create_private_repositories                  = false
  members_can_create_public_repositories                   = false
  members_can_create_pages                                 = false
  members_can_create_private_pages                         = false
  members_can_create_public_pages                          = false
  members_can_fork_private_repositories                    = false
  has_organization_projects                                = false
  has_repository_projects                                  = false
  dependabot_alerts_enabled_for_new_repositories           = true
  dependency_graph_enabled_for_new_repositories            = true
  dependabot_security_updates_enabled_for_new_repositories = true

  teams = {
    MYTEAM = {
      description = "My awesome team"
      privacy     = "closed"
      members     = ["vmvarela"]
    }

    OTHERTEAM = {
      description      = "Another awesome team"
      security_manager = true
      maintainers      = ["vmvarela"]
      parent_team      = "MYTEAM"
      privacy          = "closed"
      review_request_delegation = {
        algorithm    = "LOAD_BALANCE"
        member_count = 2
      }
    }
  }

  secrets = {
    MYSECRET = {
      plaintext_value = "mysecret"
      #      visibility      = "all"
    }
  }

  variables = {
    email = {
      value        = "vmvarela@gmail.com"
      visibility   = "selected"
      repositories = ["terraform-github-organization"]
    }
  }
}
