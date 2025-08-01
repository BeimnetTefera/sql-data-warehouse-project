/*
******************************************************************************
                        Quality Checks
******************************************************************************
Script Purpose:
  - This script performs quality checks to validate the integrity, consistency, 
  and accuracy of surrogate keys in dimenstion tables.
  - Uniqeness of surrogate keys in the dimension tables.
  - Referential integrity between fact and dimenstion tables.
  - Validations of relationships in the data model for analaytical purposses.

Usage Notes:
  - Run these checks after data loading silver layer.
  - Investigate and resolve any discripancies found during checks.
******************************************************************************
*/

-----------------------------------------------------------------------
                         -- Customer Table
-----------------------------------------------------------------------

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

-----------------------------------------------------------------------
                           -- Product Table
-----------------------------------------------------------------------

-- Check if the product key is not duplicated
SELECT prd_key, COUNT(*) FROM
    (
        SELECT
            pn.prd_id,
            pn.cat_id,
            pn.prd_key,
            pn.prd_nm,
            pn.prd_cost,
            pn.prd_line,
            pn.prd_start_dt,
            pc.cat,
            pc.subcat,
            pc.maintenance
        FROM silver.crm_prd_info AS pn
        LEFT JOIN silver.erp_px_cat_g1v2 AS pc
        ON pn.cat_id = pc.id
        WHERE prd_end_dt IS NULL 
    ) sub_table
    GROUP BY prd_key
    HAVING COUNT(*) > 1;

-----------------------------------------------------------------------
                            -- Sales Table
-----------------------------------------------------------------------

-- Check the data model connectivity between fact and dimensions

SELECT *
FROM gold.fact_sales As f 
LEFT JOIN gold.dim_customers AS c 
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products AS p
ON  p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS  NULL;
