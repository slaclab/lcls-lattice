#!/bin/env bash

cd $LCLS_LATTICE/mad
echo "running mad8s"
../mad8s < CI-Testing.mad8
echo "testing if mad8s .twiss was created"
test -f SC_BSYD_GUN_CI.twiss 
cd $LCLS_LATTICE/bmad/models/sc_bsyd
echo "running lc_unit_test_bmad"
../../../lc_unit_test_bmad sc_bsyd.lat.bmad
echo "testing if Bmad twiss.out created"
test -f twiss.out

cd $LCLS_LATTICE
tests/unit_tests.py
