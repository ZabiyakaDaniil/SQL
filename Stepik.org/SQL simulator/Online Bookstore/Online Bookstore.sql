CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

INSERT INTO author (name_author)
VALUES ('�������� �.�.'),
       ('����������� �.�.'),
       ('������ �.�.'),
       ('��������� �.�.'),
       ('��������� �.�.');

CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES ('�����'),
       ('������'),
       ('�����������');

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
VALUES  ('������ � ���������', 1, 1, 670.99, 3),
        ('����� ������� ', 1, 1, 540.50, 5),
        ('�����', 2, 1, 460.00, 10),
        ('������ ����������', 2, 1, 799.01, 2),
        ('�����', 2, 1, 480.50, 10),
        ('������������� � �����', 3, 2, 650.00, 15),
        ('������ �������', 3, 2, 570.20, 6),
        ('������', 4, 2, 518.99, 2);

CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(30),
    days_delivery INT
);

INSERT INTO city(name_city, days_delivery)
VALUES ('������', 5),
       ('�����-���������', 3),
       ('�����������', 12);
      
CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(50),
    city_id INT,
    email VARCHAR(30),
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);

INSERT INTO client(name_client, city_id, email)
VALUES ('������� �����', 3, 'baranov@test'),
       ('�������� ����', 1, 'abramova@test'),
       ('��������� ����', 2, 'semenov@test'),
       ('�������� ������', 1, 'yakovleva@test');

CREATE TABLE buy(
    buy_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_description VARCHAR(100),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
);

INSERT INTO buy (buy_description, client_id)
VALUES ('�������� ������ �������', 1),
       (NULL, 3),
       ('��������� ������ ����� �� �����������', 2),
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
VALUES ('������'),
       ('��������'),
       ('���������������'),
       ('��������');

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
       
--������� ��� ������ �������� ����� (id ������, ����� �����, �� ����� ���� � � ����� ���������� �� �������) � ��������������� �� ������ ������ � ��������� ���� ����.
select bu.buy_id, b.title, b.price, bb.amount
from client c
join buy bu on c.client_id=bu.client_id
join buy_book bb on bu.buy_id=bb.buy_id
join book b on bb.book_id=b.book_id
where c.name_client like '������� �����'
order by bu.buy_id, b.title;

--���������, ������� ��� ���� �������� ������ �����, ��� ����� ������� �� ������ (����� ���������, � ����� ���������� ������� ���������� ������ �����).
--������� ������� � �������� ������, �������� �����, ��������� ������� ������� ����������.
--��������� ������������� �������  �� �������� �������, � ����� �� ��������� ����.
select a.name_author, b.title, count(bb.book_id) as ����������
from author a
join book b on a.author_id=b.author_id
left join buy_book bb on b.book_id=bb.book_id
group by a.name_author, b.title
order by a.name_author, b.title;

--������� ������, � ������� ����� �������, ����������� ������ � ��������-��������. ������� ���������� ������� � ������ �����, ���� ������� ������� ����������.
--���������� ������� �� �������� ���������� �������, � ����� � ���������� ������� �� �������� �������.
select ci.name_city, count(bu.buy_id) as ����������
from city ci
join client c on ci.city_id=c.city_id
join buy bu on c.client_id=bu.client_id
group by ci.name_city
order by ���������� desc, ci.name_city

--������� ������ ���� ���������� ������� � ����, ����� ��� ���� ��������.
select bs.buy_id, bs.date_step_end
from step s
join buy_step bs on s.step_id=bs.step_id
where s.name_step like '������'
and bs.date_step_end is not null

--������� ���������� � ������ ������: ��� �����, ��� ��� ����������� (������� ������������) � ��� ��������� (����� ������������ ���������� ���������� ���� � �� ����),
--� ��������������� �� ������ ������ ����.
--��������� ������� ������� ���������.
select bu.buy_id, c.name_client, sum(bb.amount*b.price) as ���������
from client c
join buy bu on c.client_id=bu.client_id
join buy_book bb on bu.buy_id=bb.buy_id
join book b on bb.book_id=b.book_id
group by bu.buy_id
order by bu.buy_id

--������� ������ ������� (buy_id) � �������� ������,  �� ������� ��� � ������ ������ ���������. ���� ����� ��������� �  ���������� � ��� �� ��������.
--���������� ������������� �� ����������� buy_id.
select bs.buy_id, s.name_step
from step s
join buy_step bs on s.step_id=bs.step_id
where bs.date_step_end is null
and bs.date_step_beg is not null

 --��� ��� �������, ������� ������ ���� ���������������, ������� ���������� ���� �� ������� ����� ������� ��������� � �����.
 --� �����, ���� ����� ��������� � ����������, ������� ���������� ���� ��������, � ��������� ������ ������� 0. � ��������� �������� ����� ������ (buy_id),
 --� ����� ����������� ������� ����������_���� � ���������. ���������� ������� � ��������������� �� ������ ������ ����.
select bs.buy_id, datediff(bs.date_step_end, bs.date_step_beg) as ����������_����,
if(datediff(bs.date_step_end, bs.date_step_beg)>c.days_delivery, datediff(bs.date_step_end, bs.date_step_beg)-c.days_delivery, 0) as ���������
from city c
join client cl on c.city_id=cl.city_id
join buy bu on cl.client_id=bu.client_id
join buy_step bs on bu.buy_id=bs.buy_id
join step s on bs.step_id=s.step_id
where s.name_step like '���������������'
and bs.date_step_end is not null
and bs.date_step_beg is not null
order by bs.buy_id

--������� ���� ��������, ������� ���������� ����� ������������, ���������� ������� � ��������������� �� �������� ����. � ������� ����������� ������� ������, � �� ��� id.
select distinct cl.name_client
from author a
join book b on a.author_id=b.author_id
join buy_book bb on b.book_id=bb.book_id
join buy bu on bb.buy_id=bu.buy_id
join client cl on bu.client_id=cl.client_id
where a.name_author like '�����������%'
order by cl.name_client

--������� ���� (��� �����), � ������� ���� �������� ������ ����� ����������� ����, ������� ��� ����������. ��������� ������� ������� ����������.
select g.name_genre, sum(bb.amount) as ����������
from genre g
join book b on g.genre_id=b.genre_id
join buy_book bb on b.book_id=bb.book_id
group by g.name_genre
having ����������=(
    select max(sum_amount)
    from (
        select sum(bb.amount) as sum_amount
        from buy_book bb
        join book b on bb.book_id=b.book_id
        group by b.genre_id) q);
        
--�������� ����������� ������� �� ������� ���� �� ������� � ���������� ����.
--��� ����� ������� ���, �����, ����� ������� � ��������������� ������� �� ����������� �������, ����� �� ����������� ��� ����.
--�������� ��������: ���, �����, �����.
select year(date_payment) as ���, monthname(date_payment) as �����, sum(price*amount) as �����
from buy_archive
group by ���, �����
union all
select year(date_step_end) as ���, monthname(date_step_end) as �����, sum(b.price*bb.amount) as �����
from book b
join buy_book bb using (book_id)
join buy bu using (buy_id)
join buy_step bs using (buy_id)
join step s using (step_id)
where s.name_step like '������'
and bs.date_step_end is not null
group by ���, �����
order by �����, ���

--��� ������ ��������� ����� ���������� ������� ���������� � ���������� ��������� ����������� � �� ��������� �� 2020 � 2019 ��� .
--����������� ������� ������� ���������� � �����. ���������� ������������� �� �������� ���������.
select title, sum(����������) as ����������, sum(�����) as �����
from (
select b.title, sum(ba.amount) as ����������, sum(ba.price*ba.amount) as �����
from buy_archive ba
join book b using (book_id)
group by b.title
union all
select b.title, sum(bb.amount) as ����������, sum(b.price*bb.amount) as �����
from book b
join buy_book bb using (book_id)
join buy bu using (buy_id)
join buy_step bs using (buy_id)
join step s using (step_id)
where s.name_step like '������'
and bs.date_step_end is not null
group by b.title) q
group by title
order by ����� desc

