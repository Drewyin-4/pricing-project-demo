# pricing-project-demo — Ultimate + Exposure + Trend Pricing Indication (R)

A compact actuarial pricing indication demo that replicates a common entry-level workflow:

1. Select AY-level ultimate losses from long-format triangle data  
2. Join exposures by accident year (AY)  
3. Convert to pure premium (ultimate / exposure)  
4. Trend historical pure premiums to the latest AY  
5. Produce an exposure-weighted indicated pure premium

---

## Repo Structure

- `scripts/`
  - `00_all.R` — one-click runner (sources the full pipeline)
  - `01_data_clean.R` — builds the AY-level pricing base (ultimate + dev_used + exposure)
  - `02_pricing_ind.R` — computes pure premium, trending, and final indicated pure premium

- `outputs/`
  - `pricing_base.rds` — cleaned AY-level dataset used downstream
  - `pricing_base.csv` — pricing base + derived fields (pure premium, trended values)
  - `indicated_pp.txt` — final indicated pure premium (single scalar)

> `outputs/` is committed to make the demo immediately reviewable without running code.

---

## Data Inputs

This pipeline expects two raw inputs (not included here if licensing is unclear):

- `meyers_triangles_long.csv`  
  Long format: accident year × development lag with ultimate loss values.
- `meyers_exposure.csv`  
  Exposure by accident year.

### Required fields (minimum)
- Triangle file: `ay`, `dev_lag`, `ultimate`, plus filtering fields used in the scripts
- Exposure file: `ay`, `exposure`

If raw data is not published, the repo still includes `outputs/pricing_base.rds` and `outputs/pricing_base.csv` for inspection.

---

## How It Works (Logic)

### Step 1 — Loss Selection (Ultimate)
- Filter to a specific line/segment (e.g., `ppauto`, `ultimate`, `train`)
- For each AY, select the row with the maximum development lag as the selected ultimate
- Keep the selected development lag as `dev_used` for transparency

### Step 2 — Join Exposure
- Aggregate exposure by AY (if needed)
- Join exposure onto the selected ultimate table

### Step 3 — Pure Premium + Trending
- `pure_premium = ultimate / exposure`
- Apply a constant annual trend factor to bring each AY to the latest AY:
  - `pure_premium_trended = pure_premium * (1 + trend)^(latest_ay - ay)`
- Default trend in the script: `trend = 0.05` (5% annual)

### Step 4 — Indication
- Exposure-weighted mean of trended pure premiums:
  - `indicated_pp = sum(pure_premium_trended * exposure) / sum(exposure)`

---

## Run Instructions

### Option A (recommended): run full pipeline
```r
source("scripts/00_all.R")
