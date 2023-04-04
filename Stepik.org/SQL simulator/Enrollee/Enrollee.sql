CREATE TABLE department(
    department_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_department VARCHAR(30)
);
INSERT INTO department(name_department)
VALUES
    ('Инженерная школа'),
    ('Школа естественных наук');

CREATE TABLE subject(
    subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_subject VARCHAR(30)
);
INSERT INTO subject(name_subject)
VALUES
    ('Русский язык'),
    ('Математика'),
    ('Физика'),
    ('Информатика');

CREATE TABLE program(
    program_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_program VARCHAR(50),
    department_id INT,
    plan INT,
    FOREIGN KEY department(department_id) REFERENCES department(department_id) ON DELETE CASCADE
);
INSERT INTO program(name_program, department_id, plan)
VALUES
    ('Прикладная математика и информатика', 2, 2),
    ('Математика и компьютерные науки', 2, 1),
    ('Прикладная механика', 1, 2),
    ('Мехатроника и робототехника', 1, 3);

CREATE TABLE enrollee(
    enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_enrollee VARCHAR(50)
);
INSERT INTO enrollee(name_enrollee)
VALUES
    ('Баранов Павел'),
    ('Абрамова Катя'),
    ('Семенов Иван'),
    ('Яковлева Галина'),
    ('Попов Илья'),
    ('Степанова Дарья');

CREATE TABLE achievement(
    achievement_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_achievement VARCHAR(30),
    bonus INT
);
INSERT INTO achievement(name_achievement, bonus)
VALUES
    ('Золотая медаль', 5),
    ('Серебряная медаль', 3),
    ('Золотой значок ГТО', 3),
    ('Серебряный значок ГТО    ', 1);

CREATE TABLE enrollee_achievement(
    enrollee_achiev_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    achievement_id INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY achievement(achievement_id) REFERENCES achievement(achievement_id) ON DELETE CASCADE
);
INSERT INTO enrollee_achievement(enrollee_id, achievement_id)
VALUES
    (1, 2),
    (1, 3),
    (3, 1),
    (4, 4),
    (5, 1),
    (5, 3);

CREATE TABLE program_subject(
    program_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    subject_id INT,
    min_result INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO program_subject(program_id, subject_id, min_result)
VALUES
    (1, 1, 40),
    (1, 2, 50),
    (1, 4, 60),
    (2, 1, 30),
    (2, 2, 50),
    (2, 4, 60),
    (3, 1, 30),
    (3, 2, 45),
    (3, 3, 45),
    (4, 1, 40),
    (4, 2, 45),
    (4, 3, 45);

CREATE TABLE program_enrollee(
    program_enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    enrollee_id INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE
);
INSERT INTO program_enrollee(program_id, enrollee_id)
VALUES
    (3, 1),
    (4, 1),
    (1, 1),
    (2, 2),
    (1, 2),
    (1, 3),
    (2, 3),
    (4, 3),
    (3, 4),
    (3, 5),
    (4, 5),
    (2, 6),
    (3, 6),
    (4, 6);

CREATE TABLE enrollee_subject(
    enrollee_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    subject_id INT,
    result INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO enrollee_subject(enrollee_id, subject_id, result)
VALUES
    (1, 1, 68),
    (1, 2, 70),
    (1, 3, 41),
    (1, 4, 75),
    (2, 1, 75),
    (2, 2, 70),
    (2, 4, 81),
    (3, 1, 85),
    (3, 2, 67),
    (3, 3, 90),
    (3, 4, 78),
    (4, 1, 82),
    (4, 2, 86),
    (4, 3, 70),
    (5, 1, 65),
    (5, 2, 67),
    (5, 3, 60),
    (6, 1, 90),
    (6, 2, 92),
    (6, 3, 88),
    (6, 4, 94);
    
-- Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде. 
 
SELECT
A.NAME_ENROLLEE
FROM enrollee A
JOIN program_enrollee B USING (ENROLLEE_ID)
JOIN program C USING (PROGRAM_ID)
WHERE C.NAME_PROGRAM LIKE 'Мехатроника и робототехника'
ORDER BY A.NAME_ENROLLEE
;

-- Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.

SELECT A.NAME_PROGRAM
FROM program A
JOIN program_subject B USING (PROGRAM_ID)
JOIN subject C USING (SUBJECT_ID)
WHERE C.NAME_SUBJECT LIKE 'Информатика'
ORDER BY A.NAME_PROGRAM DESC
;

-- Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ.
-- Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета в алфавитном порядке,
-- среднее значение округлить до одного знака после запятой.

SELECT
A.NAME_SUBJECT
,COUNT(B.ENROLLEE_ID) AS Количество
,MAX(B.RESULT) AS Максимум
,MIN(B.RESULT) AS Минимум
,ROUND(AVG(B.RESULT), 1) AS Среднее
FROM subject A
JOIN enrollee_subject B USING (SUBJECT_ID)
GROUP BY 1
ORDER BY 1
;

-- Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.

SELECT
A.NAME_PROGRAM
FROM program A
JOIN program_subject B USING (PROGRAM_ID)
GROUP BY 1
HAVING MIN(B.MIN_RESULT) >=40
ORDER BY 1
;

-- Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.

SELECT
NAME_PROGRAM
,PLAN
FROM program
WHERE PLAN =
(
SELECT
MAX(PLAN)
FROM program
)
;

-- Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.

SELECT 
name_enrollee
,COALESCE(SUM(bonus), 0) as Бонус
FROM enrollee
LEFT JOIN enrollee_achievement USING (enrollee_id)
LEFT JOIN achievement USING (achievement_id)
GROUP BY 1
ORDER BY 1
;
