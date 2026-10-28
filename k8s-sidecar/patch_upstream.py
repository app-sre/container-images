#!/usr/bin/env python3
"""Apply small upstream patches after copying k8s-sidecar src into /app."""

from pathlib import Path

APP = Path("/app")


def patch_sidecar() -> None:
    path = APP / "sidecar.py"
    text = path.read_text()
    old = '''def _initialize_kubeclient_configuration():
    """
    Updates the default configuration of the kubernetes client. This is
    picked up later on automatically then.
    """

    # this is where kube_config is going to look for a config file
    kube_config = os.path.expanduser(KUBE_CONFIG_DEFAULT_LOCATION)
    try:
        if os.path.exists(kube_config):
            logger.info(f"Loading config from '{kube_config}'...")
            config.load_kube_config(kube_config)
        else:
            logger.info("Loading incluster config...")
            config.load_incluster_config()
    except ssl.SSLCertVerificationError as e:
        logger.error(f"SSL certificate verification failed when initializing Kubernetes client: {e}")
        logger.error("Check if the CA certificate at /var/run/secrets/kubernetes.io/serviceaccount/ca.crt is correct or set SKIP_TLS_VERIFY=true (insecure).")
        raise
    except Exception as e:
        logger.error(f"Unexpected error during Kubernetes client initialization: {e}")
        raise

    if os.getenv(SKIP_TLS_VERIFY) == "true":
        configuration = client.Configuration.get_default_copy()
        configuration.verify_ssl = False
        configuration.debug = False
        client.Configuration.set_default(configuration)

    # push urllib3 retries to k8s client config
    configuration = client.Configuration.get_default_copy()
    configuration.retries = Retry(total=REQ_RETRY_TOTAL,
                                  connect=REQ_RETRY_CONNECT,
                                  read=REQ_RETRY_READ,
                                  backoff_factor=REQ_RETRY_BACKOFF_FACTOR)
    client.Configuration.set_default(configuration)

    logger.info(f"Config for cluster api at '{configuration.host}' loaded.")'''
    new = '''def _initialize_kubeclient_configuration():
    from kube_client_config import ensure_kubernetes_configuration

    ensure_kubernetes_configuration(logger)'''
    if old not in text:
        raise SystemExit(f"sidecar.py patch block not found in {path}")
    path.write_text(text.replace(old, new, 1))


def patch_resources() -> None:
    path = APP / "resources.py"
    text = path.read_text()
    needle = (
        "def _watch_resource_loop(mode, label, label_value, target_folder, request_url, request_method, request_payload,\n"
        "                         namespace, folder_annotation, resource, unique_filenames, script, enable_5xx,\n"
        "                         ignore_already_processed, resource_name):\n"
    )
    insert = (
        needle
        + "    from kube_client_config import ensure_kubernetes_configuration\n"
        + "\n"
        + "    ensure_kubernetes_configuration(logger)\n"
    )
    if needle not in text:
        raise SystemExit(f"resources.py patch anchor not found in {path}")
    path.write_text(text.replace(needle, insert, 1))


def patch_main() -> None:
    path = APP / "sidecar.py"
    text = path.read_text()
    old = 'if __name__ == "__main__":\n    main()'
    new = '''if __name__ == "__main__":
    import multiprocessing

    try:
        multiprocessing.set_start_method("fork")
    except RuntimeError:
        pass
    main()'''
    if old not in text:
        raise SystemExit(f"sidecar.py __main__ patch not found in {path}")
    path.write_text(text.replace(old, new, 1))


def main() -> None:
    patch_sidecar()
    patch_resources()
    patch_main()


if __name__ == "__main__":
    main()
