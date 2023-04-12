-- Lab | SQL Subqueries 3.03

use sakila;

-- 1. How many copies of the film Hunchback Impossible 
-- exist in the inventory system?
select title, count(distinct inventory_id) as "Count" from inventory i
join film f
on i.film_id = f.film_id
where title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average
-- of all the films.
select title, length from film
where length > (select avg(length)
                from film)
order by length desc;

-- 3. Use subqueries to display all actors who appear in 
-- the film Alone Trip.
select first_name, last_name from actor
where (first_name, last_name) in
(select first_name, last_name from film f
join film_actor fa
on f.film_id = fa.film_id
join actor a
on fa.actor_id = a.actor_id
where title = "Alone Trip");

-- 4. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
select title from film
where title in (select title from film f
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where c.name = "family");

-- 5. 
select first_name, last_name, email from customer c
where exists
(select first_name, last_name, email from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = "Canada");

select first_name, last_name, email from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = "Canada";

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted
-- in the most number of films.
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id
HAVING COUNT(*) = (
  SELECT COUNT(*) 
  FROM film_actor fa_inner
  WHERE fa_inner.film_id = f.film_id
  GROUP BY fa_inner.actor_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- 7. Films rented by most profitable customer. You can use 
-- the customer table and payment table to find the most 
-- profitable customer ie the customer that has made the largest sum of payments
SELECT film.title, customer.first_name, customer.last_name
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
JOIN customer ON payment.customer_id = customer.customer_id
WHERE customer.customer_id = (
  SELECT customer_id
  FROM payment
  GROUP BY customer_id
  ORDER BY SUM(amount) DESC
  LIMIT 1
);

-- 8. Customers who spent more than the average payments.
SELECT distinct c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);
