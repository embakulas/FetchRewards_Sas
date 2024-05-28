WITH filtered_receipts AS (
    SELECT
        rewardsReceiptStatus,
        purchasedItemCount
    FROM
        receipts
    WHERE
        rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
),
total_items AS (
    SELECT
        rewardsReceiptStatus,
        SUM(purchasedItemCount) AS total_items_purchased
    FROM
        filtered_receipts
    GROUP BY
        rewardsReceiptStatus
)
SELECT
    rewardsReceiptStatus,
    total_items_purchased
FROM
    total_items
ORDER BY
    total_items_purchased DESC
LIMIT 1;
