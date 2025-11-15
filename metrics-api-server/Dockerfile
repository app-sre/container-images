FROM registry.access.redhat.com/ubi9/python-311@sha256:0e33cb88535e0fa38142daf896ad4df26dce2779b816144a09a3db818461f960

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
