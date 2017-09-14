
--emp Ա����empno Ա����/ename Ա������/job ����
--/mgr �ϼ����/hiredate �ܹ�����/sal н��/comm Ӷ��/deptno ���ű�ţ�
--dept ���ű�deptno ���ű��/dname ��������/loc �ص㣩
--���� = н�� + Ӷ��

select * from dept;
select * from emp;


--1���г�������һ��Ա�������в��š�

select * from dept d where exists (select 1 from emp e where e.deptno = d.deptno)

--2���г�н��ȡ�SMITH���������Ա�������������нˮSMITHԱ����

select * from emp where sal > (select e.sal from emp e where e.ename = 'SMITH')

--3���г�����Ա������������ֱ���ϼ���������

select e.ename,e1.ename from emp e left join emp e1 on e.mgr = e1.ename

--4���г��ܹ�����������ֱ���ϼ�������Ա����

select e.* from emp e inner join emp e1 on e.mgr = e1.ename where e.hiredate<e1.hiredate

--5���г��������ƺ���Щ���ŵ�Ա����Ϣ��������Щû��Ա���Ĳ��š�

select * from dept d left join emp e on d.deptno = e.deptno;

--6���г�����jobΪ��CLERK��������Ա�����������䲿�����ơ�

select e.ename,e.job,d.dname from emp e inner join dept d on e.deptno = d.deptno where e.job = 'CLERK' 

--7���г����н�����1500�ĸ��ֹ�����

select e.job,MIN(e.sal) from emp e group by e.job having MIN(e.sal)>1500

--8���г��ڲ��š�SALES�������۲���������Ա�����������ٶ���֪�����۲��Ĳ��ű�š�

select * from emp e inner join dept d on e.deptno = d.deptno and d.dname = 'SALES'

--9���г�н����ڹ�˾ƽ��н�������Ա����
select e.* from emp e inner join
(select AVG(sal) avg_sal from emp) as e1 on e.sal > e1.avg_sal

--10���г��롰SCOTT��������ͬ����������Ա����
select e.* from emp e inner join emp e1 on e.job = e1.job and e1.ename = 'SCOTT'

--11���г�н����ڲ���3��Ա����н�������Ա����������н��

select * from emp e where exists (select 1 from emp e1 where e1.deptno= 3 and e.empno = e1.empno and e.deptno <> 3)

--12���г�н������ڲ���3����������Ա����н���Ա��������н��

select * from emp e where sal > (select MAX(sal) from emp e1 where e1.deptno= 3 group by e1.deptno )

--13���г���ÿ�����Ź�����Ա��������ƽ�����ʺ�ƽ���������ޡ�

select e.deptno,COUNT(1) as [Ա������],AVG(e.sal+e.comm) as [ƽ������],AVG(YEAR(getdate())-cast(left(e.hiredate,4) as int)) as [ƽ����������] 
from emp e group by e.deptno

--14���г�����Ա�����������������ƺ͹��ʡ�

select e.ename,d.dname,e.sal+e.comm as [����] from emp e inner join dept d on e.deptno = d.deptno;

--15���г�����ͬһ�ֹ��������ڲ�ͬ���ŵ�Ա����һ����ϡ�

select e.job,e.ename,e.deptno,e1.ename,e1.deptno from emp e inner join emp e1 on e.job = e1.job and e.deptno > e1.deptno order by e.job;

--16���г����в��ŵ���ϸ��Ϣ�Ͳ���������
select d1.*,ISNULL(s.��������,0) from(
select d.deptno,COUNT(1) as [��������] from emp e inner join dept d on e.deptno = d.deptno group by d.deptno
) s right join dept d1 on s.deptno = d1.deptno;

--17���г����ֹ�������͹��ʡ�

select e.job,MIN(e.sal+e.comm) as [��͹���] from emp e group by e.job

--18���г��������ŵ�MANAGER�����������н��jobΪMANAGER����

select e.deptno,MIN(e.sal) as [�������н��] from emp e where e.job = 'MANAGER' group by e.deptno

