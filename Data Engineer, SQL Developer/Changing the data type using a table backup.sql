/*Изменение типа данных в столбце таблицы. Если поле является PI, то необходимо бэкапить таблицу*/

ALTER TABLE TABLE_TEST
ADD OBJECT_CODE VARCHAR(10)
;

/*Переименовываем таблицу, которую будем дублировать*/

RENAME TABLE TABLE_TEST AS TABLE_TEST_OLD
;

/*Берем синтаксис исходной таблицы*/

SHOW TABLE TABLE_TEST_OLD
;

/*Создаем таблицу, которую будем использовать как новую. Меняем в ней типы данных, которые нам необходимы*/

CREATE MULTISET TABLE TABLE_TEST ,FALLBACK
,NO BEFORE JOURNAL
,NO AFTER JOURNAL
,CHECKSUM = DEFAULT
,DEFAULT MERGEBLOCKRATIO
(
MONTH_ID INT
,GOOD_ID INT
,OBJECT_CODE VARCHAR(10) CHARACTER SET UNICODE NOT CASESPECIFIC
,SUMM FLOAT
)
PRIMARY INDEX (GOOD_ID, OBJECT_CODE)
;

/*Инсертим данные из старой в новую таблицу*/

INSERT INTO TABLE_TEST
SELECT *
FROM TABLE_TEST_OLD
;

/*Делаем проверку на соответствие сумм по полям*/

SELECT
MONTH_ID
,GOOD_ID
,OBJECT_CODE
,SUM(SUMM) AS SUMM --делаем агрегацию сумма
FROM
(
SELECT
MONTH_ID
,GOOD_ID
,OBJECT_CODE
,SUMM
FROM TEST_TABLE_OLD
UNION ALL --полностью соединяем таблицы
SELECT
MONTH_ID
,GOOD_ID
,OBJECT_CODE
,SUMM *-1 AS SUMM --сумму указываем с минусом, чтобы при агрегации получился 0
FROM TEST_TABLE
) AS R
WHERE MONTH_ID = 202301
GROUP BY 1,2,3
HAVING ABS(SUM(SUMM)) > 0.01 --указываем данное ограничение, чтобы не выпадало минимальных отклонений,
--которые при суммировании данных с типом FLOAT могут отличаться на сотые, тысячные и тд.
;

/*Проверяем кол-во строк в новой таблице*/

SELECT
CAST(COUNT(*) AS BIGINT) --если позволяет spool place, то можно без каста на бигинт сделать
FROM TABLE_TEST
;

/*Дропаем старую таблицу*/

DROP TABLE TABLE_TEST_OLD

