# Terraform, Kubernetes & Helm Charts
## Archivos
Debajo pueden descargar los archivos:
* [Diagrama](https://drive.google.com/file/d/1z1L_VLYZXhxWTEzjSz6DBI1-Sv-vo_MB/view?usp=sharing)

## Proceso
Vamos a ver el proceso de la creación de un cluster de Kubernetes en Azure utilizando Terraform.


## Programas para instalar
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [tfenv](https://github.com/tfutils/tfenv)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* [helm](https://helm.sh/docs/intro/install/)
* [kubectx/kubens](https://github.com/ahmetb/kubectx)

## Helm líneas comunes
```bash
# Agregar un repositorio
helm repo add <repo-name> <repo-url>
# Actualizar los repositorios para tener las últimas versiones de los charts
helm update
# Listar los repositorios agregados
helm repo list
# Listar los charts de un repositorio
helm search repo 
# Ver el archivo values.yaml de un chart
helm show values <repo>/<chart-name>
# Instalar / actualizar un chart. <release-name> es a elección
helm upgrade --install <release-name> <repo>/<chart-name> --namespace <namespace-name> --create-namespace
# Ver los valores con los cuales fue instalado un chart
helm get values <release-name> --namespace <namespace-name>
```
