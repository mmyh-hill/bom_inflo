library(RevGadgets)
setwd("~/Desktop/bomarea_infl_testruns/")
infl_type <- processAncStates("output/infl_type_ase_ard.tree", state_labels = c("0" = "Plain umbel",
                                                                                "1" = "Bracteole umbel",
                                                                                "2" = "Compound inflorescence"))
plotAncStatesPie(infl_type, tip_labels = FALSE)

#rates <- readTrace(c("output/infl_type_ard_run_1.log",
#                     "output/infl_type_ard_run_2.log"))

#rates <- combineTraces(rates)

#plotTrace(rates, match = "rate")
