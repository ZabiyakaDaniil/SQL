--����� ������ ��������� � ������������ ��������� ��� ������� ��������.
select * from product p
inner join category c
on p.category_id = c.category_id

--����� �������� ��������, ��������� � ����.
select product.product_name, category.category_name, product.price 
from product p
inner join category c
on p.category_id = c.category_id

--�������� ��� ������� ������ ������� ������������� �����-���� ��������� � ���������� ������� � ���������� ���������. 
--������ ������ ���� ������������ �� �������� ������, �������� ���������.
select g.name as good_name,  c.name as category_name
from good g
inner join category_has_good ch
on g.id = ch.good_id
inner join category c
on ch.category_id = c.id
order by 1, 2

--�������� ������ �������� (���, �������) � ���������� ������� ������ ��������, ������� ������ "new".
select c.first_name as first_name,  c.last_name as last_name, count(sl.id) as new_sale_num
from client c
inner join sale sl
on c.id = sl.client_id
inner join status st
on sl.status_id = st.id
where st.name = 'new'
group by first_name, last_name;

--�������� ������ ������� � ���������� ������� � ���������� ���������, � ��� ����� �������, �� ������������� �� ����� �� ���������.
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
left join category c
on ch.category_id=c.id
order by good_name

--�������� ������ ������� � ���������� ���������, � ��� ����� �������, �� ������������� �� � ����� �� ���������, � ��� ����� ��������� �� ���������� �� ������ ������.
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
left join category c
on ch.category_id=c.id
union
select g.name as good_name, c.name as category_name
from good g
left join category_has_good ch
on g.id=ch.good_id
right join category c
on ch.category_id=c.id
order by good_name

--�������� �������� �������, ������� ��������� � ��������� 'Cakes' ��� ���������� � ������� ������� ������ ������� 'delivering'. ��������� �� ������ ��������� ���������� �������.
select g.name as good_name
from good g
join category_has_good ch
on g.id=ch.good_id
join category c
on ch.category_id=c.id
where c.name = 'Cakes'
union
select g.name as good_name
from good g
join sale_has_good sh
on g.id=sh.good_id
join sale sl
on sh.sale_id=sl.id
join status st
on sl.status_id=st.id
where st.name='delivering'
order by good_name

--�������� ������ ���� ��������� ��������� � ���������� ������ �������, ����������� � ������ ���������. ��� ����������� ������ ������� ��������������� ��������� ���������� ������ ������ ������ ���������, ������������ � ������� � ����� ��������.
select c.name as name, count(sl.id) as sale_num
from category c
left join category_has_good ch
on c.id=ch.category_id
left join good g
on ch.good_id=g.id
left join sale_has_good sh
on g.id=sh.good_id
left join sale sl
on sh.sale_id=sl.id
group by name
order by name

--�������� ������ ����������, �� ������� �� ���� ��������, ���� ������� ��������� �� ������� �� ��������� ������� ��� ������������ �� �������. ��� ���������, ������� ������������ �� �������, ���������� �������� ��������, � ������� ���� ������, ������� �� ������ ���������� ������� ��������� � ��������� 'rejected'.
select s.name as source_name
from source s
where not exists (select * from client c
where c.source_id=s.id)
Union
select s.name as source_name
from source s
join client c
on s.id=c.source_id
join sale sl
on c.id=sl.client_id
join status st
on sl.status_id=st.id
where st.name='rejected'
order by source_name

--������� �� ������� 'client' ���� 'code' � 'source_id'.
alter table `store`.`client`
drop column code,
drop column source_id,
drop foreign key fk_client_source1

--�������� � ������� 'sale_has_good' ��������� ����:
--��������: `num`, ��� ������: INT, ����������� ������������� ��������������� ��������: ���
--��������: `price`, ��� ������: DECIMAL(18,2), ����������� ������������� ��������������� ��������: ���
alter table `sale_has_good`
add column num int not null,
add column price decimal(18,2) not null

--�������� � ������� 'client' ���� 'source_id' ��� ������: INT, ����������� ������������� ��������������� ��������: ��.
--��� ������� ���� ���������� ����������� �������� ����� ��� ������ �� ���� 'id' ������� 'source'.
alter table `client`
add column source_id int,
add constraint fk_source_id foreign key (source_id) references source(id)


--�������� ������� 'best_offer_sale' �� ���������� ������:
--��������: `id`, ��� ������: INT, ����������� ������������� ��������������� ��������: ���, ��������� ����
--��������: `name`, ��� ������: VARCHAR(255), ����������� ������������� ��������������� ��������: ��
--��������: `dt_start`, ��� ������: DATETIME, ����������� ������������� ��������������� ��������: ���
--��������: `dt_finish`, ��� ������: DATETIME, ����������� ������������� ��������������� ��������: ���

create table `best_offer_sale`(
`id` int not null,
`name` varchar(255),
`dt_start` DATETIME not null,
`dt_finish` DATETIME not nullL,
primary key (`id`))





