 {{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent,
        MAX(order_date) AS last_order_date
    FROM {{ ref('stg_orders') }}
    GROUP BY 1
),

customer_activity AS (
    SELECT
        customer_id,
        COUNT(*) AS total_activities,
        MAX(activity_timestamp) AS last_activity_date
    FROM {{ ref('stg_website_activity') }}
    GROUP BY 1
)

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.signup_date,
    COALESCE(co.total_orders, 0) AS total_orders,
    COALESCE(co.total_spent, 0) AS total_spent,
    co.last_order_date,
    COALESCE(ca.total_activities, 0) AS total_activities,
    ca.last_activity_date
FROM {{ ref('stg_customers') }} c
LEFT JOIN customer_orders co ON c.customer_id = co.customer_id
LEFT JOIN customer_activity ca ON c.customer_id = ca.customer_id

{% if is_incremental() %}
WHERE 
    c.signup_date > (SELECT MAX(signup_date) FROM {{ this }})
    OR co.last_order_date > (SELECT MAX(last_order_date) FROM {{ this }})
    OR ca.last_activity_date > (SELECT MAX(last_activity_date) FROM {{ this }})
{% endif %}