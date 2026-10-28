"""Kubernetes client configuration shared by main and watch worker processes."""

import os
import ssl

from kubernetes import client, config
from kubernetes.config.kube_config import KUBE_CONFIG_DEFAULT_LOCATION
from requests.packages.urllib3.util.retry import Retry

from helpers import (
    REQ_RETRY_BACKOFF_FACTOR,
    REQ_RETRY_CONNECT,
    REQ_RETRY_READ,
    REQ_RETRY_TOTAL,
)

SKIP_TLS_VERIFY = "SKIP_TLS_VERIFY"


def ensure_kubernetes_configuration(logger=None):
    """
    Load in-cluster (or kubeconfig file) settings into the default client config.
    Must run in every process that calls the Kubernetes API (including multiprocessing
    workers when the interpreter start method is "spawn").
    """
    kube_config = os.path.expanduser(KUBE_CONFIG_DEFAULT_LOCATION)
    try:
        if os.path.exists(kube_config):
            if logger:
                logger.info(f"Loading config from '{kube_config}'...")
            config.load_kube_config(kube_config)
        else:
            if logger:
                logger.info("Loading incluster config...")
            config.load_incluster_config()
    except ssl.SSLCertVerificationError as e:
        if logger:
            logger.error(
                f"SSL certificate verification failed when initializing Kubernetes client: {e}"
            )
            logger.error(
                "Check the service account CA or set SKIP_TLS_VERIFY=true (insecure)."
            )
        raise
    except Exception as e:
        if logger:
            logger.error(f"Unexpected error during Kubernetes client initialization: {e}")
        raise

    if os.getenv(SKIP_TLS_VERIFY) == "true":
        configuration = client.Configuration.get_default_copy()
        configuration.verify_ssl = False
        configuration.debug = False
        client.Configuration.set_default(configuration)

    configuration = client.Configuration.get_default_copy()
    configuration.retries = Retry(
        total=REQ_RETRY_TOTAL,
        connect=REQ_RETRY_CONNECT,
        read=REQ_RETRY_READ,
        backoff_factor=REQ_RETRY_BACKOFF_FACTOR,
    )
    client.Configuration.set_default(configuration)

    if logger:
        logger.info(f"Config for cluster api at '{configuration.host}' loaded.")