--�������� ������ �������� � ������� � ���������. ��� ��� ����� ����, ��� email popov@test, ��������� �� � ������.
insert into client (name_client, city_id, email)
select '����� ����', city_id, 'popov@test'
from city
where name_city like '������';

--������� ����� ����� ��� ������ ����. ��� ����������� ��� ������: ���������� �� ���� �� ������� ��������.
insert into buy (buy_description, client_id)
select '��������� �� ���� �� ������� ��������', client_id
from client
where name_client like '����� ����';

--� ������� buy_book �������� ����� � ������� 5.
--���� ����� ������ ��������� ����� ���������� ������� � ���������� ���� ����������� � ����� ��������� ������ �������� � ����� ����������.
insert into buy_book (buy_id, book_id, amount)
select 5, book_id, 2
from book
where title like '������';
insert into buy_book (buy_id, book_id, amount)
select 5, book_id, 1
from book
where title like '����� �������';

--���������� ��� ���� �� ������, ������� ���� �������� � ����� � ������� 5, ��������� �� �� ����������, ������� � ������ � ������� 5 �������.
update book b, buy_book bb
set b.amount=b.amount-bb.amount
where bb.buy_id=5
and b.book_id=bb.book_id;

--������� ���� (������� buy_pay) �� ������ ������ � ������� 5, � ������� �������� �������� ����, �� ������, ����, ���������� ���������� ���� �  ���������.
--��������� ������� ������� ���������. ���������� � ������� ������� � ��������������� �� ��������� ���� ����.
create table buy_pay as
select b.title, a.name_author, b.price, bb.amount, sum(b.price*bb.amount) as ���������
from author a
join book b using (author_id)
join buy_book bb using (book_id)
where bb.buy_id=5
group by b.title, a.name_author, b.price, bb.amount
order by b.title;

--������� ����� ���� (������� buy_pay) �� ������ ������ � ������� 5. ���� �������� ����� ������, ���������� ���� � ������ (�������� ������� ����������)
--� ��� ����� ��������� (�������� ������� �����). ��� ������� ����������� ���� ������.
create table buy_pay as
select bb.buy_id, sum(bb.amount) as ����������, sum(b.price*bb.amount) as �����
from buy_book bb
join book b using (book_id)
where bb.buy_id=5
group by bb.buy_id;

--� ������� buy_step ��� ������ � ������� 5 �������� ��� ����� �� ������� step, ������� ������ ������ ���� �����. 
--� ������� date_step_beg � date_step_end ���� ������� ������� Null.
insert into buy_step (buy_id, step_id, date_step_beg, date_step_end)
select buy_id, step_id, null, null
from buy, step
where buy_id=5;

--� ������� buy_step ������� ���� 12.04.2020 ����������� ����� �� ������ ������ � ������� 5.
update buy_step 
set date_step_beg = '2020-04-12'
where buy_id=5 
and step_id = (
    select step_id
    from step
    where name_step like '������');
    
--��������� ���� ������� ��� ������ � ������� 5, ������� � ������� date_step_end ���� 13.04.2020, � ������ ��������� ���� (���������),
--����� � ������� date_step_beg ��� ����� ����� �� �� ����.
--����������� ��� ������� ��� ���������� ����� � ������ ����������.
--��� ������ ���� �������� � ����� ����, ����� ��� ����� ���� ��������� ��� ����� ������, ������� ������ ������� ����.
   
update buy_step 
set date_step_end = '2020-04-13'
where buy_id=5 
and step_id = (
    select step_id
    from step
    where name_step like '������');
update buy_step
set date_step_beg = '2020-04-13'
where buy_id=5
and step_id = (
    select step_id + 1 
    from step
    where name_step like '������');
    select * from buy_step