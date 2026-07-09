WITH ranked_data AS (
    SELECT 
        DATE(time_raw) AS trade_date,
        time_raw,
        open_price,
        high_price,
        low_price,
        close_price,
        volume,
        ROW_NUMBER() OVER (PARTITION BY DATE(time_raw) ORDER BY time_raw DESC) AS rn
    FROM xauusd_raw
),

daily_market_stats AS (
    SELECT 
        trade_date,
        close_price AS daily_close,
        COALESCE(
            LAG(close_price, 1) OVER (ORDER BY trade_date ASC), 
            close_price
        ) AS yesterday_close,
        COALESCE(
            ((close_price - LAG(close_price, 1) OVER (ORDER BY trade_date ASC)) / LAG(close_price, 1) OVER (ORDER BY trade_date ASC) * 100), 
            0
        ) AS daily_return_percentage
    FROM ranked_data
    WHERE rn = 1
)

SELECT 
    r.time_raw AS trade_time,
    r.close_price,
    d.daily_close,
    d.yesterday_close,
    d.daily_return_percentage,
    
    AVG(r.close_price) OVER (ORDER BY r.time_raw ASC ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS ma_1hour,
    AVG(r.close_price) OVER (ORDER BY r.time_raw ASC ROWS BETWEEN 143 PRECEDING AND CURRENT ROW) AS ma_12hour,
    ROUND((volume / AVG(volume) OVER(ORDER BY r.time_raw ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) * 100),2) AS volume_intensity_percentage
FROM ranked_data r
JOIN daily_market_stats d ON r.trade_date = d.trade_date
ORDER BY r.time_raw DESC;