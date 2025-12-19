pipeline {
    agent {
        label 'linux'   // IMPORTANT: must be a Linux agent or Docker-based Jenkins
    }

    options {
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'a9acd7c0-1c8a-4253-96f4-641ff8efea02',
                    url: 'https://github.com/Cloud-Architect-Emma/Cloud-Architect-Emma-multi-cloud-devops-automation-platform.git'
            }
        }

        /* =========================
           AWS – Terraform
        ========================== */
        stage('AWS Terraform Init & Plan') {
            steps {
                withAWS(credentials: 'aws-terraform', region: 'us-east-1') {
                    dir('infrastructure-live/aws') {
                        sh '''
                          terraform init
                          terraform plan
                        '''
                    }
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Approve Terraform Apply for ALL CLOUDS?', ok: 'Apply'
            }
        }

        stage('AWS Terraform Apply') {
            steps {
                withAWS(credentials: 'aws-terraform', region: 'us-east-1') {
                    dir('infrastructure-live/aws') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }

        /* =========================
           Azure – Terraform
        ========================== */
        stage('Azure Terraform Init & Apply') {
            steps {
                withCredentials([
                    file(credentialsId: 'azure-credentials.json', variable: 'AZURE_AUTH')
                ]) {
                    dir('infrastructure-live/azure') {
                        sh '''
                          export ARM_CLIENT_ID=$(jq -r .clientId $AZURE_AUTH)
                          export ARM_CLIENT_SECRET=$(jq -r .clientSecret $AZURE_AUTH)
                          export ARM_SUBSCRIPTION_ID=$(jq -r .subscriptionId $AZURE_AUTH)
                          export ARM_TENANT_ID=$(jq -r .tenantId $AZURE_AUTH)

                          terraform init
                          terraform apply --auto-approve
                        '''
                    }
                }
            }
        }

        /* =========================
           GCP – Terraform
        ========================== */
        stage('GCP Terraform Init & Apply') {
            steps {
                withCredentials([
                    file(credentialsId: 'service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir('infrastructure-live/gcp') {
                        sh '''
                          terraform init
                          terraform apply --auto-approve
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Multi-cloud Terraform deployment completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
