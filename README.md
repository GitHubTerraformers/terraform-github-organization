# Github Organization Terraform module

Terraform module to manage GitHub organization settings, including teams, roles, and organization-wide repository configurations.

These features of Github Organization configurations are supported:

- settings
- teams (w/security manager role)
- secrets & variables
- rulesets (enterprise)
- webhooks
- custom roles (enterprise)
- actions permissions config

## Usage

### Private repository

```hcl
module "org" {
  source = "vmvarela/org/github"

  name           = "my-org"
  billing_email                                            = "my-email@mail.com"
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
    }
  }

  variables = {
    email = {
      value        = "vmvarela@gmail.com"
      visibility   = "selected"
      repositories = ["my-repo-1"]
    }
  }

  rulesets = {
    "test" = {
      target       = "branch"
      exclude      = ["feature/*", "hotfix/*", "release/*"]
      repositories = ["my-repo-1"]
      rules = {
        creation = true
      }
    }
    "test-2" = {
      target       = "tag"
      include      = ["~ALL"]
      repositories = ["my-repo-2"]
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
            repository = "my-repo-1"
            path       = ".github/workflows/check-pr.yml"
            ref        = "main"
          }
        ]
      }
    }
  }
}

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
