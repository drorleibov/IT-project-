# Data Source Proposals

**Team:** Dror Leibov and Ofir Gelbart  
**Course:** Fundamentals of Information Technology (2026–2027)

## Proposal 1: Bitcoin Price Differences Between Exchanges

- **Purpose and research question:** Compare the live buying and selling offers for Bitcoin (BTC/USD) on two exchanges. Do the differences between their best available prices change by hour of day?
- **Sources and URLs:**
  - Kraken order book (BTC/USD): https://api.kraken.com/0/public/Depth?pair=XBTUSD&count=5
  - Bitstamp order book (BTC/USD): https://www.bitstamp.net/api/v2/order_book/btcusd/
- **Expected content:** JSON order-book snapshots showing bid prices (offers to buy), ask prices (offers to sell), and the quantities available at each price. We would record the collection time, exchange, currency pair, best bid, best ask, and their quantities.
- **Proposed update / collection frequency:** Market offers change continuously. We propose sampling each exchange every 5 minutes, subject to approval and API restrictions.
- **Expected sample size:** Two API responses per collection (one per exchange). If each reduced snapshot is about 2–5 KB, this would be about 4–10 KB per collection, or roughly 40–101 MB over ten weeks of 24/7 sampling. These are *planning estimates*, not measured response sizes; full API responses might be larger.
- **Authentication:** The documented public order-book endpoints do not normally require an API key, user login, or password to read market data. Actual access from the course environment still needs testing.
- **Example data:** The following is a shortened excerpt of a **documentation sample from Kraken**, not a live measurement by our team:

```json
{
  "error": [],
  "result": {
    "XXBTZUSD": {
      "asks": [["30384.10000", "2.059", 1688671659]],
      "bids": [["30297.00000", "1.115", 1688671636]]
    }
  }
}
```

  Example source: https://docs.kraken.com/api-reference/market-data/get-order-book
- **Why live collection matters / limitations:** Offers may change or disappear between samples; past exact snapshots may not be retrievable from the public endpoints. However, commercial archives may exist. Exchange time differences, fees, API limits, permission for automated access, and public publication rights must be checked before selecting this project.

## Proposal 2: Bitcoin vs. Ethereum Market Liquidity

- **Purpose and research question:** Compare how much Bitcoin (BTC/USD) and Ethereum (ETH/USD) is offered for sale or purchase at several price levels. Does the estimated cost of a hypothetical larger purchase vary by asset and by time of day?
- **Sources and URLs:**
  - Kraken order book documentation: https://docs.kraken.com/api-reference/market-data/get-order-book
  - Bitstamp order-book API documentation: https://www.bitstamp.net/api/
  - Example Bitstamp market URL: https://www.bitstamp.net/api/v2/order_book/ethusd/
- **Expected content:** JSON snapshots of bid and ask price levels and the quantity at each level for BTC/USD and ETH/USD. We would retain a small fixed number of price levels and note the collection time, exchange, and currency pair.
- **Proposed update / collection frequency:** Liquidity changes continuously. We propose sampling every 10 minutes, subject to approval and API limits.
- **Expected sample size:** Four API responses per collection (two assets at two exchanges). Assuming reduced snapshots of 2–5 KB each, approximately 8–20 KB per collection, or roughly 81–202 MB across ten weeks of 24/7 sampling. These are *estimates* pending an actual size measurement.
- **Authentication:** These public order-book endpoints ordinarily do not require an API key, user login, or password for reading data; this needs confirmation by an actual request.
- **Example data:** The following is a shortened excerpt of a **documentation sample from Bitstamp**, showing the format of one order-book response (not a live BTC or ETH observation by our team):

```json
{
  "timestamp": "1643643584",
  "microtimestamp": "1643643584684047",
  "bids": [["9484.34", "1.00000000"]],
  "asks": [["9484.34", "1.00000000"]]
}
```

  Example source: https://www.bitstamp.net/api/ (Order book → Response samples)
- **Why live collection matters / limitations:** Visible liquidity changes as orders are added, removed, or executed. However, third-party historical data archives may exist, and order-book depth does not guarantee executable trade prices. The legality of automated collection and public display still requires verification.

## Preferred Proposal

**Proposal 1 — Bitcoin Price Differences Between Exchanges** is our current preference because it offers a focused comparison of two competing businesses and a straightforward quantitative question.

**Status:** These are *proposals*, not approved data sources. The examples above come from published API documentation, not requests performed by us. Before approval, we need to check real responses, storage size, historical availability, and applicable terms of use. Both proposals currently use the same two providers; if the instructors require two entirely different provider pairs, we will revise the alternatives.
