FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# Verify Python version at build time
RUN python3 --version | grep -E "3\.(11|12|13)" || \
    (echo "ERROR: Python 3.11+ required" && exit 1)

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Smoke test
RUN python3 -c "\
import sys; \
assert sys.version_info >= (3, 11), f'Python 3.11+ required, got {sys.version}'; \
from typing import Unpack; \
from transformers import AutoModelForCausalLM, AutoTokenizer; \
print(f'Python={sys.version}'); \
print('Smoke test passed')"

COPY handler.py /app/handler.py
CMD ["python3", "/app/handler.py"]