FROM hashicorp/terraform:0.11.10

RUN apk add --no-cache \
        bash \
        ruby \
        ruby-json \
        curl \
        ca-certificates \
        openssl \
        gettext \
        apache2-utils \
        python \
        py-pip \
        py-setuptools \
        && \
    pip --no-cache-dir install \
        awscli \
        && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    gem install terraform_landscape --no-rdoc --no-ri && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh && \
    chmod +x /tmp/get_helm.sh && \
    /tmp/get_helm.sh

# we want to be able to run non-terraform commands so we remove the entrypoint
ENTRYPOINT [""]

CMD ["bash"]
