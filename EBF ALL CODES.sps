* Encoding: UTF-8.
COMPUTE age=V008 - B3.
EXECUTE.

* Select children living with the mother.
FILTER OFF.
USE ALL.
SELECT IF (B9=0). 
EXECUTE.

AGGREGATE
/OUTFILE=* MODE=ADDVARIABLES
/BREAK=V001 V002 V003
/BIDX_min=MIN(BIDX).

SELECT IF (BIDX_min = BIDX) .
EXECUTE.

* Select children age below 24.
FILTER OFF.
USE ALL.
SELECT IF ( age < 24).
EXECUTE.


* Create age gropus.
RECODE age (0 thru 1=1) (2 thru 3=2) (4 thru 5=3) (6 thru 8=4) (9 thru 11=5) (12 thru 17=6) (18 
thru 23=7) INTO age_grp.
VARIABLE LABELS age_grp 'age group'.
EXECUTE.

VALUE LABELS age_grp 1 " 0-1 month" 2 "2-3 months" 3 "4-5 months" 4 "6-8 months" 5 "9-11 months" 6 "12-17 months" 7 "18-23 months".

*23-06-2017.
COMPUTE water = 0.
EXECUTE.

COMPUTE liquids = 0.
EXECUTE.

COMPUTE milk= 0.
EXECUTE.

COMPUTE solid= 0.
EXECUTE.

COMPUTE bottle= 0.
EXECUTE.
COMPUTE breast= 0.
EXECUTE.

* to determine if child is given water.

DO IF (V409 >= 1 & V409 <= 7).
RECODE water (0=1).
END IF.
EXECUTE.

*To determine if Child is given liquids.
DO IF ((V410 >= 1 & V410 <= 7) | (V412c >= 1 & V412c <= 7) | (V413 >= 1 & V413 <= 7)) .
RECODE liquids (0=1).
END IF.
EXECUTE.

* to determine if child is given milk.

DO IF ((V411 >= 1 & V411 <= 7) | (V411a >= 1 & V411a <= 7)).
RECODE milk (0=1).
END IF.
EXECUTE.

*To determine if child drank from bottle with nipple.

DO IF (M38= 1 ).
RECODE bottle (0=1).
END IF.
EXECUTE.

*To determine if Child is given Solid.

DO IF ((V412A >=1 & V412A<=7) | (V414E >= 1 & V414E <= 7) | (V414F >=1 & V414F <=7) | (V414G >=1 & V414G <=7) | (V414H >=1 & V414H <=7) | 
(V414I >=1 & V414I <=7) | (V414J >=1 & V414J <=7) | (V414K >=1 & V414K <=7) | (V414L >=1 & V414L<=7) | (V414M>=1 & V414M<=7) |
(V414N >=1 & V414N <=7) | (V414O >=1 & V414O <=7) | (V414P >=1 & V414P <=7) | (V414S >=1 & V414S <=7) | (V414V >=1 & V414V <=7)).
RECODE Solid (0=1).
END IF.
EXECUTE.

*To determine if child is still breastfeeding.

DO IF (M4= 95).
RECODE breast (0=1).
END IF.
EXECUTE.
VALUE LABELS breast 0 "Not breastfeeding" 1 " Still breastfeeding".

*Matching Table 11.3 for exclusive breast feeding in 0-5 month children.

COMPUTE feeding=7.
EXECUTE.

* Not breastfeeding.
DO IF (breast= 0).
RECODE feeding (7=0).
END IF.
EXECUTE.

* exclusive breastfeeding.
DO IF (water = 0 & liquids = 0 & Milk = 0 & Solid = 0).
RECODE feeding (7=1).
END IF.
EXECUTE.

* breastfeeding + water.
DO IF (water = 1 & liquids = 0 & Milk = 0 & Solid = 0).
RECODE feeding (7=2).
END IF.
EXECUTE.

* breastfeeding + liquids.
DO IF ( liquids = 1 & milk = 0 & solid = 0).
RECODE feeding (7=3).
END IF.
EXECUTE.

* breastfeeding + milk.
DO IF (milk = 1 & solid = 0).
RECODE feeding (7=4).
END IF.
EXECUTE.

* breastfeeding + solid.
DO IF (solid = 1).
RECODE feeding (7=5).
END IF.
EXECUTE.



VALUE LABELS feeding 0 "Not breastfeeding" 1 "exclusive breastfeeding" 2 "+Water" 3 "+Liquids" 4 "+Other Milk" 5 "+Solids".

COMPUTE wt=v005/1000000.
EXECUTE.

FREQUENCIES VARIABLES=breast 
/ORDER=ANALYSIS.

COMPUTE wt=v005/1000000.
EXECUTE.

*exclusive breastfeeding age < 6 months.
COMPUTE ebf=0.
EXECUTE.

DO IF (feeding = 1).
RECODE ebf (0=1).
END IF.
EXECUTE.
VALUE LABELS ebf 0 "Not EBF" 1 "EBF".

USE ALL.
COMPUTE filter_$=(age < 23).
VARIABLE LABELS filter_$ 'age < 23 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=ebf
/ORDER=ANALYSIS.

*EBF 50.3.

SELECT IF (filter_$ =1). 
EXECUTE.

SAVE OUTFILE= 'F:\ResearchProject\Data\BDHS 2014\BD_2014_DHS_SPSS\bdkr70sv\BreastFeed.sav'
  /KEEP V103 V024 V025 V106 V130 V136 V730 V159 V157 V190 V201 V213 V445 V701 M17 B4 M15 M18 M54 H10 V404 H11 H11B H22 H31 H31B H31C v005
  V022 V001  V013 V701 V704 V714 B8.


GET FILE= 'F:\ResearchProject\Data\BDHS 2014\BD_2014_DHS_SPSS\bdkr70sv\BreastFeed.sav'.


IF  (H11 = 2  ) diarrhea=1.
IF  (H11 = 0 ) diarrhea=0. 
EXECUTE.

Compute bloodinstools =0.
Execute.

IF  (H11B = 1) bloodinstools=1.
IF  (H11B = 0) bloodinstools=0.
EXECUTE.

IF  (H22 = 1  ) fever=1.
IF  (H22 = 0 ) fever=0. 
EXECUTE.

IF  (H31 = 2  ) cough=1.
IF  (H31 = 0 ) cough=0. 
EXECUTE.


Compute breathing=0.
EXECUTE.

IF  (H31B = 1  ) breathing=1.
IF  (H31B = 0 ) breathing=0. 
EXECUTE.


compute chest_nose = 0.
EXECUTE.

IF  (H31C = 1 |  H31C = 3 | H31C = 3) Chest_nose =1. 
EXECUTE.

COMPUTE disease_count = diarrhea + bloodinstools  + fever + cough + breathing +  Chest_nose.
execute.

Compute MassMedia=0.
EXECUTE.


IF  (V159 = 0 | V157 = 0) MassMedia=0. 
IF  (V159 = 1 |  V159 = 2 | V159 = 3 | V157=1 | V157=2 | V157=3 ) MassMedia=1.
EXECUTE.

IF  (V704 = 12 ) Hsuband_work =0. 
IF  (V704 = 13 ) Hsuband_work =1.
IF  (V704 = 51 | V704 = 52) Hsuband_work =2.
IF  (V704 = 11  | V704 = 14 | V704 = 15 | V704 = 16 | V704 = 21 | V704 = 22 | V704 = 23 | V704 = 31| V704 = 41 | V704 = 61 |
V704 = 62 | V704 = 63 | V704 = 64 | V704 = 65 | V704 = 96) Hsuband_work = 3.
EXECUTE.



