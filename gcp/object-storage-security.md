# Object Storage Security

Cloud Storage always encrypts your data on the server side, before it is written to disk, at no additional charge.

- [Encryption](https://cloud.google.com/storage/docs/encryption)
- [Cloud Identity and Access Management](https://cloud.google.com/storage/docs/access-control/iam)
- [Uniform bucket-level access](https://cloud.google.com/storage/docs/uniform-bucket-level-access)
- [Access control lists (ACLs)](https://cloud.google.com/storage/docs/access-control/lists)
- [Cross-origin resource sharing (CORS)](https://cloud.google.com/storage/docs/cross-origin)
- [Tracking updates and access to data via Pub/Sub](https://cloud.google.com/storage/docs/pubsub-notifications)
- [HMAC + User/Service Accounts](https://cloud.google.com/storage/docs/authentication/hmackeys)
- [Signed URLs](https://cloud.google.com/storage/docs/access-control/signed-urls)


## Making data public
```bash
# Make all objects in a bucket publicly readable
gsutil iam ch allUsers:objectViewer gs://[BUCKET_NAME]

# Make individual objects publicly readable
gsutil acl ch -u AllUsers:R gs://[BUCKET_NAME]/[OBJECT_NAME]
```

## Accessing public data

- Console Link: `https://console.cloud.google.com/storage/browser/_details/[BUCKET_NAME]/[OBJECT_PATH]`
- Direct Download: `https://storage.cloud.google.com/[BUCKET_NAME]/[OBJECT_PATH]`







```
