-- 1. Qual foi o valor total gasto por cada cliente no restaurante?

SELECT 
  s.customer_id,
  SUM(m.price) AS total_gasto
FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS m 
  ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. Há quantos dias cada cliente visita o restaurante?

SELECT c.customer_id, 
	MAX(c.order_date) - MIN(c.order_date) AS dias
FROM dannys_diner.sales c
GROUP BY c.customer_id;

-- 3. Qual foi o primeiro item do menu comprado por cada cliente?

SELECT DISTINCT ON (customer_id)
  customer_id,
  order_date AS dia,
  product_id AS produto
FROM dannys_diner.sales
ORDER BY customer_id, order_date;

-- 4 Qual é o item mais comprado do menu e quantas vezes ele foi comprado por todos os clientes?

SELECT 	
  m.product_name,
	s.product_id, 
	COUNT(*) AS total_vezes_compra
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m 
	ON s.product_id = m.product_id
GROUP BY s.product_id, m.product_name
ORDER BY total_vezes_compra DESC
LIMIT 1;


