/*
----------------------------------------------------
Quality Check
For crm_cust_info table
----------------------------------------------------
*/
-- Check For Bulls or Duplicates in Primary Key
-- Expectation: No Result
    SELECT 
        cst_id,
        count(*)
    FROM bronze.crm_cust_info
    GROUP BY cst_id
    HAVING count(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces for FirstName
    SELECT cst_firstname
    FROM bronze.crm_cust_info
    WHERE cst_firstname != TRIM(cst_firstname);

-- Check for Unwanted Spaces for LastName
    SELECT cst_lastname
    FROM bronze.crm_cust_info
    WHERE crm_lastname != TRIM(crm_lastname);

-- Data Standardaizationn & Consistency for cst_gndr table
    SELECT DISTINCT cst_gndr
    FROM bronze.crm_cust_info

-- Data Standardaizationn & Consistency for cst_martial_status table
    SELECT DISTINCT cst_martial_status
    FROM bronze.crm_cust_info


/*
----------------------------------------------------
For crm_prd_info
----------------------------------------------------
*/

-- Check For Nulls or Duplicate in Primary Key
-- Expectation: No Result

    SELECT
        prd_id,
        COUNT(*)
    FROM bronze.crm_prd_info
    GROUP BY prd_id
    HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Result

    SELECT prd_nm
    FROM bronze.crm_prd_info
    WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Numbers
-- Expectation: No Result 

    SELECT prd_cost
    FROM bronze.crm_prd_info
    WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency

    SELECT DISTINCT prd_line
    FROM bronze.crm_prd_info;

-- Check for Invalid Date Orders 
-- Expectation: No Result 

    SELECT *
    FROM bronze.crm_prd_info
    WHERE prd_end_date < prd_start_date; -- End date has to be always greater


/*
----------------------------------------------------
For crm_sls_ord_num
----------------------------------------------------
*/
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

/*
----------------------------------------------------
For erp_cust_az12
----------------------------------------------------
*/
-- Identify out-of-range birthdates (Age greater than 100 years or birthdate in the future)
    
    SELECT
        bdate
    FROM bronze.erp_cust_az12
    WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Check data standardization and consistency for the 'gen' (gender) field
    
    SELECT DISTINCT gen
    FROM bronze.erp_cust_az12;

/*
----------------------------------------------------
For erp_cust_az12
----------------------------------------------------
*/
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
/*
----------------------------------------------------
For erp_px_cat_g1v2
----------------------------------------------------
*/
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
