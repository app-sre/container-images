FROM registry.access.redhat.com/ubi9/python-311@sha256:ee1128adb98b79e58cd31c32da4cfd6641c4665d15112639f19428e7c3c0ef4c

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
