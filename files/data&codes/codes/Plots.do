
*********************** Replication *******************************************
clear all
cls
set more off

use "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_2010.dta"

foreach year in 2010 2011 2012 2013 2014 2015 {
	append using "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_`year'.dta"
}

sort co_ies co_curso 
replace num_stud = num_stud - 10
bys co_ies: gegen coies_stud = sum(num_stud)

bys co_ies year: gegen tot_worker_coies = sum(tot_workers_curso)
bys co_ies : gegen mode_adm = mode(tp_categoria_administrativa)
bys co_ies : gegen mode_org = mode(tp_organizacao_academica)
drop if tp_modalidade_ensino == 2

gen unc_above_med_work = above_med_work*entrepreneur
gen unc_above_med_wage = above_med_wage*entrepreneur

gen temp_var1 = string(co_ocde_area_detalhada,"%5.0g")
gen ocde = substr(temp_var1,1,2)
destring ocde, replace

gen co_iesbis = .
replace co_iesbis = 55000 if inlist(ocde, 42, 44, 46) & co_ies == 55
replace co_iesbis = 55001 if inlist(ocde, 34) & co_ies == 55
replace co_iesbis = 55002 if inlist(ocde, 52) & co_ies == 55
replace co_iesbis = 55003 if inlist(ocde, 22) & co_ies == 55
replace co_iesbis = 55004 if inlist(ocde, 48) & co_ies == 55
replace co_iesbis = 55005 if inlist(ocde, 72) & co_ies == 55
replace co_iesbis = 55006 if missing(co_iesbis) & co_ies == 55

replace co_ies = co_iesbis if co_ies == 55


************************** Graphs **********************************************


foreach yearloop in 2019 2020 2021{
gen ln_wage_`yearloop' = ln(wage_nozero_employee_`yearloop') if year==(`yearloop'-6)
}

drop if coies_stud < 100


/*
preserve
drop if ln_wage_2020==.
sort ln_wage_2020
gen order = _n
sum order, d
local p95 = r(p95)
local p50 = r(p50)
twoway (scatter ln_wage_2020 order if !inlist(co_ies,55000, 55001,55002, 55003, 55004, 55005, 55006) , color(gray%30) msize(vsmall)) ///
		(scatter ln_wage_2020 order if co_ies == 55000, color(red*1.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55001, color(blue*1.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55002, color(red*1) ) ///
		(scatter ln_wage_2020 order if co_ies == 55003, color(blue*0.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55004, color(red*0.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55005, color(green*1) ) ///
		(scatter ln_wage_2020 order if co_ies == 55006, color(yellow*1.5) ) , ///
		scheme(s1color) plotregion(style(none)) legend(order (2 "Science" 4 "Engineering" 6 "Comp Science" 3 "Business Adm" 5 "Humanities" 7 "Health" 8 "Other USP") cols(2) size(vsmall) position(11) ring(0) region(lstyle(none))) ytitle("Log Wages") xtitle("University Rank") xline(`p95', lpattern(dash) lcolor(gray%30)) ///
		xline(`p50', lpattern(dash) lcolor(gray%30)) ///
		text(10.3 1750 "Top 5%") text(10.3 870 "Median") ysc(range(7.5 10.5)) ylab(7.5 (1) 10.5) 
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wages.pdf", replace
restore
*/

