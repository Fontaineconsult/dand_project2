-- CREATE OR REPLACE TABLE ODS."Yelp_Business_Hours" (
--                                                       "id" NUMBER AUTOINCREMENT start 1 increment 1,
--                                                       "business_id" string(22),
--                                                       "monday" string,
--                                                       "tuesday" string,
--                                                       "wednesday" string,
--                                                       "thursday" string,
--                                                       "friday" string,
--                                                       "saturday" string,
--                                                       "sunday" string
-- );
--
--
-- insert into ODS."Yelp_Business_Hours" ("business_id", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday")
-- select BUSINESS_JSON:business_id, BUSINESS_JSON:hours:Monday, BUSINESS_JSON:hours:Tuesday, BUSINESS_JSON:hours:Wednesday, BUSINESS_JSON:hours:Thursday, BUSINESS_JSON:hours:Friday, BUSINESS_JSON:hours:Saturday, BUSINESS_JSON:hours:Sunday
-- from "business_json";





CREATE TABLE "Yelp_User" (
                             "user_id" string(22),
                             "name" string,
                             "review_count" integer,
                             "yelping_since" string,
                             "text" string,
                             "useful" integer,
                             "funny" integer,
                             "cool" integer,
                             "fans" integer,
                             "average_stars" integer,
                             "compliment_hot" integer,
                             "compliment_more" integer,
                             "compliment_profile" integer,
                             "compliment_cute" integer,
                             "compliment_list" integer,
                             "compliment_note" integer,
                             "compliment_plain" integer,
                             "compliment_cool" integer,
                             "compliment_funny" integer,
                             "compliment_writer" integer,
                             "compliment_photos" integer
);


CREATE TABLE "Yelp_Years_Elite" (
                            "id" integer,
                            "user_id" string(22),
                            "year" integer
);

CREATE TABLE "Yelp_Friends_List" (
                             "friend_id" string(22),
                             "user_id" string(22)
);


CREATE TABLE "Yelp_Business_Categories_List" (
                            "category_id" string,
                            "business_id" string(22)
);


CREATE SEQUENCE business_category_id_sequence
    START WITH 1
    INCREMENT BY 1
    COMMENT = 'Positive Sequence';


CREATE TABLE "Yelp_Business_Categories" (
                            "id" serial primary key,
                            "name" string
);





CREATE TABLE "Yelp_Business" (
                             "business_id" string(22),
                             "name" string,
                             "address" string,
                             "city" string,
                             "state" string(2),
                             "postal_code" string(5),
                             "latitude" float,
                             "longitude" float,
                             "stars" float,
                             "review_count" integer,
                             "is_open" integer,
                             "hours" integer

);

CREATE TABLE "Yelp_Review" (
                               "review_id" string(22),
                               "user_id" string(22),
                               "business_id" string(22),
                               "stars" integer,
                               "date" date,
                               "text" string,
                               "useful" integer,
                               "funny" integer,
                               "cool" integer
);

CREATE TABLE "Yelp_Checkin" (
                                "business_id" string(22),
                                "date" date
);

CREATE TABLE "Yelp_Tip" (
                            "text" string,
                            "date" string,
                            "compliment_count" integer,
                            "business_id" string(22),
                            "user_id" string(22)
);

CREATE TABLE "Yelp_Photo" (
                              "photo_id" string(22),
                              "business_id" string(22),
                              "caption" string,
                              "label" string
);

