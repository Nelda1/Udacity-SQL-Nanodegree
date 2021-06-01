--The columns "upvote" and "downvote" would have been better as integers as opposed to text
--No other constraints defined other than primary keys for both tables. Would be ideal to add unique constraints for some of the columns like "username" and also foregin key constraints
--Both tables contain lots of text and querying text can sometimes be very slow, adding indexes would make it quiet easy to query data.
--Quite unrealistic for a url to be 4000 characters long. Longest was about <2500 ever recorded.
--Duplicated rows for columns "upvote" & "downvote" in the table "bad_posts". Data needs to be normalized.

--PART II
--1a)
CREATE TABLE "users" (
    "id" serial PRIMARY KEY,
    "username" VARCHAR(25) UNIQUE NOT NULL CHECK(LENGTH(TRIM("username")) > 0),
    "last_login" TIMESTAMP
);

CREATE INDEX "find_user" ON "users" ("username");

--1b)
CREATE TABLE "topics" (
    "id" SERIAL PRIMARY KEY,
    "topic_name" VARCHAR(30) UNIQUE NOT NULL CHECK(LENGTH(TRIM("topic_name")) > 0),
    "description" VARCHAR(500)
);
CREATE INDEX "find_topic" ON "topics" ("topic_name");

--1c)
CREATE TABLE "posts" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
    "topic_id" INTEGER REFERENCES "topics" ON DELETE CASCADE,
    "title" VARCHAR(100) NOT NULL CHECK(LENGTH(TRIM("title")) > 0),
    "url" VARCHAR(2500),
    "text_content" VARCHAR,
    "last_post" TIMESTAMP
);

ALTER table "posts" ADD CONSTRAINT "either_url_or_text" CHECK((("url") is null and ("text_content") is not null) or (("url") is not null and ("text_content") is null)
);
CREATE INDEX "find_url" ON "posts" ("url");

--1d)
CREATE TABLE "comments" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
    "post_id" INTEGER REFERENCES "posts" ON DELETE CASCADE,
    "text_content" VARCHAR NOT NULL CHECK(LENGTH(TRIM("text_content")) > 0),
    "parent_comment_id" INTEGER,
    "date_commented" TIMESTAMP
);

ALTER TABLE "comments" ADD CONSTRAINT "parent_child_thread" FOREIGN KEY("parent_comment_id") REFERENCES "comments" ("id") ON DELETE CASCADE;

--1e)
CREATE TABLE "votes" (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER REFERENCES "users" ON DELETE SET NULL,
    "post_id" INTEGER REFERENCES "posts" ON DELETE CASCADE,
    "vote" SMALLINT CHECK(vote = 1 or vote =-1)
);

ALTER TABLE "votes" ADD UNIQUE ("user_id", "post_id");
CREATE INDEX "score" ON "votes" ("post_id");
