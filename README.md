# CloudWalk Métis

## Brief Prelude.

*In Greek mythology, Metis was an Oceanid, daughter of Oceanus and Tethys, first wife of Zeus, and mother of Athena. Both Metis and her daughter were revered as goddesses of wisdom.* 

*Métis is also the name received by the **17th moon of Jupiter.***

In an attempt of capturing **CloudWalk's celestial essence** along with the signs of **sapience** and **vigilance**, the name Métis was chosen for this project.

---

## The goal.

The intention behind the deliverables contained in this project is to provide a platform for the generation of business insights based on CloudWalk's core: payment transactions.

**Main KPIs included:**

- Total Payment Volume - The quantity of individual transactions performed in a period for a given set of transaction characteristics.
- Average Ticket
- Ammount Transacted - Sum of the value of every transaction.

---

## The Idea.

Setting up a micro analytical processing environment, comprised of a database, BI tool, a Python execution environment and an AI agent platform.

---

### Considerations

Before we go on, the following premises were followed during the development of this project:

- Quantity of Merchants is ignored on this analysis, due to it's grouping grain, a given customer could show up in more than one line, hence producing unreliable results if aggregated.
- A 7 day moving average was used as standard aggregation. This was done to capture a more precise notion of growth or decline tendencies. Since point to point comparison can produce misleading results in seasonal series. Instant non-aggregated values are labeled with “current”, or “day value”.

---

### The Structure.

### Supabase / PostgreSQL

On supabase, a simple setup was made, in order to contain the source data , processed time-series data *(see on deepnote section)* and a stored procedure, used for sankey flow analysis *(see on metabase section).*

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/refs/heads/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_02.54.04.png?token=GHSAT0AAAAAADEBAUHVX3YLHLTDP4LUK4N62ETBKLA](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_02.54.04.png?raw=true)

### Screenshots

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_02.56.30.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_02.56.30.png?raw=true)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/b5645646-a2f4-4d80-9357-f4028fad18f9.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/b5645646-a2f4-4d80-9357-f4028fad18f9.png?raw=true)

### Deepnote

Due to it's native SQL + Python capabilities, Deepnote was chosen as the python execution environment used in anomaly detection routines.

The python notebook can be acessed [here](https://deepnote.com/app/cacau/Screening-Challenge-CloudWalk-Aug-2025-240a7bae-3c7a-49c5-b1ea-94d425c9a389?utm_source=app-settings&utm_medium=product-shared-content&utm_campaign=data-app&utm_content=240a7bae-3c7a-49c5-b1ea-94d425c9a389).

The notebook reads the data from supabase, processes it and inserts it into two tables, one for each detection method:

1. **Seasonal Decomposition**

This method was a strong choice for the TPV time series due to it's strong seasonal characteristics. Beside providing ani insightful visualization of an hidden rupture between march 2 and 4

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/2a134ae8-9ec9-4ac7-8b2e-434ec3832d53.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/2a134ae8-9ec9-4ac7-8b2e-434ec3832d53.png?raw=true))

Weekly seasonality was observed graphically and used throughout the process.

The main downside with Seasonal Decomposition is the lag observed to render the trend. 

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.16.58.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.16.58.png?raw=true)

1. **Support Vector Machines**

A One-Class SVM was used due to it's synergy with anomaly detection applications. 

One-Class Support Vector Machines analyze actual data points to find a function (boundary) that separates the most data points from outliers. It's tolerance can be parametrized through ν (nu) and in this case a 0.05 value was used (percentage of expected anomalies)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.23.48.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.23.48.png?raw=true)

We can see by this graph that the SVM struggled with the first few weeks of the year, but converged with Seasonal Decomposition in the major anomaly. This exemplifies the potential for cross-validation between these models.

After the calculation, each dataset is inserted in their tables using panda's native sql method.

### Metabase

Metabase is the heart of this project, hosting most of all data aggregation and business logic. The dashboard has 4 pages:

---

1. **Main**

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.36.01.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.36.01.png?raw=true)

The entrance to the dashboard, containing:

- Summary Big Numbers
    - Current TPV Value (”Today”)
    - 7d Aggregation TPV + 1d / 7d / 28d comparisons
    - Trend / Anomaly / Actual Day Value Line Graph
    - Radar Graph based on the TPV for fast composition insight

