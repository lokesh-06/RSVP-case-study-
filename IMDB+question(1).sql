USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- 1sol)
SELECT count(*) as total_rows_indirector_mapping
from director_mapping;

#total no of rows in director_mapping = 3867

select count(*) as total_rows_inrole_mapping
from role_mapping;

#total no of rows in role_mapping = 15615

select  count(*) as total_rows_inmovie
from movie;

#total no of rows in movie = 7997

select count(*) as total_rows_inratings
from ratings;

#total no of rows in ratings = 7997

select count(*) as total_rows_innames
from names;

#total no of rows in names = 25735

select count(*) as total_rows_ingenre
from genre;

#total no of rows in genre = 14662















-- Q2. Which columns in the movie table have null values?
-- Type your code below:

 --  2sol)
select 
      
       sum(case when id is null then 1 else 0 end ) as nulls_in_id,
       sum(case when date_published is null then 1 else 0 end) as nulls_in_date_published,
       SUM(case when year is null then 1 else 0 end ) as  nulls_in_year,
       sum(case when country is null then 1 else 0 end) as nulls_in_country,
       sum(case when duration is null then 1 else 0 end) as nulls_in_duration
       
from movie;

#there are 0 null values in id column
#there are 0 null values in date_published column
#there are 0 null values in year column
#there are 20 null values in country column 
#there are 0 null values in duration column 

-- there is another way to find null values we will find null values of remaning column in different method 

select count(*) as nulls_in_title
from movie
where title is null;

#there are 0 null values in title column 

select count(*) as nulls_in_languages 
from movie
where languages is null;

#there are 194 null values in languages column 

select count(*) as nulls_in_production 
from movie
where production_company is null;

#there are 528 null values in production_company column 

select count(*) as null_in_worlwide_gross 
from movie 
where worlwide_gross_income is null;

#there are 3724 null values in worlwide_gross_income column 
       








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

--  no of movies released each year 
select year ,
         count(*) as no_of_movies
from movie
group by year 
order by year;

##in year 2017 - 3052 total movies were released 
##in year 2018 - 2944 total movies were released 
##in year 2019 - 2001 total movies were released 

# + -------------------- + ----------------+
# |   Year               | number of movies|
# + ---------------------+ ----------------+
# |    2017              |     3052        |
# |    2018              |     2944        |
# |    2019              |     2001        |
# +--------------------- + ----------------+

-- no of movies released each month
select month(date_published) as month_num,
count(id) as num_of_movies
from movie 
group by month(date_published)
order by month(date_published);

-- month_num  :  num_of_movies
--      1             804
--      2             640
--      3             824
--      4             680
--      5             625
--      6             580
--      7             493
--      8             678
--      9             809
--      10            801
--      11            625
--      12            438







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) as movies_produced 
from movie 
where
(country like '%USA%' OR country like '%India%') 
and  year = 2019;

-- so in the year 2019 there were 1059 movies produced in USA or INDIA 












/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre 
from genre;

-- different genres of movies in dataset are:-
--  1) Action
--  2) Sci-Fi
--  3) Crime
--  4) Mystery
--  5) Drama
--  6) Fantasy
--  7) Thriller
--  8) comedy 
--  9) Horror
--  10) Family
--  11) Romance 
--  12) Adventure
--  13) others 









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre,
          count(*) as highest_movie_produced
from genre 
group by genre
order by 2 desc 
limit 5;

-- so , Drama genre had produced highest no of movies and the no is 4285











/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with only_one_genre as
(
     select movie_id,
				count(genre) as total_num_of_movies
	from genre 
    group by movie_id 
    having total_num_of_movies = 1 
)
select count(movie_id) as one_genre_movies
from only_one_genre;

-- total 3289 movies belong to only one genre .

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre,
            round(avg(m.duration),3) as average_duration 
from genre as g 
inner join movie as m 
                 on 
                   m.id = g.movie_id 
