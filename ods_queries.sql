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



INSERT INTO DWH."Yelp_Checkin_Facts" ("business_id", "checkin_date", "stars", "precipitation", PRECIPITATION_NORMAL, "max_temp", "min_temp", "normal_max_temp", "normal_min_temp", "temp_closed")
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


