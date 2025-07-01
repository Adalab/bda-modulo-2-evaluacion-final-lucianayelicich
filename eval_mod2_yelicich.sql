USE sakila;

-- Ejercicios

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados

SELECT DISTINCT title -- DISTINTC solo devuelve valores únicos, por lo que evita los duplicados
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title, rating 
FROM film
WHERE rating = "PG-13"; -- aplico el operador de condición solicitado

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description 
FROM film
WHERE description LIKE "%amazing%"; -- utilizo el operador de filtro LIKE para que busque patrones y no un valor exacto, sumado al % para que indicar que puede estar en cualquier parte de la descripcion, con elementos antes o después.

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length  
FROM film
WHERE length >120; -- aplico el operador de condición solicitado

-- 5. Recupera los nombres de todos los actores.

SELECT first_name, last_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%"; -- utilizo el operador de filtro LIKE para que busque patrones y no un valor exacto, sumado al % para que indicar que puede estar en cualquier parte de la descripcion, con elementos antes o después.

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT 
	actor_id, 
	first_name, 
    last_name
FROM actor
WHERE actor_id 
BETWEEN 10 AND 20; -- selecciona el registro en un rango de valores

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT 
	title, 
    rating 
FROM film
WHERE rating 
NOT IN ("R", "PG-13"); -- usamos NOT IN para excluir las categorías que no deseamos

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT 
	rating, 
    COUNT(*) AS total_peliculas -- cuenta todas las películas en cada clasificación
FROM film
GROUP BY rating -- agrupamos por clasificación
ORDER BY total_peliculas; -- ordenamos por la cantidad de peliculas en cada categoria

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
	tabla_clientes.customer_id, -- indicamos las columnas que mostraremos
	tabla_clientes.first_name, 
    tabla_clientes.last_name, 
    COUNT(tabla_renta.rental_id) AS total_alquileres_clientes -- cuenta cuántos alquileres realizó cada cliente
FROM customer AS tabla_clientes
INNER JOIN rental AS tabla_renta 
	ON tabla_clientes.customer_id = tabla_renta.customer_id -- unimos la tabla customer con la tabla renta usando la columna en comun customer_id
GROUP BY tabla_clientes.customer_id, tabla_clientes.first_name, tabla_clientes.last_name -- agrupamos los resulatdos por cliente
ORDER BY total_alquileres_clientes; -- ordenamos los resultados


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT 
	categoria_pelicula.name AS categoria, -- definimos que columnas vamos a mostrar
    COUNT(tabla_renta.rental_id) AS total_alquileres -- contamos rental_id porque son valores únicos
FROM rental AS tabla_renta
JOIN inventory AS inventario -- unimos la tabla de renta con la de inventario a través de la comumna comun inventory_id para saber qué película se alquiló
	ON inventario.inventory_id = tabla_renta.inventory_id
JOIN film AS tabla_filmes -- unimos la tabla film a la de inventario a través de la columna comun film_id
	ON tabla_filmes.film_id = inventario.film_id
JOIN film_category AS fc -- unimos la tabla de categorias de film a la tabla de categorias de filmes mediante film_id para saber la categoria de las peliculas
	ON tabla_filmes.film_id = fc.film_id
JOIN category AS categoria_pelicula -- unimos la tabla categoria a la de categorias de film a traves de category_id para saber el nombre de la categoria
	ON categoria_pelicula.category_id = fc.category_id
GROUP BY categoria_pelicula.name -- agrupamos por categoria
ORDER BY total_alquileres; -- se cuentan los totales de alquileres

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT 
	rating AS clasificación, -- selleccionamos las columnas a comparar
    AVG(length) AS promedio_duracion -- indicamos que calcule el promedio
FROM film AS tabla_peliculas
GROUP BY rating -- agrupa por cada tipo de clasificación
ORDER BY promedio_duracion; -- ordena por el promedio de duración de cada categoria

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT 
	a.first_name,-- seleccionamos las columnas que queremos ver
    a.last_name
FROM actor AS a
JOIN film_actor AS fa -- contiene los datos de los actores
	ON a.actor_id = fa.actor_id
JOIN film AS f -- unimos la columna film que tiene los datos de las peliculas para encontrar los actores que trabajaron en esa película.
	ON f.film_id = fa.film_id
WHERE f.title = "Indian Love"; -- filtramos la pelicula que necesitamos ver

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT
	title
FROM
	film AS f
WHERE
	f.description LIKE "%dog%" -- usamos LIKE porque buscamos patrones y no valores exactos
    OR f.description LIKE "%cat%"; -- el OR indica que se cumple una de las dos condiciones. El % es un comodin para indicar que puede contener cualquier cosa antes o depsue sla palabra

-- 15. Encuentr a el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT
	title
FROM
	film AS f
WHERE
	f.release_year BETWEEN 2005 AND 2010; -- usamos BETWEEN para encontrar el valor en un rango

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT -- definimos las columnas a comparar
	f.title,
    c.name
FROM film AS f
JOIN film_category AS fc  -- unimos la tabla film category para poder encontrar la categoria solicitada
	ON f.film_id = fc.film_id
