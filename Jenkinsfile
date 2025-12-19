pipeline {
    agent any
    environment {
        // Global environment variables if needed
        DOCKER_IMAGE = "emma/multi-cloud-app"
        DOCKER_TAG = "latest"
        ARGOCD_SERVER = "https://argocd.example.com"
        SONARQUBE_SERVER = "http://sonarqube.example.com"
    }
    stages {

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Cloud-Architect-Emma/Cloud-Architect-Emma-multi-cloud-devops-automation-platform.git',
                        credentialsId: 'a9acd7c0-1c8a-4253-96f4-641ff8efea02'
                    ]]
                ])
            }
        }

        stage('Terraform Init & Plan') {
            parallel {

                stage('AWS Terraform') {
                    steps {
                        withCredentials([
                            string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            dir('terraform/aws') {
                                sh 'terraform init'
                                sh 'terraform plan -out=tfplan'
                            }
                        }
                    }
                }

                stage('Azure Terraform') {
                    steps {
                        withCredentials([file(credentialsId: 'azure-credentials.json', variable: 'AZURE_CREDS')]) {
                            dir('terraform/azure') {
                                sh '''
                                    az login --service-principal --username $(jq -r .clientId < $AZURE_CREDS) \
                                      --password $(jq -r .clientSecret < $AZURE_CREDS) \
                                      --tenant $(jq -r .tenantId < $AZURE_CREDS)
                                    az account set --subscription $(jq -r .subscriptionId < $AZURE_CREDS)
                                    terraform init
                                    terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }

                stage('GCP Terraform') {
                    steps {
                        withCredentials([file(credentialsId: 'service-account', variable: 'GCP_KEYFILE')]) {
                            dir('terraform/gcp') {
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
                        withCredentials([
                            string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            dir('terraform/aws') {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }

                stage('Azure Apply') {
                    steps {
                        withCredentials([file(credentialsId: 'azure-credentials.json', variable: 'AZURE_CREDS')]) {
                            dir('terraform/azure') {
                                sh '''
                                    az login --service-principal --username $(jq -r .clientId < $AZURE_CREDS) \
                                      --password $(jq -r .clientSecret < $AZURE_CREDS) \
                                      --tenant $(jq -r .tenantId < $AZURE_CREDS)
                                    az account set --subscription $(jq -r .subscriptionId < $AZURE_CREDS)
                                    terraform apply -auto-approve tfplan
                                '''
                            }
                        }
                    }
                }

                stage('GCP Apply') {
                    steps {
                        withCredentials([file(credentialsId: 'service-account', variable: 'GCP_KEYFILE')]) {
                            dir('terraform/gcp') {
                                sh '''
                                    gcloud auth activate-service-account --key-file=$GCP_KEYFILE
                                    terraform apply -auto-approve tfplan
                                '''
                            }
                        }
                    }
                }

            }
        }

        stage('Build, Scan & Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                        trivy image --exit-code 1 $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'sonarQube-token', usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=multi-cloud-app \
                        -Dsonar.host.url=$SONARQUBE_SERVER \
                        -Dsonar.login=$SONAR_PASS
                    '''
                }
            }
        }

        stage('Deploy via ArgoCD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'AgroCD', usernameVariable: 'ARGO_USER', passwordVariable: 'ARGO_PASS')]) {
                    sh '''
                        argocd login $ARGOCD_SERVER --username $ARGO_USER --password $ARGO_PASS --insecure
                        argocd app sync multi-cloud-app
                    '''
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}
