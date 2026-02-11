SELECT 'accounts' AS table_name, COUNT(*) FROM accounts
UNION ALL 
SELECT 'churn_events', COUNT(*) FROM churn_events
UNION ALL
SELECT 'feature_usage', COUNT(*) FROM feature_usage
UNION ALL
SELECT 'subscriptions',COUNT(*) FROM subscriptions
UNION ALL
SELECT 'support_tickets', COUNT(*) FROM support_tickets;

SELECT account_id,
	COUNT(*) AS churn_count,
	MIN(churn_date) AS first_churn,
	MAX(churn_date) AS last_churn
FROM churn_events
GROUP BY account_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS table_counts,
		COUNT(account_name) AS company_present,
		COUNT(industry) AS industry_present,
		COUNT(country) AS country_present,
		COUNT(plan_tier) AS plan_tier
FROM accounts;

SELECT COUNT(account_id) AS accounts,
		COUNT(churn_date) AS date_count,
		COUNT(reason_code) AS reason_counts
FROM churn_events;

SELECT COUNT(subscription_id) AS subscription_counts,
		COUNT(usage_date) AS date_counts,
		COUNT(feature_name) AS feature_counts,
		COUNT(usage_count) AS usage_count
FROM feature_usage;

SELECT COUNT(subscription_id) AS subscription_counts,
		COUNT(account_id) AS accounts,
		COUNT(start_date) AS date_counts,
		COUNT(plan_tier) AS plan_counts,
		COUNT(churn_flag) as churn_counts,
		COUNT(billing_frequency) AS billing_counts
FROM subscriptions;

SELECT COUNT(ticket_id) AS ticket_counts,
		COUNT(account_id) AS accounts,
		COUNT(submitted_at) AS submit_counts,
		COUNT(closed_at) AS closed_counts,
		COUNT(priority) AS priority_counts,
		COUNT(escalation_flag) AS flag_counts
FROM support_tickets;

SELECT subscription_id, COUNT(*) AS dup_counts
FROM  subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

SELECT DISTINCT industry
FROM accounts
ORDER BY industry;

UPDATE accounts
SET industry = TRIM(LOWER(industry));

SELECT * 
FROM subscriptions
WHERE end_date < start_date;

SELECT c.*,
	CASE 
		WHEN c.churn_date < s.start_date THEN 'Invalid'
		ELSE 'Valid'
	END AS churn_status	
FROM churn_events c
JOIN subscriptions s
ON c.account_id = s.account_id;

SELECT * 
FROM subscriptions
WHERE upgrade_flag = 'TRUE' AND downgrade_flag = 'TRUE';

-------FLAG TRUE VALUE---------
SELECT upgrade_flag,
		downgrade_flag,
		COUNT(*)
FROM subscriptions
GROUP BY upgrade_flag,downgrade_flag;

SELECT c.*
FROM churn_events c
LEFT JOIN subscriptions s
ON c.account_id = s.account_id
WHERE s.account_id IS NULL;

SELECT *
FROM feature_usage
WHERE usage_count < 0;

-------FLAG-------
SELECT f.*
FROM feature_usage f
JOIN subscriptions s
ON f.subscription_id = s.subscription_id
JOIN churn_events c
ON s.account_id = c.account_id 
WHERE f.usage_date > c.churn_date;

-------FLAG-----------
SELECT st.*
FROM support_tickets st
JOIN churn_events c
ON st.account_id = c.account_id
WHERE st.submitted_at > c.churn_date;

SELECT *
FROM support_tickets
WHERE priority = 'NULL';

CREATE VIEW clean_accounts AS
SELECT
  account_id,
  account_name,
  COALESCE(industry, 'unknown') AS industry,
  COALESCE(country, 'unknown') AS country
FROM accounts
WHERE account_id IS NOT NULL;

CREATE VIEW subscription_clean AS 
SELECT *
FROM subscriptions
WHERE start_date <= end_date AND NOT(upgrade_flag = 'TRUE' AND downgrade_flag = 'TRUE');

