SELECT 
  last_name,
  salary,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

SELECT 
  last_name,
  salary,
  SUM(salary) OVER () AS salary_total
FROM employees;

SELECT last_name, product_name, emp_total_sales,
       RANK() OVER (ORDER BY emp_total_sales DESC) AS sales_rank
FROM (
  SELECT e.last_name, p.product_name,
         SUM(s.quantity * s.price) OVER (PARTITION BY s.employee_id) AS emp_total_sales
  FROM sales s
  JOIN employees e ON s.employee_id = e.employee_id
  JOIN products p ON s.product_id = p.product_id
) q;

SELECT e.last_name, p.product_name, s.price,
       COUNT(*) OVER (PARTITION BY s.sale_date, s.product_id) AS product_trans_count,
       SUM(s.quantity * s.price) OVER (PARTITION BY s.sale_date, s.product_id) AS daily_product_total,
       LAG(s.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS prev_price,
       LEAD(s.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS next_price
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;

SELECT p.product_name, s.price,
       TRUNC(s.sale_date, 'MM') AS month,
       SUM(s.quantity * s.price) OVER (PARTITION BY p.product_id, TRUNC(s.sale_date, 'MM')) AS monthly_total,
       SUM(s.quantity * s.price) OVER (
         PARTITION BY p.product_id, TRUNC(s.sale_date, 'MM')
         ORDER BY s.sale_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS monthly_running_total
FROM sales s
JOIN products p ON s.product_id = p.product_id;

SELECT p.product_name, p.product_category,
       s2022.price AS sale_2022, s2023.price AS sale_2023,
       (s2023.price - s2022.price) AS sale_diff
FROM sales s2022
JOIN sales s2023 ON s2022.product_id = s2023.product_id
  AND TO_CHAR(s2022.sale_date, 'MM-DD') = TO_CHAR(s2023.sale_date, 'MM-DD')
  AND EXTRACT(YEAR FROM s2022.sale_date) = 2022
  AND EXTRACT(YEAR FROM s2023.sale_date) = 2023
JOIN products p ON p.product_id = s2022.product_id;

SELECT p.product_category, p.product_name, s.price,
       MIN(s.price) OVER (PARTITION BY p.product_category) AS min_cat_price,
       MAX(s.price) OVER (PARTITION BY p.product_category) AS max_cat_price,
       MAX(s.price) OVER (PARTITION BY p.product_category) - 
       MIN(s.price) OVER (PARTITION BY p.product_category) AS diff
FROM products p
JOIN sales s ON s.product_id = p.product_id;

SELECT p.product_name, s.sale_date,
       ROUND(AVG(s.price) OVER (
         PARTITION BY s.product_id 
         ORDER BY s.sale_date 
         ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ), 2) AS moving_avg_price
FROM sales s
JOIN products p ON s.product_id = p.product_id
ORDER BY p.product_name, s.sale_date;
    
SELECT p.product_category, p.product_name, s.price,
       RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS rank_in_cat,
       ROW_NUMBER() OVER (PARTITION BY p.product_category ORDER BY s.price) AS row_in_cat,
       DENSE_RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS dense_rank_in_cat
FROM products p
JOIN sales s ON s.product_id = p.product_id;

SELECT e.last_name, p.product_name,
       SUM(s.quantity * s.price) OVER (
         PARTITION BY s.employee_id ORDER BY s.sale_date
       ) AS cumulative_sales,
       RANK() OVER (ORDER BY s.quantity * s.price DESC) AS global_sales_rank
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;

SELECT DISTINCT e.first_name, e.last_name, j.job_title
FROM employees e
JOIN sales s ON s.employee_id = e.employee_id
JOIN jobs j ON j.job_id = e.job_id;