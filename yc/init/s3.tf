# Create Static Access Keys
resource "yandex_iam_service_account" "sa-s3" {
  name        = "sa-s3"
  description = "S3 SA for backend"
}

resource "yandex_resourcemanager_folder_iam_member" "s3-admin-account-iam" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-s3.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-s3.id
  description        = "static access key for object storage"
}

# Create S3 bucket for terraform backend files
resource "yandex_storage_bucket" "tf-back" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = var.bucket_name
}
