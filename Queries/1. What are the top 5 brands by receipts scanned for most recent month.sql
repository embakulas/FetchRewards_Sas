WITH recent_month AS (
    SELECT
        date_trunc('month', MAX(dateScanned)) AS most_recent_month
    FROM
        receipts
),
filtered_receipts AS (
    SELECT
        r._id AS receipt_id,
        r.dateScanned
    FROM
        receipts r
    JOIN
        recent_month rm
    ON
        date_trunc('month', r.dateScanned) = rm.most_recent_month
),
brand_receipts AS (
    SELECT
        ri.receipt_id,
        ribm._id AS brand_id
    FROM
        filtered_receipts fr
    JOIN
        receiptItems ri
    ON
        fr.receipt_id = ri.receipt_id
    JOIN
        receipt_items_brands_mapping ribm
    ON
        ri.receipt_item_id = ribm.receipt_item_id
),
brand_counts AS (
    SELECT
        b._id AS brand_id,
        b.name AS brand_name,
        COUNT(br.receipt_id) AS receipt_count
    FROM
        brand_receipts br
    JOIN
        brands b
    ON
        br.brand_id = b._id
    WHERE
        b.name != 'Default Brand'  -- Exclude the default brand
    GROUP BY
        b._id, b.name
)
SELECT
    brand_name,
    receipt_count
FROM
    brand_counts
ORDER BY
    receipt_count DESC
LIMIT 5;