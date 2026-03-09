FROM madiator2011/better-pytorch:cuda12.4-torch2.6.0

WORKDIR /app

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Smoke test
RUN python3 -c "\
import torch; \
from transformers import AutoModelForCausalLM, AutoTokenizer, pipeline; \
print(f'torch={torch.__version__}'); \
print('Smoke test passed')"

COPY handler.py /app/handler.py
CMD ["python3", "/app/handler.py"]