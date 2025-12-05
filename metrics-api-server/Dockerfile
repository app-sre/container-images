FROM registry.access.redhat.com/ubi9/python-311@sha256:e80bccbb5033c7026912300d97ee967e240e31f01625511c345fb2fa8cd2f971

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
