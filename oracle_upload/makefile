
PYTHON ?= python3
.DEFAULT_GOAL := all


ifeq ($(filter grouped-target,$(.FEATURES)),)
$(error GNU Make 4.3+ required)
endif

ifndef LCLS_LATTICE
$(error LCLS_LATTICE is not set. Please set it before running make)
endif

LCLS_LATTICE_PROD := /sdf/group/ad/sw/scm/repos/optics/lcls-lattice/
ifneq ($(abspath $(LCLS_LATTICE)),$(abspath $(LCLS_LATTICE_PROD)))
$(warning LCLS_LATTICE is '$(LCLS_LATTICE)', prod is '$(LCLS_LATTICE_PROD)')
$(info Enter to continue or press Ctrl-C to abort)
$(shell read ans </dev/tty)
endif

SCRIPT_DIR = $(LCLS_LATTICE)/python/scripts/oracle_upload
INSTALLROOT = /sdf/data/ad/public_html/model/output/lcls
LINESLOCATION = /sdf/data/ad/accel/prod/lcls/


# MODELS
MODELS = sc_sxr sc_hxr sc_bsyd sc_dasel sc_diag0 sc_diag02 sc_diagis cu_sxr cu_hxr sc_sxr2 sc_hxr2 sc_bsyd2 sc_dasel2 
BEAM0_MODELS = sc_sxr_beam0 sc_hxr_beam0 sc_bsyd_beam0 sc_dasel_beam0 sc_diag0_beam0
BSY_MODELS = cu_hxr_bsy cu_sfth_bsy cu_sxr_bsy sc_bsyd_bsy sc_dasel_bsy sc_hxr_bsy sc_sfts_bsy sc_sxr_bsy

SURVEY_MODELS = $(MODELS) $(BEAM0_MODELS) $(BSY_MODELS)
TWISS_MODELS  = $(MODELS) $(BEAM0_MODELS)
PLOT_MODELS   = $(MODELS) $(BEAM0_MODELS)
DOT_MODELS   = $(MODELS)
LINES_MODELS   = $(MODELS)

#TWISS_MODELS = sc_sxr sc_hxr sc_bsyd sc_dasel sc_diag0 cu_sxr cu_hxr sc_sxr2 sc_hxr2 sc_bsyd2 sc_dasel2 sc_diag02 sc_diagis
#TWISS_MODELS = sc_sxr_beam0 sc_hxr_beam0 sc_bsyd_beam0 sc_dasel_beam0 sc_diag0_beam0 cu_sxr cu_hxr
OPTICS ?= 11NOV2026s

# Expand model-specific files
PLOTS_PDFS = $(foreach model,$(PLOT_MODELS),$(model)_plots.pdf)
SURVEY_TAPES = $(foreach model,$(SURVEY_MODELS),$(model)_survey.tape)
TWISS_DATS = $(foreach model,$(TWISS_MODELS),$(model)_twiss.dat)
PRINT_FILES = $(foreach model,$(TWISS_MODELS),$(model).print)
LINES_PRECURSORS = $(foreach model,$(LINES_MODELS),$(model)_lines.precursor)
LINES_ALLS = $(foreach model,$(LINES_MODELS),$(model)_lines.all)
LINES_DATS = $(foreach model,$(LINES_MODELS),$(model)_lines.dat)
BSC_TXTS = $(foreach model,$(TWISS_MODELS),BSC_$(model).txt)
DOTS = $(foreach model,$(DOT_MODELS),$(model).dot)
DOTS_PDFS := $(DOTS:.dot=_map.pdf)
MAPICON_PNGS = $(foreach model,$(DOT_MODELS),$(model)_mapicon.png)
OPTICSICONS = $(foreach m,$(filter-out %_beam0,$(PLOT_MODELS)),$(m)_opticsicon.png)

ELEMENTDEVICES:= elementdevices.dat \
                 elementdevices_cavities_cuH.dat \
                 elementdevices_cavities_cuS.dat \
                 elementdevices_sbends_cuH.dat \
                 elementdevices_sbends_cuS.dat 

# General makefile syntax is:
# products : dependencies

# Main targets
.PHONY: all docs opticsicons AD_ACCEL lines oracle_upload stage install_docs install_lines clean

opticsicons: $(OPTICSICONS)

AD_ACCEL: AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt

all: AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt BSC-AD_ACCEL-$(OPTICS).txt $(DOTS) $(PLOTS_PDFS) $(DOTS_PDFS) $(MAPICON_PNGS) opticsicons

lines: $(LINES_ALLS) $(LINES_DATS)

# surveyDataTao.py
value_data.json $(SURVEY_TAPES) $(LINES_PRECURSORS) &: unified_keys.dat $(SCRIPT_DIR)/surveyDataTao.py
	$(PYTHON) $(SCRIPT_DIR)/surveyDataTao.py

