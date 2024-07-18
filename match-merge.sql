TRUNCATE table integration.cmd_to_novatime_stg;

insert into integration.cmd_to_novatime_stg
SELECT -- start time (in)
    HASHBYTES('SHA2_512', CONCAT(EmployeeID, StartTime)) AS hash_value,
    EmployeeID AS CID,
    CASE WHEN task_code like 'EOS%' THEN 'GT' ELSE 'I' END AS cDataType,
    '0' AS nPayCode,
    StartTime AS tPDate,
    task_code
FROM integration.cmd_to_novatime_emtm

UNION ALL

SELECT -- end time (out)
    HASHBYTES('SHA2_512', CONCAT(EmployeeID, EndTime)) AS hash_value,
    EmployeeID AS CID,
    CASE WHEN task_code like 'EOS%' THEN 'O' ELSE 'I' END AS cDataType,
    '0' AS nPayCode,
    EndTime AS tPDate,
    task_code
FROM integration.cmd_to_novatime_emtm;