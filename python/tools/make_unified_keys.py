#!/bin/env python3

import sys
import glob

upload_file = sys.argv[1]

def parse_survey(file):
  survey_dict = {}
  last_bend = False
  with open(file,'r') as f:
    for i, line in enumerate(f):
      #if last_bend == True:
      #  last_bend = False
      #  continue
      if i < 2:
        continue
      if not line.strip():
        break
      if (i-2) % 4 == 0:
        key = line[0:4]
        name = line[4:20].strip()
        fullname = name
        if key == 'LCAV':
          if name[0:4] in ['CAVL','CAVC']:
            name = name[0:7]
          elif name[0:2] in ['K2','K3']:
            name = name[0:6]
          elif name.startswith(('L0','L1X')):
            name = name[0:6]
          if '___' in name:
            name = name[:-3]
        if key == 'SBEN':
          name = name[:-1]
          #last_bend = True
        survey_dict[fullname] = [name,key]
  return survey_dict

def parse_upload(file):
  cvs_dict = {}
  ordered = []
  with open(file,'r') as f:
    header_lst = [x.strip() for x in f.readline().split(',')]
    header = f.readline() 
    for line in f:
      line_lst = line.strip().split(',')
      name = line_lst[3]
      if name[-1] == '?':
        continue
      if name in cvs_dict:
        sys.exit('name collision detected')
      if name == 'ELEMENT':
        break
      ordered.append(name)
      cvs_dict[name] = line_lst[2]
  return ordered, header_lst, cvs_dict

def parse_fdn(file):
  key_dict = {}
  with open(file,'r') as fkey:
    for line in fkey:
      if line.strip().startswith(("#","!")):
        continue
      if not line.strip():
        continue
      data = line.split()
      name = data[0][:-1]
      fdn = data[1].split('=')
      dbkey = ''
      if len(fdn) > 2:
        dbkey = data[2].replace('"', '').replace("'", '')
      key_dict[name] = dbkey
  return key_dict

survey_data = {}
survey_files = glob.glob("../*_survey.tape")
for survey_file in survey_files:
  x = parse_survey(survey_file)
  survey_data |= x

_, _, upload_data = parse_upload(upload_file)
#Cu_fdn = parse_fdn('Cu_FDN.xsif')
#SC_fdn = parse_fdn('SC_FDN.xsif')
#fdn = Cu_fdn | SC_fdn

# this loop omits the drifts
#with open('unified_keys.dat','w') as f:
#  for name,upload_key in upload_data.items():
#    if survey_data[name] == upload_key:
#      f.write(f'{name} {survey_data[name]}\n')
#    else:
#      f.write(f'{name} {survey_data[name]} {upload_key}\n')

# key off survey to include drifts
with open('unified_keys.dat','w') as f:
  for fullname,v in survey_data.items():
    name = v[0]
    survey_key = v[1]
    if fullname == 'INITIAL':
      continue
    if name in upload_data and upload_data[name] != survey_key:
      f.write(f'{fullname} {survey_key} {upload_data[name]}\n')
    else:
      f.write(f'{fullname} {survey_key}\n')












