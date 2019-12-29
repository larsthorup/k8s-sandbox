helm uninstall db
helm uninstall dbstore

echo Waiting for volumes to disappear...
sleep 15
echo ---

helm install -f ./dbstore/values.yaml dbstore ./dbstore --wait
openssl enc -pbkdf2 -salt -d -a -in ./db/secrets.yaml.enc -k $PASSPHRASE | helm install -f - -f ./db/values.yaml db ./db --wait
echo ---

helm test db --timeout 20s
echo ---

kubectl logs `kubectl get pod -l=job-name=db-smoke-test -o=jsonpath='{.items[0].metadata.name}'`