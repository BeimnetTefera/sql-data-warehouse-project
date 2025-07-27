/*
----------------------------------------------------
For crm_prd_info
----------------------------------------------------
*/

PRINT 'Truncating Table: silver.crm_prd_info';
TRUNCATE TABLE silver.crm_prd_info;

PRINT 'Inserting Data Into: silver.crm_prd_info';
INSERT INTO silver.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_date,
    prd_end_date
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract the category ID and replace '-' with '_'
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extract the product key from the 7th character onward
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost, -- Replace NULL values with 0
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line, -- Map product line codes to descriptive values
    CAST(prd_start_dt AS DATE) AS prd_start_date, -- Remove the time portion by casting to DATE
    CAST(
        LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
        AS DATE
    ) AS prd_end_date -- Calculate the end date as one day before the next start date; cast to DATE to remove the time
FROM bronze.crm_prd_info;

    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_date,
    CAST(LEAD (prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_date) - 1 AS DATE) AS prd_end_date,
FROM bronze.crm_prd_info;
