stage('Deploy to Kubernetes') {
    steps {
        withCredentials([
            file(
                credentialsId: 'kubeconfig-creds',
                variable: 'KUBECONFIG'
            )
        ]) {
            sh "tar -czf /tmp/app.tar.gz -C ${WORKSPACE} ."

            sh "docker cp /tmp/app.tar.gz minikube:/tmp/app.tar.gz"

            // Debug - verify file exists in minikube
            sh "docker exec minikube ls -lh /tmp/app.tar.gz"

            sh "docker exec minikube rm -rf /tmp/build"
            sh "docker exec minikube mkdir -p /tmp/build"
            sh "docker exec minikube tar -xzf /tmp/app.tar.gz -C /tmp/build"

            sh "docker exec minikube docker build -t my-app:local /tmp/build"

            sh "kubectl apply -f ${WORKSPACE}/k8s-deployment.yaml"
            sh "kubectl set image deployment/my-app my-app=my-app:local --namespace=default"
            sh "kubectl rollout status deployment/my-app --namespace=default"
        }
    }
}