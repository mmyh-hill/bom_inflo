library(dplyr)

#SI data
SI <- read.table("data/SI/multimedia.txt", 
                 sep = "\t", 
                 header = TRUE) # SI URLS
SIocc <- read.table("data/SI/occurrence.txt", 
                    sep = "\t", 
                    header = TRUE, 
                    quote = "",
                    fill = TRUE) # SI occurrence (with sp IDs)
SIocc <- SIocc[ , c("gbifID", "genus", "specificEpithet")] # grab columns we want
SIocc$scientificName <- paste0(SIocc$genus, "_", SIocc$specificEpithet) # make col with current species names
SIocc$scientificName[SIocc$scientificName=="_"] <- "Bomarea" # if no species ID, just call it Bomarea 
SIocc$scientificName[SIocc$scientificName=="Bomarea_"] <- "Bomarea" # if no species ID, just call it Bomarea
SImerge <- left_join(SI, SIocc) # combine URL with species names

# download SI images 
for (i in 6:nrow(SImerge)) {
  if (SImerge[i, 4] != "") {
    holdurl <- SImerge[i, 4]
    imagename <- paste0("SI_", SImerge[i, 18], "_", SImerge[i, 1])
    j <- 1
    if (i > 1) {
      if (imagename == imagenameold) {
        j <- jold + 1
      }
    } else if (i == 1) {
      oldurl <- ""
    }
    imageloc <-
      paste(
        "images_SI/",
        imagename,
        "(",
        j,
        ")",
        ".jpg",
        sep = ""
      )
    download.file(holdurl, imageloc)
    imagenameold <- imagename
    jold <- j
  }
}

