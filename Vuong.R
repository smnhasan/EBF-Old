###################Vuong Test to check excess zero in count model###################
#                            Mohammad Nayeem Hasan                                 #
####################################################################################

require(ggplot2)
require(pscl)
require(boot)
require(MASS)

zinb <- read.csv("F:\\ResearchProject\\Jamal Sir\\Breastfeed/BF_CSV_Final.csv")

summary(zip <- zeroinfl(disease_count ~ ebf , data = zinb))

mnull <- update(m1, . ~ 1)

pchisq(2 * (logLik(m1) - logLik(mnull)), df = 3, lower.tail = FALSE)

summary(pr <- glm(disease_count ~ ebf, family= poisson, data = zinb))

vuong(zip, pr)

summary(zin <- zeroinfl(disease_count ~ ebf ,dist = "negbin", data = zinb))

summary(nb <- glm.nb(disease_count ~ ebf, data = zinb))

vuong(zin, nb)

vuong(zin, zip)

