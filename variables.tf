variable "aws_accesskey" {
  type = string
}

variable "aws_secretkey" {
  type = string
}

variable "webserver_ip_private" {
  type = list
  default = ["10.10.10.20/28", "10.10.10.30/28"]
}