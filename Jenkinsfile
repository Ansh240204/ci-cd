pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        REGISTRY   = "anshraghu24"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Ansh240204/ci-cd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig-creds',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh "docker exec minikube mkdir -p /tmp/build"
                    sh "docker cp \${WORKSPACE}/. minikube:/tmp/build/"
                    sh "docker exec minikube ls /tmp/build"
                    sh "docker exec minikube docker build -t my-app:local /tmp/build"
                    sh "kubectl apply -f k8s-deployment.yaml"
                    sh "kubectl set image deployment/my-app my-app=my-app:local --namespace=default"
                    sh "kubectl rollout status deployment/my-app --namespace=default"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }

        failure {
            echo 'Pipeline failed — check logs above.'
        }
    }
}