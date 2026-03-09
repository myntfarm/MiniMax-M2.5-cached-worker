FROM runpod/nvidia-pytorch:1.0.3-25.11

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV GIT_PYTHON_REFRESH=quiet
ENV HF_HUB_DISABLE_IMPLICIT_TOKEN=1

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .
CMD ["python3", "handler.py"]