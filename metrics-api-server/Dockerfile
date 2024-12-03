FROM registry.access.redhat.com/ubi9/python-311@sha256:3d9ce0a19b0edc6f7a60a933ea9e53a809282972fde30003ce686437affde070

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
