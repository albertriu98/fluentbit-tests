FROM jenkins/inbound-agent:3327.v868139a_d00e0-2

USER root


# Install dependencies
RUN apt-get update && apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set kubectl version
ENV KUBECTL_VERSION=v1.30.1

# Download and install static kubectl binary
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        sshpass \
        git \
        curl \
        sudo && \
    pip3 install --no-cache-dir ansible && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y curl sudo gnupg && \
    curl -fsSL -o /tmp/helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf /tmp/helm.tar.gz -C /tmp && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf /tmp/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Optional: confirm it works
RUN kubectl version --client

# Set working directory back
WORKDIR /home/jenkins/agent

# Use jenkins user again
USER jenkins