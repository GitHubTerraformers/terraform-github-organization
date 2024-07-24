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
    MYSECRET2 = {
      repositories = ["terraform-github-organization"]
    }
  }

  variables = {
    email = {
      value        = "vmvarela@gmail.com"
      visibility   = "selected"
      repositories = ["terraform-github-organization"]
    }
  }

  rulesets = {
    "test" = {
      target       = "branch"
      exclude      = ["feature/*", "hotfix/*", "release/*"]
      repositories = ["terraform-github-organization"]
      rules = {
        creation = true
      }
    }
    "test-2" = {
      target       = "tag"
      include      = ["~ALL"]
      repositories = ["terraform-github-repository"]
      rules = {
        deletion = true
      }
    }
    "check-pr" = {
      target       = "branch"
      include      = ["~DEFAULT_BRANCH"]
      repositories = ["~ALL"]
      rules = {
        required_workflows = [
          {
            repository = "terraform-github-organization"
            path       = ".github/workflows/check-pr.yml"
            ref        = "main"
          }
        ]
      }
    }
  }

  webhooks = {
    "https://google.es/" = {
      content_type = "form"
      insecure_ssl = false
      events       = ["deployment"]
    }
  }

  custom_roles = {
    "myrole" = {
      description = "My custom role"
      base_role   = "write"
      permissions = ["remove_assignee"]
    }
  }

  # actions_permissions = {
  #   allowed_actions       = "local_only"
  #   enabled_repositories  = "selected"
  #   github_owned_actions  = true
  #   verified_actions      = true
  #   selected_repositories = ["terraform-github-organization", "terraform-github-repository"]
  # }

  runner_groups = {
    "MYRUNNERGROUP" = {
      repositories = ["terraform-github-organization"]
      workflows    = ["Release"]
    }
  }
}
