# rename SI images whoops 
library(dplyr)

setwd("~/Desktop/carrie/download_digitized_images/images_SI/")

#SI data
SI <- read.table("../data/SI/multimedia.txt", 
                 sep = "\t", 
                 header = TRUE) # SI URLS
SIocc <- read.table("../data/SI/occurrence.txt", 
                    sep = "\t", 
                    header = TRUE, 
                    quote = "",
                    fill = TRUE) # SI occurrence (with sp IDs)
SIocc <- SIocc[ , c("gbifID", "genus", "specificEpithet")] # grab columns we want
SIocc$scientificName <- paste0(SIocc$genus, "_", SIocc$specificEpithet) # make col with current species names
SIocc$scientificName[SIocc$scientificName=="_"] <- "Bomarea" # if no species ID, just call it Bomarea 
SIocc$scientificName[SIocc$scientificName=="Bomarea_"] <- "Bomarea" # if no species ID, just call it Bomarea
SImerge <- left_join(SI, SIocc) # combine URL with species names

# get existing name and grab gbif ID 


makeNewName <- function(f) {
  gbif_ID <- strsplit(strsplit(f, split = "_ ")[[1]][3], split = "\\(")[[1]][1]
  row <- SImerge[which(SImerge$gbifID == gbif_ID),]
  f_num <- strsplit(strsplit(f, "\\(")[[1]][2], "\\)")[[1]][1]
  new_f <- paste0(row$scientificName[1],"_SI_", row$gbifID[1],"(", f_num, ").jpg")
  return(new_f)
}

files <- list.files()

file.rename(files, unlist(lapply(files, makeNewName)))
