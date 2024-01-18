# Use the official Python base image
FROM python:3.11-bullseye AS base

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Use small image for production
FROM python:3.11-alpine

# Set the working directory in the container
WORKDIR /app

# Install Gunicorn
RUN pip install --no-cache-dir gunicorn==21.2.0

# Copy the Python dependencies from the base image
COPY --from=base /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# Copy the static folder to the container
COPY static ./static
COPY templates ./templates

# Copy the app.py file to the container
COPY app.py dbcontext.py person.py ./

# Expose the port on which the app will run
EXPOSE 80

# Run the app.py file with Gunicorn
ENTRYPOINT ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:80", "--access-logfile", "-", "--error-logfile", "-", "app:app"]