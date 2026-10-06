
clear all
set maxvar 30000

use "D:\Research\BDHS Research\Nepal\SBA\Burkina Faso\Data\BFIR81DT\BFIR81FL.DTA", clear











*******************************************
*******************************************
* Data Create
********************************************
******************************************

 tab v020
 describe v020
 codebook v020




 tab p32_01
 describe p32_01
codebook  p32_01


 tab m17_1
 describe m17_1
 codebook m17_1
 
 
 
 
 tab v208
 describe v208
 codebook v208
 
 
 
 
 tab b5_01
 describe b5_01
 codebook b5_01
 
 
 
 
 
 
 
 
 
 
 
* Step 1: Keep ever-married sample
* (In IR file, already all are ever-married, so no filtering needed for v020)

* Step 2: Keep women who had at least one birth in last 5 years
keep if v208 > 0

* Step 3: Keep if last child is alive
keep if b5_01 == 1

* Step 4: Drop missing observations in key variables (optional)
drop if missing(v208, b5_01)

* Step 5: Check final sample size
tab v208
tab b5_01

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 *********************
 *********************
 * Outcome 
 
 **********************
 *********************
 /*
 Skilled Birth Attendance (SBA) — binary:

sba = 1 if delivery attendant was doctor, nurse, midwife, auxiliary nurse/midwife, other trained health professional. (NDHS: m3a..m3n → recode)

sba = 0 for TBA, family, neighbour, no one.
 

 Skilled birth attendants include doctor, nurse, or midwife (sometimes also health assistant or auxiliary midwife depending on country context).
Unskilled includes traditional birth attendants, relatives/friends, FCHV, other, or no one
 
 
 
 Skilled birth attendant (SBA) is "an accredited health professional—such as a midwife, doctor, or nurse—who has been educated and trained to proficiency in the skills needed to manage normal pregnancies, childbirth, and the immediate postnatal period, and to identify, manage, or refer complications in women and newborns.
 */
 
 
 
 
 
 
 
 **************************************************
 **************************************************
 * Outcome definition (target variable)
 ***************************************************
 ***************************************************
 
 
 
  tab m3a_1
  describe m3a_1
  codebook m3a_1
 
 
 
  ta m3b_1
  describe  m3b_1
  codebook  m3b_1
 
 
 
 
 
 tab m3c_1
 describe  m3c_1
 codebook  m3c_1
 
 
 
  tab m3g_1
  describe m3g_1
  codebook m3g_1
 
 
 
 
 
 
 
 
  tab m3h_1
  describe m3h_1
  codebook m3h_1


 
 
 
 
 
 
 ta m3i_1
 describe m3i_1
 codebook m3i_1
 
 
 
 
 
 
  ta m3k_1
  describe m3k_1
  codebook m3k_1
 
 
 
 
 ta m3n_1
 describe m3n_1
 codebook m3n_1
 
 
 
 
 
 
 /*
BDHS 2016 / 2019 reports use doctor, nurse, midwife, and sometimes auxiliary health worker as skilled.

Traditional birth attendants, relatives, FCHVs, and others are counted as unskilled.

তাই তোমার m3a_1, m3b_1, m3c_1 → Skilled এবং m3g_1, m3h_1, m3i_1, m3k_1, m3n_1 → Unskilled mapping is consistent with DHS/Nepal reports. 
 */
 
 
 
 
 
 
 * Initialize variable
gen SBA = .

* Skilled birth attendance
replace SBA = 1 if m3a_1 == 1 | m3b_1 == 1 | m3c_1 == 1

* Unskilled birth attendance
replace SBA = 0 if m3g_1 == 1 | m3h_1 == 1 | m3i_1 == 1 | m3k_1 == 1 | m3n_1 == 1

* Label values
label define SBA_lab 0 "Unskilled birth attendant" 1 "Skilled birth attendant"
label values SBA SBA_lab

* Check frequency
tab SBA

 
 
 
 
 drop if missing(SBA)

 
 
 
 
 
 
 
 *********************************
 **********************************
 * Confounder
 ********************************
 ********************************
 * Maternal
 tab v012, missing       // Age (continuous)
tab v013, missing    // Age group (categorical)

tab v106, missing       // Mother's education