JOIN category AS c -- unimos la tabla category para obtener el nombre de la categoria
	ON c.category_id = fc.category_id
WHERE c.name = "Family"; -- establecemos el filtro

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film

SELECT
	title, 
    length,
    rating
FROM film AS f
WHERE rating = "R" AND length > 120; -- usamos AND para indicar que ambas condiciones se deben cumplir

-- BONUS
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT 
	a.first_name, -- seleccionamos las columnas que debemos mostrar
    a.last_name,
    COUNT(fa.film_id) AS total_peliculas -- contamos las peliculas en que ha actuado cada actor
FROM actor AS a
JOIN film_actor AS fa -- unimos la lista de actores con film_actor para obtener las peliculas en que han actuado
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name,a.last_name -- agrupamos por las columnas que necesitamos
HAVING COUNT(fa.film_id) >10 -- contamos que el actor haya trabajado en mas de 10 peliciulas
ORDER BY total_peliculas; -- ordenamos los resultados obtenidos

-- 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT 
    a.actor_id, -- seleccionamos las columnas a comparar
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN ( -- usamos una consulta subordinada para chequear que el id del actor no este en la lista de filmes
    SELECT fa.actor_id FROM film_actor AS fa
);

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT
	 c.name, -- seleccionamos la columna que queremos ver
     AVG(f.length) AS promedio_duracion -- pedimos que calcule el promedio de duracion
FROM category AS c
JOIN film_category AS fc -- unimos la tabla de categorias de filmes para obtener la categoria correspondiente
	ON fc.category_id = c.category_id
JOIN film AS f -- unimos la tabal de film para encontrar que filmes corresponden con qué catgeorias
	ON f.film_id = fc.film_id
GROUP BY c.name -- agrupamos por el nombre de categoria
HAVING promedio_duracion > 120; -- aplicamos el filtro solicitado

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT 
	a.first_name, -- seleccionamos las columnas que queremos ver
    a.last_name,
    COUNT(fa.film_id) AS total_peliculas -- usamos COUNT para contar la cantidad de peliculas en que actuo cada actor
FROM actor AS a
JOIN film_actor AS fa -- unimos la tabla film actor para correlacionar los actores con las peliculas
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name,a.last_name -- agrupamos los datos que necesitamos
HAVING COUNT(fa.film_id) >=5 -- usamos el filtro solicitado
ORDER BY total_peliculas; -- ordenamos los resultados

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT f.title -- seleccionamos la columna de titulo
FROM film AS f
WHERE f.film_id IN ( -- efectuamos una subconsulta para encontrar dentro de los alquileres, las que han estado alquiladas por mas de 5 dias
    SELECT i.inventory_id
    FROM inventory AS i 
    JOIN rental AS r ON r.inventory_id = i.inventory_id -- unimos la tabla inventory con rental para poder correlacionar las peliculas con los alquileres
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5 -- establecemos la duracion del alquiler mediante la diferencia entre fechas de alquiler y de retorno
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT 
    a.first_name, -- seleccionamos las columnas que necestiamos
    a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN ( -- usamos un condicional para excluir los resultados de la subconsulta 
    SELECT fa.actor_id
    FROM film_actor AS fa -- relacionamos las peliculas con su categoria
    JOIN film_category AS fc 
		ON fa.film_id = fc.film_id
    JOIN category AS c -- traemos los nombres de las categorias
		ON fc.category_id = c.category_id
    WHERE c.name = 'Horror' -- filtramos las peliculas de categoria Horror
);

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT
	f.title, -- seleccionamos las columnas a comparar
    f. length,
    c.name
FROM film AS f
JOIN film_category AS fc -- unimos la tabla film category para acceder a las categorias de cada film
	ON f.film_id = fc.film_id
JOIN category AS c -- usamos la tabla category para encontrar los nombres de cada categoria
	ON fc.category_id = c.category_id
WHERE c.name = "Comedy" AND f.length > 180; -- establecemos la condicion usando AND para definir que ambos supuestos se deben dar

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

SELECT 
    a1.first_name AS actor1_nombre, 
    a1.last_name AS actor1_apellido, -- establecemos los alias de cada tabla y de sus columnas para permitir la comparacion
    a2.first_name AS actor2_nombre,
    a2.last_name AS actor2_apellido,
    COUNT(*) AS peliculas_juntos -- contamos las peliculas en que han actuado
FROM film_actor AS fa1 -- usamos un self join para comparar los datos de actores qu estan en la misma tabla
JOIN film_actor AS fa2 
    ON fa1.film_id = fa2.film_id 
JOIN actor AS a1 -- unimos la tabla  actor para encontrar las peliculas en que han trabajado
	ON fa1.actor_id = a1.actor_id -- unimos el primer actor con la pelicula
JOIN actor AS a2 
	ON fa2.actor_id = a2.actor_id -- unimso el segundo actor con la pelicula
GROUP BY fa1.actor_id, fa2.actor_id, a1.first_name, a1.last_name, a2.first_name, a2.last_name
HAVING peliculas_juntos >= 1 -- estblecemos que hayan compartido al menos una peliciula
ORDER BY peliculas_juntos; -- ordenamos los resultados


