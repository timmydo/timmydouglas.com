# Infrastructure: S3 + CloudFront Static Hosting

Static hosting for timmydouglas.com using AWS S3 and CloudFront.

## Prerequisites

- AWS account with IAM Identity Center (SSO) enabled
- AWS CLI v2 installed (see `install-awscli.sh` for Guix systems)

## AWS CLI Setup

### Install (Guix)

```bash
./infra/install-awscli.sh
```

This downloads AWS CLI v2 to `~/.local/bin/aws` and patches the ELF binary for Guix (fixes the missing dynamic linker and zlib).

### Configure SSO

```bash
~/.local/bin/aws configure sso
```

When prompted:
- **SSO session name**: `blog`
- **SSO start URL**: your Identity Center start URL (e.g. `https://d-xxxxxxxxxx.awsapps.com/start`)
- **SSO region**: `us-west-2`
- **SSO registration scopes**: leave default
- Select your account and the `blog` permission set
- **CLI profile name**: `blog-855728370428`

### Login

```bash
~/.local/bin/aws sso login --profile blog-855728370428
```

Opens a browser for authentication. Tokens are short-lived (no long-lived keys on disk).

Verify:
```bash
~/.local/bin/aws sts get-caller-identity --profile blog-855728370428
```

### Required SSO Permission Set Policies

The `blog` permission set needs:
- `AmazonS3FullAccess`
- `CloudFrontFullAccess`
- `AWSCertificateManagerFullAccess`

## Scripts

| Script | Purpose |
|---|---|
| `install-awscli.sh` | Install + patch AWS CLI for Guix |
| `setup.sh` | One-time: create S3 bucket, CloudFront distribution, ACM cert |
| `deploy.sh` | Ongoing: build Hugo, sync to S3, invalidate CloudFront cache |
| `config.sh` | Shared configuration (bucket name, distribution ID, profile) |

## Deploying

```bash
~/.local/bin/aws sso login --profile blog-855728370428
./infra/deploy.sh
```

## DNS Setup

CloudFront domain: `d1l2jt3jh0j2hn.cloudfront.net`

### Important: Apex domain (timmydouglas.com)

You cannot use a CNAME record at a bare/apex domain (DNS spec limitation).
Options:

1. **ALIAS/ANAME record** — If your DNS provider supports it (Cloudflare, DNSimple, NS1).
   Cloudflare does this automatically when you add a CNAME at the apex ("CNAME flattening").
2. **Route53 Alias** — Move DNS to Route53, which supports Alias records to CloudFront at the apex.
3. **Subdomain only** — Use `www.timmydouglas.com` with a CNAME (works everywhere).

### ACM Certificate Validation

A CNAME record must exist for certificate validation (already added):
- Name: `_92245e98e1fe4d24cb15d6b1e9471c78.timmydouglas.com.`
- Value: `_b8b0d2573f3ce4b7c231522eaf952e12.jkddzztszm.acm-validations.aws.`
