DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
account_id TEXT PRIMARY KEY,
account_name TEXT,
industry TEXT,
country TEXT,
signup_date DATE,
referral_source TEXT,
plan_tier TEXT,
seats INT,
is_trial TEXT,
churn_flag TEXT );

DROP TABLE IF EXISTS churn_events;
CREATE TABLE churn_events(
churn_event_id TEXT,
account_id TEXT,
churn_date DATE,
reason_code TEXT,
refund_amount_usd NUMERIC,
preceding_upgrade_flag TEXT,
preceding_downgrade_flag TEXT,
is_reactivation TEXT,
feedback_text TEXT);

DROP TABLE IF EXISTS feature_usage;
CREATE TABLE feature_usage(
usage_id TEXT,
subscription_id TEXT,
usage_date DATE,
feature_name TEXT,
usage_count INT,
usage_duration_secs INT,
error_count INT,
is_beta_feature TEXT);

DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions(
subscription_id TEXT,
account_id TEXT ,
start_date DATE,
end_date DATE,
plan_tier TEXT,
seats INT,
mrr_amount INT,
arr_amount INT,
is_trial TEXT,
upgrade_flag TEXT,
downgrade_flag TEXT,
churn_flag TEXT,
billing_frequency TEXT,
auto_renew_flag TEXT);

DROP TABLE IF EXISTS support_tickets;
CREATE TABLE support_tickets(
ticket_id TEXT,
account_id TEXT,
submitted_at DATE,
closed_at DATE,
resolution_time_hours NUMERIC,
priority TEXT,
first_response_time_minutes INT,
satisfaction_score NUMERIC,
escalation_flag TEXT);