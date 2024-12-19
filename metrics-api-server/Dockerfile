FROM registry.access.redhat.com/ubi9/python-311@sha256:c110feaf0d11c700fb8a555e2e8094dbe334164af66baf0849d1ce091778589e

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
