# PostgreSQL on Kubernetes

    helm install db ./db --wait --debug
    kubectl get svc db-svc -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    psql -h <ip> -U admin --password -p 5432 db
    \dn
    helm uninstall db

## ToDo

* Kubernetes cluster configuration
  * Secrets
  * Service: choose nodePort or targetPort depending on minikube or not?!?!
* PostgreSQL schema
  * users: "deploy", "service"
  * credentials: passwords & certificates
  * application schema
* Test
  * pg connect
* Monitoring
