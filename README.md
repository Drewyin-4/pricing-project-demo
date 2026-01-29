# pricing-project-demo — Actuarial Pricing Indication (R)

This repository demonstrates a compact actuarial pricing indication workflow built in R.
The objective is to derive an accident-year level indicated pure premium starting from
large, long-format loss development data and exposure information.

The project is structured to resemble an entry-level pricing support task:
data reduction, transparent selection, and exposure-weighted indication.

---

## Project Structure

- `scripts/`
  - `00_all.R` — one-click runner for the full pipeline
  - `01_data_clean.R` — builds the accident-year pricing base
  - `02_pricing_ind.R` — computes pure premiums, applies trend, and produces indication

- `outputs/`
  - `pricing_base.rds` — cleaned accident-year pricing base
  - `pricing_base.csv` — pricing base with derived fields
  - `indicated_pp.txt` — final indicated pure premium (scalar)

Outputs are committed to make the project immediately reviewable without executing code.

---

## Data Scale and Processing Notes

### Raw data characteristics

This project starts from long-format loss development and exposure data:

- **Loss triangles (`meyers_triangles_long.csv`)**
  - ~**444,000 rows**, **8 columns**
  - **10 accident years**
  - Development lags from **1 to 10**
  - Long format (one row per accident year × development lag), consistent with
    industry triangle storage and downstream aggregation workflows.

- **Exposure data (`meyers_exposure.csv`)**
  - ~**7,800 rows**, **5 columns**
  - Exposure recorded at the accident-year level.

Raw input files are not committed if licensing is unclear.  
Instead, the processed pricing base and final outputs are included for inspection.

---

### Data reduction and selection logic

The pipeline intentionally reduces a large development-level dataset to an
**accident-year pricing view**, following standard pricing practice:

1. Filter the loss data to the relevant line, segment, and measure
   (e.g. ultimate losses for a training sample).
2. For each accident year, select the record with the **maximum development lag**
   as the working ultimate.
3. Retain the selected development lag (`dev_used`) for transparency.
4. Aggregate and join exposure by accident year.

After selection:
- The pricing base contains **10 rows**, one per accident year.
- Each row represents the selected ultimate loss and exposure used for pricing.

This reduction is deliberate: pricing decisions are made at the **accident-year level**,
not at individual development lags.

---

## Pricing and Indication

From the accident-year pricing base:

- **Pure premium** is calculated as  
  `pure premium = ultimate / exposure`
- A constant annual trend factor is applied to bring each accident year to the
  latest accident year.
- The final indication is computed as an **exposure-weighted mean** of trended
  pure premiums.

---

## Outputs

- `outputs/pricing_base.rds`  
  Accident-year pricing base (selected ultimate, exposure, development lag used).

- `outputs/pricing_base.csv`  
  Pricing base with derived fields:
  - pure premium
  - years trended to latest accident year
  - trended pure premium

- `outputs/indicated_pp.txt`  
  Final exposure-weighted indicated pure premium (single scalar value).

These outputs are intentionally small and interpretable, while remaining traceable
to a much larger underlying loss history.

---

## Practical Notes

- A constant trend is used for demonstration purposes; production pricing would
  typically apply calendar-year or split frequency/severity trends.
- Selecting the maximum development lag per accident year is a simplified proxy
  for maturity selection and keeps the example focused on pricing mechanics rather
  than reserving methodology.

---

## How to Run

```r
source("scripts/00_all.R")
