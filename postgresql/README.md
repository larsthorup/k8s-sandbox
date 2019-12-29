# PostgreSQL on Kubernetes

Here we define a Helm Chart to ensure a running PostgreSQL service with a single blank database instance into the current Kubernetes context.

The settings (non-secret) for the PostgreSQL service are in [values.yaml](./helm/db/values.yaml). The encrypted secret settings (credentials) are in [secrets.yaml.enc](./helm/db/secrets.yaml.enc)

For demo purposes the passphrase for decrypting the secrets is stated below. For production purposes, always keep secrets secret.


    # prepare environment
    export PASSPHRASE=MasterKey1
    cd helm

    # install postgresql
    openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -k $PASSPHRASE | helm install -f - -f ./db/values.yaml db ./db --wait --debug

    # test service
    helm test db --timeout 20s
    kubectl logs `kubectl get pod -l=job-name=db-smoke-test -o=jsonpath='{.items[0].metadata.name}'`

    # verify postgresql service
    POSTGRES_HOST=`kubectl get svc db-svc -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'`
    psql -h $POSTGRES_HOST -U admin --password -p 5432 db
    admin
    \dn
    \q

    # uninstall postgresql
    helm uninstall db

## Maintaining secrets

    # decrypt secrets for editing
    openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -out ./db/secrets.yaml -k $PASSPHRASE

    # encrypt secrets for commit
    openssl enc -pbkdf2 -salt -a -in ./db/secrets.yaml -out ./db/secrets.yaml.enc -k $PASSPHRASE

## ToDo

* Kubernetes cluster maintenance
  * Secret rotation
  * Upgrade (postgres image version, disk size)
* Persistance
  * Keep volume in production?
