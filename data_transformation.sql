-- Active: 1783595233773@@127.0.0.1@3306@xauusd_5m
USE xauusd_5m;

CREATE TABLE IF NOT EXISTS xauusd_raw (
    time_raw VARCHAR(100),
    open_price VARCHAR(50),
    high_price VARCHAR(50),
    low_price VARCHAR(50),
    close_price VARCHAR(50),
    volume VARCHAR(50)
);

#menampilkan 10 data terakhir dari tabel xauusd_raw
SELECT * FROM xauusd_raw
ORDER BY time_raw
LIMIT 10;

#menghapus data yang lebih lama dari 1 Juni 2026
DELETE FROM xauusd_raw
WHERE LEFT(time_raw, 10) < '2026-06-01';

#mengubah format waktu dari 'T' menjadi spasi dan menghapus 'Z' dari kolom time_raw
UPDATE xauusd_raw
SET time_raw = REPLACE(REPLACE(time_raw, 'T', ' '), 'Z', '');
SELECT * FROM xauusd_raw
ORDER BY time_raw DESC
LIMIT 10;

#merubah tipe data semua kolom dari tabel xauusd_raw menjadi tipe data yang sesuai
ALTER TABLE xauusd_raw
MODIFY COLUMN time_raw DATETIME,
MODIFY COLUMN open_price DECIMAL(10, 2),
MODIFY COLUMN high_price DECIMAL(10, 2),
MODIFY COLUMN low_price DECIMAL(10, 2),
MODIFY COLUMN close_price DECIMAL(10, 2),
MODIFY COLUMN volume DECIMAL(15, 2);

