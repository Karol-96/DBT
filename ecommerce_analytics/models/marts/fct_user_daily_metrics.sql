 {{ config(
    materialized='incremental',
    unique_key=['user_pseudo_id', 'event_date'],
    partition_by={
        "field": "event_date",
        "data_type": "date"
    },
    cluster_by=['user_pseudo_id']
) }}

with user_sessions as (
    select * from {{ ref('int_user_sessions') }}
    {% if is_incremental() %}
    where event_date >= (select max(event_date) from {{ this }})
    {% endif %}
),

-- Calculate user metrics
user_metrics as (
    select
        user_pseudo_id,
        event_date,
        total_events,
        total_revenue,
        page_view_count,
        purchase_count,
        add_to_cart_count,
        begin_checkout_count,
        -- Calculate engagement score
        (page_view_count * 1 + 
         add_to_cart_count * 2 + 
         begin_checkout_count * 3 + 
         purchase_count * 5) as engagement_score,
        -- Calculate conversion rate
        SAFE_DIVIDE(purchase_count, page_view_count) as conversion_rate
    from user_sessions
)

select * from user_metrics