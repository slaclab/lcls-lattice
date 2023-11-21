1. Obtain updated release from CVS, either by mounting a CVS repo, or checking out CVS locally.
2. Create a local branch of lcls-lattice to stage the update.
  - git co master
  - git co -b DDMMYY_conversion
3. Copy files from CVS into lcls-lattice/mad
  - copy CVS/optics/etc/lattice/lcls/mad/* lcls-lattice/mad
  - copy CVS/optics/etc/lattice/lcls/bmad/* lcls-lattice/mad
  - copy CVS/optics/script/elementdevices.dat lcls-lattice/mad
4. Obtain updated lcls_elements.csv
  - Go to [https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600](https://oraweb.slac.stanford.edu/apex/slacprod/f?p=116:600)
  - Click on Actions and Download
  - Save file to lcls-lattice/bmad/conversion/from_oracle
4. Open a command prompt for jupyter notebook
  - check that $LCLS_LATTICE is set to the location of the DDMMYY_conversion branch of lcls-lattice.
  - check that the Bmad environment is setup
    - i.e. cd to the bmad repo and run `. util/dist_source_me`
  - Start a jupyter notebook session in lcls-lattice directory
5. Within jupyter notebook cd to bmad/conversion and open slac_to_bmad.ipynb
  - Run all cells in slac_to_bmad.ipynb
6. Within jupyter nodebook cd to bmad/conversion/device_mapping and open device_mapping.ipynb
  - Run all cells.
  - This generates the lcls-lattice/bmad/master/*_devicenames.bmad files
7. Rematch sc_* lines.
  - Check Twiss at BEAM0 MARKER in mad files
  - See sc_*/scripts directories.
  - Update $LCLS_LATTICE/bmad/master/gunb/beginning_BEGGUNB.bmad
  - scripts/match_COL1.tao
  - scripts/match_EMIT2.tao
  - Adjustments should be necessary at QE201-4, Q0H01-8, and QHD01-4.
  - Also QC001-12,QCM02-3

