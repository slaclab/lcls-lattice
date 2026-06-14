
% *** OPTICS=AD_ACCEL-preRelease ***

% standing wave model; reduced L2 W in Cu linac

% NOTE: when making Matlab models (LCLS2sc and LCLS2cu)
% - uncomment SUBROUTINES in LCLS2cu_main.mad8 and LCLS2sc_main.mad8
% - remove "working stuff" from LCLS2cu_main.mad8 and LCLS2sc_main.mad8
% - use special definition of UMXLh in LTU.xsif
% - change mirrors from MULT to INST in SXTES.xsif and HXTES.xsif
% - check that L1.xsif (etc) is being CALLed, not L1e.xsif (etc)

MADrelease='preRelease';
fileDir='\\wsl.localhost\Ubuntu\home\mdw\git_repos\lcls-lattice\mad';

fprintf('Create model_beamLineLCLS2sc.m ...\n\n')
file='LCLS2sc_main.mad8';
nOut='LCLS2sc';
[lines,out]=model_parseMAD(MADrelease,fileDir,file,nOut);
% blList
% - SC_DIAG0,SC_HXR,SC_SXR,SC_BSYD,SC_DASEL (start at CATHODEB)
% - SC_DIAG0I,SC_HXRI,SC_SXRI,SC_BSYDI,SC_DASELI (start at BEAM0)
% - SC_DIAGIS,SC_DIAG02,SC_HXR2,SC_SXR2,SC_BSYD2,SC_DASEL2 (start at CATHODELEI)
% - SC_DIAGISI,SC_DIAG02I,SC_HXR2I,SC_SXR2I,SC_BSYD2I,SC_DASEL2I (start at BEAM0LEI)

fprintf('\nCreate model_beamLineLCLS2cu.m ...\n\n')
file='LCLS2cu_main.mad8';
nOut='LCLS2cu';
[lines,out]=model_parseMAD(MADrelease,fileDir,file,nOut);
% blList
% - CU_GSPEC,CU_SPEC,CU_SXR,CU_HXR (start at CATHODE)
% - CU_SPECI,CU_SXRI,CU_HXRI (start at WS02)
fprintf('\n')
