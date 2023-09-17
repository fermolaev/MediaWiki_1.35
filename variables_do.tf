
variable "zone" {
  description = "В какой зоне создаем"
  type        = string
  default     = "ru-central1-a"
}

variable "cloud_id" {
  description = "Secret infra"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Secret infra"
  type        = string
  sensitive   = true
}

variable "name" {
  description = "Имя тачки"
  type        = string
  default     = "fermolaev"
}

variable "email" {
  description = "Email при регистрации"
  type        = string
  default     = "len1256@mail.ru"
}

variable "task" {
  type        = string
  description = "like dev-01 qa-01 do-01"
}

variable "connect_type" {
  description = "Вид подключения к VM для удаленных команд"
  type        = string
  default     = "ssh"
}

variable "ssh_privat" {
  description = "Путь до моего приватного ssh ключа"
  type        = string
  sensitive   = true
}

variable "pass_length" {
  description = "Длина пароля"
  type        = number
  default     = 8
}

variable "pass_strong" {
  #Не используем *[]^${}\?|()
  description = "Спец символы для пароля"
  type        = string
  default     = "#%+-._~"
}

#------------| AWS Secrets|---------------

variable "aws_access" {
  description = "AWS Access token"
  type        = string
  sensitive   = true
}

variable "aws_secret" {
  description = "AWS Secret token"
  type        = string
  sensitive   = true
}

#------------| AWS 53 DNS|---------------
variable "aws_region" {
  description = "Регион aws"
  type        = string
  default     = "us-east-1"
}

variable "zone_name" {
  description = "Зона 53 :D"
  type        = string
  default     = "devops.rebrain.srwx.net."
}

variable "dns_type" {
  description = "Тип DNS записи"
  type        = string
  default     = "A"
}

variable "ttl" {
  description = "007: не время умирать"
  type        = number
  default     = "300"
}
