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
brand_transactions AS (
    SELECT
        b._id AS brand_id,
        b.name AS brand_name,
        COUNT(rib.receipt_id) AS transaction_count
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
)
SELECT
    brand_name,
    transaction_count
FROM
    brand_transactions
ORDER BY
    transaction_count DESC
LIMIT 100;
