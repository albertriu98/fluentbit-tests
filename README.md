What I want to do in this small project is to automate a simple deployment of a pod, defining the image and name off the app through parametersof the piepline, and then update the config of fluentbit deployed in the Kubernetes cluster to send logs from the app to a new index in elasticsearch.

Prerequisites:
- Deploy a kubernetes cluster (minikube is OK)
- Deploy elasticsearch, kibana and fluentd using official Helm Chart.
- Deploy Jenkins instance with official Helm Chart.


Challenges found:
- We want to send logs from each new application deployed in the cluster to a specific index in elasticsearch. So we need to build a pipeline in Jenkins which will first deploy the app (simple pod) and then using ansible modify the configuration file of fluentbit.
- To run the pipeline we need to build a Docker image which will inlcude as per requisites: kubectl, ansible, git and helm binaries.
- We configure the Jenkins agent correctly, using jnlp base image for correct connection between master and slave.
- Finally we develop the pipeline with groovy:
    1. Pipeline has 2 perameters: image and name.
    2. Pipeline uses kubectl to deploy a pod with the image defined in "image" parameter
    3. Pipeline uses git to clone repository and from here using ansible playbook located in ansible/ modifies the file fluentbit-config.conf by appending template block ansible/templates/output_block.conf.j2
    4. Once the file is modified and pushed back to origin, pipeline uses helm to upgrade the Chart of fluent-bit , adding the new configuration.
    5. When the deployed app starts generatic logs, those are collected and sent to a new elasticsearch index. So from there using kibana we can explore the logs and create useful dashboards.

Note: Files in /manifests/roles are related to giving permissions to Jenkins Agent service account to create any object in the cluster.

Charts: 
- FLuentbit: https://fluent.github.io/helm-charts/fluent-bit
- Elastic/Kibana:  https://helm.elastic.co/eck-stack
- Jenkins: https://charts.jenkins.io/jenkins


