pipeline {
    agent any

    triggers {
        githubPush()
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        DOCKER_IMAGE = "emma2323/multi-cloud-app"
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
                        withAWS(credentials: 'aws-terraform', region: 'us-east-1') {
                            dir('infrastructure-live/aws') {
                                sh '''
                                  terraform init
                                  terraform validate
                                  terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }

                stage('Azure Terraform') {
                    steps {
                        withCredentials([
                            file(credentialsId: 'azure-credentials.json', variable: 'AZURE_AUTH_LOCATION')
                        ]) {
                            dir('infrastructure-live/azure') {
                                sh '''
                                  terraform init
                                  terraform validate
                                  terraform plan -out=tfplan
                                '''
                            }
                        }
                    }
                }

                stage('GCP Terraform') {
                    steps {
                        withCredentials([
                            file(credentialsId: 'service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                        ]) {
                            dir('infrastructure-live/gcp') {
                                sh '''
                                  terraform init
                                  terraform validate
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
                        withAWS(credentials: 'aws-terraform', region: 'us-east-1') {
                            dir('infrastructure-live/aws') {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }

                stage('Azure Apply') {
                    steps {
                        withCredentials([
                            file(credentialsId: 'azure-credentials.json', variable: 'AZURE_AUTH_LOCATION')
                        ]) {
                            dir('infrastructure-live/azure') {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }

                stage('GCP Apply') {
                    steps {
                        withCredentials([
                            file(credentialsId: 'service-account', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                        ]) {
                            dir('infrastructure-live/gcp') {
                                sh 'terraform apply -auto-approve tfplan'
                            }
                        }
                    }
                }
            }
        }

        stage('Build & Trivy Scan') {
            steps {
                sh '''
                  docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                  trivy image --exit-code 1 --severity HIGH,CRITICAL $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS')
                ]) {
                    sh '''
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                      docker push $DOCKER_IMAGE:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'sonarQube-token',
                    usernameVariable: 'SONAR_USER',
                    passwordVariable: 'SONAR_PASS')
                ]) {
                    sh '''
                      sonar-scanner \
                      -Dsonar.login=$SONAR_PASS
                    '''
                }
            }
        }

        stage('Deploy via ArgoCD') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'AgroCD',
                    usernameVariable: 'ARGO_USER',
                    passwordVariable: 'ARGO_PASS')
                ]) {
                    sh '''
                      argocd login argocd.example.com \
                        --username $ARGO_USER \
                        --password $ARGO_PASS \
                        --insecure

                      argocd app sync multi-cloud-app
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed — investigate stage logs"
        }
    }
}
