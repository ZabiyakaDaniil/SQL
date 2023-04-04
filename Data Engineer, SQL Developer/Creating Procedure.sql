/*Создание процедуры. БД - TERADATA. Session mode - TERADATA DEFAULT*/
/*Проведенные расчеты в процедуре являются условными*/

CREATE PROCEDURE TEST_PROCEDURE (PAR_MONTH_ID INT)

BEGIN

DECLARE VAR_MONTH_ID INT;
SET VAR_MONTH_ID = PAR_MONTH_ID
;

/*1 Блок*/
/*Собираем входные данные для расчета*/

CREATE MULTISET VOLATILE TABLE VOLAT_SALES
(
    MONTH_ID INT
    ,GOOD_ID INT
    ,CLIENT_ID INT
    ,SALES FLOAT
)
PRIMARY INDEX (GOOD_ID)
ON 
COMMIT PRESERVE ROWS
;

INSERT INTO VOLAT_SALES
    SELECT
    A.MONTH_ID
    ,B.GOOD_ID
    ,A.CLIENT_ID
    ,SUM(SUMM) AS SALES
    FROM TABLE_SALES A
    LEFT JOIN GUIDE_GOODS B
              ON A.GOOD_ID = B.GOOD_ID
    WHERE 1=1
    AND A.MONTH_ID = VAR_MONTH_ID
    GROUP BY 1,2,3
;

/*Собираем статистику по таблице*/
      
COLLECT STAT
     COLUMN (MONTH_ID, GOOD_ID, CLIENT_ID)
     ,COLUMN (MONTH_ID)
     ,COLUMN(GOOD_ID)
     ,COLUMN(CLIENT_ID)
     ON VOLAT_SALES


/*Собираем  данные по себестоимости и потерям*/

CREATE MULTISET VOLATILE TABLE VOLAT_PRIMECOST_LOSS
(
     MONTH_ID INT
     ,GOOD_ID INT
     ,STORE_ID INT
     ,PRIMECOST FLOAT
     ,LOSS FLOAT
)
PRIMARY INDEX (GOOD_ID)
ON
COMMIT PRESERVE ROWS
;

INSERT INTO VOLAT_PRIMECOST_LOSS
     SELECT
     A.MONTH_ID
     ,A.GOOD_ID
     ,A.STORE_ID
     ,SUM(CASE WHEN A.CAPTION_ID IN (1, 3, 5) THEN A.SUMM ELSE 0 END) AS PRIMECOST --отбираем необходимые статьи
     ,SUM(CASE WHEN A.CAPTION_ID IN (2, 4, 6) THEN A.SUMM ELSE 0 END) AS LOSS --отбираем необходимые статьи
     FROM TABLE_CAPTION A
     JOIN VOLAT_SALES B
          ON A.GOOD_ID = B.GOOD_ID
     WHERE 1=1
     AND A.MONTH_ID = VAR_MONTH_ID
     GROUP BY 1,2,3
;

/*Собираем статистику по таблице*/
      
COLLECT STAT
     COLUMN (MONTH_ID, GOOD_ID, STORE_ID)
     ,COLUMN (MONTH_ID)
     ,COLUMN(GOOD_ID)
     ,COLUMN(STORE_ID)
     ON VOLAT_PRIMECOST_LOSS

/*Собираем  данные по остаткам*/     
     
CREATE MULTISET VOLATILE TABLE VOLAT_REST
(
     MONTH_ID INT
     ,GOOD_ID INT
     ,STORE_ID INT
     ,REST FLOAT
)
PRIMARY INDEX (GOOD_ID)
ON
COMMIT PRESERVE ROWS
;     

INSERT INTO VOLAT_REST
     SELECT
     A.MONTH_ID
     ,A.GOOD_ID
     ,A.STORE_ID
     ,SUM(A.SUMM_REST) AS REST
     FROM TABLE_REST A
     JOIN VOLAT_SALES B
          ON A.GOOD_ID = B.GOOD_ID
     WHERE 1=1
     AND A.MONTH_ID = ADD_MONTHS_ID(VAR_MONTH_ID, -1) --остатки берем за прошлый месяц
     GROUP BY 1,2,3
     HAVING SUM(A.SUMM_REST) > 0 --остатки берем только больше нуля
;

/*Собираем статистику по таблице*/
      
COLLECT STAT
     COLUMN (MONTH_ID, GOOD_ID, STORE_ID)
     ,COLUMN (MONTH_ID)
     ,COLUMN(GOOD_ID)
     ,COLUMN(STORE_ID)
     ON VOLAT_REST

/*2 Блок*/
/*Материализация данных*/

/*Создали таблицу для материализации*/
     
/*CREATE MULTISET TABLE TABLE_RESULT_MARGIN
(
     MONTH_ID INT
     ,GOOD_ID INT
     ,CLIENT_ID INT
     ,SALES FLOAT
     ,PRIMECOST FLOAT
     ,LOSS FLOAT
     ,REST FLOAT
     ,MARGIN FLOAT
)
PRIMARY INDEX (GOOD_ID)
;*/

/*Удаляем данные за текущий месяц (на случай, если до этого были залиты какие-то данные)*/
     
DELETE FROM TABLE_RESULT_MARGIN
WHERE MONTH_ID = VAR_MONTH_ID
;

/*Инсертим итоговые данные в таблицу материализации*/

INSERT INTO TABLE_RESULT_MARGIN
      SELECT
      MONTH_ID
      ,GOOD_ID
      ,CLIENT_ID
      ,SALES
      ,PRIMECOST
      ,LOSS
      ,REST
      ,SUM(SALES - (PRIMECOST + LOSS + REST)) AS MARGIN --формула расчета является условной
      FROM
          (
          SELECT
          A.MONTH_ID
          ,A.GOOD_ID
          ,A.CLIENT_ID
          ,COALESCE(SUM(A.SALES), 0) AS SALES
          ,COALESCE(B.PRIMECOST, 0) AS PRIMECOST
          ,COALESCE(B.LOSS, 0) AS LOSS
          ,COALESCE(C.REST, 0) AS REST
          FROM VOLAT_SALES A
               LEFT JOIN 
                        (
                        SELECT
                        MONTH_ID
                        ,GOOD_ID
                        ,SUM(PRIMECOST) AS PRIMECOST
                        ,SUM(LOSS) AS LOSS                       
                        FROM VOLAT_PRIMECOST_LOSS
                        WHERE 1=1
                        GROUP BY 1,2
                        ) AS B
                              ON A.GOOD_ID = B.GOOD_ID
               LEFT JOIN
                        (
                        SELECT
                        MONTH_ID
                        ,GOOD_ID
                        SUM(REST) AS REST
                        FROM VOLAT_REST
                        WHERE 1=1
                        GROUP BY 1,2
                        ) AS C
                              ON A.GOOD_ID = C.GOOD_ID
           WHERE 1=1
           ) AS R
         WHERE 1=1
         GROUP BY 1,2,3,4,5,6,7
;

/*Собираем статистику по таблице*/
      
COLLECT STAT
     COLUMN (MONTH_ID, GOOD_ID, CLIENT_ID)
     ,COLUMN (MONTH_ID)
     ,COLUMN(GOOD_ID)
     ,COLUMN(CLIENT_ID)
     ON TABLE_RESULT_MARGIN
;

COLLECT SUMMARY STATISTICS
     TABLE_RESULT_MARGIN
;

END
