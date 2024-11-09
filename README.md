# 📊 Social Media Usage Analysis – A Data Dive!

Welcome! This project dives into social media usage metrics, exploring user engagement patterns, platform efficiency, and high-energy user activity. With SQL queries and a dash of data enthusiasm, this analysis uncovers the hidden stories in the metrics!

# 🔍 Project Overview
This analysis answers key questions about social media engagement:

Who’s a Power User? – those who spend the most time and post frequently.
Which platform has the best engagement rate? – think likes per post!
Where are the high-activity users? – platforms with the highest concentration of engaged users.
Let’s jump in and get to know the dataset!

# 📄 Dataset
This dataset contains daily engagement metrics for users on popular social media platforms. Here’s a quick rundown of the columns:

user_id: Unique identifier for each user.
app: The platform they’re using (e.g., Instagram, TikTok).
daily_minutes_spent: Time spent daily on the platform.
posts_per_day: Average posts per day.
likes_per_day: Number of likes given per day.
follows_per_day: Number of new follows each day.
# 🎯 Analysis Goals
Here’s what this project aims to achieve:

User Engagement Clustering: Segmenting users by engagement levels.
Engagement Efficiency: Analyzing the ratio of likes per post by platform.
Highly Active Users: Counting top users on each platform based on time spent.
Engagement Outliers Detection: Identifying users with exceptionally high engagement metrics.
Retention Probability Estimation: Estimating user retention likelihood based on engagement.
Platform Popularity by User Cluster: Analyzing platform popularity segmented by user cluster.
Engagement Elasticity: Calculating engagement per hour for likes and follows.
# ⚙️ Queries and Insights
## 1. User Engagement Clustering
Segmenting users into categories—Power User, Active User, Casual User—based on daily engagement.

```sql
Copy code
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
```
![output](https://github.com/user-attachments/assets/763cbca0-90b3-4d36-b74b-4338f58381eb)



## 2. Engagement Efficiency (Likes per Post)
Calculating which platform has the most likes per post—a key indicator of platform engagement.
```
sql
Copy code
SELECT
    app,
    SUM(likes_per_day) / NULLIF(SUM(posts_per_day), 0) AS likes_per_post_ratio
FROM
    social_media_usage
GROUP BY
    app
ORDER BY
    likes_per_post_ratio DESC;
```
![output (1)](https://github.com/user-attachments/assets/3b84b4cc-6c67-426e-8165-af59bacbb523)



## 3. Highly Active Users by Platform
Identifying the number of high-activity users for each platform.

```sql
Copy code
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
```
![output (2)](https://github.com/user-attachments/assets/d4c1b157-c200-437a-ac98-aee843754f57)



## 4. Engagement Outliers Detection
Identifying users with exceptionally high engagement metrics based on posts, likes, and follows per day.

```sql
Copy code
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
```
![output (3)](https://github.com/user-attachments/assets/a90d5203-9930-4832-9516-7be6aa38f652)



## 5. Retention Probability Estimation
Estimating user retention likelihood based on high engagement factors.

```sql
Copy code
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
```
![output (4)](https://github.com/user-attachments/assets/d0072c1f-b9a5-4eb6-882b-cd807aecd1ad)



## 6. Platform Popularity by User Cluster
Analyzing platform popularity segmented by user cluster.

```sql
Copy code
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
```
![output (5)](https://github.com/user-attachments/assets/8a2e290c-84bf-4432-94f7-a62fcef77d7b)



## 7. Engagement Elasticity
Calculating likes and follows per hour to understand how responsive users are to increased time spent.

```sql
Copy code
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
```
![output (6)](https://github.com/user-attachments/assets/abab43cf-7dbd-4ca6-a08d-d4e7fd282121)



# 📝 Conclusion
This project reveals fascinating insights into social media engagement:

Power Users and Active Users tend to be most prevalent on Instagram and TikTok.
Platforms like TikTok and Instagram drive higher engagement efficiency, with more likes per post.
Highly Active Users are concentrated on platforms that support frequent interaction and content sharing.
With this analysis, we get a better sense of where users are most engaged and which platforms are effectively driving interactions. Thanks for taking a look—exploring data can be fun, and there’s always more to uncover!
