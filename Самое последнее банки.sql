--это однострочный коментарий
/* 
 * это многострочный коментарий
 */

--запрос для вывода всех строк таблицы
SELECT *
FROM clients_churn;

--запрос для вывода 10 строк таюлицы
SELECT *
FROM clients_churn
LIMIT 10;

-- запрос для выбора столбцов
SELECT user_id, city, gender, age, churn
FROM clients_churn
LIMIT 10;
-- или можно так (можжно пропустить пару стро после лимит ставим число, запятая и следующие число)
SELECT user_id, 
city, 
gender, 
age, 
churn
FROM clients_churn
LIMIT 5, 10; --- или лимит 10 offset 5

--как назвать столбец как надо, если слов 2 то ставятся кавычки "идентификатор пользователя"
SELECT cc.user_id AS "идентификатор пользователя", 
city AS Город, 
gender AS Пол, 
age AS возраст, 
churn
FROM clients_churn cc
LIMIT 10;

/*
 * Просмотр уникальных значений поля (то есть смотри у тебя кучу женщин и мужчин, а среди них еще оказалось лишнее среднее, и он выведет ж, м и среднее)
 * Оператор distinct
 * Задание:
 * вывести уникальные значение столбцов "city" и "gender"
 */
 -- код запроса
 
SELECT DISTINCT city 
FROM clients_churn cc;

-- а тут комбинация признаков то есть, если в городе Я если нет мужчин, то не будет я м
SELECT DISTINCT gender, city  
FROM clients_churn cc;
 
 /*
  * Количество значений и группа
  * Оператор count
 */

-- код запроса подсчитать количество строк в таблице
SELECT COUNT(*) AS "КОЛИЧЕСТВО СТРОК"
FROM clients_churn cc;

-- посчитать количество уникальных значений для стобцов возраст и баланс

SELECT COUNT(age) as "Количество строк с возрастом", 
COUNT(balance) as "Количество строк с балансом",
COUNT(DISTINCT balance) as "Уникальные значение баланса"
FROM clients_churn cc;
/*  Обратите внимание на то, что функция COUNT() с переданным именем столбца не учитывает значения NULL (пропущенное значение, то есть его нет) в этом столбце; 
это делает функция COUNT(*), которая подсчитывает все строки независимо от их значений. 
Если же не рассматривать значения NULL, то функция COUNT() игнорирует значения данных в столбце и просто подсчиты вает их количество.
*/

/*Вычисляемые столбцы
Функции: ABS, AVG(выборочное целое), COUNT, MAX, MIN, ROUND(округлить - пример, цифра после запятой) , SUM
Математические функции: https://www.sqlite.org/lang_mathfunc.html
Задание:
- создать новый столбец `nalog`, значения которого рассчитываются по следующей формуле: nalog = 0.13*estimated_salary */

SELECT estimated_salary,
ROUND(0.13*estimated_salary , 2) as "Минус налог"
FROM clients_churn cc;

SELECT estimated_salary,
balance,
ROUND(0.13*estimated_salary+balance, 2) as "Минус налог"
FROM clients_churn cc;

-- как бороться с нул? Дойдем вроде как, но надо наверное к нулю его прировнять

SELECT MIN(estimated_salary) ,
MAX(estimated_salary)
FROM clients_churn cc;

SELECT AVG(balance), -- или так считать выборочное среднее
SUM (balance)/COUNT(*), --здесь стоит общее количество строк , то есть он складывает нул, как ноль и учитывает эту строку при делении--  так не надо
SUM (balance)/COUNT(balance) -- а здесь количество строк в балансе, то есть тут нет нуля, так правильно считать выборочное среднее
FROM clients_churn cc;

/*Отбор строк
Оператор where

Для отбора строк используется предложение WHERE.
Для каждой из строк условие отбора может иметь одно из трех перечисленных ниже значений.
• Если условие отбора имеет значение TRUE, строка будет включена в результаты запроса.
• Если условие отбора имеет значение FALSE, то строка исключается из результатов запроса.
• Если условие отбора имеет значение NULL, то строка исключается из результатов запроса.

Когда СУБД сравнивает значения двух выражений, могуг быть получены три результата:
• если сравнение истинно, то результат проверки имеет значение TRUE;
• если сравнение ложно, то результат проверки имеет значение FALSE;
• если хотя бы одно из двух выражений имеет значение NULL, то результатом сравнения будет NULL. 
*/

