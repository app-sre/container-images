# MSK debug container

This container is intended to be used as a temporary debugging tool for MSK clusters. Please deploy it into the same cluster and namespace as the MSK cluster external resource.

## Features

The template requires the following parameters:

- `MSK_VERSION`: The version of the MSK cluster to debug. See [Available Kafka Versions](#available-kafka-versions) for a list of available versions.
- `MSK_SECRET_NAME`: The name of the secret containing the MSK connection information.
- `MSK_CREDENTIALS_SECRET_NAME`: The name of the secret containing the MSK SCRAM credentials.

The container supports the following environment variables:

- `MSK_CONFIG`: Path to the Kafka client configuration file. Default: `/client.properties`.
- `MSK_BOOTSTRAP_SERVERS`: The Kafka bootstrap servers.
- `MSK_ZOOKEEPER_CONNECT`: The Zookeeper connection string.
- `MSK_USER`: The Kafka user.
- `MSK_PASSWORD`: The Kafka password.

## Usage

Use the following commands to deploy the container:

```bash
# Login to the cluster and select the namespace
oc login ...
oc project <namespace>
# Deploy the container
oc process --local \
  -p MSK_VERSION=<MSK_VERSION> \
  -p MSK_SECRET_NAME=<MSK_SECRET_NAME> \
  -p MSK_CREDENTIALS_SECRET_NAME=<MSK_CREDENTIALS_SECRET_NAME> \
  -f https://raw.githubusercontent.com/app-sre/container-images/master/msk-debug-container/openshift.yml | oc apply -f -
# Connect to the pod
oc rsh deployment/msk-debug-container
```

The container provides all Kafka tools, such as `kafka-console-consumer`, `kafka-console-producer`, and `kafka-topics`. For example:

```bash
kafka-topics.sh --bootstrap-server $MSK_BOOTSTRAP_SERVERS --command-config $MSK_CONFIG --list
```

> **Note**
>
> Please remove the `msk-debug-container` deployment after debugging is complete.

## Available Kafka Versions

See [msk-debug-container repository](https://quay.io/repository/redhat-user-workloads/app-sre-tenant/container-images-master/msk-debug-container-master?tab=tags) for all available tags.
