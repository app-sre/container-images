FROM registry.access.redhat.com/ubi9/python-311@sha256:b7cb719d2c9d0ab4c416f9a7f40161b5b284eccfcf9a8787ab2339cbdf0c5d17

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
