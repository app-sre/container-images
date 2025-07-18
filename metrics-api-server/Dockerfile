FROM registry.access.redhat.com/ubi9/python-311@sha256:232487f27faed8417ea2fe3f6cdc4a5b8054894e44b2033e3a1548f1e1a1a08a

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
