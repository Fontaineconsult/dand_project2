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




-- CREATE TABLE ODS."Yelp_User" ( "user_id" string(22),"name" string, "review_count" integer, "yelping_since" string, "useful" integer, "funny" integer, "cool" integer, "fans" integer, "average_stars" integer, "compliment_hot" integer, "compliment_more" integer, "compliment_profile" integer, "compliment_cute" integer, "compliment_list" integer, "compliment_note" integer, "compliment_plain" integer, "compliment_cool" integer, "compliment_funny" integer, "compliment_writer" integer, "compliment_photos" integer);
-- INSERT INTO ODS."Yelp_User" ( "user_id", "name", "review_count", "yelping_since", "useful", "funny","cool", "fans", "average_stars", "compliment_hot", "compliment_more", "compliment_profile", "compliment_cute", "compliment_list", "compliment_note", "compliment_plain", "compliment_cool", "compliment_funny", "compliment_writer", "compliment_photos")
-- select YELP_USER_JSON:user_id, YELP_USER_JSON:name, YELP_USER_JSON:review_count, YELP_USER_JSON:yelping_since, YELP_USER_JSON:useful, YELP_USER_JSON:funny, YELP_USER_JSON:cool, YELP_USER_JSON:fans, YELP_USER_JSON:average_stars, YELP_USER_JSON:compliment_hot, YELP_USER_JSON:compliment_more, YELP_USER_JSON:compliment_profile, YELP_USER_JSON:compliment_cute, YELP_USER_JSON:compliment_list, YELP_USER_JSON:compliment_note, YELP_USER_JSON:compliment_plain, YELP_USER_JSON:compliment_cool, YELP_USER_JSON:compliment_funny, YELP_USER_JSON:compliment_writer, YELP_USER_JSON:compliment_photos
-- from STAGING."yelp_user_json";




-- CREATE OR REPLACE TABLE ODS."Yelp_Years_Elite" (
--                                                    "user_id" string(22),
--                                                    "year" string,
--                                                    PRIMARY KEY ("user_id", "year")
-- );
--
-- insert into ODS."Yelp_Years_Elite" ("user_id", "year")
-- select YELP_USER_JSON:user_id::string as user_id,
--        value as year
-- from
--     "STAGING"."yelp_user_json"
--    , lateral flatten( input => to_array(SPLIT(YELP_USER_JSON:elite, ',')) );


-- CREATE OR REPLACE TABLE ODS."Yelp_Friends_List" (
--                                                     "user_id" string(23),
--                                                     "friend_id" string(23),
--                                                     PRIMARY KEY ("user_id", "friend_id")
--
-- );
--
-- insert into ODS."Yelp_Friends_List" ("user_id", "friend_id")
-- select YELP_USER_JSON:user_id::string as user_id,
--        LTRIM(value) as friend_id
-- from
--     "STAGING"."yelp_user_json"
--    , lateral flatten( input => to_array(SPLIT(YELP_USER_JSON:friends, ',')));



-- CREATE OR REPLACE TABLE ODS."Yelp_Business_Categories_List" (
--                                                                 "id" NUMBER AUTOINCREMENT start 1 increment 1,
--                                                                 "category_name" string
-- );

-- insert into ODS."Yelp_Business_Categories_List" ("category_name")
-- select  distinct
--     LTRIM(value) as friend_id
-- from
--     "STAGING"."business_json"
--    , lateral flatten( input => to_array(SPLIT(BUSINESS_JSON:categories, ',')));
--
--
--
--
-- CREATE TABLE "Yelp_Business_Categories" (
--                             "id" serial primary key,
--                             "name" string
-- );
--




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

