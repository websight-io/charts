# WebSight Charts
![Version: 2.0.0](https://img.shields.io/badge/Version-2.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.22.1](https://img.shields.io/badge/AppVersion-1.22.1-informational?style=flat-square)

This chart bootstraps WebSight CMS deployment on a Kubernetes cluster using the Helm package manager.

[WebSight](https://websight.io/) is a Digitial Experience Platform driven by the enterprise-grade CMS.

## Prerequisites

- Kubernetes cluster with at least 8 GB ram and 2 CPU
- Ingress installed on k8s cluster (you may use e.g. [Nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/)).
- Helm 3.8+

## CMS

### Quick start

> Important!!!
> Make sure to install [Nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/) before installing WebSight CMS.

```bash
helm upgrade --install websight-cms websight-cms \
  --repo https://websight-io.github.io/charts \
  --namespace cms --create-namespace --set ingress.enabled=true
```

> WebSight instance will be available at:
> - CMS Panel: http://cms.127.0.0.1.nip.io

### Installing the Chart
To install the chart with the release name `websight-cms` using the existing domain that points to your Kubernetes cluster, run:
```bash
helm repo add websight https://websight-io.github.io/charts
helm install --set ingress.enabled=true --set ingress.hosts.cms=cms.my-page.domain websight-cms websight/websight-cms -n cms --create-namespace
```

This command deploys WebSight CMS on Kubernetes cluster with the default configuration in the `cms` namespace.
The [Parameters](#parameters) section lists the parameters that can be configured.

### Uninstalling the Chart
To uninstall/delete the deployment run:
```bash
helm uninstall websight-cms -n cms
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

### Parameters
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cms.customAdminSecret | string | `nil` | Name of the secret (without release name prefix) where custom admin password is stored under `WS_ADMIN_PASSWORD` key |
| cms.debug.enabled | bool | `false` | enables debug on port 5005 |
| cms.env | list | `[]` | environment variables |
| cms.envsFromConfig | list | `[]` | List of config maps that will work with `configMapRef` |
| cms.envsFromSecret | list | `[]` | List of secrets that will work with `secretRef` |
| cms.image.pullPolicy | string | `"IfNotPresent"` | project image pull policy |
| cms.image.repository | string | `"europe-docker.pkg.dev/websight-io/public/websight-cms-starter"` | project image repository |
| cms.image.tag | string | `nil` | project image tag, overwrites value from `.Chart.appVersion` |
| cms.imagePullSecrets | list | `[]` | cms image pull secrets |
| cms.livenessProbe.enabled | bool | `true` | enables pods liveness probe |
| cms.livenessProbe.failureThreshold | int | `3` |  |
| cms.livenessProbe.initialDelaySeconds | int | `30` |  |
| cms.livenessProbe.periodSeconds | int | `10` |  |
| cms.livenessProbe.successThreshold | int | `1` |  |
| cms.livenessProbe.timeoutSeconds | int | `3` |  |
| cms.nodeSelector | object | `nil` | node selector |
| cms.persistence.mode | string | `"tar"` | sets persistence mode, currenly `tar` is the only supported mode |
| cms.persistence.tar.size | string | `"2Gi"` | tar persistance volume size |
| cms.persistence.tar.storageClassName | string | `""` | tar persistance volume storage class |
| cms.readinessProbe.enabled | bool | `true` | enables pods readiness probe |
| cms.readinessProbe.failureThreshold | int | `3` |  |
| cms.readinessProbe.initialDelaySeconds | int | `30` |  |
| cms.readinessProbe.periodSeconds | int | `30` |  |
| cms.readinessProbe.successThreshold | int | `1` |  |
| cms.readinessProbe.timeoutSeconds | int | `10` |  |
| cms.resources | object | `{}` | container's resources settings |
| ingress.annotations | object | `{"kubernetes.io/ingress.class":"nginx","nginx.ingress.kubernetes.io/proxy-body-size":"5m"}` | custom ingress annotations |
| ingress.enabled | bool | `false` | enables ingress |
| ingress.hosts.cms | string | `"cms.127.0.0.1.nip.io"` | cms host |

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
