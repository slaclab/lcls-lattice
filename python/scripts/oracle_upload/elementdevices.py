#!/bin/env python3

import os
import oracledb
from pathlib import Path
from datetime import datetime
import shutil
import subprocess
import re

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

# Query element names and device names from database
elements = []
device_names = []
with conn.cursor() as cur:
    cur.execute(SQL1)
    for row in cur:
        if row[0] not in elements:
            elements.append(row[0])
        device_names.append(row[1] if "NO EPICS NAME" not in row[1] else '-')
db_result = list(zip(elements,device_names))

# Close database connection
conn.close()

#-----------------------------
# Make elementdevices.dat file
#-----------------------------
with open('elementdevices.dat','w') as f:
    for row in db_result:
        f.write(f'{row[0]} {row[1]}\n')

#-----------------------------
# Make cavities elementdevices
#-----------------------------
pat = re.compile(r'^LCAVK[0-2][0-9]_')  # start, LCAVK, 00–29, underscore
def cav_devices(survey_file, out_file):
    with open(survey_file,'r') as fin, open(out_file,'w') as fout:
        for row in fin:
            if not row.strip():
                continue
            word = row.split()[0]
            if word.startswith('LCAVL0A'):
                fout.write(f'{word[4:]} ACCL:IN20:300\n')
            elif word.startswith('LCAVL0B'):
                fout.write(f'{word[4:]} ACCL:IN20:400\n')
            elif word.startswith('LCAVL1X'):
                fout.write(f'{word[4:]} KLYS:LI21:180\n')
            elif word.startswith('LCAVK21_1'):
                fout.write(f'{word[4:]} ACCL:LI21:1\n')
            elif pat.match(word):
                fout.write(f'{word[4:]} KLYS:LI{word[5:7]}:{word[8:9]}1\n')

cav_devices('LCLS2cuH_survey.tape', 'elementdevices_cavities_cuH.dat')
cav_devices('LCLS2cuS_survey.tape', 'elementdevices_cavities_cuS.dat')

#--------------------------
# Make sbend elementdevices
#--------------------------
db_result.sort(key=lambda x: x[0])

def sbend_devices(survey_file, out_file):
    with open(survey_file,'r') as fin, open(out_file,'w') as fout:
        eleids=[]
        for line in fin:
            if line.startswith('SBEN'):
                eleids.append(line.split()[0][4:-1])
        eleids.sort(key=lambda x: x[0])
        for row in db_result:
            if row[0] in eleids:
                fout.write(f'{row[0]} {row[1]}\n')

sbend_devices('LCLS2cuH_survey.tape', 'elementdevices_sbends_cuH.dat')
sbend_devices('LCLS2cuS_survey.tape', 'elementdevices_sbends_cuS.dat')

