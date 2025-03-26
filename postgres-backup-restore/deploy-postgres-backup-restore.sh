#!/bin/bash

set -e

CHART_NAME="postgres-backup-restore"
RELEASE_NAME="pg-job"
NAMESPACE="default"
RESTORE_NAMESPACE=$(yq '.restore.namespace' values.yaml)

echo "[1] Deploying Helm chart..."
helm upgrade --install $RELEASE_NAME . --namespace $NAMESPACE --create-namespace

echo "[2] Waiting for dump pod to be ready..."
kubectl wait --for=condition=Ready pod/pg-dump --timeout=120s -n $NAMESPACE

echo "[3] Copying dump from pg-dump pod..."
kubectl cp $NAMESPACE/pg-dump:/dump ./pg_dump

echo "[4] Copying dump to pg-restore pod..."
kubectl cp ./pg_dump pg-restore:/dump -n $RESTORE_NAMESPACE

echo "[5] Restoring database to target Postgres..."
kubectl exec -it pg-restore -n $RESTORE_NAMESPACE --   psql "$(yq '.restore.uri' values.yaml)" < /dump/db.sql

echo "✅ PostgreSQL backup and restore completed."
