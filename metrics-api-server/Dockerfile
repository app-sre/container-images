FROM registry.access.redhat.com/ubi9/python-311@sha256:1803ef85fc1cf9969cec37554c83b5fb9ef2e38b3592c91489a271005d3df4e2

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
