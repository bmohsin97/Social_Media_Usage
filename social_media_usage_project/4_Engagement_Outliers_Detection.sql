/*
Identify outliers based on high engagement metrics (e.g., posts, likes, follows)
*/
-- Calculate average and standard deviation for posts, likes, and follows
WITH stats AS (
    SELECT
        AVG(posts_per_day) AS avg_posts,
        STDDEV(posts_per_day) AS stddev_posts,
        AVG(likes_per_day) AS avg_likes,
        STDDEV(likes_per_day) AS stddev_likes,
        AVG(follows_per_day) AS avg_follows,
        STDDEV(follows_per_day) AS stddev_follows
    FROM
        social_media_usage
)
SELECT
    smu.user_id,
    smu.app,
    smu.posts_per_day,
    smu.likes_per_day,
    smu.follows_per_day,
    -- Flag each user who is an outlier in each category
    CASE WHEN smu.posts_per_day > (stats.avg_posts + 2 * stats.stddev_posts) THEN 'Outlier' ELSE 'Normal' END AS post_outlier,
    CASE WHEN smu.likes_per_day > (stats.avg_likes + 2 * stats.stddev_likes) THEN 'Outlier' ELSE 'Normal' END AS like_outlier,
    CASE WHEN smu.follows_per_day > (stats.avg_follows + 2 * stats.stddev_follows) THEN 'Outlier' ELSE 'Normal' END AS follow_outlier
FROM
    social_media_usage smu
JOIN
    stats ON 1=1
WHERE
    smu.posts_per_day > (stats.avg_posts + 2 * stats.stddev_posts)
    OR 
    smu.likes_per_day > (stats.avg_likes + 2 * stats.stddev_likes)
    OR 
    smu.follows_per_day > (stats.avg_follows + 2 * stats.stddev_follows);


-- Adjust the threshold to one standard deviation
WITH stats AS (
    SELECT
        AVG(posts_per_day) AS avg_posts,
        STDDEV(posts_per_day) AS stddev_posts,
        AVG(likes_per_day) AS avg_likes,
        STDDEV(likes_per_day) AS stddev_likes,
        AVG(follows_per_day) AS avg_follows,
        STDDEV(follows_per_day) AS stddev_follows
    FROM
        social_media_usage
)
SELECT
    smu.user_id,
    smu.app,
    smu.posts_per_day,
    smu.likes_per_day,
    smu.follows_per_day
FROM
    social_media_usage smu
JOIN
    stats ON 1=1
WHERE
    smu.posts_per_day > (stats.avg_posts + stats.stddev_posts)
    OR 
    smu.likes_per_day > (stats.avg_likes + stats.stddev_likes)
    OR 
    smu.follows_per_day > (stats.avg_follows + stats.stddev_follows);

