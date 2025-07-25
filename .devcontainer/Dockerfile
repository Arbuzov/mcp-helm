FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG HELM_VERSION=v3.13.1
RUN curl -sL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz \
    && tar -xzf helm.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf helm.tar.gz linux-amd64

RUN apt-get update && apt-get install -y --no-install-recommends \
    yamllint \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js for markdownlint
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g markdownlint-cli \
    && rm -rf /var/lib/apt/lists/*

ARG KUBEVAL_VERSION=v0.16.1
RUN curl -sL https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz -o kubeval.tar.gz \
    && tar -xzf kubeval.tar.gz \
    && install -o root -g root -m 0755 kubeval /usr/local/bin/kubeval \
    && rm -f kubeval kubeval.tar.gz

ARG YQ_VERSION=4.43.1
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

CMD ["bash"]
