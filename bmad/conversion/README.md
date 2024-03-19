1. Obtain updated release from CVS, either by mounting a CVS repo, or checking out CVS locally.
  - `cvs update` from local CVS/optics directory
2. Create a local branch of lcls-lattice to stage the update.
  - git checkout master
  - git checkout -b DDMMYYYY_conversion
3. Copy files from CVS into lcls-lattice/mad (omit mad/CVS, bmad/CVS directory from copy)
  - cp CVS/optics/etc/lattice/lcls/mad/* lcls-lattice/mad
  - cp CVS/optics/etc/lattice/lcls/bmad/* lcls-lattice/mad  #not a typo: CVS bmad goes into lcls-lattice/mad
  - cp CVS/optics/script/elementdevices.dat lcls-lattice/mad
4. Obtain updated lcls_elements.csv
  - Go to [https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600](https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600)
  - Click on Actions and Download
  - Save file to lcls-lattice/bmad/conversion/from_oracle
5. Open a command prompt for jupyter notebook
  - check that $LCLS_LATTICE is set to the location of the DDMMYY_conversion branch of lcls-lattice.
  - check that the Bmad environment is setup (consider whether the lcls-live bmad / tao is better)
    - i.e. cd to the bmad repo and run `. util/dist_source_me`
  - Start a jupyter notebook session in lcls-lattice directory
6. Within jupyter notebook cd to bmad/conversion and open slac_to_bmad.ipynb
  - Check hard-coded paths in slac_to_bmad.ipynb match lcls-lattice repo with conversion branch.
  - Run all cells in slac_to_bmad.ipynb
7. Correct special cases.
  - Add this line below the bun1b desplit in INJ.bmad
      - bun1b[voltage] = 2*bun1b[voltage]
7. Within jupyter nodebook cd to bmad/conversion/device_mapping and open device_mapping.ipynb
  - Check LCLS_LATTICE environment variable points to conversion branch of lcls-lattice repo.
  - Run all cells.
  - This generates the lcls-lattice/bmad/master/*_devicenames.bmad files
8. Rematch sc_* lines.
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
9. Submit PR to github.
10. Generate new lcls-lattice release.

| Bmad line | mad8s Twiss file | Bmad <-> mad8s Places to Check |
|-|-|-|
| sc_diag0 | DIAG0.print | BEAM0, BEGHTR, ENDHTR, OTRDG04, ENDDIAG0 |
| sc_bsyd | LCLS2scD.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMPBSY |
| sc_dasel | LCLS2scDA.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DPR2 |
| sc_hxr | LCLS2scH.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
| sc_sxr | LCLS2scS.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