group by g.genre 
order by 1 ;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_rank as 
(
    select genre ,count(movie_id) as movie_count,
    rank()        over(order by count(movie_id)desc) as genre_rank
    from genre 
    group by genre 
)
select *
from genre_rank
where genre = 'thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as  min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_avg_votes,
max(total_votes) as max_avg_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating

from ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title, avg_rating,
dense_rank() over(order by avg_rating desc) as movie_rank
from movie m
inner join ratings r
on m.id = r.movie_id
limit 12;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating,
       count(movie_id) as movie_count
from ratings 
group by median_rating
order by 1;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company,
       count(m.id) as movie_count,
       rank() over(
                    order by count(m.id)desc) prod_company_rank
from ratings r 
inner join movie m 
on r.movie_id = m.id 
where 
 r.avg_rating > 8 
 group by 
  m.production_company limit 5;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
  genre,
  count(g.movie_id) as movie_count
from 
   genre as g 
   inner join 
      movie as m 
      on g.movie_id = m.id 
    inner join 
       ratings as r 
       on m.id = r.movie_id 
where 
  year = 2017
  and month(date_published) = 3 
  and lower(country) like '%USA%'
  and total_votes > 1000
group by 
  genre
order by 
 movie_count desc;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select distinct
   title,
   avg_rating,
   genre
from 
  movie as m 
         inner join genre as g 
         on m.id = g.movie_id 
         inner join ratings as r 
         on m.id = r.movie_id
 where 
   title like 'the%' and avg_rating > 8 
 order by genre, avg_rating desc;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(m.id) as movie_ct
from 
    movie as m 
    inner join 
      ratings as r 
      on m.id = r.movie_id 
where 
   median_rating = 8 
   and date_published between '2018-04-01' and '2019-04-01';







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(r.total_votes)
from movie as m 
join ratings as r 
	 on m.id = r.movie_id
where country like '%German%' or country like '%ital%'
group by country;

select sum(total_votes)
from movie as m 
join ratings as r 
on m.id = r.movie_id
where 
 country like '%Germany%';
 
 -- 2026223 is the sum of total votes for german movies,

select sum(total_votes)
from movie m 
join ratings r 
on m.id = r.movie_id 
where country like '%italy%';

-- 703024 is the sum of total votes for italian movies.



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
  count( case when name is null then id end) as name_nulls,
  count(case when height is null then id end) as height_nulls,
  count(case when date_of_birth is null then id end) date_of_birth_nulls,
  count(case when known_for_movies is null then id end) as known_for_movies_nulls
from names;

-- there are 0 nulls values in name , 17335 in height_nulls,
-- 13431 in date_of_birth, 15226 in known_for_movies_nulls





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_rated_genres as 
( select genre,
         count(m.id) as movie_count,
         rank() over(order by count(m.id) desc) as genre_rank
   from genre as g 
   left join movie as m 
   on g.movie_id = m.id 
   inner join ratings as r  
   on m.id = r.movie_id
   where avg_rating>8
   group by genre )
   
select n.name as director_name,
	   count(m.id) as movie_count
from names as n 
inner join director_mapping as d 
on n.id = d.name_id
inner join movie as m 
on d.movie_id = m.id 
inner join ratings as r 
on m.id = r.movie_id
inner join genre as g
on g.movie_id = m.id
where g.genre in 
( select distinct genre 
  from top_rated_genres
  where genre_rank <= 3 ) and 
  avg_rating > 8 
  group by name
  order by movie_count desc
  limit 3 ; 







/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select n.name as actor_name,
       count(m.id) as movie_count
from names as n 
inner join 
	   role_mapping as a 
       on n.id = a.name_id 
inner join movie as m 
on a.movie_id = m.id 
inner join ratings as r 
on m.id = r.movie_id
where median_rating >= 8 and category = 'actor'
group by actor_name
order by movie_count desc
limit 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company , 
	sum(total_votes) as vote_count,
    rank() over(order by sum(r.total_votes) desc) as prod_comp_rank 
