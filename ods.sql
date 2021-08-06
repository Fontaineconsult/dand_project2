--- This code moves data from the staging tables into the ODS


--Business Hours--

CREATE OR REPLACE TABLE ODS."Yelp_Business_Hours" (
                  "id" NUMBER AUTOINCREMENT start 1 increment 1,
                  "business_id" string(22),
                  "monday" string,
                  "tuesday" string,
                  "wednesday" string,
                  "thursday" string,
                  "friday" string,
                  "saturday" string,
                  "sunday" string

);


insert into ODS."Yelp_Business_Hours" ("business_id", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday")
select BUSINESS_JSON:business_id, BUSINESS_JSON:hours:Monday, BUSINESS_JSON:hours:Tuesday, BUSINESS_JSON:hours:Wednesday, BUSINESS_JSON:hours:Thursday, BUSINESS_JSON:hours:Friday, BUSINESS_JSON:hours:Saturday, BUSINESS_JSON:hours:Sunday
from STAGING."business_json";


--Yelp_Users--

CREATE TABLE ODS."Yelp_User" ( "user_id" string(22),"name" string, "review_count" integer, "yelping_since" string, "useful" integer, "funny" integer, "cool" integer, "fans" integer, "average_stars" integer, "compliment_hot" integer, "compliment_more" integer, "compliment_profile" integer, "compliment_cute" integer, "compliment_list" integer, "compliment_note" integer, "compliment_plain" integer, "compliment_cool" integer, "compliment_funny" integer, "compliment_writer" integer, "compliment_photos" integer, PRIMARY KEY ("user_id"));
INSERT INTO ODS."Yelp_User" ( "user_id", "name", "review_count", "yelping_since", "useful", "funny","cool", "fans", "average_stars", "compliment_hot", "compliment_more", "compliment_profile", "compliment_cute", "compliment_list", "compliment_note", "compliment_plain", "compliment_cool", "compliment_funny", "compliment_writer", "compliment_photos")
select YELP_USER_JSON:user_id, YELP_USER_JSON:name, YELP_USER_JSON:review_count, YELP_USER_JSON:yelping_since, YELP_USER_JSON:useful, YELP_USER_JSON:funny, YELP_USER_JSON:cool, YELP_USER_JSON:fans, YELP_USER_JSON:average_stars, YELP_USER_JSON:compliment_hot, YELP_USER_JSON:compliment_more, YELP_USER_JSON:compliment_profile, YELP_USER_JSON:compliment_cute, YELP_USER_JSON:compliment_list, YELP_USER_JSON:compliment_note, YELP_USER_JSON:compliment_plain, YELP_USER_JSON:compliment_cool, YELP_USER_JSON:compliment_funny, YELP_USER_JSON:compliment_writer, YELP_USER_JSON:compliment_photos
from STAGING."yelp_user_json";



--Yelp_Years_Elite--
CREATE OR REPLACE TABLE ODS."Yelp_Years_Elite" (
                   "user_id" string(22),
                   "year" string,
                   PRIMARY KEY ("user_id", "year")
);

insert into ODS."Yelp_Years_Elite" ("user_id", "year")
select YELP_USER_JSON:user_id::string as user_id,
       value as year
from
    "STAGING"."yelp_user_json"
   , lateral flatten( input => to_array(SPLIT(YELP_USER_JSON:elite, ',')) );



--Yelp_Friends_List--

CREATE OR REPLACE TABLE ODS."Yelp_Friends_List" (
                    "user_id" string(23),
                    "friend_id" string(23),
                    PRIMARY KEY ("user_id", "friend_id")

);

insert into ODS."Yelp_Friends_List" ("user_id", "friend_id")
select YELP_USER_JSON:user_id::string as user_id,
       LTRIM(value) as friend_id
from
    "STAGING"."yelp_user_json"
   , lateral flatten( input => to_array(SPLIT(YELP_USER_JSON:friends, ',')));



--Yelp_Business_Categories_List--

CREATE OR REPLACE TABLE ODS."Yelp_Business_Categories_List" (
            "id"  NUMBER AUTOINCREMENT start 1 increment 1,
            "category_name" string,
            primary key ("id")
);

insert into ODS."Yelp_Business_Categories_List" ("category_name")
select  distinct
    LTRIM(value) as category_name
from
    "STAGING"."business_json"
   , lateral flatten( input => to_array(SPLIT(BUSINESS_JSON:categories, ',')));


--Yelp_Business_Categories_Assignments--

CREATE OR REPLACE TABLE ODS."Yelp_Business_Categories_Assignments"
(
    category_id integer references ODS."Yelp_Business_Categories_List" ("id"),
    business_id string(22) references ODS."Yelp_Business" ("business_id")
);


INSERT INTO ODS."Yelp_Business_Categories_Assignments" ("CATEGORY_ID", "BUSINESS_ID")
SELECT ODS."Yelp_Business_Categories_List"."id", a.business_id
FROM ODS."Yelp_Business_Categories_List"
         LEFT JOIN
     (select
          BUSINESS_JSON:business_id as business_id,
          LTRIM(value) as category_name
      from
          "STAGING"."business_json"
         , lateral flatten( input => to_array(SPLIT(BUSINESS_JSON:categories, ',')))) as a
     ON ODS."Yelp_Business_Categories_List"."category_name" = a.category_name;


--Yelp_Business--

CREATE OR REPLACE TABLE ODS."Yelp_Business" ("business_id" string(22) PRIMARY KEY,
                                             "name" string,
                                              "address" string,
                                               "city" string,
                                                "state" string,
                                                 "postal_code" string,
                                                  "latitude" float,
                                                   "longitude" float,
                                                    "stars" float,
                                                     "review_count" integer,
                                                     "is_open" integer
);
INSERT INTO ODS."Yelp_Business" ("business_id", "name", "address", "city", "state", "postal_code", "latitude", "longitude", "stars", "review_count", "is_open"                               )
SELECT LTRIM(BUSINESS_JSON:business_id), BUSINESS_JSON:name, BUSINESS_JSON:address, BUSINESS_JSON:city, BUSINESS_JSON:state, BUSINESS_JSON:postal_code, BUSINESS_JSON:latitude, BUSINESS_JSON:longitude, BUSINESS_JSON:stars, BUSINESS_JSON:review_count, BUSINESS_JSON:is_open
FROM STAGING."business_json";

CREATE OR REPLACE TABLE ODS."Yelp_Review" (
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

--Yelp_Review--

INSERT INTO ODS."Yelp_Review" ("review_id", "user_id", "business_id", "stars", "date", "text", "useful", "funny", "cool")
SELECT LTRIM(YELP_REVIEW_JSON:review_id), LTRIM(YELP_REVIEW_JSON:user_id), LTRIM(YELP_REVIEW_JSON:business_id), YELP_REVIEW_JSON:stars, YELP_REVIEW_JSON:date, YELP_REVIEW_JSON:text, YELP_REVIEW_JSON:useful, YELP_REVIEW_JSON:funny, YELP_REVIEW_JSON:cool
FROM STAGING."yelp_review_json";

CREATE OR REPLACE TABLE ODS."Yelp_Checkin" (
                                               "business_id" string(22),
                                               "date" string
);

insert into ODS."Yelp_Checkin" ("business_id", "date")
select
    CHECKIN_JSON:business_id,
    LTRIM(value) as date
from
    "STAGING"."yelp_checkin_json"
   , lateral flatten( input => to_array(SPLIT(CHECKIN_JSON:date, ',')));

--Yelp_Tip--

CREATE OR REPLACE TABLE ODS."Yelp_Tip" (
                                           "text" string,
                                           "date" string,
                                           "compliment_count" integer,
                                           "business_id" string(22),
                                           "user_id" string(22)
);
INSERT INTO ODS."Yelp_Tip" ("text", "date", "compliment_count", "business_id", "user_id")
SELECT YELP_TIP_JSON:text, YELP_TIP_JSON:date, YELP_TIP_JSON:compliment_count, YELP_TIP_JSON:business_id, YELP_TIP_JSON:user_id
FROM STAGING."yelp_tip_json";

--Yelp_Photo--

CREATE OR REPLACE TABLE ODS."Yelp_Photo" (
                                             "photo_id" string(22),
                                             "business_id" string(22) references ODS."Yelp_Business" ("business_id"),
                                             "caption" string,
                                             "label" string

);
INSERT INTO ODS."Yelp_Photo"("photo_id", "business_id", "caption", "label")
SELECT  YELP_PHOTOS_JSON:photo_id, YELP_PHOTOS_JSON:business_id, YELP_PHOTOS_JSON:caption, YELP_PHOTOS_JSON:label
FROM STAGING."yelp_photos_json";


--Weather_Precipitation--

CREATE OR REPLACE TABLE ODS."Weather_Precipitation" (Date integer, Precipitation integer, Precipitation_Normal integer);
INSERT INTO ODS."Weather_Precipitation" ("DATE", "PRECIPITATION", "PRECIPITATION_NORMAL")
SELECT DATE, PRECIPITATION, PRECIPITATION_NORMAL
FROM STAGING."precipitation_csv";


--Weather_Temperature--

CREATE OR REPLACE TABLE ODS."Weather_Temperature" (Date integer, min integer, max integer, Normal_Min float, Normal_Max float);
INSERT INTO ODS."Weather_Temperature" ("DATE", "MIN", "MAX", "NORMAL_MIN", "NORMAL_MAX")
SELECT  DATE, MIN, MAX, NORMAL_MIN, NORMAL_MAX
FROM STAGING."temperature_csv";

CREATE OR REPLACE TABLE ODS."Yelp_Covid" (
                                             "call_to_action_enabled" boolean,
                                             "covid_banner" string,
                                             "grubhub_enabled" string,
                                             "request_a_quote_enabled" string,
                                             "temporary_closed_until" string,
                                             "virtual_services_offered" string,
                                             "business_id" string references ODS."Yelp_Business" ("business_id"),
                                             "delivery_or_takeout" string,
                                             "highlights" string,
                                              primary key ("business_id")
);


--Yelp_Covid--

INSERT INTO ODS."Yelp_Covid"("call_to_action_enabled", "covid_banner", "grubhub_enabled", "request_a_quote_enabled", "temporary_closed_until", "virtual_services_offered", "business_id", "delivery_or_takeout", "highlights")
select YELP_COVID_JSON:"Call To Action enabled", YELP_COVID_JSON:"Covid Banner",YELP_COVID_JSON:"Grubhub enabled", YELP_COVID_JSON:"Request a Quote Enabled", YELP_COVID_JSON:"Temporary Closed Until", YELP_COVID_JSON:"Virtual Services Offered", YELP_COVID_JSON:"business_id", YELP_COVID_JSON:"delivery or takeout", YELP_COVID_JSON:"highlights"
FROM STAGING."yelp_covid_json"
