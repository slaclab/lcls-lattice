1. Once Mark Woodley has uploaded the pre-release to github lcls-lattice repo, checkout that release.
2. Obtain updated lcls_elements.csv
  - Go to [https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600](https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600)
  - Click on Actions and Download
  - Save file to lcls-lattice/bmad/conversion/from_oracle
3. Setup terminal environment for jupyter notebook
  - check that $LCLS_LATTICE is set to the location of the DDMMYY_conversion branch of lcls-lattice.
  - check that the Bmad environment is setup (consider whether the lcls-live bmad / tao is better)
    - i.e. cd to the bmad repo and run `. util/dist_source_me`
4. Start a jupyter notebook session in lcls-lattice directory
6. Within jupyter notebook cd to bmad/conversion and open slac_to_bmad.ipynb
  - Check hard-coded paths in slac_to_bmad.ipynb match lcls-lattice repo with conversion branch.
  - Run all cells in slac_to_bmad.ipynb
7. Correct special cases.
  - Add this line below the bun1b desplit in INJ.bmad
      - bun1b[voltage] = 2*bun1b[voltage]
8. Within jupyter nodebook cd to bmad/conversion/device_mapping and open device_mapping.ipynb
  - Check LCLS_LATTICE environment variable points to conversion branch of lcls-lattice repo.
  - Run all cells.
  - This generates the lcls-lattice/bmad/master/*_devicenames.bmad files
9. Rematch sc_* lines.
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
10. Submit PR to github.
11. Generate new lcls-lattice release.
12. Update `/sdf/group/ad/sw/scm/repos/optics/lcls-lattice` on s3df.

| Bmad line | mad8s Twiss file | Bmad <-> mad8s Places to Check |
|-|-|-|
| sc_diag0 | DIAG0.print | BEAM0, BEGHTR, ENDHTR, OTRDG04, ENDDIAG0 |
| sc_bsyd | LCLS2scD.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMPBSY |
| sc_dasel | LCLS2scDA.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DPR2 |
| sc_hxr | LCLS2scH.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
| sc_sxr | LCLS2scS.print | BEAM0, BEGHTR, ENDL1B, ENDCOL1, ENDL2B, ENDEMIT2, ENDL3B, DDUMP |
