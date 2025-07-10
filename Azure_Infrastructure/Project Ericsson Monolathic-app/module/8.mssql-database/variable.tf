variable "collation" {
  description = "The collation of the SQL Database."
  type        = string
  
}
variable "license_type" {
  description = "The license type of the SQL Database."
  type        = string

}
variable "max_size_gb" {
  description = "The maximum size of the SQL Database in GB."
  type        = number
  default     = 32
}
variable "sku_name" {
  description = "The SKU name of the SQL Database."
  type        = string
  default     = "S0"
}
variable "enclave_type" {
  description = "The enclave type of the SQL Database."
  type        = string
  default     = "None"
}
variable "database_name" {
    description = "The name of the SQL Database."
    type        = string
    default     = "mydatabase"
  
}
variable "server_id" {
  description = "The ID of the SQL Server where the database will be created."
  type        = string
}