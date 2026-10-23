--Задача 1: Выгрузите из таблицы staff дни рождения сотрудников. Необходимые значения в виде строк хранит поле birth_date. Сформируйте запрос так, чтобы на экране отобразилась только дата.

SELECT CAST(birth_date AS date)
FROM staff;

--Задача 2: Из таблицы invoice выгрузите заказы, оформленные не раньше 6 января 2009 года. В итоговую таблицу должен войти идентификатор invoice_id, страна оформления заказа и дата в формате 'YYYY-MM-DD'.

SELECT invoice_id,
       billing_country,
       CAST (invoice_date AS date)
FROM invoice
WHERE CAST (invoice_date AS date)>= '2009-01-06';

--Задача 3: Выгрузите адреса (billing_address) и города (billing_city) оформления заказов (invoice), сделанных в сентябре 2009 года. Отберите данные о заказах, оформленных во всех странах (billing_country), кроме США и Бразилии. Стоимость заказа (total) должна быть больше двух долларов.

SELECT billing_address,
       billing_city
FROM invoice
WHERE CAST (invoice_date AS date) <= '2009.09.30' 
AND CAST (invoice_date AS date) >= '2009.09.01'
AND billing_country <> 'USA'
AND billing_country <> 'Brazil'
AND total > 2;

--Задача 4: Из таблицы с треками отберите названия композиций, которые соответствуют условиям. В итоговую таблицу должны войти:треки длиннее 300000 миллисекунд, в создании которых принимал участие Bono, с идентификаторами жанра 7, 8, 9, 10; либо треки, размер которых превышает 1000000000 байт.

SELECT name
FROM track
WHERE milliseconds > 300000 
AND (composer LIKE '%Bono%' AND  genre_id IN (7,8,9,10))
OR bytes > 1000000000;

--Задача 5: Выгрузите из таблицы staff адреса электронной почты сотрудников из города Калгари (англ. Calgary), которых наняли на работу в 2002 году.

SELECT email
FROM staff
WHERE city = 'Calgary'
AND EXTRACT (YEAR FROM hire_date)= 2002;

--Задача 6: Найдите треки длиннее 250000 миллисекунд, в названии которых есть слово Moon, но автор трека не указан.Выгрузите номера альбомов, в которых находятся выбранные треки.

SELECT album_id
FROM track
WHERE milliseconds > 250000 
AND name LIKE '%Moon%'
AND composer IS NULL;

--Задача 7: Теперь попробуйте разделить на категории фильмы из таблицы movie. Выведите на экран поля title и rental_rate. Выделить категории нужно по цене аренды фильма:Если значение rental_rate меньше 1, в новом поле появится категория 'категория 1'.Если значение rental_rate больше либо равно 1, но меньше 3, в новом поле отобразится категория 'категория 2'.Если значение rental_rate больше либо равно 3, в новом поле появится категория 'категория 3'.

SELECT title,
       rental_rate,
         CASE
          WHEN rental_rate < 1 THEN 'категория 1'
          WHEN rental_rate >=1 AND rental_rate <3 THEN 'категория 2'
          WHEN rental_rate >=3 THEN 'категория 3'
          END
FROM movie;

--Задача 8: Добавьте к минимуму и максимуму несколько новых полей:среднее значение поля total, округлённое до ближайшего целого числа; количество уникальных идентификаторов покупателей из поля customer_id; суммарная выручка.Не меняйте условия для среза данных.

SELECT MIN(total),
       MAX(total),
       ROUND (AVG(total)),
       COUNT(DISTINCT customer_id),
       SUM(total)
FROM invoice
WHERE EXTRACT(MONTH FROM CAST(invoice_date AS timestamp)) = 9
  AND customer_id in (11, 13, 44, 36, 48, 52, 54, 56);

--Задача 9: Создайте новое поле с категориями: заказы на сумму меньше одного доллара получат категорию 'low cost';заказы на сумму от одного доллара и выше получат категорию 'high cost'. Для каждой категории посчитайте сумму значений в поле total, но только для тех заказов, при оформлении которых указан почтовый код. В итоговую таблицу должны войти только два поля.

SELECT CASE
      WHEN total < 1 THEN 'low cost'
      WHEN total >= 1 THEN 'high cost'
      END,
      SUM (total)
FROM invoice
WHERE billing_postal_code IS NOT NULL
GROUP BY CASE
      WHEN total < 1 THEN 'low cost'
      WHEN total >= 1 THEN 'high cost'
      END;

--Задача 10: Посчитайте пропуски в поле с почтовым индексом billing_postal_code для каждой страны (поле billing_country). Получите срез: в таблицу должны войти только те записи, в которых поле billing_address не содержит слов Street, Way, Road или Drive. Отобразите в таблице страну и число пропусков, если их больше 10. Помните, что COUNT() не считает пропуски, если внутри функции указать поле. Функция подсчитает пропуски, если считать строки методом COUNT(*).

SELECT billing_country,
       COUNT(*)
FROM invoice
WHERE billing_postal_code IS NULL
AND  NOT (billing_address LIKE'%Street%'
OR billing_address LIKE'%Way%'
OR billing_address LIKE'%Road%'
OR billing_address LIKE'%Drive%')
GROUP BY billing_country
HAVING COUNT(*) > 10;

--Задача 11: Разделите фильмы на категории: 'без ограничений' — если у фильма рейтинг G.'с ограничениями' — если у фильма любой рейтинг, кроме G.Новое поле с категориями назовите new_rating. Сгруппируйте данные по новому полю и посчитайте суммарную цену аренды фильмов для каждой категории.

SELECT CASE
           WHEN rating = 'G' THEN 'без ограничений'
           WHEN rating !='G' THEN 'с ограничениями'
           END AS new_rating,
           SUM(rental_rate)
FROM movie
GROUP BY new_rating;

--Задача 12: Массовую любовь к музыке 90-х можно понять. А как обстоит дело с жанрами — какие популярнее? Сгруппируйте данные по жанрам и посчитайте количество заказов. Выведите на экран два поля: одно с названием жанра, второе — с количеством купленных треков этого жанра. Отсортируйте таблицу по убыванию количества заказов.

SELECT  g.name,
       COUNT(il.invoice_id) AS all_count
FROM invoice_line AS il
JOIN track AS t ON il.track_id=t.track_id
JOIN genre AS g ON t.genre_id=g.genre_id
GROUP BY g.name
ORDER BY all_count DESC;