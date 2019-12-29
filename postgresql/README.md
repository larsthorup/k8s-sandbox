# PostgreSQL on Kubernetes

Here we define Helm charts to ensure a running PostgreSQL service with a single blank database instance stored on a blank volume into the current Kubernetes context.

The settings for the volume is in [dbstore/values.yaml](./helm/dbstore/values.yaml).

The settings (non-secret) for the PostgreSQL service are in [db/values.yaml](./helm/db/values.yaml). The encrypted secret settings (credentials) are in [db/secrets.yaml.enc](./helm/db/secrets.yaml.enc)

For demo purposes the passphrase for decrypting the secrets is stated below. For production purposes, always keep secrets secret.


## Create and destroy volume

    cd helm

    # install volume
    helm install -f ./dbstore/values.yaml dbstore ./dbstore --wait --debug

    # uninstall volume
    helm uninstall dbstore


## Start and stop PostgreSQL service

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


## ToDo: Rotate admin password

* Upgrade service to use new admin password


## ToDo: Upgrade postgres image version

* Upgrade service to use new image version


## ToDo: Upgrade volume size

* Create new volume
* Stop service
* Copy data from old volume
* Upgrade service to use new volume
* Delete old volume


## ToDo: Rotate user password

* Migrate user password
