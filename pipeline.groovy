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
    stages {
        stage ('Deploy app'){
            steps {
                script {
                    sh('kubectl create namespace ${name}')
                    sh('kubectl create deployment ${name} --image=${image} -n ${name}')
                }
            }
        }
        stage ('Create output in fluentbit configuration file') {
            steps {
                sh ('git pull ')
                sh ('ansible-playbook')
                sh ('git commit -am  && git push')
                sh ('helm upgrade fluentbit -n fluentbit fluent/fluentbit --create-namespace --install --values fluentbit-config.conf')
                
            }
        }
    }
}