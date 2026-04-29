# Convert mad8 lattices to Bmad

1. Once Mark Woodley has uploaded the pre-release to github lcls-lattice repo, checkout that release.
2. Setup terminal environment
   - check that $LCLS_LATTICE is set to the location of the DDMMYY_conversion branch of lcls-lattice.
   - check that the lcls-lattice-dev conda environment is active, which can be generated from lcls-lattice `environment.yml`
   - set MAD8_TO_BMAD to the location of the mad8_to_bmad.py script from the bmad_ecosystem
      - Using dist_source_me is discouraged, as it can cause the wrong libraries to be used by pytao because it results in a mixed conda / bmad repo environment.
3. Run $LCLS_LATTICE/bmad/conversion/slac_to_bmad.py
4. Check if beginning twiss in `bmad/master/gunb/beginning_BEGGUNB.bmad` need to be updated from BX0, AX0, etc. in `mad/LCLS2sc_master.xsif`
5. Rematch SC ENDL1B using sc_sxr/tao.init q_L1[2:5] and L1[1:6].  L1 data updated from ENDL1B in mad/SC_SXR_GUN_CI
6. from `$LCLS_LATTICE` run `pytest`
7. Update plots
   - python/scripts/make_bmad_plots.py
   - mv beta_*.png docs/plots
   - python/scripts/make_mad_plots.py
   - mv beta_*.png docs/plots
   - python/scripts/residuals.py
   - mv residual_*.png docs/plots

# Check into repo
1. Trigger the Make Optics Plots action for the pre-release branch.
   - This updates the plots in `docs/plots/`.  Check these plots for correctness.
3. Submit PR to github.
4. Generate new lcls-lattice release.
5. Update `/sdf/group/ad/sw/scm/repos/optics/lcls-lattice` on s3df.
6. Update prod using zip of release at `lcls-srv01:/usr/local/lcls/model/lattice`
   - Update the `/usr/local/lcls/model/lattice/current` link to point to the new release.

# Make Oracle Upload files
1. In the mad directory, uncomment the call to `makeSymbols` from `LCLS2cu_main.mad8` and `LCLS2sc_main.mad8`.
2. run mad8s, assuming mad8s executable is in the lcls-lattice base directory.
   - `../mad8s < LCLS2sc_main.mad8`
   - `../mad8s < LCLS2cu_main.mad8`
3. Update `optics` variable in the oracle_upload script located at `../python/scripts/oracle_upload/prepare_upload.py`
4. Run `../python/scripts/oracle_upload/prepare_upload.py`, which generates the following files
   - AD_ACCEL-19DEC2025s.txt
   - AD_ACCEL-extra-19DEC2025s.txt
   - BSY-AD_ACCEL-19DEC2025s.txt
5. Manually copy the FACET elements from the previous extras file to the new extras file.
   - Starts with SOL10111 and ends with CQ141866

# Update element devices
To be done after the Oracle database is updated by the database group.
1. Obtain updated lcls_elements.csv
   - Go to [https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600](https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600)
   - Click on Actions and Download
   - Save file to `lcls-lattice/bmad/conversion/from_oracle`
2. Run `$LCLS_LATTICE/bmad/conversion/device_mapping/device_mapping.py`
   - This generates the `lcls-lattice/bmad/master/*_devicenames.bmad` files

# Publish from sdf using makefile
To be done after the Oracle database is updated by the the database group.
1. Log onto sdfiana16
2. `module load conda`
3. `conda activate oracle-conn`
4. `cd /sdf/group/ad/sw/scm/repos/optics/lcls-lattice/mad`
5. execute `../python/scripts/oracle_upload/elementdevices.py`
   - Connects to oracle database to generate element devices files
6. make -f makefile -B INSTALLDIR=22SEP2025s install
   - replace 22SEP2025s with latest release name in DDMMMYYYYs format
   - lattice files and lines files put into `/sdf/data/ad/public_html/model/output/lcls/mad/`
   - Lattice description published here:  https://s3df.slac.stanford.edu/data/ad/model/lcls.html

## Rematch notes.
* Rematching is usually not needed.  A mismatch between mad8 and Bmad usually means something went wrong in the conversion.
  - Run mad8s to get Twiss
    - `mad8s < LCLS2sc_main.mad8`
      - mad8s Twiss are in the .print files.  The table below shows the .print file for each Bmad beamline.
      - Also shown in table below are locations to check that the optics agree.
  - Check Twiss at BEAM0 MARKER in mad files
   - BXi, AXi, BYi, AYi in LCLS2sc_beamd.mad8
  - See sc_*/scripts directories.
  - Update $LCLS_LATTICE/bmad/master/gunb/beginning_BEGGUNB.bmad
  - scripts/match_COL1.tao
  - scripts/match_EMIT2.tao
  - Adjustments should be necessary at QE201-4, Q0H01-8, and QHD01-4.
  - Also QC001-12,QCM02-3

| Bmad line | mad8s Twiss file | Bmad <-> mad8s Places to Check |
|-|-|-|
| sc_diag0 | DIAG0.print | BEAM0, BEGHTR, ENDHTR, OTRDG04, ENDDIAG0 |
| sc_bsyd | LCLS2scD.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMPBSY |
| sc_dasel | LCLS2scDA.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DPR2 |
| sc_hxr | LCLS2scH.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
| sc_sxr | LCLS2scS.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
