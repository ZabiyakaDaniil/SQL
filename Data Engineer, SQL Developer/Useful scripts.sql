/*Useful scripts*/
/*Большинство скриптов относятся к синтаксису Teradata. Но также есть и T-SQL, PostgreSQL и MySQL.*/

/*Создание таблицы по типу другой таблицы*/

CREATE TABLE TABLE_1
AS TABLE_2 WITH DATA --можно также указать WITH NO DATA, если необходимо создать пустую таблицу
;

/*При выборке из таблицы от даты отнять 1 день*/

SELECT 
DATE_ADD(DATE, INTERVAL -1 DAY)
FROM
TABLE_1
;

/*Выгрузка данных за прошлый месяц*/

SELECT *
FROM TABLE_1
WHERE 1=1
AND MONTH_ID = ADD_MONTHS_ID(MONTH_ID, -1)
;

/*Замена в таблице зарплаты сотрудника*/
UPDATE TABLE_1
SET SALARY =
CASE WHEN SALARY = 1000 THEN 2000 ELSE 3000
END
;

/*Извлечение месяца из даты*/

SELECT
EXTRACT(MONTH FROM DATE)
FROM TABLE_1

/*Проверка итоговых сумм в 2 таблицах*/

SELECT
MONTH_ID
,GOOD_ID
,SUM(SALES) AS SALES
FROM
(
  SELECT
  MONTH_ID
  ,GOOD_ID
  ,SUM(SALES) AS SALES
  FROM TABLE_1
  GROUP BY 1,2
  
  UNION ALL
  
  SELECT
  MONTH_ID
  ,GOOD_ID
  ,SUM(SALES * -1) AS SALES --сумму делаем со знаком "-", чтобы итог при объединении получился 0.
  FROM TABLE_2
  GROUP BY 1,2
) AS R
WHERE 1=1
GROUP BY 1,2
;

/*Найти дубли в поле*/

SELECT
GOOD_ID
,COUNT(GOOD_ID) AS GOOD_ID
FROM TABLE_1
GROUP BY 1
HAVING COUNT(GOOD_ID) > 1
;

/*Простой цикл WHILE.
Если средняя цена продуктов меньше 300, цикл удваивает цены, а затем выбирает максимальную.
В том случае, если максимальная цена меньше или равна 500, цикл повторяется и снова удваивает цены. 
Цикл продолжает удваивать цены до тех пор, пока максимальная цена не будет больше, чем 500, после чего выполнение цикла прекращается.*/

WHILE (
       SELECT
       AVG(PRICE)
       FROM TABLE_1
       ) < 300
BEGIN	
	UPDATE TABLE_1
	SET PRICE = PRICE * 2
	;
    SELECT 
    MAX(PRICE)
    FROM TABLE_1
    IF (
        SELECT
	    MAX(PRICE)
        FROM TABLE_1
        ) > 500
    BREAK;
END

/*Вывести вторые по величине продажи*/

SELECT
MAX(SALES) AS SALES
FROM TABLE_1
WHERE 1=1
AND SALES NOT IN 
(
SELECT
MAX(SALES)
FROM TABLE_1
)
;

/*Выбор четных значений*/

SELECT *
FROM TABLE_1
WHERE 1=1
AND ID % 2 = 0
;

/*Выбрать записи за 3 день февраля 2023 года*/

SELECT *
FROM TABLE_1
WHERE 1=1
AND YEAR(DATE) = 2023
AND MONTH(DATE) = 2
AND DAY(DATE) = 3
;

/*Обновление полей с порядковой нумерацией значений (в данной ситуации обновление будет начинаться с поля со значением 5)*/

UPDATE TABLE_1
SET GOOD_ID = GOOD_ID - 1
WHERE GOOD_ID >=5
;

/*Команда, позволяющая при создании или изменении процедуры игнорировать часть ошибок синтаксиса. Например, не нужно заранее создавать волатилки, чтобы CREATE/REPLACE PROCEDURE отработало корректно.*/

CREATE/REPLACE PROCEDURE PROCEDURE_1 (P_MONTH_ID INT)
SQL SECURITY INVOKER --команда
BEGIN
	...
;

/*Обновление поля таблицы с помощью джоина другой таблицы*/

UPDATE A
FROM TABLE_1 A, TABLE_2 B
SET GOOD_ID = B.GOOD_ID
WHERE A.MONTH_ID = B.MONTH_ID
AND COALESCE(A.ACC_ID, -1) = COALESCE(B.ACC_ID, -1) --добавляем коляску, так как, если в поле есть null, джоин не сработает.
AND COALESCE(A.CODE, -1) = COALESCE(B.CODE, -1)
;

/*Получить общие записи из двух таблиц (PostgreSQL)*/
 
SELECT GOOD_ID
FROM TABLE_1
INTERSECT
SELECT GOOD_ID
FROM TABLE_2
;



