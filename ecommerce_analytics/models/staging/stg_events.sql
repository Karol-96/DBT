 {{
    config(
        materialized = 'incremental',
        unique_key = 'event_id',
        partition_by={
            'field': 'event_date',
            'data_type':'date'
        }
    )

 }}


 with sources as (
    select * from {{source ('ga4', 'events_*')}}
    {% if is_incremental() %}
    where _TABLE_SUFFIX >= FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(),INTERVAL 3 DAY))
    {% endif %}
 ),

 renamed as (
    select
    event_timestamp,
    PARSE_DATE('%Y%m%d', event_date) as event_date,
    user_pseudo_id,
    event_name,
    {{ clean_string('event_name')}} as clean_event_name,
    platform,
    traffic_source.source as traffic_source,
    traffic_source.medium as traffic_medium,
    traffic_source.name as traffic_campaign_name,
    geo.country as country,
    device.category as device_category,
    ecommerce.transaction_id,
    ecommerce.purchase_revenue as revenue
    from source
 )

 select * from renamed