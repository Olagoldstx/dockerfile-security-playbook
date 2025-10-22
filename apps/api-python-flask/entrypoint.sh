#!/usr/bin/env sh
set -e
exec gunicorn -b 0.0.0.0:8080 app:app --workers 2 --threads 2 --timeout 30
