SELECT
    stage_1_views,
    stage_2_cart,
    ROUND(SAFE_DIVIDE(stage_2_cart * 100, stage_1_views)) AS view_to_cart_rate,
    stage_3_checkout,
    ROUND(SAFE_DIVIDE(stage_3_checkout * 100, stage_2_cart)) AS cart_to_checkout_rate,
    stage_4_payment,
    ROUND(SAFE_DIVIDE(stage_4_payment * 100, stage_3_checkout)) AS checkout_to_payment_rate,
    stage_5_purchase,
    ROUND(SAFE_DIVIDE(stage_5_purchase * 100, stage_4_payment)) AS payment_to_purchase_rate,
    ROUND(SAFE_DIVIDE(stage_5_purchase * 100, stage_1_views)) AS overall_conversion_rate,

    ROUND(((stage_1_views - stage_2_cart) * avg_purchase_amount), 2) AS potential_lost_revenue_at_cart,
    ROUND(((stage_2_cart - stage_3_checkout) * avg_purchase_amount), 2) AS potential_lost_revenue_at_checkout,
    ROUND(((stage_3_checkout - stage_4_payment) * avg_purchase_amount), 2) AS potential_lost_revenue_at_payment,
    ROUND(((stage_4_payment - stage_5_purchase) * avg_purchase_amount), 2) AS potential_lost_revenue_at_purchase,

    ROUND(((stage_1_views - stage_5_purchase) * avg_purchase_amount), 2) AS total_potential_lost_revenue
FROM {{ ref('int_funnel_stages') }}
