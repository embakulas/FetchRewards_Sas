WITH recent_months AS (
    SELECT
        date_trunc('month', MAX(dateScanned)) AS most_recent_month,
        date_trunc('month', MAX(dateScanned) - interval '1 month') AS previous_month
    FROM
        receipts
),
filtered_receipts AS (
    SELECT
        r._id AS receipt_id,
        r.dateScanned,
        date_trunc('month', r.dateScanned) AS month_scanned
    FROM
        receipts r
    JOIN
        recent_months rm
    ON
        date_trunc('month', r.dateScanned) = rm.most_recent_month
        OR date_trunc('month', r.dateScanned) = rm.previous_month
),
brand_receipts AS (
    SELECT
        ri.receipt_id,
        ribm._id AS brand_id,
        fr.month_scanned
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
        br.month_scanned,
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
        b._id, b.name, br.month_scanned
),
recent_month_top5 AS (
    SELECT
        brand_name,
        receipt_count,
        ROW_NUMBER() OVER (ORDER BY receipt_count DESC) AS rank
    FROM
        brand_counts
    WHERE
        month_scanned = (SELECT most_recent_month FROM recent_months)
    ORDER BY
        receipt_count DESC
    LIMIT 5
),
previous_month_top5 AS (
    SELECT
        brand_name,
        receipt_count,
        ROW_NUMBER() OVER (ORDER BY receipt_count DESC) AS rank
    FROM
        brand_counts
    WHERE
        month_scanned = (SELECT previous_month FROM recent_months)
    ORDER BY
        receipt_count DESC
    LIMIT 5
)
SELECT
    rm.brand_name AS recent_month_brand,
    rm.rank AS recent_month_rank,
    pm.brand_name AS previous_month_brand,
    pm.rank AS previous_month_rank
FROM
    recent_month_top5 rm
FULL OUTER JOIN
    previous_month_top5 pm
ON
    rm.brand_name = pm.brand_name
ORDER BY
    COALESCE(rm.rank, pm.rank);