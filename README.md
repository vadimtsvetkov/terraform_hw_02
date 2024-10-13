# «Основы Terraform. Yandex Cloud»

## Задание 1 :monkey:



**1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider. :white_check_mark:** \
**2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net). :white_check_mark:** \
**3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**. :white_check_mark:** 

Дерево моей рабочей директории.
```Bash
terraform_hw_02/
├── authorized_key.json
├── LICENSE
├── README.md
└── terraform-yc_mv
    ├── console.tf
    ├── locals.tf
    ├── main.tf
    ├── outputs.tf
    ├── private.auto.tfvars
    ├── providers.tf
    └── variables.tf

```
Создал файл с переменными.
```private.auto.tfvars

# Yandex Cloud Oauth token
yc_token = "***"

# Yandex Cloud ID
yc_cloud_id = "***"

# Yandex Cloud folder ID
yc_folder_id = "***"

# Default Yandex Cloud Region
yc_region = "ru-central1-a"

#SSH-key для подключения к VM
vms_ssh_public_root_key = "***"
```

**4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.**

```Bash
╷
│ Error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```

В файле main.tf указана platform_id = "standart-v4", такой платформы нет. Указал платформу v1.
После чего появилась другая ошибка.
```Bash
╷
│ Error: Error while requesting API to create instance: server-request-id = b4ee9d86-64eb-49b5-bec4-36beb69fac4e server-trace-id = b81918851d26816c:358b748f285084aa:b81918851d26816c:1 client-request-id = d3ec4390-f162-4098-96dd-43b355ed07e0 client-trace-id = 9ea7355b-4e3d-46d7-ab54-fcbf477374ff rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```
Изменил кол-во ядер на 2.

**5. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.**
![img.png](https://github.com/vadimtsvetkov/terraform_hw_02/blob/main/screen/ter-yc_1.png)
![img.png](https://github.com/vadimtsvetkov/terraform_hw_02/blob/main/screen/ter-yc_2.png)

**6. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.**

Параметры ```preemptible = true``` и ```core_fraction=5``` могут быть полезны в процессе обучения по следующим причинам:

**Экономия затрат:** \
preemptible = true: Виртуальные машины с этим параметром могут быть автоматически остановлены (прерваны) при необходимости, что позволяет снизить затраты на ресурсы. 
Это особенно полезно для задач, которые не требуют постоянного доступа к ресурсам, таких как обучение моделей, где можно временно остановить работу ВМ без потери данных.

**Гибкость ресурсов:** \
core_fraction=5: Этот параметр позволяет использовать только часть ядра процессора, что снижает потребление ресурсов и затраты. Это может быть полезно для задач, которые не требуют полной мощности процессора, таких как обучение небольших моделей или выполнение простых вычислений.
### Задание 2 :monkey_face:
**1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**. :white_check_mark:** \
**2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. :white_check_mark:** \
**3. Проверьте terraform plan. Изменений быть не должно.** 
<details>
<summary>variables.tf</summary>

```*.tf
###cloud vars

variable "yc_token" {
  type        = string
}

variable "yc_cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "yc_folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "yc_region" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_public_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
}

variable "vm_web_cores" {
  type = number
  default = 2
}

variable "vm_web_memory" {
  type = number
  default = 1
}

variable "vm_web_core_fraction" {
  type = number
  default = 5
}
```

</details>

<details>
<summary>main.tf</summary>

```*.tf
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.yc_region
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }

}
```

</details>

```Bash
root@core-vm:/home/tvadim/terraform_hw_02/terraform-yc_mv# terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpjv0rnpo2ff83khfj7]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd84lhq77fmk7rffj7g1]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bgnp2g7nj6h2g747b5]
yandex_compute_instance.platform: Refreshing state... [id=fhmv985qckiap8em1gq3]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```
### Задание 3 :hear_no_evil:

**1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ. :white_check_mark:** \
**2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"**

<details>
<summary>variables.tf</summary>

```*.tf
###cloud vars

variable "yc_token" {
  type	      = string
}

variable "yc_cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "yc_folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "yc_region" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "yc_region_vm2" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_public_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

### var for VM1
variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
}

variable "vm_web_cores" {
  type = number
  default = 2
}

variable "vm_web_memory" {
  type = number
  default = 1
}

variable "vm_web_core_fraction" {
  type = number
  default = 5
}

### var for VM2

variable "vm_db_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v1"
}

variable "vm_db_cores" {
  type = number
  default = 2
}

variable "vm_db_memory" {
  type = number
  default = 2
}

variable "vm_db_core_fraction" {
  type = number
  default = 20
}
```

</details>

<details>
<summary>vms_platform.tf</summary>

```*.tf

data "yandex_compute_image" "vm2" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "vm2" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }

}

```

</details>

**3. Примените изменения.**

```Bash
yandex_compute_instance.vm2: Creating...
yandex_compute_instance.vm2: Still creating... [10s elapsed]
yandex_compute_instance.vm2: Still creating... [20s elapsed]
yandex_compute_instance.vm2: Still creating... [30s elapsed]
yandex_compute_instance.vm2: Creation complete after 36s [id=fhmk5qfui8dmrcudu784]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
![img.png](https://github.com/vadimtsvetkov/terraform_hw_02/blob/main/screen/ter-yc_3.png)

### Задание 4 :speak_no_evil:

**1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)**


```output.tf

output "vm_platform_ip_address" {
  value = yandex_compute_instance.platform.*.network_interface.0.nat_ip_address
  description = "vm_platform external ip"
}


output "vm_db_ip_address" {
  value = yandex_compute_instance.vm2.*.network_interface.0.nat_ip_address
  description = "vm_db external ip"
}

```


**2. Примените изменения. В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.**

```Bash

root@core-vm:/home/tvadim/terraform_hw_02/terraform-yc_mv# terraform output
vm_db_ip_address = [
  "51.250.80.58",
]
vm_platform_ip_address = [
  "51.250.80.73",
]
```

### Задание 5 :monkey_face:

**1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.**

```*.tf
locals.tf

locals {
 name_platform = "${var.vm_web_name}"
 name_db = "${var.vm_db_name}"
}

```
**2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.**

```*.tf
main.tf

resource "yandex_compute_instance" "platform" {
  name        = local.name_platform
  ....
}

vms_platform.tf

resource "yandex_compute_instance" "vm2" {
  name        = local.name_db
  ...
}
```

**3. Примените изменения. :white_check_mark:**

### Задание 6 :tiger:

**1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).**

```*.tf
variables.tf

variable "vms_resources" {
  default = {
    web = {
      cores = 2
      memory = 1
      fraction = 5
    },
    db = {
      cores = 2
      memory = 2
      fraction = 20
    }
  }
}

```

```*.tf
main.tf

resource "yandex_compute_instance" "platform" {
  name        = local.name_platform
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.fraction
  }

```

```*.tf
vms_platform.tf

resource "yandex_compute_instance" "vm2" {
  name        = local.name_db
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.fraction
  }

```

**3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.**

```*.tf
variables.tf

variable "metadata" {
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-rsa ***"
  }
}

```

```В файлах main.tf и vms_platform.tf указал metadata = var.metadata```
  
**5. Найдите и закоментируйте все, более не используемые переменные проекта. :white_check_mark:** \
**6. Проверьте terraform plan. Изменений быть не должно. :white_check_mark:** 


