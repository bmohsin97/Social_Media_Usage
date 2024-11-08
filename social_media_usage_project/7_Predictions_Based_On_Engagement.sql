-- Calculate engagement elasticity (percent change in likes and follows per unit time)
SELECT
    app,
    ROUND(SUM(likes_per_day) / NULLIF(SUM(daily_minutes_spent) / 60, 0), 2) AS likes_per_hour,
    ROUND(SUM(follows_per_day) / NULLIF(SUM(daily_minutes_spent) / 60, 0), 2) AS follows_per_hour
FROM
    social_media_usage
GROUP BY
    app
ORDER BY
    likes_per_hour DESC, follows_per_hour DESC;

