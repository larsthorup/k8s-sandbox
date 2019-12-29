helm uninstall db

echo Waiting for volumes to disappear
sleep 15

openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -k $PASSPHRASE | helm install -f - -f ./db/values.yaml db ./db --wait --debug

helm test db --timeout 20s

kubectl logs `kubectl get pod -l=job-name=db-smoke-test -o=jsonpath='{.items[0].metadata.name}'`