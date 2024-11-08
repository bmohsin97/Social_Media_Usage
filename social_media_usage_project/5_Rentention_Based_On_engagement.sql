-- Estimation of user retention probability based on high engagement factors
SELECT
    user_id,
    app,
    CASE
        WHEN daily_minutes_spent >= 200 AND likes_per_day >= 50 THEN 'High Retention Likely'
        WHEN daily_minutes_spent BETWEEN 100 AND 199 AND likes_per_day BETWEEN 25 AND 49 THEN 'Moderate Retention Likely'
        ELSE 'Low Retention Likely'
    END AS retention_estimate
FROM
    social_media_usage;
