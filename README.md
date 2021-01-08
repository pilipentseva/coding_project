# coding_project
# A final project for the course "Coding for Economists" at CEU


## Data:

I decided it would be interesting to learn to download and work with data I can later use for the Econometrics course project. I decided to use data on public procurement in Russia under federal law 44 (FL 44). This data is located on ftp server of website. 

## The hypothetical research question:

The most common procurement type under this federal law is procurement through electronic auctions. There are 2 types of electronic auctions procedure: short electronic auction and long electronic auctions. Short electronic auctions allow finishing procurement procedures (application, registration and etc ) much faster than the long ones.

**Reform:**  Electronic auction purchase was qualified as a short auction if the maximum sum envisioned by the buyer was below 3 mln rubles. On 1st of July 2019 (01-07-2019) it changed. Now short auctions are up to 300 mln rubles. 

Purchases with larger sum may be more likely to be corrupted and now they even have easier procedures. So, I want to see which impact this reform had on procurement outcomes.

**Control group** - purchases below 3 mln rubles and higher 300 mln rubles. For them nothing changed.

**Treatment group** - purchases in range 3 mln - 300 mln rubles. 

## I did the following:

1) I downloaded the data for notifications, contracts and protocols of Moscow from ftp server of the Russian procurement website. Different information lies in different folders,so I needed all of them. I chose Moscow since I had no memory for all regions and Moscow has the largest number of purchases.

2) I restricted my data to 2018-2020 years (approximately 1.5 year before reform and 1.5 after reform).

3) The data was in xml format and was zipped. I unzipped files the way I could and parsed the relevant information from xml files.

4) I combined information from different years and different folders (contracts and notifications) in one dataset. I joined notifications and contracts by purchase number which was present in both data sets. I accounted for the fact that there may be changes and, as a result, several entries for each purchase number: I left only the last entry. 

5) I was interested in the following procurement outcomes and fixed effects (so I parsed and modified information accordingly):

   **ratio of final price to reserve price** : Reserve price is the maximum price (max_price) the buyer agreed to pay before the auction. It is published in the notifications. It is likely that the price was reduced as an auction took place, but in this project, I don’t extract data for this . 
   Final price (final_price) is not the final price after the auction, it the price of final spending for the contract. So, it may exceed the reserve price. Final price is published in contracts. I am using the ratio since purchases may be very different and it won’t make sense to compare monetary changes for medical supplies and infrastructure. 

   **execution period**: Difference in days between execution start date and execution end date. 

   **Fixed Effects**: buyer’s fixed effect (each buyer has a registration number, so I am able to identify them) and year-month fixed effect 

6) I created 2 dummy variables. One: if the purchase belonged to the treatment group based on the price of purchase (**treatment_group**), Another one: if the purchase was made before or after reform (**reform**)

7) I reduced the data because I had problems exporting it to STATA (utf-8 encoding and long rows) and it was also to big for GitHub upload. Reduced means that I got rid of some variables irrelevant for regressions (for instance, purchase description) , but i kept all observations. 

8) I exported the reduced data to csv and loaded it to Stata

9) In Stata, I built a histogram, logged variable execution time, created variable **reform_treatment** =  treatment_group * reform. 
Then I ran the following regressions with fixed effects and clustering of standard errors:

   **Procurement Outcome = b0 + b1 treatment_group + b2 reform_treatment + buyer’s fixed effect + year-month fixed effect + e**

   e is clustered at buyer’s level

   Procurement outcomes are: ratio of final to reserve price and execution period

10) I saved regression tables with outreg2 to doc
11) The hypothesis didn’t prove
