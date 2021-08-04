---DWH Fact Table---

CREATE OR REPLACE TABLE DWH."Yelp_Checkin_Facts" (
                                                     "id"  NUMBER AUTOINCREMENT start 1 increment 1,
                                                     "business_id" STRING,
                                                     "checkin_date" date,
                                                     "stars" DOUBLE,
                                                     "precipitation" NUMBER,
                                                     "PRECIPITATION_NORMAL" NUMBER,
                                                     "max_temp" NUMBER,
                                                     "min_temp" NUMBER,
                                                     "normal_max_temp" NUMBER,
                                                     "normal_min_temp" NUMBER,
                                                     "temp_closed" STRING,
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
       ODS."Weather_Temperature"."MAX" as max_temp,
       ODS."Weather_Temperature"."MIN" as min_temp,
       ODS."Weather_Temperature".NORMAL_MAX,
       ODS."Weather_Temperature".NORMAL_MIN,
       ODS."Yelp_Covid"."temporary_closed_until"
FROM ODS."Yelp_Checkin"
         INNER JOIN ODS."Yelp_Business" on ODS."Yelp_Checkin"."business_id" = ODS."Yelp_Business"."business_id"
         LEFT JOIN ODS."Weather_Precipitation" on REPLACE(TO_CHAR(TO_DATE(ODS."Yelp_Checkin"."date")),'-') = TO_CHAR(ODS."Weather_Precipitation"."DATE")
         LEFT JOIN ODS."Weather_Temperature" on REPLACE(TO_CHAR(TO_DATE(ODS."Yelp_Checkin"."date")),'-') = TO_CHAR(ODS."Weather_Temperature"."DATE")
         LEFT JOIN ODS."Yelp_Covid" on ODS."Yelp_Checkin"."business_id" = ODS."Yelp_Covid"."business_id";



---Business Dim Table---

CREATE OR REPLACE TABLE DWH."Yelp_Business_Dim" ("id" NUMBER AUTOINCREMENT start 1 increment 1,
                                                 "business_id" string(22),
                                                 "name" string,
                                                 "address" string,
                                                 "city" string,
                                                 "state" string,
                                                 "postal_code" string,
                                                 "latitude" float,
                                                 "longitude" float,
                                                 "stars" float,
                                                 "review_count" integer,
                                                 "is_open" integer,
                                                 primary key ("id")

);
INSERT INTO DWH."Yelp_Business_Dim" ("business_id", "name", "address", "city", "state", "postal_code", "latitude", "longitude", "stars", "review_count", "is_open")
SELECT
    ODS."Yelp_Business"."business_id",
    ODS."Yelp_Business"."name",
    ODS."Yelp_Business"."address",
    ODS."Yelp_Business"."city",
    ODS."Yelp_Business"."state",
    ODS."Yelp_Business"."postal_code",
    ODS."Yelp_Business"."latitude",
    ODS."Yelp_Business"."longitude",
    ODS."Yelp_Business"."stars",
    ODS."Yelp_Business"."review_count",
    ODS."Yelp_Business"."is_open"
from ODS."Yelp_Business";

---Yelp Covid Dim---

CREATE OR REPLACE Table DWH."Yelp_Covid_Dim" (
                             "id" NUMBER AUTOINCREMENT start 1 increment 1,
                             call_to_action_enabled BOOLEAN,
                             covid_banner string,
                             grubhub_enabled string,
                             request_a_quote_enabled string,
                             temporary_closed_until string,
                             virtual_services_offered string,
                             business_id string UNIQUE,
                             delivery_or_takeout string,
                             highlights string,
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
SELECT
    ODS."Yelp_Covid"."call_to_action_enabled",
    ODS."Yelp_Covid"."covid_banner",
    ODS."Yelp_Covid"."grubhub_enabled",
    ODS."Yelp_Covid"."request_a_quote_enabled",
    ODS."Yelp_Covid"."temporary_closed_until",
    ODS."Yelp_Covid"."virtual_services_offered",
    ODS."Yelp_Covid"."business_id",
    ODS."Yelp_Covid"."delivery_or_takeout",
    ODS."Yelp_Covid"."highlights"
FROM ODS."Yelp_Covid";



