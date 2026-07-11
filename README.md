# XAUUSD Analytics & Feature Engineering Pipeline

Proyek ini berfokus pada pembangunan pipeline transformasi data (*Data Transformation*) dan rekayasa fitur (*Feature Engineering*) untuk pergerakan harga emas (XAUUSD) berbasis data intraday (interval 5 menit). Seluruh kalkulasi metrik teknikal dilakukan langsung di dalam database (SQL-level) untuk menghasilkan dataset yang matang, bersih, dan siap divisualisasikan menggunakan Tableau.

## 📊 Data Source & Credit

Dataset mentah yang digunakan dalam proyek ini diambil dari platform **Kaggle**. 

* **Nama Dataset**: XAUUSD 5m OHLCV Metals Historical Data
* **Sumber/Pembuat**: Ork.ad | Financial Data Provider
* **Link Dataset**: https://www.kaggle.com/datasets/orkadd/xauusd-5m-ohlcv-metals-historical-data

*Disclaimer: Dataset ini digunakan murni untuk kepentingan pembelajaran, pengembangan portofolio data engineering, dan simulasi visualisasi analitis.*

## 🚀 Fitur & Metrik yang Dikembangkan

Dataset akhir yang dihasilkan (`xauusd_analys_daily.csv`) membawa beberapa fitur kalkulasi baru hasil transformasi dari data mentah (`xauusd_raw`):

1. **`trade_date` & `trade_time`**: Pemisahan dan penyesuaian granularitas waktu untuk mempermudah pemfilteran berbasis deret waktu (*time-series*).
2. **`daily_close`**: Menangkap harga penutupan harian sejati dengan menyaring baris menit terakhir (`rn = 1`) pada setiap tanggal menggunakan *Window Function* `ROW_NUMBER()`.
3. **`yesterday_close`**: Mengambil harga penutupan satu hari sebelumnya menggunakan fungsi `LAG()`, diamankan dengan fungsi `COALESCE()` untuk mencegah nilai `NULL` pada baris hari pertama.
4. **`daily_return_percentage`**: Mengukur momentum dan persentase performa harian emas terhadap hari sebelumnya.
5. **`ma_1hour` & `ma_12hour`**: *Simple Moving Average* berbasis interval intraday (12 periode untuk 1 jam, 144 periode untuk 12 jam) menggunakan klausa `ROWS BETWEEN ... PRECEDING` untuk memperhalus fluktuasi harga jangka pendek dan menengah.
6. **`volume_intensity_percentage`**: Pendekatan berbasis *Volume Z-Score* untuk mengukur intensitas volume transaksi menit berjalan terhadap rata-rata 1 jam terakhir guna mendeteksi aktivitas anomali pasar (*whale movements*).

## 🛠️ Tech Stack yang Digunakan

* **Database Engine**: MySQL / PostgreSQL
* **IDE / Query Tool**: VS Code (dengan optimasi *Advanced Database Extensions*)
* **Visualisasi Data**: Tableau (Koneksi via File Data / Live Extract)
* **Bahasa**: SQL (Common Table Expressions / CTE, Window Functions, Agregasi Kontinu)

## 📁 Struktur File Proyek

```text
├── data_transformation.sql  # Kueri tahap awal pembersihan data
├── data_analysis.sql        # Kueri utama rekayasa fitur (Dua struktur CTE & Ekspor)
├── XAUUSD_5m.csv            # Dataset mentah per 5 menit (Source)
├── xauusd_analys_daily.csv # Dataset matang hasil ekspor pipeline (Ready for Tableau)
└── README.md                # Dokumentasi proyek