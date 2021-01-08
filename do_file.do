* LO-6: Break up work into smaller components using Stata .do files
pwd
cd C:\Users\AHHA
* LO - 7: Read .csv data in in Stata
import delimited data_final_reduced.csv
* LO-8: Fix common data quality errors in Stata (for example, string vs number, missing value)
* Purchasenumber was imported as number and I need it as string
tostring purchasenumber, replace format(%19.0f)
* LO-13: Create a graph (of any type) in Stata.
histogram ratio_final_to_reserve_price
histogram execution_period

* I can see that this graph has a "tail", so it makes sense to log this variable
gen ln_execution_period = ln(execution_period)

*LO-5: Automate repeating tasks using Stata “for” loops.
* I couldn't find a meaningful task for this, so let's just do smth

gen play = treatment_group

foreach v in play{
  gen b = 2
}

* LO_15: Install a Stata package. 
ssc install reghdfe

* Install ftools (remove program if it existed previously)
cap ado uninstall moresyntax
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

* Install reghdfe 5.x
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

* Install boottest for Stata 11 and 12
if (c(version)<13) cap ado uninstall boottest
if (c(version)<13) ssc install boottest

* Install moremata (sometimes used by ftools but not needed for reghdfe)
cap ssc install moremata

ftools, compile
reghdfe, compile

*LO-12: Run ordinary least squares regression in Stata

* I need one extra variable reform * treatment_group

gen reform_treatment = reform * treatment_group

*Regression for procurement outcome "ratio_final_to_reserve_price" with 2
* fixed effects: year-month and buyer and clustering at the buyer level

reghdfe ratio_final_to_reserve_price treatment_group reform_treatment, absorb(month_year responsibleorg_regnum) vce(cluster responsibleorg_regnum)

*Regression for procurement outcome "execution_period" with 2
* fixed effects: year-month and buyer and clustering at the buyer level

reghdfe execution_period treatment_group reform_treatment, absorb(month_year responsibleorg_regnum) vce(cluster responsibleorg_regnum)

* LO-11: Save data in Stata.
save "C:\Users\AHHA\stata_final.dta"

*LO-14. Save regression tables and graphs as files. Demonstrate both.
histogram execution_period
graph export "C:\Users\AHHA\Graph.pdf", as(pdf) name("Graph")

ssc install outreg2

reghdfe ratio_final_to_reserve_price treatment_group reform_treatment, absorb(month_year responsibleorg_regnum) vce(cluster responsibleorg_regnum)
outreg2 using myreg_one.doc, replace ctitle (Model 1)


reghdfe execution_period treatment_group reform_treatment, absorb(month_year responsibleorg_regnum) vce(cluster responsibleorg_regnum)

outreg2 using myreg_two.doc, replace ctitle (Model 2)
