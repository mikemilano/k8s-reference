# gcloud CLI

## Manage Accounts

### Create config
```
# Create config
gcloud config configurations create myconfig-1
# Activate config
gcloud config configurations activate myconfig-1
# Login
gcloud auth login
# Set project
gcloud config set project mygcp-project
```

### List configurations
```
gcloud config configurations list
```

### Set configuration
```
gcloud config configurations set myconfig-1
```

### List detail of current config
```
gcloud config list
```

### Configuration sets

You can specify different config sets with the `CLOUDSDK_CONFIG` var.

```
CLOUDSDK_CONFIG=/tmp/gcpset1 gcloud auth login
CLOUDSDK_CONFIG=/tmp/gcpset2 gcloud auth login
```

