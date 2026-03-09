FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV GIT_PYTHON_REFRESH=quiet
ENV HF_HUB_DISABLE_IMPLICIT_TOKEN=1

RUN apt-get update && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3-pip \
    curl \
    git \
    wget \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

RUN pip install --no-cache-dir \
    runpod>=1.6.2 \
    transformers>=4.52.0 \
    accelerate>=1.6.0 \
    safetensors>=0.5.3 \
    sentencepiece \
    protobuf \
    typing_extensions>=4.6.0 \
    huggingface_hub>=0.23.0

RUN python3 -c "\
import sys, torch; \
from transformers import AutoModelForCausalLM, AutoTokenizer; \
from typing import Unpack; \
print(f'Python: {sys.version[:6]}'); \
print(f'Torch:  {torch.__version__}'); \
print(f'CUDA:   {torch.version.cuda}'); \
print('All imports OK')"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .
CMD ["python3", "handler.py"]