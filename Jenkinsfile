pipeline {
    agent any

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        skipDefaultCheckout(true)
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ARGOCD_SERVER = 'https://argocd.example.com'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Plan') {
            parallel {

                stage('AWS Terraform') {
                    steps {
                        withAWS(credentials: 'aws-terraform', region: env.AWS_DEFAULT_REGION) {
                            dir('infrastructure-live/aws') {
                                sh '''
                                  terraform init
                                  terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }

                stage('Azure Terraform') {
                    steps {
                        withCredentials([
                            string(credentialsId: 'azure-client-id', variable: 'AZURE_CLIENT_ID'),
                            string(credentialsId: 'azure-client-secret', variable: 'AZURE_CLIENT_SECRET'),
                            string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID'),
                            string(credentialsId: 'azure-subscription-id', variable: 'AZURE_SUBSCRIPTION_ID')
                        ]) {
                            dir('infrastructure-live/azure') {
                                sh '''
                                  az login --service-principal \
                                    -u $AZURE_CLIENT_ID \
                                    -p $AZURE_CLIENT_SECRET \
                                    --tenant $AZURE_TENANT_ID

                                  az account set --subscription $AZURE_SUBSCRIPTION_ID

                                  terraform init
                                  terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }

                stage('GCP Terraform') {
                    steps {
                        withCredentials([
                            file(credentialsId: 'gcp-terraform', variable: 'GCP_KEYFILE')
                        ]) {
                            dir('infrastructure-live/gcp') {
                                sh '''
                                  gcloud auth activate-service-account --key-file=$GCP_KEYFILE
                                  terraform init
                                  terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            parallel {

                stage('AWS Apply') {
                    steps {
                        withAWS(credentials: 'aws-terraform', region: env.AWS_DEFAULT_REGION) {
                            dir('infrastructure-live/aws') {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }

                stage('Azure Apply') {
                    steps {
                        dir('infrastructure-live/azure') {
                            sh 'terraform apply -auto-approve tfplan'
                        }
                    }
                }

                stage('GCP Apply') {
                    steps {
                        dir('infrastructure-live/gcp') {
                            sh 'terraform apply -auto-approve tfplan'
                        }
                    }
                }
            }
        }

        stage('Build, Scan & Push Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        def image = docker.build("multi-cloud-app:${env.BUILD_NUMBER}")

                        sh """
                          trivy image \
                            --severity CRITICAL,HIGH \
                            --exit-code 1 \
                            ${image.imageName()}
                        """

                        image.push()
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    withCredentials([
                        string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')
                    ]) {
                        sh 'sonar-scanner -Dsonar.login=$SONAR_TOKEN'
                    }
                }
            }
        }

        stage('Deploy via ArgoCD') {
            steps {
                withCredentials([
                    string(credentialsId: 'argocd-token', variable: 'ARGOCD_TOKEN')
                ]) {
                    sh '''
                      argocd login $ARGOCD_SERVER \
                        --token $ARGOCD_TOKEN \
                        --insecure

                      for cluster in aws azure gcp; do
                        argocd app sync app-$cluster --prune --retry
                      done
                    '''
                }
            }
        }
    }

    post {
        failure {
            withCredentials([
                string(credentialsId: 'argocd-token', variable: 'ARGOCD_TOKEN')
            ]) {
                sh '''
                  argocd login $ARGOCD_SERVER --token $ARGOCD_TOKEN --insecure

                  for cluster in aws azure gcp; do
                    argocd app rollback app-$cluster 1
                  done
                '''
            }
        }
    }
}
