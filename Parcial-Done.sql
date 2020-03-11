Select concat(p.FirstName,' ',isnull(p.MiddleName,''),' ',p.LastName) as 'Nombre',s.TerritoryID, stid.Name 'Territorio', count(so.OrderQty) as Pred_vendidos, sub.promedio as Promedio_Territorio,
case 
	when count(so.OrderQty)>= sub.promedio then 'Cumplio'
	when count(so.OrderQty)< sub.promedio then 'No cumplio'
	else 'Fuera'
end as Estado
from Person.Person p
inner join Sales.SalesOrderHeader s on
p.BusinessEntityID = s.SalesPersonID
inner join Sales.SalesTerritory stid on
stid.TerritoryID = s.TerritoryID
inner join Sales.SalesOrderDetail so on
so.SalesOrderID = s.SalesOrderID
join (
	select s.TerritoryID, count(so.OrderQty) as contar, count(distinct(p.BusinessEntityID)) as personas, count(so.OrderQty)/count(distinct(p.BusinessEntityID)) as promedio
	from Sales.SalesOrderHeader s
	inner join Sales.SalesOrderDetail so on
	so.SalesOrderID = s.SalesOrderID
	inner join Person.Person p on
	s.SalesPersonID = p.BusinessEntityID
	where s.SalesPersonID is not null
	group by  s.TerritoryID
) sub on
sub.TerritoryID = stid.TerritoryID 
where p.PersonType ='sp'
group by concat(p.FirstName,' ',isnull(p.MiddleName,''),' ',p.LastName), s.TerritoryID, stid.Name, sub.promedio
order by 'Nombre' desc;
