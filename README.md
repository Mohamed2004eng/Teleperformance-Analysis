# Call Center Performance Analytics: Excel + SQL + Power BI

**Business question:** Where is a 100,000-contact customer service operation losing service quality, and what are the three changes most worth making?

**Stack:** Excel (cleaning, buckets) -> SQL (KPI layer, 17 analytical queries) -> Python (statistical checks, charts) -> Power BI (6-page dashboard)

![Monthly KPIs](outputs/charts/01_monthly_kpis.png)

## 1. Headline results (2025, 100,000 contacts)

| KPI | Value | Definition |
|---|---|---|
| Total contacts | **100,000** | all rows |
| Handled contacts | **97,992** | reached an agent |
| Abandonment rate | **2.01%** (2,008) | abandoned / total |
| Resolution rate | **81.95%** | resolved / handled |
| Average handling time | **494 s (8 min 14 s)** | handled only |
| Average wait time | **69.7 s** | all contacts |
| SLA compliance | **63.1%** | within SLA / total (60 s inbound phone, 120 s other channels) |
| Transfer rate | **13.72%** | transferred / handled |
| First-contact resolution | **65.05%** | FCR / handled |
| Average satisfaction | **4.01 / 5** | handled and surveyed (37,382 surveys, 38% response) |

## 2. The story in one paragraph
Performance is stable month to month and the same across regions, agents, weekdays and hours. The problems sit in **three specific places**: the **inbound phone queue** (52% SLA vs 84.5% on every other channel, and 100% of abandonment), **transfers** (Technical Support and Complaints transfer 2x as often, and transferred contacts end up worse on every measure), and **unresolved contacts** (the cause of 83% of dissatisfied customers).

## 3. Answers to the 18 questions

### A. Executive performance
| # | Answer |
|---|---|
| 1 | **100,000** contacts received. |
| 2 | **97,992 handled**, **2,008 abandoned** (2.01%). All abandonment is on Inbound Phone, where the rate is 3.05%. |
| 3 | **81.95%** of handled contacts were resolved (18.05% / 17,684 were not). |
| 4 | **63.1%** met the SLA overall. By channel: Inbound Phone **52.0%**, Outbound 84.6%, Live Chat 84.3%, Email 84.8%. The data shows two SLA rules: wait <= 60 s for inbound phone, <= 120 s for the others (both fit 100% of rows). |
| 5 | KPIs are **flat**: SLA ranged 61.9% to 63.7%, resolution 81.6% to 82.8%, abandonment 1.78% to 2.30%, satisfaction 3.995 to 4.025. SLA's lowest month was November (61.9%, -0.9 pp) but each month's 95% margin is about +/-1 pp, so no month changed beyond normal noise. Volume is steady at about 8,300 per month (February is lower only because it has fewer days). |

### B. Customer experience
| # | Answer |
|---|---|
| 6 | **Technical Support (3.99)** and **Complaints (4.00)** are lowest, versus 4.02 to 4.03 for the others. The gap is small (0.04) but real. It is explained by what happens to the contact, not the department: after controlling for resolution, transfer and wait, department effects drop to about 0. Tech Support and Complaints transfer 20.0% and 18.5% of contacts vs about 10% elsewhere. |
| 7 | **Yes, but as a cliff, not a slope.** Waits under 3 minutes score **4.04**; waits of 3 minutes or more score **3.39**, and 57% of those customers are dissatisfied vs 11%. Only 4.4% of handled contacts wait 3+ minutes, which is why the overall correlation looks weak (Spearman -0.08). On inbound phone, abandonment also jumps from 2.5% to **13.6%** past 180 s. |
| 8 | Lowest resolution: **Service Outage 80.3%**, Long Wait 80.8%, Agent Complaint 81.1%, Setup Help 81.3%, Device Problem 81.4%. The bottom 8 reasons are all Technical Support or Complaints. The full range is narrow (80.3% to 83.4%). |
| 9 | Repeat-contact proxy rate: Returning **25.75%**, New 25.72%, **VIP 23.33%** (lowest). New and Returning are statistically identical. No segment stands out as a problem; VIPs are actually best. |
| 10 | **65.05%** resolved on first contact (**59.1%** if you also require no repeat flag). Contacts that were transferred have 0% FCR by definition. |

### C. Agent performance (case-mix aware)
Each contact gets an "expected" outcome: the average for contacts with the same Department, Reason, Priority, Customer Type and Channel. Agents are judged on **actual minus expected**, and flagged only when the gap exceeds a 3-sigma control limit (80 agents are being compared, so some will look extreme by chance).

