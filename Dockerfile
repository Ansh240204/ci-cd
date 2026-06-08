FROM --platform=linux/amd64 python:3.11-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]