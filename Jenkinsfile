pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ARGOCD_SERVER = 'https://argocd.example.com'
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
                        withCredentials([file(credentialsId: 'azure-credentials.json', variable: 'AZURE_CREDS')]) {
                            dir('infrastructure-live/azure') {
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

        stage('Terraform Apply') { ... } // same mapping as above

        stage('Build, Scan & Push Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        def image = docker.build("multi-cloud-app:${env.BUILD_NUMBER}")
                        sh "trivy image --severity CRITICAL,HIGH --exit-code 1 ${image.imageName()}"
                        image.push()
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'sonarQube-token', usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
                    sh 'sonar-scanner -Dsonar.login=$SONAR_PASS'
                }
            }
        }

        stage('Deploy via ArgoCD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'AgroCD', usernameVariable: 'ARGO_USER', passwordVariable: 'ARGO_PASS')]) {
                    sh '''
                      argocd login $ARGOCD_SERVER --username $ARGO_USER --password $ARGO_PASS --insecure
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
            withCredentials([usernamePassword(credentialsId: 'AgroCD', usernameVariable: 'ARGO_USER', passwordVariable: 'ARGO_PASS')]) {
                sh '''
                  argocd login $ARGOCD_SERVER --username $ARGO_USER --password $ARGO_PASS --insecure
                  for cluster in aws azure gcp; do
                    argocd app rollback app-$cluster 1
                  done
                '''
            }
        }
    }
}
