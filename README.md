# bom_inflo
Code for analysis on inflorescence evolution in Bomarea

Link to google drive folder with image metadata (Smithsonian and Field Museum specimens):
https://drive.google.com/drive/folders/1bv4PKfV_kNo0SJyzhE00N4WXZmUobq2E?usp=share_link

data_prep scripts:
	bomareacode.R: run analyses on coded traits
	plotresults.R: plots ancestral state results
	plotviolinrates.R: plots results in violin plot
	binary_umbel.Rev: runs ancestral state reconstruction of umbel types as a binary character
	infl_types.Rev: runs ancestral state reconstruction for 3 umbel types (single rate model)
	infl_type_ard.Rev: runs ancestral state reconstruction for 3 umbel types (all rates different model)
image_prep_scripts:
	downloadurl_F.R: downloads Field Museum specimen images from urls (see image metadata folder), labels by species, gbifID, and iteration of gbifID (to avoid saving over files in the case of more than one photo of a particular specimen)
	downloadurl_SI.R: downloads Smithsonian specimen images from urls (see image metadata folder), labels by species, gbifID, and iteration of gbifID (to avoid saving over files in the case of more than one photo of a particular specimen)
	rename_SI.R: renames SI images due to hitch in specific specimen cases

	specimen images from other museums were downloaded individually and their information stored manually (ex. Kew specimens)

Specimen images on accompanying hard drive