FROM registry.access.redhat.com/ubi9/python-311@sha256:1f731d98ef65bf4c68875cc8908d750eed27ceac1fb5fc2fb969f7f2a0baee6d

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
