
--emp 员工表（empno 员工号/ename 员工姓名/job 工作
--/mgr 上级编号/hiredate 受雇日期/sal 薪金/comm 佣金/deptno 部门编号）
--dept 部门表（deptno 部门编号/dname 部门名称/loc 地点）
--工资 = 薪金 + 佣金

select * from dept;
select * from emp;


--1、列出至少有一个员工的所有部门。

select * from dept d where exists (select 1 from emp e where e.deptno = d.deptno)

--2、列出薪金比“SMITH”多的所有员工。（大于最大薪水SMITH员工）

select * from emp where sal > (select e.sal from emp e where e.ename = 'SMITH')

--3、列出所有员工的姓名及其直接上级的姓名。

select e.ename,e1.ename from emp e left join emp e1 on e.mgr = e1.ename

--4、列出受雇日期早于其直接上级的所有员工。

select e.* from emp e inner join emp e1 on e.mgr = e1.ename where e.hiredate<e1.hiredate

--5、列出部门名称和这些部门的员工信息，包括那些没有员工的部门。

select * from dept d left join emp e on d.deptno = e.deptno;

--6、列出所有job为“CLERK”（办事员）的姓名及其部门名称。

select e.ename,e.job,d.dname from emp e inner join dept d on e.deptno = d.deptno where e.job = 'CLERK' 

--7、列出最低薪金大于1500的各种工作。

select e.job,MIN(e.sal) from emp e group by e.job having MIN(e.sal)>1500

--8、列出在部门“SALES”（销售部）工作的员工的姓名，假定不知道销售部的部门编号。

select * from emp e inner join dept d on e.deptno = d.deptno and d.dname = 'SALES'

--9、列出薪金高于公司平均薪金的所有员工。
select e.* from emp e inner join
(select AVG(sal) avg_sal from emp) as e1 on e.sal > e1.avg_sal

--10、列出与“SCOTT”从事相同工作的所有员工。
select e.* from emp e inner join emp e1 on e.job = e1.job and e1.ename = 'SCOTT'

--11、列出薪金等于部门3中员工的薪金的所有员工的姓名和薪金。

select * from emp e where exists (select 1 from emp e1 where e1.deptno= 3 and e.empno = e1.empno and e.deptno <> 3)

--12、列出薪金高于在部门3工作的所有员工的薪金的员工姓名和薪金。

select * from emp e where sal > (select MAX(sal) from emp e1 where e1.deptno= 3 group by e1.deptno )

--13、列出在每个部门工作的员工数量、平均工资和平均服务期限。

select e.deptno,COUNT(1) as [员工数量],AVG(e.sal+e.comm) as [平均工资],AVG(YEAR(getdate())-cast(left(e.hiredate,4) as int)) as [平均服务期限] 
from emp e group by e.deptno

--14、列出所有员工的姓名、部门名称和工资。

select e.ename,d.dname,e.sal+e.comm as [工资] from emp e inner join dept d on e.deptno = d.deptno;

--15、列出从事同一种工作但属于不同部门的员工的一种组合。

select e.job,e.ename,e.deptno,e1.ename,e1.deptno from emp e inner join emp e1 on e.job = e1.job and e.deptno > e1.deptno order by e.job;

--16、列出所有部门的详细信息和部门人数。
select d1.*,ISNULL(s.部门人数,0) from(
select d.deptno,COUNT(1) as [部门人数] from emp e inner join dept d on e.deptno = d.deptno group by d.deptno
) s right join dept d1 on s.deptno = d1.deptno;

--17、列出各种工作的最低工资。

select e.job,MIN(e.sal+e.comm) as [最低工资] from emp e group by e.job

--18、列出各个部门的MANAGER（经理）的最低薪金（job为MANAGER）。

select e.deptno,MIN(e.sal) as [经理最低薪金] from emp e where e.job = 'MANAGER' group by e.deptno

--19、列出所有员工的年工资，按年薪从低到高排序。

select e.empno,e.ename,(e.sal+e.comm)*12 as [年薪] from emp e order by 年薪 desc

--20、列出emp表中各部门的部门号，最高工资，最低工资

select e.deptno,MAX(e.sal+e.comm) as [最高工资],MIN(e.sal+e.comm) as [最低工资] from emp e group by e.deptno

--21、列出emp表中各部门job为’CLERK’的员工的最低工资，最高工资。

select e.deptno,MAX(e.sal+e.comm) as [CLERK最高工资],MIN(e.sal+e.comm) as [CLERK最低工资] from emp e where e.job = 'CLERK' group by e.deptno

--22、对于emp中最低工资小于2000的部门。列出job为’CLERK’的员工的部门号，最低工资，最高工资

select e.deptno,e.job,MAX(e.sal+e.comm) as [最高工资],MIN(e.sal+e.comm) as [最低工资] from emp e where e.job = 'SALESMAN' 
and exists (select 1 from emp e1 where e.deptno = e1.deptno having MIN(e1.sal+e1.comm) <2000)
 group by e.deptno,e.job 

--23、根据部门号由高到低，工资由低到高对应每个员工的姓名，部门号，工资

select e.ename,e.deptno,e.sal+e.comm as [工资] from emp e order by e.deptno desc,工资

--24、列出’buddy’所在部门中每个员工的姓名与部门号

select e.ename,e.deptno from emp e inner join emp e1 on e.deptno = e1.deptno and e1.ename = 'SCOTT'

--25、列出每个员工的姓名，工资，部门号，部门名

select e.ename,e.sal+e.comm as [工资],d.deptno,d.dname from emp e inner join dept d on e.deptno = d.deptno

--26、列出emp中工作为’CLERK’的员工的姓名，工作，部门号，部门名

select e.ename,e.job,e.deptno,d.dname from emp e inner join dept d on e.deptno = d.deptno and e.job = 'CLERK'

--27、对于emp中有管理者的员工，列出姓名，管理者姓名（管理者外键为mgr）

select e.ename,e1.ename from emp e inner join emp e1 on e.mgr = e1.ename

--28、对于dept表中，列出所有部门名，部门号，同时列出各部门工作为’CLERK’的员工名与工作

select d.deptno,d.dname,e.ename,e.job from dept d inner join emp e on d.deptno = e.deptno and e.job = 'CLERK'

--29、对于工资高于本部门平均水平的员工，列出部门号，姓名，工资，按部门号排序
select e1.deptno,e1.ename,e1.sal+e1.comm as [工资] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) order by e1.deptno

--30、对于emp，列出各个部门中工资高于本部门平均工资的员工数和部门号，按部门号排序

select e1.deptno,COUNT(1) as [工资高于部门平均水平的员工数] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) group by e1.deptno order by e1.deptno

--31、对于emp中工资高于本部门平均水平，人数多于1人的，列出部门号，人数，平均工资，按部门号排序

select e1.deptno,COUNT(1) as [工资高于部门平均水平的员工数],AVG(e1.sal+e1.comm) as [平均工资] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) group by e1.deptno having COUNT(1)>1 order by e1.deptno

--32、对于emp中低于自己工资至少5人的员工，列出其部门号，姓名，工资，以及工资少于自己的人数

select e.deptno,e.ename,e.sal+e.comm as [工资],(select COUNT(1) from emp e1 where e1.sal+e1.comm < e.sal+e.comm) as [工资少于自己的人数]
 from emp e where (select COUNT(1) from emp e1 where e1.sal+e1.comm < e.sal+e.comm) >5





























