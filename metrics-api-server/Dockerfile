FROM registry.access.redhat.com/ubi9/python-311@sha256:617152a2d5600081b00f3d4bb0e430b681d932e53e3053fa6a4c54861d3fec83

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
