--Задача 1: Вывести имена всех людей, которые есть в базе данных авиакомпаний

SELECT name
FROM passenger;

--Задача 2: Вывести все рейсы, совершенные из Москвы

SELECT *
FROM trip
WHERE town_from = 'Moscow';

--Задача 3: Страна считается большой, если:её площадь составляет не менее 3 миллионов км² (3000000), или её население составляет не менее 25 миллионов человек (25000000). Напишите запрос для поиска названия (name), населения (population) и площади (area) больших стран.

SELECT name,
	population,
	area
FROM world
WHERE area >= 3000000
	OR population >= 25000000;

--Задача 4: Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)

SELECT DISTINCT plane
FROM trip
WHERE town_to = 'Moscow';

--Задача 5: Отчёт собирает сотрудников с зарплатой от 160000 — тех, кому положена надбавка. В выгрузку не попали сотрудники с зарплатой ровно 160000, хотя граница входит в диапазон. Выведите имя сотрудника и его зарплата.

SELECT e.name,
       e.salary
FROM employees e
WHERE e.salary > 160000;

--Задача 6: Вывести имена людей, которые заканчиваются на "man"

SELECT name
FROM passenger
WHERE name LIKE '%man';

--Задача 7: Сколько учениц с именем Анна  учится в школе?

SELECT COUNT(*)
FROM student
WHERE first_name = 'Anna';

--Задача 8: Вывести количество рейсов, совершенных на TU-134

SELECT COUNT (trip)
FROM trip
WHERE plane = 'TU-134';

--Задача 9: Посчитай доход с женской аудитории (доход = сумма(price * items)). Обратите внимание, что в таблице женская аудитория имеет поле user_gender «female» или «f».

SELECT SUM(price * items) AS income_from_female
FROM purchases
WHERE user_gender IN ('female', 'f');

--Задача 10: Выведите идентификатор и признак наличия интернета в помещении. Если интернет в сдаваемом жилье присутствует, то выведите «YES», иначе «NO».

SELECT id,
	CASE
		WHEN has_internet = true THEN 'YES'
		ELSE 'NO'
	END AS has_internet
FROM Rooms;

--Задача 11: Выведите поля id, home_type, price у всего жилья из таблицы Rooms. Если комната имеет телевизор и интернет одновременно, то в качестве цены в поле price выведите цену, применив скидку 10%.

SELECT id,
	home_type,
	CASE
		WHEN has_tv
		AND has_internet = true THEN price * 0.9
		ELSE price
	END AS price
FROM rooms;

--Задача 12: В таблице bets поле betting_type принимает значения sports, casino, poker, esports. Напишите запрос, который вернёт betting_type и avg_amount — средний размер ставки, округлённый до двух знаков. Отсортируйте по avg_amount по возрастанию.

SELECT betting_type,
	ROUND(AVG(bet_amount), 2) AS avg_amount
FROM bets
GROUP BY betting_type
ORDER BY avg_amount ASC;

--Задача 13: В таблице transactions хранятся транзакции пользователей Kaspi: user_id — пользователь, transaction_date — дата, amount — сумма. Аналитики выделяют VIP-пользователей — тех, кто за январь 2024 совершил более 5 транзакций. Выведите user_id и transactions_count (число транзакций за январь 2024) таких пользователей. Отсортируйте по user_id по возрастанию.

SELECT user_id,
	COUNT(*) AS transactions_count
FROM transactions
WHERE transaction_date >= '2024-01-01'
	AND transaction_date < '2024-02-01'
GROUP BY user_id
HAVING COUNT(*) > 5
ORDER BY user_id ASC;

--Задача 14: Посчитать количество работающих складов на текущую дату по каждому городу. Вывести только те города, у которых количество складов более 80. Данные на выходе - город, количество складов.

SELECT city,
	COUNT(*) AS warehouse_count
FROM warehouses
WHERE date_close IS NULL
GROUP BY city
HAVING COUNT(*) > 80;

