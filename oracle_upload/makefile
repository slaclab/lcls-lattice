
ifndef LCLS_LATTICE
$(error LCLS_LATTICE is not set. Please set it before running make)
endif

SCRIPT_DIR = $(LCLS_LATTICE)/python/scripts/oracle_upload
INSTALLROOT=/sdf/data/ad/public_html/model/output/lcls

# Variables
SURVEY_MODELS = sc_sxr sc_hxr sc_bsyd sc_dasel sc_diag0 sc_diag02 sc_diagis cu_sxr cu_hxr
BSY_SURVEY_MODELS = cu_hxr_bsy  cu_sfth_bsy  cu_sxr_bsy  sc_bsyd_bsy  sc_dasel_bsy  sc_hxr_bsy  sc_sfts_bsy  sc_sxr_bsy
TWISS_MODELS = sc_sxr_beam0 sc_hxr_beam0 sc_bsyd_beam0 sc_dasel_beam0 sc_diag0_beam0 cu_sxr cu_hxr
OPTICS = 04MAY2026s

# Expand model-specific files
SURVEY_TAPES = $(foreach model,$(SURVEY_MODELS) $(BSY_SURVEY_MODELS),$(model)_survey.tape)
TWISS_DATS = $(foreach model,$(TWISS_MODELS),$(model)_twiss.dat)
LINES_PRECURSORS = $(foreach model,$(SURVEY_MODELS),$(model)_lines.precursor)
LINES_ALLS = $(foreach model,$(SURVEY_MODELS),$(model)_lines.all)
LINES_DATS = $(foreach model,$(SURVEY_MODELS),$(model)_lines.dat)
BSC_TXTS = $(foreach model,$(TWISS_MODELS),BSC_$(model).txt)
PLOTS_PDFS = $(foreach model,$(TWISS_MODELS),$(model)_plots.pdf)
DOTS = $(foreach model,$(SURVEY_MODELS),$(model).dot)
DOTS_PDFS := $(DOTS:.dot=_map.pdf)
MAPICON_PNGS = $(foreach model,$(SURVEY_MODELS),$(model)_mapicon.png)

ELEMENTDEVICES:= elementdevices.dat \
                 elementdevices_cavities_cuH.dat \
								 elementdevices_cavities_cuS.dat \
                 elementdevices_sbends_cuH.dat \
								 elementdevices_sbends_cuS.dat 

# General makefile syntax is:
# products : dependencies

# Main targets
.PHONY: all clean docs opticsicons

all: AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt BSC-AD_ACCEL-$(OPTICS).txt $(DOTS) $(PLOTS_PDFS) $(DOTS_PDFS) $(MAPICON_PNGS)

# surveyDataTao.py
value_data.json $(SURVEY_TAPES) $(LINES_PRECURSORS) &: unified_keys.dat
	python $(SCRIPT_DIR)/surveyDataTao.py

# twissDataTao.py
$(TWISS_DATS) &: unified_keys.dat
	python $(SCRIPT_DIR)/twissDataTao.py

# elementdevices_bmad.py
$(ELEMENTDEVICES) &: cu_hxr_survey.tape cu_sxr_survey.tape
	python $(SCRIPT_DIR)/elementdevices_bmad.py

# prepare_upload.py
ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt &: value_data.json $(SURVEY_TAPES)
	python $(SCRIPT_DIR)/prepare_upload_bmad.py $(OPTICS)

# bsc.py
BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS) &: ips.dump $(TWISS_DATS)
	python $(SCRIPT_DIR)/bsc.py $(OPTICS)

oracle_upload: 

# plotsTao.py
$(PLOTS_PDFS) &:
	python $(SCRIPT_DIR)/plotsTao.py

# make_lines.py
$(LINES_ALLS) $(LINES_DATS) &: $(ELEMENTDEVICES)
	python $(SCRIPT_DIR)/make_lines.py

# make_dot.py
$(DOTS) &: $(LINES_ALLS)
	python $(SCRIPT_DIR)/make_dot.py

# To make a PDF from a .dot file, use dot -T facility
%_map.pdf : %.dot
	dot -Tpdf $< -o $@

# Optics plot icons for web page
#
# Create these eight optics plot icons by hand because conversion to png creates one
# file per plot, and the ps files have many, but we only want the most interesting one.
opticsicons: sc_sxr_opticsicon.png sc_hxr_opticsicon.png sc_bsyd_opticsicon.png sc_dasel_opticsicon.png sc_diag0_opticsicon.png cu_hxr_opticsicon.png cu_sxr_opticsicon.png

sc_sxr_opticsicon.png : sc_sxr_beam0_plots.pdf
	convert -rotate 0 -scale 200x140 'sc_sxr_beam0_plots.pdf[1]' $@
