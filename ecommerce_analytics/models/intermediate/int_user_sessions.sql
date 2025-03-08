{{
    config(
        materialized='table',
        tags=['daily']
    )
}} 

{%- set event_types = ['page_view','purchase','add_to_cart','begin_checkout'] -%}

with events as (
    select * from {{ref('stg_events')}}
),

user_daily_events as (
    select user_pseudo_id,
    event_date,
    count(*) as total_events,
    {% for event_type in event_types %}
    sum(case when clean_event_name = '{{event_type}}' then 1 else 0 end) as {{ event_type}}_count,
    {% endfor %}
    sum(revenue) as total_revenue
    from events
    group by 1,2
)

select * from user_daily_events