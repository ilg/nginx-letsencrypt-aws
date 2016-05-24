# nginx-letcencrypt-aws

Docker image to run nginx with automatic Let's Encrypt certificate management, verifying through Route53 and storing on S3.

## Environment Variables

The container expects:

- `EMAIL` to tell it what email address to use with Let's Encrypt
- `DOMAINS` to tell it for which domain(s) to get/renew the certificate
- `S3LEGO` to tell it the S3 URL to which to sync the `.lego` directory
- whatever AWS variables are necessary for the S3 syncing and for lego to work with Route53 (typically `AWS_REGION`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`)
