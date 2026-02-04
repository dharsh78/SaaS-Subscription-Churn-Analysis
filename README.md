# SaaS Subscription Churn Analysis

## 📌 Project Overview
This project analyzes SaaS customer churn to identify key risk drivers across industries, plans, regions, and customer behavior.  
The goal is to uncover actionable insights that can help improve customer retention, reduce revenue loss, and support data-driven decision-making.

---

## 🛠 Tools Used
- Python (Pandas, NumPy)
- SQL
- Tableau
- Data Cleaning & Exploratory Data Analysis (EDA)
- Dashboarding & Reporting

---

## 📊 Key Insights

### Customer & Industry Trends
- The company serves a balanced mix of industries, reducing dependency risk but requiring **segment-specific strategies**:  
  - DevTools (23%)  
  - FinTech (22%)  
  - Cybersecurity (20%)  
  - HealthTech (19%)  
  - EdTech (16%)

- **80% of accounts churned**, indicating a serious retention issue impacting recurring revenue and long-term growth.

- Churn is **concentrated in specific industries**, not evenly distributed:
  - DevTools (24%)  
  - FinTech (21%)  
  - Cybersecurity (20%)  
  - HealthTech (19%)  
  - EdTech (17%)

---

### Product, Support & Behavior Insights
- Churn is **not driven by early feature engagement**, indicating onboarding alone is not the problem.
- Customers typically raise support issues **~10 months before churning**, creating a large window for proactive intervention.
- Churn exceeds **65% across all industries**, with DevTools, EdTech, and Cybersecurity being the highest-risk segments.
- Churn is high across all plans:
  - Pro: 72.47%  
  - Enterprise: 70.13%  
  - Basic: 68.45%  
  This suggests churn risk increases slightly with higher-tier plans.

- All countries show high churn (>56%), with **UK, France, and the US** being the top three.
- Churn remains high across all customer priority levels (>69%).

---

### Support & Upgrade Signals
- Top churn drivers:
  1. Features  
  2. Support issues  
  3. Budget constraints  

- Feature usage has **limited impact on churn** (38%–44%), suggesting feature availability alone does not ensure retention.
- Customers with escalated support issues show slightly higher churn, but escalation alone is **not the dominant factor**.
- Resolution speed alone does not significantly influence churn.
- Customers who upgraded plans show **higher churn**, suggesting upgrades often happen late in the customer lifecycle and may signal instability rather than loyalty.

---

## 📌 Recommendations

### 1. Shift retention focus to mid-lifecycle intervention
Monitor mid-to-late lifecycle signals such as declining usage, plan changes, and repeated support interactions to trigger proactive retention actions.

---

### 2. Treat plan upgrades and downgrades as risk signals
Any plan change should prompt customer success outreach focused on:
- Value realization
- Feature adoption
- Expectation alignment

---

### 3. Implement industry-specific retention strategies
- Develop tailored value messaging by industry
- Prioritize DevTools, FinTech, and Cybersecurity segments for targeted retention initiatives

---

### 4. Use support interactions as predictive signals
Support tickets raised months before churn should be treated as early warning indicators:
- Introduce risk scoring for repeated or escalated tickets
- Conduct proactive check-ins after unresolved or recurring issues

---

### 5. Re-evaluate higher-tier plan value proposition
Higher churn in Pro and Enterprise plans suggests a value-to-price mismatch:
- Review feature differentiation
- Improve post-upgrade onboarding
- Ensure advanced features are actively adopted

---

### 6. Address product and pricing concerns together
Since churn is primarily driven by features, support experience, and budget:
- Close critical feature gaps
- Improve perceived ROI
- Offer flexible pricing or usage-based adjustments where feasible

---

## 📈 Conclusion
This analysis highlights that churn is a **systemic issue across industries, plans, and regions**, driven more by lifecycle behavior and perceived value than by early engagement or support speed.  
Targeted, proactive, and segment-specific retention strategies are essential to improving customer lifetime value and sustaining long-term growth.

