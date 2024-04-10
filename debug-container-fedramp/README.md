# FedRamp Debug Container 

- Use 'alternatives --config psql' to select version of psql client

- See perf-tools folder for Brendan Gregg performance testing suite

- Do NOT install openssl (breaks FIPS compatibility)

## Usage

Apply one of the provided OpenShift templates to your namespace.

* `openshift.yml` - for a pod without a PVC attached
* `openshift-with-pvc.yml` - for a pod with a PVC attached

Both templates support several parameters; please see the templates for details.

## Postgres Example

```bash
$ oc process --local -p POSTGRES_DB_SECRET_NAME=SECRET_NAME -f https://raw.githubusercontent.com/app-sre/container-images/debug-container-fedramp/master/openshift.yml  | oc apply -f -
$ oc rsh <pod>
$ psql -h <FQDN-of-db> -U postgres -d postgres -W
pqsl>
```

## Redis Example

```bash
$ oc process --local -p REDIS_SECRET_NAME=SECRET_NAME -f https://raw.githubusercontent.com/app-sre/container-images/debug-container-fedramp/master/openshift.yml  | oc apply -f -
$ oc rsh <pod>
$ redis-cli -h $REDISCLI_HOST -p $REDISCLI_PORT --tls
redis>
```
