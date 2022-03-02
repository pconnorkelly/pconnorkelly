// name: Impact Eval Problem Set 1
// author: Connor Kelly
// date_created: Sep 15, 2019
clear all
cd "/Users/apple/Desktop/Impact Eval"
capture log close
set logtype smcl
log using ieps1, replace 
version 15
set more off

use "/Users/apple/Desktop/Impact Eval/ps1_instructions/oregon.dta"
gen female = 1 if male == 0
replace female = 0 if male ==1

gen ed = 1 if ed_on_pre == 0 | ed_on_pre==1
replace ed = 0 if ed_on_pre==.

reg ed lottery
/*
      Source |       SS           df       MS      Number of obs   =    74,922
-------------+----------------------------------   F(1, 74920)     =      8.92
       Model |  1.96976773         1  1.96976773   Prob > F        =    0.0028
    Residual |  16536.5943    74,920  .220723362   R-squared       =    0.0001
-------------+----------------------------------   Adj R-squared   =    0.0001
       Total |  16538.5641    74,921  .220746707   Root MSE        =    .46981

------------------------------------------------------------------------------
          ed |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
     lottery |  -.0104743   .0035062    -2.99   0.003    -.0173466   -.0036021
       _cons |   .3331263   .0022126   150.56   0.000     .3287897    .3374629
------------------------------------------------------------------------------
*/


drop if ed_visit_pre==.

reg birthyear lottery
reg female lottery
reg english lottery
reg self lottery
reg first_day lottery
reg have_phone lottery
reg pobox lottery

//Table 3 Replication

ivregress 2sls ed_visit_post (enrolled_post_ever = lottery) ed_visit_pre i.numhh, ///
	cluster(id_household)
sum ed_visit_post if lottery==0
sum ed_visit_post if lottery==0 & one==1
sum ed_visit_post if lottery==0 & twoplus==1
sum ed_visit_post if lottery==0 & fiveplus==1
sum ed_visit_post if lottery==0 & twoplus_out==1

ivregress 2sls ed_visit_post (enrolled_post_ever = lottery) ed_visit_pre i.numhh /// 
	if one==1, cluster(id_household)
	
ivregress 2sls ed_visit_post (enrolled_post_ever = lottery) ed_visit_pre i.numhh ///
	if twoplus==1, cluster(id_household)

ivregress 2sls ed_visit_post (enrolled_post_ever = lottery) ed_visit_pre i.numhh ///
	if fiveplus==1, cluster(id_household)

ivregress 2sls ed_visit_post (enrolled_post_ever = lottery) ed_visit_pre i.numhh ///
	if twoplus_out==1, cluster(id_household)

//Table 4 Replication
sum tr_ed_edcnnp_post if lottery==0
sum tr_ed_edcnpa_post if lottery== 0
sum tr_ed_epct_post if lottery==0

ivregress 2sls tr_ed_edcnnp_post (enrolled_post_ever = lottery) tr_ed_edcnnp_pre ///
	tr_ed_edcnnp_pre_miss i.numhh, cluster(id_household)

ivregress 2sls tr_ed_edcnpa_post (enrolled_post_ever = lottery) tr_ed_edcnpa_pre ///
	tr_ed_edcnpa_pre_miss i.numhh, cluster(id_household)

ivregress 2sls tr_ed_epct_post (enrolled_post_ever = lottery) tr_ed_epct_pre ///
	tr_ed_epct_pre_miss i.numhh, cluster(id_household)


log close
