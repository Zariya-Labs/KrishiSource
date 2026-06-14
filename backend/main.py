from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from scraper import scrape_market_prices

app = FastAPI(
    title="KrishiSource Agricultural Scraper API",
    description="Microservice to scrape and serve agricultural commodity prices."
)

# Enable CORS for frontend clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/prices")
def get_prices():
    """
    Returns daily commodity market prices.
    """
    return scrape_market_prices()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
