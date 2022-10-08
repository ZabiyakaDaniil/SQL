CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

INSERT INTO author (name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.'),
       ('Лермонтов М.Ю.');

CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES ('Роман'),
       ('Поэзия'),
       ('Приключения');

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id)
        REFERENCES genre (genre_id)
        ON DELETE SET NULL
);

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES  ('Мастер и Маргарита', 1, 1, 670.99, 3),
        ('Белая гвардия ', 1, 1, 540.50, 5),
        ('Идиот', 2, 1, 460.00, 10),
        ('Братья Карамазовы', 2, 1, 799.01, 2),
        ('Игрок', 2, 1, 480.50, 10),
        ('Стихотворения и поэмы', 3, 2, 650.00, 15),
        ('Черный человек', 3, 2, 570.20, 6),
        ('Лирика', 4, 2, 518.99, 2);

CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(30),
    days_delivery INT
);

INSERT INTO city(name_city, days_delivery)
VALUES ('Москва', 5),
       ('Санкт-Петербург', 3),
       ('Владивосток', 12);
      
CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(50),
    city_id INT,
    email VARCHAR(30),
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);

INSERT INTO client(name_client, city_id, email)
VALUES ('Баранов Павел', 3, 'baranov@test'),
       ('Абрамова Катя', 1, 'abramova@test'),
       ('Семенонов Иван', 2, 'semenov@test'),
       ('Яковлева Галина', 1, 'yakovleva@test');

CREATE TABLE buy(
    buy_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_description VARCHAR(100),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
);

INSERT INTO buy (buy_description, client_id)
VALUES ('Доставка только вечером', 1),
       (NULL, 3),
       ('Упаковать каждую книгу по отдельности', 2),
       (NULL, 1);

CREATE TABLE buy_book (
    buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    book_id INT,
    amount INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (book_id) REFERENCES book (book_id)
);

INSERT INTO buy_book(buy_id, book_id, amount)
VALUES (1, 1, 1),
       (1, 7, 2),
       (1, 3, 1),
       (2, 8, 2),
       (3, 3, 2),
       (3, 2, 1),
       (3, 1, 1),
       (4, 5, 1);

CREATE TABLE step (
    step_id INT PRIMARY KEY AUTO_INCREMENT,
    name_step VARCHAR(30)
);

INSERT INTO step(name_step)
VALUES ('Оплата'),
       ('Упаковка'),
       ('Транспортировка'),
       ('Доставка');

CREATE TABLE buy_step (
    buy_step_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    step_id INT,
    date_step_beg DATE,
    date_step_end DATE,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id)
);

INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
VALUES (1, 1, '2020-02-20', '2020-02-20'),
       (1, 2, '2020-02-20', '2020-02-21'),
       (1, 3, '2020-02-22', '2020-03-07'),
       (1, 4, '2020-03-08', '2020-03-08'),
       (2, 1, '2020-02-28', '2020-02-28'),
       (2, 2, '2020-02-29', '2020-03-01'),
       (2, 3, '2020-03-02', NULL),
       (2, 4, NULL, NULL),
       (3, 1, '2020-03-05', '2020-03-05'),
       (3, 2, '2020-03-05', '2020-03-06'),
       (3, 3, '2020-03-06', '2020-03-10'),
       (3, 4, '2020-03-11', NULL),
       (4, 1, '2020-03-20', NULL),
       (4, 2, NULL, NULL),
       (4, 3, NULL, NULL),
       (4, 4, NULL, NULL);
       
--Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.
select bu.buy_id, b.title, b.price, bb.amount
from client c
join buy bu on c.client_id=bu.client_id
join buy_book bb on bu.buy_id=bb.buy_id
join book b on bb.book_id=b.book_id
where c.name_client like 'Баранов Павел'
order by bu.buy_id, b.title;

--Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).
--Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество.
--Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
select a.name_author, b.title, count(bb.book_id) as Количество
from author a
join book b on a.author_id=b.author_id
left join buy_book bb on b.book_id=bb.book_id
group by a.name_author, b.title
order by a.name_author, b.title;

--Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество.
--Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
select ci.name_city, count(bu.buy_id) as Количество
from city ci
join client c on ci.city_id=c.city_id
join buy bu on c.client_id=bu.client_id
group by ci.name_city
order by Количество desc, ci.name_city

--Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
select bs.buy_id, bs.date_step_end
from step s
join buy_step bs on s.step_id=bs.step_id
where s.name_step like 'Оплата'
and bs.date_step_end is not null

--Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены),
--в отсортированном по номеру заказа виде.
--Последний столбец назвать Стоимость.
select bu.buy_id, c.name_client, sum(bb.amount*b.price) as Стоимость
from client c
join buy bu on c.client_id=bu.client_id
join buy_book bb on bu.buy_id=bb.buy_id
join book b on bb.book_id=b.book_id
group by bu.buy_id
order by bu.buy_id

--Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить.
--Информацию отсортировать по возрастанию buy_id.
select bs.buy_id, s.name_step
from step s
join buy_step bs on s.step_id=bs.step_id
where bs.date_step_end is null
and bs.date_step_beg is not null

 --Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город.
 --А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id),
 --а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
