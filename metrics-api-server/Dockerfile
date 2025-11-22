FROM registry.access.redhat.com/ubi9/python-311@sha256:0607e1889bd6ad297c011781a8f93588ff889ac6fc0b4a1eae34063fab681087

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
