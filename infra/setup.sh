#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "=== Setting up S3 + CloudFront for $DOMAIN ==="
echo ""

# 1. Create S3 bucket in us-west-2
echo "--- Creating S3 bucket: $BUCKET_NAME ---"
aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION"

# Block all public access
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "S3 bucket created: $BUCKET_NAME (us-west-2, private)"
echo ""

# 2. Create CloudFront Origin Access Control
echo "--- Creating CloudFront Origin Access Control ---"
OAC_ID=$(aws cloudfront create-origin-access-control \
    --origin-access-control-config \
        "Name=${DOMAIN}-oac,Description=OAC for ${DOMAIN},SigningProtocol=sigv4,SigningBehavior=always,OriginAccessControlOriginType=s3" \
    --query 'OriginAccessControl.Id' \
    --output text)

echo "OAC created: $OAC_ID"
echo ""

# 3. Request ACM certificate in us-east-1
echo "--- Requesting ACM certificate in us-east-1 ---"
CERT_ARN=$(aws acm request-certificate \
    --region "$ACM_REGION" \
    --domain-name "$DOMAIN" \
    --validation-method DNS \
    --query 'CertificateArn' \
    --output text)

echo "Certificate requested: $CERT_ARN"
echo ""

# Wait for ACM to populate the validation records
sleep 5

# Get the DNS validation record
echo "--- DNS validation required ---"
VALIDATION_RECORD=$(aws acm describe-certificate \
    --region "$ACM_REGION" \
    --certificate-arn "$CERT_ARN" \
    --query 'Certificate.DomainValidationOptions[0].ResourceRecord')

VALIDATION_NAME=$(echo "$VALIDATION_RECORD" | python3 -c "import sys,json; print(json.load(sys.stdin)['Name'])")
VALIDATION_VALUE=$(echo "$VALIDATION_RECORD" | python3 -c "import sys,json; print(json.load(sys.stdin)['Value'])")

echo ""
echo "************************************************************"
echo "* ADD THIS DNS RECORD AT YOUR DNS PROVIDER:                *"
echo "************************************************************"
echo "  Type:  CNAME"
echo "  Name:  $VALIDATION_NAME"
echo "  Value: $VALIDATION_VALUE"
echo "************************************************************"
echo ""
echo "Waiting for certificate validation (this will block until you add the DNS record)..."
echo "Press Ctrl+C to abort and re-run later if needed."

aws acm wait certificate-validated \
    --region "$ACM_REGION" \
    --certificate-arn "$CERT_ARN"

echo "Certificate validated!"
echo ""

# 4. Create CloudFront distribution
echo "--- Creating CloudFront distribution ---"

S3_ORIGIN="${BUCKET_NAME}.s3.${AWS_REGION}.amazonaws.com"

DIST_CONFIG=$(cat <<EOF
{
    "CallerReference": "${DOMAIN}-$(date +%s)",
    "Aliases": {
        "Quantity": 1,
        "Items": ["${DOMAIN}"]
    },
    "DefaultRootObject": "index.html",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "S3-${BUCKET_NAME}",
                "DomainName": "${S3_ORIGIN}",
                "OriginAccessControlId": "${OAC_ID}",
                "S3OriginConfig": {
                    "OriginAccessIdentity": ""
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "S3-${BUCKET_NAME}",
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
            "Quantity": 2,
            "Items": ["GET", "HEAD"],
            "CachedMethods": {
                "Quantity": 2,
                "Items": ["GET", "HEAD"]
            }
        },
        "CachePolicyId": "658327ea-f89d-4fab-a63d-7e88639e58f6",
        "Compress": true
    },
    "ViewerCertificate": {
        "ACMCertificateArn": "${CERT_ARN}",
        "SSLSupportMethod": "sni-only",
        "MinimumProtocolVersion": "TLSv1.2_2021"
    },
    "PriceClass": "PriceClass_100",
    "Enabled": true,
    "Comment": "${DOMAIN} static site",
    "HttpVersion": "http2and3"
}
EOF
)

DIST_RESULT=$(aws cloudfront create-distribution \
    --distribution-config "$DIST_CONFIG")

DIST_ID=$(echo "$DIST_RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['Distribution']['Id'])")
DIST_DOMAIN=$(echo "$DIST_RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['Distribution']['DomainName'])")

echo "Distribution created: $DIST_ID"
echo "CloudFront domain: $DIST_DOMAIN"
echo ""

# 5. Set S3 bucket policy to allow CloudFront OAC
echo "--- Setting S3 bucket policy for CloudFront OAC ---"

DIST_ARN=$(echo "$DIST_RESULT" | python3 -c "import sys,json; print(json.load(sys.stdin)['Distribution']['ARN'])")

BUCKET_POLICY=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${DIST_ARN}"
                }
            }
        }
    ]
}
EOF
)

aws s3api put-bucket-policy \
    --bucket "$BUCKET_NAME" \
    --policy "$BUCKET_POLICY"

echo "Bucket policy set."
echo ""

# 6. Print summary
echo "============================================================"
echo "  SETUP COMPLETE"
echo "============================================================"
echo ""
echo "  S3 Bucket:      $BUCKET_NAME (us-west-2)"
echo "  Distribution ID: $DIST_ID"
echo "  CloudFront URL:  https://$DIST_DOMAIN"
echo ""
echo "  NEXT STEPS:"
echo "  1. Add a CNAME (or ALIAS) DNS record at your provider:"
echo "     $DOMAIN -> $DIST_DOMAIN"
echo ""
echo "  2. Update DISTRIBUTION_ID in infra/config.sh:"
echo "     DISTRIBUTION_ID=\"$DIST_ID\""
echo ""
echo "  3. Run infra/deploy.sh to publish your site"
echo "============================================================"
