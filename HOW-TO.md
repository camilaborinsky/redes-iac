# Infraestructura como código

### Trabajo Práctico Especial - Redes de Información

Autores:

- Agustín Tormakh
- Francisco Quesada
- Camila Borinsky

## Clonar repositorio

## Obtener credenciales

Para poder levantar la red en AWS, se deben obtener las credenciales de AWS. Para esto, se debe crear un usuario en AWS con permisos de administrador y obtener las credenciales de este usuario. Estas credenciales se deben guardar en el archivo `terraform/.env` con el siguiente formato:

```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_SESSION_TOKEN=
```

## Levantar una red en AWS

Para levantar la red en AWS, se debe ejecutar el script `network.sh` ubicado en la carpeta `scripts`. Este script se encarga de ejecutar los comandos necesarios para levantar la red en AWS utilizando `terraform`.

```
cd scripts
./network.sh
```