| # | Answer |
|---|---|
| 11 | Highest volume: **A052 (1,304), A026 (1,299), A008 (1,297), A033 (1,284), A035 (1,283)**. Volume is very even (1,118 to 1,304; CV 3%), so it is not a meaningful performance signal. |
| 12 | Highest raw resolution: **A016 (84.1%), A043 (83.8%), A056 (83.5%), A075, A001**. After case-mix adjustment A016 leads at +2.3 pp, but **no agent is outside normal variation** (z = 2.0 at most). |
| 13 | Highest satisfaction: **A056 (4.057), A004, A017, A045, A058**, all about 4.05. Lowest adjusted: A065 and A060 (-0.07, z about -2.9), a **watch list**, not a verdict. |
| 14 | **No association.** Resolution by tenure band is 82.1% (<2y) to 81.8% (8y+); satisfaction is 4.01 to 4.02 in every band; agent-level correlations are all weak and not significant (resolution r = -0.13, p = 0.25; satisfaction r = 0.04, p = 0.71). |

**Why raw rankings would mislead:** Technical Support contacts take 573 s vs 464 s elsewhere and transfer twice as often, so an agent with more of them is disadvantaged. Even so, the adjustment barely reorders the agents (rank correlation raw vs adjusted = 0.99) because case mix is spread evenly across agents. The more important finding is that an agent's resolution rate in H1 does not predict H2 (correlation -0.03), so the spread between agents is mostly chance. Coaching should be based on process and quality reviews, not on league tables.

![Agent funnel](outputs/charts/05_agent_funnel.png)

### D. Operations and workforce planning
| # | Answer |
|---|---|
| 15 | Busiest hours: **06:00 (4,304), 23:00 (4,297), 09:00 and 16:00 (4,250), 07:00 (4,235)**. Busiest day: **Wednesday (14,559)**, quietest Tuesday (14,087). The pattern is **flat**: hourly volume varies by only 1.6% and neither hours nor weekdays differ more than chance (p = 0.30 and 0.11). Demand is spread evenly across 24 hours and 7 days, so this is a capacity and routing problem, not a peak-hour problem. |
| 16 | **Technical Support transfers the most**: 20.0% rate and **41% of all transfers** from 28% of volume (5,515 transfers). Then Complaints 18.5%. Billing, Sales and Account Services are all about 10%. |
| 17 | **No region is meaningfully weak.** All five are within 0.6 pp on SLA, 0.6 pp on resolution and 0.006 on satisfaction, with no significant differences (all p > 0.18). Central is nominally lowest on SLA (62.7%), and West/South on FCR (64.6%), but this is within noise. |
| 18 | See recommendations below. |

## 4. Three recommendations to management

**1. Fix the inbound phone queue (largest and most certain impact).**
Evidence: SLA is 52.0% on phone vs 84.5% elsewhere; every abandoned contact is a phone contact; abandonment is 2.5% when callers wait up to 3 minutes and **13.6%** beyond. Handled customers who wait 3+ minutes score 3.39 vs 4.04. Action: offer a callback at 90 to 120 s, route overflow to staff on other channels (which are meeting target), and set a 180 s alert for supervisors. Impact: lifting phone SLA to 70% raises overall SLA from 63% to **75%**; 80% gives **81.5%**. Cutting waits past 180 s removes about 338 avoidable abandons (17% of all).

**2. Cut transfers in Technical Support and Complaints.**
Evidence: transferred contacts are resolved 71.5% vs 83.6%, repeat 34.8% vs 24.0%, and score 3.74 vs 4.06. Action: first-line troubleshooting scripts and a knowledge base for the top transfer reasons (Setup Help, Service Outage), plus a short skills-based routing review. Impact (if transfer rate in those two departments fell to 10%): about **3,770 fewer transfers**, FCR from 65.1% to about **67.9%**, overall transfer rate from 13.7% to **9.9%**. This is an association, so run it as a pilot with a control group.

**3. Run a resolution-quality programme for the 18% unresolved contacts.**
Evidence: unresolved contacts make up **83% of all dissatisfied survey responses** (CSAT 3.39 vs 4.15). VIP customers resolve at 84.5% vs 81.7% for others, so a better outcome is achievable with the same agents. Action: root-cause review of unresolved Technical Support and Complaints cases, a follow-up process for open cases, and share the VIP handling approach. Impact: bringing non-VIP resolution to the VIP level means about **2,450 more resolved contacts** a year.

**Also recommended:** raise the 38% survey response rate and add a real customer-ID-based repeat metric (see data notes).

## 5. Data quality notes (these are findings too)
* **Abandoned rows carry outcomes.** 80.6% of abandoned contacts are marked Resolved and 737 have a satisfaction score, which is not logically possible. Resolution, FCR, transfer and satisfaction are therefore computed on **handled contacts only**; abandonment and SLA use all contacts.
* **Satisfaction is missing for 62% of contacts** (survey non-response). Averages describe responders only.
* **The repeat-contact flag is a proxy.** `RepeatContactWithin7Days` is true for 25.5% of contacts, but checking `CustomerID` and dates shows only 6.5% of contacts are followed by another from the same customer within 7 days, and the two are unrelated. Q9 uses the provided flag, as requested; treat it with caution.
* **SLA targets were inferred**, not documented: 60 s (inbound phone) and 120 s (other channels) match 100% of the rows.
* 326 handled records have hold time longer than handle time; kept, but worth checking at source.
* No duplicates, dates and weekdays are consistent, and no nulls apart from the above.

