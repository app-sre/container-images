FROM registry.access.redhat.com/ubi9/python-311@sha256:d89ff287e8248919657e8b6ca978f768054c48f087614bc765f51eafbe922fbc

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
