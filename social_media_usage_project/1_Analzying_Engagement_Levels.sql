-- Define user engagement clusters based on usage statistics
SELECT
    user_id,
    app,
    daily_minutes_spent,
    posts_per_day,
    likes_per_day,
    follows_per_day,
    CASE
        WHEN daily_minutes_spent >= 300 OR posts_per_day >= 15 THEN 'Power User'
        WHEN daily_minutes_spent BETWEEN 100 AND 299 OR posts_per_day BETWEEN 5 AND 14 THEN 'Active User'
        ELSE 'Casual User'
    END AS user_cluster
FROM
    social_media_usage;
