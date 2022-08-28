--������� ����� ������, �������� � ������ �������� ����� ��� ���� �� ���������� ����� 500 ���. �������: model, speed � hd
Select model, speed, hd 
from PC
where price<500

--������� �������������� ���������. �������: maker
Select distinct maker 
from Product
where type='Printer'

--������� ����� ������, ����� ������ � ������� ������� ��-���������, ���� ������� ��������� 1000 ���.
Select model, ram, screen 
from laptop
where price>1000

--������� ��� ������ ������� Printer ��� ������� ���������.
Select * 
from Printer
where color='y'

--������� ����� ������, �������� � ������ �������� ����� ��, ������� 12x ��� 24x CD � ���� ����� 600 ���.
Select model, speed, hd 
from PC
where (cd='12x'OR cd='24x') AND price<600

--��� ������� �������������, ������������ ��-�������� c ������� �������� ����� �� ����� 10 �����, ����� �������� ����� ��-���������. �����: �������������, ��������.
Select Distinct Product.maker, Laptop.speed
from Product Join
Laptop ON Product.model=Laptop.model
Where Laptop.hd>=10

--������� ������ ������� � ���� ���� ��������� � ������� ��������� (������ ����) ������������� B (��������� �����).
Select pc.model, pc.price 
from PC Join Product on PC.model=Product.model
where Product.maker='B'
Union
Select Laptop.model, Laptop.price 
from Laptop Join Product on Laptop.model=Product.model
where Product.maker='B'
Union
Select Printer.model, Printer.price 
from Printer Join Product on Printer.model=Product.model
where Product.maker='B'
Order By price Desc