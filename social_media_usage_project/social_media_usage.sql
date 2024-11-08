-- Creating a table named `social_media_usage` to store social media usage metrics for each user
CREATE TABLE social_media_usage (
    user_id VARCHAR(50) PRIMARY KEY,      -- Unique identifier for each user, using VARCHAR for flexibility
    app VARCHAR(50),                      -- The social media platform's name (e.g., Facebook, Instagram)
    daily_minutes_spent INT,              -- Total minutes the user spends on the app daily
    posts_per_day INT,                    -- Average number of posts the user makes per day
    likes_per_day INT,                    -- Average number of likes the user gives per day
    follows_per_day INT                   -- Average number of follows the user initiates per day
);

-- Using the COPY command to load data from the CSV file into the `social_media_usage` table
COPY social_media_usage(user_id, app, daily_minutes_spent, posts_per_day, likes_per_day, follows_per_day) 
FROM '/Users/brianmohsin/Desktop/Social_Media_Usage/social_media_usage.csv'              
DELIMITER ','                                     
CSV HEADER;                                         

