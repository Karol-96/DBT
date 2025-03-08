 {{ config(materialized='view') }}

SELECT
    order_id,
    customer_id,
    total_amount,
    order_date
FROM {{ source('raw_data', 'orders') }}