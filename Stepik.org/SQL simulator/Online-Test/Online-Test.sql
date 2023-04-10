CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name_subject varchar(30)
);

INSERT INTO subject (subject_id,name_subject) VALUES 
    (1,'Основы SQL'),
    (2,'Основы баз данных'),
    (3,'Физика');

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name_student varchar(50)
);

INSERT INTO student (student_id,name_student) VALUES
    (1,'Баранов Павел'),
    (2,'Абрамова Катя'),
    (3,'Семенов Иван'),
    (4,'Яковлева Галина');

CREATE TABLE attempt (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    date_attempt date,
    result INT,
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO attempt (attempt_id,student_id,subject_id,date_attempt,result) VALUES
    (1,1,2,'2020-03-23',67),
    (2,3,1,'2020-03-23',100),
    (3,4,2,'2020-03-26',0),
    (4,1,1,'2020-04-15',33),
    (5,3,1,'2020-04-15',67),
    (6,4,2,'2020-04-21',100),
    (7,3,1,'2020-05-17',33);

CREATE TABLE question (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    name_question varchar(100), 
    subject_id INT,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO question (question_id,name_question,subject_id) VALUES
    (1,'Запрос на выборку начинается с ключевого слова:',1),
    (2,'Условие, по которому отбираются записи, задается после ключевого слова:',1),
    (3,'Для сортировки используется:',1),
    (4,'Какой запрос выбирает все записи из таблицы student:',1),
    (5,'Для внутреннего соединения таблиц используется оператор:',1),
    (6,'База данных - это:',2),
    (7,'Отношение - это:',2),
    (8,'Концептуальная модель используется для',2),
    (9,'Какой тип данных не допустим в реляционной таблице?',2);

CREATE TABLE answer (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    name_answer varchar(100),
    question_id INT,
    is_correct BOOLEAN,
    CONSTRAINT answer_ibfk_1 FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);

INSERT INTO answer (answer_id,name_answer,question_id,is_correct) VALUES
    (1,'UPDATE',1,FALSE),
    (2,'SELECT',1,TRUE),
    (3,'INSERT',1,FALSE),
    (4,'GROUP BY',2,FALSE),
    (5,'FROM',2,FALSE),
    (6,'WHERE',2,TRUE),
    (7,'SELECT',2,FALSE),
    (8,'SORT',3,FALSE),
    (9,'ORDER BY',3,TRUE),
    (10,'RANG BY',3,FALSE),
    (11,'SELECT * FROM student',4,TRUE),
    (12,'SELECT student',4,FALSE),
    (13,'INNER JOIN',5,TRUE),
    (14,'LEFT JOIN',5,FALSE),
    (15,'RIGHT JOIN',5,FALSE),
    (16,'CROSS JOIN',5,FALSE),
    (17,'совокупность данных, организованных по определенным правилам',6,TRUE),
    (18,'совокупность программ для хранения и обработки больших массивов информации',6,FALSE),
    (19,'строка',7,FALSE),
    (20,'столбец',7,FALSE),
    (21,'таблица',7,TRUE),
    (22,'обобщенное представление пользователей о данных',8,TRUE),
    (23,'описание представления данных в памяти компьютера',8,FALSE),
    (24,'база данных',8,FALSE),
    (25,'file',9,TRUE),
    (26,'INT',9,FALSE),
    (27,'VARCHAR',9,FALSE),
    (28,'DATE',9,FALSE);

CREATE TABLE testing (
    testing_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT,
    question_id INT,
    answer_id INT,
    FOREIGN KEY (attempt_id) REFERENCES attempt (attempt_id) ON DELETE CASCADE
);

INSERT INTO testing (testing_id,attempt_id,question_id,answer_id) VALUES
    (1,1,9,25),
    (2,1,7,19),
    (3,1,6,17),
    (4,2,3,9),
    (5,2,1,2),
    (6,2,4,11),
    (7,3,6,18),
    (8,3,8,24),
    (9,3,9,28),
    (10,4,1,2),
    (11,4,5,16),
    (12,4,3,10),
    (13,5,2,6),
    (14,5,1,2),
    (15,5,4,12),
    (16,6,6,17),
    (17,6,8,22),
    (18,6,7,21),
    (19,7,1,3),
    (20,7,4,11),
    (21,7,5,16);

-- Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.

select s.name_student, a.date_attempt, a.result
from student s
join attempt a using (student_id)
join subject sj using (subject_id)
where sj.name_subject like 'Основы баз данных'
order by a.result desc
;

-- Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой.
-- Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.
-- В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.

select s.name_subject, count(a.attempt_id) as Количество, round(avg(result), 2) as Среднее
from subject s
left join attempt a using (subject_id)
group by s.name_subject
order by Среднее desc
;

-- Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.

select s.name_student, a.result
from student s
join attempt a using (student_id)
where a.result = (
    select max(result)
    from attempt)
order by s.name_student
;

-- Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой.
 -- В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы.
 -- Студентов, сделавших одну попытку по дисциплине, не учитывать.
 
 select s.name_student, sj.name_subject, datediff(max(a.date_attempt), min(a.date_attempt)) as Интервал
from student s
join attempt a using (student_id)
join subject sj using (subject_id)
group by s.name_student, sj.name_subject
having Интервал <> 0
order by Интервал
;

-- Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем)
-- Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование .
-- Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины.
-- В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.

select s.name_subject, count(distinct a.student_id) as Количество
from subject s
left join attempt a using (subject_id)
group by s.name_subject
order by Количество desc, s.name_subject
;

-- Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.

select q.question_id, q.name_question
from question q
join subject s using (subject_id)
where s.name_subject like 'Основы баз данных'
order by rand()
limit 3
;

-- Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7).
-- Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.

