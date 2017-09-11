select * from Student;
select * from SC;
select * from Teacher;
select * from Course;


--1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数

select s.*,s1.C#,s1.score,s2.C#,s2.score from Student s 
inner join SC s1 on s.S# = s1.S# and s1.C#=1
inner join SC s2 on s.S# = s2.s# and s2.C#=2
where s1.score>s2.score

--1.1、查询同时存在"01"课程和"02"课程的情况
--1.2、查询同时存在"01"课程和"02"课程的情况和存在"01"课程
--但可能不存在"02"课程的情况(不存在时显示为null)
select s.*,s1.C#,s1.score,s2.C#,s2.score from Student s 
inner join SC s1 on s.S# = s1.S# and s1.C#=1
left join SC s2 on s.S# = s2.s# and s2.C#=2

--4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
--4.1、查询在sc表存在成绩的学生信息的SQL语句。

select s.*,s1.ave from Student s,
(select distinct s#,AVG(score) 
over(partition by s#) as ave from SC ) s1 
where s.S#=s1.S# and s1.ave<60;

select * from student where s# in 
(select S# from SC where score is not null)


--5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩

select st.*,  a.cnt,a.total from student st left join 
(select s.s#,count(1) cnt,sum(s.score) total  
from  sc s group by s.s# ) a  on a.s#=st.s#

--6、查询"李"姓老师的数量 
select count(1) from teacher t where t.tname like '李%'


--7、查询学过"张三"老师授课的同学的信息 
select st.*  from teacher t 
inner join course c on t.t# = c.t# 
inner join sc cc on cc.c#=c.c#  
inner join student st on st.s#= cc.s# 
where t.tname ='张三'
--8、查询没学过"张三"老师授课的同学的信息 


--9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息


--10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息


--11、查询没有学全所有课程的同学的信息 

--12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 

select distinct s.* from Student s inner join SC c on s.S#=c.S#
where c.C# in (select c1.C# from SC c1 where c1.S# = '01');

--12.1、查询没有一门课与学号为"01"的同学所学相同的同学的信息 

select s.* from Student s where s.S# not in
(select distinct s1.S# from Student s1 inner join SC c on s1.S#=c.S#
where c.C# in (select c1.C# from SC c1 where c1.S# = '01'));

--13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
--反向查询，查询至少有一门不同
select s.* from Student s where s.S# not in
(
select distinct s1.S# from Student s1 left join SC c on s1.S#=c.S#
where c.C# is null or (c.C# not in (select c1.C# from SC c1 
where c1.S# = '01'))
or exists
(select s2.S#,COUNT(1) from Student s2 left join SC c2 on s2.S#=c2.S# 
where s1.s# = s2.s#
group by s2.S# having COUNT(1)<>(select COUNT(1) from SC c3
where c3.S# = '01') )
)
--正向查询
select Student.* from Student where S# 
in (
select SC.S# from SC where S# <> '01'
and  exists
(select c1.S# from sc c1 where S# = c1.S# and SC.S#=c1.S# group by c1.S#
 having count(*) = (select count(*) from sc c2 where c2.S# = '01') )
and exists 
(select distinct c2.C# from SC c2 where c2.S# = '01' and SC.C# = c2.C#) 
group by SC.S# having count(1) = (select count(1) from SC where S#='01')
) 

--14、查询没学过"张三"老师讲授的任一门课程的学生姓名 

--第一步，查询"张三"老师讲授的所有课程
select c.C# from Course c 
inner join Teacher t on c.T# = t.T# and t.Tname='张三'
--查询学过张三老师讲授的任意一门课程的学生 exists 第一步结果
select sc1.* from SC sc1 where exists
(select c.C# from Course c 
inner join Teacher t on c.T# = t.T# and t.Tname='张三'
where sc1.C# = c.C# )
--取反
select s.* from Student s where not exists
(
select sc1.* from SC sc1 where exists
(select c.C# from Course c 
inner join Teacher t on c.T# = t.T# and t.Tname='张三'
where sc1.C# = c.C# and s.S# = sc1.S#)
)
--参考答案
select student.* from student where 
not exists (select distinct sc.S# from sc , course , teacher 
where sc.C# = course.C# and course.T# = teacher.T# 
and teacher.tname = N'张三' and student.S# =sc.S#) 

--15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
--查询不及格课程的数目和平均成绩，按学号分组
select sc1.S#,COUNT(1) con,AVG(sc1.score) av from SC sc1 
where sc1.score<60 group by sc1.S# 
--查询学生信息，where不及格数目>=2
select s.S#,s.Sname,s1.平均成绩 from Student s 
inner join 
(select sc1.S#,COUNT(1) con,AVG(sc1.score) as 平均成绩 from SC sc1 
where sc1.score<60 group by sc1.S# ) as s1 
on s1.S# = s.S# and s1.con >= 2
--第二种方法
 select st.s#,st.sname, avg(sc.score) from student st 
 inner join sc sc  on st.s#=sc.s# where sc.score<60 
 group by st.s#,st.sname having   count(1)>=2
 
--16、检索"01"课程分数小于60，按分数降序排列的学生信息

select s.*,sc1.score from Student s inner join SC sc1  
on s.s# = sc1.s# and sc1.c# = '01' and sc1.score<60 
order by sc1.score desc

--17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
--静态写法
select a.S# 学生编号 , a.Sname 学生姓名 , 
max(case c.Cname when N'语文' then b.score else null end) [语文], 
max(case c.Cname when N'数学' then b.score else null end) [数学], 
max(case c.Cname when N'英语' then b.score else null end) [英语], 
cast(avg(b.score) as decimal(18,2)) 平均分 from Student a 
left join SC b on a.S# = b.S# left join Course c on b.C# = c.C# 
group by a.S# , a.Sname order by 平均分 desc
--动态写法
declare @sql nvarchar(4000) 
set @sql = 'select a.S# 学生编号, a.Sname 学生姓名'
select @sql = @sql + ',max(case c.Cname when N'''+Cname+''' 
then b.score else null end) ['+Cname+']' 
from (select distinct Cname from Course) as t 
set @sql = @sql + ' , cast(avg(b.score) as decimal(18,2)) ' + N'平均分' 
+ ' from Student a left join SC b on a.S# = b.S# left join Course c 
on b.C# = c.C# group by a.S# , a.Sname order by ' + N'平均分' + ' desc' 
exec(@sql) 
--18、查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，
--课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
--及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

select c.C#,c.Cname,MAX(sc.score) as 最高分,MIN(sc.score) as 最低分,AVG(sc.score) as 平均分,
cast((select COUNT(1) from SC where score>=60 and C#=c.C#)*100/(select COUNT(1) from SC where C#=c.C#) as decimal(18,2)) as [及格率(%)] ,
cast((select COUNT(1) from SC where score>70 and score<=80 and C#=c.C#)*100/(select COUNT(1) from SC where C#=c.C#) as decimal(18,2)) as [中等率(%)] ,
cast((select COUNT(1) from SC where score>80 and score<=90 and C#=c.C#)*100/(select COUNT(1) from SC where C#=c.C#) as decimal(18,2)) as [优良率(%)] ,
cast((select COUNT(1) from SC where score>90 and score<=100 and C#=c.C#)*100/(select COUNT(1) from SC where C#=c.C#) as decimal(18,2)) as [优秀率(%)] 
from SC sc inner join Course c on c.C#=sc.C#
group by c.C#,c.Cname;

--19、按各科成绩进行排序，并显示排名
--Score重复时保留名次空缺
--Score重复时合并名次
--DENSE_RANK
select c.Cname,RANK() over(partition by sc.c# order by sc.score desc) as [名次],sc.score from SC sc 
inner join Course c on sc.C# = c.C#

--20、查询学生的总成绩并进行排名
--over()开窗函数，使用时注意distinct
select RANK() over(order by s.总成绩 desc) as [名次],s.S#,s1.Sname,s.总成绩 from 
(
select distinct SC.S#,SUM(sc.score) over(partition by sc.s#) as [总成绩] from SC sc
) as s inner join Student s1 on s.S# = s1.S#;
--分组
select S#,SUM(score) as [总成绩] from SC group by S# order by 总成绩 desc;

--21、查询不同老师所教不同课程平均分从高到低显示 

select distinct t.Tname,c.Cname,AVG(sc.score) over(partition by sc.C#) as [平均分] from SC sc
inner join Course c on sc.C# = c.C# inner join Teacher t on t.T# = c.T# order by 平均分 desc;

--22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩


