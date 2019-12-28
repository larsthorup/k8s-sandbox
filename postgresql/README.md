# PostgreSQL on Kubernetes

    # prepare environment
    export PASSPHRASE=MasterKey1
    cd helm

    # install postgresql
    openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -k $PASSPHRASE | helm install -f - -f ./db/values.yaml db ./db --wait --debug
    POSTGRES_HOST=`kubectl get svc db-svc -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'`

    # verify postgresql service
    psql -h $POSTGRES_HOST -U admin --password -p 5432 db
    admin
    \dn
    \q

    # uninstall postgresql
    helm uninstall db

## Maintenance of secrets

    # decrypt secrets for editing
    openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -out ./db/secrets.yaml -k $PASSPHRASE

    # encrypt secrets for commit
    openssl enc -pbkdf2 -salt -a -in ./db/secrets.yaml -out ./db/secrets.yaml.enc -k $PASSPHRASE

## ToDo

* Kubernetes cluster maintenance
  * Secret rotation
  * Upgrade (postgres image version, disk size)
* PostgreSQL schema
  * users: "deploy", "service"
  * credentials: passwords & certificates
  * application schema
* Test
  * pg connect
* Monitoring
