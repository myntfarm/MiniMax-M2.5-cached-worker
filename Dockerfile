FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

WORKDIR /app

# Ensure consistent torch stack
RUN pip install --no-cache-dir --force-reinstall \
    torch==2.6.0 \
    torchvision==0.21.0 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu128

# Install model dependencies
RUN pip install --no-cache-dir \
    transformers>=4.52.0 \
    accelerate>=1.6.0 \
    safetensors>=0.5.3 \
    sentencepiece protobuf

# Smoke test
RUN python3 -c "\
import torch, torchvision; \
from transformers import pipeline; \
print(f'torch={torch.__version__} torchvision={torchvision.__version__}'); \
print('Smoke test passed')"

COPY handler.py /app/handler.py
CMD ["python3", "/app/handler.py"]