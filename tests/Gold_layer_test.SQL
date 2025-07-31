-- Check if cst_id have duplicates

SELECT cst_id, COUNT(*) FROM
    (
        SELECT
            ci.cst_id,
            ci.cst_key,
            ci.cst_firstname,
            ci.cst_lastname,
            ci.cst_martial_status,
            ci.cst_gndr,
            ci.cst_create_date,
            cb.bdate,
            cb.gen,
            la.cntry
        FROM silver.crm_cust_info AS ci 
        LEFT JOIN silver.erp_cust_az12 AS cb
        ON ci.cst_key = cb.cid
        LEFT JOIN silver.erp_loc_a101 AS la
        ON ci.cst_key = la.cid
    ) sub_table

GROUP BY cst_id
HAVING COUNT(*) > 1

-- Cause we have two gender column we have to check if it is the same, if not we do data integration

SELECT DISTINCT
    ci.cst_gndr,
    cb.gen,
    CASE
        WHEN ci.cst_gndr != "N/A" THEN ci.cst_gndr -- CRM is the Master for gender Info
        ELSE COALESCE(cb.gen, 'N/A')
    END AS gender

FROM silver.crm_cust_info AS ci 
LEFT JOIN silver.erp_cust_az12 AS cb
ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;
