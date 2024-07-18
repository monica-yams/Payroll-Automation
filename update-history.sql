WITH hist_data AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY CID, tPDate ORDER BY tPDate DESC) AS row_num 
    FROM integration.cmd_to_novatime_hist
)

INSERT INTO integration.cmd_to_novatime_hist(
    hash_value,
    CID,
    cDataType,  
    nPayCode,
    tPDate,
    task_code
)
SELECT  
    stg.hash_value,
    stg.CID,
    stg.cDataType,  
    stg.nPayCode,
    stg.tPDate,
    stg.task_code
FROM integration.cmd_to_novatime_stg stg 
LEFT JOIN (
    SELECT CID, tPDate, hash_value FROM hist_data WHERE row_num = 1
) hist ON hist.CID = stg.CID AND hist.tPDate = stg.tPDate
WHERE hist.hash_value IS NULL;