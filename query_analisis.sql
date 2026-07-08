-- Active: 1783497928514@@127.0.0.1@3306@xauusd_5m
USE xauusd_5m;

CREATE TABLE IF NOT EXISTS xauusd_raw (
    time_raw VARCHAR(100),
    open_price VARCHAR(50),
    high_price VARCHAR(50),
    low_price VARCHAR(50),
    close_price VARCHAR(50),
    volume VARCHAR(50)
);

SELECT * FROM xauusd_raw
ORDER BY time_raw DESC
LIMIT 10;

