# Mongo Restic

Container for backing up Mongodb data using Restic.

## Build and Release

```bash
scripts/release.sh
```

## Usage with Helm

```bash
helm install backupper https://janvotava.github.io/helm-charts/helm-cronjobs-1.0.2.tgz -f values.yaml
```

### values.yaml

```yaml
jobs:
- name: mongodb-restic-backup
  schedule: "20 * * * *"
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
  image:
    repository: votava/mongo-restic
    tag: b5c8cc2d0f5d9f1b99705301d203b3e90958869a
    imagePullPolicy: IfNotPresent
  volumeMounts:
    - mountPath: /.cache
      name: cache
    - name: secrets
      mountPath: "/etc/secrets"
      readOnly: true
  volumes:
    - name: cache
      emptyDir: {}
    - name: secrets
      secret:
        secretName: restic-backups
        optional: false
  failedJobsHistoryLimit: 1
  successfulJobsHistoryLimit: 3
  concurrencyPolicy: Forbid
  restartPolicy: Never
  command: ["/bin/sh"]
  args:
    - -c
    - mongodump mongodb://mongodb:27017
      --oplog --archive |
      restic backup -r b2:bucket-name:/
      --stdin --stdin-filename mongo.archive
      --password-file /etc/secrets/restic.key
```
