# Terraform doesn't provide a multi-arch image, so we have to build it ourselves.
# See: https://github.com/hashicorp/terraform/issues/25571
# This is based on: https://github.com/clowa/docker-terraform

FROM --platform=$BUILDPLATFORM alpine:3.19 as build

ARG TERRAFORM_VERSION
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk --quiet --update-cache upgrade
RUN apk add --quiet --no-cache --upgrade git curl openssh gnupg perl-utils && \
    curl --silent --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip && \
    curl --silent --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    curl --silent --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    curl --silent --remote-name https://keybase.io/hashicorp/pgp_keys.asc && \
    gpg --import pgp_keys.asc && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    shasum --algorithm 256 --ignore-missing --check terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip -qq terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS* pgp_keys.asc

FROM alpine:3.19 as final
ARG TERRAFORM_VERSION

LABEL "com.hashicorp.terraform.version"="${TERRAFORM_VERSION}"

ADD https://github.com/gruntwork-io/terragrunt/releases/download/v0.44.4/terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN apk --quiet --update-cache upgrade
RUN apk add --no-cache \
        aws-cli \
        bash \
        ruby \
        ruby-json \
        ruby-dev \
        curl \
        ca-certificates \
        openssh \
        openssl \
        gettext \
        git \
        apache2-utils \
        nodejs \
        npm \
        python3 \
        py-pip \
        py-setuptools \
        rsync \
        jq \
    && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -o aws-iam-authenticator https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/darwin/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    gem install terraform_landscape --no-document && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > /tmp/get_helm.sh && \
    chmod +x /tmp/get_helm.sh && \
    /tmp/get_helm.sh && \
    chmod +x /usr/local/bin/terragrunt && \
    rm -fr /tmp/*

COPY --from=build ["/bin/terraform", "/bin/terraform"]
COPY docker-entrypoint /usr/local/bin/docker-entrypoint

# we want to be able to run non-terraform commands so we remove the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]

CMD ["bash"]
