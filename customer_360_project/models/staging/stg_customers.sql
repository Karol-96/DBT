 {{ config(materialized='view') }}

SELECT
    customer_id,
    LOWER(TRIM(full_name)) AS full_name,
    LOWER(TRIM(email)) AS email,
    signup_date
FROM {{ source('raw_data', 'customers') }}