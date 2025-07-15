FROM registry.access.redhat.com/ubi9/python-311@sha256:10dd6f77f419d06adf88fe0baa881e0c495ccda3ea7a3b6fadd65442e1ac4b6e

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
