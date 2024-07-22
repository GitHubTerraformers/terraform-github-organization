resource "github_organization_settings" "this" {
  billing_email                                                = var.billing_email
  company                                                      = var.company
  blog                                                         = var.blog
  email                                                        = var.email
  twitter_username                                             = var.twitter_username
  location                                                     = var.location
  name                                                         = var.name
  description                                                  = var.description
  has_organization_projects                                    = var.has_organization_projects
  has_repository_projects                                      = var.has_repository_projects
  default_repository_permission                                = var.default_repository_permission
  members_can_create_repositories                              = var.members_can_create_repositories
  members_can_create_public_repositories                       = var.members_can_create_public_repositories
  members_can_create_private_repositories                      = var.members_can_create_private_repositories
  members_can_create_internal_repositories                     = var.members_can_create_internal_repositories
  members_can_create_pages                                     = var.members_can_create_pages
  members_can_create_public_pages                              = var.members_can_create_public_pages
  members_can_create_private_pages                             = var.members_can_create_private_pages
  members_can_fork_private_repositories                        = var.members_can_fork_private_repositories
  web_commit_signoff_required                                  = var.web_commit_signoff_required
  advanced_security_enabled_for_new_repositories               = var.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.secret_scanning_push_protection_enabled_for_new_repositories
}

resource "github_team" "this" {
  for_each       = var.teams
  name           = each.key
  description    = each.value["description"]
  privacy        = each.value["privacy"]
  parent_team_id = each.value["parent_team"]
}

resource "github_team_members" "this" {
  for_each = var.teams
  team_id  = github_team.this[each.key].id
  dynamic "members" {
    for_each = each.value["members"] != null ? each.value["members"] : []
    content {
      username = members.value
      role     = "member"
    }
  }
  dynamic "members" {
    for_each = each.value["maintainers"] != null ? each.value["maintainers"] : []
    content {
      username = members.value
      role     = "maintainer"
    }
  }
}

resource "github_team_settings" "this" {
  for_each = {
    for team, team_data in var.teams : team => team_data
    if team_data["review_request_delegation"] != null
  }
  team_id = github_team.this[each.key].id
  review_request_delegation {
    algorithm    = each.value["review_request_delegation"]["algorithm"]
    member_count = each.value["review_request_delegation"]["member_count"]
    notify       = each.value["review_request_delegation"]["notify"]
  }
}

resource "github_organization_security_manager" "this" {
  for_each = {
    for team, team_data in var.teams : team => team_data
    if try(team_data["security_manager"], false) == true
  }
  team_slug = github_team.this[each.key].slug
}

data "github_repository" "this" {
  for_each = local.repositories != null ? toset(local.repositories) : []
  name     = each.key
}

resource "github_actions_organization_secret" "this" {
  for_each        = try(var.secrets, null) != null ? var.secrets : {}
  visibility      = each.value.visibility
  secret_name     = each.key
  encrypted_value = each.value.encrypted_value
  plaintext_value = each.value.plaintext_value
  selected_repository_ids = each.value.repositories != null ? [
    for repository in each.value.repositories :
    data.github_repository.this[repository].repo_id
  ] : []
}

resource "github_actions_organization_variable" "this" {
  for_each      = try(var.variables, null) != null ? var.variables : {}
  visibility    = each.value.visibility
  variable_name = each.key
  value         = each.value.value
  selected_repository_ids = each.value.repositories != null ? [
    for repository in each.value.repositories :
    data.github_repository.this[repository].repo_id
  ] : []
}

locals {
  repositories = distinct(concat(
    flatten([
      for secret, secret_data in var.secrets : secret_data.repositories if secret_data.repositories != null
    ]),
    flatten([
      for variable, variable_data in var.variables : variable_data.repositories if variable_data.repositories != null
    ])
  ))
}
