variable "billing_email" {
  description = "(Required) The billing email address for the organization."
  type        = string
}

variable "company" {
  description = "(Optional) The company name for the organization."
  type        = string
  default     = null
}

variable "blog" {
  description = "(Optional) The blog URL for the organization."
  type        = string
  default     = null
}

variable "email" {
  description = "(Optional) The email address for the organization."
  type        = string
  default     = null
}

variable "twitter_username" {
  description = "(Optional) The Twitter username for the organization."
  type        = string
  default     = null
}

variable "location" {
  description = "(Optional) The location for the organization."
  type        = string
  default     = null
}

variable "name" {
  description = "(Optional) The name for the organization."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) The description for the organization."
  type        = string
  default     = null
}

variable "has_organization_projects" {
  description = "(Optional) Whether organization projects are enabled."
  type        = bool
  default     = null
}

variable "has_repository_projects" {
  description = "(Optional) Whether repository projects are enabled."
  type        = bool
  default     = null
}

variable "default_repository_permission" {
  description = "(Optional) The default permission for organization members to create new repositories. Can be one of read, write, admin, or none. Defaults to read."
  type        = string
  default     = null
}

variable "members_can_create_repositories" {
  description = "(Optional) Whether members can create repositories."
  type        = bool
  default     = null
}

variable "members_can_create_public_repositories" {
  description = "(Optional) Whether members can create public repositories."
  type        = bool
  default     = null
}

variable "members_can_create_private_repositories" {
  description = "(Optional) Whether members can create private repositories."
  type        = bool
  default     = null
}

variable "members_can_create_internal_repositories" {
  description = "(Optional) Whether members can create internal repositories."
  type        = bool
  default     = null
}

variable "members_can_create_pages" {
  description = "(Optional) Whether members can create pages."
  type        = bool
  default     = null
}

variable "members_can_create_public_pages" {
  description = "(Optional) Whether members can create public pages."
  type        = bool
  default     = null
}

variable "members_can_create_private_pages" {
  description = "(Optional) Whether members can create private pages."
  type        = bool
  default     = null
}

variable "members_can_fork_private_repositories" {
  description = "(Optional) Whether members can fork private repositories."
  type        = bool
  default     = null
}

variable "web_commit_signoff_required" {
  description = "(Optional) Whether a commit signature is required for commits to this organization."
  type        = bool
  default     = null
}

variable "advanced_security_enabled_for_new_repositories" {
  description = "(Optional) Whether advanced security is enabled for new repositories."
  type        = bool
  default     = null
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  description = "(Optional) Whether dependabot alerts are enabled for new repositories."
  type        = bool
  default     = null
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  description = "(Optional) Whether dependabot security updates are enabled for new repositories."
  type        = bool
  default     = null
}

variable "dependency_graph_enabled_for_new_repositories" {
  description = "(Optional) Whether dependency graph is enabled for new repositories."
  type        = bool
  default     = null
}

variable "secret_scanning_enabled_for_new_repositories" {
  description = "(Optional) Whether secret scanning is enabled for new repositories."
  type        = bool
  default     = null
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  description = "(Optional) Whether secret scanning push protection is enabled for new repositories."
  type        = bool
  default     = null
}

variable "teams" {
  description = "(Optional) A list of teams to add to the organization."
  type = map(object({
    description      = optional(string)
    security_manager = optional(bool)
    privacy          = optional(string)
    parent_team      = optional(string)
    members          = optional(list(string))
    maintainers      = optional(list(string))
    review_request_delegation = optional(object({
      algorithm    = optional(string)
      member_count = optional(number)
      notify       = optional(bool)
    }))
  }))
  default = {}
}
