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


CREATE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key As product_number,
    pn.prd_nm As product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL ; -- We don't want historical data where the end date is set, so we only include records where the end date is NULL.
