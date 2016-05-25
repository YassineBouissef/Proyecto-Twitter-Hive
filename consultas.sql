
/************************Idioma de tuit y followers***************************************/

CREATE TABLE tweet1 AS
SELECT
l.lang as idioma,
a.followers_count as seguidores
FROM pepito
LATERAL VIEW json_tuple(jsonData,’followers_count’) a AS followers_count
LATERAL VIEW json_tuple(jsonData,’ lang’) l AS lang



/************************Media de Retwwets***************************************/

CREATE TABLE mediaRetweets AS
SELECT
c.screenname as user,
a.text as tweet,
to_date(from_unixtime(unix_timestamp(substr(a.time, 5), 'MMM dd hh:mm:ss
ZZZZZ yyyy'))) as daydate,
avg(a.retweetcount) as retweetcount
FROM tweets
LATERAL VIEW json_tuple(jsonData, 'created_at', 'text', 'retweet_count')
a AS time, text, retweetcount
LATERAL VIEW json_tuple(jsonData, 'user') b AS user
LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname
GROUP BY c.screenname;


/************************Tuits con más interacciones***************************************/

SELECT 
a.text as tweet,
b.retweet_count as retweet_count
FROM tweetsFinal
lateral view json_tuple(jsondata,'text')a as text
lateral view json_tuple(jsondata,'retweet_count')b as retweet_count
ORDER by retweet_count desc
limit 10;

/*********************************Hashtags mas comentados******************************************/

SELECT
 LOWER(hashtags.text),
 COUNT(*) AS total_count
FROM tweets
LATERAL VIEW EXPLODE(entities.hashtags) t1 AS hashtags
GROUP BY LOWER(hashtags.text)
ORDER BY total_count DESC
LIMIT 15;


/*********************************Zonas horarias mas activas del mundo******************************************/

SELECT
 user.time_zone,
 SUBSTR(created_at, 0, 3),
 COUNT(*) AS total_count
FROM tweets
WHERE user.time_zone IS NOT NULL
GROUP BY
 user.time_zone,
 SUBSTR(created_at, 0, 3)
ORDER BY total_count DESC
LIMIT 15;



/*********************************Localizacion******************************************/

CREATE TABLE localizacion AS 
	SELECT foo.screenname as screenname, foo.location as location 
	FROM ( 
	 	SELECT c.screenname, c.location
		FROM tweets 
		LATERAL VIEW json_tuple(jsonData, 'retweeted_status') a AS us
		LATERAL VIEW json_tuple(a.us, 'user') b AS user 
		LATERAL VIEW json_tuple(b.user, 'screen_name', 'location') c AS screenname , location 
	 	) foo 
	GROUP BY foo.screenname, foo.location;

a) Numero de Tweets localizados en Barcelona
select count(*) as NumeroDeTweets from localizacion where location LIKE '%Barcelona%';


/********Si tuvo menciones en #HappyNacionalCerealDay #NationalCerealDay********/


CREATE TABLE mentions AS
SELECT
	foo.screenname as mentioner,
	substr(wordTable.word, 2) as mentioned,
	to_date(from_unixtime(unix_timestamp(substr(foo.time, 5), 'MMM ddhh:mm:ss ZZZZZ yyyy'))) as daydate
FROM (
SELECT
	c.screenname,
	a.time,
	split(a.text, '[^a-zA-Z_0-9@#]') AS wordarray
FROM tweets
	LATERAL VIEW json_tuple(jsonData, 'created_at','text') a AS time, text
	LATERAL VIEW json_tuple(jsonData, 'user') b AS user
	LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname) foo
	LATERAL VIEW explode(foo.wordarray) wordTable AS word
WHERE wordTable.word LIKE '%#HappyNacionalCerealDay%';


/********Hashtags a estudiar: #FrostedFlakes #fillinyourGRRREAT********/

CREATE TABLE tophashtags AS
SELECT
	foo2.screenname AS user,
	foo2.word AS word,
	COUNT(*) as count
FROM (
SELECT
	foo.screenname as screenname,
	wordTable.word as word FROM (
SELECT
	c.screenname,
	a.time,
	split(a.text, "[^a-zA-Z_0-9@#]+") AS wordarray
FROM tweets
	LATERAL VIEW json_tuple(jsonData, 'created_at', 'text') a AS time,text
	LATERAL VIEW json_tuple(jsonData, 'user') b AS user
	LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname
) foo
	LATERAL VIEW explode(foo.wordarray) wordTable AS word
	WHERE wordTable.word LIKE '#fillinyourGRRREAT%'
) foo2
	GROUP BY foo2.screenname, foo2.word;


/*****************Menciones recibidas en x tiempo*******************/


CREATE TABLE mentions AS
SELECT
	foo.screenname as mentioner,
	substr(wordTable.word, 2) as mentioned,
	to_date(from_unixtime(unix_timestamp(substr(foo.time, 5), 'MMM ddhh:mm:ss ZZZZZ yyyy'))) as daydate
FROM (
SELECT
	c.screenname,
	a.time,
	split(a.text, '[^a-zA-Z_0-9@#]') AS wordarray
FROM tweets
	LATERAL VIEW json_tuple(jsonData, 'created_at','text') a AS time, text
	LATERAL VIEW json_tuple(jsonData, 'user') b AS user
	LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname
) foo
	LATERAL VIEW explode(foo.wordarray) wordTable AS word
	WHERE wordTable.word LIKE '@%';









/***********************************EJERCICIOS PROPUESTOS******************************/
-Temática del contenido



-Tono



-Tipología de links 

















































m&m https://twitter.com/mmschocolate

CREATE TABLE mentions AS
SELECT
foo.screenname as mentioner,
substr(wordTable.word, 2) as mentioned,
to_date(from_unix
time(unix_timestamp(substr(foo.
time, 5), 'MMM dd
hh:mm
:ss ZZZZZ yyyy'))) as daydate
FROM (
SELE
CT
c.screenname,
a.
time,
split(a.text, '[^a
-
zA
-
Z_0
-
9@#]') AS wordarray
FROM tweets
LATERAL VIEW json_tuple(jsonDat
a, 'created_at',
'text') a AS
t
ime, text
LATERAL VIEW json_
tuple(jsonData, 'user') b AS user
LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname
) foo
LATERAL VIEW explode(foo.wordarray) wordTable AS word
WHERE wordTable.word LIKE '@%';



create table frecuencia as 
select 
c.screenname as user, 
a.retweet_count as retweet_count 
from mm
 LATERAL VIEW json_tuple(jsonData,'retweet_count') 
a AS retweet_count 
 LATERAL VIEW json_tuple(jsonData, 'user') b AS user 
 LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname; 

create table frecuencia as 
select 
c.screenname as user, 
a.retweet_count as retweet_count,
max(a.retweet_count)
from mms
 LATERAL VIEW json_tuple(jsonData,'retweet_count') 
a AS retweet_count 
 LATERAL VIEW json_tuple(jsonData, 'user') b AS user 
 LATERAL VIEW json_tuple(b.user, 'screen_name') c AS screenname; 


-Idioma de tuit, propios y followers





-Media de rt y likes + seguidores y seguidos

-Temática del contenido

-Tono

-Tipología de links

-Interacción con otros perfiles

-Tuits con más interacciones


SELECT
 user.time_zone,
 SUBSTR(created_at, 0, 3),
 COUNT(*) AS total_count
FROM mm
WHERE user.time_zone IS NOT NULL
GROUP BY
 user.time_zone,
 SUBSTR(created_at, 0, 3)
ORDER BY total_count DESC
LIMIT 15;



create external table tweetsFinal (
retweeted boolean,
in_reply_to_screen_name string,
possibly_sensitive boolean,
truncated boolean,
lang string,
in_reply_to_status_id_str string,
id int,
in_reply_to_user_id_str string,
in_reply_to_status_id string,
created_at string,
favorite_count int,
place string,
coordinates string
)
location ‘/user/cloudera/tweetsFinal’;