from movie m 
inner join ratings r 
on m.id = r.movie_id 
group by production_company 
limit 3;

-- production_company    vote_count      prod_comp_rank
--  marvel studios       2656967                1 
-- twentieth_century_fox  2411163               2 
-- warner bros.          2396057                3


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with INDIAN as 
(  select n.name actor_name ,
    r.total_votes,
    m.id,
    r.avg_rating,
    total_votes*avg_rating as w_avg
from names n 
inner join role_mapping rol on n.id = rol.name_id
inner join ratings r on rol.movie_id =  r.movie_id
inner join movie m on m.id = r.movie_id 
where category = 'Actor' and country = 'INDIA'
order by actor_name ),

Actor as 
( select *,
          sum(w_avg) over w1 as rating,
          sum(total_votes) over w2 as votes 
   from indian window w1 as 
   (partition by actor_name ),
					w2 as 
    (partition by actor_name) )
    
select actor_name ,
       votes as total_votes ,
       count(id) as movie_count,
       round(rating/votes, 3) as actor_avg_rating,
       dense_rank()
       over(order by  rating/votes desc) as actor_rank
       from actor 
       group by actor_name 
       having movie_count >= 5 ;
       
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
    
with INDIAN as 
( select n.name as actress_name ,
  r.total_votes, 
  m.id,
  r.avg_rating,
  total_votes*avg_rating as w_avg 
from names n
inner join role_mapping rol
		on n.id = rol.name_id
inner join ratings r 
        on rol.movie_id = r.movie_id 
inner join movie m 
        on m.id = r.movie_id
where  category = 'Actress' and languages = 'Hindi'
order by actress_name ),

Actress as 
( select *,
   sum(w_avg) over  w1 as rating,
   sum(total_votes) over w2 as votes
  from Indian window w1 as 
      ( partition by actress_name),
      w2 as 
      (partition by actress_name))

select actress_name ,
	votes as total_votes,
    count(id) as movie_count,
    round(rating/votes,2)as actress_avg_rating,
    dense_rank()
    over(order by  rating/votes desc) as actress_rank
    from Actress
    group by actress_name
    having movie_count>=3
    limit 5;
    
-- top five actress are  tapsee pannu ,divya dutta, kriti kharbanda, sonakshi sinha 
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select m.title as name_of_name , r.avg_rating,
Case 
    when avg_rating > 8 then'superhit'
    when avg_rating between 7 and 8 then 'hit'
    when avg_rating between 5 and 7 then 'one-time-watch'
    else 'flop movies'
end as type_of_movie
from movie m 
inner join ratings r 
on m.id = r.movie_id
inner join genre g 
on m.id = g.movie_id 
where genre = 'thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

with genre_summary as 
( select genre,
		 round(avg(duration), 2) as avg_duration
   from genre as g 
   left join movie as m 
   on g.movie_id = m.id
   group by genre )
   select *, 
          sum(avg_duration)
          over(order by genre rows unbounded preceding) as running_total_duration,
          avg(avg_duration)
          over(order by genre rows unbounded preceding) as moving_avg_duration
          from  genre_summary;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select genre, count(movie_id) as movie_count
from genre 
group by genre
order by movie_count desc 
limit 3;
-- genre   movie_count
-- drama     4285
-- comedy    2412
-- thriller  1484

-- Top 3 Genres based on most number of movies

with top_genres as (
select genre,count(m.id) as movie_count,
rank() over(order by count(m.id)desc) as genre_rank
from genre as g 
left join movie as m 
on g.movie_id = m.id 
group by genre),
top_grossing as (
select g.genre, year, m.title as movie_name , worlwide_gross_income,
rank() 
       over(partition by g.genre,year 
       order by convert(replace(trim(worlwide_gross_income),
       '$',''),unsigned int)desc) as movie_rank

from movie as m
inner join genre as g 
on g.movie_id = m.id 
where g.genre in (select distinct genre from top_genres where genre_rank <= 3))

