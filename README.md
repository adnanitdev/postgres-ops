# PostgreSQL Backup & Restore Helm Chart

This Helm chart automates the backup and restore process for PostgreSQL databases using `pg_dump` and `psql`.

## 📁 Project Structure

```
postgres-backup-restore/
├── templates/
│   ├── pg-dump-pod.yaml         # Pod that performs pg_dump
│   └── pg-restore-pod.yaml      # Pod used for restoring data using psql
├── values.yaml                  # Source and destination PostgreSQL URIs
├── Chart.yaml                   # Helm chart definition
├── deploy-postgres-backup-restore.sh # Bash script to automate the process
```

## 🔧 Configuration

Edit the `values.yaml` file to specify the source and destination PostgreSQL connection strings:

```yaml
source:
  uri: "postgresql://<user>:<password>@<source-host>:5432/<db>"

restore:
  uri: "postgresql://<user>:<password>@<target-host>:5432/<db>"
```

## 🚀 Usage

1. Make sure `helm`, `kubectl`, and `yq` are installed.
2. Deploy and run the backup/restore process:

```bash
chmod +x deploy-postgres-backup-restore.sh
./deploy-postgres-backup-restore.sh
```

## 📝 Notes

- The dump pod stores `db.sql` in `/dump` and keeps running so you can copy files.
- The restore pod also idles so files can be copied before executing `psql`.
- You can automate the restore further with Kubernetes Jobs or `initContainers`.

## 📦 Requirements

- Helm 3+
- Kubernetes cluster
- PostgreSQL access
- `yq` installed (`brew install yq` or `apt install yq`)

