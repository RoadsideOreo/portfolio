#Q1: How many restaurants are rated higher than 4.5?

SELECT count(DISTINCT restaurant_name) FROM swiggy 
WHERE rating > 4.5;

#Q2: Which city has the highest number of restaurants?

SELECT city, count(distinct restaurant_name) as ct FROM swiggy
GROUP BY city
ORDER BY ct DESC
LIMIT 1;

#Q3: How many restaurants have the word "pizza" in their name?

SELECT DISTINCT restaurant_name as ct FROM swiggy
WHERE restaurant_name LIKE ('%pizza%');

#Q4: What is the most common cuisine among the restaurants in the dataset?

SELECT cuisine, count(cuisine)
FROM (SELECT DISTINCT restaurant_name, cuisine FROM swiggy
ORDER BY restaurant_name) as X
GROUP BY cuisine
ORDER BY count(cuisine) DESC
LIMIT 1;

#Q5: What is the average rating of restaurants in each city?

SELECT x.city, ROUND(AVG(x.rating), 2)
FROM (SELECT DISTINCT restaurant_name, city, rating FROM swiggy) as X
GROUP BY x.city;

#Q6: What is the highest price for an item under the "recommended" menu category for each restaurant?

SELECT restaurant_name, max(price)
FROM swiggy 
WHERE menu_category='recommended'
GROUP BY restaurant_name;

#Q7: Find the top 5 most expensive restaurants that offer cuisine other than Indian cusisine.

SELECT DISTINCT restaurant_name, MAX(cost_per_person) as m
FROM swiggy
WHERE cuisine != 'Indian Cuisine'
GROUP BY restaurant_name
ORDER by m DESC
LIMIT 5;

#Q8: Find the restaurants that have an average rating which is higher than the total average rating of all restaurants together.

WITH t1 as (SELECT DISTINCT restaurant_name, rating FROM swiggy), 
t2 as (SELECT AVG(rating) as rt from t1) 
SELECT restaurant_name, rating FROM t1, t2
WHERE t1.rating>t2.rt;

#Q9: Find the restaurants that have the same name but are located in different cities.

SELECT DISTINCT a.restaurant_name FROM swiggy a, swiggy b
WHERE a.restaurant_name=b.restaurant_name AND a.city != b.city;

#Q10: Which restaurant offers the most number of items in the "main course" category?

SELECT restaurant_name, count(*) as ct
FROM swiggy
WHERE menu_category='Main Course'
GROUP BY restaurant_name 
ORDER BY ct DESC
LIMIT 1;

#Q11: List the name of restaurants that are 100% vegetarian arranged in alphabetical order.

WITH t1 as (SELECT restaurant_name, veg_or_nonveg, DENSE_RANK() OVER (partition by restaurant_name, veg_or_nonveg ORDER BY veg_or_nonveg) as rn, CASE WHEN veg_or_nonveg='veg' THEN 1 ELSE 2 END as ron FROM swiggy),
t2 as (SELECT t1.restaurant_name, SUM(t1.rn) as a, SUM(t1.ron) as b
FROM t1
GROUP BY t1.restaurant_name)
SELECT restaurant_name FROM t2 WHERE a/b=1;

SELECT DISTINCT restaurant_name, count(CASE WHEN veg_or_nonveg THEN 1 ELSE 0 END)/count(*) as veg FROM swiggy
GROUP BY restaurant_name
HAVING veg=1
ORDER BY restaurant_name;

#Q12 Which is the restaurant providing the lowest average price for all items?

SELECT restaurant_name, ROUND(AVG(price),1) as price FROM swiggy
GROUP BY restaurant_name
ORDER BY price ASC
LIMIT 1;

#Q13 List the top 5 restaurants that offer the highest number of categories.

SELECT restaurant_name, count(DISTINCT menu_category) as cn FROM swiggy
GROUP BY restaurant_name
ORDER BY cn DESC
LIMIT 5;

#Q14 Which top 3 restaurants provide the highest percentage of non-vegetarian food?

SELECT restaurant_name, count(case when veg_or_nonveg='non-veg' THEN 1 END)/count(*) as cn
FROM swiggy
GROUP BY restaurant_name
ORDER BY cn DESC
LIMIT 3;












