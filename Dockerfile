# Base image with Playwright + Python preinstalled
FROM mcr.microsoft.com/playwright/python:v1.48.0-jammy

WORKDIR /app

# Install python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && python -m playwright install --with-deps

# Copy application code
COPY . .

# Default port; platforms like Koyeb set PORT env automatically
ENV PORT=8000
EXPOSE 8000

# Start FastAPI with gunicorn + uvicorn worker
# Use shell form so ${PORT} is expanded by the shell
CMD bash -lc 'gunicorn -k uvicorn.workers.UvicornWorker -w ${WEB_CONCURRENCY:-2} -b 0.0.0.0:${PORT:-8000} app:app'
