from fastapi import FastAPI

app = FastAPI(title="Payment API", version="1.0.0")


@app.get("/")
def read_root():
    return {
        "status": "healthy",
        "message": "Payment API em execução com sucesso na GCP!"
    }


@app.get("/healthz")
def health_check():
    return {"status": "ok"}
