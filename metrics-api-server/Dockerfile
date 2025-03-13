FROM registry.access.redhat.com/ubi9/python-311@sha256:deebed046bcdbb6023ee9d57b93de2ba4b4bb9b8c222f76a259c649cf6a6f6f4

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
