FROM hashicorp/terraform:0.11.14
RUN apk add --no-cache \
    bash \
    ruby \
    ruby-json \
    ruby-dev \
    curl \
    ca-certificates \
    openssl \
    gettext \
    apache2-utils \
    python \
    py-pip \
    py-setuptools \
    jq \
    && \
    pip --no-cache-dir install \
    awscli \
    && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    gem install terraform_landscape --no-document && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh && \
    chmod +x /tmp/get_helm.sh && \
    /tmp/get_helm.sh && \
    echo "helm istalled" && \
    curl -LO https://github.com/kubernetes/kops/releases/download/1.15.0/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 && \
    mv kops-linux-amd64 /usr/local/bin/kops && \
    rm -fr /tmp/*

# we want to be able to run non-terraform commands so we remove the entrypoint
ENTRYPOINT [""]

CMD ["bash"]
