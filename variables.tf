variable "aws_accesskey" {
  type = string
}

variable "aws_secretkey" {
  type = string
}

variable "webserver_ip_private" {
  type    = list(any)
  default = ["10.10.10.20", "10.10.10.30"]
}