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


create table "business_json" (business_json variant);

put file:///C:/Users/913678186/Desktop/DANDProj2/yelp_data/yelp_business.json

copy into "business" from @YELP_BUSINESS/yelp_business.json file_format=yelp_json on_error='skip_file';