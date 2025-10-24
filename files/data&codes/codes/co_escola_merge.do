** Demographics
forvalues x = 1/11 {
	import delimited "C:\Users\javie\jfeinmann Dropbox\javier feinmann\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Raw data\\co_escola_demographics\demographics_co_escola_nu_ano_nm`x'.csv", clear
	tempfile dem_`x'
	save `dem_`x'', replace
}

clear
forvalues x = 1/11 {
	append using `dem_`x''
}
duplicates drop
tempfile dem
save `dem', replace


** College Info

forvalues x = 1/28 {
	import delimited "C:\Users\javie\jfeinmann Dropbox\javier feinmann\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Raw data\\co_escola_type_college\educational_outcomes_co_escola_nu_ano_nm`x'.csv", clear
	tempfile col_`x'
	save `col_`x'', replace
}

clear
forvalues x = 1/28 {
	append using `col_`x''
}
duplicates drop
tempfile col
save `col', replace

** Major Info

forvalues x = 1/12 {
	import delimited "C:\Users\javie\jfeinmann Dropbox\javier feinmann\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Raw data\\co_escola_type_major\degree_typeenrollment_co_escola_pcnu_ano_nm_`x'.csv", clear
	tempfile maj_`x'
	save `maj_`x'', replace
}

clear
forvalues x = 1/12 {
	append using `maj_`x''
}
duplicates drop
tempfile maj
save `maj', replace

** Labor Market Info

forvalues x = 1/19 {
	import delimited "C:\Users\javie\jfeinmann Dropbox\javier feinmann\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Raw data\\co_escola_labor_market\labormarket_outcomes_co_escola_nu_ano_nm`x'.csv", clear
	tempfile lab_`x'
	save `lab_`x'', replace
}

clear
forvalues x = 1/19 {
	append using `lab_`x''
}
duplicates drop
tempfile lab
save `lab', replace

use `dem', clear
merge 1:1 co_escola_nm nu_ano_nm using `col', keep(3) nogen
merge 1:1 co_escola_nm nu_ano_nm using `maj', keep(3) nogen
merge 1:1 co_escola_nm nu_ano_nm using `lab', keep(3) nogen

*** Labels

label variable co_escola_nm "High School Code"
label variable nu_ano_nm "Year"
label variable pct_gdp_pc "GDP per Capital Rank School Zip Code"
label variable idade_nm "Age"
label variable father_college_master "Father has college"
label variable mother_college_master "Mother has college"
label variable nonwhite_master "Non-white"
label variable fem_master "Female"
label variable nu_nota_mt "Math Grade"
label variable av_grade "Av. Grade (5 exams)"
label variable minwage_hh "HH with 1 MW per capita"
label variable rich_hh "HH with >12 MW per capita"
label variable num_stud "Number of Students"
label variable found_csup "Found in CSUP"
label variable found_csup_r "Found in CSUP (res. by grades)"
label variable graduated "Graduated college"
label variable graduated_r "Graduated college (res. by grades)"
label variable unc_public_univ "Attend Public University"
label variable unc_public_univ_r "Attend Public University (res. by grades)"
label variable unc_private_univ "Attend Private University"
label variable unc_private_univ_r "Attend Private University (res. by grades)"
label variable unc_pub_elite_wage_q1 "Attend Public University Tier 1"
label variable unc_pub_elite_wage_q1_r "Attend Public University Tier 1 (res. by grades)"
label variable unc_pub_elite_wage_q2 "Attend Public University Tier 2"
label variable unc_pub_elite_wage_q2_r "Attend Public University Tier 2 (res. by grades)"
label variable unc_pub_elite_wage_q3 "Attend Public University Tier 3"
label variable unc_pub_elite_wage_q3_r "Attend Public University Tier 3 (res. by grades)"
label variable unc_pub_elite_wage_q4 "Attend Public University Tier 1"
label variable unc_pub_elite_wage_q4_r "Attend Public University Tier 4 (res. by grades)"
label variable unc_pub_elite_wage_q5 "Attend Public University Tier 5"
label variable unc_pub_elite_wage_q5_r "Attend Public University Tier 5 (res. by grades)"
label variable unc_priv_elite_wage_q1 "Attend Private University Tier 1"
label variable unc_priv_elite_wage_q1_r "Attend Private University Tier 1 (res. by grades)"
label variable unc_priv_elite_wage_q2 "Attend Private University Tier 2"
label variable unc_priv_elite_wage_q2_r "Attend Private University Tier 2 (res. by grades)"
label variable unc_priv_elite_wage_q3 "Attend Private University Tier 3"
label variable unc_priv_elite_wage_q3_r "Attend Private University Tier 3 (res. by grades)"
label variable unc_priv_elite_wage_q4 "Attend Private University Tier 1"
label variable unc_priv_elite_wage_q4_r "Attend Private University Tier 4 (res. by grades)"
label variable unc_priv_elite_wage_q5 "Attend Private University Tier 5"
label variable unc_priv_elite_wage_q5_r "Attend Private University Tier 5 (res. by grades)"

label variable in_reserva_vagas "Reserved Seats (cond. attendance)"
label variable in_reserva_vagas_r "Reserved Seats (cond. attendance, res. by grades)"
label variable fin_est "Financiamento Estudiantil (cond. attendance)"
label variable fin_est_r "Financiamento Estudiantil (cond. attendance, res. by grades)"
label variable unc_remote "Remote Education"
label variable unc_remote_r "Remote Education (res. by grades)"
label variable unc_tecnico "Tecnico"
label variable unc_tecnico_r "Tecnico (res. by grades)"
label variable unc_in_reserva_vagas "Reserved Seats"
label variable unc_in_reserva_vagas_r "Reserved Seats (res. by grades)"
label variable unc_fin_est "Financiamento Estudiantil"
label variable unc_fin_est_r "Financiamento Estudiantil (res. by grades)"
label variable employee "Employed in RAIS"
label variable employee_r "Employed in RAIS (res. by grades)"
label variable employee_ri "Employed in RAIS (res. by grades and college FE)"
label variable any_activity "Any Activity (RAIS, MEI, Ownership)"
label variable any_activity_r "Any Activity (res. by grades)"
label variable any_activity_ri "Any Activity (res. by grades and college FE)"
label variable real_earnings "Real Earnings"
label variable real_earnings_r "Real Earnings (res. by grades)"
label variable real_earnings_ri "Real Earnings (res. by grades and college FE)"
label variable real_wages "Real Wages"
label variable real_wages_r "Real Wages (res. by grades)"
label variable real_wages_ri "Real Wages (res. by grades and college FE)"
label variable pc_wage "Future Wage Rank (within cohort)"
label variable pc_wage_r "Future Wage Rank (res. by grades)"
label variable pc_wage_ri "Future Wage Rank (res. by grades and college FE)"
label variable pc_earnings "Future Earnings Rank (within cohort)"
label variable pc_earnings_r "Future Earnings Rank (res. by grades)"
label variable pc_earnings_ri "Future Earnings Rank (res. by grades and college FE)"
label variable entrepreneur "Entrepreneur"
label variable entrepreneur_r "Entrepreneur (res. by grades)"
label variable entrepreneur_ri "Entrepreneur (res. by grades and college FE)"

drop unc_pub_elite_wage_q6 unc_pub_elite_wage_q6_r unc_priv_elite_wage_q6 unc_priv_elite_wage_q6_r
export delimited using "C:\Users\javie\jfeinmann Dropbox\javier feinmann\INEP_EXTRACCIONES\extractions\segunda_extraccion\database\Clean data\co_escola\high_school_graduates_cohort_2009_2014_ENEM.csv", replace