FROM registry.access.redhat.com/ubi9/python-311@sha256:a0bdb55576fc5b8d6704279307817828ef027e1065533ceba133fe9516003a6c

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
