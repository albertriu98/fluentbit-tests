pipeline{
    agent {
        kubernetes {
            label 'jenkins-agent-kubectl'
        }
    }
    parameters {
        string(name: 'image', description: 'Image to create pod')
        string(name: 'name', description: 'Name of the application')
    }
    environment {
        GIT_SSH_COMMAND = 'ssh -o StrictHostKeyChecking=no'
        ANSIBLE_VAULT_PASS = credentials('ansible-vault-passwd') 
    }

    stages {
        stage ('Deploy app'){
            steps {
                script {
                    sh('kubectl create namespace ${name}')
                    sh('kubectl create deployment ${name} --image=${image} -n ${name}')
                }
            }
        }
        stage ('Checkout code') {
            steps {
                sshagent(['github-sshkey']) {
                    sh 'git clone git@github.com:albertriu98/fluentbit-tests.git'
                }
            }
        }
        stage ('Create output in fluentbit configuration file') {
            steps {
                sshagent(['github-sshkey']) {
                    sh """
                        cd fluentbit-tests/ansible 
                        echo "$ANSIBLE_VAULT_PASS" > vault_pass.txt
                        ansible-playbook playbook.yaml --extra-vars namespace=${name} --vault-password-file  vault_pass.txt")
                        rm vault_pass.txt
                        cd ../
                        git config user.name "Jenkins Bot"
                        git config user.email "jenkins@yourdomain.com"
                        git commit -am "Update fluentbit config , automated by Jenkins"
                        git push
                        helm repo add fluent https://fluent.github.io/helm-charts 
                        helm repo update
                        helm upgrade fluentbit -n fluentbit fluent/fluent-bit --create-namespace --install --values fluentbit-config.conf 
                    """
                }
                
            }
        }
    }
}