sc_hxr_opticsicon.png : sc_hxr_beam0_plots.pdf
	convert -rotate 0 -scale 200x140 'sc_hxr_beam0_plots.pdf[1]' $@
sc_bsyd_opticsicon.png : sc_bsyd_beam0_plots.pdf
	convert -rotate 0 -scale 200x140 'sc_bsyd_beam0_plots.pdf[1]' $@
sc_dasel_opticsicon.png : sc_dasel_beam0_plots.pdf
	convert -rotate 0 -scale 200x140 'sc_dasel_beam0_plots.pdf[1]' $@
sc_diag0_opticsicon.png : sc_diag0_beam0_plots.pdf
	convert -rotate 0 -scale 200x140 'sc_diag0_beam0_plots.pdf[0]' $@
cu_hxr_opticsicon.png : cu_hxr_plots.pdf
	convert -rotate 0 -scale 200x140 'cu_hxr_plots.pdf[1]' $@
cu_sxr_opticsicon.png : cu_sxr_plots.pdf
	convert -rotate 0 -scale 200x140 'cu_sxr_plots.pdf[1]' $@

# Icon files for maps on web site (rarely updated).
# Do them individually so can scale differently depending on beamline size.
#
# 300 = -scale '20x0.5%"
# Orgininal scaling 800.
sc_sxr_mapicon.png : sc_sxr_map.pdf
	convert -scale '12x0.5%' +profile "icc" $? $@ 
sc_hxr_mapicon.png : sc_hxr_map.pdf
	convert -scale '12x0.5%' +profile "icc" $? $@ 
sc_bsyd_mapicon.png : sc_bsyd_map.pdf
	convert -scale '3x1%' +profile "icc" $? $@ 
sc_dasel_mapicon.png : sc_dasel_map.pdf
	convert -scale '3x1%' +profile "icc" $? $@ 
sc_diag0_mapicon.png : sc_diag0_map.pdf
	convert -scale '1x1%' +profile "icc" $? $@ 
cu_hxr_mapicon.png : cu_hxr_map.pdf
	convert -scale '12x0.5%' +profile "icc" $? $@ 
cu_sxr_mapicon.png : cu_sxr_map.pdf
	convert -scale '12x0.5%' +profile "icc" $? $@ 

# # Clean target
# clean:
# 	rm -f value_data.json $(SURVEY_TAPES) $(TWISS_DATS)
# 	rm -f elementdevices.dat elementdevices_cavities_*.dat elementdevices_sbends_*.dat
# 	rm -f ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt
# 	rm -f $(PLOTS_PDFS)
# 	rm -f BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS)
# 	rm -f $(LINES_PRECURSORS) $(LINES_ALLS) $(LINES_DATS)
# 	rm -f $(DOTS)
#
# Prepare the files to install in a local staging directory. 
#
# Do this for two reasons; first we can check what will be synced; second, 
# this way we can use --delete on the production rsync to remove files on 
# the server that are no longer wanted, which is only possible if one syncs 
# whole directories as opposed to lists of files.

WEB:=.htaccess

docs: $(PLOTS_PDFS) $(LINES_ALLS) $(DOTS) $(DOTS_PDFS) $(MAPICON_PNGS) opticsicons oracle_upload

oracle_upload: $(TWISS_DATS) $(ELEMENTDEVICES) ips.dump AD_ACCEL-$(OPTICS).txt BSY-AD_ACCEL-$(OPTICS).txt AD_ACCEL-extra-$(OPTICS).txt BSC-AD_ACCEL-$(OPTICS).txt $(BSC_TXTS)

stage : #all
	mkdir -p installstage
	rsync -az $(SURVEY_TAPES) $(TWISS_DATS) $(PLOTS_PDFS) $(WEB) installstage
	rsync -az $(DOTS) $(DOTS_PDFS) $(MAPICON_PNGS) $(LINES_DATS) $(WEB) $(ELEMENTDEVICES) installstage/opt
	rsync -as *_opticsicon.png installstage/opt
	rsync -az ../mad/*.mad8 ../mad/*.xsif installstage/src

# Install output lattice files, beam path device lists and maps in common area

install : stage
	rsync -azv installstage/ $(INSTALLROOT)/$(OPTICS)
	rm $(INSTALLROOT)/latest
	ln -s $(OPTICS) $(INSTALLROOT)/latest

mostlyclean:
	rm -f value_data.json ips.dump $(SURVEY_TAPES) $(TWISS_DATS)
	rm -f elementdevices*.dat $(PLOTS_PDFS) $(LINES_PRECURSORS) $(LINES_ALLS) $(LINES_DATS)
	rm -f $(DOTS) *_mapicon.png *_opticsicon.png
	rm -f BSC_*.txt *_survey.tape *_map.pdf





