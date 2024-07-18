WITH tasks as (
select
LTRIM(RTRIM(empl_code)) AS empl_code,
start_time,
end_time,
task_code,
   ROW_NUMBER() OVER (
      PARTITION BY LTRIM(RTRIM(empl_code)), LEFT(task_code, 3)
      ORDER BY start_time
   ) row_num
from [dbo].[emtm]
where (task_code like 'EOS[0-9][0-9]'
or task_code  like 'LUN[0-9][0-9]')
and update_date>=(dateadd(hh, -4, GETDATE()))
and start_time>=(dateadd(hh, -4, GETDATE()))

and start_status = -1
)
select empl_code AS EmployeeID,
start_time as StartTime,
(case when task_code like 'EOS%' then
		dateadd(minute,convert(numeric,substring(task_code,charindex('EOS',task_code)+3,2)),start_time)
     when task_code like 'LUN%' and (start_time=end_time OR end_time > dateadd(minute,convert(numeric,substring(task_code,charindex('LUN',task_code)+3,2)),start_time))
         THEN dateadd(minute,convert(numeric,substring(task_code,charindex('LUN',task_code)+3,2)),start_time)
else end_time
end) as EndTime,
task_code
from tasks
WHERE row_num=1
AND (db_name() not like '%RH' OR empl_code like '207%')
order by start_time