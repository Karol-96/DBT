{% snapshot user_properties_snapshot %} 

{{

    config(
        target_schema = 'snapshots',
        unique_key = 'user_pseudo_key',
        strategy = 'timestamp',
        updated_at = 'last_updated_at',
    )
}}


select 
user_pseudo_id,
first_seen_date,
last_seen_date,
lifetime_value,
current_timestamp as last_updated_at
from {{ ref('int_user_properties')}}

{% endsnapshot %}