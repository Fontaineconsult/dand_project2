CREATE FILE FORMAT "PROJECT2"."STAGING".yelp_json TYPE = 'JSON' COMPRESSION = 'AUTO'
ENABLE_OCTAL = FALSE ALLOW_DUPLICATE = FALSE STRIP_OUTER_ARRAY = FALSE STRIP_NULL_VALUES = FALSE IGNORE_UTF8_ERRORS = FALSE;


CREATE OR REPLACE FILE FORMAT "PROJECT2"."STAGING".weather_CSV TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE'
TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134'
DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('\\N');


create or replace stage yelp_business file_format = yelp_json;
create or replace stage yelp_checkin file_format = yelp_json;
create or replace stage yelp_review file_format = yelp_json;
create or replace stage yelp_tip file_format = yelp_json;
create or replace stage yelp_user file_format = yelp_json;
create or replace stage yelp_covid file_format = yelp_json;
create or replace stage yelp_photos file_format = yelp_json;
create or replace stage weather_precipitation file_format = weather_CSV;
create or replace stage weather_temperature file_format = weather_CSV;


create or replace table "yelp_business_json" (business_json variant);
create or replace table "yelp_checkin_json" (checkin_json variant);
create or replace table "yelp_review_json" (yelp_review_json variant);
create or replace table "yelp_tip_json" (yelp_tip_json variant);
create or replace table "yelp_user_json" (yelp_user_json variant);
create or replace table "yelp_photos_json" (yelp_photos_json variant);
create or replace table "yelp_covid_json" (yelp_covid_json variant);

create or replace table "temperature_csv" (date integer, min integer, max integer, normal_min float, normal_max float);
create or replace table "precipitation_csv" (date integer, precipitation integer, precipitation_normal integer);


put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_business.json @yelp_business auto_compress=true parallel=4;
copy into staging."business_json" from @YELP_BUSINESS/yelp_business.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_checkin.json @yelp_checkin auto_compress=true parallel=4;
copy into staging."yelp_checkin_json" from @yelp_checkin/yelp_checkin.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_review.json @yelp_review auto_compress=true parallel=4;
copy into staging."yelp_review_json" from @yelp_review/yelp_review.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_tip.json @yelp_tip auto_compress=true parallel=4;
copy into staging."yelp_tip_json" from @yelp_tip/yelp_tip.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_user.json @yelp_user auto_compress=true parallel=4;
copy into staging."yelp_user_json" from @yelp_user/yelp_user.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_covid.json @yelp_covid auto_compress=true parallel=4;
copy into staging."yelp_covid_json" from @yelp_covid/yelp_covid.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/913678186/Desktop/DANDProj2/yelp_data/yelp_academic_dataset_photos.json @yelp_photos auto_compress=true parallel=4;
copy into staging."yelp_photos_json" from @yelp_photos/yelp_academic_dataset_photos.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/temperature.csv @weather_temperature auto_compress=true parallel=4;
copy into staging."temperature_csv" from @weather_temperature/temperature.json file_format=weather_CSV on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/precipitation.csv @weather_precipitation auto_compress=true parallel=4;
copy into staging."precipitation_csv" from @weather_precipitation/precipitation.csv file_format=weather_CSV on_error='skip_file';











