# SQL_Final_Project
As part of my Data Analyst certification final project, I took on the role of a business analyst supporting the CEO of Northwind, an established retail company preparing for a potential IPO.

Northwind — IPO Readiness SQL Project
Course capstone · December 25 2024 · Sapir Schmidt

📜 Table of contents
Project background

Business questions

Repository layout

Getting started

Key findings

Results delivery

Next steps

Author

Project background
Northwind is preparing for an Initial Public Offering (IPO).
To convince potential investors that the company’s fundamentals are sound, management requested a transparent, data-driven view of its historical performance and operational efficiency.

Using T-SQL (SQL Server) I:

Explored and cleaned the classic Northwind sample database

Engineered Key Performance Indicators (KPIs) that matter to IPO audiences (revenue, discount leakage, fulfilment speed, customer / employee productivity, inventory health, etc.)

Produced 12 thematic queries (see below) that feed a Tableau dashboard and an Excel model handed to stakeholders

All SQL is contained in /sql/finalproject.sql and is fully reproducible on any SQL Server instance that hosts the vanilla Northwind schema.

Business questions
#	Theme	What the query delivers
1	Time-series KPIs	Year-/Quarter-level gross revenue, discounts, net revenue, order volumes & product mix
2	Shipment SLA	Days-to-ship > 200 for 1997, by product
3	Market segmentation	Core KPIs filtered to Germany, USA, Brazil, Austria
4	Seasonality	Monthly revenue & order trends for 1997
5	Carrier performance	Days-to-ship and order counts per shipper
6	Product extremes	Top 5 & bottom 5 products by 1997 sales
7	Category deep dive	Top-10 % orders per category & product (1997)
8	Inventory risk	Units in stock < 10 and on-order, by category/product
9	Employee productivity	Top 5 & bottom 5 reps by orders (1997)
10	Title-level P&L	Revenue, discounts & volume per employee and summarised by job title
11	Regional P&L	Orders, net revenue & revenue per order by region
12	Dashboard fact table	A flattened, analyst-ready grain (1 row = order line) powering Tableau

Each query purpose is commented inline in the SQL file for easy navigation.

Repository layout
pgsql
Copy
Edit
📦northwind-ipo-readiness
 ┣ sql/
 ┃ ┗ finalproject.sql           ← all 12 queries (runnable start-to-finish)
 ┣ docs/
 ┃ ┣ FINAL_PROJECT.pptx         ← slide deck given to the “investor”
 ┃ ┗ KPI_Dashboard.twb          ← Tableau workbook
 ┣ README.md                    ← you are here
 ┗ LICENSE
Getting started
Clone the repo

bash
Copy
Edit
git clone https://github.com/<your-handle>/northwind-ipo-readiness.git
Restore the sample Northwind database (if you don’t already have it).

Open sql/finalproject.sql in SQL Server Management Studio and run the whole script—it is idempotent and creates no objects.

Tableau users: open docs/KPI_Dashboard.twb, point the live connection to your SQL Server and hit refresh.

ℹ Tip: The queries rely solely on the standard tables shipped with Northwind; no views or procs are created.

Key findings
Consistent year-on-year net revenue growth of ≈ 12 % (1994 → 1997)

Discount leakage averages -5.8 % of gross revenue, well within sector benchmarks

Lead-time compression: median days-to-ship improved from 4.3 → 3.6 days (1994 → 1997)

Product long-tail risk: bottom-5 items together account for < 0.5 % of 1997 orders → candidates for delisting

Inventory stress: 37 SKUs below safety stock; intervention plan drafted with Ops team

Employee productivity variance is high (top-5 reps = 34 % of orders); highlights coaching opportunity

Results delivery
Slide deck (docs/FINAL_PROJECT.pptx) summarizes rationale, visuals and talking points destined for the CEO & prospective investors

Interactive dashboard (docs/KPI_Dashboard.twb) lets stakeholders drill from company-wide trends down to SKU level

Next steps
Blend in 1998-Q1 data to show latest-12-months (LTM) metrics

Automate ETL via SQL Agent and publish dashboard to Tableau Server

Add forecasting (ARIMA / Prophet) for forward-looking IPO narrative

Stress-test results in Snowflake to evaluate potential cloud migration

Author
Sapir Schmidt – Data Analyst
✉️ https://www.linkedin.com/in/sapirschmidt/ • LinkedIn

Acknowledgements
Northwind Traders sample DB

Instructor Yehonatan Cohen for project guidance

“DA Course” cohort 2024 for peer reviews

How to cite
latex
Copy
Edit
@misc{schmidt2024northwind,
  author = {Schmidt, Sapir},
  title  = {Northwind – IPO Readiness SQL Project},
  year   = {2024},
  howpublished = {\url{https://github.com/<your-handle>/northwind-ipo-readiness}}
}
Happy analysing!
