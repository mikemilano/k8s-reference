# Cloud SQL

My strategy for using [Cloud SQL](https://cloud.google.com/sql) in GKE K8s applications is to use [Cloud SQL
Proxy](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine) for strong encryption and use of IAM.

> Note: With the SQL Proxy Sidecar attached to your deployment, your database host will be `127.0.0.1`.

## Granting a service account role/cloudsql.client

In order to proxy Cloud SQL from a sidecar, the service account must have the `roles/cloudsql.client` role.

The following command assigns `roles/cloudsql.client` to `my-sa` service account in project `my-project`. 

```bash
gcloud projects add-iam-policy-binding my-project \
--member serviceAccount:sa@myproject.iam.gserviceaccount.com \
--role roles/cloudsql.client
```

## Service Account Secret

If you haven't already, create a secret from the service account key json file.

```bash
kubectl create secret generic <YOUR-SA-SECRET> \
--from-file=service_account.json=~/key.json
```

## Injecting the Cloud SQL Sidecar

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