preserve
gcollapse ln_wage_2019 ln_wage_2020 ln_wage_2021 unc_above_med_work unc_above_med_wage entrepreneur employer coies_stud tot_worker_coies mode_adm mode_org tot_workers_curso [fweight = num_stud], by(co_ies year)
drop if ln_wage_2020==.
keep if mode_org == 1
sort ln_wage_2020
gen order = _n
sum order, d
local p95 = r(p95)
local p50 = r(p50)
twoway (scatter ln_wage_2020 order if !inlist(co_ies,55000, 55001,55002, 55003, 55004, 55005, 55006) & ln_wage_2020>=8 , color(gray%30) msize(vsmall)) ///
		(scatter ln_wage_2020 order if co_ies == 55000, color(red*1.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55001, color(blue*1.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55002, color(red*1) ) ///
		(scatter ln_wage_2020 order if co_ies == 55003, color(blue*0.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55004, color(red*0.5) ) ///
		(scatter ln_wage_2020 order if co_ies == 55005, color(green*1) ) ///
		(scatter ln_wage_2020 order if co_ies == 55006, color(yellow*1.5) ) , ///
		scheme(s1color) plotregion(style(none) lcolor(white) margin(0)) legend(order (- "USP:" 2 "Science" 4 "Engineering" 6 "Comp Science" 3 "Business Adm" 5 "Humanities" 7 "Health" 8 "Other USP" - " " - "Other Universities:" 1 "Other") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ytitle("Log Wages") xtitle("University Rank") xline(`p95', lpattern(dash) lcolor(gray%30)) ///
		xline(`p50', lpattern(dash) lcolor(gray%30)) ///
		text(9.5 175 "Top 5%") text(9.5 85 "Median") ysc(range(8 9.5)) ylab(8 (0.5) 9.5) 
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wagesuniv.pdf", replace
qui graph save "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wagesuniv.gph", replace
restore

preserve
gcollapse ln_wage_2019 ln_wage_2020 ln_wage_2021 unc_above_med_work unc_above_med_wage entrepreneur employer coies_stud tot_worker_coies mode_adm mode_org tot_workers_curso[fweight = num_stud], by(co_ies)
keep if mode_org == 1
sort entrepreneur
gen order = _n
sum order, d
local p95 = r(p95)
local p50 = r(p50)
twoway (scatter entrepreneur order if !inlist(co_ies,55000, 55001,55002, 55003, 55004, 55005, 55006) , color(gray%30) msize(vsmall)) ///
		(scatter entrepreneur order if co_ies == 55000, color(red*1.5) ) ///
		(scatter entrepreneur order if co_ies == 55001, color(blue*1.5) ) ///
		(scatter entrepreneur order if co_ies == 55002, color(red*1) ) ///
		(scatter entrepreneur order if co_ies == 55003, color(blue*0.5) ) ///
		(scatter entrepreneur order if co_ies == 55004, color(red*0.5) ) ///
		(scatter entrepreneur order if co_ies == 55005, color(green*1) ) ///
		(scatter entrepreneur order if co_ies == 55006, color(yellow*1.5) ) , ///
		scheme(s1color) plotregion(style(none) lcolor(white) margin(0)) legend(order (- "USP:" 2 "Science" 4 "Engineering" 6 "Comp Science" 3 "Business Adm" 5 "Humanities" 7 "Health" 8 "Other USP" - " " - "Other Universities:" 1 "Other") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ytitle("Fraction of Entrepreneurs") xtitle("University Rank") xline(`p95', lpattern(dash) lcolor(gray%30)) ///
		xline(`p50', lpattern(dash) lcolor(gray%30)) ///
		text(0.1 175 "Top 5%") text(0.1 85 "Median") ysc(range(0 0.1)) ylab(0 (0.025) 0.1) ///
		name(entrepreneurship)
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\entrepreneur.pdf", replace
qui graph save "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\entrepreneur.gph", replace
restore


/*
preserve
gcollapse ln_wage_2019 ln_wage_2020 ln_wage_2021 unc_above_med_work unc_above_med_wage entrepreneur employer coies_stud tot_worker_coies mode_adm mode_org tot_workers_curso, by(co_ies)
keep if mode_org == 1
sort employer
gen order = _n
sum order, d
local p95 = r(p95)
local p50 = r(p50)
twoway (scatter employer order if !inlist(co_ies,55000, 55001,55002, 55003, 55004, 55005, 55006) , color(gray%30) msize(vsmall)) ///
		(scatter employer order if co_ies == 55000, color(red*1.5) ) ///
		(scatter employer order if co_ies == 55001, color(blue*1.5) ) ///
		(scatter employer order if co_ies == 55002, color(red*1) ) ///
		(scatter employer order if co_ies == 55003, color(blue*0.5) ) ///
		(scatter employer order if co_ies == 55004, color(red*0.5) ) ///
		(scatter employer order if co_ies == 55005, color(green*1) ) ///
		(scatter employer order if co_ies == 55006, color(yellow*1.5) ) , ///
		scheme(s1color) plotregion(style(none)) legend(order (2 "Science" 4 "Engineering" 6 "Comp Science" 3 "Business Adm" 5 "Humanities" 7 "Health" 8 "Other USP") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ytitle("Fraction of Firm Owners") xtitle("University Rank") xline(`p95', lpattern(dash) lcolor(gray%30)) ///
		xline(`p50', lpattern(dash) lcolor(gray%30)) ///
		text(0.14 175 "Top 5%") text(0.14 85 "Median") ysc(range(0 0.15)) ylab(0 (0.05) 0.15)
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\owner.pdf", replace

restore
*/

gr combine "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wagesuniv.gph" "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\entrepreneur.gph", ysize(6) xsize(12)
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wagesvsent.pdf", replace
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\wagesvsent.png", replace

**************************************** New Graphs ****************************
clear all
cls
set more off

use "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_2010.dta"

foreach year in 2010 2011 2012 2013 2014 2015 {
	append using "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_`year'.dta"
}
generate graduates = 1
generate year_grad=year

foreach year in 2010 2011 2012 2013 2014 2015 {
	append using "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\New Students\merged_new_students_`year'.dta"	
}
replace graduates=0 if graduate==.
replace year_grad = year+5 if graduates==0

sort co_ies co_curso 
replace num_stud = num_stud - 10
bys co_ies: gegen coies_stud = sum(num_stud)

foreach year in 2019 2020 2021{
gen ln_wage_`year' = ln(wage_nozero_employee_`year')
}

bys co_ies year: gegen tot_worker_coies = sum(tot_workers_curso)
bys co_ies : gegen mode_adm = mode(tp_categoria_administrativa)
bys co_ies : gegen mode_org = mode(tp_organizacao_academica)
drop if tp_modalidade_ensino == 2

gen temp_var1 = string(co_ocde_area_detalhada,"%5.0g")
gen ocde1 = substr(temp_var1,1,1)
gen ocde2 = substr(temp_var1,1,2)
destring ocde1, replace
destring ocde2, replace


/*

preserve

bys year_grad: gegen tot_workers_year = sum(num_stud)
bys year_grad ocde1: gegen tot_workers_ocde = sum(num_stud)

drop if ocde1==.

gen frac_ocde1 = tot_workers_ocde/tot_workers_year

gcollapse (first) frac_ocde1, by(year_grad ocde1)

twoway (line frac_ocde1 year_grad if ocde1 == 1,) ///
       (line frac_ocde1 year_grad if ocde1 == 2,) ///
       (line frac_ocde1 year_grad if ocde1 == 3,) ///
       (line frac_ocde1 year_grad if ocde1 == 4,) ///
       (line frac_ocde1 year_grad if ocde1 == 5,) ///
       (line frac_ocde1 year_grad if ocde1 == 6,) ///
       (line frac_ocde1 year_grad if ocde1 == 7,) ///
       (line frac_ocde1 year_grad if ocde1 == 8) ///
       , scheme(s1color) ///
       legend(order (1 "Education" 2 "Humanities and Arts" 3 "Social Sciences, Business, and Law" 4 "Sciences, Mathematics, and Computing" 5 "Engineering, Production, and Construction"  6 "Agriculture and Veterinary" 7 "Health and Social Well-being" 8 "Services") cols(2) size(vsmall)) ///
       ytitle("Fraction of students") xtitle("Year of Graduation")

restore

preserve
	   
replace ocde1=8 if ocde1==1 | ocde1==6 | ocde1==2

bys year_grad: gegen tot_workers_year = sum(num_stud)
bys year_grad ocde1: gegen tot_workers_ocde = sum(num_stud)

drop if ocde1==.

gen frac_ocde1 = tot_workers_ocde/tot_workers_year

gcollapse (first) frac_ocde1 tot_workers_ocde tot_workers_year, by(year_grad ocde1)


twoway (line frac_ocde1 year_grad if ocde1 == 3,) ///
       (line frac_ocde1 year_grad if ocde1 == 4,) ///
       (line frac_ocde1 year_grad if ocde1 == 5,) ///
	   (line frac_ocde1 year_grad if ocde1 == 7,) ///
       (line frac_ocde1 year_grad if ocde1 == 8) ///
       , scheme(s1color) ///
       legend(order (1 "Social Sciences, Business, and Law" 2 "Sciences, Mathematics, and Computing" 3 "Engineering, Production, and Construction"  4 "Health and Social Well-being" 5 "Other Areas") cols(2) size(vsmall)) ///
       ytitle("Fraction of students") xtitle("Year of Graduation")
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\graduation1.pdf", replace	   
	   
restore

preserve

gen ocdegraph=7
replace ocdegraph=1 if ocde2==34 | co_ocde_area_detalhada==314
replace ocdegraph=2 if ocde2==38
replace ocdegraph=3 if ocde2==42 | ocde2==44 | ocde2==46
replace ocdegraph=4 if ocde2==48
replace ocdegraph=5 if ocde2==52
replace ocdegraph=6 if ocde2==72


bys year_grad: gegen tot_workers_year = sum(num_stud)
bys year_grad ocdegraph: gegen tot_workers_ocde = sum(num_stud)

gen frac_ocdegraph = tot_workers_ocde/tot_workers_year

gcollapse (first) frac_ocdegraph, by(year_grad ocdegraph)

twoway (line frac_ocdegraph year_grad if ocdegraph == 1,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 2,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 3,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 4,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 5,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 6,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 7,) ///
       (line frac_ocdegraph year_grad if ocdegraph == 8,) ///
       , scheme(s1color) ///
       legend(order (1 "Economics, Business and Administration" 2 "Law" 3 "Sciences and Mathematics" 4 "Computing" 5 "Engineering" 6 "Health" 7 "Other Professions") cols(2) size(vsmall)) ///
       ytitle("Fraction of students") xtitle("Year of Graduation")
graph export "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\graduation2.pdf", replace
restore

*/


tab ocde2
tab co_ocde_area_detalhada

bys co_ocde_area_detalhada: gegen mean_wage_2021_grad = mean(ln_wage_2021) if graduates==1
bys co_ocde_area_detalhada: gegen mean_wage_2021_ns = mean(ln_wage_2021) if graduates==0

/*
preserve
gcollapse (first) mean_wage_2021_grad mean_wage_2021_ns (mean) nu_nota_mt_master [fweight=num_stud], by(co_ocde_area_detalhada graduates)
drop if graduates==0
sort mean_wage_2021_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)


gen nota_mt=nu_nota_mt_master
sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 30

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1


reghdfe mean_wage_2021_grad bin_nota_mt, resid
predict newwageresid, resid
sum mean_wage_2021_grad, d
*local mean_mean = r(mean)
gen newwage = r(mean) + newwageresid

*gen nota_mt2=nota_mt^2
*gen nota_mt3=nota_mt^3
*reg mean_wage_2021_grad nota_mt nota_mt2 nota_mt3
*predict newwage, xb

sort newwage
gen order2 = _n
centile order2, centile(50 95)


twoway (scatter mean_wage_2021_grad order if !inlist(co_ocde_area_detalhada,520,314, 380, 340, 721), color(black) msize(vsmall)) ///
       (scatter mean_wage_2021_grad order if co_ocde_area_detalhada == 314, color(blue)) ///
       (scatter mean_wage_2021_grad order if co_ocde_area_detalhada == 520, color(green)) ///
       (scatter mean_wage_2021_grad order if co_ocde_area_detalhada == 380, color(purple)) ///
       (scatter mean_wage_2021_grad order if co_ocde_area_detalhada == 340, color(brown)) ///
       (scatter mean_wage_2021_grad order if co_ocde_area_detalhada == 721, color(red)) ///
	   (scatter newwage order2 if !inlist(co_ocde_area_detalhada, 520,314, 380, 340, 721), color(gray%30) msize(vsmall)) ///
       (scatter newwage order2 if co_ocde_area_detalhada == 314, color(blue%30) msize(vbig)) ///
       (scatter newwage order2 if co_ocde_area_detalhada == 520, color(green%30)) ///
       (scatter newwage order2 if co_ocde_area_detalhada == 380, color(purple%30)) ///
       (scatter newwage order2 if co_ocde_area_detalhada == 340, color(brown%30)) ///
       (scatter newwage order2 if co_ocde_area_detalhada == 721, color(red%30)) ///
       , scheme(s1color) ///
       legend(order(1 "Raw" 7 "Controlled by Math Grades") cols(2)) ///
       ytitle("Log Wages") xtitle("Rank - University Course") ///
       xline(`=p95', lpattern(dash) lcolor(gray%30)) ///
       xline(`=p50', lpattern(dash) lcolor(gray%30)) ///
       text(9.8 `=p95' "Top 5%") text(9.8 `=p50' "Median") text(8.25 29 "Law", color(purple) size(vsmall) ) text(8.45 20 "Business &" "Administration", color(brown) size(vsmall) ) text(8.68 69 "Engineering", color(green) size(vsmall) ) text(8.95 62 "Economics", color(blue) size(vsmall) ) text(8.95 78 "Medicine", color(red) size(vsmall) ) ///
       ysc(range(8 10)) ylab(8 (0.5) 10)
restore
*/

foreach yearloop in 2019 2020 2021{
gen ln_wage_`yearloop'_grad = ln(wage_nozero_employee_`yearloop') if year==(`yearloop'-6) & graduates==1
}

/*
**** 1 Cohort ****
preserve
drop if  ln_wage_2020_grad==.

gcollapse (first) co_ocde_area_detalhada num_stud (mean) nu_nota_mt_master ln_wage_2020_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen avg_wg_eco = mean(ln_wage_2020_grad) [fweight=num_stud] if co_ocde_area_detalhada==314
gegen avg_nt_eco = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==314

gegen avg_wg_bus = mean(ln_wage_2020_grad) [fweight=num_stud] if co_ocde_area_detalhada==340
gegen avg_nt_bus = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==340

gegen avg_wg_law = mean(ln_wage_2020_grad) [fweight=num_stud] if co_ocde_area_detalhada==380
gegen avg_nt_law = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==380

gegen avg_wg_eng = mean(ln_wage_2020_grad) [fweight=num_stud] if co_ocde_area_detalhada==520
gegen avg_nt_eng = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==520

gegen avg_wg_med = mean(ln_wage_2020_grad) [fweight=num_stud] if co_ocde_area_detalhada==721
gegen avg_nt_med = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==721

gen obs=0

insobs 1
replace co_curso=100000000 in 22354
replace ln_wage_2020_grad=8.789769 in 22354
replace nota_mt=641.1431 in 22354
replace obs=1 if obs!=0

insobs 1
replace co_curso=100000001 in 22355
replace ln_wage_2020_grad=8.306249 in 22355
replace nota_mt=547.22 in 22355
replace obs=2 if obs==.

insobs 1
replace co_curso=100000002 in 22356
replace ln_wage_2020_grad=8.739717 in 22356
replace nota_mt=557.2076 in 22356
replace obs=3 if obs==.

insobs 1
replace co_curso=100000003 in 22357
replace ln_wage_2020_grad=8.704473 in 22357
replace nota_mt=623.2305 in 22357
replace obs=4 if obs==.

insobs 1
replace co_curso=100000004 in 22358
replace ln_wage_2020_grad=9.274127 in 22358
replace nota_mt=684.4819 in 22358
replace obs=5 if obs==.



sort ln_wage_2020_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 30

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1

reghdfe ln_wage_2020_grad nota_mt if obs==0, absorb(bin_nota_mt) resid
predict newwageresid, resid
sum ln_wage_2020_grad, d
*local mean_mean = r(mean)
gen newwage = r(mean) + newwageresid

gegen re_avg_wg_eco = mean(newwage) [fweight=num_stud] if co_ocde_area_detalhada==314
replace newwage=8.551159 if obs==1

gegen re_avg_wg_bus = mean(newwage) [fweight=num_stud] if co_ocde_area_detalhada==340
replace newwage=8.339219 if obs==2

gegen re_avg_wg_law = mean(newwage) [fweight=num_stud] if co_ocde_area_detalhada==380
replace newwage=8.744912 if obs==3

gegen re_avg_wg_eng = mean(newwage) [fweight=num_stud] if co_ocde_area_detalhada==520
replace newwage=8.520122 if obs==4

gegen re_avg_wg_med = mean(newwage) [fweight=num_stud] if co_ocde_area_detalhada==721
replace newwage=8.911404 if obs==5


*gen nota_mt2=nota_mt^2
*gen nota_mt3=nota_mt^3
*reg mean_wage_2021_grad nota_mt nota_mt2 nota_mt3
*predict newwage, xb

sort newwage
gen order2 = _n
centile order2, centile(50 95)


twoway (scatter ln_wage_2020_grad order if !inlist(obs,1,2,3,4,5), color(black) msize(vsmall)) ///
       (scatter ln_wage_2020_grad order if obs==1, color(blue)) ///
	   (scatter ln_wage_2020_grad order if obs==2, color(red)) ///
	   (scatter ln_wage_2020_grad order if obs==3, color(purple)) ///
	   (scatter ln_wage_2020_grad order if obs==4, color(green)) ///
	   (scatter ln_wage_2020_grad order if obs==5, color(brown)) ///
	   (scatter newwage order2 if !inlist(obs,1,2,3,4,5), color(gray%30) msize(vsmall)) ///
       , scheme(s1color) ///
       legend(order(1 "Raw" 7 "Controlled by Math Grades") cols(1) size(vsmall) position(11) ring(0)) ///
       ytitle("Log Wages") xtitle("Rank - University Course") ///
       xline(`=p95', lpattern(dash) lcolor(gray%30)) ///
       xline(`=p50', lpattern(dash) lcolor(gray%30)) ///
      text(9.8 `=p95-2000' "Top 5%") text(9.8 `=p50-2000' "Median") text(8.8 22700 "Medicine", color(brown) size(vsmall)) text(9 19000 "Economics", color(blue) size(vsmall))  text(8.55 20500 "Law", color(purple) size(vsmall)) text(8 14000 "Business &" "Administration", color(red) size(vsmall)) text(8.35 18000 "Engineering", color(green) size(vsmall)) ///
       ysc(range(6 10)) ylab(6 (1) 10)
	   
restore	 

*/

/*  
**** 3 Cohorts - full
preserve
drop if ln_wage_2019_grad==. & ln_wage_2020_grad==. & ln_wage_2021_grad ==.

replace ln_wage_2019_grad=ln_wage_2019_grad/1
replace ln_wage_2020_grad=ln_wage_2020_grad/(1.043111)
replace ln_wage_2021_grad=ln_wage_2021_grad/(1.155125)

gen ln_wage_grad=.
replace ln_wage_grad=ln_wage_2019_grad if year==2013
replace ln_wage_grad=ln_wage_2020_grad if year==2014
replace ln_wage_grad=ln_wage_2021_grad if year==2015

gcollapse (rawsum) num_stud (first) co_ocde_area_detalhada ocde2 co_ies (mean) nu_nota_mt_master ln_wage_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen avg_wg_eco = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==314
gegen avg_nt_eco = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==314

gegen avg_wg_bus = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==340
gegen avg_nt_bus = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==340

gegen avg_wg_law = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==380
gegen avg_nt_law = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==380

gegen avg_wg_eng = mean(ln_wage_grad) [fweight=num_stud] if ocde2==52
gegen avg_nt_eng = mean(nota_mt) [fweight=num_stud] if ocde2==52

gegen avg_wg_med = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==721
gegen avg_nt_med = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==721

gen obs=0

insobs 1
replace co_curso=100000000 in 26773 
replace ln_wage_grad=8.279804 in 26773
replace nota_mt=641.1381 in 26773
replace obs=1 if obs!=0

insobs 1
replace co_curso=100000001 in 26774
replace ln_wage_grad=7.841778 in 26774
replace nota_mt=548.0417 in 26774
replace obs=2 if obs==.

insobs 1
replace co_curso=100000002 in 26775
replace ln_wage_grad=8.207399 in 26775
replace nota_mt=558.8224 in 26775
replace obs=3 if obs==.

insobs 1
replace co_curso=100000003 in 26776
replace ln_wage_grad=8.29698 in 26776
replace nota_mt=653.3247 in 26776
replace obs=4 if obs==.

insobs 1
replace co_curso=100000004 in 26777
replace ln_wage_grad=8.72661 in 26777
replace nota_mt=701.0775 in 26777
replace obs=5 if obs==.

sort ln_wage_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 20

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1

reghdfe ln_wage_grad if obs==0, absorb(bin_nota_mt#co_ies) resid
*reghdfe ln_wage_grad nota_mt if obs==0, absorb(bin_nota_mt year) resid
predict newwageresid, resid
sum ln_wage_grad, d
*local mean_mean = r(mean)
gen newwage = r(mean) + newwageresid

*gen nota_mt2=nota_mt^2
*gen nota_mt3=nota_mt^3
*reg mean_wage_2021_grad nota_mt nota_mt2 nota_mt3
*predict newwage, xb

sort newwage
gen order2 = _n 
centile order2, centile(50 95)

twoway (scatter ln_wage_grad order if !inlist(obs,1,2,3,4,5) & ln_wage_grad>=6, color(black) msize(vsmall)) ///
	   (scatter newwage order2 if !inlist(obs,1,2,3,4,5) & newwage>=6, color(gray%30) msize(vsmall)) ///
       (scatter ln_wage_grad order if obs==1, color(blue)) ///
	   (scatter ln_wage_grad order if obs==2, color(red)) ///
	   (scatter ln_wage_grad order if obs==3, color(purple)) ///
	   (scatter ln_wage_grad order if obs==4, color(green)) ///
	   (scatter ln_wage_grad order if obs==5, color(brown)) ///
       , scheme(s1color) plotregion(style(none)) ///
       legend(order(1 "Raw" 2 "Controlled by Math Grades") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ///
       ytitle("Log Wages") xtitle("Rank - All Courses") ///
       xline(`=p95', lpattern(dash) lcolor(gray%30)) ///
       xline(`=p50', lpattern(dash) lcolor(gray%30)) ///
      text(9.8 `=p95-1500' "Top 5%") text(9.8 `=p50-1500' "Median") ///
	   yscale(range(6 7 8 9 10)) ylab(6 (1) 10) ///
	   xlab (0 (7000) 28000) ///
	   text(8.6 27500 "Medicine", color(brown) size(vsmall)) text(8.15 25000 "Economics", color(blue) size(vsmall))  text(8.35 22100 "Law", color(purple) size(vsmall)) text(7.6 16000 "Business &" "Administration", color(red) size(vsmall)) text(8.25 25500 "Engineering", color(green) size(vsmall)) ///
	   
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\allcourses.pdf", replace	   
	   
	   
restore	   


**** 3 Cohorts - universities w/interaction
preserve
drop if ln_wage_2019_grad==. & ln_wage_2020_grad==. & ln_wage_2021_grad ==.
keep if mode_org == 1

replace ln_wage_2019_grad=ln_wage_2019_grad/1
replace ln_wage_2020_grad=ln_wage_2020_grad/(1.043111)
replace ln_wage_2021_grad=ln_wage_2021_grad/(1.155125)

gen ln_wage_grad=.
replace ln_wage_grad=ln_wage_2019_grad if year==2013
replace ln_wage_grad=ln_wage_2020_grad if year==2014
replace ln_wage_grad=ln_wage_2021_grad if year==2015

gcollapse (rawsum) num_stud (first) co_ocde_area_detalhada ocde2 co_ies (mean) nu_nota_mt_master ln_wage_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen avg_wg_eco = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==314
gegen avg_nt_eco = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==314

gegen avg_wg_bus = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==340
gegen avg_nt_bus = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==340

gegen avg_wg_law = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==380
gegen avg_nt_law = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==380

gegen avg_wg_eng = mean(ln_wage_grad) [fweight=num_stud] if ocde2==52
gegen avg_nt_eng = mean(nota_mt) [fweight=num_stud] if ocde2==52

gegen avg_wg_med = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==721
gegen avg_nt_med = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==721

gen obs=0

insobs 1
replace co_curso=100000000 in 12972 
replace ln_wage_grad=8.276859 in 12972
replace nota_mt=644.2869 in 12972
replace obs=1 if obs!=0

insobs 1
replace co_curso=100000001 in 12973
replace ln_wage_grad=7.883771 in 12973
replace nota_mt=549.3828 in 12973
replace obs=2 if obs==.

insobs 1
replace co_curso=100000002 in 12974
replace ln_wage_grad=8.298368 in 12974
replace nota_mt=581.7078 in 12974
replace obs=3 if obs==.

insobs 1
replace co_curso=100000003 in 12975
replace ln_wage_grad=8.392198 in 12975
replace nota_mt=683.875 in 12975
replace obs=4 if obs==.

insobs 1
replace co_curso=100000004 in 12976
replace ln_wage_grad=8.734048 in 12976
replace nota_mt=711.481 in 12976
replace obs=5 if obs==.

sort ln_wage_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 30

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1

reghdfe ln_wage_grad if obs==0, absorb(bin_nota_mt#co_ies) resid
predict newwageresid, resid
sum ln_wage_grad, d
local mean_mean = r(mean)
gen newwage = r(mean) + newwageresid

*gen nota_mt2=nota_mt^2
*gen nota_mt3=nota_mt^3
*gen nota_mt4=nota_mt^4
*reg ln_wage_grad nota_mt nota_mt2 nota_mt3 nota_mt4
*predict newwage, xb

sort newwage
gen order2 = _n 
centile order2, centile(50 95)


twoway (scatter ln_wage_grad order if !inlist(obs,1,2,3,4,5) & ln_wage_grad>=6, color(black) msize(vsmall)) ///
	   (scatter newwage order2 if !inlist(obs,1,2,3,4,5) & newwage>=6, color(gray%30) msize(vsmall)) ///
       (scatter ln_wage_grad order if obs==1, color(blue)) ///
	   (scatter ln_wage_grad order if obs==2, color(red)) ///
	   (scatter ln_wage_grad order if obs==3, color(purple)) ///
	   (scatter ln_wage_grad order if obs==4, color(green)) ///
	   (scatter ln_wage_grad order if obs==5, color(brown)) ///
       , scheme(s1color) plotregion(style(none)) ///
       legend(order(1 "Raw" 2 "Controlled by Math Grades") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ///
       ytitle("Log Wages") xtitle("Rank - University Courses") ///
       xline(`=p95', lpattern(dash) lcolor(gray%30)) ///
       xline(`=p50', lpattern(dash) lcolor(gray%30)) ///
      text(9.8 `=p95-1000' "Top 5%") text(9.8 `=p50-1000' "Median") ///
	   yscale(range(6 7 8 9 10)) ylab(6 (1) 10) ///
	   xscale(range(0 14000)) xlab (0 3300 6600 9900 13200) ///
	   text(8.6 13100 "Medicine", color(brown) size(vsmall)) text(8.32 10100 "Economics", color(blue) size(vsmall))  text(8.45 10660 "Law", color(purple) size(vsmall)) text(7.7 7500 "Business &" "Administration", color(red) size(vsmall)) text(8.6 11100 "Engineering", color(green) size(vsmall)) ///
	   
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\univ with fe interactions.pdf", replace	   
	   
		   

restore
*/

**** 3 Cohorts - universities w/o interaction
preserve
drop if ln_wage_2019_grad==. & ln_wage_2020_grad==. & ln_wage_2021_grad ==.
keep if mode_org == 1

replace ln_wage_2019_grad=ln_wage_2019_grad/1
replace ln_wage_2020_grad=ln_wage_2020_grad/(1.043111)
replace ln_wage_2021_grad=ln_wage_2021_grad/(1.155125)

gen ln_wage_grad=.
replace ln_wage_grad=ln_wage_2019_grad if year==2013
replace ln_wage_grad=ln_wage_2020_grad if year==2014
replace ln_wage_grad=ln_wage_2021_grad if year==2015

gcollapse (rawsum) num_stud (first) co_ocde_area_detalhada ocde2 co_ies (mean) nu_nota_mt_master ln_wage_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen avg_wg_eco = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==314
gegen avg_nt_eco = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==314

gegen avg_wg_bus = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==340
gegen avg_nt_bus = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==340

gegen avg_wg_law = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==380
gegen avg_nt_law = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==380

gegen avg_wg_eng = mean(ln_wage_grad) [fweight=num_stud] if ocde2==52
gegen avg_nt_eng = mean(nota_mt) [fweight=num_stud] if ocde2==52

gegen avg_wg_med = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==721
gegen avg_nt_med = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==721

gegen avg_wg_hl = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==220
gegen avg_nt_hl = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==220

gegen avg_wg_tou = mean(ln_wage_grad) [fweight=num_stud] if co_ocde_area_detalhada==312
gegen avg_nt_tou = mean(nota_mt) [fweight=num_stud] if co_ocde_area_detalhada==312

gen obs=0

insobs 1, before(1)
replace co_curso=100000000 in 1 
replace ln_wage_grad=8.276859 in 1
replace nota_mt=644.2869 in 1
replace obs=1 if obs!=0

insobs 1, before(1)
replace co_curso=100000001 in 1
replace ln_wage_grad=7.883771 in 1
replace nota_mt=549.3828 in 1
replace obs=2 if obs==.

insobs 1, before(1)
replace co_curso=100000002 in 1
replace ln_wage_grad=8.298368 in 1
replace nota_mt=581.7078 in 1
replace obs=3 if obs==.

insobs 1, before(1)
replace co_curso=100000003 in 1
replace ln_wage_grad=8.392198 in 1
replace nota_mt=683.875 in 1
replace obs=4 if obs==.

insobs 1, before(1)
replace co_curso=100000004 in 1
replace ln_wage_grad=8.734048 in 1
replace nota_mt=711.481 in 1
replace obs=5 if obs==.

insobs 1, before(1)
replace co_curso=100000004 in 1
replace ln_wage_grad=7.680958 in 1
replace nota_mt=582.6433 in 1
replace obs=6 if obs==.

insobs 1, before(1)
replace co_curso=100000004 in 1
replace ln_wage_grad=7.535608 in 1
replace nota_mt=542.8816 in 1
replace obs=7 if obs==.

sort ln_wage_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 30

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1

reghdfe ln_wage_grad if obs==0, absorb(bin_nota_mt co_ies) resid
predict newwageresid, resid
sum ln_wage_grad, d
local mean_mean = r(mean)
gen newwage = r(mean) + newwageresid

sum num_stud, d

*gen nota_mt2=nota_mt^2
*gen nota_mt3=nota_mt^3
*gen nota_mt4=nota_mt^4
*reg ln_wage_grad nota_mt nota_mt2 nota_mt3 nota_mt4
*predict newwage, xb

sort newwage
gen order2 = _n 
centile order2, centile(50 95)


twoway (scatter ln_wage_grad order if !inlist(obs,1,2,3,4,5,6,7) & ln_wage_grad>=6, color(black) msize(vsmall)) ///
	   (scatter newwage order2 if !inlist(obs,1,2,3,4,5,6,7) & newwage>=6, color(gray%30) msize(vsmall)) ///
       (scatter ln_wage_grad order if obs==1, color(blue)) ///
	   (scatter ln_wage_grad order if obs==2, color(red)) ///
	   (scatter ln_wage_grad order if obs==3, color(purple)) ///
	   (scatter ln_wage_grad order if obs==4, color(green)) ///
	   (scatter ln_wage_grad order if obs==5, color(brown)) ///
	   (scatter ln_wage_grad order if obs==6, color(pink)) ///
	   (scatter ln_wage_grad order if obs==7, color(lavender)) ///
       , scheme(s1color) plotregion(style(none) lcolor(white) margin(0)) ///
       legend(order(1 "Raw" 2 "Controlled by Math" "Grades and Institution") cols(1) size(vsmall) position(11) ring(0) region(lstyle(none))) ///
       ytitle("Log Wages 6 Years After Graduation") xtitle("Rank - University x Degree") ///
       xline(`=p95', lpattern(dash) lcolor(gray%30)) ///
       xline(`=p50', lpattern(dash) lcolor(gray%30)) ///
      text(9.8 `=p95-1000' "Top 5%") text(9.8 `=p50-1000' "Median") ///
	   yscale(range(6 7 8 9 10)) ylab(6 (1) 10) ///
	   xscale(range(0 14000)) xlab (0 3300 6600 9900 13200) ///
	   text(8.8 12000 "Medicine", color(brown) size(vsmall)) text(8.32 10100 "Economics", color(blue) size(vsmall))  text(8.45 10660 "Law", color(purple) size(vsmall)) text(7.7 7500 "Business &" "Administration", color(red) size(vsmall)) text(8.6 11100 "Engineering", color(green) size(vsmall)) text(7.49 5200 "Humanities" "& Letters", color(pink) size(vsmall)) text(7.39 3300 "Tourism", color(lavender) size(vsmall))  
	   
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\univ without fe interactions.pdf", replace	   
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\univ without fe interactions.png", replace	  	   
		   
restore	  	


/*
******* Hist 1 year:

preserve
drop if  ln_wage_2020_grad==.

gcollapse (first) co_ocde_area_detalhada num_stud co_ies (mean) nu_nota_mt_master ln_wage_2020_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen true_mean = mean(ln_wage_2020_grad) [fweight=num_stud] 

gen ln_wage_2020_grad_med = ln_wage_2020_grad - true_mean

sort ln_wage_2020_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 20

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1

reghdfe ln_wage_2020_grad , absorb(bin_nota_mt co_ies) resid
predict newwageresid, resid
sum ln_wage_2020_grad, d
gen newwage = r(mean) + newwageresid
gen newwage_med = newwage - true_mean
       
twoway (kdensity ln_wage_2020_grad_med [fweight=num_stud], color(black) kernel(epanechnikov)) (kdensity newwage_med [fweight=num_stud], color(gray) kernel(epanechnikov)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)")

twoway (kdensity ln_wage_2020_grad_med [fweight=num_stud], color(black)) (kdensity newwage_med [fweight=num_stud], color(gray)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)")

	  
twoway (kdensity ln_wage_2020_grad_med, color(black)) (kdensity newwage_med, color(gray)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)") 
	  
	  
reghdfe ln_wage_2020_grad , absorb(bin_nota_mt#co_ies) resid
predict newwageresid2, resid
sum ln_wage_2020_grad, d
gen newwage2 = r(mean) + newwageresid2
gen newwage_med2 = newwage - true_mean

twoway (kdensity ln_wage_2020_grad_med [fweight=num_stud], color(black) kernel(epanechnikov)) (kdensity newwage_med2 [fweight=num_stud], color(gray) kernel(epanechnikov)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)")

twoway (kdensity ln_wage_2020_grad_med [fweight=num_stud], color(black)) (kdensity newwage_med2 [fweight=num_stud], color(gray)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)")

	  
twoway (kdensity ln_wage_2020_grad_med, color(black)) (kdensity newwage_med2, color(gray)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math Grades") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) ///	   
       ytitle("Density") xtitle("Distance to the mean log(wage)") 
	  
restore	 
*/  
   
   
***** Hist 3 years:   

preserve
drop if ln_wage_2019_grad==. & ln_wage_2020_grad==. & ln_wage_2021_grad ==.
keep if mode_org == 1

replace ln_wage_2019_grad=ln_wage_2019_grad/1
replace ln_wage_2020_grad=ln_wage_2020_grad/(1.043111)
replace ln_wage_2021_grad=ln_wage_2021_grad/(1.155125)

gen ln_wage_grad=.
replace ln_wage_grad=ln_wage_2019_grad if year==2013
replace ln_wage_grad=ln_wage_2020_grad if year==2014
replace ln_wage_grad=ln_wage_2021_grad if year==2015

gcollapse (rawsum) num_stud (first) co_ocde_area_detalhada ocde2 co_ies (mean) nu_nota_mt_master ln_wage_grad [fweight=num_stud], by(co_curso)
gen nota_mt=nu_nota_mt_master
drop if nota_mt==.

gegen true_mean = mean(ln_wage_grad) [fweight=num_stud] 

gen ln_wage_grad_med = ln_wage_grad - true_mean

sort ln_wage_grad
gen order = _n
centile order, centile(50 95)
scalar p50 = r(c_1)
scalar p95 = r(c_2)

sum nota_mt, d

local min_value = r(min)
local max_value = r(max)
local bin_width = (`max_value' - `min_value') / 30

* Generate the bin variable
gen bin_nota_mt = floor((nota_mt - `min_value') / `bin_width') + 1 
	  
reghdfe ln_wage_grad , absorb(bin_nota_mt#co_ies) resid
predict newwageresid2, resid
sum ln_wage_grad, d
gen newwage2 = r(mean) + newwageresid2
gen newwage_med2 = newwage2 - true_mean

	  
twoway (kdensity ln_wage_grad_med if ln_wage_grad_med>=-2 & ln_wage_grad_med<=2, color(black) ) (kdensity newwage_med2 if newwage_med2>=-2 & newwage_med2<=2, color(gray)), scheme(s1color) plotregion(style(none)) ///
 legend(order(1 "Raw" 2 "Controlled by Math" "Grades & Institution") region(lstyle(none)) cols(1) size(vsmall) position(11) ring(0)) plotregion(lcolor(white) margin(0)) ///	   
       ytitle("Density") xtitle("Log Wage 6 Years After Graduation (Standarized)") xsc(range(-2 2)) xlab(-2 (1) 2) 
graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\density without fw.pdf", replace	

graph export  "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\figures\final\density without fw.png", replace		   
restore	 
   
   
**** New Students vs Graduates:
preserve
keep if mode_org==1
*keep if mode_adm==1
keep if (year==2010 & graduates==0)|(year==2015 & graduates==1)

gen yes_dem = 1 - no_dem
gen realstud = num_stud*yes_dem

gen female = fem_master*realstud
gen nonwhite = nonwhite_master*realstud
gen father_college = father_college_master*realstud
gen mother_college = mother_college_master*realstud
gen minwage = minwage_hh*realstud

gcollapse (sum) num_stud realstud female nonwhite father_college mother_college minwage, by(graduates)

gen share = realstud/num_stud

label define yesno 0 "New Students" 1 "Graduates"
label values graduates yesno 
 
gen female_sh=female/realstud
gen nonwhite_sh=nonwhite/realstud
gen father_college_sh=father_college/realstud
gen minwage_sh=minwage/realstud


graph bar female_sh nonwhite_sh father_college_sh minwage_sh, over(graduates) bargap(0) ysc(range(0 1)) ylab(0 (0.2) 1) legend( order(1 "Female Students" 2 "Non-White Students" 3 "Fathers' Education" "Above College Level" 4 "Salary below the" " Minimum Wage") cols(2) size(vsmall) position(11) ring(0) region(lstyle(none))) plotregion(style(none) fcolor(white) ifcolor(white)) graphregion(fcolor(white))

restore   


******** 
clear all
cls
set more off

use "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_2010.dta"

foreach year in 2010 2011 2012 2013 2014 2015 {
	append using "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\Graduates\merged_graduates_`year'.dta"
}
generate graduates = 1
generate year_grad=year

foreach year in 2010 2011 2012 2013 2014 2015 {
	append using "D:\Dropbox\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\New Students\merged_new_students_`year'.dta"	
}
replace graduates=0 if graduate==.
replace year_grad = year+5 if graduates==0

sort co_ies co_curso 
replace num_stud = num_stud - 10
bys co_ies: gegen coies_stud = sum(num_stud)

foreach year in 2019 2020 2021{
gen ln_wage_`year' = ln(wage_nozero_employee_`year')
}

bys co_ies year: gegen tot_worker_coies = sum(tot_workers_curso)
bys co_ies : gegen mode_adm = mode(tp_categoria_administrativa)
bys co_ies : gegen mode_org = mode(tp_organizacao_academica)
drop if tp_modalidade_ensino == 2

gen temp_var1 = string(co_ocde_area_detalhada,"%5.0g")
gen ocde1 = substr(temp_var1,1,1)
gen ocde2 = substr(temp_var1,1,2)
destring ocde1, replace
destring ocde2, replace


*** Public v Private
*preserve

foreach year in 2019 2020 2021{
gen real_emp_`year' = round(inrais_employee_`year'*num_stud)
gen real_publ_`year' = round(setor_publico_employee_`year'*real_emp_`year')
gen real_priv_`year' = round(setor_privado_employee_`year'*real_emp_`year')
gen real_other_`year' = round(setor_other_employee_`year'*real_emp_`year')
}

gen degree=0
replace degree=1 if mode_adm==1|mode_adm==2|mode_adm==3
replace degree=2 if mode_adm==4|mode_adm==5|mode_adm==6
replace degree=3 if mode_adm==7|mode_adm==8|mode_adm==9
drop if degree==0

label define degrees 1 "Public" 2 "Private" 3 "Other"
label values degree degrees

gcollapse (sum) real_publ_* real_emp_*, by(degree)

foreach year in 2019 2020 2021{
gen share_publ_emp_`year' = real_publ_`year'/real_emp_`year'
}

graph bar share_publ_emp_2020, over(degree) bargap(0) ysc(range(0 1)) ylab(0 (0.2) 1) plotregion(style(none) fcolor(white) ifcolor(white)) graphregion(fcolor(white))


restore
