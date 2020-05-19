# Service Accounts

A service account is a special kind of account used by an application or a virtual machine (VM) instance, not a person. Applications use service accounts to make authorized API calls.

Service accounts are represented as an email address `<id>@<project>.iam.gserviceaccount.com`.

Read more about service accounts [here](https://cloud.google.com/iam/docs/service-accounts).

## Manage Accounts

```bash
# Create
gcloud iam service-accounts create sa-name \
    --description="sa-description" \
    --display-name="sa-display-name"
Created service account [sa-name].

# List
$ gcloud iam service-accounts list
NAME                    EMAIL
sa-display-name-1       sa-name-1@project-id.iam.gserviceaccount.com
sa-display-name-2       sa-name-2@project-id.iam.gserviceaccount.com

# Update
gcloud iam service-accounts update \
    sa-name@project-id.iam.gserviceaccount.com \
    --description="updated-sa-description" \
    --display-name="updated-display-name"
description: updated-sa-description
displayName: updated-display-name
name: projects/project-id/serviceAccounts/sa-name@project-id.iam.gserviceaccount.com

# Disable
gcloud iam service-accounts disable sa-name@project-id.iam.gserviceaccount.com
Disabled service account sa-name@project-id.iam.gserviceaccount.com

# Enable
gcloud iam service-accounts enable sa-name@project-id.iam.gserviceaccount.com
Enabled service account sa-name@project-id.iam.gserviceaccount.com

# Delete
gcloud iam service-accounts delete \
    sa-name@project-id.iam.gserviceaccount.com

# Undelete
gcloud beta iam service-accounts undelete account-id
restoredAccount:
  email: sa-name@project-id.iam.gserviceaccount.com
  etag: BwWWE7zpApg=
  name: projects/project-id/serviceAccounts/sa-name@project-id.iam.gserviceaccount.com
  oauth2ClientId: '123456789012345678901'
  projectId: project-id
  uniqueId: 'account-id'

```

## Managing Keys

Key property `privateKeyData` will be base64 encoded.

```bash
# Create (May take up to 60 seconds)
gcloud iam service-accounts keys create ~/key.json \
  --iam-account sa-name@project-id.iam.gserviceaccount.com
created key [e44da1202f82f8f4bdd9d92bc412d1d8a837fa83] of type [json] as
[/usr/home/username/key.json] for
[sa-name@project-id.iam.gserviceaccount.com]

# List
gcloud iam service-accounts keys list \
  --iam-account sa-name@project-id.iam.gserviceaccount.com
KEY_ID                                    CREATED_AT            EXPIRES_AT
0f1309b4aa6fd678856ee1220b81d082682272db  2020-04-10T23:48:20Z  9999-12-31T23:59:59Z

# Upload public key (List to determine success)
gcloud beta iam service-accounts keys upload /path/to/public_key.pem \
  --iam-account sa-name@project-id.iam.gserviceaccount.com

# Delete
gcloud iam service-accounts keys delete key-id \
  --iam-account sa-name@project-id.iam.gserviceaccount.com
Deleted key [8e6e3936d7024646f8ceb39792006c07f4a9760c] for
service account [sa-name@project-id.iam.gserviceaccount.com]
```

## Granting roles

```bash
# Create 
gcloud projects add-iam-policy-binding my-project-123 \
  --member serviceAccount:my-sa-123@my-project-123.iam.gserviceaccount.com \
  --role roles/editor
bindings:
- members:
  - user:email1@example.com
  role: roles/owner
- members:
  - serviceAccount:our-project-123@appspot.gserviceaccount.com
  - serviceAccount:123456789012-compute@developer.gserviceaccount.com
  - serviceAccount:my-sa-123@my-project-123.iam.gserviceaccount.com
  - user:email3@example.com
  role: roles/editor
- members:
  - user:email2@example.com
  role: roles/viewer
etag: BwUm38GGAQk=
version: 1





```

## Short-lived service accounts

Short-lived service accounts last only a few hours. They can be used to enhance

Short-lived service account credentials are useful for scenarios where you need to grant limited access to resources for trusted service accounts.

[Read more here.](https://cloud.google.com/iam/docs/creating-short-lived-service-account-credentials)

## Reference

- [Service Accounts](https://cloud.google.com/iam/docs/service-accounts)
- [Managing Service Accounts](https://cloud.google.com/iam/docs/creating-managing-service-accounts#iam-service-accounts-create-gcloud)
- [Service Account Keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
- [Short-lived service accoutns](https://cloud.google.com/iam/docs/creating-short-lived-service-account-credentials)
- [Granting Roles](https://cloud.google.com/iam/docs/granting-roles-to-service-accounts#gcloud)
