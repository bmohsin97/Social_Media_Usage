SELECT
    app,
    SUM(likes_per_day) / NULLIF(SUM(posts_per_day), 0) AS likes_per_post_ratio
FROM
    social_media_usage
GROUP BY
    app
ORDER BY
    likes_per_post_ratio DESC;