# twissDataTao.py
$(TWISS_DATS) $(PRINT_FILES) &: unified_keys.dat $(SCRIPT_DIR)/twissDataTao_par.py
	$(PYTHON) $(SCRIPT_DIR)/twissDataTao_par.py

# elementdevices_bmad.py
$(ELEMENTDEVICES) &: cu_hxr_survey.tape cu_sxr_survey.tape $(SCRIPT_DIR)/elementdevices_bmad.py
	$(PYTHON) $(SCRIPT_DIR)/elementdevices_bmad.py

# prepare_upload_bmad.py
ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt &: value_data.json $(SURVEY_TAPES) $(SCRIPT_DIR)/prepare_upload_bmad.py
	$(PYTHON) $(SCRIPT_DIR)/prepare_upload_bmad.py $(OPTICS)

# bsc.py
BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS) &: ips.dump $(TWISS_DATS)
	@true
#	$(PYTHON) $(SCRIPT_DIR)/bsc.py $(OPTICS)

# plotsTao.py
$(PLOTS_PDFS) &: $(SCRIPT_DIR)/plotsTao_par.py
	$(PYTHON) $(SCRIPT_DIR)/plotsTao_par.py

# make_lines.py
$(LINES_ALLS) $(LINES_DATS) &: $(ELEMENTDEVICES) $(LINES_PRECURSORS) $(SCRIPT_DIR)/make_lines.py
	$(PYTHON) $(SCRIPT_DIR)/make_lines.py

# make_dot.py
$(DOTS) &: $(LINES_ALLS) $(SCRIPT_DIR)/make_dot.py
	$(PYTHON) $(SCRIPT_DIR)/make_dot.py

# To make a PDF from a .dot file, use dot -T facility
%_map.pdf : %.dot
	dot -Tpdf $< -o $@

ICON_PAGE_DEFAULT = 1
ICON_PAGE_sc_diag0 = 0

ICON_SCALE_DEFAULT = 12x0.5%
ICON_SCALE_sc_bsyd = 3x1%
ICON_SCALE_sc_bsyd2 = 3x1%
ICON_SCALE_sc_dasel = 3x1%
ICON_SCALE_sc_dasel2 = 3x1%
ICON_SCALE_sc_diag0 = 1x1%
ICON_SCALE_sc_diag02 = 1x1%

icon_page  = $(or $(ICON_PAGE_$(1)),$(ICON_PAGE_DEFAULT))
icon_scale = $(or $(ICON_SCALE_$(1)),$(ICON_SCALE_DEFAULT))

%_opticsicon.png: %_plots.pdf
	convert -rotate 0 -scale 200x140 '$<[$(call icon_page,$*)]' $@

%_mapicon.png: %_map.pdf
	convert -scale '$(call icon_scale,$*)' +profile "icc" $< $@

WEB:=.htaccess

docs: $(PLOTS_PDFS) $(LINES_ALLS) $(DOTS) $(DOTS_PDFS) $(MAPICON_PNGS) opticsicons

oracle_upload: $(PRINT_FILES) $(TWISS_DATS) $(ELEMENTDEVICES) ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS)

#stage : $(PRINT_FILES) $(TWISS_DATS) $(PLOTS_PDFS) $(SURVEY_TAPES) docs $(ELEMENTDEVICES)
stage :
	mkdir -p installstage/opt installstage/src
	rsync -az $(SURVEY_TAPES) $(PRINT_FILES) $(TWISS_DATS) $(PLOTS_PDFS) $(WEB) installstage
	rsync -az $(DOTS) $(DOTS_PDFS) $(MAPICON_PNGS) $(LINES_DATS) $(WEB) $(ELEMENTDEVICES) installstage/opt
	rsync -az $(OPTICSICONS) installstage/opt
	rsync -az ../mad/*.mad8 ../mad/*.xsif installstage/src

# Install output lattice files, beam path device lists and maps in common area

install_docs :
	rsync -azv installstage/ $(INSTALLROOT)/$(OPTICS)
	ln -sfn $(OPTICS) $(INSTALLROOT)/latest

install_lines : $(LINES_DATS)
	rsync -azv $(LINES_DATS) $(LINESLOCATION)

clean:
	rm -f value_data.json ips.dump $(SURVEY_TAPES) $(TWISS_DATS) $(PRINT_FILES)
	rm -f elementdevices*.dat $(PLOTS_PDFS) $(LINES_PRECURSORS) $(LINES_ALLS) $(LINES_DATS)
	rm -f $(DOTS) *_mapicon.png *_opticsicon.png
	rm -f BSC_*.txt *_survey.tape *_map.pdf





