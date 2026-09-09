# Créer la base de données "customer_behavior";

Select * from customer limit 20;

-- Quel est le chiffre d'affaires total généré par les clients masculins vs féminins ?

Select gender, SUM(purchase_amount) as revenue 
from customer 
group by gender;


-- Quels clients ont utilisé une remise mais ont quand même dépensé plus que le montant moyen d'achat ?

SELECT customer_id, purchase_amount
from customer 
where discount_applied= 'Yes' and purchase_amount >= ( SELECT AVG(purchase_amount) from customer);

-- Quels sont les 5 produits ayant la meilleure note moyenne ?

SELECT item_purchased, ROUND(AVG(review_rating),2) AS "Average Product Rating"
from customer group by item_purchased
order by AVG(review_rating) desc
limit 5;
#can be highlighted in marketing campaigns

-- Comparer les montants moyens d'achat entre la livraison Standard et Express

SELECT shipping_type, ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

-- Les clients abonnés dépensent-ils plus ? Comparer la dépense moyenne et le chiffre d'affaires total entre abonnés et non abonnés

SELECT subscription_status, COUNT(customer_id) as total_customers, ROUND(AVG(purchase_amount),2) as avg_spend, ROUND(SUM(purchase_amount),2) as total_revenue
from customer 
group by subscription_status
order by total_revenue, avg_spend desc;

-- Quels sont les 5 produits ayant le pourcentage le plus élevé d'achats avec remise appliquée ?

 SELECT item_purchased, ROUND((Sum( CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*))*100 , 2) as discount_rate
 FROM customer
 group by item_purchased
 order by discount_rate desc
 limit 5;
 
-- Segmenter les clients en "Nouveaux", "Récurrents" et "Fidèles" selon leur nombre total d'achats précédents 
-- et afficher le nombre de clients dans chaque segment
 
 WITH customer_type as (
 SELECT customer_id , previous_purchases,
 CASE
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
from customer
)

select customer_segment , count(*) as 'Number of customers'
from customer_type
group by customer_segment;

-- Quels sont les 3 produits les plus achetés par catégorie
      # Utilisation des fonctions rank, dense_rank et row_number

WITH item_counts as (
select item_purchased, category , COUNT(customer_id) as total_orders,
ROW_NUMBER() OVER (PARTITION BY category order by count(customer_id) DESC) AS item_rank
from customer
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3; 

-- Les clients qui sont des acheteurs récurrents (plus de 5 achats précédents) sont-ils également susceptibles de s'abonner ?

SELECT subscription_status, COUNT(customer_id) as repeat_buyers
FROM customer
where previous_purchases > 5
group by subscription_status;

-- Quelle est la contribution au chiffre d'affaires de chaque tranche d'âge ?

SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer 
GROUP BY age_group
ORDER BY total_revenue DESC;




                                        
                                        