select bs.buy_id, datediff(bs.date_step_end, bs.date_step_beg) as Количество_дней,
if(datediff(bs.date_step_end, bs.date_step_beg)>c.days_delivery, datediff(bs.date_step_end, bs.date_step_beg)-c.days_delivery, 0) as Опоздание
from city c
join client cl on c.city_id=cl.city_id
join buy bu on cl.client_id=bu.client_id
join buy_step bs on bu.buy_id=bs.buy_id
join step s on bs.step_id=s.step_id
where s.name_step like 'Транспортировка'
and bs.date_step_end is not null
and bs.date_step_beg is not null
order by bs.buy_id

--Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
select distinct cl.name_client
from author a
join book b on a.author_id=b.author_id
join buy_book bb on b.book_id=bb.book_id
join buy bu on bb.buy_id=bu.buy_id
join client cl on bu.client_id=cl.client_id
where a.name_author like 'Достоевский%'
order by cl.name_client

--Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.
select g.name_genre, sum(bb.amount) as Количество
from genre g
join book b on g.genre_id=b.genre_id
join buy_book bb on b.book_id=bb.book_id
group by g.name_genre
having Количество=(
    select max(sum_amount)
    from (
        select sum(bb.amount) as sum_amount
        from buy_book bb
        join book b on bb.book_id=b.book_id
        group by b.genre_id) q);
        
--Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы.
--Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде.
--Название столбцов: Год, Месяц, Сумма.
select year(date_payment) as Год, monthname(date_payment) as Месяц, sum(price*amount) as Сумма
from buy_archive
group by Год, Месяц
union all
select year(date_step_end) as Год, monthname(date_step_end) as Месяц, sum(b.price*bb.amount) as Сумма
from book b
join buy_book bb using (book_id)
join buy bu using (buy_id)
join buy_step bs using (buy_id)
join step s using (step_id)
where s.name_step like 'Оплата'
and bs.date_step_end is not null
group by Год, Месяц
order by Месяц, Год

--Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год .
--Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.
select title, sum(Количество) as Количество, sum(Сумма) as Сумма
from (
select b.title, sum(ba.amount) as Количество, sum(ba.price*ba.amount) as Сумма
from buy_archive ba
join book b using (book_id)
group by b.title
union all
select b.title, sum(bb.amount) as Количество, sum(b.price*bb.amount) as Сумма
from book b
join buy_book bb using (book_id)
join buy bu using (buy_id)
join buy_step bs using (buy_id)
join step s using (step_id)
where s.name_step like 'Оплата'
and bs.date_step_end is not null
group by b.title) q
group by title
order by Сумма desc

--Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
insert into client (name_client, city_id, email)
select 'Попов Илья', city_id, 'popov@test'
from city
where name_city like 'Москва';

--Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
insert into buy (buy_description, client_id)
select 'Связаться со мной по вопросу доставки', client_id
from client
where name_client like 'Попов Илья';

--В таблицу buy_book добавить заказ с номером 5.
--Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
insert into buy_book (buy_id, book_id, amount)
select 5, book_id, 2
from book
where title like 'Лирика';
insert into buy_book (buy_id, book_id, amount)
select 5, book_id, 1
from book
where title like 'Белая Гвардия';

--Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5 указано.
update book b, buy_book bb
set b.amount=b.amount-bb.amount
where bb.buy_id=5
and b.book_id=bb.book_id;

--Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и  стоимость.
--Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
create table buy_pay as
select b.title, a.name_author, b.price, bb.amount, sum(b.price*bb.amount) as Стоимость
from author a
join book b using (author_id)
join buy_book bb using (book_id)
where bb.buy_id=5
group by b.title, a.name_author, b.price, bb.amount
order by b.title;

--Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество)
--и его общую стоимость (название столбца Итого). Для решения используйте ОДИН запрос.
create table buy_pay as
select bb.buy_id, sum(bb.amount) as Количество, sum(b.price*bb.amount) as Итого
from buy_book bb
join book b using (book_id)
where bb.buy_id=5
group by bb.buy_id;

--В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. 
--В столбцы date_step_beg и date_step_end всех записей занести Null.
insert into buy_step (buy_id, step_id, date_step_beg, date_step_end)
select buy_id, step_id, null, null
from buy, step
where buy_id=5;

--В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
update buy_step 
set date_step_beg = '2020-04-12'
where buy_id=5 
and step_id = (
    select step_id
    from step
    where name_step like 'Оплата');
    
--Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»),
--задав в столбце date_step_beg для этого этапа ту же дату.
--Реализовать два запроса для завершения этапа и начала следующего.
--Они должны быть записаны в общем виде, чтобы его можно было применять для любых этапов, изменив только текущий этап.
   
update buy_step 
set date_step_end = '2020-04-13'
where buy_id=5 
and step_id = (
    select step_id
    from step
    where name_step like 'Оплата');
update buy_step
set date_step_beg = '2020-04-13'
where buy_id=5
and step_id = (
    select step_id + 1 
    from step
    where name_step like 'Оплата');
    select * from buy_step