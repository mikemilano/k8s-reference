# Cloud SQL

My strategy for using [Cloud SQL](https://cloud.google.com/sql) in GKE K8s applications is to use [Cloud SQL
Proxy](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine) for strong encryption and use of IAM.

> Note: With the SQL Proxy Sidecar attached to your deployment, your database host will be `127.0.0.1`.

There are [2 methods](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine#proxy)
 to work with the Cloud SQL Proxy:
1. Proxy with Workload Identity (Recommended by Google)
  - Recommended by Google
  - Associates a Kubernetes Service Account (KSA) to a Google Service Account (GSA)
2. Proxy with Service Account Key
  - Uses mounted secrets

Before you begin, make sure the Cloud SQL API is enabled:

https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com?_ga=2.26801341.1415054126.1589817032-1025133925.1585540116

## Method 1: Proxy with Workload Identity

Enable Workload Identity if you haven't done so yet:
```bash
# Enable Workload Identity (You may have to add --zone if not set in your config)
gcloud container clusters update [cluster-name] \
  --workload-pool=[project-id].svc.id.goog
```

Apply your service account:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: <YOUR-KSA-NAME> # TODO(developer): replace these values
```

Enable the IAM binding between your YOUR-GSA-NAME and YOUR-KSA-NAME:
```bash
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:<YOUR-GCP-PROJECT>.svc.id.goog[<YOUR-K8S-NAMESPACE>/<YOUR-KSA-NAME>]" \
  <YOUR-GSA-NAME>@<YOUR-GCP-PROJECT>.iam.gserviceaccount.com
```

Add an annotation to YOUR-KSA-NAME to complete the binding:
```bash
kubectl annotate serviceaccount \
   <YOUR-KSA-NAME> \
   iam.gke.io/gcp-service-account=<YOUR-GSA-NAME>@<YOUR-GCP-PROJECT>.iam.gserviceaccount.com
```



## Method 2: Proxy with Service Account Key

### Granting a service account role/cloudsql.client

In order to proxy Cloud SQL from a sidecar, the service account must have the `roles/cloudsql.client` role.

The following command assigns `roles/cloudsql.client` to `my-sa` service account in project `my-project`. 

```bash
gcloud projects add-iam-policy-binding my-project \
--member serviceAccount:sa@myproject.iam.gserviceaccount.com \
--role roles/cloudsql.client
```

### Service Account Secret

If you haven't already, create a secret from the service account key json file.

```bash
kubectl create secret generic <YOUR-SA-SECRET> \
--from-file=service_account.json=~/key.json
```

### Injecting the Cloud SQL Sidecar

Add the following container (Sidecar) and volume mount to your deployment config.

```yaml
    - name: cloud-sql-proxy
        # It is recommended to use the latest version of the Cloud SQL proxy
        # Make sure to update on a regular schedule!
        image: gcr.io/cloudsql-docker/gce-proxy:1.17
        command:
          - "/cloud_sql_proxy"

          # If connecting from a VPC-native GKE cluster, you can use the
          # following flag to have the proxy connect over private IP
          # - "-ip_address_types=PRIVATE"

          # Replace DB_PORT with the port the proxy should listen on
          # Defaults: MySQL: 3306, Postgres: 5432, SQLServer: 1433
          - "-instances=<INSTANCE_CONNECTION_NAME>=tcp:<DB_PORT>"

          # This flag specifies where the service account key can be found
          - "-credential_file=/secrets/service_account.json"
        securityContext:
          # The default Cloud SQL proxy image is based on distroless, which
          # runs as the "nonroot" user (uid: 65534) by default.
          runAsNonRoot: true
        volumeMounts:
        - name: <YOUR-SA-SECRET-VOLUME>
          mountPath: /secrets/
          readOnly: true
      volumes:
      - name: <YOUR-SA-SECRET-VOLUME>
        secret:
          secretName: <YOUR-SA-SECRET>
```

## Reference

- [Cloud SQL Project Access Control](https://cloud.google.com/sql/docs/mysql/project-access-control)
- [Cloud SQL Proxy](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine)
