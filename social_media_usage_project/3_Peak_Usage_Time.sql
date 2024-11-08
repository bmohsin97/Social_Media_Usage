-- Assuming hypothetical thresholds of daily_minutes_spent >=180 for peak engagement analysis
SELECT
    app,
    COUNT(user_id) AS highly_active_users
FROM
    social_media_usage
WHERE
    daily_minutes_spent >= 180
GROUP BY
    app
ORDER BY
    highly_active_users DESC;
