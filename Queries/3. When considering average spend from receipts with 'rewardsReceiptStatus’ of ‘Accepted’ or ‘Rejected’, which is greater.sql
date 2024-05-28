WITH filtered_receipts AS (
    SELECT
        rewardsReceiptStatus,
        totalSpent
    FROM
        receipts
    WHERE
        rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
),
average_spend AS (
    SELECT
        rewardsReceiptStatus,
        AVG(totalSpent) AS avg_spend
    FROM
        filtered_receipts
    GROUP BY
        rewardsReceiptStatus
)
SELECT
    rewardsReceiptStatus,
    avg_spend
FROM
    average_spend
ORDER BY
    avg_spend DESC
LIMIT 1;