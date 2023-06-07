# redes-iac

Trabajo práctico para Redes de Información ITBA, tema 13 (Infraestructura como código)

## Introducción

En el siguiente docuemento se detalla la información técnica y los pasos a seguir para la realización del trabajo práctico.

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)
- [Pulumi](https://www.pulumi.com/docs/get-started/install/)

## Instrucciones

El codigo se encuentra estructurado de esta manera:

```
.
├── express-api
│    ├── src
│    │   └── app.js
│    ├── package.json
│    └── package-lock.json
├── front-react
│     ├── src
│     │   └── app.js
│     ├── package.json
│     └── package-lock.json
├── scripts
│     ├── network.sh
│     └── plan_network.sh
├── pulumi
│   └── gcp
│       ├── cloudfunction
│       │   ├── index.js
│       │   ├── package.json
│       │   └── tsconfig.json
│       ├── main.ts
│       └── pulumi.yaml
│
└── terraform
    ├── modules
    │  └── ...
    │    ├── main.tf
    │    ├── outputs.tf
    │    └── variables.tf
    ├─ main.tf
    ├─ locals.tf
    ├─ providers.tf
    ├─ terraform.tfvars
    ├─ versions.tf
    └─ variables.tf

```

La carpeta `express-api` contiene el código de la api en express, la carpeta `front-react` contiene el código del front en react, la carpeta `scripts` contiene los scripts para ejecutar los comandos de terraform y pulumi, la carpeta `pulumi` contiene el código de pulumi para GCP y la carpeta `terraform` contiene el código de terraform para AWS.

Dentro de la carpeta `terraform` se encuentra el archivo `terraform.tfvars` donde se deben definir las variables de terraform. Las variables que se deben definir son las siguientes:

```
domain_name  = "dominio a utilizar"
vpc_cidr     = "cidr de la vpc"
vpc_name     = "nombre de la vpc"
ec2_api_port = puerto de la api

```

Dentro de la carpeta modules se encuentra el código de los módulos de terraform. Los módulos fueron creados para poder reutilizar el código y que sea más fácil de mantener. A su vez permite crear multiples recursos con la misma configuración sin necesidad de repetir el código. Cada módulo posee un archivo `main.tf` donde se define el recurso, un archivo `outputs.tf` donde se definen las salidas del módulo y un archivo `variables.tf` donde se definen las variables del módulo (aka inputs).

Para ejecutar el script de terraform se debe ejecutar el siguiente comando:

```
./scripts/network.sh
```

Para ejecutar el script de pulumi se debe ejecutar el siguiente comando:

```
./scripts/pulumi.sh
```

## Arquitectura

![Arquitectura](./arquitectura.png)

# a -

- Lambda en AWS con terraform
- Cloud function en GCP con Pulumi
- Script que deploye ambos

# b y c (3 horas)

Red en AWS

✅ 1 VPC + 4 subredes (30 min) (2p)

- EC2 con API en express (30 min)(1p)
- Load Balancer (1 hora) (2p)
  ✅ Nat gateway
- Security groups y Nacl(30 min)
- Script que deploye todo (30 min)

# d (1h 15 mins)

- Ponemos lo mismo en otra región y que cloudfront cambie de región si es necesario (45 min)
- Script que cambie la región activa (30 min)

# e (1hs 30 mins)

Static website con s3 cloudfront y dominio propio

- S3 bucket (15 min)
- Template react para subir al s3 (15 min)
- Cloudfront distribution (15 min)
- Route 53 (45 min)

# f (1hr)

- Secret manager (traer secrets necesarios desde la api de express) (45 min)
- KMS para encriptar logs del bucket del static website (45 min)
