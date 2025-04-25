FROM python:3.11-slim

WORKDIR /app

COPY import_products.py .

RUN pip install requests

ENTRYPOINT ["python", "import_products.py"]
