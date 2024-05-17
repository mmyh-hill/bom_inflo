setwd("~/Desktop/bomarea_traits")
library(dplyr)
library(tidyr)
library(vegan)
library(readxl)
library(ape)
library(tidytree)

traits <- read_xlsx("bomarea traits.xlsx", sheet = 3, na = "N/A")

get_most_frequent_discrete_value <- function(vec) {
  tbl <- table(vec)
  if (dim(tbl) > 0) {
    value <- names(tbl)[which.max(tbl)]
    return(value)
  } else {
    return (NA)
  }
  }

### Name Check
sameName <- function(df) {
  if (df[1] != df[2]) {
    return(1)
  }
  else {
    return(NA)
  }
}

subsetName <- traits[, c("speciesName", "acceptedName")]
subsetName$ifSame <- apply(subsetName, 1, sameName)
subsetName <- na.omit(subsetName)
write.csv(subsetName, file = "NameCheck")
### Name Check End

traits %>% 
  group_by(acceptedName) %>%
  summarise(numBranchP = mean(numBranchP, na.rm = T),
            numBracts = mean(numBracts, na.rm = T),
            numBranch1 = mean(numBranch1, na.rm = T), 
            numBranch2 = mean(numBranch2, na.rm = T),
            numBranch3 = mean(numBranch3, na.rm = T),
            numBranch4 = mean(numBranch4, na.rm = T),
            numBranch5 = mean(numBranch5, na.rm = T),
            Bracteoles = get_most_frequent_discrete_value(Bracteoles),
            ifFruiting = get_most_frequent_discrete_value(ifFruiting),
            matFruit = get_most_frequent_discrete_value(matFruit),
            ifFlowering = get_most_frequent_discrete_value(ifFlowering),
            matFlower = get_most_frequent_discrete_value(matFlower),
            allFlowersMat = get_most_frequent_discrete_value(allFlowersMat),
            nectarGuides = get_most_frequent_discrete_value(nectarGuides),
            colorTepalP = get_most_frequent_discrete_value(colorTepalP),
            colorTepalS = get_most_frequent_discrete_value(colorTepalS),
            ifTepalLengthMatch = get_most_frequent_discrete_value(ifTepalLengthMatch),
            ETepalLength = get_most_frequent_discrete_value(ETepalLength),
            ifExcerted = get_most_frequent_discrete_value(ifExcerted)) -> traits_by_species

traits_by_species_averaged <- cbind(traits_by_species[, c("acceptedName","numBranchP","numBracts","numBranch1")],
                                    traits_by_species[, c("Bracteoles","ifFruiting","matFruit","ifFlowering",       
                                                         "matFlower","allFlowersMat","nectarGuides",      
                                                         "colorTepalP","colorTepalS","ifTepalLengthMatch",
                                                         "ETepalLength","ifExcerted")])


traits_by_species_averaged[sapply(traits_by_species_averaged, is.infinite)] <- NA
traits_by_species_averaged[sapply(traits_by_species_averaged, is.nan)] <- NA
traits_by_species_averaged <- as.data.frame(apply(traits_by_species_averaged, 
                                                 2, 
                                                 car::recode, 
                                                 recodes = "'NA' = NA"))
traits_by_species_averaged <- as.data.frame(apply(traits_by_species_averaged, 
                                                  2, 
                                                  car::recode, 
                                                  recodes = "'' = NA"))
traitdata <- traits_by_species_averaged
traitdata$numBranchP <- as.numeric(traitdata$numBranchP)
traitdata$numBracts <- as.numeric(traitdata$numBracts)
traitdata$numBranch1 <- as.numeric(traitdata$numBranch1)

typeset <- function(df) {
  if (df[2]==TRUE & df[3]==FALSE) { ## umbellike, no bracteoles
    return(0)
  }
  else if (df[2]==TRUE & df[3]==TRUE) { ## umbellike w/ bracteoles
    return(1)
  }
  else if (df[2]==FALSE & df[3]==TRUE) { ## non umbel (branching) w/ bracteoles
    return(2)
  }
}

#### new stuff: infl type
traitdata %>%
  mutate(umbellike = numBranch1==0) %>%
  mutate(bracteoles = Bracteoles=="Y") %>%
  mutate(acceptedName = gsub(" ", "_", acceptedName)) %>%
  select(acceptedName, umbellike, bracteoles) -> traitdatasubset

traitdatasubset$type = apply(traitdatasubset, 1, typeset)

### new stuff: infl trait isolation (size + tepal traits)

traits %>%
  group_by(acceptedName) %>%
  summarise(maxBranchNo = max(numBranchP, na.rm = T),
            maxBranchLength = max(lengthTotal1, lengthTotal2, lengthTotal3, lengthTotal4, lengthTotal5, na.rm = T),
            degreeBranch = max(numBranch1, numBranch2, numBranch3, numBranch4, numBranch5, na.rm = T),
            colorTepalP = get_most_frequent_discrete_value(colorTepalP),
            colorTepalS = get_most_frequent_discrete_value(colorTepalS),
            ifTepalLengthMatch = get_most_frequent_discrete_value(ifTepalLengthMatch),
            ifExcerted = get_most_frequent_discrete_value(ifExcerted)) -> inflSelect
inflSelect %>%
  count(colorTepalP, sort = TRUE)
inflSelect %>%
  count(colorTepalS, sort = TRUE)


### new stuff: sparsity via length/# branches


#match names to tree
tree <- read.tree("data/bom_only_MAP.tre")
tree_df <- as_tibble(tree)

get_gen_sp <- function(x) {
  if (is.na(x)) {
    return(NA)
  } else if (grepl("_cf_", x)) {
    namesplit <- unlist(strsplit(x, split = "_"))
    newname <- paste0(namesplit[1], "_", namesplit[3])
    return(newname) 
  } else {
    namesplit <- unlist(strsplit(x, split = "_"))
    newname <- paste0(namesplit[1], "_", namesplit[2])
    return(newname) 
  }
}

tree_df$speciesName <- unlist(lapply(tree_df$label, get_gen_sp))
tree_df <- left_join(tree_df, traitdatasubset)
typedat <- data.frame(label = tree_df$label, type = tree_df$type)
typedat <- typedat[is.na(typedat$label) == FALSE, ]
typedat$type <- replace_na(as.character(as.integer(typedat$type)), "?")

typemat <- matrix(typedat$type, ncol =1)
rownames(typemat) <- typedat$label
colnames(typemat) <- "type"

#write to nexus 
write.nexus.data(umbelmat, file = "data/type.nexus", format = "standard", missing = "?")