-- Check whether the keys are consistent, since we will use them to establish relationships

SELECT 
    cid
FROM bronze.erp_loc_a101
WHERE cid NOT IN (
    SELECT cst_key FROM silver.crm_cust_info
);

-- Data Standardization & Consistency: Review unique country values

SELECT DISTINCT 
    cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;
