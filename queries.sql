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

-- 4. Qual é o item mais comprado do menu e quantas vezes ele foi comprado por todos os clientes?

SELECT 	
	m.product_name,
	COUNT(*) AS total_vezes_compra
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m 
	ON s.product_id = m.product_id
GROUP BY s.product_id, m.product_name
ORDER BY total_vezes_compra DESC
LIMIT 1;

-- 5. Qual item foi o mais popular para cada cliente?

SELECT DISTINCT ON (s.customer_id)
	s.customer_id,
	COUNT(*) AS prod_popular

FROM dannys_diner.sales AS s
GROUP BY s.customer_id, s.product_id
ORDER BY s.customer_id, COUNT(*) DESC;


-- 6. Qual item foi comprado primeiro pelo cliente depois que ele se tornou membro?

/* Nessa questão foi considerado o próximo dia a partir da data que o cliente virou membro, pois temos um caso que
o cliente A virou membro e fez um pedido no mesmo dia, não é possível saber se ele fez o pedido antes 
ou depois de se tornar membro, por isso a query foi feita considerando o primeiro dia após a data que o cliente virou membro. */

SELECT DISTINCT ON(m.customer_id)
	m.customer_id,
	m.join_date,
	s.order_date,
	s.product_id

FROM dannys_diner.members AS m
JOIN dannys_diner.sales AS s ON m.customer_id = s.customer_id
WHERE s.order_date > m.join_date
ORDER BY m.customer_id, s.order_date ASC;

-- 7. Qual item foi comprado pouco antes do cliente se tornar um membro?

SELECT DISTINCT ON(m.customer_id)
	m.customer_id,
	m.join_date,
	s.order_date,
	s.product_id

FROM dannys_diner.members AS m
JOIN dannys_diner.sales AS s ON m.customer_id = s.customer_id
WHERE s.order_date < m.join_date
ORDER BY m.customer_id, s.order_date DESC;

-- 8. Qual é o total de itens e valores gastos por cada membro antes de se tornar membro?

SELECT 
	s.customer_id, 
	COUNT(*) AS total_itens,
	SUM(mn.price) AS total_gasto

FROM dannys_diner.sales AS s
JOIN dannys_diner.members AS mb ON s.customer_id = mb.customer_id
JOIN dannys_diner.menu AS mn ON s.product_id = mn.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9. Se cada US$ 1 gasto equivale a 10 pontos e o sushi tem um multiplicador de pontos de 2x, quantos pontos cada cliente teria?

SELECT 
	s.customer_id,
	s.product_id,
	mn.price,
	mn.price * 
		CASE 
			WHEN s.product_id = 1 THEN 20
			ELSE 10
		END AS total_de_pontos

FROM dannys_diner.sales AS s
JOIN dannys_diner.menu AS mn ON s.product_id = mn.product_id
ORDER BY s.customer_id;