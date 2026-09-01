SELECT 'page_view' AS stage_name, 1 AS stage_order, stage_1_views AS users
FROM {{ ref('int_funnel_stages') }}

UNION ALL

SELECT 'add_to_cart', 2, stage_2_cart
FROM {{ ref('int_funnel_stages') }}

UNION ALL

SELECT 'checkout_start', 3, stage_3_checkout
FROM {{ ref('int_funnel_stages') }}

UNION ALL

SELECT 'payment_info', 4, stage_4_payment
FROM {{ ref('int_funnel_stages') }}

UNION ALL

SELECT 'purchase', 5, stage_5_purchase
FROM {{ ref('int_funnel_stages') }}