/*Рассмотрим пять основных условий отбора:
- Сравнение. Значение одного выражения сравнивается со значением другого выражения;


- Проверка на соответствие шаблону. Проверяется, соответствует ли строковое значение, содержащееся в столбце, определенному шаблону;
- Проверка на равенство значению NULL. Проверяется, содержится ли в столбце значение NULL.
Задание: 
- вывести список клиентов банка, проживающих в `Город_Р и имеющих доход больше 20000.
- вывести список клиентов банка, проживающих в `Город_Р` в возрасте от 35 до 50 лет.
- вывести список клиентов банка, проживающих в `Город_Р` и в возрасте либо 35, либо 50 лет.
*/

SELECT *
FROM clients_churn cc 
WHERE city = "Город_Р" and estimated_salary > "20000";

--Как можно себя перепроверить (Не поняла почему так, можно поразбираться)
SELECT DISTINCT city,
MIN (estimated_salary) 
FROM clients_churn cc 
WHERE city = "Город_Р" and estimated_salary > "20000";

-- Проверка на принадлежность диапазону. Проверяется, попадает ли указанное значение в определенный диапазон значений (between и not between); 
SELECT *
FROM clients_churn cc 
WHERE city = "Город_Р" and age BETWEEN 35 and 50;

--  а можно beetwen not

SELECT *
FROM clients_churn cc 
WHERE NOT city = "Город_Р" and age NOT BETWEEN 35 and 50; -- Не в городе Р и все возраста помимо 35 и 50

-- - Проверка наличия во множестве. Проверяется, совпадает ли значение выражения с одним из значений из заданного множества;
-- вывести список клиентов банка, проживающих в `Город_Р` и в возрасте либо 35, либо 50 лет.

SELECT *
FROM clients_churn cc 
WHERE city = "Город_Р" and age = 35 OR city = "Город_Р" and age = 50;

SELECT *
FROM clients_churn cc 
WHERE city = "Город_Р" and age IN (35,50);

- просто проверила
SELECT COUNT(*) 
FROM clients_churn cc
where age IN (35, 50) AND city = 'Город_Р';

--  Проверка на равенство значению NULL. Проверяется, содержится ли в столбце значение NULL.
-- null не ноль а пропущенное значчение
SELECT *
FROM clients_churn cc 
WHERE balance is NULL 

SELECT * 
FROM clients_churn cc 
WHERE NULL 

SELECT *
FROM clients_churn cc 
WHERE balance is NOT NULL

/*
Сортировка результата запроса
Оператор ORDER ВY
Параметр:
- `ASC` (по возрастанию) 
- `DESC` (по убыванию)
*/

select min(age),
       max(age)
from clients_churn
where gender='Ж'

select min(age),
       max(age)
from clients_churn
where gender='М';

SELECT min(age),
       max(age),
       gender 
FROM clients_churn cc 
GROUP BY gender;

SELECT min(estimated_salary),
       max(estimated_salary),
       min(age),
       max(age),
       gender 
FROM clients_churn cc 
GROUP BY gender;

-- найдем средний заработную плату клиентов в каждом городе

SELECT city,
avg(estimated_salary) as "средняя зп"
FROM clients_churn cc 
GROUP BY city, gender

SELECT city,
gender,
round(avg(estimated_salary),2) as "средняя зп"
FROM clients_churn cc 
GROUP BY city, gender;  

SELECT DISTINCT gender, city 
FROM clients_churn cc;


select city,
       gender,
       round(avg(estimated_salary),2) as "средняя зп"
from clients_churn
group by city, gender
order by estimated_salary ASC  -- поумолчанию групируется по возрастанию, еще есть метка ASC, DECS -это по убыванию

select city,
       gender,
       round(avg(estimated_salary),2) as "средняя зп"
from clients_churn
group by city, gender
order by  gender ASC, estimated_salary ASC -- сначала сортирует по гендеру, затем по зп от меньшего к болшему, первый признак главный и если будет противоречить второму то сортировка будет только по одному первому признаку

--group by и having, накладывает ограничения 

select city,
       gender,
       round(avg(estimated_salary),2) as "средняя зп"
from clients_churn
group by city, gender
having "средняя зп" > 100000
order by "средняя зп";

-- в каждом городе посчитаем количество ушедших и оставшихся клиентов  (churn-0 stay, 1-go)

SELECT city,
churn, 
COUNT(churn) 
FROM clients_churn cc 
GROUP BY city, churn 

SELECT city,
churn, 
COUNT(churn) AS "сумма"
FROM clients_churn cc 
GROUP BY city, churn 
order by city, COUNT(churn) DESC;

-- посчитать количество клиентов, которое пользуется определенным количеством продуктов
 
SELECT city ,
products ,
COUNT(user_id) 
FROM clients_churn cc 
GROUP BY city, products 
HAVING products >= 2


SELECT products, 
COUNT(user_id)  -- count считает складывает числа в колонке а сколько колонок
FROM clients_churn cc 
GROUP BY products 


-- where условия на исходную таблицу, having -условия на груп бай то есть на уже модернизацию


