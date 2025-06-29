# Dockerfile

# Use an official Python runtime as a parent image.
# python:3.9-slim-buster provides a lightweight Debian-based image with Python 3.9 installed.
FROM python:3.9-slim-buster

# Set the working directory in the container.
# All subsequent commands will be executed relative to this directory inside the container.
WORKDIR /app

# Copy the requirements.txt file into the container at /app.
# This is done before copying the rest of the code to leverage Docker's build cache.
# If requirements.txt doesn't change, this layer won't be rebuilt.
COPY requirements.txt .

# Install any needed Python packages specified in requirements.txt.
# --no-cache-dir ensures pip doesn't store cached packages, reducing image size.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the current directory's contents (including app.py) into the container at /app.
COPY . .

# Make port 5000 available to the world outside this container.
# This simply documents the port; it doesn't actually publish it.
# The Kubernetes Service handles actual port exposure.
EXPOSE 5000

# Run the Flask app when the container launches.
# We use gunicorn, a production-ready WSGI HTTP server, instead of Flask's built-in development server.
# "--bind 0.0.0.0:5000" makes gunicorn listen on all network interfaces on port 5000.
# "app:app" specifies that gunicorn should run the 'app' Flask application instance from the 'app.py' file.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
