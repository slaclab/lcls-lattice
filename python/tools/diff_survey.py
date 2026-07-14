#!/bin/env python3

import sys
from parse_survey import parse_survey

file1 = sys.argv[1]
file2 = sys.argv[2]

def is_number(s):
  try:
    float(s)
    return True
  except ValueError:
    return False

tt, K, N, L, P, A, T, E, FDN, coor, S  = parse_survey(file1)

print(len(N))
print(len(set(N)))

bomb

with open(file1,'r') as f1:
  n1 = 0
  for line in f1:
    n1 += 1
with open(file2,'r') as f2:
  n2 = 0
  for line in f2:
    n2 += 1
  
print(f'Lines in file 1: {n1}')
print(f'Lines in file 2: {n2}')

#rel_tol = 5e-8
rel_tol = 1e-6



with open(file1,'r') as f1, open(file2,'r') as f2:
  header1_1 = f1.readline() 
  header1_2 = f1.readline() 
  header2_1 = f2.readline() 
  header2_2 = f2.readline() 
  for i in range(min(n1,n2)):
    line1 = f1.readline().strip().split(',')
    line2 = f2.readline().strip().split(',')
    for j,pair in enumerate(zip(line1,line2)):
      if j in veto_cols:
        continue
      if is_number(pair[0]) and is_number(pair[1]):
        if pair[0] != pair[1]:
          num1 = float(pair[0])
          num2 = float(pair[1])
          abs_diff = num1-num2
          rel_diff = abs(num1-num2)/(abs(num1)+abs(num2))/2.0 
          if rel_diff > rel_tol:
            print(f'fail at {i+3} i={line1[0]}, j={j}: {pair} {rel_diff} {abs_diff}')
            #print(f'    {num1=}   {num2=}')
      else:
        if pair[0].strip() != pair[1].strip():
          print(f'fail at {i+3} i={line1[0]}, j={j}: {pair}')


LEFT AS-IS AFTER EARLY START.  RATHER THAN DIFFING THE SURVEYS, I PLAN TO DO A BETTER JOB DIFFING THE CVS ORACLE UPLOAD FILES