tab v025, missing       // Place of residence (Urban/Rural)
tab v131, missing       // Religion
tab v130, missing       // Ethnicity/Caste
tab v502, missing       // Marital status

 
 
 
 
 
 *Household & socioeconomic variables
 
 
 
 tab v190, missing       // Wealth index
tab v218, missing       // Household size
tab v701, missing       // Husband/partner occupation
tab v155, missing       // Husband/partner education
tab v149, missing       // Woman's employment
tab v481, missing       // Health insurance (if available)

 
 
 * Obstetric & reproductive variables
 
 tab v208, missing       // Births in last 5 years
tab v201, missing       // Children ever born
tab m14_1, missing      // Place of delivery
tab m17_1, missing      // Mode of delivery (C-section / Vaginal)
tab m18_1, missing      // ANC visits (<4 vs >=4)
tab m2a_1, missing      // Maternal age at first birth
tab v525 , misisng    // Age at first sex
 
 
 
 
 * Media & empowerment variables
 
 
 tab v158, missing       // Newspaper frequency
tab v159, missing       // Radio frequency
tab v160, missing       // TV frequency
tab v149, missing       // Employment status
tab v743a, missing      // Decision on healthcare
tab v171a, missing  // Internet usage (if created)

 tab v171b, missing  // Internet usage freq (if created)

 
 
 
 
 *Geographic & contextual variables
 
 tab v024, missing       // Region / Division
tab v101, missing       // Cluster / PSU
tab province, missing   // Province (if available)

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 *****************************************************
* Skilled Birth Attendance Study
* Descriptive statistics for all predictors (confounders)
*****************************************************

*************************************
* Maternal variables
*************************************
tab v012, missing         // Age (continuous)
describe v012
codebook v012

tab v013, missing         // Age group (categorical)
describe v013
codebook v013

tab v106, missing         // Mother's education
describe v106
codebook v106

tab v025, missing         // Place of residence (Urban/Rural)
describe v025
codebook v025

tab v131, missing         // Ethnicity / Caste
describe v131
codebook v131

tab v130, missing         // Religion
describe v130
codebook v130



*************************************
* Household & socioeconomic variables
*************************************
tab v190, missing         // Wealth index
describe v190
codebook v190

tab v218, missing         // children number
describe v218
codebook v218

tab v701, missing         // Husband/partner occupation
describe v701
codebook v701

tab v155, missing         // Husband/partner education
describe v155
codebook v155

tab v149, missing         // Woman's education
describe v149
codebook v149

tab v481, missing         // Health insurance (if available)
describe v481
codebook v481



ta v717, missing   // working
describe v717
codebook v717




 ta v136 // hh size
 codebook v136
 describe v136



*************************************
* Obstetric & reproductive variables
*************************************
tab v208, missing         // Births in last 5 years
describe v208
codebook v208

tab v201, missing         // Children ever born
describe v201
codebook v201

tab m14_1, missing        // Place of delivery
describe m14_1
codebook m14_1

tab m17_1, missing        // Mode of delivery (C-section / Vaginal)
describe m17_1
codebook m17_1

tab m18_1, missing        // birth size
describe m18_1
codebook m18_1

tab m2a_1, missing        // prenatal doctor
describe m2a_1
codebook m2a_1


tab v212               // Maternal age at first birth
codebook v212
describe v212



 tab v636 , missing       // pressure to pregnant
codebook v636
describe v636


tab v525 , missing      // Age at first sex
codebook v525
describe v525


tab v536 , missing
codebook v536
describe v536


tab v602 , missing // fertility preference
codebook v602
describe v602




tab v763a
codebook v743a
describe v743a





tab v763b
codebook v743b
describe v743b


*************************************
* Media & empowerment variables
*************************************
tab v158, missing         // Newspaper frequency
describe v158
codebook v158

tab v159, missing         // Radio frequency
describe v159
codebook v159

tab v121, missing         // TV
describe v121
codebook v121

 tab v169a              // telephone
 describe v169a
 codebook v169a



tab v171a, missing        // Internet usage
describe v171a
codebook v171a

tab v171b, missing        // Internet usage frequency
describe v171b
codebook v171b

*************************************
* Geographic & contextual variables
*************************************
tab v024, missing         // Region / Division
describe v024
codebook v024

tab v101, missing         // Cluster / PSU
describe v101
codebook v101





















*****************************************
*****************************************
* preprocesing
*****************************************
*****************************************



*************************************
* Maternal variables
*************************************

* age 
gen age = .

* 1 = <20
replace age = 1 if v013 == 1

* 2 = 20–34
replace age = 2 if inlist(v013, 2,3,4)

* 3 = >35
replace age = 3 if inlist(v013, 5,6,7)

* Labeling
label define age_lbl 1 "<20" 2 "20-34" 3 ">35"
label values age age_lbl

tab age





* Create new variable edu_cat
gen edu_cat = .

* 0 = No education
replace edu_cat = 0 if v106 == 0

* 1 = Basic
replace edu_cat = 1 if v106 == 1

* 2 = Secondary/Higher
replace edu_cat = 2 if inlist(v106, 2,3)

* Add labels
label define edu_lbl 0 "No education" 1 "Basic" 2 "Secondary/Higher"
label values edu_cat edu_lbl

* Check the variable
tab edu_cat








* Create new variable residence
gen residence = .

* 1 = Urban
replace residence = 1 if v025 == 1

* 2 = Rural
replace residence = 2 if v025 == 2

* Add labels
label define res_lbl 1 "Urban" 2 "Rural"
label values residence res_lbl

* Check the variable
tab residence




* Create new binary ethnicity variable
gen ethnicity = .

* Hill groups = 1
replace ethnicity = 1 if inlist(v131, 4, 6, 8, 10)   // gourmantche, lobi, senoufo, dagara

* Non-hill groups = 0
replace ethnicity = 0 if ethnicity == .

* Label the categories
label define ethn_lbl 0 "Non-hill" 1 "Hill"
label values ethnicity ethn_lbl

* Check results
tab ethnicity


/*
ethnicity = 1 → Hill group

ethnicity = 0 → Non-hill group


hill brahmin + hill chhetri + hill dalit + hill janajati → 1

বাকি সব (terai brahmin/chhetri, other terai caste, terai dalit, terai janajati, newar, muslim, other) → 0


*/



tab v130



**************************************************************
* Collapse religion (v130) into 5 categories → religion_bin
**************************************************************




gen religion_cat = .

* Assign categories based on v130 numeric codes
replace religion_cat = 1 if v130 == 1             // Catholic
replace religion_cat = 2 if v130 == 2             // Islam
replace religion_cat = 3 if v130 == 3             // Zion
replace religion_cat = 4 if v130 == 4             // Evangelical/Pentecostal
replace religion_cat = 5 if inlist(v130, 5, 6, 96)  // Others: Anglican, No religion, Other

* Define value labels
label define relabel 1 "Catholic" 2 "Islam" 3 "Zion" 4 "Evangelical/Pentecostal" 5 "Other"
label values religion_cat relabel
label variable religion_cat "Religion (5 categories)"

* Check frequencies
tab religion_cat, missing










*************************************
* Household & socioeconomic variables
*************************************


* Create new variable wealth_cat
gen wealth_cat = .

* 1 = Poor (poorest + poorer)
replace wealth_cat = 1 if inlist(v190, 1,2)

* 2 = Middle
replace wealth_cat = 2 if v190 == 3

* 3 = Rich (richer + richest)
replace wealth_cat = 3 if inlist(v190, 4,5)

* Add labels
label define wealth_lbl 1 "Poor" 2 "Middle" 3 "Rich"
label values wealth_cat wealth_lbl

* Check the variable
tab wealth_cat







* Create new variable child_cat
gen child_cat = .

* 1 = Single child
replace child_cat = 1 if v218 == 1

* 2 = Multiple children
replace child_cat = 2 if v218 >= 2

* Add labels
label define child_lbl 1 "Single child" 2 "Multiple children"
label values child_cat child_lbl

* Check the variable
tab child_cat




* Create new variable hh_size_group
gen hh_size_group = .

* 1 = Household members ≤5
replace hh_size_group = 1 if v136 <= 5

* 2 = Household members >5
replace hh_size_group = 2 if v136 > 5

* Add labels
label define hhgroup_lbl 1 "≤5 members" 2 ">5 members"
label values hh_size_group hhgroup_lbl

* Check the variable
tab hh_size_group














* Create new variable husb_edu_cat
gen husb_edu = .

* 1 = No education
replace husb_edu = 1 if v701 == 0

* 2 = Basic
replace husb_edu = 2 if v701 == 1

* 3 = Secondary + Higher
replace husb_edu = 3 if inlist(v701, 2,3)

* 4 = Don't know / Missing
replace husb_edu = 4 if v701 == 8 | missing(v701)

* Add labels
label define husb_lbl 1 "No education" 2 "Basic" 3 "Secondary/Higher" 4 "Don't know/Missing"
label values husb_edu husb_lbl

* Check the variable
tab husb_edu




/*
* Create new variable woman_edu
gen woman_edu = .

* 1 = No education
replace woman_edu = 1 if v149 == 0

* 2 = Basic education (primary incomplete/complete + secondary incomplete)
replace woman_edu = 2 if inlist(v149, 1,2,3)

* 3 = High education (secondary complete + higher)
replace woman_edu = 3 if inlist(v149, 4,5)

* Add labels
label define woman_edu_lbl 1 "No education" 2 "Basic" 3 "High"
label values woman_edu woman_edu_lbl

* Check the variable
tab woman_edu
*/


* Create binary variable for health insurance coverage
gen health_ins = v481

* Add labels
label define ins_lbl 0 "No" 1 "Yes"
label values health_ins ins_lbl

* Check the variable
tab health_ins








* Create binary variable for working status
gen working_status = .

* 0 = Not working
replace working_status = 0 if v717 == 0

* 1 = Working (any type of occupation)
replace working_status = 1 if inlist(v717, 1,2,3,4,8,9)

* Add labels
label define work_lbl 0 "Not working" 1 "Working"
label values working_status work_lbl

* Check the variable
tab working_status








*-----------------------------------------------*
* Create new variable: Parity (single vs multiple)
*-----------------------------------------------*




gen parity = . 

* 1 = Primiparous (first-time mother)
replace parity = 1 if v201 == 1

* 2 = Multiparous (2+ lifetime births)
replace parity = 2 if v201 >= 2

label define parity_lbl 1 "Primiparous (1 birth)" 2 "Multiparous (2+ births)"
label values parity parity_lbl

tab parity

/*
| Study                   | Journal                        | Variable used | Note                                                                          |
| ----------------------- | ------------------------------ | ------------- | ----------------------------------------------------------------------------- |
| Tessema GA et al., 2021 | *BMC Pregnancy and Childbirth* | `v201`        | Included women with births in last 5 years; defined parity using total births |
| Yaya S et al., 2018     | *Women & Health*               | `v201`        | Restricted to recent births; parity = 1 vs. ≥2                                |
| Rahman M et al., 2020   | *Reproductive Health*          | `v201`        | Kept last 5-year births; used parity as primiparous/multiparous               |
| Islam M et al., 2022    | *PLOS Global Public Health*    | `v201`        | DHS Bangladesh study, same approach                                           |


*/










*------------------------------------------------------------
* Create binary variable for antenatal care visits (ANC_visits)
*------------------------------------------------------------

* Clean special or missing codes if any
replace m14_1 = . if m14_1 >= 97   // DHS missing codes (97, 98, 99)

* Generate new variable
gen ANC_visit = .
label variable ANC_visit "Adequate ANC visits (4 or more)"

