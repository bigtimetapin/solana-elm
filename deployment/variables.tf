variable "domain_name" {
  description = "Domain Name"
  default     = "meme-race.com"
}

variable "cert_arn" {
  description = "SSL Cert"
  default     = "arn:aws:acm:us-east-1:504084586672:certificate/767ceeb9-203c-4de4-9a53-d9790c09fd95"
}
