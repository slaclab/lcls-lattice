
% *** OPTICS=AD_ACCEL-preRelease ***

% standing wave model; reduced L2 W in Cu linac

% NOTE: when making Matlab models (LCLS2sc and LCLS2cu)
% - uncomment SUBROUTINES in LCLS2cu_main.mad8 and LCLS2sc_main.mad8
% - use SUBROUTINEs in LCLS2cu_main.mad8 and LCLS2sc_main.mad8
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
% - SC_EIC,SC_DIAG0,SC_HXR,SC_SXR,SC_BSYD,SC_DASEL (start at CATHODEB)
% - SC_DIAG0I,SC_HXRI,SC_SXRI,SC_BSYDI,SC_DASELI (start at BEAM0)

fprintf('\nCreate model_beamLineLCLS2cu.m ...\n\n')
file='LCLS2cu_main.mad8';
nOut='LCLS2cu';
[lines,out]=model_parseMAD(MADrelease,fileDir,file,nOut);
% blList
% - CU_GSPEC,CU_SPEC,CU_SXR,CU_HXR (start at CATHODE)
fprintf('\n')
