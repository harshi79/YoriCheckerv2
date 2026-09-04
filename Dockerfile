# Use a lightweight Python image
FROM python:3.10-slim

# Unbuffered output so bot logs appear immediately in container logs
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Set working directory
WORKDIR /app

# Copy requirements first (better caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create a non-root user to run the bot
RUN adduser --disabled-password --gecos '' appuser \
    && mkdir -p /app/results \
    && chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Health server port (see main.py, default PORT=8080)
ENV PORT=8080
EXPOSE 8080

# Run the bot
CMD ["python", "main.py"]
