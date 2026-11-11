from fastapi import FastAPI

app = FastAPI(title="Vibe App")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
