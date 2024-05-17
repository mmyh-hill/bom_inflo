library(dplyr)

#field data
field <- read.table("data/F/multimedia.txt", sep = "\t", header = TRUE) # field URLs
fieldocc <- read.table("data/F/occurrence.txt", sep = "\t", header = TRUE, fill = TRUE) # field occurrence (with sp IDs)
fieldocc <- fieldocc[ , c("gbifID", "genus", "specificEpithet")] # grab columns we want
fieldocc$scientificName <- paste0(fieldocc$genus, "_", fieldocc$specificEpithet) # make col with current species names
fieldocc$scientificName[fieldocc$scientificName=="_"] <- "Bomarea" # if no species ID, just call it Bomarea
fieldocc$scientificName[fieldocc$scientificName=="Bomarea_"] <- "Bomarea" # if no species ID, just call it Bomarea 
fieldmerge <- left_join(field, fieldocc) # combine URL with species names

 
# download Field images  
for (i in 1:nrow(fieldmerge)) {
  if (fieldmerge[i, 4] != "") {
    holdurl <- fieldmerge[i, 4]
    holdurl <- gsub("https", "http", holdurl, fixed = TRUE)
    imagename <- paste0(fieldmerge[i, 18], 
                        "_", 
                        fieldmerge[i, 1])
    j <- 1
    if (i > 1) {
      if (imagename == imagenameold) {
        j <- jold + 1
      }
    } else if (i == 1) {
      oldurl <- ""
    }
    if (holdurl != oldurl) {
      imageloc <-
        paste0("images_F/",
               imagename,
               "(",
               j,
               ")",
               ".jpg")
      download.file(holdurl, imageloc)
      imagenameold <- imagename
      oldurl <- holdurl
      jold <- j
    }
  }
}