-----------------EDA------------------
SELECT industry, COUNT(*) AS industry_counts
FROM accounts
GROUP BY industry
ORDER BY industry_counts DESC;

WITH account_status AS (
    SELECT 
        a.industry,
        CASE WHEN c.account_id IS NULL THEN 'Active' ELSE 'Churned' END AS churn_status
    FROM clean_accounts a
    LEFT JOIN churn_events c ON a.account_id = c.account_id
)

SELECT * 
FROM account_status 
WHERE churn_status = 'Churned';

SELECT
  f.feature_name,
  COUNT(DISTINCT f.subscription_id) AS total_accounts,
  COUNT(DISTINCT c.account_id) AS churned_accounts,
  ROUND((COUNT(DISTINCT c.account_id)::NUMERIC /COUNT(DISTINCT f.subscription_id)) * 100,2) AS churn_rate
FROM feature_usage f
JOIN subscriptions s
ON s.subscription_id = f.subscription_id
LEFT JOIN churn_events c
  ON s.account_id = c.account_id
GROUP BY f.feature_name
ORDER BY churn_rate DESC
;

SELECT 
	CASE WHEN c.account_id IS NULL THEN 'Active' ELSE 'Churned' END AS churn_status,
	ROUND(AVG(f.usage_count),2) AS avg_usage_count
FROM feature_usage f
JOIN subscriptions s
ON f.subscription_id = s.subscription_id
LEFT JOIN churn_events c
ON s.account_id = c.account_id
GROUP BY churn_status
ORDER by avg_usage_count;

SELECT 
	COUNT(*) AS tickets_before_churn,
	ROUND(AVG(c.churn_date-s.submitted_at),2) AS avg_days_before_churn
FROM support_tickets s
JOIN churn_events c
ON s.account_id  = c.account_id
WHERE s.submitted_at <= c.churn_date;

SELECT
	reason_code,
	feedback_text,
	COUNT(*) AS churn_accounts,
	ROW_NUMBER() OVER(PARTITION BY reason_code ORDER BY COUNT(*) ASC) AS churns
FROM churn_events
GROUP BY reason_code,feedback_text;

WITH account_usage AS (
  SELECT
    subscription_id,
    AVG(usage_count) AS avg_usage
  FROM feature_usage
  GROUP BY subscription_id
),
usage_quartiles AS (
  SELECT
    subscription_id,
    NTILE(4) OVER (ORDER BY avg_usage) AS usage_quartile
  FROM account_usage
)
SELECT
  uq.usage_quartile,
  COUNT(DISTINCT uq.subscription_id) AS accounts,
  COUNT(DISTINCT c.account_id) AS churned_accounts
FROM usage_quartiles uq
JOIN subscriptions s
ON uq.subscription_id = s.subscription_id
LEFT JOIN churn_events c
  ON s.account_id = c.account_id
GROUP BY uq.usage_quartile
ORDER BY uq.usage_quartile;

SELECT	
	CASE 
	WHEN resolution_time_hours <= 24 THEN 'Fast'
	WHEN resolution_time_hours <= 72 THEN 'Moderate'
	ELSE 'Slow'
	END AS resolution_bucket,
	ROUND(COUNT(DISTINCT c.account_id) * 1.0
    / COUNT(DISTINCT t.account_id),2) AS churn_rate
FROM support_tickets t
LEFT JOIN churn_events c
  ON t.account_id = c.account_id
GROUP BY resolution_bucket
ORDER BY churn_rate;

SELECT 
	upgrade_flag,
	downgrade_flag,
	ROUND(COUNT(DISTINCT c.account_id) * 1.0
    / COUNT(DISTINCT s.account_id),2) AS churn_rate
FROM subscription_clean s
LEFT JOIN churn_events c
  ON s.account_id = c.account_id
GROUP BY upgrade_flag,downgrade_flag;