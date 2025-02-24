Instructions for Oracle Upload.


1. Switch to mad directory.
2. Uncomment the LCLS2sc_makeSymbols.mad8 line from LCLS2sc_main.mad8
3. Uncomment the LCLS2cu_makeSymbols.mad8 line from LCLS2cu_main.mad8
4. run: mad8s < LCLS2cu_main.mad8
5. run: mad8s < LCLS2sc_main.mad8
6. delete oracle_upload folder and its contents (rm -Rf oracle_upload)
7. Edit the header of ../python/scripts/oracle_upload/makeExcel.py with the release name.
8. Execute ~/git_repos/lcls-lattice/python/scripts/oracle_upload/makeExcel.py

The final command will make a directory called `oracle_upload`.

The contents of oracle_upload are:
* `AD_ACCEL-<release name>.txt`
* `AD_ACCEL-<release name>.xls`
* `AD_ACCEL-extra-<release name>.txt`
* `BSY-AD_ACCEL-<release name>.txt`
