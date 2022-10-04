--������� � ������� fine ����� �������, ������� ������ �������� ��������, � ������������ � ������� �� ������� traffic_violation.
--��� ���� ����� �������� ������ � ������ ���� �������  sum_fine.
update fine f, traffic_violation tv
set f.sum_fine=tv.sum_fine
where f.sum_fine is null
and f.violation=tv.violation;

--������� �������, ����� ������ � ��������� ������ ��� ��� ���������, ������� �� ����� ������ �������� ���� � �� �� ������� ��� � ����� ���.
 --��� ���� ��������� ��� ���������, ���������� �� ���� �������� ��� ��� ���.
 --���������� ������������� � ���������� �������, ������� �� ������� ��������, ����� �� ������ ������ �, �������, �� ���������.
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2
order by name, name, number_plate, violation;

--� ������� fine ��������� � ��� ���� ����� ������������ ������� ��� ���������� �� ���������� ���� �������. 
--1:
update fine f, (
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2) qi
set f.sum_fine = f.sum_fine*2
where f.date_payment is null
and f.name=qi.name
and f.number_plate=qi.number_plate
and f.violation=qi.violation;

--2:
create table qi as
select name, number_plate, violation
from fine
group by name, number_plate, violation
having count(violation)>=2;

update fine f, qi
set f.sum_fine = f.sum_fine*2
where f.date_payment is null
and f.name=qi.name
and f.number_plate=qi.number_plate
and f.violation=qi.violation;

--� ������� fine ������� ���� ������ ���������������� ������ �� ������� payment; 
--��������� ����������� ����� � ������� fine � ��� ����  (������ ��� ��� �������, ���������� � ������� �������� � ������� payment) , ���� ������ ����������� �� ������� 20 ���� �� ��� ���������.
update fine f, payment p
set f.date_payment = p.date_payment,
f.sum_fine = if(datediff(f.date_payment, f.date_violation)<=20, f.sum_fine/2, f.sum_fine)
where f.date_payment is null
and f.name=p.name
and f.number_plate=p.number_plate
and f.violation=p.violation;

--������� ����� ������� back_payment, ���� ������ ���������� � ������������ ������� (������� � �������� ��������, ����� ������, ���������, ����� ������  �  ���� ���������) �� ������� fine.
create table back_payment as
select name, number_plate, violation, sum_fine, date_violation
from fine
where date_payment is null;

--������� �� ������� fine ���������� � ����������, ����������� ������ 1 ������� 2020 ����. 
delete from fine
where date_violation<'2020-02-01'