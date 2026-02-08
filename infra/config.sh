#!/usr/bin/env bash
# Shared configuration for infra scripts

BUCKET_NAME="timmydouglas.com"
DOMAIN="timmydouglas.com"
AWS_REGION="us-west-2"
ACM_REGION="us-east-1"  # Required by CloudFront — only the cert lives here
AWS_PROFILE="blog-855728370428"  # Uses IAM Identity Center (SSO) for short-lived tokens

export AWS_PROFILE

# Populated after running setup.sh
DISTRIBUTION_ID="EVOZ54LV0E9WV"
