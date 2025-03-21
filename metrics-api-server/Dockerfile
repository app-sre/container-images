FROM registry.access.redhat.com/ubi9/python-311@sha256:753524c12d1feb344133d6074994498fbbfea8078cef75eb9b90c37fd5db5f3a

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
