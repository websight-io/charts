# WebSight Charts
![Version: 2.2.0](https://img.shields.io/badge/Version-2.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.24.8](https://img.shields.io/badge/AppVersion-1.24.8-informational?style=flat-square)

This chart bootstraps WebSight CMS deployment on a Kubernetes cluster using the Helm package manager.

[WebSight](https://websight.io/) is a Digitial Experience Platform driven by the enterprise-grade CMS.

## Prerequisites

- Kubernetes cluster with at least 4 GB memory and 1 CPU (8 GB/2 CPU if you want to run CMS with MongoDB).
- Ingress Controller installed on k8s cluster (you may use e.g. [Nginx ingress](https://kubernetes.github.io/ingress-nginx/deploy/)).
- Helm 3.8+
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/) (optional - for local development)

## CMS

### Quick start

```bash
helm upgrade --install websight-cms websight-cms \
  --repo https://websight-io.github.io/charts \
  --set cms.ingress.enabled=true \
  --set cms.ingress.host=cms.127.0.0.1.nip.io \
  --namespace websight --create-namespace --wait
```

This command deploys WebSight CMS on Kubernetes cluster with the default configuration in the `websight` namespace and waits until the deployment is ready.

> WebSight instance will be available at:
> - CMS Panel: http://cms.127.0.0.1.nip.io

The default CMS admin credentials are `wsadmin/wsadmin`.

### Uninstalling the Chart
To uninstall/delete the deployment run:
```bash
helm uninstall websight-cms -n websight
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
| cms.ingress.annotations | object | `{"nginx.ingress.kubernetes.io/proxy-body-size":"5m"}` | custom CMS ingress annotations |
| cms.ingress.enabled | bool | `false` | enables CMS ingress |
| cms.ingress.host | string | `nil` | cms host |
| cms.ingress.ingressClassName | string | `"nginx"` | ingress class name |
| cms.ingress.session.cookie | object | `{"expires":172800,"maxAge":172800}` | nginx ingress affinity settings |
| cms.ingress.tls.secretName | string | `nil` | defines the secret name for the TLS certificate, if set, the TLS will be enabled |
| cms.livenessProbe.enabled | bool | `true` | enables pods liveness probe |
| cms.livenessProbe.failureThreshold | int | `3` |  |
| cms.livenessProbe.initialDelaySeconds | int | `30` |  |
| cms.livenessProbe.periodSeconds | int | `10` |  |
| cms.livenessProbe.successThreshold | int | `1` |  |
| cms.livenessProbe.timeoutSeconds | int | `3` |  |
| cms.nodeSelector | object | `nil` | node selector |
| cms.persistence.mode | string | `"tar"` | sets persistence mode, possible options are `tar` or `mongo` |
| cms.persistence.mongo.connectionOptions | string | `""` | mongo connection options |
| cms.persistence.mongo.hosts | string | `"mongodb:27017"` | comma separated list of [mongo hosts](https://www.mongodb.com/docs/manual/reference/connection-string/#standard-connection-string-format) |
| cms.persistence.mongo.passwordSecret | string | `nil` | secret name where mongo admin password is stored under `oak.doc.ns.mongouri.password` key, if not set, default "mongoadmin" password will be used |
| cms.persistence.mongo.username | string | `"mongoadmin"` | mongo admin username |
| cms.persistence.tar.size | string | `"2Gi"` | tar persistance volume size |
| cms.persistence.tar.storageClassName | string | `""` | tar persistance volume storage class |
| cms.readinessProbe.enabled | bool | `true` | enables pods readiness probe |
| cms.readinessProbe.failureThreshold | int | `3` |  |
| cms.readinessProbe.initialDelaySeconds | int | `30` |  |
| cms.readinessProbe.periodSeconds | int | `30` |  |
| cms.readinessProbe.successThreshold | int | `1` |  |
| cms.readinessProbe.timeoutSeconds | int | `10` |  |
| cms.replicas | int | `1` | number of replicas, mind that `tar` persistence mode will create a StatefulSet, while `mongo` will create a Deployment |
| cms.resources | object | `{}` | container's resources settings |
| cms.updateStrategy | object | `{}` | update strategy, works only for `mongo` persistence mode |
| proxy.enabled | bool | `false` | enables proxy |
| proxy.env | list | `[]` | environment variables |
| proxy.image | object | `{"repository":"nginx","tag":"stable-alpine"}` | proxy image repository |
| proxy.imagePullSecrets | list | `[]` | proxy image pull secrets |
| proxy.ingress.annotations | object | `{}` | custom ingress annotations |
| proxy.ingress.ingressClassName | string | `"nginx"` | ingress class name |
| proxy.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":1}` | liveliness probe config |
| proxy.livenessProbe.enabled | bool | `true` | enables pods liveness probe |
| proxy.nodeSelector | object | `nil` | node selector |
| proxy.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":1}` | readiness probe config |
| proxy.readinessProbe.enabled | bool | `true` | enables pods readiness probe |
| proxy.replicas | int | `1` | number of replicas |
| proxy.resources | object | `{}` | container's resources settings |
| proxy.sites | object | `[]` | site configuration, see the `examples/luna-proxy` for more details |
| proxy.updateStrategy | object | `{}` | update strategy |

### Configuration

#### Running CMS with MongoDB as NodeStore

> Note MongoDB support will be available since WebSight CMS version 1.23.0.

1. Install MongoDB, e.g. with one of the following options:
  - Bitnami Helm Chart
    <details><summary>show commands</summary>
    <p>

    ```bash
    helm install mongodb oci://registry-1.docker.io/bitnamicharts/mongodb --version 14.3.0 \
      --set auth.enabled=true \
      --set auth.rootUser="mongoadmin" \
      --set auth.rootPassword="mongoadmin" \
      -n mongo --create-namespace
    ```

    </p>
    </details>

  - `kubectl` and [MongoDB docker image](https://hub.docker.com/_/mongo)
    <details><summary>show commands</summary>
    <p>

    ```bash
    kubectl create namespace mongo
    kubectl -n mongo run mongodb --image=mongo:7 \
      --env MONGO_INITDB_ROOT_USERNAME=mongoadmin \
      --env MONGO_INITDB_ROOT_PASSWORD=mongoadmin
    kubectl -n mongo expose pod mongodb --port=27017 --name=mongodb
    ```
    </p>
    </details>

2. Install CMS with mode `mongo` from `websight-cms` directory:
   ```bash
   helm upgrade --install websight-cms . \
     --set cms.persistence.mode=mongo \
     --set cms.persistence.mongo.hosts='mongodb.mongo:27017' \
     --set cms.livenessProbe.initialDelaySeconds=60 \
     -n websight --create-namespace
   ```

#### Running CMS with Ngninx proxy
To run CMS with Nginx proxy you need to enable it by setting `proxy.enabled` to `true`.

See the [luna-proxy](websight-cms/examples/luna-proxy) example `values.yaml` file for more details on how to configure Nginx to proxy a particular CMS site.

To run the example, clone this repository and follow the steps below:

1. Create `websight` namespace:
   ```bash
   kubectl create namespace websight
   ```
2. From `websight-cms` directory create Nginx proxy configuration as a ConfigMap
   ```bash
   kubectl -n websight create configmap luna-site-config --from-file=examples/luna-proxy/luna-site.conf.template
   ```
3. From `websight-cms` directory install CMS with Nginx proxy enabled:
   ```bash
   helm -n websight upgrade --install websight-cms . \
     -f examples/luna-proxy/values.yaml --wait
   ```
   CMS should start in 1-2 minutes.
   The information about available CMS Panel and Luna site should be printed.

#### Custom CMS admin username and password

> Important!!!
>
> Setting custom username and password for the CMS administrator is possible only during the first installation!

By default, the CMS deployment runs an admin panel instance with default `wsadmin/wsadmin` credentials. To set a custom username and password, use Secret named `<Release name>-your-name`
with `WS_ADMIN_USERNAME` and `WS_ADMIN_PASSWORD` values configured and configure `cms.envsFromSecret` and `cms.customAdminSecret` accordingly. Create secret in the same namespace where CMS is deployed.

Example:

```bash
kubectl create secret generic <Release name>-cms-admin -n websight --from-literal WS_ADMIN_USERNAME=myadmin --from-literal WS_ADMIN_PASSWORD=mys3cretPassw0rd
```

> values.yaml
```yaml
cms:
  envsFromSecret:
    - cms-admin                # add all `<Release name>-cms-admin` secrets as env variables (this is how CMS reads custom username)
  customAdminSecret: cms-admin # mount `<Release name>-cms-admin` secret for CMS pod and add value from `WS_ADMIN_PASSWORD` key as a secret file (this is how CMS reads custom password)
```

### Local development

To run WebSight CMS locally with Kind, clone the repository and follow the steps below:
1. Create a Kind cluster with Ingress Nginx controller:
   ```bash
   kind create cluster --config .github/cluster/kind-cluster.yaml     
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   ```
   And wait until the Ingress controller is ready:
   ```bash
   kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller
   ```
2. Install WebSight CMS with the default configuration from the `websight-cms` directory:
   ```bash
   helm upgrade --install websight-cms . \
     --set cms.ingress.enabled=true \
     --namespace websight --create-namespace --wait
   ```
