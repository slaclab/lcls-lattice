#!/bin/env python3

import os
import oracledb
from pathlib import Path
from datetime import datetime
import shutil
import subprocess

SQL1="""
     select unique element, epics_device_name, linacz_m from V_lcls_elements_report_public 
     where 
     (ELEMENT_TYPE='MAD' OR FIRST_SOURCED_FROM != 'CABLES') 
     AND ACTIVE_FLAG='A' 
     AND BEAMLINE_ID IN (11)
     order by (linacz_m)
     """

def get_db_pwd():
    res = subprocess.run(["bash","-lc","ssh mcclogin ssh -Kl physics lcls-srv01 getPwd LCLS_INFRASTRUCTURE"],
            capture_output = True, text=True, check=True)
    return res.stdout.rstrip("\n")

def get_sql2(eleids):
    eleids_str = ",".join(f"'{x[:-1]}'" for x in eleids)
    return f"""
            select element, epics_device_name from V_lcls_elements_report_public 
            where 
            (ELEMENT_TYPE='MAD' OR FIRST_SOURCED_FROM != 'CABLES') 
            AND ACTIVE_FLAG='A' 
            AND BEAMLINE_ID IN (11)
            AND element in ({eleids_str})
            """

# Open database connection
conn = oracledb.connect(
    user = "LCLS_INFRASTRUCTURE",
    dsn = "slacprod:1521/slacprod",
    password = get_db_pwd(),
)

# test database connectivity
#cur.execute("select sysdate from dual")
#print("Connected. DB time:", cur.fetchone()[0])

# Backup elementdevices.dat file if it exists
src = Path('elementdevices.dat')
if src.is_file():
    ts = datetime.now().strftime("%Y%m%dT%H%M%S")
    dst = src.with_name(f"{src.name}-priorto-{ts}.log")
    shutil.copyfile(src, dst)

# Make elementdevices.dat file
with conn.cursor() as cur, open('elementdevices.dat','w') as f:
    cur.execute(SQL1)
    for row in cur:
        epics_device_name = row[1] if "NO EPICS NAME" not in row[1] else '-'
        f.write(f'{row[0]} {epics_device_name}\n')

# Function called later to make the elementdevices_sbends_cuH.dat and _cuS.dat files
def sbend_devices(survey_file, out_file):
    with conn.cursor() as cur, open(survey_file,'r') as fin, open(out_file,'w') as fout:
        eleids=[]
        for line in fin:
            if line.startswith('SBEN'):
                eleids.append(line.split()[0][4:])
        cur.execute(get_sql2(eleids))
        out_lst = []
        for row in cur:
            epics_device_name = row[1] if "NO EPICS NAME" not in row[1] else '-'
            out_lst.append(f'{row[0]} {epics_device_name}')
        out_lst = sorted(set(out_lst))  #replicates sort -u
        for ele in out_lst:
            fout.write(f'{ele}\n')

sbend_devices('LCLS2cuH_survey.tape', 'elementdevices_sbends_cuH.dat')
sbend_devices('LCLS2cuS_survey.tape', 'elementdevices_sbends_cuS.dat')

# Close database connection
conn.close()
