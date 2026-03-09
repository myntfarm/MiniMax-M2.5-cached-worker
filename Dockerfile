FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install Python 3.12 + system deps
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

# Verify Python version
RUN python3 --version

# Install torch 2.8.0 for CUDA 12.8
RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu128

# Install all dependencies
RUN pip install --no-cache-dir \
    runpod>=1.6.2 \
    transformers>=4.52.0 \
    accelerate>=1.6.0 \
    safetensors>=0.5.3 \
    sentencepiece \
    protobuf \
    typing_extensions>=4.6.0

# Smoke test
RUN python3 -c "
import sys
import torch
print(f'Python: {sys.version}')
print(f'Torch:  {torch.__version__}')
print(f'CUDA:   {torch.version.cuda}')
from typing import Unpack
from transformers import AutoModelForCausalLM, AutoTokenizer
print('All imports OK')
"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .
CMD ["python3", "handler.py"]