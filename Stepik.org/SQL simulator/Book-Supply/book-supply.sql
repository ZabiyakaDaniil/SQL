CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50));

INSERT INTO author (name_author)
VALUES ('�������� �.�.'),
('����������� �.�.'),
('������ �.�.'),
('��������� �.�.'),
('��������� �.�.');

CREATE TABLE genre(
        genre_id INT PRIMARY KEY AUTO_INCREMENT,
        name_genre varchar(30));

INSERT INTO genre (name_genre)
VALUES ('�����'),
       ('������'),
       ('�����������');

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
VALUES ('������ � ���������', 1, 1, 670.99, 3),
       ('����� ������� ', 1, 3, 540.50, 5),
       ('�����', 2, 1, 460.00, 10),
       ('������ ����������', 2, 1, 799.01, 3),
       ('�����', 2, 1, 480.50, 10),
       ('������������� � �����', 3, 2, 650.00, 15),
       ('������ �������', 3, 1, 570.20, 6),
       ('������', 4, 2, 518.99, 2);
       
       CREATE TABLE supply(
        supply_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(50), 
    author VARCHAR(50),
    price DECIMAL(8,2), 
    amount INT); 

INSERT INTO supply (title, author, price, amount)
VALUES ('������ ������', '��������� �.�.', 380.80, 4),
       ('������ �������', '������ �.�.', 570.20, 6),
       ('����� �������', '�������� �.�.', 540.50, 7),
       ('�����', '����������� �.�.', 360.80, 3),
       ('������������� � �����', '��������� �.�.', 255.90, 4),
       ('������ ��������', '��������� �.�.', 599.99, 5);
      
--������� ��������, ���� � ���� ��� ����, ���������� ������� ������ 8, � ��������������� �� �������� ���� ����.
select title, name_genre, price
from genre g
inner join book b
on g.genre_id = b.genre_id
where b.amount>8
order by b.price desc;

--������� ��� �����, ������� �� ������������ � ������ �� ������.
select name_genre
from genre g
left join book b
on g.genre_id = b.genre_id
where b.title is null;

--���������� � ������ ������ �������� �������� ���� ������� ������ � ������� 2020 ����.
--���� ���������� �������� ������� ��������� �������. ������� ������, ������� ������� �����, ������ � ���� ���������� ��������.
--��������� ������� ������� ����.
--���������� �������, ������������ ������� � ���������� ������� �� ��������� �������, � ����� �� �������� ��� ���������� ��������.

CREATE TABLE city(
        city_id INT PRIMARY KEY AUTO_INCREMENT,
        name_city varchar(30));

INSERT INTO city (name_city)
VALUES ('������'),
       ('�����-���������'),
       ('�����������');
       
select c.name_city, a.name_author, date_add('2020-01-01', interval floor(rand()*365) DAY) as ����
from author a cross join city c
order by c.name_city, ���� desc;

--������� ���������� � ������ (����, �����, �����), ����������� � �����, ����������� ����� ������ � ��������������� �� ��������� ���� ����.
select g.name_genre, b.title, a.name_author
from genre g
inner join book b on g.genre_id=b.genre_id
inner join author a on b.author_id=a.author_id
where g.name_genre like '�����'
order by b.title;

--��������� ���������� �����������  ���� ������� ������ �� ������� author.
--������� ��� �������,  ���������� ���� ������� ������ 10, � ��������������� �� ����������� ���������� ����.
--��������� ������� ������� ����������.
select a.name_author, sum(b.amount) as ����������
from author a
left join book b on a.author_id=b.author_id
group by a.name_author
having ����������<10
or count(title)=0
order by ����������;

--������� � ���������� ������� ���� �������, ������� ����� ������ � ����� �����.
--C join:
select a.name_author
from author a
inner join book b on a.author_id=b.author_id
group by a.name_author
having count(distinct b.genre_id)=1
order by a.name_author;

--� �����������:
select a.name_author
from author a
where a.author_id in 
(
select b.author_id
from book b
group by b.author_id
having count(distinct(genre_id))=1)
order by a.name_author;

--������� ���������� � ������ (�������� �����, ������� � �������� ������, �������� �����, ���� � ���������� ����������� �����),
--���������� � ����� ���������� ������, � ��������������� � ���������� ������� �� �������� ���� ����.
--����� ���������� ������� ����, ����� ���������� ����������� ���� �������� �� ������ �����������.
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
group by genre_id) query1
inner join
(
select genre_id, sum(amount) as sum_amount
from book
group by genre_id
limit 1) query2
on query1.sum_amount=query2.sum_amount)
order by b.title;

--� �����������:
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

--���� � �������� supply  � book ���� ���������� �����, ������� ����� ������ ����, 
--������� �� �������� � ������, � ����� ��������� ����� ���������� ����������� ���� � �������� supply � book,
--������� ������� ��������, �����  � ����������.
select b.title as ��������, s.author as �����, b.amount+s.amount as ����������
from book b
inner join supply s on b.title=s.title
where b.price=s.price;

--��� ����, ������� ��� ���� �� ������ (� ������� book), �� �� ������ ����, ��� � �������� (supply),
--���������� � ������� book ��������� ���������� �� ��������, ��������� � ��������,  � ����������� ����. � � �������  supply �������� ���������� ���� ����.
update book b
inner join supply s on b.title=s.title
inner join author a on s.author=a.name_author
and b.author_id=a.author_id
set b.amount=b.amount+s.amount,
s.amount=0,
b.price=(b.price*b.amount+s.price*s.amount)/(b.amount+s.amount)
where b.price<>s.price
and s.author=a.name_author;

--�������� ����� ������� � ������� author � ������� ������� �� ����������, � ����� ������� ��� ������ �� ������� author.
--������ ��������� ������, ������� ���� � ������� supply, �� ��� � ������� author.
insert into author (name_author)
select s.author
from author a
right join supply s on a.name_author=s.author
where a.name_author is null;
select * from author

--�������� ����� ������ � ������, ������� ���� � ������� supply � ��� � ������� book.
--��������� � ������� supply �� ������ ���� �����, �������� ��� ���� ������ (������� �������� Null). ����� ������� ��� ��������� ������� book.
insert into book (title, author_id, genre_id, price, amount)
select s.title, a.author_id, null, s.price, s.amount
from author a
inner join supply s on a.name_author = s.author
where s.amount <> 0;
select * from book

 --������� ��� ����� �������������� � ������ ���������� ���� ��������, � ��� ����� ������� ��������� ���������� - �������������. (������������ ��� �������).
update book
set genre_id = 
(
    select genre_id
    from genre
    where name_genre='������')
    where title like '������������� � �����';
 update book
set genre_id = 
(
    select genre_id
    from genre
    where name_genre='�����������')
    where title like '������ ��������';

--������� ���� ������� � ��� �� �����, ����� ���������� ���� ������� ������ 20.
delete from author
where author_id in (
    select author_id
    from book
    group by author_id
    having sum(amount)<20);
    
--������� ��� �����, � ������� ��������� ������ 4-� ����. � ������� book ��� ���� ������ ���������� �������� Null.
delete from genre
where genre_id in (
    select genre_id
    from book
    group by genre_id
    having count(title)<4);
    
--������� ���� �������, ������� ����� � ����� "������". �� ������� book ������� ��� ����� ���� �������.
--� ������� ��� ������ ������� ������������ ������ �������� �����, � �� ��� id.
delete from author
using author
inner join book b on author.author_id=b.author_id
inner join genre g on b.genre_id=b.genre_id
where b.genre_id in (
    select genre_id
    from genre
    where name_genre like '������');