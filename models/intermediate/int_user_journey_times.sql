WITH
    date_spine AS (
        SELECT DATE_SUB(MAX(event_timestamp), INTERVAL 30 DAY) AS date_cutoff
        FROM {{ ref( 'stg_user_events') }}
    ),

    user_journey AS (

        SELECT
            user_id,
            MIN(CASE WHEN event_type = 'page_view' THEN event_timestamp END) AS view_time,
            MIN(CASE WHEN event_type = 'add_to_cart' THEN event_timestamp END) AS cart_time,
            MIN(CASE WHEN event_type = 'checkout_start' THEN event_timestamp END) AS checkout_time,
            MIN(CASE WHEN event_type = 'payment_info' THEN event_timestamp END) AS payment_time,
            MIN(CASE WHEN event_type = 'purchase' THEN event_timestamp END)AS purchase_time

        FROM {{ ref('stg_user_events') }}

        WHERE
            event_timestamp >= (
                SELECT date_cutoff
                FROM date_spine
            )
        GROUP BY user_id
        HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_timestamp END) IS NOT NULL
    )

SELECT
    user_id,
   view_time,
   cart_time,
   checkout_time,
   payment_time,
   purchase_time
FROM user_journey