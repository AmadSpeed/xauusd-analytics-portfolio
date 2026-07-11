CREATE VIEW xauusd_analysis_daily_summary AS
WITH base_calculations AS (
    SELECT 
        DATE(time_raw) AS trade_date,
        time_raw,
        open_price,
        high_price,
        low_price,
        close_price,
        volume,
        MAX(high_price) OVER (PARTITION BY DATE(time_raw)) AS daily_high,
        MIN(low_price) OVER (PARTITION BY DATE(time_raw)) AS daily_low,
        SUM(volume) OVER (PARTITION BY DATE(time_raw)) AS daily_volume,
        ROW_NUMBER() OVER (PARTITION BY DATE(time_raw) ORDER BY time_raw ASC) AS rn_open,
        ROW_NUMBER() OVER (PARTITION BY DATE(time_raw) ORDER BY time_raw DESC) AS rn_close
    FROM xauusd_raw
),
daily_prices AS (
        SELECT 
        trade_date,
        MAX(CASE WHEN rn_open = 1 THEN open_price END) AS daily_open,
        MAX(CASE WHEN rn_close = 1 THEN close_price END) AS daily_close,
        MAX(daily_high) AS daily_high,
        MAX(daily_low) AS daily_low,
        MAX(daily_volume) AS daily_volume
    FROM base_calculations
    GROUP BY trade_date
),
daily_metrics AS (
    SELECT 
        trade_date,
        daily_open,
        daily_close,
        daily_high,
        daily_low,
        daily_volume,
        COALESCE(
            ((daily_close - LAG(daily_close, 1) OVER (ORDER BY trade_date ASC)) / LAG(daily_close, 1) OVER (ORDER BY trade_date ASC) * 100), 
            0
        ) AS daily_return_percentage
    FROM daily_prices
)
-- Query untuk menampilkan hasil akhir 
SELECT 
    r.time_raw AS trade_time,
    d.daily_open,
    d.daily_close,
    d.daily_high,
    d.daily_low,
    d.daily_return_percentage,
    AVG(r.close_price) OVER (ORDER BY r.time_raw ASC ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS ma_1hour,
    AVG(r.close_price) OVER (ORDER BY r.time_raw ASC ROWS BETWEEN 143 PRECEDING AND CURRENT ROW) AS ma_12hour,
    ROUND((r.volume / AVG(r.volume) OVER(ORDER BY r.time_raw ASC ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) * 100), 2) AS volume_intensity_percentage
FROM base_calculations r
JOIN daily_metrics d ON r.trade_date = d.trade_date;