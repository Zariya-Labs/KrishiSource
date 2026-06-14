import requests
from bs4 import BeautifulSoup
import json
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def scrape_market_prices():
    """
    Scrapes commodity prices from the Kalimati Fruits and Vegetables Market Board.
    If the website is unreachable or the parsing fails, returns a default mock dataset
    to ensure endpoint availability.
    """
    url = "https://kalimatimarket.gov.np/"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            table = soup.find('table')
            if table:
                rows = table.find_all('tr')[1:]  # Skip the table header row
                prices = []
                for row in rows:
                    cols = row.find_all('td')
                    if len(cols) >= 5:
                        item_name = cols[0].text.strip()
                        unit = cols[1].text.strip()
                        try:
                            # Clean price labels and convert to floats
                            min_price_str = cols[2].text.strip().replace('Rs.', '').replace(',', '').strip()
                            max_price_str = cols[3].text.strip().replace('Rs.', '').replace(',', '').strip()
                            avg_price_str = cols[4].text.strip().replace('Rs.', '').replace(',', '').strip()

                            min_p = float(min_price_str)
                            max_p = float(max_price_str)
                            avg_p = float(avg_price_str)

                            prices.append({
                                "item_name": item_name,
                                "unit": unit,
                                "min_price": min_p,
                                "max_price": max_p,
                                "avg_price": avg_p
                            })
                        except ValueError:
                            continue
                if prices:
                    logger.info(f"Successfully scraped {len(prices)} items from Kalimati Market.")
                    return prices
    except Exception as e:
        logger.error(f"Scraping failed: {e}. Falling back to default mock data.")

    # High-quality fallback data if remote scraping is blocked or fails
    logger.info("Returning fallback agricultural prices.")
    return [
        {"item_name": "Tomato Local", "unit": "Kg", "min_price": 50.0, "max_price": 60.0, "avg_price": 55.0},
        {"item_name": "Potato Red", "unit": "Kg", "min_price": 40.0, "max_price": 45.0, "avg_price": 42.5},
        {"item_name": "Onion Dry", "unit": "Kg", "min_price": 80.0, "max_price": 90.0, "avg_price": 85.0},
        {"item_name": "Cabbage", "unit": "Kg", "min_price": 30.0, "max_price": 35.0, "avg_price": 32.5},
        {"item_name": "Cauliflower Local", "unit": "Kg", "min_price": 70.0, "max_price": 80.0, "avg_price": 75.0},
        {"item_name": "Ginger", "unit": "Kg", "min_price": 120.0, "max_price": 140.0, "avg_price": 130.0},
        {"item_name": "Garlic Dry", "unit": "Kg", "min_price": 180.0, "max_price": 200.0, "avg_price": 190.0},
        {"item_name": "Banana", "unit": "Dozen", "min_price": 90.0, "max_price": 100.0, "avg_price": 95.0},
    ]

if __name__ == "__main__":
    print(json.dumps(scrape_market_prices(), indent=2))
