---This code moves data from the ODS to the DHW


---DWH Fact Table---

CREATE OR REPLACE TABLE DWH."Yelp_Checkin_Facts"
(
    "id"                   NUMBER AUTOINCREMENT start 1 increment 1,
    "business_id"          STRING,
    "checkin_date"         date,
    "stars"                DOUBLE,
    "precipitation"        float,
    "PRECIPITATION_NORMAL" float,
    "max_temp"             NUMBER,
    "min_temp"             NUMBER,
    "normal_max_temp"      NUMBER,
    "normal_min_temp"      NUMBER,
    "temp_closed"          STRING,
    primary key ("id")
);



INSERT INTO DWH."Yelp_Checkin_Facts" ("business_id",
                                      "checkin_date",
                                      "stars", "precipitation",
                                      PRECIPITATION_NORMAL,
                                      "max_temp",
                                      "min_temp",
                                      "normal_max_temp",
                                      "normal_min_temp",
                                      "temp_closed")
select ODS."Yelp_Checkin"."business_id",
       TO_Date(ODS."Yelp_Checkin"."date"),
       ODS."Yelp_Business"."stars",
       ODS."Weather_Precipitation".PRECIPITATION as rain,
       ODS."Weather_Precipitation".PRECIPITATION_NORMAL,
       ODS."Weather_Temperature"."MAX"           as max_temp,
       ODS."Weather_Temperature"."MIN"           as min_temp,
       ODS."Weather_Temperature".NORMAL_MAX,
       ODS."Weather_Temperature".NORMAL_MIN,
       ODS."Yelp_Covid"."temporary_closed_until"
FROM ODS."Yelp_Checkin"
         INNER JOIN ODS."Yelp_Business" on ODS."Yelp_Checkin"."business_id" = ODS."Yelp_Business"."business_id"
         LEFT JOIN ODS."Weather_Precipitation" on REPLACE(TO_CHAR(TO_DATE(ODS."Yelp_Checkin"."date")), '' - '') =
                                                  TO_CHAR(ODS."Weather_Precipitation"."DATE")
         LEFT JOIN ODS."Weather_Temperature" on REPLACE(TO_CHAR(TO_DATE(ODS."Yelp_Checkin"."date")), '' - '') =
                                                TO_CHAR(ODS."Weather_Temperature"."DATE")
         LEFT JOIN ODS."Yelp_Covid" on ODS."Yelp_Checkin"."business_id" = ODS."Yelp_Covid"."business_id";


---Business Dim Table---

CREATE OR REPLACE TABLE DWH."Yelp_Business_Dim"
(
    "id"           NUMBER AUTOINCREMENT start 1 increment 1,
    "business_id"  string(22),
    "name"         string,
    "address"      string,
    "city"         string,
    "state"        string,
    "postal_code"  string,
    "latitude"     float,
    "longitude"    float,
    "stars"        float,
    "review_count" integer,
    "is_open"      integer,
    "hr_monday"    string,
    "hr_tuesday"   string,
    "hr_wednesday" string,
    "hr_thursday"  string,
    "hr_friday"    string,
    "hr_saturday"  string,
    "hr_sunday"    string,
    primary key ("id")

);
INSERT INTO DWH."Yelp_Business_Dim" ("business_id",
                                     "name",
                                     "address",
                                     "city",
                                     "state",
                                     "postal_code",
                                     "latitude",
                                     "longitude",
                                     "stars",
                                     "review_count",
                                     "is_open",
                                     "hr_monday",
                                     "hr_tuesday",
                                     "hr_wednesday",
                                     "hr_thursday",
                                     "hr_friday",
                                     "hr_saturday",
                                     "hr_sunday")
