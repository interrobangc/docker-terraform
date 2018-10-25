# interrobangc/terraform

This docker image adds some additional tools to [the official terraform image](https://hub.docker.com/r/hashicorp/terraform/).

It adds kubectl and aws-iam-authenticator to enable support for EKS.

It adds [terraform-landscape](https://github.com/coinbase/terraform-landscape) which cleans up plan output for human consumption.

It removes the docker-entrypoint to simplify more advanced usage.

## Usage

Get terraform version:

```bash
docker run -it --rm interrobangc/terraform terraform version
```

Run terraform init:

```bash
docker run -it --rm -e AWS_DEFAULT_REGION -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -v $(pwd):/app -w /app interrobangc/terraform terraform init
```

Run terraform plan:

```bash
docker run -it --rm -e AWS_DEFAULT_REGION -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -v $(pwd):/app -w /app interrobangc/terraform bash -c "terraform plan | landscape"
```

Run terraform init:

```bash
docker run -it --rm -e AWS_DEFAULT_REGION -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -v $(pwd):/app -w /app interrobangc/terraform terraform apply
```
