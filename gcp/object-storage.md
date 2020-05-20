# Object Storage

Object storage is the equivalent to AWS S3

## Storage Classes
There are 4 different storage classes: MSD=Minimum Storage Duration
- `STANDARD` $0.026/GB/Month 
- `NEARLINE` $0.010/GB/Month - 30 day MSD
- `COLDLINE` $0.007/GB/Month - 90 day MSD
- `ARCHIVE` $0.004/GB/Month - 365 day MSD

## Bucket Locations
[Bucket locations](https://cloud.google.com/storage/docs/locations) can be set to:
- A single region
- A dual-region (specific pair of regions)
- A multi-region (i.e. continents)

## Notable & Obscure Features/Concepts
- [Object Versioning](https://cloud.google.com/storage/docs/object-versioning) (Dedicated section below)
- [Composite Objects](https://cloud.google.com/storage/docs/composite-objects)
- [Resumable Uploads](https://cloud.google.com/storage/docs/resumable-uploads)
- [Streaming Transfers](https://cloud.google.com/storage/docs/streaming)
- [Retention Policy](https://cloud.google.com/storage/docs/bucket-lock) (Dedicated section below)
- [Object Holds](https://cloud.google.com/storage/docs/object-holds) (Dedicated section below)
- [Object Lifecycle Management (TTL)](https://cloud.google.com/storage/docs/lifecycle) (Dedicated section below)

## Specifying Projects
The `gsutil mb`, `gsutil ls`, and `gsutil kms` commands require you to specify a project, unless you have set a default project. 
If you have not set a default project, or if you would like to use a different project, use the -p flag to specify a project. 
No other gsutil commands require you to specify a project.

## Manage Buckets

Notes:
- [Uniform bucket level access](https://cloud.google.com/storage/docs/uniform-bucket-level-access) flag sets bucket to use [Cloud IAM](https://cloud.google.com/storage/docs/access-control/iam) insteadof [ACLs](https://cloud.google.com/storage/docs/access-control/lists).

```bash
# Make bucket: -p <project> -c <storage class> 
#  -l <location> i.e. US-EAST1
# -b Enable uniform bucket-level access
gsutil mb -p [PROJECT] -l US-CENTRAL1 gs://[BUCKET_NAME]

# List buckets
gsutil ls

# Change storage class
gsutil defstorageclass set [STORAGE_CLASS] gs://[BUCKET_NAME]

# Get bucket size
gsutil du -s gs://[BUCKET_NAME]/

# Get metadata
gsutil ls -L -b gs://[BUCKET_NAME]/

# Copy bucket (There is no rename)
gsutil mb gs://[BUCKET_NAME]/
gsutil cp -r gs://[SOURCE_BUCKET]/* gs://[DESTINATION_BUCKET]

# Delete bucket
gutil rm -r gs://[BUCKET_NAME]

# Delete contents but keep bucket
gutil rm -a gs://[BUCKET_NAME]/**
```

## Manage Objects

```bash
# Upload single objects
gsutil cp [OBJECT_LOCATION] gs://[DESTINATION_BUCKET_NAME]/

# Upload recursive objects
gsutil cp -r [OBJECT_LOCATION] gs://[DESTINATION_BUCKET_NAME]/

# List objects (Linux ls, complete with wildcards)
gsutil ls gs://[BUCKET_NAME]/*

# List objects recursively
gsutil ls -r gs://[BUCKET_NAME]/**

# Download object (Linux cp)
gsutil cp gs://[BUCKET_NAME]/[OBJECT_NAME] [SAVE_TO_LOCATION]

# Download objects recursively  (Linux cp -r)
gsutil cp -r gs://[BUCKET_NAME]/* [SAVE_TO_LOCATION]

# Rename/Move object (Linux mv)
gsutil mv gs://[BUCKET_NAME]/[OLD_OBJECT_NAME] gs://[BUCKET_NAME]/[NEW_OBJECT_NAME]

# Copy object (Linux cp)
gsutil cp gs://[SOURCE_BUCKET_NAME]/[SOURCE_OBJECT_NAME] gs://[DESTINATION_BUCKET_NAME]/[NAME_OF_COPY]

# Change object storage classes
gsutil rewrite -s [STORAGE_CLASS] gs://[PATH_TO_OBJECT]

# View object metadata
gsutil stat gs://[BUCKET_NAME]/[OBJECT_NAME]

# Edit object metadata
gsutil setmeta -h "[METADATA_KEY]:[METADATA_VALUE]" gs://[BUCKET_NAME]/[OBJECT_NAME]

# Create composite object (Assembles objects uploaded separately or in parallel)
# https://cloud.google.com/storage/docs/composite-objects
gsutil compose gs://[BUCKET_NAME]/[SOURCE_OBJECT_1] gs://[BUCKET_NAME]/[SOURCE_OBJECT_2] gs://[BUCKET_NAME]/[COMPOSITE_OBJECT_NAME]

# Delete object
gsutil rm gs://[BUCKET_NAME]/[OBJECT_NAME]
```

## Object Versioning

```bash
# Enable versioning on bucket
gsutil versioning set on gs://[BUCKET_NAME]

# Disable versioning on bucket
gsutil versioning set off gs://[BUCKET_NAME]

# Check if versioning is enabled
gsutil versioning get gs://[BUCKET_NAME]

# Access versions via: [OBJECT_NAME]#[GENERATION_NUMBER]
# Copy noncurrent object version
gsutil cp gs://[SOURCE_BUCKET_NAME]/[SOURCE_OBJECT_NAME]#[GENERATION_NUMBER] gs://[DESTINATION_BUCKET_NAME]/[DESTINATION_OBJECT_NAME]

# Delete noncurrent object version
gsutil rm gs://[BUCKET_NAME]/[OBJECT_NAME]#[GENERATION_NUMBER]
```

## Retention and Object Holds
```bash
# Set retention policy
gsutil retention set [TIME_DURATION] gs://[BUCKET_NAME]

# Remove retention policy
gsutil retention clear gs://[BUCKET_NAME]

# Lock a bucket and permanently restrict edits to the bucket's policy 
gsutil retention lock gs://[BUCKET_NAME]

# View bucket's retention policy and lock status
gsutil retention get gs://[BUCKET_NAME]

# Enabling the default event-based hold property
gsutil retention event-default set gs://[BUCKET_NAME]

# Get default hold status of a bucket
gsutil ls -L -b gs://[BUCKET_NAME]/

# Disable a default event-based hold
gsutil retention event-default release gs://[BUCKET_NAME]

# Placing an object hold
gsutil retention [HOLD_TYPE] set gs://[BUCKET_NAME]/[OBJECT_NAME]

# Releasing an object hold
gsutil retention [HOLD_TYPE] release gs://[BUCKET_NAME]/[OBJECT_NAME]
```

## Object Lifecycles

[Lifecycles](https://cloud.google.com/storage/docs/managing-lifecycles) require a JSON file definition and a bucket.
```bash
# Enable lifecycle management
gsutil lifecycle set [LIFECYCLE_CONFIG_FILE] gs://[BUCKET_NAME]

# Disable lifecycle management (file is empty json, i.e. {})
gsutil lifecycle set [LIFECYCLE_CONFIG_FILE] gs://[BUCKET_NAME]

# Check lifecycle config on a bucket
gsutil lifecycle get gs://[BUCKET_NAME]

```
