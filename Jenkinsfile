pipeline {
    agent any
    tools {
        terraform 'terra'
        ansible 'ansible'
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/abaseer23/challenge-6.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY' 
                ]]) {
                    dir('terraform') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('ansible') {
                    sh 'chmod +x generate_inventory.sh'
                    sh './generate_inventory.sh'
                }
            }
        }

        stage('Configure VMs') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'UBUNTU_KEY')]) {
                    withCredentials([sshUserPrivateKey(credentialsId: 'linux', keyFileVariable: 'linux_KEY')]) {
                        dir('ansible') {
                            sh '''
                                chmod 600 $UBUNTU_KEY $linux_KEY
                                export ANSIBLE_HOST_KEY_CHECKING=False

                                ansible-playbook -i inventory.ini playbook_backend.yml --private-key=$UBUNTU_KEY -u ubuntu
                                ansible-playbook -i inventory.ini playbook_frontend.yml --private-key=$AMAZON_KEY -u ec2-user
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment and configuration complete!'
        }
        failure {
            echo '❌ Something went wrong.'
        }
    }
}
