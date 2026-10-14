# --- Estágio 1: Build das Dependências ---
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependências num diretório de utilizador para isolamento
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

WORKDIR /app

# Copiar apenas as dependências compiladas do estágio anterior
COPY --from=builder /root/.local /root/.local
# Copiar o código fonte da aplicação
COPY . /app

# Garantir que os executáveis do pip estão no PATH
ENV PATH=/root/.local/bin:$PATH

# Expor a porta padrão da aplicação
EXPOSE 8000

# Comando para iniciar o servidor Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]