* Categorize:
* 0 = less than 4 ANC visits (including don't know and missing)
* 1 = 4 or more ANC visits
replace ANC_visit = 0 if m14_1 < 4 | m14_1 == 98 | m14_1 == . 
replace ANC_visit = 1 if m14_1 >= 4 & m14_1 < .

* Add labels
label define ANC_lbl 0 "<4" ///
                    1 ">=4"
label values ANC_visit ANC_lbl

* Check
tab ANC_visit, missing


/*
Antenatal care (ANC) utilization was dichotomized based on WHO recommendations: women with fewer than four ANC visits—including those who responded "don't know" or had missing data—were categorized as having inadequate ANC (0), while those with four or more visits were coded as having adequate ANC (1).

*/






*------------------------------------------------------------
* Create binary variable for mode of delivery
*------------------------------------------------------------

gen delivery_mode = m17_1
label variable delivery_mode "Mode of delivery"

* Add value labels
label define del_lbl 0 "Vaginal delivery" 1 "Caesarean section"
label values delivery_mode del_lbl

* Check
tab delivery_mode, missing







*------------------------------------------------------------
* Create binary variable for birth size
*------------------------------------------------------------
gen birth_size = .

* 0 = Smaller than average / very small / don't know / missing
replace birth_size = 0 if inlist(m18_1, 4,5,8) | missing(m18_1)

* 1 = Average or larger
replace birth_size = 1 if inlist(m18_1, 1,2,3)

* Add labels
label define bsize_lbl 0 "Small / Unknown" 1 "Average or Large"
label values birth_size bsize_lbl

* Check
tab birth_size, missing


/*
Birth size was categorized as "Average or Large" (1) versus "Small / Unknown" (0), consistent with DHS maternal and child health reporting. Children whose birth size was not reported ("don't know") were included in the small/unknown category to avoid missing data bias.

*/



*------------------------------------------------------------
* Create binary variable for prenatal doctor visit
*------------------------------------------------------------
gen pnc_doc = .

* 0 = No prenatal doctor
replace pnc_doc = 0 if m2a_1 == 0

* 1 = Yes prenatal doctor
replace pnc_doc = 1 if m2a_1 == 1

* Add labels
label define pnc_lbl 0 "No prenatal doctor" 1 "Prenatal doctor"
label values pnc_doc pnc_lbl

* Check
tab pnc_doc, missing






/*
orld Health Organization (WHO) – Adolescent pregnancy fact sheet

Defines teenage/early maternal age as <20 years and adult maternal age as ≥20 years.

Used widely in public health research for categorization.

DHS-based studies in peer-reviewed journals:

Rahman et al., 2019, The Lancet Global Health – Maternal age at first birth <20 years was considered "early" and ≥20 years "adult."

Nair et al., 2020, BMC Pregnancy and Childbirth – Used the same dichotomy to study adverse birth outcomes.

Kumar et al., 2018, PLOS ONE – Categorized maternal age at first birth as <20 vs ≥20 in analyses of child stunting and maternal outcomes.

UNICEF / DHS reports – Often categorize maternal age at first birth in the same way to assess risk of adverse maternal and child outcomes.
*/







*------------------------------------------------------------
* Binary variable for maternal age at first birth
*------------------------------------------------------------
gen mat_age1st = .

* 0 = Early (<20 years)
replace mat_age1st = 0 if v212 < 20

* 1 = Adult (≥20 years)
replace mat_age1st = 1 if v212 >= 20

* Add labels
label define matage_lbl 0 "<20 years" 1 "≥20 years"
label values mat_age1st matage_lbl

* Check
tab mat_age1st, missing







* Create new variable for pregnancy pressure
gen preg_pressure = . 

* 0 = Not pressured
replace preg_pressure = 0 if v636 == 0

* 1 = Pressured
replace preg_pressure = 1 if v636 == 1

* Add labels
label define preg_lbl 0 "Not pressured" 1 "Pressured"
label values preg_pressure preg_lbl

* Check the variable
tab preg_pressure, missing








* Create new binary variable for age at first sex
gen age_first_sex= . 

* 0 = <18 years
replace age_first_sex = 0 if v525 < 18

* 1 = >=18 years
replace age_first_sex = 1 if v525 >= 18

* Add labels
label define sexage_lbl 0 "<18 years" 1 "≥18 years"
label values age_first_sex sexage_lbl

* Check the variable
tab age_first_sex, missing






* Create binary variable for recent sexual activity
gen sex_active = . 

* 1 = Active in last 4 weeks
replace sex_active = 1 if v536 == 1

* 0 = Not active in last 4 weeks (postpartum or not)
replace sex_active = 0 if inlist(v536, 2,3)

* Add labels
label define sexact_lbl 0 "Not active" 1 "Active"
label values sex_active sexact_lbl

* Check
tab sex_active, missing









* Create binary fertility preference variable
gen fert_pref = . 

* 1 = Want more children (have another + undecided)
replace fert_pref = 1 if inlist(v602, 1,2)

* 0 = Do not want more children (no more + sterilized + infecund)
replace fert_pref = 0 if inlist(v602, 3,4,5)

* Add labels
label define fert_lbl 0 "Do not want more" 1 "Want more"
label values fert_pref fert_lbl

* Check
tab fert_pref, missing









* Create binary variable for genital sore/ulcer
gen genital_ulcer = . 

* 0 = No / Don't know
replace genital_ulcer = 0 if inlist(v763b, 0, .a)

* 1 = Yes
replace genital_ulcer = 1 if v763b == 1

* Add labels
label define gu_lbl 0 "No" 1 "Yes"
label values genital_ulcer gu_lbl

* Check
tab genital_ulcer, missing









* --------------------------------------
* Step 1: Recode individual media variables as binary
* --------------------------------------
gen radio_exp = 0
replace radio_exp = 1 if v158 >= 1

gen tv_exp = 0
replace tv_exp = 1 if v159 >= 1

gen tv_house = 0
replace tv_house = 1 if v121 == 1

gen mobile = v169a

* --------------------------------------
* Step 2: Create a single composite media variable
* 0 = no exposure to any media
* 1 = exposed to at least one media type
* --------------------------------------
gen media = 0
replace media = 1 if radio_exp==1 | tv_exp==1 | tv_house==1 | mobile==1

* Add labels
label define media_lbl 0 "No media exposure" 1 "Any media exposure"
label values media media_lbl

* Check
tab media






* Create binary internet usage variable
gen internet_use = .

* 0 = no or low usage
replace internet_use = 0 if v171b == 0 | v171b == 1

* 1 = regular usage
replace internet_use = 1 if v171b == 2 | v171b == 3

* Label the variable
label define internet_lbl 0 "Low usage" 1 "Regular usage"
label values internet_use internet_lbl

* Check results
tab internet_use, missing






*******************************
tab v743a
describe v743a
codebook v743a

tab v743b
describe v743b
codebook v743b

tab v743d
describe v743d
codebook v743d


*1 = respondent involved

*0 = respondent not involved
* Generate decision variable
gen deci_make = .

* Respondent involved (alone or jointly)
replace deci_make = 1 if inlist(v743a, 1, 2) | inlist(v743b, 1, 2) | inlist(v743d, 1, 2)

* Respondent not involved
replace deci_make = 0 if inlist(v743a, 4, 5, 6) | inlist(v743b, 4, 5, 6) | inlist(v743d, 4, 5, 6)

* Label
label define deci_make_lbl 0 "No" 1 "Yes"
label values deci_make deci_make_lbl

* Check
tab deci_make












/*

tab v744a
describe v744a
codebook v744a

tab v744b
describe v744b
codebook v744b

tab v744c
describe v744c
codebook v744c

tab v744d
describe v744d
codebook v744d

tab v744e // ipv
describe v744e
codebook v744e



* Generate IPV variable
gen IPV = .

* If any justification is yes (1) => IPV = 1
replace IPV = 1 if v744a==1 | v744b==1 | v744c==1 | v744d==1 | v744e==1

* If all are no (0) => IPV = 0
replace IPV = 0 if v744a==0 & v744b==0 & v744c==0 & v744d==0 & v744e==0

* Label
label define IPV_lbl 0 "No" 1 "Yes"
label values IPV IPV_lbl

* Check
tab IPV


*/

**************************************************************
* 3. Create IPV Variables (Ever-partnered women only)
**************************************************************
* Physical IPV: d105a-f + d105j
gen physical = (d105a==1 | d105b==1 | d105c==1 | d105j==1 | d105d==1 | d105e==1 | d105f==1)

* Sexual IPV: d105h-i + d105k
gen sexual = (d105h==1 | d105i==1 | d105k==1)

* Emotional IPV: d103a-c
gen emotional = (d103a==1 | d103b==1 | d103c==1)

* Any IPV: composite
gen any_ipv = (physical==1 | sexual==1 | emotional==1)





tab physical
tab sexual
 tab emotional
 tab any_ipv



* Rename v024 to province
rename v024 province

* Check the result
tab province






*-------------------------------------------------
* Run logistic regression with all predictors
*-------------------------------------------------
  

svy: logistic SBA ///
    i.province ///
    i.age ///
    i.edu_cat ///
    i.residence ///
    i.ethnicity ///
    i.religion_cat ///
    i.wealth_cat ///
    i.child_cat ///
    i.hh_size_group ///
    i.husb_edu ///
    i.health_ins ///
    i.parity ///
    i.ANC_visit ///
    i.birth_size ///
    i.pnc_doc ///
    i.mat_age1st ///
    i.age_first_sex ///
    i.sex_active ///
    i.fert_pref ///
    i.media ///
    i.internet_use






