#
# Makefile for making LCLS MAD lattice output files from the MAD deck files. 
#
# This makefile helps make the main lattice output files (*.ps, *.print, 
# *.tape etc) from the input MAD8 decks (LCLS2sc_main.mad8 and LCLS2cu_main.mad8). 
# Additionally, it helps make the "lines" files (eg lcls_lines.dat) 
# used to update the control system of the names of LCLS devices, and 
# it makes the "subway" maps (pdfs of the elements in the lines).
#
# NOTE: by default, if no files have changed, and all files are up to date,
# then executing make will not do anything - since there is nothing to be done!
# To force make to build when no inputs have changed, use make -B <target>.
#
# NOTE2: This makefile should be run by GNU make. On some OS, eg Solaris, use 
# gmake command rather than make.
#
# 
# Usage examples:
# 
#    make                   - ONLY Run MAD8 on LCLS2sc_main.mad8 and LCLS2cu_main.mad8.
#                             This is the default. 
#    make maps              - Make the device lists and maps
#    make all               - Makes all mad output, maps, device lists and icons.
#    make installlatest     - Copies the lattice files output from MAD8, 
#                             to /afs/slac/www/grp/ad/model/output/lcls/mad/latest/
#                             We do this occasionally during development to publish
#                             optics that has NOT yet been released, as well as 
#                             part of the procedure of every release. 
#    make INSTALLDIR=23JAN19 install
#                           - Copies the lattice files output from MAD8, to the
#                             named directory under INSTALLROOT (see defintion
#                             below). In example given, would copy to
#                             /afs/slac/www/grp/ad/model/output/lcls/mad/23JAN19/ 
#    make clean             - Remove all the output files that are in the present 
#                             directory (doesn't touch the install directory) 
#
# Also (rarely used):
#
#    make icons             - Make the icons for the web site
#    make installicons      - Copies web icons to the web site
# 
# Typical development cycle:
#
#    cvs co optics/etc/lattice/lcls/mad
#    cvs co optics/script
#    cd optics/etc/lattice/lcls/mad
#    make                   - just run mad
#    make all               - make all maps, lists, and icon files
#
# To release optics files, example:
#
#    cvs commit -m "my changes" optics/etc/lattice/lcls/mad  
#    cvs rtag v23JAN19 
#    make INSTALLDIR=23JAN19 install
#    make installlatest
#
# Prerequisites:
#
# To use this makefile you'll need a pretty standard unix machine (linux or
# mac) that has the GNU toolset (specifically gmake, gawk), plus dot and rsync. 
# 
# You will also need the MAD8 executable, either as command "mad8" or
# tell make where it is, like this:
#  
#     make MAD8=/afs/slac.stanford.edu/u/ad/mdw/mad8.52/mad 
#
# -------------------------------------------------------------------------
#
# Auth: 03-Apr-2014, Greg White (SLAC)
#       
# Mod:
# 13-Mar-2024, Mark Woodley (SLAC)
#    Use MAD8.53 (includes standing-wave LCAVITY support)
# 20-Aug-2019, Greg White (SLAC)
#    Replace use of temp file elementdevices_lcls2.dat with newly generated
#    elementdevices.dat, which now has all devices in combined SC and CU 
#    machine.
# 24-Apr-2019, Mark Woodley (SLAC)
#    Initial LCLS facility release.
# 21-Jan-2017, Greg White (SLAC)
#    Added support for creating lines files mapping elements and devices in
#    each area of machine. Also simplified and made beampaths explicit.
# 12-Dec-2014, Mark Woodley (SLAC)
#    Use *.mad8 in staging list
# 03-Nov-2014, Greg White, Mark Woodley (SLAC)
#    Make compatible with Solaris; use explicit frame selection in convert 
#    command instead of mv and rm, and awk -> gawk
# 27-Aug-2014, Greg White (SLAC)
#    Delete obsolete files from latest/ install directory and added staging
# 12-Apr-2014, Mark Woodley (SLAC)
#    Updates for 07AUG14 release
# 10-Apr-2014, Greg White (SLAC)
#    Many updates for supporting LCLS2 and making install easier
#
# =========================================================================