--19���г�����Ա�����깤�ʣ�����н�ӵ͵�������

select e.empno,e.ename,(e.sal+e.comm)*12 as [��н] from emp e order by ��н desc

--20���г�emp���и����ŵĲ��źţ���߹��ʣ���͹���

select e.deptno,MAX(e.sal+e.comm) as [��߹���],MIN(e.sal+e.comm) as [��͹���] from emp e group by e.deptno

--21���г�emp���и�����jobΪ��CLERK����Ա������͹��ʣ���߹��ʡ�

select e.deptno,MAX(e.sal+e.comm) as [CLERK��߹���],MIN(e.sal+e.comm) as [CLERK��͹���] from emp e where e.job = 'CLERK' group by e.deptno

--22������emp����͹���С��2000�Ĳ��š��г�jobΪ��CLERK����Ա���Ĳ��źţ���͹��ʣ���߹���

select e.deptno,e.job,MAX(e.sal+e.comm) as [��߹���],MIN(e.sal+e.comm) as [��͹���] from emp e where e.job = 'SALESMAN' 
and exists (select 1 from emp e1 where e.deptno = e1.deptno having MIN(e1.sal+e1.comm) <2000)
 group by e.deptno,e.job 

--23�����ݲ��ź��ɸߵ��ͣ������ɵ͵��߶�Ӧÿ��Ա�������������źţ�����

select e.ename,e.deptno,e.sal+e.comm as [����] from emp e order by e.deptno desc,����

--24���г���buddy�����ڲ�����ÿ��Ա���������벿�ź�

select e.ename,e.deptno from emp e inner join emp e1 on e.deptno = e1.deptno and e1.ename = 'SCOTT'

--25���г�ÿ��Ա�������������ʣ����źţ�������

select e.ename,e.sal+e.comm as [����],d.deptno,d.dname from emp e inner join dept d on e.deptno = d.deptno

--26���г�emp�й���Ϊ��CLERK����Ա�������������������źţ�������

select e.ename,e.job,e.deptno,d.dname from emp e inner join dept d on e.deptno = d.deptno and e.job = 'CLERK'

--27������emp���й����ߵ�Ա�����г����������������������������Ϊmgr��

select e.ename,e1.ename from emp e inner join emp e1 on e.mgr = e1.ename

--28������dept���У��г����в����������źţ�ͬʱ�г������Ź���Ϊ��CLERK����Ա�����빤��

select d.deptno,d.dname,e.ename,e.job from dept d inner join emp e on d.deptno = e.deptno and e.job = 'CLERK'

--29�����ڹ��ʸ��ڱ�����ƽ��ˮƽ��Ա�����г����źţ����������ʣ������ź�����
select e1.deptno,e1.ename,e1.sal+e1.comm as [����] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) order by e1.deptno

--30������emp���г����������й��ʸ��ڱ�����ƽ�����ʵ�Ա�����Ͳ��źţ������ź�����

select e1.deptno,COUNT(1) as [���ʸ��ڲ���ƽ��ˮƽ��Ա����] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) group by e1.deptno order by e1.deptno

--31������emp�й��ʸ��ڱ�����ƽ��ˮƽ����������1�˵ģ��г����źţ�������ƽ�����ʣ������ź�����

select e1.deptno,COUNT(1) as [���ʸ��ڲ���ƽ��ˮƽ��Ա����],AVG(e1.sal+e1.comm) as [ƽ������] from emp e1 where e1.sal+e1.comm >
(select AVG(e.sal+e.comm) from emp e where e.deptno = e1.deptno group by e.deptno ) group by e1.deptno having COUNT(1)>1 order by e1.deptno

--32������emp�е����Լ���������5�˵�Ա�����г��䲿�źţ����������ʣ��Լ����������Լ�������

select e.deptno,e.ename,e.sal+e.comm as [����],(select COUNT(1) from emp e1 where e1.sal+e1.comm < e.sal+e.comm) as [���������Լ�������]
 from emp e where (select COUNT(1) from emp e1 where e1.sal+e1.comm < e.sal+e.comm) >5





























