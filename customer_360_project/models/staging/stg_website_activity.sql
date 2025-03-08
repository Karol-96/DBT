 {{ config(materialized='view') }}

SELECT
    activity_id,
    customer_id,
    activity_type,
    activity_timestamp
FROM {{ source('raw_data', 'website_activity') }}