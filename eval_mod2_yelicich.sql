USE sakila;

-- Ejercicios

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados

SELECT DISTINCT title 
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title, rating 
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description 
FROM film
WHERE description LIKE "%amazing%";

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length  
FROM film
WHERE length >120;

-- 5. Recupera los nombres de todos los actores.

SELECT first_name, last_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT 
	actor_id, 
	first_name, 
    last_name
FROM actor
WHERE actor_id 
BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT 
	title, 
    rating 
FROM film
WHERE rating 
NOT IN ("R", "PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT 
	rating, 
    COUNT(*) AS total_peliculas 
FROM film
GROUP BY rating
ORDER BY total_peliculas DESC;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
	tabla_clientes.customer_id, 
	tabla_clientes.first_name, 
    tabla_clientes.last_name, 
    COUNT(tabla_renta.rental_id) AS total_alquileres_clientes
FROM customer AS tabla_clientes
INNER JOIN rental AS tabla_renta
	ON tabla_clientes.customer_id = tabla_renta.customer_id
GROUP BY tabla_clientes.customer_id, tabla_clientes.first_name, tabla_clientes.last_name
ORDER BY total_alquileres_clientes;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT 
	categoria_pelicula.name AS categoria, 
    COUNT(tabla_renta.rental_id) AS total_alquileres
FROM rental AS tabla_renta
JOIN inventory AS inventario 
	ON inventario.inventory_id = tabla_renta.inventory_id
JOIN film AS tabla_filmes 
	ON tabla_filmes.film_id = inventario.film_id
JOIN film_category AS fc 
	ON tabla_filmes.film_id = fc.film_id
JOIN category AS categoria_pelicula 
	ON categoria_pelicula.category_id = fc.category_id
GROUP BY categoria_pelicula.name
ORDER BY total_alquileres;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT 
	rating AS clasificación, 
    AVG(length) AS promedio_duracion
FROM film AS tabla_peliculas
GROUP BY rating
ORDER BY promedio_duracion;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT 
	a.first_name,
    a.last_name
FROM actor AS a
JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
JOIN film AS f
	ON f.film_id = fa.film_id
WHERE f.title = "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT
	title
FROM
	film AS f
WHERE
	f.description LIKE "%dog%" 
    OR f.description LIKE "%cat%";

-- 15. Encuentr a el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT
	title
FROM
	film AS f
WHERE
	f.release_year BETWEEN 2005 AND 2010;

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT
	f.title,
    c.name
FROM film AS f
JOIN film_category AS fc
	ON f.film_id = fc.film_id
JOIN category AS c
	ON c.category_id = fc.category_id
WHERE c.name = "Family";

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film

SELECT
	title,
    length,
    rating
FROM film AS f
WHERE rating = "R" AND length > 120;
