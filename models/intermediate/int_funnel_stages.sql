WITH
    date_spine AS (
        SELECT DATE_SUB(MAX(event_timestamp), INTERVAL 30 DAY) AS date_cutoff
        FROM {{ ref('stg_user_events') }}
    ),


    funnel_stages AS (
        SELECT
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
        WHERE
            event_timestamp >= (
                SELECT date_cutoff
                FROM date_spine )
    ),

    avg_purchase AS (
        SELECT ROUND(AVG(amount), 2) AS avg_purchase_amount
        FROM {{ ref('stg_user_events') }}
        WHERE event_type = 'purchase'
    )

SELECT
    stage_1_views,
    stage_2_cart,
    stage_3_checkout,
    stage_4_payment,
    stage_5_purchase,
    avg_purchase_amount
FROM funnel_stages, avg_purchase