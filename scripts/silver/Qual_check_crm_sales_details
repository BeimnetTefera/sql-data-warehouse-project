-- Check for extra spaces in 'sls_ord_num'
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM
    bronze.crm_sales.details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Check if all 'sls_prd_key' values exist in the related product info table
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM
    bronze.crm_sales.details
WHERE 
    sls_prd_key NOT IN (
        SELECT prd_key FROM silver.crm_prd_info
    );

-- Check if all 'sls_cust_id' values exist in the customer info table,
-- as we will later join both tables using this key
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM
    bronze.crm_sales.details
WHERE 
    sls_cust_id NOT IN (
        SELECT cst_id FROM silver.crm_cust_info
    );

-- Check for invalid dates

        -- For the 'sls_order_dt' column
SELECT
    sls_order_dt
FROM
    bronze.crm_sales_details
WHERE 
    sls_order_dt <= 0 -- Since dates are stored as integers, check if negative or zero
    OR
    LEN(sls_order_dt) != 8 -- Dates should be 8 digits long (format: YYYYMMDD)
    OR
    sls_order_dt > 20250103 OR sls_order_dt < 19000103; -- Check if date is within valid range

        -- For the 'sls_ship_dt' column
SELECT
    sls_ship_dt
FROM
    bronze.crm_sales_details
WHERE 
    sls_ship_dt <= 0 -- Check for negative or zero
    OR
    LEN(sls_ship_dt) != 8 -- Should be 8 digits long
    OR
    sls_ship_dt > 20250103 OR sls_ship_dt < 19000103; -- Check valid range

        -- For the 'sls_due_dt' column
SELECT
    sls_due_dt
FROM
    bronze.crm_sales_details
WHERE 
    sls_due_dt <= 0 -- Check for negative or zero
    OR
    LEN(sls_due_dt) != 8 -- Should be 8 digits long
    OR
    sls_due_dt > 20250103 OR sls_due_dt < 19000103; -- Check valid range

-- Check for invalid date order (Order date must be earlier than Shipping or Due date)
SELECT 
    *
FROM
    bronze.crm_sales_details
WHERE
    sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Business Rules:
-- 1) Sales = Quantity * Price
-- 2) Sales, Quantity, and Price must not be negative, zero, or NULL
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM
    bronze.crm_sales_details
WHERE
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
    OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;
