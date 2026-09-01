WITH
    date_spine AS (
        SELECT DATE_SUB(MAX(event_timestamp), INTERVAL 30 DAY) AS date_cutoff
            FROM {{ ref('stg_user_events') }}
    ),

    source_funnel AS (
        SELECT
            traffic_source,
            COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END)
                AS stage_1_views,
            COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END)
                AS stage_2_cart,
            COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END)
                AS stage_3_checkout,
            COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END)
                AS stage_4_payment,
            COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
                AS stage_5_purchase
        FROM {{ ref('stg_user_events') }}
        WHERE event_timestamp >= (SELECT date_cutoff
                                  FROM date_spine)
        GROUP BY traffic_source
    )
SELECT
    traffic_source,
    stage_1_views,
    ROUND( SAFE_DIVIDE( stage_1_views * 100, SUM(stage_1_views) OVER() )) AS pct_of_total_views,
    stage_2_cart,
    stage_3_checkout,
    stage_4_payment,
    stage_5_purchase,
    ROUND(SAFE_DIVIDE(stage_5_purchase * 100, stage_1_views)) AS overall_conversion_rate,
FROM source_funnel