# MACROS

AWK=awk
UNAME := $(shell uname)


# Where do we install the mad outputs, all associated files.

INSTALLROOT=/sdf/data/ad/public_html/model/output/lcls/mad
#INSTALLROOT=/sdf/group/ad/sw/scm/repos/optics/lcls-lattice/mad/TESTTESTTEST
#INSTALLROOT=.

# The location of the file defining the association between
# MAD element names and control system device names, as used
# in the maps and lines files.
ELEMENTDEVICES:=elementdevices.dat \
                elementdevices_cavities_cuH.dat \
                elementdevices_cavities_cuS.dat \
                elementdevices_sbends_cuH.dat \
                elementdevices_sbends_cuS.dat

WEB:=.htaccess 

# TARGETS

# sc (superconducting) beampaths:
#   SC_SXR   = GUNB - L0B - superconducting linac - Bypass line - LTUS - SXR
#   SC_HXR   = GUNB - L0B - superconducting linac - Bypass line - LTUH - HXR 
#   SC_BSYD  = GUNB - L0B - superconducting linac - Bypass line - BSY dump line
#   SC_DIAG0 = GUNB - end of diagnostics line
#   SC_DASEL = GUNB - L0B - superconducting linac - Bypass line - DASEL 

# cu (warm copper linac) beampaths:
#   CU_HXR   = GUN - copper linac - LTUH - HXR 
#   CU_SXR   = GUN - copper linac - LTUS - SXR


sc : sc_bsyd_beam0  sc_dasel_beam0  sc_diag0_beam0  sc_hxr_beam0  sc_sxr_beam0
cu : cu_hxr  cu_sxr

sc_bsyd_beam0: sc_bsyd_beam0_plots.pdf
sc_dasel_beam0: sc_dasel_beam0_plots.pdf
sc_diag0_beam0: sc_diag0_beam0_plots.pdf
sc_hxr_beam0: sc_hxr_beam0_plots.pdf
sc_sxr_beam0: sc_sxr_beam0_plots.pdf

cu_hxr: cu_hxr_plots.pdf
cu_sxr: cu_sxr_plots.pdf


# Special target to make everything - all MAD8 output, control system support
# and web related things.
all : lattice lines dots maps mapicons opticspdfs opticsicons

lines : $(LINES)              # Files mapping elements and devices to areas 
dots : $(DOTS)                # Beampath maps in Dot language
maps : $(MAPS)                # Beampath maps in PDF 
mapicons : $(MAPICONS)        # Small .png files of beampath maps for web page
opticspdfs : $(OPTICSPDFS)    # PDFs of twiss optics equiv to Postscript from MAD
opticsicons : $(OPTICSICONS)  # Small .png files of optics topsheets for web page

FORCE :
	clean
	make all

#
# RULES
#

sc cu:
	../python/scripts/oracle_upload/plotsTao.py


# To make a PDF from a .dot file, use dot -T facility
%_map.pdf : %.dot
	dot -Tpdf $< -o $@


# Beam line device lists and maps.

# Create the line .dot and .dat files. Dot files describe graphically the beam's traversal
# through each LCLS area in the dot language. The dat files are equivalent but textually list
# each element that is also a control system device with its device and element name.
# The _lines.dat files are consumed by the control system directory service so it knows
# what device matches what element and vice-versa. NOTE 1: if no devices have been yet defined
# for a beampath (as may be the case during machine construction), the lines.dat file for
# that beampath will not be emitted (since it would be 0-length). NOTE 2: The order of
# input files to the awk script is important, it is: survey.tape, elementdevices, print.

#%_lines.dat %.dot : %_survey.tape $(ELEMENTDEVICES) %.print
#	gawk -v width=38 -v height=4  -f mad2dot.awk $+ > $*.dot
%_lines.dat %.dot : %_survey.tape $(ELEMENTDEVICES) %.print
	gawk  -f mad2dot.awk $+ > $*.dot

