# bom_inflo
Code for analysis on inflorescence evolution in Bomarea

[Link](https://drive.google.com/drive/folders/1bv4PKfV_kNo0SJyzhE00N4WXZmUobq2E?usp=share_link) to google drive folder with image metadata (Smithsonian and Field Museum specimens).

[Link](https://docs.google.com/spreadsheets/d/1tz5yj18hGkikD05JvuuDW6Y-gS-BnChY6fLEXKZQcnA/edit?usp=sharing) to datasheet on Google Drive.

Trait coding and data sheet color legend is [here](https://drive.google.com/file/d/1-8_w90ZOqw7TNES3cnNXsbYn2YeAs0IH/view?usp=sharing). 

data_prep scripts:
- bomareacode.R: run analyses on coded traits
- plotresults.R: plots ancestral state results
- plotviolinrates.R: plots results in violin plot
- binary_umbel.Rev: runs ancestral state reconstruction of umbel types as a binary character
- infl_types.Rev: runs ancestral state reconstruction for 3 umbel types (single rate model)
- infl_type_ard.Rev: runs ancestral state reconstruction for 3 umbel types (all rates different model)
 
image_prep_scripts:
- downloadurl_F.R: downloads Field Museum specimen images from urls (see image metadata folder), labels by species, gbifID, and iteration of gbifID (to avoid saving over files in the case of more than one photo of a particular specimen)
- downloadurl_SI.R: downloads Smithsonian specimen images from urls (see image metadata folder), labels by species, gbifID, and iteration of gbifID (to avoid saving over files in the case of more than one photo of a particular specimen)
- rename_SI.R: renames SI images due to hitch in specific specimen cases

Specimen images from other museums were downloaded individually and their information stored manually (ex. Kew specimens)

Specimen images on accompanying hard drive