--Задача 15: Вывести имена людей, у которых есть полный тёзка среди пассажиров

SELECT name
FROM passenger
GROUP BY name
HAVING COUNT(name) > 1;

--Задача 16: Выведите название страны, где находится город «Salzburg»

SELECT Countries.name AS country_name
FROM Cities
	JOIN Regions ON Cities.regionId = Regions.Id
	JOIN Countries ON Regions.countryId = Countries.Id
WHERE Cities.name = 'Salzburg';

--Задача 17: Какие компании совершали перелеты на Boeing

SELECT DISTINCT name
FROM Company
	JOIN Trip on Company.id = trip.company
WHERE plane = 'Boeing';

--Задача 18: Дана база данных с информацией о компаниях и их счетах. В таблице Company хранится информация о компаниях, в таблице Contract - информация о счетах, в таблице Company_contract - связи между компаниями и их счетами.Найти номера счетов (contract_number) по компаниям, в названии которых (company_name) встречается 'SBER'.

SELECT contract_number
FROM contract c
	JOIN company_contract cc ON cc.contract_id = c.contract_id
	JOIN company comp ON cc.company_id = comp.company_id
WHERE company_name LIKE '%SBER%';

--Задача 19: В какие города летал Bruce Willis

SELECT town_to
FROM trip
	JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
	JOIN Passenger ON Pass_in_trip.passenger = passenger.id
WHERE passenger.name = 'Bruce Willis';

--Задача 20: Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей по фамилии в алфавитном порядке.

SELECT DISTINCT Teacher.last_name
FROM Teacher
	JOIN Schedule on Teacher.id = Schedule.teacher
	JOIN Subject on Schedule.subject = Subject.id
WHERE Subject.name = 'Physical Culture'
ORDER BY Teacher.last_name;

--Задача 21: Выведите идентификаторы всех рейсов и количество пассажиров на них. Обратите внимание, что на каких-то рейсах пассажиров может не быть. В этом случае выведите число "0".
SELECT Trip.id,
	count(Pass_in_trip.id)
FROM Trip
	left JOIN Pass_in_trip on Pass_in_trip.trip = Trip.id
GROUP by Trip.id;

--Задача 22: Посчитайте население каждого региона. В качестве результата выведите название региона и его численность населения.

SELECT Regions.name AS region_name,
	sum(Cities.population) AS total_population
FROM Regions
	JOIN Cities on Cities.regionid = Regions.id
GROUP by Regions.name;

--Задача 23: Дана база данных с информацией о разработчиках и проектах. В таблице Developers хранится информация о разработчиках, в таблице Projects - информация о проектах, в таблице ProjectHistory - история работы разработчиков над проектами.Вывести все проекты (name), которые никогда не брались в работу разработчиками.

SELECT Projects.name
FROM Projects
	LEFT JOIN ProjectHistory ON Projects.id = ProjectHistory.project_id
WHERE ProjectHistory.id IS NULL;

--Задача 24: Вывести идентификатор, имя и количество перелётов каждого пассажира, совершившего хотя бы 1 полёт. Результат отсортировать по количеству перелётов (по убыванию) и имени (по возрастанию).

SELECT Passenger.id,
	Passenger.name,
	COUNT(Pass_in_trip.trip) AS count
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY Passenger.id,
	Passenger.name
ORDER BY count DESC,
	Passenger.name ASC;

--Задача 25: Выведите фамилию, имя и дату рождения студентов, кто был рожден в мае.

SELECT s.last_name,
	s.first_name,
	s.birthday
FROM student s
WHERE EXTRACT (MONTH FROM s.birthday) = 5;

--Задача 26: Создайте индекс idx_type_price для столбцов home_type и price таблицы Rooms.

CREATE INDEX idx_type_price ON Rooms(home_type, price);


--Задача 27: Найти имена всех матерей (mother)

SELECT member_name
FROM FamilyMembers
WHERE status = 'mother';

