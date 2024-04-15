#!/bin/env python3

comments = ['!','*','@','$','#']

def parse_file(file_name):
	data_lines = []
	with open(file_name,'r') as f:
		for line in f:
			if line.lstrip()[0] not in comments:
				data_lines.append(line.split())
	return data_lines

tests_pass = True

# test 1
# Compare beta_x as the end of both the mad and bmad sc_bsyd (cathode to dump) line

eps = 1e-6

bmad_data = parse_file('bmad/models/sc_bsyd/twiss.out')
mad8_data = parse_file('mad/SC_BSYD_GUN_CI.twiss')
	
bmad_beta_x = float(bmad_data[-1][3])
mad8_beta_x = float(mad8_data[-1][2])

test = abs((bmad_beta_x-mad8_beta_x) / (bmad_beta_x+mad8_beta_x) / 2) 
print('Checking beta_y as SC_BSYD end ...')
if (test < eps):
  print('   pass!')
else:
  print('   fail! {}  {}'.format(float(bmad_beta_x), float(mad8_beta_x)))
  tests_pass = False

# test 2
# Compare beta_x as the end of both the mad and bmad sc_hxr (cathode to dump) line

#   under development

if(tests_pass):
  exit(0)
else:
  exit(1)
