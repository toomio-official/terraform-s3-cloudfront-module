variable "s3_bucket_name" {
  type = string
}

variable "cloudfront_distribution_description" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "index_document" {
  type    = string
  default = "index.html"
}