# Bitcoin Order-Book Data Sources

**Team:** Dror Leibov and Ofir Gelbart
**Course:** Fundamentals of Information Technology (2026–2027)

## 1. Approved Sources and Collection Settings

We selected Proposal 1, comparing BTC/USD order books on Kraken and Bitstamp, following the instructors' approval and feedback.

Research question: How do differences in the best BTC/USD bid and ask prices between Kraken and Bitstamp vary over time, and how are they associated with each exchange's bid-ask spread and quantities available at the five best price levels?

This is an observational comparison: associations will not establish causation.

| Property | Kraken | Bitstamp |
|---|---|---|
| Source | Public BTC/USD order book | Public BTC/USD order book |
| Endpoint | https://api.kraken.com/0/public/Depth?pair=XBTUSD&count=5 | https://www.bitstamp.net/api/v2/order_book/btcusd/ |
| Documentation | https://docs.kraken.com/api-reference/market-data/get-order-book | https://www.bitstamp.net/api/ |
| Response format | JSON | JSON |
| API key or login | Not required for this endpoint; tested successfully | Not required for this endpoint; tested successfully |
| Retained depth | Five bid and five ask price levels | Five bid and five ask price levels, selected from the larger response |
| Planned collection frequency | One request every five minutes | One request every five minutes |
| Initial collection | One manual snapshot on each of 17–20 November 2026 | Collected during the same four collection sessions |
| License and usage terms | Provider-controlled content, subject to Kraken's applicable terms; no open-data redistribution license has been established for this project | Provider-controlled exchange data; the API documentation directs commercial users to obtain a Data License Agreement |

All collection times, directory dates, and filenames use UTC.

Kraken's published public REST guidance states that one request per second or less remains within its rate limits. Bitstamp's API documentation specifies standard limits of 400 requests per second and 10,000 requests per ten minutes. Our planned five-minute interval is substantially lower. Limits may change, and requests from the same IP may share limits.

Public technical access is not equivalent to an unrestricted data license. This is an educational project; we do not claim ownership of the providers' market data or assign an open license to it. Permission for public redistribution of raw data or public website display has not been established by our access tests and must be clarified before extending publication.

References:
- https://support.kraken.com/articles/206548367-what-are-the-api-rate-limits-
- https://www.kraken.com/legal
- https://www.kraken.com/legal/global-terms
- https://www.bitstamp.net/api/

## 2. Collected Information and Limitations

Each collection session produces one JSON file containing observations from both exchanges.

For each exchange, we retain:
- Five highest bid prices and their quantities.
- Five lowest ask prices and their quantities.
- The UTC time immediately before starting the request.

A bid is an offer to buy BTC; an ask is an offer to sell BTC. Each entry represents a price level and its available quantity, not necessarily one trader or one individual order.

The file contains `kraken_collected_at_utc`, `bitstamp_collected_at_utc`, `kraken`, and `bitstamp`. We preserve Kraken's returned structure and retain Bitstamp's `timestamp`, `microtimestamp`, and selected bid/ask arrays.

Files follow `raw/YYYY-mm-dd/HHMM.json`, using the start time of the Kraken request as the collection-session filename. Files are append-only: existing samples are not edited, renamed, or overwritten.

Initial samples:
- `raw/2026-11-17/1143.json`
- `raw/2026-11-18/1818.json`
- `raw/2026-11-19/0625.json`
- `raw/2026-11-20/1025.json`

Each initial file is 868 bytes; the four files total 3,472 bytes.

Prices, quantities, and timestamps vary. Provider names, the currency pair, and the retained depth are fixed project settings.

Limitations:
- Requests are sequential rather than simultaneous. The first session had a 16-second gap; separate collection timestamps preserve this difference.
- Collection timestamps record request starts, not exact matching-engine observation times.
- Only five levels per side are retained, so deeper liquidity is not represented.
- Offers can change or disappear before a trade occurs.
- Price differences do not establish executable profit: fees, transfer delays, available balances, and execution constraints are not included.
- Four manual sessions cannot establish reliable hourly patterns. Those questions require the later, denser collection stage.
- Public trade histories are different from our collected order-book snapshots. We have not established that equivalent historical snapshots are unavailable from every third-party archive.
- Missing samples will remain missing; we will not fabricate or backdate observations.

Initial checks confirmed empty Kraken error arrays and five retained entries on each side at both exchanges. Source timestamps were also inspected where available.

## 3. Planned Dataset Schema

The future normalized table will be stored as `data/dataset.csv`, with one header row.

One row represents one price level, on one side, at one exchange, within one collection session. A complete session produces 20 rows: two exchanges times two sides times five levels. The four initial sessions should therefore produce 80 data rows.

| Column | Meaning | Type and unit |
|---|---|---|
| snapshot_id | Relative raw-file path identifying the shared collection session | Text |
| collected_at_utc | UTC request-start time for the relevant exchange | ISO 8601 text ending in Z |
| exchange | `kraken` or `bitstamp` | Text |
| pair | Standardized currency pair, `BTC/USD` | Text |
| side | `bid` for buy offers or `ask` for sell offers | Text |
| level | Rank from 1 to 5, where 1 is the best price on that side | Integer; no unit |
| price_usd | Price of one BTC at that level | Decimal; USD per BTC |
| quantity_btc | Available BTC quantity at that price level | Decimal; BTC |

