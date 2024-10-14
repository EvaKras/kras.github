1. Составьте SQL-запрос, который выгружает данные по продажам аксессуаров за последний квартал для каждого магазина сети. Вам нужно:
•	Вывести код магазина, название товара, товарную группу, количество проданных единиц, выручку, долю выручки от общей выручки по товарной группе;
•	Отфильтровать данные по товарной группе "Сумки", выбрать магазины из городов Москва, Улан-Удэ, Новосибирск, исключить магазины с нулевыми продажами и закрытые магазины; 
•	Сгруппировать данные по магазину , группе товаров, наименование товара.


with tbl as (
select kod_rtt, srt.name, srt.gruppa, edinic, city, sr.kod, status, 
ROUND((summa*edinic),2) as Выручка, 
ROUND(((summa*edinic)/sum(summa*edinic) over(partition by gruppa)*100),2) as 'Доля_выручки_по_группе'
from cheki ch left join spr_rrt srt ON ch.kod_tovara = srt.kod
			 left join spr_rtt sr ON ch. kod_rtt = sr.kod
)
					
select kod_rtt, name, gruppa, sum(edinic), sum(Доля_выручки_по_группе)
from tbl
where name='Сумка' and 
		city in (' Москва', 'Улан-Удэ', 'Новосибирск') and 
		status != 0 and 
		kod not in (select sr.kod from cheki ch left join spr_rtt sr ON ch.kod_rtt = sr.kod	
					group by sr.kod
					having SUM(summa*edinic) = 0)
group by kod_rtt, name, gruppa

Исходные таблицы:
•	cheki: таблица с информацией о продажах
•	date – дата продажи;
•	document –  номер документа (чека);
•	kod_rtt –  код магазина;
•	kod_tovara – код товара:
•	summa – сумма оплаты за товар;
•	edinic – число единиц товара.

•	spr_rtt:  справочник по магазинам
•	kod – код магазина;
•	city – город расположения;
•	status – статус магазина (ОТКРЫТ/ЗАКРЫТ)

•	spr_rrt:  справочник по товарам
•	kod – код товара;
•	name – наименование товара;
•	gruppa – товарная группа.

2. Отнести каждого студента к группе,  в зависимости от пройденных заданий

create temporary table intervall
(Groupp text, Inerval text);
insert into intervall values ('I', 'от 0 до 10'),
							('II', 'от 11 до 15'),
							('III', 'от 16 до 27'), 
							('IV', 'больше 27');						
with tbl as (
select student_name, rate,
	case 
		when rate<=10 then 'I'
        WHEN rate <= 15 THEN 'II'
        WHEN rate <= 27 THEN 'III'
        ELSE 'IV'
	end as 'Группа'
from (select student_name, count(*) as rate 
		from (select student_name, step_id
				from student s left join step_student ss using(student_id)
				where result = 'correct'
				group by student_name, step_id) a
		group by student_name) b
);
select Группа, inerval as 'Интервал', count(student_name) as 'Количество'
from tbl left join intervall on tbl.Группа = intervall.groupp
group by Группа, Интервал
order by Группа;

Исходные таблицы:
•	student: таблица с информацией о студентах
•	student_id;
•	student_name - имя студента.

•	step_student: в этой таблице хранятся все попытки пользователей по каждому шагу
•	step_student_id;
•	step_id - номер шага;
•	student_id;
•	attempt_time - время начала попытки;
•	submission_time - время отправки задания на проверку;
•	result - результат.


