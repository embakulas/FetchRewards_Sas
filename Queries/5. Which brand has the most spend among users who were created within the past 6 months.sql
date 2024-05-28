WITH recent_users AS (
    SELECT
        _id AS user_id
    FROM
        users
    WHERE
        createdDate >= '2020-09-01' AND createdDate <= '2021-03-01'
),
user_receipts AS (
    SELECT
        r._id AS receipt_id,
        r.totalSpent,
        ru.user_id
    FROM
        receipts r
    JOIN
        recent_users ru
    ON
        r.user_id = ru.user_id
),
receipt_items_brands AS (
    SELECT
        ur.receipt_id,
        ur.totalSpent,
        ribm._id AS brand_id
    FROM
        user_receipts ur
    JOIN
        receiptItems ri
    ON
        ur.receipt_id = ri.receipt_id
    JOIN
        receipt_items_brands_mapping ribm
    ON
        ri.receipt_item_id = ribm.receipt_item_id
),
brand_spend AS (
    SELECT
        b._id AS brand_id,
        b.name AS brand_name,
        SUM(rib.totalSpent) AS total_spend
    FROM
        receipt_items_brands rib
    JOIN
        brands b
    ON
        rib.brand_id = b._id
    WHERE
        b.name != 'Default Brand'  -- Exclude the default brand
    GROUP BY
        b._id, b.name
),
max_total_spend AS (
    SELECT
        MAX(total_spend) AS max_spend
    FROM
        brand_spend
)
SELECT
    brand_name,
    total_spend
FROM
    brand_spend
WHERE
    total_spend = (SELECT max_spend FROM max_total_spend)
ORDER BY
    brand_name;