select *
from top_grossing
where movie_rank <= 5
order by year;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with top_prod as 
( select m.production_company,
  count(m.id) as movie_count,
  row_number() 
  over(order by count(m.id) desc) as prod_comp_rank
  
   from movie as m 
   left join ratings as r 
   on m.id = r.movie_id 
   where median_rating >= 8 and production_company is not null
   and position(',' in languages) > 0 
   group by m.production_company )
   
select *
from top_prod
where prod_comp_rank <=2 ;






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actress_ratings as (
      select n.name as actress_name,
      sum(r.total_votes) as total_votes,
      count(m.id) as movie_count,
      round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes),2) as actress_avg_rating 
      from names as n 
      inner join role_mapping as a 
      on n.id = a.name_id 
      inner join movie as m 
      on m.id = a.movie_id 
      inner join ratings as r 
      on m.id = r.movie_id 
      inner join genre as g 
      on m.id = g.movie_id 
	where category = 'actress' and lower(g.genre) = 'drama' and avg_rating > 8 
    group by actress_name )
    
select * ,
row_number() 
over(order by movie_count desc) as actress_rank
from actress_ratings
limit 3;
	
select n.name as actress_name,
       sum(r.total_votes) as total_votes,
       count(m.id) as movie_count,
       round(sum(r.avg_rating*r.total_votes),2) as actress_avg_rating
from names as n 
inner join role_mapping as a 
on n.id = a.name_id 
inner join movie as m
on a.movie_id = m.id 
inner join ratings as r 
on m.id = r.movie_id
inner join genre as g
on m.id = g.movie_id
where category = 'actress' and lower(g.genre) = 'drama'
group by actress_name;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with top_director as (
select n.id as director_id,
n.name as director_name,
count(m.id) as movie_count,
rank() 
over(order by count(m.id) desc) as director_rank 
from names as n 
inner join director_mapping as d
on n.id = d.name_id 
inner join movie as m 
on d.movie_id = m.id
group by n.id ),

movie_summary as (
select n.id as director_id ,
n.name as director_name,
m.id as movie_id,
m.date_published,
r.avg_rating,
r.total_votes, 
m.duration, 
lead(date_published) 
over(
partition by n.id order by m.date_published) as next_date_published,
datediff(lead(date_published) 
over(partition by n.id order by m.date_published), date_published) as inter_movie_days
from names as n 
inner join director_mapping as d 
on n.id = d.name_id 
inner join movie as m 
on d.movie_id = m.id 
inner join ratings as r 
on m.id = r.movie_id
where n.id in (
                 select director_id 
                 from top_director
                 where director_rank <= 9 ))

select director_id, director_name,
       count(distinct movie_id) as number_of_movies,
       round(avg(inter_movie_days),0) as avg_inter_movie_days,
       round(sum(avg_rating*total_votes)/sum(total_votes),2) as avg_rating,
       sum(total_votes) as total_votes,
       min(avg_rating) as min_rating,
       max(avg_rating) as max_rating,
       sum(duration) as total_duration
from movie_summary
group by director_id
order by number_of_movies desc,
avg_rating desc;
       
-- my own extra queries for the summary part,

-- number of movies produced in India
select count(id) as num_of_movies_IND 
FROM movie 
where country = 'India';
-- 1007 movies in India 
-- number of movies produced in USA
select count(id) as num_of_movies_USA
 from movie
 where country = 'USA';
 -- 2260 
 
 -- Movies released in each genre during march 2017 in the india had more than 1000 votes 
 select genre,
 count(g.movie_id) as movie_count
 from genre as g 
 inner join movie as m 
 on g.movie_id = m.id 
 inner join ratings as r 
 on m.id = r.movie_id
 where year = 2017 and month(date_published) = 3 
       and lower(country) like '%India%'
       and total_votes > 1000
group by genre 
order by movie_count desc;


