CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_martial_status AS martial_status,
    CASE
        WHEN ci.cst_gndr != "N/A" THEN ci.cst_gndr -- CRM is the Master for gender Info
        ELSE COALESCE(cb.gen, 'N/A')
    END AS gender,
    cb.bdate AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info AS ci 
LEFT JOIN silver.erp_cust_az12 AS cb
ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;
