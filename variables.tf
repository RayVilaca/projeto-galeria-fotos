# -- general --
variable "name" { type = string }
variable "region" { type = string }
variable "dr_region" { type = string }
variable "project" { type = string }

# -- Tags --
variable "tags" { type = map(any) }