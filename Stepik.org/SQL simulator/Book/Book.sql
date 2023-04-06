--Cоздание таблицы.
create table book(
book_id INT PRIMARY key AUTO_INCREMENT,
title VARCHAR(50),
author VARCHAR(30),
price DECIMAL(8,2),
amount INT);
insert into book (title, author, price, amount)
values ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);
insert into book (title, author, price, amount)
values ('Белая гвардия', 'Булгаков М.А.', 540.50, 5);
insert into book (title, author, price, amount)
values ('Идиот', 'Достоевский Ф.М.', 460.00, 10);
insert into book (title, author, price, amount)
values ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 3);
insert into book (title, author, price, amount)
values ('Стихотворения и поэмы', 'Есенин С.А.', 650.00, 15)

--В конце года цену всех книг на складе пересчитывают – снижают ее на 30%. 
--Написать SQL запрос, который из таблицы book выбирает названия, авторов, количества и вычисляет новые цены книг. 
--Столбец с новой ценой назвать new_price, цену округлить до 2-х знаков после запятой.
select title, author, amount,
round(price*0.7, 2) as new_price
from book;

--При анализе продаж книг выяснилось, что наибольшей популярностью пользуются книги Михаила Булгакова, на втором месте книги Сергея Есенина.
--Исходя из этого решили поднять цену книг Булгакова на 10%, а цену книг Есенина - на 5%. 
--Написать запрос, куда включить автора, название книги и новую цену, последний столбец назвать new_price. Значение округлить до двух знаков после запятой.
select author, title,
round(if(author='Булгаков М.А.', price*1.1, if(author='Есенин С.А.', price*1.05, price*1)), 2) as new_price
from book;

--Вывести название, автора,  цену  и количество всех книг, цена которых меньше 500 или больше 600, а стоимость всех экземпляров этих книг больше или равна 5000.
select title, author, price, amount
from book
where (price<500 or price>600) AND price*amount>=5000

--Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7.
select title, author
from book
where price between 540.50 AND 800
and amount in (2,3,5,7);

--Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы).
--Информацию  отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту).
select author, title
from book
where amount between 2 AND 14
order by author DESC, title

--Вывести название и автора тех книг, название которых состоит из двух и более слов, а инициалы автора содержат букву «С». 
--Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания,
--между фамилией автора и инициалами обязателен пробел, инициалы записываются без пробела в формате: буква, точка, буква, точка. 
--Информацию отсортировать по названию книги в алфавитном порядке.
select title, author
from book
where title like '_% %'
and (author like '% С._.'
or author like '% _.С.')
order by title;

--Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость), а также вычислить налог на добавленную стоимость  для полученных сумм (имя столбца НДС ) ,
--который включен в стоимость и составляет k = 18%,  а также стоимость книг  (Стоимость_без_НДС) без него. 
--Значения округлить до двух знаков после запятой.
select author,
sum(price*amount) as Стоимость,
round(sum(price*amount)/1.18*0.18, 2) as НДС,
round(sum(price*amount)/1.18, 2) as Стоимость_без_НДС
from book
group by author;

--Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14, включительно.
--Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой.
select round(avg(price), 2) as Средняя_цена,
round(sum(price*amount), 2) as Стоимость
from book
where amount between 5 and 14;

--Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия».
--В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб.
--Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.
select author, sum(price*amount) as Стоимость
from book
where title <> 'Идиот' or 'Белая Гвардия'
group by author
having sum(price*amount) > 5000
order by Стоимость DESC;

--Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе.
--Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.
select author, title, price
from book
where price <= (
select AVG(price)
from book)
order by price DESC;

--Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей
--в отсортированном по возрастанию цены виде.
select author, title, price
from book
where price -
(select min(price)
from book) <= 150
order by price;

--Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.
select author, title, amount
from book
where amount IN
(select amount
from book
group by amount
having count(amount)=1);

--Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.
select author, title, price
from book
where price < ANY
(select min(price)
from book
group by author);

--Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров каждой книги,
--равное значению самого большего количества экземпляров одной книги на складе. 
--Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. 
--Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.

select title, author, amount, 
(select max(amount)
from book) - amount AS Заказ
from book
where amount < any
(select max(amount)
from book);

--Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
create table supply(
supply_id INT PRIMARY key AUTO_INCREMENT,
title VARCHAR(50),
author VARCHAR(30),
price DECIMAL(8,2),
amount INT)
insert into supply (title, author, price, amount)
values ('Лирика', 'Пастернак Б.Л.', 518.99, 2);
insert into supply (title, author, price, amount)
values ('Черный человек', 'Есенин С.А.', 570.20, 6);
insert into supply (title, author, price, amount)
values ('Белая гвардия', 'Булгаков М.А.', 540.50, 7);
insert into supply (title, author, price, amount)
values ('Идиот', 'Достоевский Ф.М.', 360.80, 3)

--Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not like 'Булгаков М.А.'
and author not like 'Достоевский Ф.М.'

--Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.
insert into book (title, author, price, amount)
select title, author, price, amount
from supply
where author not in (
select author
from book);

--Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
update book
set price = 0.9*price
where amount between 5 and 10

--В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг,
--указанных в столбце amount.
--А цену тех книг, которые покупатель не заказывал, снизить на 10%.
update book
set buy = IF(buy>=amount, amount,
 buy), 
price = IF(buy=0, price*0.9, price);

--Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book
--(увеличить их количество на значение столбца amount таблицы supply),
--но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).
UPDATE book b, supply s
SET b.amount = b.amount+s.amount,
b.price = (b.price+s.price)/2
WHERE b.title=s.title AND b.author=s.author;

--Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
delete from supply
where author in (
select author
from book
group by author
having sum(amount)>10);

--Создать таблицу заказ (ordering), куда включить авторов и названия тех книг,
--количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book.
--В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
create table ordering as
select author, title, (
select avg(amount)
from book) as amount
from book
where amount < (
select avg(amount)
from book);

