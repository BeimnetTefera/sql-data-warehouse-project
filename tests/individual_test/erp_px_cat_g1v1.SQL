
-- Check for unwanted spaces in the 'cat' column

SELECT  
    cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);

-- Check for unwanted spaces in the 'subcat' column

SELECT  
    subcat
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);

-- Check for unwanted spaces in the 'maintenance' column

SELECT  
    maintenance
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
-- Review all distinct values in each column to identify inconsistencies

SELECT DISTINCT cat 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance 
FROM bronze.erp_px_cat_g1v2;