Bids are ranked by descending numeric price; asks by ascending numeric price. Source price and quantity strings will be interpreted as decimal values.

The intended row identifier is `(snapshot_id, exchange, side, level)`. Missing or invalid values will not be replaced with invented values. Incomplete sessions will be reported rather than silently treated as complete.

## 4. Reasons for Selecting These Fields

- `snapshot_id` connects both exchanges to the same collection session and traces each row to its raw file.
- `collected_at_utc` supports time comparisons and exposes timing differences between requests.
- `exchange` distinguishes the providers.
- `pair` makes the asset and quote currency explicit.
- `side` separates buying from selling offers.
- `level` identifies the best price and the next four levels.
- `price_usd` supports cross-exchange price and bid-ask spread comparisons.
- `quantity_btc` provides context about visible liquidity at each price level.

Retaining five levels preserves the best prices and some nearby liquidity while keeping storage small.

We do not retain Bitstamp's full order book. This limits deeper-liquidity analysis but avoids the much larger storage requirement of full responses.

Kraken's error field and level timestamps, and Bitstamp's source timestamps, remain available in the raw files but are not separate columns in the initial normalized schema. Kraken's per-level timestamp and Bitstamp's book timestamp describe different objects, so we do not combine them into a falsely equivalent timestamp column.

Derived measures, such as spreads and cross-exchange differences, will be calculated later from the collected data rather than inserted as unsupported observations.

## 5. Mapping Source Fields to Dataset Columns

Here, `i` denotes an entry after numeric price ranking, starting at zero. The saved JSON includes the provider wrapper names shown below.

| Dataset column | Kraken mapping | Bitstamp mapping |
|---|---|---|
| snapshot_id | Relative raw-file path | Relative raw-file path |
| collected_at_utc | `kraken_collected_at_utc` | `bitstamp_collected_at_utc` |
| exchange | Assigned constant `kraken` | Assigned constant `bitstamp` |
| pair | Standardize `XXBTZUSD` to `BTC/USD`, according to the requested pair | Assigned `BTC/USD` from the `btcusd` endpoint |
| side | `bids` becomes `bid`; `asks` becomes `ask` | `bids` becomes `bid`; `asks` becomes `ask` |
| level | Numeric price rank, `i + 1` | Numeric price rank, `i + 1` |
| price_usd | `kraken.result.XXBTZUSD.bids[i][0]` or `asks[i][0]` | `bitstamp.bids[i][0]` or `asks[i][0]` |
| quantity_btc | `kraken.result.XXBTZUSD.bids[i][1]` or `asks[i][1]` | `bitstamp.bids[i][1]` or `asks[i][1]` |

The `[2]` element of each Kraken price-level entry is retained in raw JSON but excluded from the initial CSV. Bitstamp's `timestamp` and `microtimestamp` are likewise retained in raw JSON.

## 6. Expected Storage for the Collection Period

Planning assumptions:
- Thirteen weeks of continuous collection as the semester-length estimation horizon.
- One combined snapshot every five minutes, 24 hours per day.
- Five bid and five ask levels per exchange, giving 20 CSV rows per snapshot.
- Decimal MB means 1,000,000 bytes.

If the actual collection period differs, estimates scale proportionally with the number of days.

Number of snapshots:
`13 * 7 * 24 * 60 / 5 = 26,208`

### Raw JSON

Measured initial snapshot size: 868 bytes.

Estimated JSON content:
`26,208 * 868 = 22,748,544 bytes`, approximately **22.7 MB**.

A conservative content budget of 2,000 bytes per snapshot gives:
`26,208 * 2,000 = 52,416,000 bytes`, approximately **52.4 MB**.

Filesystem block allocation and directories consume additional space. For example, one 4 KiB allocation block per snapshot would consume:
`26,208 * 4,096 = 107,347,968 bytes`, approximately **107.3 MB** for file blocks alone. Actual filesystem allocation must be monitored.

### Normalized CSV

Expected rows:
`26,208 * 20 = 524,160 data rows`, plus one header.

The normalized file has not yet been generated. Assuming an average of 200 bytes per row, including separators and newline:
`524,160 * 200 = 104,832,000 bytes`, approximately **104.8 MB**, plus the small header.

This is a planning estimate, not a measured CSV size. It will be revised after normalization is implemented.

The conservative raw-content budget plus the CSV estimate is:
`52,416,000 + 104,832,000 = 157,248,000 bytes`, approximately **157.2 MB**, before filesystem overhead, Git history, and other project files. Both data outputs are expected to fit within the 500 MB project limit under these assumptions. We will monitor actual disk usage and revise the plan if necessary.

The current four manual daily samples are an initial exercise stage; five-minute automated collection has not yet been implemented.
