SELECT 
    time_raw,
    close_price,
    AVG(close_price) OVER (ORDER BY time_raw ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS ma_1hour,
    AVG(close_price) OVER (ORDER BY time_raw ROWS BETWEEN 143 PRECEDING AND CURRENT ROW) AS ma_12hour
    FROM xauusd_raw
    ORDER BY time_raw DESC;