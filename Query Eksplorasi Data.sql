--Menggabungkan seluruh data kedalam satu tabel baru--
select a.CLIENTNUM, b.status, a.Customer_Age, a.Gender, 
		a.Dependent_count, c.Education_Level as Education, 
		d.Marital_Status as Marital, a.Income_Category, e.Card_Category, 
		a.Months_on_book, a.Total_Relationship_Count, a.Months_Inactive_12_mon, 
		a.Contacts_Count_12_mon, a.Credit_Limit, a.Total_Revolving_Bal, a.Avg_Open_To_Buy, 
		a.Total_Trans_Amt, a.Total_Trans_Ct, a.Avg_Utilization_Ratio
into Customer_History
from customer_data_history as a
left join status_db as b on a.idstatus = b.id
left join education_db as c on a.Educationid = c.id
left join marital_db as d on a.Maritalid = d.id
left join category_db as e on a.card_categoryid = e.id;

--Persentase Pengguna--
select status, 
		count(status) as Jumlah_Customer, 
		round(cast(count(status) as float)*100.0/(select count(status) from Customer_History), 2) as Persentase
into Persentase_Customer
from Customer_History
group by status

--Rata-rata pemakaian berdasarkan jenis pemasukan dan status pernikahan--
select Marital as Status_Pernikahan, Income_Category as Kategori_Pendapatan, avg(Total_Revolving_Bal) as Avg_Pemakaian_Saldo
into Marital_Income
from Customer_History
group by Marital, Income_Category
order by Marital,
				case 
					when Income_Category = 'Unknown' then 1
					when Income_Category = 'Less than $40K' then 2
					when Income_Category = '$40K - $60K' then 3
					when Income_Category = '$60K - $80K' then 4
					when Income_Category = '$80K - $120K' then 5
					when Income_Category = '$120K +' then 6
				end;

--Customer Card--
select Card_Category as Kategori_Kartu, round(avg(Avg_Utilization_Ratio), 2) as Rasio_Pemakaian, 
count(*) as Pengguna 
into Customer_Card
from Customer_History
where status = 'Existing Customer'
group by Card_Category

--Pemakai Kartu berdasarkan edukasi--
select Education, count(*) as Jumlah_Customer
into Education_Customer
from Customer_History
Group by Education