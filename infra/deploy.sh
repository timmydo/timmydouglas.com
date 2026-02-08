#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
source "$SCRIPT_DIR/config.sh"

if [ -z "$DISTRIBUTION_ID" ]; then
    echo "Error: DISTRIBUTION_ID is not set in infra/config.sh"
    echo "Run infra/setup.sh first, then update config.sh with the distribution ID."
    exit 1
fi

echo "--- Building site ---"
(cd "$REPO_ROOT" && hugo --gc --minify)

echo "--- Syncing to S3 ---"
aws s3 sync "$REPO_ROOT/public/" "s3://$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --delete \
    --cache-control "max-age=3600"

echo "--- Invalidating CloudFront cache ---"
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id "$DISTRIBUTION_ID" \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

echo "Invalidation created: $INVALIDATION_ID"
echo "Deploy complete. Changes may take a few minutes to propagate."
