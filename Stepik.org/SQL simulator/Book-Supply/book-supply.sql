CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50));

INSERT INTO author (name_author)
VALUES ('Булгаков М.А.'),
('Достоевский Ф.М.'),
('Есенин С.А.'),
('Пастернак Б.Л.'),
('Лермонтов М.Ю.');

CREATE TABLE genre(
        genre_id INT PRIMARY KEY AUTO_INCREMENT,
        name_genre varchar(30));

INSERT INTO genre (name_genre)
VALUES ('Роман'),
       ('Поэзия'),
       ('Приключения');

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT, 
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
 FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
);

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES ('Мастер и Маргарита', 1, 1, 670.99, 3),
       ('Белая гвардия ', 1, 3, 540.50, 5),
       ('Идиот', 2, 1, 460.00, 10),
       ('Братья Карамазовы', 2, 1, 799.01, 3),
       ('Игрок', 2, 1, 480.50, 10),
       ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 1, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);
       
       CREATE TABLE supply(
        supply_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(50), 
    author VARCHAR(50),
    price DECIMAL(8,2), 
    amount INT); 

INSERT INTO supply (title, author, price, amount)
VALUES ('Доктор Живаго', 'Пастернак Б.Л.', 380.80, 4),
       ('Черный человек', 'Есенин С.А.', 570.20, 6),
       ('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
       ('Идиот', 'Достоевский Ф.М.', 360.80, 3),
       ('Стихотворения и поэмы', 'Лермонтов М.Ю.', 255.90, 4),
       ('Остров сокровищ', 'Стивенсон Р.Л.', 599.99, 5);
      
--Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.

select title, name_genre, price
from genre g
inner join book b
on g.genre_id = b.genre_id
where b.amount>8
order by b.price desc;

--Вывести все жанры, которые не представлены в книгах на складе.

select name_genre
from genre g
left join book b
on g.genre_id = b.genre_id
where b.title is null;

--Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года.
--Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки.
--Последний столбец назвать Дата.
--Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок.

CREATE TABLE city(
        city_id INT PRIMARY KEY AUTO_INCREMENT,
        name_city varchar(30));

INSERT INTO city (name_city)
VALUES ('Москва'),
       ('Санкт-Петербург'),
       ('Владивосток');
       
select c.name_city, a.name_author, date_add('2020-01-01', interval floor(rand()*365) DAY) as Дата
from author a cross join city c
order by c.name_city, Дата desc;

--Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.

select g.name_genre, b.title, a.name_author
from genre g
inner join book b on g.genre_id=b.genre_id
inner join author a on b.author_id=a.author_id
where g.name_genre like 'Роман'
order by b.title;

--Посчитать количество экземпляров  книг каждого автора из таблицы author.
--Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде.
--Последний столбец назвать Количество.

select a.name_author, sum(b.amount) as Количество
from author a
left join book b on a.author_id=b.author_id
group by a.name_author
having Количество<10
or count(title)=0
order by Количество;

--Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре.
--C join:

select a.name_author
from author a
inner join book b on a.author_id=b.author_id
group by a.name_author
having count(distinct b.genre_id)=1
order by a.name_author;

--С подзапросом:

select a.name_author
from author a
where a.author_id in 
(
select b.author_id
from book b
group by b.author_id
having count(distinct(genre_id))=1)
order by a.name_author;

--Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги),
--написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде.
--Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.
--C join:

select b.title, a.name_author, g.name_genre, b.price, b.amount
from author a
inner join book b on a.author_id=b.author_id
inner join genre g on b.genre_id=g.genre_id
where g.genre_id in 
(
select query1.genre_id
from
(
select genre_id, sum(amount) as sum_amount
from book
group by genre_id
) query1
inner join
(
select genre_id, sum(amount) as sum_amount
from book
group by genre_id
limit 1
) query2
on query1.sum_amount=query2.sum_amount)
order by b.title;

--С подзапросом:

select b.title, a.name_author, g.name_genre, b.price, b.amount
from author a
inner join book b on a.author_id=b.author_id
inner join genre g on b.genre_id=g.genre_id
where g.genre_id in 
(
select genre_id
from book
group by genre_id
having sum(amount) = 
(
select sum(amount) as sum_amount
from book
group by genre_id
limit 1))
order by b.title;

--Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену, 
--вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book,
--столбцы назвать Название, Автор  и Количество.

select b.title as Название, s.author as Автор, b.amount+s.amount as Количество
from book b
inner join supply s on b.title=s.title
where b.price=s.price;

--Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
--необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену. А в таблице  supply обнулить количество этих книг.

update book b
inner join supply s on b.title=s.title
inner join author a on s.author=a.name_author
and b.author_id=a.author_id
set b.amount=b.amount+s.amount,
s.amount=0,
b.price=(b.price*b.amount+s.price*s.amount)/(b.amount+s.amount)
where b.price<>s.price
and s.author=a.name_author;

--Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.
--Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.

insert into author (name_author)
select s.author
from author a
right join supply s on a.name_author=s.author
where a.name_author is null;
select * from author

--Добавить новые записи о книгах, которые есть в таблице supply и нет в таблице book.
--Поскольку в таблице supply не указан жанр книги, оставить его пока пустым (занести значение Null). Затем вывести для просмотра таблицу book.

insert into book (title, author_id, genre_id, price, amount)
select s.title, a.author_id, null, s.price, s.amount
from author a
inner join supply s on a.name_author = s.author
where s.amount <> 0;
select * from book;

 --Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения». (Использовать два запроса).
 
update book
set genre_id = 
(
    select genre_id
    from genre
    where name_genre='Поэзия')
    where title like 'Стихотворения и поэмы';
 update book
set genre_id = 
(
    select genre_id
    from genre
    where name_genre='Приключения')
    where title like 'Остров сокровищ';

--Удалить всех авторов и все их книги, общее количество книг которых меньше 20.

delete from author
where author_id in (
    select author_id
    from book
    group by author_id
    having sum(amount)<20);
    
--Удалить все жанры, к которым относится меньше 4-х книг. В таблице book для этих жанров установить значение Null.

delete from genre
where genre_id in (
    select genre_id
    from book
    group by genre_id
    having count(title)<4);
    
--Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов.
--В запросе для отбора авторов использовать полное название жанра, а не его id.

delete from author
using author
inner join book b on author.author_id=b.author_id
inner join genre g on b.genre_id=b.genre_id
where b.genre_id in (
    select genre_id
    from genre
    where name_genre like 'Поэзия');
