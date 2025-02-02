## Introduction: 
When providing a credit card to a customer, banks had to rely on the applicant’s background and the history to understand the creditworthiness of the applicant. The process includes scrutinisation of application data with reference documents and this process was not always accurate and the bank had to face difficulties in approving the credit card.
Aims to help banking and financial institutions to identify and approve the creditworthy customers by using predictive models. 
Various supervised machine learning algorithms will be utilised to create models and implement the OSEMN process for the life cycle of this project. 

## Problem Statement:
Banks support economic expansion in a number of ways. The interest a bank or other financial institution charges on loans is one of their main sources of income. Banks provide a variety of loan solutions to their consumers and credit card is one of the solutions. Nearly every financial institution in the world is experiencing difficult times and credit risk while providing loan facilities to their end clients. It frequently becomes a non-performing credit facility because the repayments are not guaranteed. This will have an impact on banks' cash flow and cause backlogs to accumulate on their balance sheets, which won't look good if the bank is a publicly traded company.

Banks and financial institutions are critically assessing eligibility for a credit facility before granting facility to the customer due to the credit risk factor the credit card involved in. This process involves verification, validation, and approval and may cause delay of granting a facility which will be disadvantageous for the applicant as well as for the bank. Credit officers determine whether the borrowers can fulfil their requirements to being eligible and these judgments and predictions are always not accurate. Most of the times the banks and financial institutions doing the background check of the individual customers by analysing their eligibility ended up in making wrong decisions. 


## Project Objectives:
1. To propose an effective and high prediction accuracy credit card application approval prediction model with implementation of different machine learning algorithms.
2. To identify the key features related to the approval of a credit card application.
3. To deploy the proposed prediction model with highest prediction accuracy measured with implementation of web-based application.
---

**1. OSEMN**
OSEMN Framework is implemented in this project including 5 stages:
1. Data Obtaining
2. Data Scrubbing
3. Data Exploratory
4. Data Modelling
5. Data Interpretation
---

**Data Obtaining**
The data is obtained from Kaggle with the link: https://www.kaggle.com/datasets/rikdifos/credit-card-approval-prediction.

---

**Data preprocessing:**
1. Combine dattasets/application_record.csv and datasets/credit_record.csv
2. Checking on null value and fill up if necessary (Removal of features if necessary)
3. Outliers detection aand removal
4. Time Conversion
5. Skewness handling
6. Data binning
7. Data Encoding
8. Data scaling
9. Data spliting
10. Data balancing

---

**Exploration:**
Please refer to pandas_profile_file/credit_pred_profile.html
1. Check for missing value
2. Visualization
3. Correlation

---

**Model:**
1.  Random Forest (RandomisedSearchCV)
2.	Random Forest (GridSearhCV)
3.	XGBoost-Default
4.	XGBoost (RandomisedSearchCV)
5.	XGBoost (GridSearchCV)
6.	Balanced Bagging Classifier (XGBoost)
7.	Balanced Bagging Classifier (DecisionTree)
8.	MLP (RandomisedSearchCV)
9.	MLP (GridSearchCV)
10.	KNN (RandomisedSearchCV)
11.	KNN (GridSearchCV)
12.	GNB (RandomisedSearchCV)
13.	GNB (GridSearchCV)

---

**Deployment**
A Shiny App is developed for user to input data based on the criteria for credit card approval prediction, please refer to Credit_Card_Approval_App/app.R
A brief presentation about the project is available at Credit Card Approval with Prediction Model.Rmd

---
