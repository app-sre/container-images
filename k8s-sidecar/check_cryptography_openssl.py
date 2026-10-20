"""Fail if `cryptography` is not linked against the system (FIPS) OpenSSL.

On Linux, a plain `pip install cryptography` pulls a manylinux wheel with its
own *statically linked* OpenSSL baked in (see
https://cryptography.io/en/latest/installation/#static-wheels). That vendored
OpenSSL bypasses Hummingbird's FIPS-validated OpenSSL provider even though no
code in this image calls `cryptography` directly -- it is a transitive
dependency (kubernetes -> google-auth -> cryptography), and
Hummingbird's FIPS policy excludes any unvalidated crypto library regardless
of whether it is actually exercised at runtime:
https://hummingbird-project.io/docs/contributing/fips-variant-guide/

The Dockerfile installs build tooling and uses `pip install --no-binary
cryptography` so `cryptography` is compiled against the image's own
`openssl-devel` instead. This script checks that the OpenSSL version
`cryptography` reports matches the OpenSSL version Python's own `ssl` module
reports, which is the version actually shipped and FIPS-validated by
Hummingbird.
"""
import re

import ssl

from cryptography.hazmat.backends.openssl.backend import backend


def _version(text: str) -> str:
    match = re.search(r"\d+\.\d+\.\d+", text)
    if not match:
        raise SystemExit(f"could not parse an OpenSSL version from: {text!r}")
    return match.group()


def main() -> None:
    python_ssl_text = ssl.OPENSSL_VERSION
    cryptography_text = backend.openssl_version_text()
    print(f"python ssl module : {python_ssl_text}")
    print(f"cryptography      : {cryptography_text}")

    python_version = _version(python_ssl_text)
    crypto_version = _version(cryptography_text)
    if python_version != crypto_version:
        raise SystemExit(
            "cryptography is not linked against the system OpenSSL "
            f"(python ssl={python_version}, cryptography={crypto_version}). "
            "This usually means a prebuilt wheel with a vendored OpenSSL was "
            "installed instead of a --no-binary source build; the FIPS "
            "guarantee of this image is not preserved."
        )
    print("OK: cryptography is linked against the system (FIPS) OpenSSL")


if __name__ == "__main__":
    main()
