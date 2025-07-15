# Convert mad8 lattices to Bmad

1. Once Mark Woodley has uploaded the pre-release to github lcls-lattice repo, checkout that release.
2. Setup terminal environment
   - check that $LCLS_LATTICE is set to the location of the DDMMYY_conversion branch of lcls-lattice.
   - check that the lcls-lattice-dev conda environment is active, which can be generated from lcls-lattice `environment.yml`
   - cd to the bmad repo and run `. util/dist_source_me`
3. Run $LCLS_LATTICE/bmad/conversion/slac_to_bmad.py
4. Check if beginning twiss in `bmad/master/gunb/beginning_BEGGUNB.bmad` need to be updated from BX0, AX0, etc. in `mad/LCLS2sc_master.xsif`
5. from `$LCLS_LATTICE` run `pytest`

# Update element devices
1. Obtain updated lcls_elements.csv
   - Go to [https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600](https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600)
   - Click on Actions and Download
   - Save file to `lcls-lattice/bmad/conversion/from_oracle`
2. Run `$LCLS_LATTICE/bmad/conversion/device_mapping/device_mapping.py`
   - This generates the `lcls-lattice/bmad/master/*_devicenames.bmad` files

# Check into repo
1. Trigger the Make Optics Plots action for the pre-release branch.
   - This updates the plots in `docs/plots/`.  Check these plots for correctness.
3. Submit PR to github.
4. Generate new lcls-lattice release.
5. Update `/sdf/group/ad/sw/scm/repos/optics/lcls-lattice` on s3df.
6. Update prod using zip of release at `lcls-srv01:/usr/local/lcls/model/lattice`
  - Update the `/usr/local/lcls/model/lattice/current` link to point to the new release.

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