select city, 
       products, 
       count(user_id)
from clients_churn
group by city, products 
having city != 'Город_Р';

/*
------------------ Подзапросы ----------------------
Подзапрос – это запрос внутри запроса. 
Первый запрос называется внешним, второй запрос называется внутренним или вложенным.

Подзапрос всегда заключен в круглые скобки и выполняется перед содержащей инструкцией. 
Подобно любому запросу, подзапрос возвращает результирующий набор, который может состоять из:
- одной строки с одним столбцом;
- нескольких строк с одним столбцом;
- нескольких строк с несколькими столбцами.

В выражении SELECT подзапросы могут вводиться четырьмя способами:
- в условии в выражении `WHERE`;
- в условии в выражении `HAVING`;
- в качестве таблицы для выборки в выражении `FROM`;
- в качестве спецификации столбца в выражении `SELECT`. - он должен возвращать 1 значение

Задание:
- вывести всех клиентов банка, проживающих в городах `Город_Я`, `Город_Р`;
- вывести всех клиентов банка, имеющих баланс выше среднего;
- вывести количество клиентов, проживающих в городах `Город_Я`, `Город_Р`.
- посчитать процент клиентов, проживающих в каждом городе;
- посчитать процент оставшихся и ушедших клиентов, проживающих в каждом городе. 
*/
--- вывести всех клиентов банка, проживающих в городах `Город_Я`, `Город_Р`;
SELECT *
FROM clients_churn cc 
WHERE city = 'Город_Я' or city = 'Город_Р'
ORDER BY city ASC 

SELECT *
FROM clients_churn cc 
WHERE city IN ('Город_Я', 'Город_Р')
ORDER BY city ASC

SELECT * 
FROM (SELECT * FROM clients_churn cc WHERE city IN ('Город_Я', 'Город_Р'))

--вывести всех клиентов банка, имеющих баланс выше среднего;
SELECT user_id,
balance 
FROM clients_churn cc 
WHERE balance > (SELECT AVG(balance) FROM clients_churn cc2 )
ORDER BY balance DESC  

SELECT AVG(balance)
FROM clients_churn cc 

-- вывести количество клиентов, проживающих в городах `Город_Я`, `Город_Р`
SELECT COUNT(user_id),
city 
FROM clients_churn cc 
GROUP BY city 
HAVING city IN ('Город_Я', 'Город_Р')
ORDER BY city ASC

SELECT COUNT(user_id),
city 
FROM (SELECT * FROM clients_churn cc  WHERE city IN ('Город_Я', 'Город_Р'))
GROUP BY CITY

-- посчитать процент клиентов, проживающих в каждом городе;

/*
Результат должен быт примерно тамим
Город_Р  n1 / (n1+n2+n3) * 100
Город_В  n2 / (n1+n2+n3) * 100
Город_Я  n3 / (n1+n2+n3) * 100
*/

SELECT city,
COUNT(user_id) 
FROM clients_churn cc 
GROUP BY city   

SELECT city,
COUNT(user_id) how_much ,
COUNT(user_id) * 100.0 / (SELECT COUNT(*) FROM clients_churn cc) '%'
FROM clients_churn cc 
GROUP BY city   

ooor

SELECT city,
COUNT(user_id) how_much ,
COUNT(user_id) * 100.0 / 2 '%'
FROM clients_churn cc, (select COUNT(*) as '1' 
                       from clients_churn cc2) as '2'
GROUP BY city   

-- - посчитать процент оставшихся и ушедших клиентов, проживающих в каждом городе. 
/*
Результат должен быт примерно тамим

 Город   Уход  Количество  Процент
Город_Р   0     n10  	   n10 / n1
Город_Р   1     n11    	   n11 / n1
Город_В   0     n20  	   n20 / n2
Город_В   1     n21    	   n21 / n2
Город_Я   0     n30   	   n30 / n3
Город_Я   1     n31  	   n31 / n3
*/
--left tabble
SELECT city,
churn,
COUNT(user_id) how_much 
FROM clients_churn cc
GROUP BY city, churn   
--right table
SELECT city,
COUNT(user_id) how_much 
FROM clients_churn cc
GROUP BY city 

-- объединение двух таблиц из подзапросов 
SELECT tbl1.city,
tbl1.churn,
tbl1.how_much,
ROUND(tbl1.how_much*100.0/tbl2.how_much, 2) as "%"
FROM (SELECT city, churn,
      COUNT(user_id) how_much 
      FROM clients_churn cc
      GROUP BY city, churn) as 'tbl1'
inner join (SELECT city, COUNT(user_id) how_much 
            FROM clients_churn cc
            GROUP BY city) as 'tbl2'
ON tbl1.city = tbl2.city


