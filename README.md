# WebSight Charts
![Version: 1.5.0](https://img.shields.io/badge/Version-1.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.19.0](https://img.shields.io/badge/AppVersion-1.19.0-informational?style=flat-square)

This chart bootstraps WebSight CMS deployment on a Kubernetes cluster using the Helm package manager.

[WebSight](https://websight.io/) is a Digitial Experience Platform driven by the enterprise-grade CMS.

## Prerequisites

- Kubernetes cluster with at least 8 GB ram and 2 CPU
- Ingress installed on k8s cluster (you may use e.g. [Nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/)).
- Helm 3.6+

## CMS

### Quick start

> Important!!!
> Make sure to install [Nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/) before installing WebSight CMS.

```bash
helm upgrade --install my-websight websight-cms \
  --repo https://websight-io.github.io/charts \
  --namespace ws --create-namespace --set ingress.enabled=true
```

> WebSight instance will be available at:
> - CMS Panel: http://cms.127.0.0.1.nip.io
> - Demo sites:
>   - http://kyanite.127.0.0.1.nip.io
>   - http://luna-low-code.127.0.0.1.nip.io
>   - http://luna.127.0.0.1.nip.io
>   - http://luna-no-code.127.0.0.1.nip.io

### Installing the Chart
To install the chart with the release name `my-websight` using existing domain that points to your Kubernetes cluster, run:
```bash
helm repo add websight https://websight-io.github.io/charts
helm install --set ingress.enabled=true --set ingress.hosts.cms=cms.my-page.domain --set ingress.hosts.sites={'my-page.domain'} my-websight websight/websight-cms -n ws --create-namespace
```

This command deploys WebSight CE on Kubernetes cluster with the default configuration using `ws` namespace.
The [Parameters](#parameters) section lists the parameters that can be configured.

### Uninstalling the Chart
To uninstall/delete the deployment run:
```bash
helm uninstall my-websight -n ws
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

### Parameters
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cms.customAdminSecret | string | `nil` | Name of the secret (without release name prefix) where custom admin password is stored under `WS_ADMIN_PASSWORD` key |
| cms.debug.enabled | bool | `false` | enables WebSight CMS debug on port 5005 |
| cms.env | list | `[{"name":"LEASE_CHECK_MODE","value":"LENIENT"}]` | WebSight CMS environment variables |
| cms.envsFromConfig | list | `[]` | List of WebSight CMS config maps that will work with `configMapRef` |
| cms.envsFromSecret | list | `[]` | List of WebSight CMS secrets that will work with `secretRef` |
| cms.image.pullPolicy | string | `"IfNotPresent"` | WebSight CMS project image pull policy |
| cms.image.repository | string | `"public.ecr.aws/ds/websight-cms-starter"` | WebSight CMS project image repository |
| cms.image.tag | string | `nil` | WebSight CMS project image tag, overwrites value from `.Chart.appVersion` |
| cms.imagePullSecrets | list | `[]` | cms image pull secrets |
| cms.livenessProbe.enabled | bool | `true` | enables WebSight CMS pods liveness probe |
| cms.livenessProbe.failureThreshold | int | `3` |  |
| cms.livenessProbe.initialDelaySeconds | int | `30` |  |
| cms.livenessProbe.periodSeconds | int | `10` |  |
| cms.livenessProbe.successThreshold | int | `1` |  |
| cms.livenessProbe.timeoutSeconds | int | `3` |  |
| cms.nodeSelector | object | `nil` | CMS node selector |
| cms.readinessProbe.enabled | bool | `true` | enables WebSight CMS pods readiness probe |
| cms.readinessProbe.failureThreshold | int | `3` |  |
| cms.readinessProbe.initialDelaySeconds | int | `30` |  |
| cms.readinessProbe.periodSeconds | int | `30` |  |
| cms.readinessProbe.successThreshold | int | `1` |  |
| cms.readinessProbe.timeoutSeconds | int | `10` |  |
| cms.replicas | int | `1` | number of WebSight CMS replicas |
| cms.resources.limits.cpu | string | `"1000m"` | WebSight CMS limits cpu resources |
| cms.resources.limits.memory | string | `"4Gi"` | WebSight CMS limits memory resources |
| cms.resources.requests.cpu | string | `"500m"` | WebSight CMS request cpu resources |
| cms.resources.requests.memory | string | `"1Gi"` | WebSight CMS request memory resources |
| ingress.annotations | object | `{"kubernetes.io/ingress.class":"nginx","nginx.ingress.kubernetes.io/proxy-body-size":"5m"}` | custom ingress annotations |
| ingress.enabled | bool | `false` | enables ingress |
| ingress.hosts.cms | string | `"cms.127.0.0.1.nip.io"` | cms panel host |
| ingress.hosts.sites | list | `[]` | demo sites hosts, should correspond with your `nginx.customServerConfigurations` config |
| mongo.env | list | `[{"name":"MONGO_INITDB_ROOT_PASSWORD","value":"mongoadmin"},{"name":"MONGO_INITDB_ROOT_USERNAME","value":"mongoadmin"}]` | MongoDB Content Store environment variables |
| mongo.image.pullPolicy | string | `"IfNotPresent"` | MongoDB Content Store image pull policy |
| mongo.image.repository | string | `"mongo"` | MongoDB Content Store image repository |
| mongo.image.tag | string | `"4.4.6"` | MongoDB Content Store image tag |
| mongo.livenessProbe.enabled | bool | `true` | enables MongoDB pods liveness probe |
| mongo.livenessProbe.failureThreshold | int | `3` |  |
| mongo.livenessProbe.initialDelaySeconds | int | `15` |  |
| mongo.livenessProbe.periodSeconds | int | `10` |  |
| mongo.livenessProbe.successThreshold | int | `1` |  |
| mongo.livenessProbe.timeoutSeconds | int | `5` |  |
| mongo.nodeSelector | object | `nil` | MongoDB node selector |
| mongo.replicas | int | `1` | number of MongoDB replicas - valid values are `0` or `1`, do not set above `1` |
| mongo.resources.limits.cpu | string | `"1000m"` | MongoDB limits cpu resources |
| mongo.resources.limits.memory | string | `"4Gi"` | MongoDB limits memory resources |
| mongo.resources.requests.cpu | string | `"500m"` | MongoDB request cpu resources |
| mongo.resources.requests.memory | string | `"1Gi"` | MongoDB request memory resources |
| mongo.storage.size | string | `"2Gi"` | MongoDB Repository volume size |
| nginx.configurationTemplates | list | `[]` | list of Nginx custom templates that will be atached to the container under `/etc/nginx/templates/` directory using `configMapRef` and processed by `envsubst` command during the entrypoint execution, read more [here](https://hub.docker.com/_/nginx#:~:text=Using%20environment%20variables%20in%20nginx%20configuration) |
| nginx.customServerConfigurations | list | `[]` | list of Nginx custom configs that will be atached to the container under `/etc/nginx/conf.d/` directory using `configMapRef` |
| nginx.enabled | bool | `true` | enables Web Server |
| nginx.env | list | `[]` | WebSight Nginx environment variables |
| nginx.host | string | `"127.0.0.1.nip.io"` | WebSight Nginx host name used for Nginx config, overwrite it to change the nginx configurations `server_name` |
| nginx.image.pullPolicy | string | `"IfNotPresent"` | Web Server image pull policy |
| nginx.image.repository | string | `"nginx"` | Web Server image repository |
| nginx.image.tag | string | `"1.23.3"` | Web Server project image tag |
| nginx.livenessProbe.enabled | bool | `true` | enables WebSight Nginx pods liveness probe |
| nginx.livenessProbe.failureThreshold | int | `6` |  |
| nginx.livenessProbe.initialDelaySeconds | int | `5` |  |
| nginx.livenessProbe.periodSeconds | int | `5` |  |
| nginx.livenessProbe.successThreshold | int | `1` |  |
| nginx.livenessProbe.timeoutSeconds | int | `1` |  |
| nginx.nodeSelector | object | `nil` | WebSight Nginx node selector |
| nginx.replicas | int | `2` | number of Web Server replicas |
| nginx.resources.limits.cpu | string | `"100m"` | WebSight Nginx limits cpu resources |
| nginx.resources.limits.memory | string | `"100Mi"` | WebSight Nginx limits memory resources |
| nginx.resources.requests.cpu | string | `"50m"` | WebSight Nginx request cpu resources |
| nginx.resources.requests.memory | string | `"50Mi"` | WebSight Nginx request memory resources |
| siteRepository.enabled | bool | `true` | enables Site Repository volume |
| siteRepository.rwxStorageClassName | string | `nil` | Configure storageClassName in case you want to use `ReadWriteMany` access mode |
| siteRepository.storage.size | string | `"2Gi"` | Site Repository volume size |

### configuration

#### Custom CMS admin username and password

> Important!!!
>
> Setting custom username and password for the CMS administrator is possible only during the first installation!

By default, the CMS deployment runs an admin panel instance with default `wsadmin/wsadmin` credentials. To set a custom username and password, use Secret named `<Release name>-your-name`
with `WS_ADMIN_USERNAME` and `WS_ADMIN_PASSWORD` values configured and configure `cms.envsFromSecret` and `cms.customAdminSecret` accordingly.

Example:

> cms-secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ $.Release.Name }}-cms-admin
type: Opaque
stringData:
  WS_ADMIN_USERNAME: myadmin # WebSight CMS reads this env to set up the admin username during the first launch
data:
  WS_ADMIN_PASSWORD: c2VjcmV0UGFzcw== #base64 encoded
immutable: true
```

> values.yaml
```yaml
cms:
  envsFromSecret:
    - cms-admin                # add all `<Release name>-cms-admin` secrets as env variables (this is how CMS reads custom username)
  customAdminSecret: cms-admin # mount `<Release name>-cms-admin` secret for CMS pod and add value from `WS_ADMIN_PASSWORD` key as a secret file (this is how CMS reads custom password)
```

#### Nginx custom configuration

> Out-of-the-box, nginx doesn't support environment variables inside most configuration blocks. But this image has a function, which will extract environment variables before nginx starts.

Read more about the mechanics [here](https://hub.docker.com/_/nginx#:~:text=Using%20environment%20variables%20in%20nginx%20configuration).

Use `nginx.configurationTemplates` to add custom configuration templates to the nginx via configMapRef and `nginx.env` to pass the environment variables to the nginx.

## Improvements (help wanted)

- `*` use Community MongoDB Operator instead of custom mongo chart