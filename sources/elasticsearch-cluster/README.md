# elasticsearch-cluster

A Helm Chart for Elasticsearch cluster

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 7.12.0](https://img.shields.io/badge/AppVersion-7.12.0-informational?style=flat-square)

## Additional Information

This chart will deploy a multinode elasticsearch cluster. The nodes have identical roles (master, data, ingest), so please have this in mind when deciding the number of replicas. By default, it will start with three nodes.

## Besides the elastic nodes, this chart can deploy:

| Component | Parameter |
| --------- | --------- |
| nginx ingress controller | ```ingress.deployController``` |
| ingress objects for elasticsearch and kibana | ```ingress.enabled ``` |
| kibana | ```kibana.enabled ``` |

## Installing the Chart

### TLS encryption
In case you are deploying the chart with ```elastic.xpack.transportSSLEnabled = 'true'```, cert-manager with custom CRDs need to be deployed before deploying this chart. This can be done using the following commands:

```console
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --set installCRDs=true --namespace=<namespace-name> --create-namespace
```
To install the chart with the release name `my-release` in `my-ns` namespace:

```console
helm repo add bfrunza https://bfrunza.github.io/helm-charts
helm install my-release bfrunza/elasticsearch-cluster --namespace=my-ns --create-namespace
```
### Sample deployments
#### Elastcsearch cluster with TLS transport encryption. NOTE: requires cert-manager to be installed prior
```helm install my-release bfrunza/elasticsearch-cluster --namespace=my-ns --create-namespace --set elastic.xpack.transportSSLEnabled=true ```
#### Elastcsearch cluster with Kibana and Ingress controller
```helm install my-release bfrunza/elasticsearch-cluster --namespace=my-ns --create-namespace --set elastic.xpack.transportSSLEnabled=true --set ingress.enabled=true --set ingress.deployController=true --set kibana.enabled =true ```
#### Deployment on single node Kubernetes cluster
```helm install my-release bfrunza/elasticsearch-cluster --namespace=my-ns --create-namespace --set elastic.useAntiAffinity=false ```

## Future developments
- add support for xpack.security.enabled
- add support for multiple different node roles
- allow single node deployment

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kubernetes.github.io/ingress-nginx | ingress-nginx | 3.29.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certManager.clusterIssuerName | string | `"selfsigned-issuer"` | Selfsigned certificate ClusterIssuer Name |
| elastic.clusterName | string | `"es-k8s-cluster"` | Elastisearch cluster name. This is Elastic specific, not Kubernetes resource |
| elastic.env.javaOpts | string | `"-Xms512m -Xmx512m"` | JAVA_OPTS value to be passed as startup argument |
| elastic.image | string | `"docker.elastic.co/elasticsearch/elasticsearch"` | Image repository |
| elastic.replicaCount | int | `3` | Number of Elastic nodes to be deployed |
| elastic.resources.limits | object | `{"cpu":"1000m","memory":"2048Mi"}` | Resource limits |
| elastic.resources.requests | object | `{"cpu":"250m","memory":"1024Mi"}` | Resource requests |
| elastic.service.http.name | string | `"es-public"` | HTTP service name |
| elastic.service.http.port | int | `80` | HTTP service port |
| elastic.service.transport.name | string | `"es-transport"` | Transport service name |
| elastic.service.transport.port | int | `9300` | Transport service port |
| elastic.statefulSetName | string | `"es-node"` | Elasticsearch cluster StetefulSet name. This will be used as base for node names |
| elastic.transportCertificate.name | string | `"elastic-transport"` | Transport certificate object name |
| elastic.transportCertificate.secret | string | `"elastic-transport-certificate"` | Secret name to store transport certificate |
| elastic.useAntiAffinity | bool | `true` | If enabled, will not allow two pods to run on the same node |
| elastic.volume.certificates.mount | string | `"/usr/share/elasticsearch/config/certs"` | Volume mountpoint for transport certificate |
| elastic.volume.certificates.name | string | `"elastic-transport-certificate"` | Volume name for transport certificate |
| elastic.volume.data | object | `{"name":"data","size":"1Gi"}` | Data volume name and size |
| elastic.xpack.monitoringCollectionEnabled | bool | `true` | If enabled, internal monitoring collection is enabled |
| elastic.xpack.transportSSLEnabled | bool | `false` | If enabled, internal cluster communication will be encrypted using the transport certificate |
| elastic.xpack.transportSSLMode | string | `"certificate"` | Transport validation mode as defined by Elastic. In "certificate" mode, certificate is matched against CA, hostnames are not validates |
| elasticCA.certificateCommonName | string | `"Internal Certificate CA"` | CA Common Name |
| elasticCA.certificateName | string | `"elastic-ca"` | Resource name for internal CA signing certificate |
| elasticCA.certificateSecret | string | `"elastic-ca-certificate"` | Secret name to store the internal CA signing certificate |
| elasticCA.issuerName | string | `"elastic-ca-issuer"` | Certificate issuer name |
| ingress-nginx.fullnameOverride | string | `"nginx-ingress-ingress-nginx"` | Needed as a workaround for a bug in the nginx controller chart |
| ingress.deployController | bool | `false` | If enabled, nginx ingess controller will be deployed |
| ingress.elasticPath | string | `"es"` | Path for Elasticsearch cluster |
| ingress.enabled | bool | `false` | If enabled, creates ingress objects for deployed resources |
| ingress.kibanaPath | string | `"kibana"` | Path for Kibana |
| ingress.name | string | `"elastic-ingress"` | Ingress name |
| kibana.appLabel | string | `"kibana"` | Value for app label for Kibana resources |
| kibana.deploymentName | string | `"kibana"` | Kibana deployment name |
| kibana.elasticUsername | string | `"kibana_system"` | Username for Kibana to Elastic communication |
| kibana.enabled | bool | `false` | If enabled, Kibana will de deployed |
| kibana.image | string | `"docker.elastic.co/kibana/kibana"` | Kibana image |
| kibana.serviceName | string | `"kibana-service"` | Kibana service name |
| kibana.servicePort | int | `80` | Kibana service port |
| nameOverride | string | `""` | Override the name of the chart in labels |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)