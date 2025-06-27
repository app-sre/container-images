FROM registry.access.redhat.com/ubi9/python-311@sha256:47f3998eaf36beb97789d1fe52db4811e02338cc55266638ebb992df48adea86

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
