SELECT
    ROUND( AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE))) AS avg_view_to_cart_minutes,
    ROUND( AVG(TIMESTAMP_DIFF(checkout_time, cart_time, MINUTE))) AS avg_cart_to_checkout_minutes,
    ROUND( AVG(TIMESTAMP_DIFF(payment_time, checkout_time, MINUTE))) AS avg_checkout_to_payment_minutes,
    ROUND( AVG(TIMESTAMP_DIFF(purchase_time, payment_time, MINUTE))) AS avg_payment_to_purchase_minutes,
    ROUND( AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE))) AS avg_total_journey_minutes

FROM {{ ref('int_user_journey_times') }}