---

1. **Feature Analysis**

In this page, the intention is to provide a side by side comparison of each feature's impact on the three main metrics.

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.40.35.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.40.35.png?raw=true)

The visuals on this are simple, but rely on the standard vertical bar chart to maximize the proportion comprehension between categories. Each metric was addressed in a separate graph to avoid competition between distinct domains of information and dissimilar axis ranges.

---

1. **Sankey Analysis**

The sankey analysis was brought as a complement for the exploration of relations between features.

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.43.43.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.43.43.png?raw=true)

It can exhibit from 2 to 4 stages of features and is great to show what are the common shares of features inside other features.

The value of the shares can be customized and can show either the sum or the average of **installment quantities, amount transacted** or **quantity transaction.**

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.48.25.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.48.25.png?raw=true)

In this example, we can see the average number of installments for every PJ client, segmented by product. This allows us to quickly realize that the “link” product has on average the highest amount of installments when used by PJ customers.

---

1. **Alerts**

The alerts page contains metabase-native alerts.

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/fc94fde2-d8cc-4fdb-bafa-96aa77098908.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/fc94fde2-d8cc-4fdb-bafa-96aa77098908.png?raw=true)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.51.44.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.51.44.png?raw=true)

These alerts are a native manner of creating alerts on metabase.

In this example, an alarm will be sent at 08:00 AM **if the related metabase question produce any results.**

These questions were purposely put on a alarming state for demonstration purpose. When alerting, an email is sent with the question info within it, such as:

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.53.57.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.53.57.png?raw=true)

An example of 3 point in 30 day trigger for the alarm was used here, but anything that can be modelled in SQL can be used as a trigger for the alarm.

These alarms can also be used for general information, Dasboards can also be **subscribed**

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.57.08.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.57.08.png?raw=true)

For dashboard subscriptions, a summary email is sent containing all questions

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.57.44.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_03.57.44.png?raw=true)

### N8N

N8N hosts 3 automations, being:

1. **Anomaly Notification** (Alternative to Metabase Triggered Notification)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.00.01.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.00.01.png?raw=true)

This is very similar to what metabase does, the only thing to point out here is that any x event on n8n could trigger the anomaly check (Or daily result check).

Didn't bother to go too far on the daily result update because of the metabase implemmentation, but the logic is the same.

---

1. **Data Processing Trigger**

![https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/b9ee6579-3e73-4e61-80b6-192510e331e5.png?raw=true)](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/b9ee6579-3e73-4e61-80b6-192510e331e5.png?raw=true)

Once again, a very simple trigger to kickstart the data processing for anomaly detection, wait for a webhook response for when the process ends (or timeouts) and send an email (or something else) afterwards.

---

and last, but not least

1. **Métis Agent**

This is a simple n8n ai agent using OpenRouter for model access and with metabase's questions as tools. This allows it to understand business questions and search for the necessary information to answer them:

![[https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.11.12.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.11.12.png?raw=true)

**Examples of questions and aswers:**

![https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.13.21.png?raw=true](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.13.21.png?raw=true)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.16.05.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.17.07.png?raw=true)

![https://raw.githubusercontent.com/strangercacaus/congenial-memory/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.17.07.png](https://github.com/strangercacaus/congenial-memory/blob/main/CloudWalk%20M%C3%A9tis%20247281cd42ce80c989ffc45fecb97d22/Screenshot_2025-08-06_at_04.16.05.png?raw=true)

### Links and credentials
This project was developed mostly on online platforms. SQL DDL files are available in the project.

Metabase Dashboard: [Access Here](https://grand-drift.metabaseapp.com/public/dashboard/aad2d97e-64e3-49bd-8c60-1b134a3cebce)

Metabase Environment: [Access Here](https://grand-drift.metabaseapp.com/)

Deepnote NotebookL: [Acess Here](https://deepnote.com/app/cacau/Screening-Challenge-CloudWalk-Aug-2025-240a7bae-3c7a-49c5-b1ea-94d425c9a389?utm_source=app-settings&utm_medium=product-shared-content&utm_campaign=data-app&utm_content=240a7bae-3c7a-49c5-b1ea-94d425c9a389)

### Thank You!
