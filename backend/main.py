from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from scraper import scrape_market_prices
from typing import List, Dict, Any

app = FastAPI(
    title="KrishiSource Price Ingestion Service",
    description="Sprint 1, Ticket 1: Microservice providing Nepal agricultural wholesale market rates.",
    version="1.0.0"
)

# CORS configuration to allow cross-origin requests from Flutter/web clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/v1/prices/latest", response_model=List[Dict[str, Any]])
def get_latest_prices() -> List[Dict[str, Any]]:
    """
    Scrapes the Kalimati Fruits and Vegetable Market Development Board website
    and returns daily wholesale prices for all active agricultural produce.
    Returns data matching the following JSON schema:
    
    [
      {
        "date": "YYYY-MM-DD",
        "commodity_name_np": "गोलभेडा (ठूलो)",
        "commodity_name_en": "Tomato (Big)",
        "unit": "KG",
        "minimum_price": 60.0,
        "maximum_price": 70.0,
        "average_price": 65.0
      }
    ]
    """
    return scrape_market_prices()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
