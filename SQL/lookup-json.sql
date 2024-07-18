WITH punches as (
SELECT 
    '{"CID":"' + stg.CID 
+ '","cDataType":"' + stg.cDataType
+ '","nPayCode":"' + stg.nPayCode
+ '","tPDate":"' + 
    (CONVERT(NVARCHAR(30), stg.tPDate, 120) + ' ' + 
        CASE WHEN CAST(stg.tPDate AS TIME) >= '12:00:00' THEN 'PM' ELSE 'AM' END)
+ '"'
+ CASE WHEN stg.task_code like 'EOS%' 
    THEN ',"cGroupsList": [{"nGroupNum": "15","cGroupCode": "1","cGroupDesc": ""}]}' 
    ELSE '}' END punch
FROM integration.cmd_to_novatime_stg stg
LEFT JOIN integration.cmd_to_novatime_hist hist ON hist.hash_value = stg.hash_value
WHERE hist.hash_value is null)
select '[' + coalesce(string_agg(cast(punch as varchar(max)), ','), '') + ']' punches, (select count(*) from punches) cnt from punches
