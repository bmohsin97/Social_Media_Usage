-- Calculate platform popularity segmented by user cluster
WITH user_clusters AS (
    SELECT
        user_id,
        app,
        CASE
            WHEN daily_minutes_spent >= 300 OR posts_per_day >= 15 THEN 'Power User'
            WHEN daily_minutes_spent BETWEEN 100 AND 299 OR posts_per_day BETWEEN 5 AND 14 THEN 'Active User'
            ELSE 'Casual User'
        END AS user_cluster
    FROM
        social_media_usage
)
SELECT
    app,
    user_cluster,
    COUNT(user_id) AS user_count
FROM
    user_clusters
GROUP BY
    app, user_cluster
ORDER BY
    app, user_cluster DESC;
