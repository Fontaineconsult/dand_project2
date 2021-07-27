CREATE FILE FORMAT "PROJECT2"."STAGING".yelp_json TYPE = 'JSON' COMPRESSION = 'AUTO'
ENABLE_OCTAL = FALSE ALLOW_DUPLICATE = FALSE STRIP_OUTER_ARRAY = FALSE STRIP_NULL_VALUES = FALSE IGNORE_UTF8_ERRORS = FALSE;


CREATE FILE FORMAT "PROJECT2"."STAGING".weather_CSV TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n' SKIP_HEADER = 0 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE'
TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134'
DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('\\N');


create or replace stage yelp_business file_format = yelp_json;
create or replace stage yelp_checkin file_format = yelp_json;
create or replace stage yelp_review file_format = yelp_json;
create or replace stage yelp_tip file_format = yelp_json;
create or replace stage yelp_user file_format = yelp_json;
create or replace stage yelp_covid file_format = yelp_json;
create or replace stage weather_precipitation file_format = weather_CSV;
create or replace stage weather_temperature file_format = weather_CSV;


create or replace table "yelp_business_json" (business_json variant);
create or replace table "yelp_checkin_json" (checkin_json variant);
create or replace table "yelp_review_json" (yelp_review_json variant);
create or replace table "yelp_tip_json" (yelp_tip_json variant);
create or replace table "yelp_user_json" (yelp_user_json variant);
create or replace table "yelp_covid_json" (yelp_covid_json variant);

create table "temperature_csv" (temp_csv variant);
create table "precipitation_csv" (precipitation_csv variant);


put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_business.json @yelp_business auto_compress=true parallel=4;
copy into "yelp_business_json" from @YELP_BUSINESS/yelp_business.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_checkin.json @yelp_checkin auto_compress=true parallel=4;
copy into "yelp_checkin_json" from @yelp_checkin/yelp_checkin.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_review.json @yelp_review auto_compress=true parallel=4;
copy into "yelp_review_json" from @yelp_review/yelp_review.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_tip.json @yelp_tip auto_compress=true parallel=4;
copy into "yelp_tip_json" from @yelp_tip/yelp_tip.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_user.json @yelp_user auto_compress=true parallel=4;
copy into "yelp_user_json" from @yelp_user/yelp_user.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/yelp_covid.json @yelp_covid auto_compress=true parallel=4;
copy into "yelp_covid_json" from @yelp_covid/yelp_covid.json file_format=yelp_json on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/temperature.csv @weather_temperature auto_compress=true parallel=4;
copy into "temperature_csv" from @weather_temperature/temperature.json file_format=weather_CSV on_error='skip_file';

put file:///C:/Users/DanielPC/Desktop/UdacityDevOps/dand_project2/yelp_data/precipitation.csv @weather_precipitation auto_compress=true parallel=4;
copy into "precipitation_csv" from @weather_precipitation/precipitation.csv file_format=weather_CSV on_error='skip_file';