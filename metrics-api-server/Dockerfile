FROM registry.access.redhat.com/ubi9/python-311@sha256:3d7217ff801658e72048ace18433f434971f64433f33e8c0f7f1e73525841ae7

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