select q.name_question, a.name_answer, if(a.is_correct=1, 'Верно', 'Неверно') as Результат
from question q
join testing t using (question_id)
join answer a using (answer_id)
where t.attempt_id=7
;

-- Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) 
-- и умноженное на 100.
-- Результат округлить до двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат.
-- Последний столбец назвать Результат. Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.

select s.name_student, sj.name_subject, a.date_attempt, round((sum(an.is_correct)/3)*100 ,2) as Результат
from student s
join attempt a using (student_id)
join testing t using (attempt_id)
join subject sj using (subject_id)
join answer an using (answer_id)
group by s.name_student, sj.name_subject, a.date_attempt
order by s.name_student, a.date_attempt desc
;

-- Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству ответов, значение округлить
-- до 2-х знаков после запятой.
-- Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос.
-- В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность.
-- Информацию отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.

SELECT 
Название_дисциплины
,Вопрос
,Всего_ответов
,ROUND(100*Количество_верных_ответов/Всего_ответов, 2) AS Успешность
FROM
(
SELECT
A.NAME_SUBJECT AS Название_дисциплины
,CONCAT(LEFT(B.NAME_QUESTION, 30), "...") AS Вопрос
,COUNT(D.ANSWER_ID) AS Всего_ответов
,SUM(C.IS_CORRECT) AS Количество_верных_ответов
FROM subject A
JOIN question B USING (SUBJECT_ID)
JOIN answer C USING (QUESTION_ID)
JOIN testing D USING (ANSWER_ID)
GROUP BY 
A.NAME_SUBJECT
,B.NAME_QUESTION
) AS R
ORDER BY 1, 4 DESC, 2
;

-- В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.

INSERT INTO attempt
SELECT 
8 AS ATTEMPT_ID
,A.STUDENT_ID
,C.SUBJECT_ID
,NOW() AS DATE_ATTEMPT
,NULL
FROM student A
JOIN attempt B USING (STUDENT_ID)
JOIN subject C USING (SUBJECT_ID)
WHERE 1=1
AND A.NAME_STUDENT LIKE 'Баранов Павел'
AND C.NAME_SUBJECT LIKE 'Основы баз данных'
;

-- Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент,
-- занесенный в таблицу attempt последним, и добавить их в таблицу testing.
-- Id последней попытки получить как максимальное значение id из таблицы attempt.

INSERT INTO testing (ATTEMPT_ID, QUESTION_ID, ANSWER_ID)
SELECT
B.ATTEMPT_ID
,A.QUESTION_ID
,NULL
FROM question A
JOIN attempt B USING (SUBJECT_ID)
WHERE B.ATTEMPT_ID = 
(
    SELECT MAX(ATTEMPT_ID)
    FROM attempt
)
ORDER BY RAND()
LIMIT 3
;

-- Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), 
-- далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.
-- Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. 
-- Результат округлить до целого.
-- id попытки,  для которой вычисляется результат, в нашем случае это 8.

UPDATE attempt
SET RESULT =
(
SELECT
ROUND(SUM(B.IS_CORRECT)/3*100, 0)
FROM testing A
JOIN answer B USING (ANSWER_ID)
WHERE ATTEMPT_ID = 8
)
WHERE ATTEMPT_ID = 8
;
