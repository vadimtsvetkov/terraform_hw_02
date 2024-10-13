terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
}

resource "yandex_vpc_network" "db" {
 name = "db-network"

}

provider "yandex" {
  #token                   = var.yc_token
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_region
  service_account_key_file = file("../authorized_key.json")
}
