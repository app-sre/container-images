FROM registry.access.redhat.com/ubi9/python-311@sha256:5d5a2a4f907778812b450278c1ce49d02da61e9aeb3ec4481e2dafc69ae4bcc7

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
