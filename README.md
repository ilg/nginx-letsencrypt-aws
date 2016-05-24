# nginx-letcencrypt-aws

Docker image to run [nginx](http://nginx.org/) with automatic [Let's Encrypt](https://letsencrypt.org/) certificate management, verifying through Route53 and storing on S3.

## :warning: INCOMPLETE :warning:

This is not at all complete yet.  Don't use it.  Really, just don't.  Maybe it'll be ready for use some day soon, but that day is probably not today.  If you use this, you're doing so at your own risk.  You've been warned.

## How it Works

This image derives from [nginx:alpine](https://hub.docker.com/_/nginx/) (in particular, since Alpine provides cron), adds [the s6 overlay](https://github.com/just-containers/s6-overlay) for process supervision (easy way to have a startup script and allow cron jobs to run), uses the [AWS CLI](https://aws.amazon.com/cli/) to sync with S3 (and this requires installing Python), and uses [lego](https://github.com/xenolf/lego) to talk to [Let's Encrypt](https://letsencrypt.org/) and handle the Route53 DNS verification stuff.

At startup, before nginx is launched, the contents of the S3 lego URL are copied to the local filesystem at `/.lego/`.  If the appropriate certificate for the domain name isn't present, it's generated using lego and copied back to S3.

A daily cron job uses lego to renew the certificate if it's close enough to expiration.  If the certificate files change, the cron job also copies them to S3 and makes nginx reload.

The nginx configuration in this image is not changed from the official nginx image.  Actually making use of the SSL certificates requires that you apply your own configuration in some fashion.  Typically, the certificate for example.com will be `/.lego/certificates/example.com.crt` with key `/.lego/certificates/example.com.key`.

## Environment Variables

The container expects:

- `EMAIL` to tell it what email address to use with Let's Encrypt
- `DOMAINS` to tell it for which domain(s) to get/renew the certificate (multiple should be specified like `DOMAINS="example.com --domain=www.example.com --domain=secure.example.com"`
- `S3LEGO` to tell it the S3 URL to which to sync the `.lego` directory
- whatever AWS variables are necessary for the S3 syncing and for lego to work with Route53 (typically `AWS_REGION`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`)

Optional environment variables:
- `RENEW_DAYS` to set the number of days before expiration at which to renew the certificate (defaults to 30)
- `LEGO_SERVER` to set the URL for the ACME server (defaults to the production Let's Encrypt ACME server)
