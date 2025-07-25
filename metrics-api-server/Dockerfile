FROM registry.access.redhat.com/ubi9/python-311@sha256:4f90eac25924eb00f9459015ecc41c19a29c4a49b2b92328e877bcac5f21e794

WORKDIR /app

# Copy the Flask app to the container
COPY app /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir flask gunicorn

# Expose the port Gunicorn will listen on
EXPOSE 5000

# run the app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
