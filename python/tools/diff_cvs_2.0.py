#!/bin/env python3

import sys

file1 = sys.argv[1]
file2 = sys.argv[2]

def is_number(s):
  try:
    float(s)
    return True
  except ValueError:
    return False

def parse_cvs(file):
  cvs_dict = {}
  ordered = []
  with open(file,'r') as f:
    header_lst = [x.strip() for x in f.readline().split(',')]
    header = f.readline() 
    for line in f:
      line_lst = line.strip().split(',')
      key = line_lst[3]
      if key in cvs_dict:
        sys.exit('key collision detected')
      if key == 'ELEMENT':
        break
      ordered.append(key)
      cvs_dict[key] = line_lst
  return ordered, header_lst, cvs_dict

ordered, header_lst, data1 = parse_cvs(file1)
dumb, dumb, data2 = parse_cvs(file2)
  
print(f'Lines in file 1: {len(data1)}')
print(f'Lines in file 2: {len(data2)}')

print("In file 1, but not in file 2:")
got_one = False
for key in data1.keys() - data2.keys():
  got_one = True
  print(key) 
if not got_one:
  print("   None!")

print("In file 2, but not in file 1:")
got_one = False
for key in data2.keys() - data1.keys():
  got_one = True
  print(key) 
if not got_one:
  print("   None!")
  
ordered_filtered = []
for key in ordered:
  if key in data1.keys() & data2.keys():
    ordered_filtered.append(key)

#rel_tol = 5e-8
rel_tol = [1e-6 for _ in header_lst]
rel_tol[15] = 5e-5

veto_cols=[0,48,49,] #[6,50,]  #columns are zero-indexed

ignore_matching_quads=['QA01', 'QA02', 'QE01', 'QE02', 'Q0H01', 'Q0H02', 'Q0H03', 'Q0H04', 'QC011', 'QC012', 'QCM02', 'QCM03']

print("Comparing common elements:")
for key in ordered_filtered:
  data1_ = data1[key]
  data2_ = data2[key]
  for j,pair in enumerate(zip(data1_,data2_)):
    if key in ignore_matching_quads and j in [8,32,33]:
      continue
    if j in veto_cols:
      continue
    if is_number(pair[0]) and is_number(pair[1]):
      if pair[0] != pair[1]:
        num1 = float(pair[0])
        num2 = float(pair[1])
        abs_diff = num1-num2
        rel_diff = abs(num1-num2)/(abs(num1)+abs(num2))/2.0 
        if rel_diff > rel_tol[j]:
          print(f'fail for {key}, j={j} ({header_lst[j]}): {pair} rel: {rel_diff} abs: {abs_diff}')
    else:
      if pair[0].strip() != pair[1].strip():
        print(f'fail for {key}: j={j} ({header_lst[j]}), {pair}')




