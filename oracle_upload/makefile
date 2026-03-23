
ifndef LCLS_LATTICE
$(error MY_ENV_VAR is not set. Please set it before running make)
endif

SCRIPT_DIR = $(LCLS_LATTICE)/python/scripts/oracle_upload

# Variables
MODELS = sc_sxr sc_hxr sc_bsyd sc_dasel sc_diag0 cu_sxr cu_hxr
OPTICS = 24MAR2025s

# Expand model-specific files
SURVEY_TAPES = $(foreach model,$(MODELS),$(model)_survey.tape)
TWISS_DATS = $(foreach model,$(MODELS),$(model)_twiss.dat)
LINES_PRECURSORS = $(foreach model,$(MODELS),$(model)_lines.precursor)
LINES_ALLS = $(foreach model,$(MODELS),$(model)_lines.all)
LINES_DATS = $(foreach model,$(MODELS),$(model)_lines.dat)
DOTS = $(foreach model,$(MODELS),$(model).dot)
BSC_TXTS = $(foreach model,$(MODELS),BSC_$(model).txt)
PLOTS_PDFS = $(foreach model,$(MODELS),$(model)_plots.pdf)

# General makefile syntax is:
# products : dependencies

# Main targets
.PHONY: all clean

all: AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt BSC-AD_ACCEL-$(OPTICS).txt $(DOTS) $(PLOTS_PDFS)

# surveyDataTao.py
value_data.json $(SURVEY_TAPES) $(LINES_PRECURSORS) &: unified_keys.dat
	python $(SCRIPT_DIR)/surveyDataTao.py

# twissDataTao.py
$(TWISS_DATS) &: unified_keys.dat
	python $(SCRIPT_DIR)/twissDataTao.py

# elementdevices_bmad.py
elementdevices.dat elementdevices_cavities_cuH.dat elementdevices_cavities_cuS.dat \
elementdevices_sbends_cuH.dat elementdevices_sbends_cuS.dat &: cu_hxr_survey.tape cu_sxr_survey.tape
	python $(SCRIPT_DIR)/elementdevices_bmad.py

# prepare_upload.py
ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt &: value_data.json $(SURVEY_TAPES)
	python $(SCRIPT_DIR)/prepare_upload_bmad.py

# plotsTao.py
$(PLOTS_PDFS) &:
	python $(SCRIPT_DIR)/plotsTao.py

# bsc.py
BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS) &: ips.dump $(TWISS_DATS)
	python $(SCRIPT_DIR)/bsc.py

# make_lines.py
$(LINES_ALLS) $(LINES_DATS) &: elementdevices.dat \
elementdevices_cavities_cuH.dat elementdevices_cavities_cuS.dat elementdevices_sbends_cuH.dat elementdevices_sbends_cuS.dat
	python $(SCRIPT_DIR)/make_lines.py

# make_dot.py
$(DOTS) &: $(LINES_ALLS)
	python $(SCRIPT_DIR)/make_dot.py

# # Clean target
# clean:
# 	rm -f value_data.json $(SURVEY_TAPES) $(TWISS_DATS)
# 	rm -f elementdevices.dat elementdevices_cavities_*.dat elementdevices_sbends_*.dat
# 	rm -f ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt
# 	rm -f $(PLOTS_PDFS)
# 	rm -f BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS)
# 	rm -f $(LINES_PRECURSORS) $(LINES_ALLS) $(LINES_DATS)
# 	rm -f $(DOTS)
