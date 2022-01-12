WITH dept_emps AS(
select
	f.dataCriacao::date,
	MAX(fu.nome) as usuario,
	COUNT(f.codigo) as qtd
from imobiliario.foto f
inner join imobiliario.lote l on l.codigo = f.codGeografico
inner join ctgis.funcionario fu on fu.codigo = f.codFuncionarioCriacao
where l.codcliente = 360102
	and l.excluido = false
	and f.excluido = false
	and f.dataCriacao::date >= '2021-03-22'
GROUP BY f.dataCriacao::date, fu.codigo  
order by datacriacao
)  

 


select
	f.dataCriacao::date,
	MAX(fu.nome) as usuario,
	COUNT(f.codigo) as qtd,
	(select sum(qtd) 
	from dept_emps) as total
from imobiliario.foto f
inner join imobiliario.lote l on l.codigo = f.codGeografico
inner join ctgis.funcionario fu on fu.codigo = f.codFuncionarioCriacao
where l.codcliente = 360102
	and l.excluido = false
	and f.excluido = false
	and f.dataCriacao::date >= '2021-03-22'
GROUP BY f.dataCriacao::date, fu.codigo  
order by datacriacao