# DIAG0 line: Defined explicitly because scaling is different (height).
DIAG0_lines.dat DIAG0.dot : DIAG0_survey.tape $(ELEMENTDEVICES) DIAG0.print 
	gawk -v width=20 -v height=10 -f mad2dot.awk $+ > DIAG0.dot



# Icon files for maps on web site (rarely updated).
# Do them individually so can scale differently depending on beamline size.
#
# 300 = -scale '20x0.5%"

# Orgininal scaling 800.
LCLS2scS_mapicon.png : LCLS2scS_map.pdf
	convert -scale '12x0.5%' $? $@ 
LCLS2scH_mapicon.png : LCLS2scH_map.pdf
	convert -scale '12x0.5%' $? $@ 
LCLS2scD_mapicon.png : LCLS2scD_map.pdf
	convert -scale '3x1%' $? $@ 
LCLS2scDA_mapicon.png : LCLS2scDA_map.pdf
	convert -scale '3x1%' $? $@ 
DIAG0_mapicon.png : DIAG0_map.pdf
	convert -scale '1x1%' $? $@ 
LCLS2cuH_mapicon.png : LCLS2cuH_map.pdf
	convert -scale '12x0.5%' $? $@ 
LCLS2cuS_mapicon.png : LCLS2cuS_map.pdf
	convert -scale '12x0.5%' $? $@ 

# Optics plot icons for web page
#
# Create these eight optics plot icons by hand because conversion to png creates one
# file per plot, and the ps files have many, but we only want the most interesting one.
LCLS2sc_color_opticsicon.png : LCLS2sc_color.ps
	convert -rotate 90 -scale 200x140 'LCLS2sc_color.ps[0]' $@
LCLS2scS_opticsicon.png : LCLS2scS.ps
	convert -rotate 90 -scale 200x140 'LCLS2scS.ps[1]' $@
LCLS2scH_opticsicon.png : LCLS2scH.ps
	convert -rotate 90 -scale 200x140 'LCLS2scH.ps[1]' $@
LCLS2scD_opticsicon.png : LCLS2scD.ps
	convert -rotate 90 -scale 200x140 'LCLS2scD.ps[1]' $@
LCLS2scDA_opticsicon.png : LCLS2scDA.ps
	convert -rotate 90 -scale 200x140 'LCLS2scDA.ps[1]' $@
DIAG0_opticsicon.png : DIAG0.ps
	convert -rotate 90 -scale 200x140 'DIAG0.ps[0]' $@
LCLS2cu_color_opticsicon.png : LCLS2cu_color.ps
	convert -rotate 90 -scale 200x140 'LCLS2cu_color.ps[0]' $@
LCLS2cuH_opticsicon.png : LCLS2cuH.ps
	convert -rotate 90 -scale 200x140 'LCLS2cuH.ps[1]' $@
LCLS2cuS_opticsicon.png : LCLS2cuS.ps
	convert -rotate 90 -scale 200x140 'LCLS2cuS.ps[1]' $@



# Prepare the files to install in a local staging directory. 
#
# Do this for two reasons; first we can check what will be synced; second, 
# this way we can use --delete on the production rsync to remove files on 
# the server that are no longer wanted, which is only possible if one syncs 
# whole directories as opposed to lists of files.
#
stage : all
	mkdir -p .installstage
	rsync -az $(MODELLATS) $(OPTICSPDFS) $(WEB) .installstage
	rsync -az $(OPTS) $(WEB) $(ELEMENTDEVICES) .installstage/opt
	rsync -az *.mad8 *.xsif .installstage/src

# Install output lattice files, beam path device lists and maps in common area
#
install : stage
	rsync -azv .installstage/ $(INSTALLROOT)/$(INSTALLDIR)

# Install latest
#
installlatest : stage 
	rsync -e ssh -r --delete -v .installstage/ $(INSTALLROOT)/latest/


# Clean is a convenience target to delete all output files.
#
clean :
	rm -f $(MODELLATS) *.pdf *.png *.dot print
	rm -fr .installstage
