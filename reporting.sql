--- reports generate required data from DWH


---DWH Select Query---

select DWH."Yelp_Checkin_Facts"."business_id",
       DWH."Yelp_Checkin_Facts"."max_temp",
       DWH."Yelp_Checkin_Facts"."min_temp",
       DWH."Yelp_Checkin_Facts"."normal_max_temp",
       DWH."Yelp_Checkin_Facts"."normal_min_temp",
       DWH."Yelp_Checkin_Facts".PRECIPITATION_NORMAL,
       DWH."Yelp_Checkin_Facts"."stars",
       DWH."Yelp_Business_Dim"."name"
FROM DWH."Yelp_Checkin_Facts"
         JOIN DWH."Yelp_Business_Dim" ON DWH."Yelp_Checkin_Facts"."business_id" = DWH."Yelp_Business_Dim"."business_id";

---Query DWH for Portland---
select DWH."Yelp_Business_Dim"."name" as business_name,
       DWH."Yelp_Business_Dim"."city",
       DWH."Yelp_Checkin_Facts"."max_temp",
       DWH."Yelp_Checkin_Facts"."min_temp",
       DWH."Yelp_Checkin_Facts"."precipitation",
       DWH."Yelp_Checkin_Facts"."stars"

FROM DWH."Yelp_Checkin_Facts"
         JOIN DWH."Yelp_Business_Dim" ON DWH."Yelp_Checkin_Facts"."business_id" = DWH."Yelp_Business_Dim"."business_id"
WHERE DWH."Yelp_Business_Dim"."city" = 'Portland';

---Aggregates Checkins by date and averages stars---

select COUNT(DWH."Yelp_Checkin_Facts"."review_date") as "Checkin Count",
       DWH."Yelp_Checkin_Facts"."review_date",
       avg(DWH."Yelp_Checkin_Facts"."stars") as average_stars,
       DWH."Yelp_Checkin_Facts"."max_temp",
       DWH."Yelp_Checkin_Facts"."min_temp",
       DWH."Yelp_Checkin_Facts"."precipitation"



FROM DWH."Yelp_Checkin_Facts"
         JOIN DWH."Yelp_Business_Dim" ON DWH."Yelp_Checkin_Facts"."business_id" = DWH."Yelp_Business_Dim"."business_id"
WHERE DWH."Yelp_Business_Dim"."city" = 'Portland'
GROUP BY DWH."Yelp_Checkin_Facts"."review_date", DWH."Yelp_Checkin_Facts"."max_temp", DWH."Yelp_Checkin_Facts"."min_temp", DWH."Yelp_Checkin_Facts"."precipitation"
ORDER BY avg(DWH."Yelp_Checkin_Facts"."stars") asc ;