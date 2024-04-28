--Menggabungkan seluruh data kedalam Data Warehouse--
select a.CLIENTNUM as ClientNum, b.status as Status, a.Customer_Age, a.Gender, 
		a.Dependent_count, c.Education_Level as Education, 
		d.Marital_Status as Marital, a.Income_Category, e.Card_Category, 
		a.Months_on_book, a.Total_Relationship_Count, a.Months_Inactive_12_mon, 
		a.Contacts_Count_12_mon, a.Credit_Limit, a.Total_Revolving_Bal, a.Avg_Open_To_Buy, 
		a.Total_Trans_Amt, a.Total_Trans_Ct, a.Avg_Utilization_Ratio
into Datawarehouse_Customers
from customer_data_history as a
left join status_db as b on a.idstatus = b.id
left join education_db as c on a.Educationid = c.id
left join marital_db as d on a.Maritalid = d.id
left join category_db as e on a.card_categoryid = e.id;

select * from Datawarehouse_Customers

--Mengecek Tipe Data--
exec sp_columns Datawarehouse_Customers

--Mengubah Tipe Data--
alter table Datawarehouse_Customers
alter column Credit_Limit int

alter table Datawarehouse_Customers
alter column  Total_Revolving_Bal int

alter table Datawarehouse_Customers
alter column Avg_Open_To_Buy int

alter table Datawarehouse_Customers
alter column Contacts_Count_12_mon int

alter table Datawarehouse_Customers
alter column Months_Inactive_12_mon int

alter table Datawarehouse_Customers
alter column Total_Relationship_Count int

--EKSPLORASI DATA--
--Persentase Pengguna--
select Status, 
count(Status) as Jumlah_Pengguna, 
round(cast(count(Status) as float)*100.0/(select count(Status) from Datawarehouse_Customers), 2) as Persentase
from Datawarehouse_Customers
group by Status

--Pemakai Kartu berdasarkan edukasi--
select Education, count(*) as Jumlah_Customer
from Datawarehouse_Customers
Group by Education

--Rata-rata limit kredit dan saldo terpakai berdasarkan jenis kartu--
select Card_Category as Kategori_Kartu, avg(Credit_Limit) as Limit_Kredit, 
avg(Total_Revolving_Bal) as Kredit_Terpakai 
from Datawarehouse_Customers 
group by Card_Category

--Transaksi berdasarkan status pernikahan--
select Marital, sum(Total_Trans_Amt) as Jumlah_Transaksi from Datawarehouse_Customers
group by Marital																																																																															