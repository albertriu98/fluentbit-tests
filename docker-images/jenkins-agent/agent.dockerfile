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
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    sshpass \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN python3 -m pip install --break-system-packages ansible

#install ansible

#install helm
# Install helm
RUN curl -LO https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.7.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf helm-v3.7.0-linux-amd64.tar.gz linux-amd64



# Set working directory back
WORKDIR /home/jenkins/agent

# Use jenkins user again
USER jenkins