SELECT ODS."Yelp_Business"."business_id",
       ODS."Yelp_Business"."name",
       ODS."Yelp_Business"."address",
       ODS."Yelp_Business"."city",
       ODS."Yelp_Business"."state",
       ODS."Yelp_Business"."postal_code",
       ODS."Yelp_Business"."latitude",
       ODS."Yelp_Business"."longitude",
       ODS."Yelp_Business"."stars",
       ODS."Yelp_Business"."review_count",
       ODS."Yelp_Business"."is_open",
       ODS."Yelp_Business_Hours"."monday",
       ODS."Yelp_Business_Hours"."tuesday",
       ODS."Yelp_Business_Hours"."wednesday",
       ODS."Yelp_Business_Hours"."thursday",
       ODS."Yelp_Business_Hours"."friday",
       ODS."Yelp_Business_Hours"."saturday",
       ODS."Yelp_Business_Hours"."sunday"

from ODS."Yelp_Business"
         JOIN ODS."Yelp_Business_Hours" ON ODS."Yelp_Business"."business_id" = ODS."Yelp_Business_Hours"."business_id"

---Yelp Covid Dim---

CREATE OR REPLACE Table DWH."Yelp_Covid_Dim"
(
    "id"                     NUMBER AUTOINCREMENT start 1 increment 1,
    call_to_action_enabled   BOOLEAN,
    covid_banner             string,
    grubhub_enabled          string,
    request_a_quote_enabled  string,
    temporary_closed_until   string,
    virtual_services_offered string,
    business_id              string UNIQUE,
    delivery_or_takeout      string,
    highlights               string,
    primary key ("id")

);

INSERT INTO DWH."Yelp_Covid_Dim" (CALL_TO_ACTION_ENABLED,
                                  COVID_BANNER,
                                  GRUBHUB_ENABLED,
                                  REQUEST_A_QUOTE_ENABLED,
                                  TEMPORARY_CLOSED_UNTIL,
                                  VIRTUAL_SERVICES_OFFERED,
                                  BUSINESS_ID,
                                  DELIVERY_OR_TAKEOUT,
                                  HIGHLIGHTS)
SELECT ODS."Yelp_Covid"."call_to_action_enabled",
       ODS."Yelp_Covid"."covid_banner",
       ODS."Yelp_Covid"."grubhub_enabled",
       ODS."Yelp_Covid"."request_a_quote_enabled",
       ODS."Yelp_Covid"."temporary_closed_until",
       ODS."Yelp_Covid"."virtual_services_offered",
       ODS."Yelp_Covid"."business_id",
       ODS."Yelp_Covid"."delivery_or_takeout",
       ODS."Yelp_Covid"."highlights"
FROM ODS."Yelp_Covid";

---Yelp Bus Categories Dim---

CREATE OR REPLACE TABLE DWH."Business_Categories_Dim"
(
    "business_id"       string,
    "business_category" string

);

INSERT INTO DWH."Business_Categories_Dim" ("business_id", "business_category")
SELECT ODS."Yelp_Business_Categories_Assignments".BUSINESS_ID,
       ODS."Yelp_Business_Categories_List"."category_name"
FROM ODS."Yelp_Business_Categories_Assignments"
         JOIN ODS."Yelp_Business_Categories_List"
              on ODS."Yelp_Business_Categories_Assignments".CATEGORY_ID = ODS."Yelp_Business_Categories_List"."id"

---Business Review Dim---

CREATE OR REPLACE TABLE DWH."Business_Review_Dim"
(
    "id"          NUMBER AUTOINCREMENT start 1 increment 1,
    "review_id"   string,
    "user_id"     string,
    "business_id" string,
    "stars"       number,
    "date"        DATE,
    "text"        string,
    "useful"      number,
    "funny"       number,
    "cool"        number,
    primary key ("id")

);

INSERT INTO DWH."Business_Review_Dim" ("review_id",
                                       "user_id",
                                       "business_id",
                                       "stars",
                                       "date",
                                       "text",
                                       "useful",
                                       "funny",
                                       "cool")
SELECT "review_id",
       "user_id",
       "business_id",
       "stars",
       "date",
       "text",
       "useful",
       "funny",
       "cool"
FROM ODS."Yelp_Review";

