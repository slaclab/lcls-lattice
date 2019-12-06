function beamLine=model_beamLineLCLS2sc()
%
% -----------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-05DEC19 ***
% -----------------------------------------------------------------------------
%
% beamLine=model_beamLineLCLS2sc();
%
% Returns Matlab model beam lines that correspond to defined AD_ACCEL
% beampaths originating in the SC linac:
%
%  beamLine.SC_EIC   = gunB to EIC FARC
%  beamLine.SC_DIAG0 = gunB to DIAG0 FARC
%  beamLine.SC_SXR   = gunB to SXR beam dump
%  beamLine.SC_HXR   = gunB to HXR beam dump
%  beamLine.SC_BSYD  = gunB to BSY beam dump
%
% Additional beam lines used for comparison with MAD (the BEAM0 point is at
% the upstream face of QCM01, at 100 MeV):
%
%  beamLine.SC_DIAG0I = BEAM0 to DIAG0 FARC
%  beamLine.SC_SXRI   = BEAM0 to SXR beam dump
%  beamLine.SC_HXRI   = BEAM0 to HXR beam dump
%  beamLine.SC_BSYDI  = BEAM0 to BSY beam dump
%
% -----------------------------------------------------------------------------
 
% check for mat-file version ... load and return beamLine if found
if (exist('model_beamLineLCLS2sc.mat')==2)
  load model_beamLineLCLS2sc.mat
  return
end

global SETSP SETCUS SETAL ROLLON

SETSP = 0;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_EIC=[EIC]';


SETSP = 1;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_SXR=[GUN,L0,LCLS2SCC,LCLS2SCS]';


SETSP = -1;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_HXR=[GUN,L0,LCLS2SCC,LCLS2SCH]';


SETSP = 0;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_BSYD=[GUN,L0,LCLS2SCC,LCLS2SCD]';


SETSP = 0;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DIAG0=[GUN,L0,HTR,DIAG0]';


SETSP = 1;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_SXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCS]';


SETSP = -1;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_HXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCH]';


SETSP = 0;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_BSYDI=[LCLS2SCI,LCLS2SCC,LCLS2SCD]';


SETSP = 0;SETCUS = 0;SETAL = 0;ROLLON = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DIAG0I=[LCLS2SCI,HTR,DIAG0]';



function [DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl()

global SETSP SETCUS SETAL ROLLON


PI     = pi;
TWOPI  = 2*pi;
DEGRAD = 180/pi;
RADDEG = pi/180;
E      = exp(1);
EMASS  = 0.510998902e-3; % electron rest mass [GeV]
PMASS  = 0.938271998;    % proton rest mass [GeV]
CLIGHT = 2.99792458e8;   % speed of light [m/s]
%superconducting linac
% *** OPTICS=AD_ACCEL-05DEC19 ***



% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 07-AUG-2019, M. Woodley
%  * remove "h" from names of split elements
%  * create "_full" sub-LINEs for split elements
% ------------------------------------------------------------------------------
% 28-MAY-2019, M. Woodley
%  * rematch through SXR undulator (self-seeding chicane moved from cell 33
%    to cell 35)
% ------------------------------------------------------------------------------
% 19-JUL-2017, M. Woodley
%  * structural changes in deck to accomodate MAD-to-BMAD
% ------------------------------------------------------------------------------
% 28-NOV-2016, M. Woodley
%  * merge LCLS-II' version 28NOV16 with LCLS2sc version 04NOV16
% ------------------------------------------------------------------------------
% **************************** NEW LCLS2sc BASELINE ****************************
% ------------------------------------------------------------------------------
% 26-FEB-2016, M. Woodley / Y. Nosochkov
%  * replace the HXR undulator with HGVPU undulator
% 01-FEB-2016, M. Woodley
%  * new 100 pC input beams from J. Qiang/C. Mitchell
% 01-NOV-2015, M. Woodley
%  * new 100 pC input beam from F. Zhou (Twiss from P. Emma)
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley / Y. Nosochkov
%  * update boundary Z-locations (Z0end, Z2end)
%  * see list of changes in .xsif files and in file MADdeckChanges.pdf
%  * add BKR (rolled kicker) to the list of defined element name prefixes
%  * update initial Twiss in LTU dogleg with stronger R56 chicanes
%  * load ALINE.xsif before LTU.xsif
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * list of changes ...
% 12-MAR-2015, Y. Nosochkov
%  * update quad/BPM/corrector positions in the spreader (per T. O'Heron)
%  * add dogleg connection from CuRF to SXR
%  * add kicker/septum in BSY to connect with the existing A-line
%  * update existing LCLS-I devices in the HXR (per updated LCLS-I lattice)
%  * change quad type "1.97Q10" to "2Q10"
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * change name prefix for cryomodule BPMs from "BPMCM" to "CMB"
%  * assign BPM TYPE attributes per PRD LCLSII-2.4-PR-0136
%  * change deferral level for some diagnostic devices per T. Taubenheimer
%  * change some RFBs (defer>0) to BPMs (defer=0)
% 09-DEC-2014, Y. Nosochkov
%  * add safety dump lines based on LCLS1 design and PRD LCLSII-3.5-PR-0111
%  * update types of various magnets
%  * add radiation physics collimators and ACMs
%  * move D10 dump inside the muon wall
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * new 1.3 GHz cryomodule layout from FNAL
%  * move GUN-L3 upstream 30 m to align 3.9 GHz CMs with NLTR tunnel (tweak
%    matching section between LH and COL0 to put gun at Z= -10.0 m exactly)
%  * lengthen EXT FODO cells by 12 m (57 m to 69 m)
%  * rematch EXT (layout and optics)
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * shortened inter-linac warm sections ... gun moved 30 m d/s (to Z=20m ...
%    there is now 40 m from present location of CID gun to location of LCLS-II
%    gun)
%  * various cost-cutting changes ... see individual xsif-files
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * add emittance measurement in L0-to-laser-heater matching section
%  * laser heater chicane lengthened to reduce R56 to 3.5 mm
%  * collimation systems (COL0, COL1, and COL2) now consist of four 45 degree
%    FODO cells with 3 pairs of collimators separated by 45 degrees (22 m betas
%    at collimators); FODO cell length is 12 m
%  * added a wire scanner at the end of COL0 for "tomographic" emittance
%    measurement
%  * L1 phase advance per cell lowered to 45 degrees
%  * DIAG1 beamline (post-BC1 off-axis diagnostics line) removed
%  * in-line emittance measurement systems incorporated into COL1 and COL2
%  * TCAV(Y), vertical kicker, and lambertson septum added d/s of BC1
%  * change bending direction in BC2 chicane ... toward the aisle
%  * TCAV(Y) added d/s of BC2
%  * EXT FODO cell length doubled, phase advance per cell lowered to 60 degrees
%  * 1.259Q12 quadrupoles replaced by QWs or QEs
%  * BC3 removed
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * TYPE attribute of "deprecated" devices is now "decorated" ... see below
% 31-JUL-2014, Y. Nosochkov
%  * implement magnetic kicker with two 2-hole septa in the spreader
%  * remove QBP37 and adjust positions of QBP31, QBP32, QBP35, QBP36
%  * remove unnecessary diagnostics (per J. Frisch)
%  * move TDUNDb 2.8 m d/s, QUM1b 2.0 m d/s, QDL11-QDL19 2.5 m d/s
%    (per J. Stieber)
%  * move markers ENDSXR, BEGDMPS and ENDHXR, BEGDMPH to include
%    RFBSX51 and RFBHX51 into the SXR and HXR areas (per D. Hanquist)
% ------------------------------------------------------------------------------
% 02-MAY-2014, M. Woodley
%  * update 1.3 GHz cryomodule layout (including end caps) per H. Alvarez
%  * update baseline compression setup per P. Emma
%  * remove DIAG1 beamline ... prepare COL1 for inline emittance diagnostics
%  * add "CNT" to list of defined element name prefixes (MARKER element)
%  * add "HOMCM" to list of defined element name prefixes (MARKER element)
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * add list of beamline area names (per document LCLSII-2.1-PR-0134)
%  * add list of element name prefixes (per document LCLSII-1.1-TS-0159)
%  * add beamline area boundary MARKer points
% 26-MAR-2014, Y. Nosochkov
%  * put phase shifter and RFBPM positions back to 03/14 version
%  * remove PCTDKIK1,2,3,4 from HXR LTU
% 25-MAR-2014, Y. Nosochkov
%  * add insertable beam stoppers STSP6ha, STSP6hb, STSP6hc in HXR spreader
%  * remove existing BYKIK, TDKIK and SPOILER from HXR LTU
%  * add missing ST60, ST61 stoppers in the BSY
%  * add marker D10Js for location of D10 dump face in SXR line
%  * remove BYKIKb, SPOILERb, TDKIKb, SPOILD2b from SXR
%  * change names: D2b -> STBP33a, ST60b -> STBP33b, ST61b -> STBP33c
% 21-MAR-2014, Y. Nosochkov
%  * update positions of phase shifters and RFBPMs in undulator cells
%  * add Y-corrector to each undulator
%  * update phase shifter parameters (per H-D. Nuhn)
% 14-MAR-2014, Y. Nosochkov
%  * add/update names for area boundary markers
% 07-MAR-2014, Y. Nosochkov
%  * increase main dump length to 1.5 m (to be confirmed)
%  * remove transverse deflecting cavities from SXR dumpline
% 06-MAR-2014, Y. Nosochkov
%  * add a soft bend upstream of the dump bends
%  * roll the dumpline starting from the soft bend by 10 deg
%    to reduce HXR to SXR x-separation at the dumps to ~1.88 m and
%    adjust the vertical position at the dumps
% ------------------------------------------------------------------------------
% 01-MAR-2014, M. Woodley
%  * move cathode 10 m downstream ... now at Z= -10 m
%  * updated cryomodule layout
%    - 11 lambda CM-to-CM spacing
%    - add special short end cap at upstream end of L0
%      > SOL02 -> CAV011 center-to-center = 1.606 m
%    - include L0/L1/L2 feed boxes, L3 vacuum break box, and L3 end box
%      > use XFEL feed and end box lengths (~3.5 m)
%      > use XFEL "string connection box" length (23 lambda) for L3 break box
%  * add DIAG0 diagnostic line and X/Y collimation section after laser heater
%  * add BC3 chicane after dogleg to bypass line
%  * complete XCOR/YCOR/BPM additions in injector and linac areas
% 28-FEB-2014, Y. Nosochkov
%  * update undulators for reduced cell length of 4.4 m, rematch
% 26-FEB-2014, Y. Nosochkov
%  * update magnet types in the spreader, rematch
% 14-FEB-2014, Y. Nosochkov
%  * add a dumpline from the spreader to D10 dump including optics
%    for energy diagnostic
% 17-JAN-2014, Y. Nosochkov
%  * modify HXR spreader from 1-step to 2-step dogleg for tunable R56
%    and better magnet separation
% 18-DEC-2013, Y. Nosochkov
%  * adjust magnet positions in the spreader for less magnet interference
% 18-DEC-2013, M. Woodley
%  * name change: CE11B -> C1XE, CE21B -> C2XE
% 16-DEC-2013, Y. Nosochkov
%  * 3-way spreader design with low R56
% 03-DEC-2013, Y. Nosochkov
%  * make HXR BSY compatible with the existing divergent and biconcave chambers
%  * modify the spreader to reduce R56 and match to the updated BSY
% 21-NOV-2013, Y. Nosochkov
%  * replace the 2-way spreader (TLINE) with a 3-way spreader in BSY
% ------------------------------------------------------------------------------
% 04-NOV-2013, M. Woodley
%  * assign X or Y correctors to cryomodules
%  * redefine linac axis in LI00-LI10 ... modify bypass dogleg geometry
%  * update quadrupole type 1.26Q12 in HXR
%  * laser heater undulator parameters per M. Venturini
%  * latest compression setup per P. Emma
% 26-OCT-2013, Y. Nosochkov
%  * update quadrupole type 1.26Q12 in SXR
%  * update SXR and HXR undulator design, rematch optics
%  * update LTU match
% 21-OCT-2013, M. Woodley
%  * LCLS2sc v1.1
%  * input Twiss from C. Papadopoulos (Parameters_GUN2013_10_08v3.docx) ...
%    use "avg. beta" and "avg. alpha" parameters
%  * everything downstream of QBP13 from Yuri's LCLS2sc_2013_10_16 files
% 15-OCT-2013, M. Woodley
%  * LCLS2sc v1.0
%  * input Twiss from C. Papadopoulos (Parameters_GUN2013_10_08v3.docx)
% 07-OCT-2013, M. Woodley
%  * LCLS2sc v0.1
%  * initial beam parameters from C. Papadopoulos
%  * change 4-quad match to 6-quad match between L0 and laser heater
%  * increase laser heater chicane dispersion to 7.5 cm ... matching requires
%    inner/outer bend separation to increase
%  * increase laser heater chicane inner bend separation by 1.0 m and add an
%    energy collimator
% 06-OCT-2013, M. Woodley
%  * initial bare-bones lattice ... LCLS2sc v0
% 30-SEP-2013, M. Woodley
%  * from XFEL and NGLS designs
% ------------------------------------------------------------------------------
% ==============================================================================
% Deferred devices
% ------------------------------------------------------------------------------
% see: https://slacspace.slac.stanford.edu/sites/lcls/lcls-2/ap/InjSim/
%      150129%20Deferment%20Levels.xlsx
% ------------------------------------------------------------------------------
% Device TYPE attributes have been prefixed by a 2-character deferment
% indicator. If the first character of a device's TYPE attribute is not "@" (or
% if a device has no defined TYPE attribute), the device is baseline. If the
% first character of a device's TYPE attribute is "@", the device is deferred.
% The level of deferral is indicated by the second character of the TYPE
% attribute:

% TYPE="@0..." : level 0 (required for CD4-Threshold with >100 pC/bunch and
%                         50 kHz operation)
% TYPE="@1..." : level 1 (required to approach CD4-Objective, but limited to
%                         ~100 pC/bunch)
% TYPE="@2..." : level 2 (required to meet science objectives across parameter
%                         range)
% TYPE="@3..." : level 3 (component to improve tuning time)
% TYPE="@4..." : level 4 (space for future components that may be needed)
% TYPE="@5..." : level 5 (probably not needed ... leave space in beamline for
%                         future installation)
% TYPE="@9..." : level 9 (previously baseline (costed) ... removed but might
%                         return)

% The remaining characters of TYPE define the device's engineering type.
% ------------------------------------------------------------------------------
% ==============================================================================
% Beamline area names (see LCLSII-2.1-PR-0134)
% see: https://docs.slac.stanford.edu/sites/pub/Publications/
%      Beamline Boundaries.pdf
% ------------------------------------------------------------------------------
% SC linac common areas
% ------------------------------------------------------------------------------
% GUNB   : cathode to L0
% L0B    : L0 (end cap, CM01, end cap, mechanical stay-clear)
% HTR    : laser heater (emittance measurement, chicane, extraction to DIAG0)
% COL0   : collimation 0
% L1B    : L1 (differential pumping, mechanical stay-clear, end cap, CM02-03,
%          HCM01-02, end cap, mechanical stay-clear, differential pumping)
% BC1B   : BC1 chicane
% COL1   : collimation 1 (includes in-line emittance measurement)
% L2B    : L2 (differential pumping, mechanical stay-clear, end cap, CM04-15,
%          end cap, mechanical stay-clear, differential pumping)
% BC2B   : BC2 chicane
% EMIT2  : match BC2 to L3 (includes quad-scan emittance measurement station)
% L3B    : L3 (differential pumping, mechanical stay-clear, end cap, CM16-25,
%          vacuum break, CM26-23, end cap, mechanical stay-clear, differential
%          pumping)
% EXT    : L3B-to-dogleg matching
% DOG    : dogleg to PEP-II e- bypass line
% BYP    : bypass line (NIT)
% ------------------------------------------------------------------------------
% SC linac to SXR areas
% ------------------------------------------------------------------------------
% SPS    : SXR spreader kickers to start of BSY
% SLTS   : start of BSY to Cu/SC linac merge
% BSYS   : Cu/SC merge to end of BSY
% LTUS   : SXR LTU (from d/s end of muon wall)
% UNDS   : SXR extension + SXR undulator
% DMPS_1 : SXR post-undulator line
% DMPS_2 : SXR dump line
% SFTS_1 : BYDSS u/s face to BXPM1B u/s face
% SFTS_2 : BXPM1B u/s face to SXR safety dump
% SXTES  : SXR XTES system (BSY coordinate SURVEY only)
% ------------------------------------------------------------------------------
% SC linac to HXR areas
% ------------------------------------------------------------------------------
% SPH    : HXR spreader kickers to start of BSY
% SLTH   : start of BSY to SC/Cu linac merge
% BSYH_1 : SC/Cu linac merge to A-line kickers
% BSYH_2 : A-line kickers to end of BSY
% LTUH   : HXR LTU (from d/s end of muon wall)
% UNDH   : HXR undulator
% DMPH_1 : HXR post-undulator line
% DMPH_2 : HXR dump line
% SFTH_1 : BYDSH u/s face to BXPM1 u/s face
% SFTH_2 : BXPM1 u/s face to HXR safety dump
% HXTES  : HXR XTES system (BSY coordinate SURVEY only)
% ------------------------------------------------------------------------------
% SC linac to BSY dump areas
% ------------------------------------------------------------------------------
% SPD_1  : HXR spreader kickers to SXR spreader kickers
% SPD_2  : SXR spreader kickers to DASEL kickers
% SPD_3  : DASEL kickers to start of BSY
% SLTD   : start of BSY to BSY dump
% ------------------------------------------------------------------------------
% SC linac to other areas
% ------------------------------------------------------------------------------
% DIAG0  : post laser heater diagnostics line
% DASEL  : DASEL kickers to A-line merge ... deferred
% ==============================================================================
% ==============================================================================
% Element naming conventions with the first few characters meaning:
% ------------------------------------------------------------------------------
% CAVL.... = 1.3 GHz RF cavity (superconducting)
% CAVC.... = 3.9 GHz RF cavity (superconducting)
% CAVS.... = 2.856 GHz RF structure (warm copper)
% CSP..... = cryomodule support post
% BUN..... = RF buncher (warm)
% TCX..... = transverse deflecting structure (horizontal deflection)
% TCY..... = transverse deflecting structure (vertical deflection)
% BX...... = horizontal bend (split in two (suffixes "a" and "b"))
% BY...... = vertical bend (split in two (suffixes "a" and "b"))
% BR...... = rolled bend (split in two (suffixes "a" and "b"))
% BCX..... = horizontal chicane bend (split in two (suffixes "a" and "b"))
% BLX..... = horizontal Lambertson septum (split in two (suffixes "a" and "b"))
% BLY..... = vertical Lambertson septum (split in two (suffixes "a" and "b"))
% BLR..... = rolled Lambertson septum (split in two (suffixes "a" and "b"))
% BKX..... = horizontal kicker ((split in two (suffixes "a" and "b"))
% BKY..... = vertical kicker (split in two (suffixes "a" and "b"))
% BKR..... = rolled kicker (split in two (suffixes "a" and "b"))
% Q....... = quadrupole (normal quad, split in half)
% QCM..... = standard cryomodule quadrupole (normal quad, split in half)
% QSX..... = undulator quadrupole (normal quad, split in half ... SXR)
% QHX..... = undulator quadrupole (normal quad, split in half ... HXR)
% CQ...... = correction quadrupole (normal quad, split in half)
% SQ...... = skew quadrupole (skew quad, split in half)
% SOL..... = solenoid (split in half)
% UM...... = undulator magnet (full undulator segment)
% PS...... = phase shifter undulator
% CX...... = horizontal collimator (vertical jaws, adjustable)
% CY...... = vertical collimator (horizontal jaws, adjustable)
% CE...... = momentum collimator (adjustable)
% PC...... = protection collimator (fixed aperture) when keyword=ECOL
% PC...... = RP spot shielding (external plates) when keyword=INST
% RO...... = coordinate rotation (non-physical element)
% XC...... = horizontal steering dipole
% XCM..... = standard cryomodule horizontal steering dipole
% YC...... = vertical steering dipole
% YCM..... = standard cryomodule vertical steering dipole
% SC...... = steering coil package (horizontal and vertical dipole correctors)
% BPM..... = beam position monitor (stripline, various resolutions)
% RFB..... = RF beam position monitor (<1 micron rms resolution)
% CMB..... = standard cryomodule button beam position monitor
% WS...... = wire scanner
% YAG..... = YAG screen profile monitor
% OTR..... = optical transition radiation profile monitor
% IM...... = bunch charge monitor (ICT, DCCT, ACM, etc.)
% FC...... = Faraday cup
% BZ...... = bunch length monitor (various types)
% BTM..... = burn-through monitor (PPS device)
% PH...... = beam phase detector
% TD...... = tune-up dump (insertable copper block)
% SP...... = beam spoiler
% ST...... = beam stopper
% TR...... = transition radiator
% DUMP.... = beam dump
% BOD..... = beam overlap monitor
% VV...... = vacuum valve (not all valves are in the MAD deck)
% MIR..... = laser insertion mirror
% BLM..... = beam loss monitor (undulator areas)
% CNT..... = ELEGANT centering element
% HOMCM... = standard cryomodule HOM absorber
% S....... = sextupole (normal or rolled sextupole, split in half)
% ==============================================================================
% ------------------------------------------------------------------------------
% deflector switch definitions
% ------------------------------------------------------------------------------



SETDA =  0 ;%deflector switch for BSYD/DASEL
SETXLEAP2 =  0 ;%selector switch for XLEAP-II components
SETHXRSS =  0 ;%ON/OFF switch for HXR self-seeding chicane
SETSXRSS =  0 ;%ON/OFF switch for SXR self-seeding chicane
% ------------------------------------------------------------------------------
% integrated gradients for undulator quadrupoles
% ------------------------------------------------------------------------------
INTGSX =  30.0 ;%kG
INTGHX =  30.0 ;%kG
% ------------------------------------------------------------------------------
% element and line definitions
% ------------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-05DEC19 ***
% ------------------------------------------------------------------------------
% constants and global parameters
% ------------------------------------------------------------------------------
% constants
CB=1.0E10/CLIGHT;%kG-m/GeV
IN2M=0.0254;%m/inch
MC2=0.51099906E-3;%GeV
QELEC=1.602176462E-19;%C
% energy profile
E0 =  MC2+0.750E-3 ;%NGLS/APEX gun energy (GeV) ... 750 kV gun
EI =  0.1          ;%energy at end of L0B (GeV)
E1 =  0.23         ;%BC1 energy (GeV)
E2 =  1.6          ;%BC2 energy (GeV)
EF =  4.0          ;%final beam energy (GeV)
EU =  4.0          ;%energy in undulator (GeV)
EMAX =  10.0         ;%maximum beam energy
BRHO0 =  CB*E0;
BRHOI =  CB*EI;
BRHO1 =  CB*E1;
BRHO2 =  CB*E2;
BRHOF =  CB*EF;
% compression
R56HTR =  0.0035 ;%DXmax = 75 cm
R56BC1 =  0.05285;
R56BC2 =  0.03955;
R56CCDLU =  9.99E-5;
R56CCDLD =  9.99E-5;
% ------------------------------------------------------------------------------
% input beam definition: F. Zhou (100 pC)
% ------------------------------------------------------------------------------
% Twiss at gun
BX0 =  54.70910663424;
AX0 =  24.927276694193;
BY0 =  54.64124177612;
AY0 =  24.896728669354;
% Twiss at S= 15.0 m (ASTRA MARKER)
BXA =  13.325594260685;
AXA =  -2.125811087318;
BYA =  13.315541277702;
AYA =  -2.123153832086;
% Twiss at BEAM0 MARKER (specified)
BXI =   9.3480;
AXI =  -1.6946;
BYI =   9.3429;
AYI =  -1.6925;
% max beta u/s of WS0H04
BMAX =  50;
% beta at WS0H04 waist
B0H04W =  5.0;
% beam parameters
QBNCH =  100.0E-12  ;%C
EMITXN =  0.2953E-06 ;%m
EMITYN =  0.2954E-06 ;%m
SIG_Z =  0.9987E-03 ;%m
SIG_DP =  0.0379E-02 ;%1
% ------------------------------------------------------------------------------
% input beam definition (at BEAM0)
% ------------------------------------------------------------------------------
EMITX =  EMITXN/(EI/EMASS);
EMITY =  EMITYN/(EI/EMASS);
GXI =  (1+AXI*AXI)/BXI;
SIG11 =  EMITX*BXI;
SIG21 =  -EMITX*AXI;
SIG22 =  EMITX*GXI;
C21 =  SIG21/sqrt(SIG11*SIG22);
GYI =  (1+AYI*AYI)/BYI;
SIG33 =  EMITY*BYI;
SIG43 =  -EMITY*AYI;
SIG44 =  EMITY*GYI;
C43 =  SIG43/sqrt(SIG33*SIG44);
%SIGX = SQRT(SIG11)
%SIGPX= SQRT(SIG22)
%R21  = C21
%SIGY = SQRT(SIG33)
%SIGPY= SQRT(SIG44)
%R43  = C43
%SIGT = sig_z
%SIGPT= sig_dp
% ------------------------------------------------------------------------------
% survey (Z values are w.r.t. start of LI01 where Z=0)
% ------------------------------------------------------------------------------
XGUN =     0.28     ;%beam axis (w.r.t. original linac axis)
YGUN =    -0.99     ;%beam axis (w.r.t. original linac axis)
ZGUN =   -10.044667 ;%10.0 m d/s of location of CID gun
Z0BEG =    -7.992090 ;%start of L0 (12.0 m d/s of location of CID gun)
ZI =     3.914190 ;%BEAM0 point (~3.9 m into LI01)
ZA =    ZGUN+15.0 ;%ASTRA treaty point (~4.8 m into LI01)
Z0END =     8.130200 ;%end of L0 (~8.0 m into LI01)
ZHTR =    18.202600 ;%start of laser heater chicane (~18.2 m into LI01)
ZDG0 =    32.183970 ;%start of DIAG0 (~32.2 m into LI01)
Z1BEG =    73.383640 ;%start of L1 (~73.4 m into LI01)
Z1LOC =   104.194330 ;%center of CAVC011 (sholud be 104.0 m)
Z1END =   121.344620 ;%end of L1 (~19.7 m into LI02)
Z2BEG =   174.885202 ;%start of L2 (~73.3 m into LI02)
Z2END =   331.562942 ;%end of L2 (~26.8 m into LI04)
Z3BEG =   385.847300 ;%start of L3 (~81.0 m into LI04)
Z3END =   643.543300 ;%end of L3 (~33.9 m into LI07)
ZDOG =   667.043300 ;%entrance first dogleg bend (~57.4 m into LI07)
XBYP =    -0.650494 ;%BEGBYP X is |Xbyp| to the south of linac axis
YBYP =     0.649478 ;%BEGBYP Y is Ybyp above linac axis
ZBYP =  1202.631303 ;%BEGBYP Z (~85.0 m into LI12)
% ------------------------------------------------------------------------------
% twiss parameter definitions (for matching, etc.)
% ------------------------------------------------------------------------------
% "treaty" Twiss at center of laser heater undulator
BXLH =  10.0;
AXLH =  0;
BYLH =  10.0;
AYLH =  0;
% matched Twiss for coasting linac FODOs
BXCMFODO1 =  47.734300019352 ;%L1: 45 degrees per cell
BYCMFODO1 =  21.362810104773 ;%L1: 45 degrees per cell
BXCMFODO2 =  61.483042301615 ;%L2: 30 degrees per cell
BYCMFODO2 =  36.259471142003 ;%L2: 30 degrees per cell
BXCMFODO3 =  61.483042301615 ;%L3: 30 degrees per cell
BYCMFODO3 =  36.259471142003 ;%L3: 30 degrees per cell
% match into bypass dogleg
BXDLM =  13.103975995473;
AXDLM =  -1.328121315284;
BYDLM =  15.962707890972;
AYDLM =   1.529775364964;
% match into SXR LTU emittance diagnostic section
BXEDS =  46.225914318019;
AXEDS =  -1.084608326468;
BYEDS =  46.225914318019;
AYEDS =   1.084608326468;
% match into HXR LTU emittance diagnostic section
BXEDH =  46.347592421655;
AXEDH =  -1.088004889273;
BYEDH =  46.098656017174;
AYEDH =   1.08081945287;
% initial Twiss for SXR dogleg
MBETXS =   6.841330859726;
MALFXS =  -0.28404741292;
MBETYS =  47.120432391261;
MALFYS =   2.555848494222;
% periodic Twiss in HXR dogleg cells
MBETXH =  48.911502413792;
MALFXH =   3.141736059434;
MBETYH =  92.803659415654;
MALFYH =   3.519158552438;
% ------------------------------------------------------------------------------
% load lattice definitions
% ------------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc common parameters
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-JAN-2019, M. Woodley
%  * add area BEG/END MARKers for the Cu-linac (u/s of BSY)
% ------------------------------------------------------------------------------
% 31-OCT-2018, Y. Nosochkov
%  * adjust ABRDAS2, TBRDAS2 for DASEL optics with 25G kicker field
% 19-SEP-2018, M. Woodley
%  * add LPCTDKIK definition
% 30-MAY-2018, M. Woodley
%  * add self-seeding chicane ON/OFF switch definitions
% 16-MAY-2018, M. Woodley
%  * add narrow-frame SLTR QF1545 quadrupole type
% ------------------------------------------------------------------------------
% 24-JAN-2018, M. Woodley
%  * change length of BCS protection collimators (PCs) in spreader from 30 cm
%    to 5.08 cm (2")
% 05-DEC-2017, M. Woodley
%  * add BEGHXTES, ENDHXTES, BEGSXTES, ENDSXTES MARKers
% 06-SEP-2017, Y. Nosochkov
%  * update spreader kicker gap GBKSP to 20 mm (= 10 mm beam aperture +
%    10 mm pipe walls) (T. Beukers)
% 22-AUG-2017, M. Woodley
%  * add low-energy dump line (area=SLTDX)
%  * split SLTS and SLTD areas
% ------------------------------------------------------------------------------
% 28-NOV-2016, M. Woodley
%  * replace BEGCOL2/ENDCOL2 with BEGEMIT2/ENDEMIT2
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * change "1.259Q3.5" to "1.26Q3.5"
%  * change Everson-Tesla 2.362Q3.5 (r=30mm) to SigmaPhi 1.69Q3.4 (bore=43mm)
% 02-NOV-2016, Y. Nosochkov
%  * move definition of DRFB drift to LTU.xsif
%  * remove no longer used definition of SPhOFF
%  * add markers BEGSPD3, ENDSPD3
%  * add kicker switches for DASEL
% 30-SEP-2016, Y. Nosochkov
%  * add some missing GLmax data (per J. Amann)
% ------------------------------------------------------------------------------
% 12-FEB-2016, M. Woodley
%  * add FFTB sextupole definitions (for 2nd-order dispersion correction)
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * add SETDG0 ... switch beam between straight-ahead (DG0OFF) and DIAG0 line
%    (DG0ON)
% 25-SEP-2015, Y. Nosochkov
%  * add deflector switches for CUSXR and A-line
% 28-AUG-2015, M. Woodley
%  * add GLmax comment for 2Q4 ("QM")
%  * replace "Qs" definitions with  SLC positron inflector (LI01) quadrupole
%    definitions
% 24-AUG-2015, Y. Nosochkov
%  * specify gap height and length of fast kickers and septa
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * restore definition of 1.97Q20 quadrupole
% ------------------------------------------------------------------------------
% 16-APR-2015, M. Woodley
%  * restore "LQL" parameter (used in SPRD.xsif)
% 20-MAR-2015, M. Woodley
%  * remove 1.97Q10 and 1.97Q20 quadrupole definitions (replaced with 2Q10s)
%  * set length of tungsten jaw collimators (15*X0; X0(W)= 4 mm; Ljaw = 6 cm)
%  * add SEQ20BEG, SEQ20END, BEGCuSXR, ENDCuSXR MARKERs (for LCLS1 to SXR line)
%  * add SEQ21BEG, SEQ21END, BEGBSYA, ENDBSYA MARKERs (for BSY to A-line)
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * add PEPII "2Q10" quadrupole type
%  * add area and SEQ BEG/END MARKers for safety dump lines
% 09-DEC-2014, Y. Nosochkov
%  * specify a preliminary length of protection collimators in the spreader
% 19-NOV-2014, Y. Nosochkov
%  * specify type of undulator quadrupole (per J. Amann)
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * add SEQ17BEG, SEQ17END, BSY1BEG, BSY1END MARKERs (for LCLS1 BSY)
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * add R56 compensation chicane parameters
% ------------------------------------------------------------------------------
% ==============================================================================
% magnets
% ------------------------------------------------------------------------------
% LCLS2 quadrupoles
% QK : 1.625Q27.3
% QA : 1.26Q12 (NOTE: bore of captured BPM is 0.870")
% Qu : undulator quadrupole (0.433Q3.1)
LQK =  0.7142  ;
RQK =  1.625*IN2M/2 ;%GLmax=   ?   kG @   ? A
LQA =  0.32    ;
RQA =  0.016        ;%GLmax= 112   kG @ 120 A
LQU =  0.084   ;
RQU =  0.0055       ;%GLmax=  41.8 kG @   6 A
% LCLS quadrupoles
% Qx  : Everson-Tesla quadrupole (1.26Q3.5)
% Qc  : SigmaPhi "tweaker" quadrupole (1.69Q3.4)
% QsB : "Bertsche" skew quadrupole
LQX =  0.108 ;
RQX =  0.016    ;%GLmax= 20.0 kG @ 12 A
LQC =  0.108 ;
RQC =  0.043/2  ;%GLmax=  2.1 kG @ 12 A
LQSB =  0.16  ;
RQSB =  0.06     ;%GLmax=  1.3 kG @ 12 A
% PEP-II quadrupoles
% QM : PEPII injection quadrupole (2Q4)
% QP : PEPII LER quadrupole (3.94Q17)
% QR : PEPII injection quadrupole (2Q10)
% QN : PEPII injection "50Q" quadrupole (1.97Q20)
LQM =  0.1244 ;
RQM =  0.0269 ;%GLmax= 6.75 kG @  45 A; GLmax= 27 kG for 2Q4W
LQP =  0.43   ;
RQP =  0.05   ;%GLmax= 44.6 kG @ 178 A
LQR =  0.263  ;
RQR =  0.0257 ;%GLmax= 50   kG @ 160 A
LQN =  0.542  ;
RQN =  0.025  ;%GLmax= 78   kG @   ? A
% FFTB quadrupoles
% QF : FFTB "Russian" quad 0.91Q17.72
% QD : FFTB dump quad (3.25Q20)
LQF =  0.46092 ;
RQF =  0.023/2   ;%GLmax= 386.8 kG @ 240 A
LQD =  0.55    ;
RQD =  0.08255/2 ;%GLmax=  74.7 kG @  35 A
% SLC quadrupoles
% QE : linac QE4 (1.085Q4.31)
% Qs : LI01 positron inflector type
% QW : "wraparound" type (4.63Q8.0; i.e. SLTR QWF1015)
% Qz : special narrow quad (SLTR QF1545)
LQE =  0.1068  ;
RQE =  1.085*IN2M/2 ;%GLmax= 106   kG @ 220 A
%LQs := 0.09181 ; rQs := 1.013*in2m/2 GLmax=  52   kG @ 207 A
LQS =  0.197   ;
RQS =  1.510*IN2M/2 ;%GLmax=  31   kG @  90 A
LQW =  0.248   ;
RQW =  4.625*IN2M/2 ;%GLmax=  16.5 kG @  50 A
LQZ =  0.09181 ;
RQZ =  1.013*IN2M/2 ;%GLmax=  63.8 kG @ 160 A
% R56 compensation chicanes (0.788D11.50):
%   GBCC = bend magnet full gap height (m)
%   ZBCC = bend magnet Z-length (m)
%   FBCC = average measured bend magnet FINT value (m)
%   ZDCC = Z-space between magnets (m)
GBCC =  0.032;
ZBCC =  0.35;
FBCC =  0.8436;
ZDCC =  0.2;
% FFTB sextupoles
% Sa : 2.13S3.00
% Sb : 1.38S3.00
LSA =  0.1 ;
RSA =  2.13*IN2M/2 ;%G'Lmax= 240 kG/m @ 8 A; Kmax=18 (4 GeV)
LSB =  0.1 ;
RSB =  1.38*IN2M/2 ;%G'Lmax= 870 kG/m @ 8 A; Kmax=65 (4 GeV)
% ==============================================================================
% kickers and septa
% ------------------------------------------------------------------------------
SETSPS =   1 ;%deflector switch for SXR
SETSPH =  -1 ;%deflector switch for HXR
SETSPD =   0 ;%deflector switch for dump
CUSON =   1 ;%deflector switch ON for pulsed Cu-linac to SXR
CUSONDC =  -1 ;%deflector switch ON for DC Cu-linac to SXR
CUSOFF =   0 ;%deflector switch OFF for Cu-linac to HXR
ALON =   1 ;%deflector switch ON for Cu/SC-linac to A-line
ALOFF =   0 ;%deflector switch OFF for Cu/SC-linac to HXR
DAON =   1 ;%deflector switch ON for DASEL
DAOFF =   0 ;%deflector switch OFF for DASEL
% ==============================================================================
% self seeding chicanes
% ------------------------------------------------------------------------------
SSON =   1 ;%self-seeding chicane ON
SSOFF =   0 ;%self-seeding chicane OFF
% ==============================================================================
% miscellaneous
% ------------------------------------------------------------------------------
SBANDF =  2856.0     ;%S-band rf frequency (MHz)
XBANDF =  4*SBANDF   ;%X-band rf frequency (MHz)
LJAW =  0.06     ;%standard jaw collimator length
LCOLL =  0.08     ;%standard collimator length
LPCPM =  0.076    ;%length of BCS protection collimator
LPCPMW =  0.08     ;%length of BCS WHA protection collimator
GBKSP =  0.02     ;%fast kicker gap height - round pipe, square bore aperture
LBKSP =  1.0      ;%fast kicker straight length (m)
GBLSP =  0.0159   ;%0.625SD38.98 septum gap height (m)
LBLSP =  1.0      ;%0.625SD38.98 septum straight length (m)
GBSP =  0.0254   ;%1.0D38.37 gap height (m)
LBSP =  1.0      ;%1.0D38.37 straight length (m)
R56SPS =  0.0      ;%R56 of the SXR spreader
R56SPH =  0.0      ;%R56 of the HXR spreader
LQL =  0.28     ;%length of no-longer-used 1.97Q10 quadrupole
LRFBUB =  0.05     ;%length of undulator RF BPM
LPCTDKIK =  0.8128   ;%length of muon protection collimators associated with
% TDKIK and TDKIKS (0.875" ID w/pipe)
LPLATE =  2.5*IN2M ;%length (thickness) of BCS shielding plates (RP "PC")
LSPOTS =  8.0*IN2M ;%length (thickness) of BCS spot shield
% wooden BSY door (separates LI30 from BSY)
WOODDOOR={'mo' 'WOODDOOR' 0 []}';
% Note: BRDAS2 is a merge DC-bend which is either turned ON to operate
%       DASEL beam in A-line, or turned OFF to operate beam in A-line from
%       BSY pulsed magnets
ABRDAS2 =  -0.011874293037;
TBRDAS2 =   0.371701698805 ;%BRDAS2 roll angle (rad)
% ------------------------------------------------------------------------------
% beamline area delimiters (see PRD LCLSII-2.1-PR-0134)
% ------------------------------------------------------------------------------
% areas "owned" by SC linac
BEGGUNB={'mo' 'BEGGUNB' 0 []}';
ENDGUNB={'mo' 'ENDGUNB' 0 []}';
BEGL0B={'mo' 'BEGL0B' 0 []}';
ENDL0B={'mo' 'ENDL0B' 0 []}';
BEGHTR={'mo' 'BEGHTR' 0 []}';
ENDHTR={'mo' 'ENDHTR' 0 []}';
BEGDIAG0={'mo' 'BEGDIAG0' 0 []}';
ENDDIAG0={'mo' 'ENDDIAG0' 0 []}';
BEGCOL0={'mo' 'BEGCOL0' 0 []}';
ENDCOL0={'mo' 'ENDCOL0' 0 []}';
BEGL1B={'mo' 'BEGL1B' 0 []}';
ENDL1B={'mo' 'ENDL1B' 0 []}';
BEGBC1B={'mo' 'BEGBC1B' 0 []}';
ENDBC1B={'mo' 'ENDBC1B' 0 []}';
BEGCOL1={'mo' 'BEGCOL1' 0 []}';
ENDCOL1={'mo' 'ENDCOL1' 0 []}';
BEGL2B={'mo' 'BEGL2B' 0 []}';
ENDL2B={'mo' 'ENDL2B' 0 []}';
BEGBC2B={'mo' 'BEGBC2B' 0 []}';
ENDBC2B={'mo' 'ENDBC2B' 0 []}';
BEGEMIT2={'mo' 'BEGEMIT2' 0 []}';
ENDEMIT2={'mo' 'ENDEMIT2' 0 []}';
BEGL3B={'mo' 'BEGL3B' 0 []}';
ENDL3B={'mo' 'ENDL3B' 0 []}';
BEGEXT={'mo' 'BEGEXT' 0 []}';
ENDEXT={'mo' 'ENDEXT' 0 []}';
BEGDOG={'mo' 'BEGDOG' 0 []}';
ENDDOG={'mo' 'ENDDOG' 0 []}';
BEGBYP={'mo' 'BEGBYP' 0 []}';
ENDBYP={'mo' 'ENDBYP' 0 []}';
BEGSPH={'mo' 'BEGSPH' 0 []}';
ENDSPH={'mo' 'ENDSPH' 0 []}';
BEGSLTH={'mo' 'BEGSLTH' 0 []}';
ENDSLTH={'mo' 'ENDSLTH' 0 []}';
BEGSPD_1={'mo' 'BEGSPD_1' 0 []}';
ENDSPD_1={'mo' 'ENDSPD_1' 0 []}';
BEGSPD_2={'mo' 'BEGSPD_2' 0 []}';
ENDSPD_2={'mo' 'ENDSPD_2' 0 []}';
BEGSPD_3={'mo' 'BEGSPD_3' 0 []}';
ENDSPD_3={'mo' 'ENDSPD_3' 0 []}';
BEGSLTD={'mo' 'BEGSLTD' 0 []}';
ENDSLTD={'mo' 'ENDSLTD' 0 []}';
BEGSPS={'mo' 'BEGSPS' 0 []}';
ENDSPS={'mo' 'ENDSPS' 0 []}';
BEGSLTS={'mo' 'BEGSLTS' 0 []}';
ENDSLTS={'mo' 'ENDSLTS' 0 []}';
BEGBSYS={'mo' 'BEGBSYS' 0 []}';
ENDBSYS={'mo' 'ENDBSYS' 0 []}';
BEGLTUS={'mo' 'BEGLTUS' 0 []}';
ENDLTUS={'mo' 'ENDLTUS' 0 []}';
BEGUNDS={'mo' 'BEGUNDS' 0 []}';
ENDUNDS={'mo' 'ENDUNDS' 0 []}';
BEGDMPS_1={'mo' 'BEGDMPS_1' 0 []}';
ENDDMPS_1={'mo' 'ENDDMPS_1' 0 []}';
BEGDMPS_2={'mo' 'BEGDMPS_2' 0 []}';
ENDDMPS_2={'mo' 'ENDDMPS_2' 0 []}';
BEGSFTS_1={'mo' 'BEGSFTS_1' 0 []}';
ENDSFTS_1={'mo' 'ENDSFTS_1' 0 []}';
BEGSFTS_2={'mo' 'BEGSFTS_2' 0 []}';
ENDSFTS_2={'mo' 'ENDSFTS_2' 0 []}';
BEGSXTES={'mo' 'BEGSXTES' 0 []}';
ENDSXTES={'mo' 'ENDSXTES' 0 []}';
% areas "owned" by Cu linac
BEGGUN={'mo' 'BEGGUN' 0 []}';
ENDGUN={'mo' 'ENDGUN' 0 []}';
BEGGSPEC={'mo' 'BEGGSPEC' 0 []}';
ENDGSPEC={'mo' 'ENDGSPEC' 0 []}';
BEGL0={'mo' 'BEGL0' 0 []}';
ENDL0={'mo' 'ENDL0' 0 []}';
BEGDL1_1={'mo' 'BEGDL1_1' 0 []}';
ENDDL1_1={'mo' 'ENDDL1_1' 0 []}';
BEGSPEC={'mo' 'BEGSPEC' 0 []}';
ENDSPEC={'mo' 'ENDSPEC' 0 []}';
BEGDL1_2={'mo' 'BEGDL1_2' 0 []}';
ENDDL1_2={'mo' 'ENDDL1_2' 0 []}';
BEGL1={'mo' 'BEGL1' 0 []}';
ENDL1={'mo' 'ENDL1' 0 []}';
BEGBC1={'mo' 'BEGBC1' 0 []}';
ENDBC1={'mo' 'ENDBC1' 0 []}';
BEGL2={'mo' 'BEGL2' 0 []}';
ENDL2={'mo' 'ENDL2' 0 []}';
BEGBC2={'mo' 'BEGBC2' 0 []}';
ENDBC2={'mo' 'ENDBC2' 0 []}';
BEGL3={'mo' 'BEGL3' 0 []}';
ENDL3={'mo' 'ENDL3' 0 []}';
BEGCLTH_0={'mo' 'BEGCLTH_0' 0 []}';
ENDCLTH_0={'mo' 'ENDCLTH_0' 0 []}';
BEGCLTH_1={'mo' 'BEGCLTH_1' 0 []}';
ENDCLTH_1={'mo' 'ENDCLTH_1' 0 []}';
BEGCLTH_2={'mo' 'BEGCLTH_2' 0 []}';
ENDCLTH_2={'mo' 'ENDCLTH_2' 0 []}';
BEGBSYH_1={'mo' 'BEGBSYH_1' 0 []}';
ENDBSYH_1={'mo' 'ENDBSYH_1' 0 []}';
BEGBSYH_2={'mo' 'BEGBSYH_2' 0 []}';
ENDBSYH_2={'mo' 'ENDBSYH_2' 0 []}';
BEGLTUH={'mo' 'BEGLTUH' 0 []}';
ENDLTUH={'mo' 'ENDLTUH' 0 []}';
BEGUNDH={'mo' 'BEGUNDH' 0 []}';
ENDUNDH={'mo' 'ENDUNDH' 0 []}';
BEGDMPH_1={'mo' 'BEGDMPH_1' 0 []}';
ENDDMPH_1={'mo' 'ENDDMPH_1' 0 []}';
BEGDMPH_2={'mo' 'BEGDMPH_2' 0 []}';
ENDDMPH_2={'mo' 'ENDDMPH_2' 0 []}';
BEGSFTH_1={'mo' 'BEGSFTH_1' 0 []}';
ENDSFTH_1={'mo' 'ENDSFTH_1' 0 []}';
BEGSFTH_2={'mo' 'BEGSFTH_2' 0 []}';
ENDSFTH_2={'mo' 'ENDSFTH_2' 0 []}';
BEGHXTES_1={'mo' 'BEGHXTES_1' 0 []}';
ENDHXTES_1={'mo' 'ENDHXTES_1' 0 []}';
BEGHXTES_2={'mo' 'BEGHXTES_2' 0 []}';
ENDHXTES_2={'mo' 'ENDHXTES_2' 0 []}';
BEGHXTES_3={'mo' 'BEGHXTES_3' 0 []}';
ENDHXTES_3={'mo' 'ENDHXTES_3' 0 []}';
BEGCLTS={'mo' 'BEGCLTS' 0 []}';
ENDCLTS={'mo' 'ENDCLTS' 0 []}';
BEGBSYA_1={'mo' 'BEGBSYA_1' 0 []}';
ENDBSYA_1={'mo' 'ENDBSYA_1' 0 []}';
BEGBSYA_2={'mo' 'BEGBSYA_2' 0 []}';
ENDBSYA_2={'mo' 'ENDBSYA_2' 0 []}';
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc linacs: L0, L1, L2 L3
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 02-NOV-2018, M. Woodley
%  * L0 gradients and phases from 100 pC ASTRA run, per C. Mayes
% ------------------------------------------------------------------------------
% 01-NOV-2017, M. Woodley
%  * change L2 phase to -20.0 degrees per P. Emma
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * change cryo-quadrupole effective length from 0.29 m to 0.23 m
%  * change CM03-to-CMH1 interconnect dimensions per A. Dalesandro (FNAL)
%  * change from gate valve flange face callouts to mating surface callouts for
%    1.3 GHz cryomodules
%  * add beamline flanges
% ------------------------------------------------------------------------------
% 06-JUN-2016, M. Woodley
%  * move 1.3 GHz HOMs d/s 27.19 mm per Yun He (FNAL) ... maintain slot length
% 26-MAY-2016, M. Woodley
%  * 3.9 GHz layout update (18-May-2016) per Yun He (FNAL)
%  * put HOMs ("Beam Line Absorbers") back at the d/s end of L0, L2, and L3 per
%    C. Adolphsen email of 20-May-2016
% 11-MAY-2016, M. Woodley
%  * set L0 d/s MSC length to 1.829 m; locations of vacuum components (V*0H00)
%    per H.Alvarez
% 28-APR-2016, M. Woodley
%  * post-to-cap dimensions from SD-375-000-99-R2
% 22-APR-2016, M. Woodley
%  * add 1.1 mm to CM03-CMH1 interconnect
%  * add 3.47 mm to CMH1-CMH2 interconnect
%  * 3.9 GHz CM cold dimensions per Y. He (20-Apr-2016)
% 28-MAR-2016, M. Woodley
%  * add end cap and feed cap MARKers
% ------------------------------------------------------------------------------
% 14-MAR-2016, M. Woodley
%  * 3.9 GHz layout update per Yun He (FNAL)
% 02-FEB-2016, M. Woodley
%  * new 1.3 GHz layout per T. Peterson/J. Kaluzny (FNAL) [19-Nov-2015]
%  * new 3.9 GHz layout per T. Peterson (FNAL) [02-Dec-2015]
%  * feed cap, end cap, and stay-clear dimensions from drawing SD-375-000-99-R1
%  * remove last HOM in each linac section (L0/L1/L2/L3)
%  * adjust Differential Pumping Stay-Clears to restore locations of
%    LH/BC1/BC2/dogleg
%  * split 1.3 GHz cavity #5's to insert MARKer for center post
%  * remove BPM1C00/RFB1C00 (now that there are BPMs in the 3.9 GHz cryomodules)
% 01-FEB-2016, M. Woodley
%  * new 100 pC input beams from J. Qiang/C. Mitchell
% 01-NOV-2015, M. Woodley
%  * new 100 pC input beam from F. Zhou (Twiss from P. Emma)
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * add vacuum components and fixed-aperture collimator in L0 downstream
%    mechanical-stay-clear space
%  * fix negative D2C00a drift length error by shortening DPSC2D drift
%  * add BEAM0 MARKer
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * lengthen special L0 u/s end cap, per H.Alvarez ... moves gun u/s
%  * move ASTRA point to dZ=15.0 m from gun (temporarily)
%  * use QCM01 for matching
%  * undefer BPM1C00
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * add APER definition for cryo-quads
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * new FNAL 1.3 GHz cryomodule layout (F10010875) per M. Carrasco
%  * new end cap and mechanical stay-clear dimensions per H. Alvarez
%  * because mechanical stay-clear spaces got ~0.5 m longer, shorten
%    differential pumping spaces from 3.0 m to ~2.5 m to keep cryomodules in
%    previous Z-locations (checked with D. Gill)
%  * keep previous L3 vacuum break length (not designed yet)
%  * replace RFB1C00 (defer=2) with BPM1C00 (defer=0)
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * new FNAL 3.9 GHz cryomodule layout (F10014857) via M. Carrasco ... assume
%    save interconnect and d/s end cap dimensions as 1.3 GHz cryomodule
%  * add 3.0 m differential pumping stay-clear after L0
%  * add RFB0H00 between L0 mechanical stay-clear and differential pumping
%    stay-clear
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * new cryomodule layout per FNAL folks via H. Alvarez
%  * L1 phase advance per FODO cell lowered to 45 degrees
%  * cryomodule BPMs will be button-type ... rename RFB* -> BPM*
%  * shorten 3.9 GHz CMs and remove QUAD/BPM/corrector packages
% ------------------------------------------------------------------------------
% 25-APR-2014, M. Woodley
%  * new cryomodule layout per FNAL folks via H. Alvarez
%  * add HOM absorber MARKERs (HOMCM*)
% ------------------------------------------------------------------------------
% 27-MAR-2014, M. Woodley
%  * all cryomodules now have standard Q/XC/YC/BPM package
%  * remove COUPLER MARKer points
%  * add CM34/CM35 energy feedback phase "kink"
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% 19-FEB-2014, M. Woodley
%  * updated cryomodule layout
%  * 3.9 GHz linearizer is now 2 standard cryostats with 8 cavities each
% ------------------------------------------------------------------------------
% 07-JAN-2014, M. Woodley
%    Energy profile (CM01 amplitudes and phases) per P. Emma (20-DEC-2013)
% ------------------------------------------------------------------------------
% 30-OCT-2013, M. Woodley
%    LCLS2sc v1.2
% ------------------------------------------------------------------------------
% ==============================================================================
% LCAV
% ------------------------------------------------------------------------------
% CM01 (L0), CM02 (L1), and CM03 (L1) cavities have individual power sources
% ------------------------------------------------------------------------------
LAMBDA =  CLIGHT/1.3E+09 ;%1.3 GHz wavelength
LCAVL =  9*LAMBDA/2 ;%1.3 GHz cavity active length
LCAVR =  70E-3/2    ;%1.3 GHz cavity iris radius
CCAVL =  LCAVL/3    ;%3.9 GHz cavity active length
CCAVR =  30E-3/2    ;%3.9 GHz cavity iris radius
LCAV52CP =  0.14035          ;%cavity #5 center to support post
LCAVLA =  LCAVL/2+LCAV52CP ;%cavity #5 length u/s of support post
LCAVLB =  LCAVL-LCAVLA     ;%cavity #5 length d/s of support post
CCAV22CP =  0.11262          ;%support post to cavity #2 center
CCAVLA =  CCAVL/2-CCAV22CP ;%cavity #2 length u/s of support post
CCAVLB =  CCAVL-CCAVLA     ;%cavity #2 length d/s of support post
FRACL1 =     0.993584966016 ;%100*(1-FracL1)= L1 overhead (%)
GRADL1 =    11.1*FRACL1;
PHASL1 =   -19.2;
GHCAV =     9.053035;
PHCAV =  -148.97;
FRACL2 =     0.986958273387 ;%100*(1-FracL2)= L2 overhead (%)
GRADL2 =    14.9*FRACL2;
PHASL2 =   -20.75;
FRACL3 =     0.944734910147 ;%100*(1-FracL3)= L3 overhead (%)
GRADL3 =    15.3*FRACL3;
PHASL3 =     0.0;
%VALUE, 100*(1-FracL1),100*(1-FracL2),100*(1-FracL3)
% L0 (new settings from reference 100 pC Astra run July 2017 per C. Mayes)
% Maximum E_z in MV/m from Astra optimization
L011_SCALE =  15.8;
L012_SCALE =   0   ;% off
L013_SCALE =   0   ;% off
L014_SCALE =  28   ;
L015_SCALE =  32 ;
L016_SCALE =  32;
L017_SCALE =  32;
L018_SCALE =  32 ;
% Phases (deg)
P011 =  -4.0;
P012 =   0 ;
P013 =   0 ;
P014 =   0;
P015 =   0;
P016 =   0;
P017 =   1.25;
P018 =   6.0;
% Fix scaling to end up with final injection energy Ei:   
L0_FACTOR1 =  L011_SCALE*cos(RADDEG*P011)+ L012_SCALE*cos(RADDEG*P012)+ L013_SCALE*cos(RADDEG*P013)+ L014_SCALE*cos(RADDEG*P014)  ;
L0_FACTOR2 =  L015_SCALE*cos(RADDEG*P015)+ L016_SCALE*cos(RADDEG*P016)+ L017_SCALE*cos(RADDEG*P017)+ L018_SCALE*cos(RADDEG*P018)    ;
%L0_scale := 1.0E3*(Ei-(E0+MC2))/(L0_factor1+L0_factor2)/LcavL
L0_SCALE =  1.0E3*(EI- E0     )/(L0_FACTOR1+L0_FACTOR2)/LCAVL;
G011 =  L011_SCALE*L0_SCALE ;
G012 =  L012_SCALE*L0_SCALE ;
G013 =  L013_SCALE*L0_SCALE ;
G014 =  L014_SCALE*L0_SCALE ;
G015 =  L015_SCALE*L0_SCALE ;
G016 =  L016_SCALE*L0_SCALE ;
G017 =  L017_SCALE*L0_SCALE ;
G018 =  L018_SCALE*L0_SCALE ;
CAVL011={'lc' 'CAVL011' LCAVL [1300 G011*LCAVL P011/360*TWOPI]}';
CAVL012={'lc' 'CAVL012' LCAVL [1300 G012*LCAVL P012/360*TWOPI]}';
CAVL013={'lc' 'CAVL013' LCAVL [1300 G013*LCAVL P013/360*TWOPI]}';
CAVL014={'lc' 'CAVL014' LCAVL [1300 G014*LCAVL P014/360*TWOPI]}';
CAVL015A={'lc' 'CAVL015A' LCAVLA [1300 G015*LCAVLA P015/360*TWOPI]}';
CAVL015B={'lc' 'CAVL015B' LCAVLB [1300 G015*LCAVLB P015/360*TWOPI]}';
CAVL016={'lc' 'CAVL016' LCAVL [1300 G016*LCAVL P016/360*TWOPI]}';
CAVL017={'lc' 'CAVL017' LCAVL [1300 G017*LCAVL P017/360*TWOPI]}';
CAVL018={'lc' 'CAVL018' LCAVL [1300 G018*LCAVL P018/360*TWOPI]}';
% L1
G021 =  GRADL1 ;
P021 =  PHASL1;
G022 =  GRADL1 ;
P022 =  PHASL1;
G023 =  GRADL1 ;
P023 =  PHASL1;
G024 =  GRADL1 ;
P024 =  PHASL1;
G025 =  GRADL1 ;
P025 =  PHASL1;
G026 =  GRADL1 ;
P026 =  PHASL1;
G027 =  GRADL1 ;
P027 =  PHASL1;
G028 =  GRADL1 ;
P028 =  PHASL1;
CAVL021={'lc' 'CAVL021' LCAVL [1300 G021*LCAVL P021/360*TWOPI]}';
CAVL022={'lc' 'CAVL022' LCAVL [1300 G022*LCAVL P022/360*TWOPI]}';
CAVL023={'lc' 'CAVL023' LCAVL [1300 G023*LCAVL P023/360*TWOPI]}';
CAVL024={'lc' 'CAVL024' LCAVL [1300 G024*LCAVL P024/360*TWOPI]}';
CAVL025A={'lc' 'CAVL025A' LCAVLA [1300 G025*LCAVLA P025/360*TWOPI]}';
CAVL025B={'lc' 'CAVL025B' LCAVLB [1300 G025*LCAVLB P025/360*TWOPI]}';
CAVL026={'lc' 'CAVL026' LCAVL [1300 G026*LCAVL P026/360*TWOPI]}';
CAVL027={'lc' 'CAVL027' LCAVL [1300 G027*LCAVL P027/360*TWOPI]}';
CAVL028={'lc' 'CAVL028' LCAVL [1300 G028*LCAVL P028/360*TWOPI]}';
G031 =  GRADL1 ;
P031 =  PHASL1;
G032 =  GRADL1 ;
P032 =  PHASL1;
G033 =  GRADL1 ;
P033 =  PHASL1;
G034 =  GRADL1 ;
P034 =  PHASL1;
G035 =  GRADL1 ;
P035 =  PHASL1;
G036 =  GRADL1 ;
P036 =  PHASL1;
G037 =  GRADL1 ;
P037 =  PHASL1;
G038 =  GRADL1 ;
P038 =  PHASL1;
CAVL031={'lc' 'CAVL031' LCAVL [1300 G031*LCAVL P031/360*TWOPI]}';
CAVL032={'lc' 'CAVL032' LCAVL [1300 G032*LCAVL P032/360*TWOPI]}';
CAVL033={'lc' 'CAVL033' LCAVL [1300 G033*LCAVL P033/360*TWOPI]}';
CAVL034={'lc' 'CAVL034' LCAVL [1300 G034*LCAVL P034/360*TWOPI]}';
CAVL035A={'lc' 'CAVL035A' LCAVLA [1300 G035*LCAVLA P035/360*TWOPI]}';
CAVL035B={'lc' 'CAVL035B' LCAVLB [1300 G035*LCAVLB P035/360*TWOPI]}';
CAVL036={'lc' 'CAVL036' LCAVL [1300 G036*LCAVL P036/360*TWOPI]}';
CAVL037={'lc' 'CAVL037' LCAVL [1300 G037*LCAVL P037/360*TWOPI]}';
CAVL038={'lc' 'CAVL038' LCAVL [1300 G038*LCAVL P038/360*TWOPI]}';
% 3rd harmonic linearizer
CAVC011={'lc' 'CAVC011' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC012A={'lc' 'CAVC012A' CCAVLA [3900 GHCAV*CCAVLA PHCAV/360*TWOPI]}';
CAVC012B={'lc' 'CAVC012B' CCAVLB [3900 GHCAV*CCAVLB PHCAV/360*TWOPI]}';
CAVC013={'lc' 'CAVC013' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC014={'lc' 'CAVC014' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC015={'lc' 'CAVC015' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC016={'lc' 'CAVC016' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC017={'lc' 'CAVC017' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC018={'lc' 'CAVC018' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC021={'lc' 'CAVC021' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC022A={'lc' 'CAVC022A' CCAVLA [3900 GHCAV*CCAVLA PHCAV/360*TWOPI]}';
CAVC022B={'lc' 'CAVC022B' CCAVLB [3900 GHCAV*CCAVLB PHCAV/360*TWOPI]}';
CAVC023={'lc' 'CAVC023' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC024={'lc' 'CAVC024' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC025={'lc' 'CAVC025' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC026={'lc' 'CAVC026' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC027={'lc' 'CAVC027' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC028={'lc' 'CAVC028' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
% L2
CAVL041={'lc' 'CAVL041' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL042={'lc' 'CAVL042' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL043={'lc' 'CAVL043' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL044={'lc' 'CAVL044' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL045A={'lc' 'CAVL045A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL045B={'lc' 'CAVL045B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL046={'lc' 'CAVL046' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL047={'lc' 'CAVL047' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL048={'lc' 'CAVL048' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL051={'lc' 'CAVL051' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL052={'lc' 'CAVL052' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL053={'lc' 'CAVL053' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL054={'lc' 'CAVL054' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL055A={'lc' 'CAVL055A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL055B={'lc' 'CAVL055B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL056={'lc' 'CAVL056' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL057={'lc' 'CAVL057' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL058={'lc' 'CAVL058' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL061={'lc' 'CAVL061' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL062={'lc' 'CAVL062' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL063={'lc' 'CAVL063' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL064={'lc' 'CAVL064' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL065A={'lc' 'CAVL065A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL065B={'lc' 'CAVL065B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL066={'lc' 'CAVL066' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL067={'lc' 'CAVL067' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL068={'lc' 'CAVL068' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL071={'lc' 'CAVL071' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL072={'lc' 'CAVL072' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL073={'lc' 'CAVL073' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL074={'lc' 'CAVL074' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL075A={'lc' 'CAVL075A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL075B={'lc' 'CAVL075B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL076={'lc' 'CAVL076' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL077={'lc' 'CAVL077' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL078={'lc' 'CAVL078' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL081={'lc' 'CAVL081' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL082={'lc' 'CAVL082' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL083={'lc' 'CAVL083' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL084={'lc' 'CAVL084' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL085A={'lc' 'CAVL085A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL085B={'lc' 'CAVL085B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL086={'lc' 'CAVL086' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL087={'lc' 'CAVL087' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL088={'lc' 'CAVL088' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL091={'lc' 'CAVL091' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL092={'lc' 'CAVL092' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL093={'lc' 'CAVL093' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL094={'lc' 'CAVL094' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL095A={'lc' 'CAVL095A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL095B={'lc' 'CAVL095B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL096={'lc' 'CAVL096' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL097={'lc' 'CAVL097' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL098={'lc' 'CAVL098' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL101={'lc' 'CAVL101' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL102={'lc' 'CAVL102' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL103={'lc' 'CAVL103' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL104={'lc' 'CAVL104' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL105A={'lc' 'CAVL105A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL105B={'lc' 'CAVL105B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL106={'lc' 'CAVL106' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL107={'lc' 'CAVL107' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL108={'lc' 'CAVL108' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL111={'lc' 'CAVL111' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL112={'lc' 'CAVL112' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL113={'lc' 'CAVL113' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL114={'lc' 'CAVL114' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL115A={'lc' 'CAVL115A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL115B={'lc' 'CAVL115B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL116={'lc' 'CAVL116' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL117={'lc' 'CAVL117' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL118={'lc' 'CAVL118' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL121={'lc' 'CAVL121' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL122={'lc' 'CAVL122' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL123={'lc' 'CAVL123' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL124={'lc' 'CAVL124' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL125A={'lc' 'CAVL125A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL125B={'lc' 'CAVL125B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL126={'lc' 'CAVL126' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL127={'lc' 'CAVL127' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL128={'lc' 'CAVL128' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL131={'lc' 'CAVL131' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL132={'lc' 'CAVL132' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL133={'lc' 'CAVL133' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL134={'lc' 'CAVL134' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL135A={'lc' 'CAVL135A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL135B={'lc' 'CAVL135B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL136={'lc' 'CAVL136' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL137={'lc' 'CAVL137' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL138={'lc' 'CAVL138' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL141={'lc' 'CAVL141' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL142={'lc' 'CAVL142' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL143={'lc' 'CAVL143' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL144={'lc' 'CAVL144' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL145A={'lc' 'CAVL145A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL145B={'lc' 'CAVL145B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL146={'lc' 'CAVL146' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL147={'lc' 'CAVL147' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL148={'lc' 'CAVL148' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL151={'lc' 'CAVL151' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL152={'lc' 'CAVL152' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL153={'lc' 'CAVL153' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL154={'lc' 'CAVL154' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL155A={'lc' 'CAVL155A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL155B={'lc' 'CAVL155B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL156={'lc' 'CAVL156' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL157={'lc' 'CAVL157' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL158={'lc' 'CAVL158' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
% L3
CAVL161={'lc' 'CAVL161' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL162={'lc' 'CAVL162' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL163={'lc' 'CAVL163' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL164={'lc' 'CAVL164' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL165A={'lc' 'CAVL165A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL165B={'lc' 'CAVL165B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL166={'lc' 'CAVL166' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL167={'lc' 'CAVL167' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL168={'lc' 'CAVL168' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL171={'lc' 'CAVL171' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL172={'lc' 'CAVL172' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL173={'lc' 'CAVL173' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL174={'lc' 'CAVL174' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL175A={'lc' 'CAVL175A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL175B={'lc' 'CAVL175B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL176={'lc' 'CAVL176' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL177={'lc' 'CAVL177' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL178={'lc' 'CAVL178' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL181={'lc' 'CAVL181' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL182={'lc' 'CAVL182' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL183={'lc' 'CAVL183' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL184={'lc' 'CAVL184' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL185A={'lc' 'CAVL185A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL185B={'lc' 'CAVL185B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL186={'lc' 'CAVL186' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL187={'lc' 'CAVL187' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL188={'lc' 'CAVL188' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL191={'lc' 'CAVL191' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL192={'lc' 'CAVL192' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL193={'lc' 'CAVL193' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL194={'lc' 'CAVL194' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL195A={'lc' 'CAVL195A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL195B={'lc' 'CAVL195B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL196={'lc' 'CAVL196' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL197={'lc' 'CAVL197' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL198={'lc' 'CAVL198' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL201={'lc' 'CAVL201' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL202={'lc' 'CAVL202' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL203={'lc' 'CAVL203' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL204={'lc' 'CAVL204' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL205A={'lc' 'CAVL205A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL205B={'lc' 'CAVL205B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL206={'lc' 'CAVL206' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL207={'lc' 'CAVL207' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL208={'lc' 'CAVL208' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL211={'lc' 'CAVL211' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL212={'lc' 'CAVL212' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL213={'lc' 'CAVL213' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL214={'lc' 'CAVL214' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL215A={'lc' 'CAVL215A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL215B={'lc' 'CAVL215B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL216={'lc' 'CAVL216' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL217={'lc' 'CAVL217' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL218={'lc' 'CAVL218' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL221={'lc' 'CAVL221' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL222={'lc' 'CAVL222' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL223={'lc' 'CAVL223' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL224={'lc' 'CAVL224' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL225A={'lc' 'CAVL225A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL225B={'lc' 'CAVL225B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL226={'lc' 'CAVL226' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL227={'lc' 'CAVL227' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL228={'lc' 'CAVL228' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL231={'lc' 'CAVL231' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL232={'lc' 'CAVL232' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL233={'lc' 'CAVL233' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL234={'lc' 'CAVL234' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL235A={'lc' 'CAVL235A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL235B={'lc' 'CAVL235B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL236={'lc' 'CAVL236' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL237={'lc' 'CAVL237' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL238={'lc' 'CAVL238' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL241={'lc' 'CAVL241' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL242={'lc' 'CAVL242' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL243={'lc' 'CAVL243' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL244={'lc' 'CAVL244' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL245A={'lc' 'CAVL245A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL245B={'lc' 'CAVL245B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL246={'lc' 'CAVL246' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL247={'lc' 'CAVL247' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL248={'lc' 'CAVL248' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL251={'lc' 'CAVL251' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL252={'lc' 'CAVL252' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL253={'lc' 'CAVL253' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL254={'lc' 'CAVL254' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL255A={'lc' 'CAVL255A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL255B={'lc' 'CAVL255B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL256={'lc' 'CAVL256' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL257={'lc' 'CAVL257' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL258={'lc' 'CAVL258' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL261={'lc' 'CAVL261' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL262={'lc' 'CAVL262' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL263={'lc' 'CAVL263' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL264={'lc' 'CAVL264' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL265A={'lc' 'CAVL265A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL265B={'lc' 'CAVL265B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL266={'lc' 'CAVL266' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL267={'lc' 'CAVL267' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL268={'lc' 'CAVL268' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL271={'lc' 'CAVL271' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL272={'lc' 'CAVL272' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL273={'lc' 'CAVL273' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL274={'lc' 'CAVL274' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL275A={'lc' 'CAVL275A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL275B={'lc' 'CAVL275B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL276={'lc' 'CAVL276' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL277={'lc' 'CAVL277' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL278={'lc' 'CAVL278' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL281={'lc' 'CAVL281' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL282={'lc' 'CAVL282' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL283={'lc' 'CAVL283' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL284={'lc' 'CAVL284' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL285A={'lc' 'CAVL285A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL285B={'lc' 'CAVL285B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL286={'lc' 'CAVL286' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL287={'lc' 'CAVL287' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL288={'lc' 'CAVL288' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL291={'lc' 'CAVL291' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL292={'lc' 'CAVL292' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL293={'lc' 'CAVL293' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL294={'lc' 'CAVL294' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL295A={'lc' 'CAVL295A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL295B={'lc' 'CAVL295B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL296={'lc' 'CAVL296' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL297={'lc' 'CAVL297' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL298={'lc' 'CAVL298' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL301={'lc' 'CAVL301' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL302={'lc' 'CAVL302' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL303={'lc' 'CAVL303' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL304={'lc' 'CAVL304' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL305A={'lc' 'CAVL305A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL305B={'lc' 'CAVL305B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL306={'lc' 'CAVL306' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL307={'lc' 'CAVL307' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL308={'lc' 'CAVL308' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL311={'lc' 'CAVL311' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL312={'lc' 'CAVL312' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL313={'lc' 'CAVL313' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL314={'lc' 'CAVL314' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL315A={'lc' 'CAVL315A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL315B={'lc' 'CAVL315B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL316={'lc' 'CAVL316' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL317={'lc' 'CAVL317' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL318={'lc' 'CAVL318' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL321={'lc' 'CAVL321' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL322={'lc' 'CAVL322' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL323={'lc' 'CAVL323' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL324={'lc' 'CAVL324' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL325A={'lc' 'CAVL325A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL325B={'lc' 'CAVL325B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL326={'lc' 'CAVL326' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL327={'lc' 'CAVL327' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL328={'lc' 'CAVL328' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL331={'lc' 'CAVL331' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL332={'lc' 'CAVL332' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL333={'lc' 'CAVL333' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL334={'lc' 'CAVL334' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL335A={'lc' 'CAVL335A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL335B={'lc' 'CAVL335B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL336={'lc' 'CAVL336' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL337={'lc' 'CAVL337' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL338={'lc' 'CAVL338' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL341={'lc' 'CAVL341' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL342={'lc' 'CAVL342' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL343={'lc' 'CAVL343' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL344={'lc' 'CAVL344' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL345A={'lc' 'CAVL345A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL345B={'lc' 'CAVL345B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL346={'lc' 'CAVL346' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL347={'lc' 'CAVL347' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL348={'lc' 'CAVL348' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL351={'lc' 'CAVL351' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL352={'lc' 'CAVL352' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL353={'lc' 'CAVL353' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL354={'lc' 'CAVL354' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL355A={'lc' 'CAVL355A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL355B={'lc' 'CAVL355B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL356={'lc' 'CAVL356' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL357={'lc' 'CAVL357' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL358={'lc' 'CAVL358' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
% define unsplit LCAVs for BMAD ... not used by MAD
CAVL015={'lc' 'CAVL015' LCAVL [1300 G015*LCAVL P015/360*TWOPI]}';
CAVL025={'lc' 'CAVL025' LCAVL [1300 G025*LCAVL P025/360*TWOPI]}';
CAVL035={'lc' 'CAVL035' LCAVL [1300 G035*LCAVL P035/360*TWOPI]}';
CAVC012={'lc' 'CAVC012' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC022={'lc' 'CAVC022' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVL045={'lc' 'CAVL045' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL055={'lc' 'CAVL055' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL065={'lc' 'CAVL065' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL075={'lc' 'CAVL075' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL085={'lc' 'CAVL085' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL095={'lc' 'CAVL095' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL105={'lc' 'CAVL105' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL115={'lc' 'CAVL115' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL125={'lc' 'CAVL125' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL135={'lc' 'CAVL135' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL145={'lc' 'CAVL145' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL155={'lc' 'CAVL155' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL165={'lc' 'CAVL165' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL175={'lc' 'CAVL175' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL185={'lc' 'CAVL185' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL195={'lc' 'CAVL195' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL205={'lc' 'CAVL205' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL215={'lc' 'CAVL215' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL225={'lc' 'CAVL225' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL235={'lc' 'CAVL235' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL245={'lc' 'CAVL245' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL255={'lc' 'CAVL255' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL265={'lc' 'CAVL265' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL275={'lc' 'CAVL275' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL285={'lc' 'CAVL285' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL295={'lc' 'CAVL295' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL305={'lc' 'CAVL305' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL315={'lc' 'CAVL315' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL325={'lc' 'CAVL325' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL335={'lc' 'CAVL335' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL345={'lc' 'CAVL345' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL355={'lc' 'CAVL355' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
LCMQ =  0.23     ;%cryomodule quadrupole length
RCMQ =  0.0762/2 ;%cryomodule quadrupole pole-tip radius
KQCMFODO1 =  0.274030631043 ;%L1: 45 degrees/cell
KQCMFODO2 =  0.185334132537 ;%L2: 30 degrees/cell
KQCMFODO3 =  0.185334132537 ;%L3: 30 degrees/cell
% L0
KQCM01 =  0.378216482077;
QCM01={'qu' 'QCM01' LCMQ/2 [KQCM01 0]}';
% L1
QCM02={'qu' 'QCM02' LCMQ/2 [-0.350806201565 0]}';%-KQCMfodo1
QCM03={'qu' 'QCM03' LCMQ/2 [0.239632137591 0]}';% KQCMfodo1
% L2
QCM04={'qu' 'QCM04' LCMQ/2 [-0.337961546545 0]}';%-KQCMfodo2
QCM05={'qu' 'QCM05' LCMQ/2 [0.30139383074 0]}';% KQCMfodo2
QCM06={'qu' 'QCM06' LCMQ/2 [-0.198247592192 0]}';%-KQCMfodo2
QCM07={'qu' 'QCM07' LCMQ/2 [0.171374449674 0]}';% KQCMfodo2
QCM08={'qu' 'QCM08' LCMQ/2 [-0.171719110376 0]}';%-KQCMfodo2
QCM09={'qu' 'QCM09' LCMQ/2 [0.174074499825 0]}';% KQCMfodo2
QCM10={'qu' 'QCM10' LCMQ/2 [-0.174836643588 0]}';%-KQCMfodo2
QCM11={'qu' 'QCM11' LCMQ/2 [0.17644901691 0]}';% KQCMfodo2
QCM12={'qu' 'QCM12' LCMQ/2 [-0.18155309543 0]}';%-KQCMfodo2
QCM13={'qu' 'QCM13' LCMQ/2 [0.062968974993 0]}';% KQCMfodo2
QCM14={'qu' 'QCM14' LCMQ/2 [-0.176070484188 0]}';%-KQCMfodo2
QCM15={'qu' 'QCM15' LCMQ/2 [0.067235224899 0]}';% KQCMfodo2
% L3
QCM16={'qu' 'QCM16' LCMQ/2 [-0.31666848621 0]}';%-KQCMfodo3
QCM17={'qu' 'QCM17' LCMQ/2 [0.258400025673 0]}';% KQCMfodo3
QCM18={'qu' 'QCM18' LCMQ/2 [-0.210508915512 0]}';%-KQCMfodo3
QCM19={'qu' 'QCM19' LCMQ/2 [0.193498338579 0]}';% KQCMfodo3
QCM20={'qu' 'QCM20' LCMQ/2 [-0.187169022347 0]}';%-KQCMfodo3
QCM21={'qu' 'QCM21' LCMQ/2 [KQCMFODO3 0]}';
QCM22={'qu' 'QCM22' LCMQ/2 [-KQCMFODO3 0]}';
QCM23={'qu' 'QCM23' LCMQ/2 [KQCMFODO3 0]}';
QCM24={'qu' 'QCM24' LCMQ/2 [-0.190499689137 0]}';%-KQCMfodo3
QCM25={'qu' 'QCM25' LCMQ/2 [0.181764322884 0]}';% KQCMfodo3
QCM26={'qu' 'QCM26' LCMQ/2 [-0.181491332716 0]}';%-KQCMfodo3
QCM27={'qu' 'QCM27' LCMQ/2 [0.190245621978 0]}';% KQCMfodo3
QCM28={'qu' 'QCM28' LCMQ/2 [-KQCMFODO3 0]}';
QCM29={'qu' 'QCM29' LCMQ/2 [0.185719761499 0]}';% KQCMfodo3
QCM30={'qu' 'QCM30' LCMQ/2 [-0.188023739048 0]}';%-KQCMfodo3
QCM31={'qu' 'QCM31' LCMQ/2 [0.194636646982 0]}';% KQCMfodo3
QCM32={'qu' 'QCM32' LCMQ/2 [-0.211302280779 0]}';%-KQCMfodo3
QCM33={'qu' 'QCM33' LCMQ/2 [0.258254876336 0]}';% KQCMfodo3
QCM34={'qu' 'QCM34' LCMQ/2 [-0.246773847976 0]}';%-KQCMfodo3
QCM35={'qu' 'QCM35' LCMQ/2 [0.0 0]}';% KQCMfodo3
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% 1.3 GHz cryomodule
% ------------------------------------------------------------------------------
% from Joshua Kaluzny spreadsheet (2015_11_19)
LGV2CAV =  0.79731 ;%u/s gate valve to cavity #1    0.79981
LCAV2CAV =  1.38360 ;%intra-CM cavity to cavity
LCAV2BPM =  0.81139 ;%cavity #8 to BPM
LBPM2QUAD =  0.26444 ;%BPM to quadrupole
LQUAD2GV =  0.35186 ;%quadrupole to d/s gate valve   0.35436
LGV2HOM =  0.16577 ;%d/s gate valve to HOM absorber 0.16327
LHOM2GV =  0.14442 ;%HOM absorber to u/s gate valve 0.14192
% derived dimensions
LCAV2QUAD =  LCAV2BPM+LBPM2QUAD     ;%cavity #8 quadrupole
LCAV2GV =  LCAV2QUAD+LQUAD2GV     ;%cavity #8 to d/s gate valve
LCAV2HOM =  LCAV2GV+LGV2HOM        ;%cavity #8 to HOM absorber
LGV2GV =  LGV2HOM+LHOM2GV        ;%d/s gate valve to u/s gate valve
LCM2CM =  LCAV2GV+LGV2GV+LGV2CAV ;%inter-CM cavity-to-cavity
% cryomodule drifts
DCM1={'dr' '' LGV2CAV-LCAVL/2 []}';
DCM2={'dr' '' LCAV2CAV-LCAVL []}';
DCM3={'dr' '' LCAV2BPM-LCAVL/2 []}';
DCM4={'dr' '' LBPM2QUAD-LCMQ/2 []}';
DCM5={'dr' '' LQUAD2GV-LCMQ/2 []}';
DCMCM1={'dr' '' LGV2HOM []}';
DCMCM2={'dr' '' LHOM2GV []}';
DCM4B={'dr' '' 0.03 []}';
DCM4A={'dr' '' DCM4{3}-DCM4B{3} []}';
% ------------------------------------------------------------------------------
% 1.3 GHz cryomodule to 3.9 GHz cryomodule
% ------------------------------------------------------------------------------
LHOM2HGV =  0.14282 ;%HOM absorber to u/s gate valve 0.17021
DCMCMH1={'dr' '' LGV2HOM []}';
DCMCMH2={'dr' '' LHOM2HGV []}';
% ------------------------------------------------------------------------------
% 3.9 GHz cryomodule dimensions
% ------------------------------------------------------------------------------
% new (18-May-16)
LGV2HCAV =  1.14660 ;%u/s gate valve to cavity #1
LHCAV2HCAV =  0.63416 ;%intra-CMH cavity to cavity
LHCAV2BPM =  0.49684 ;%cavity #8 to BPM
LHBPM2GV =  0.16449 ;%BPM to d/s gate valve (no magnet package)
LHGV2HHOM =  0.16888 ;%d/s gate valve to HOM absorber
LHHOM2HGV =  0.13857 ;%HOM absorber to u/s gate valve
% derived dimensions
LHCAV2GV =  LHCAV2BPM+LHBPM2GV ;%cavity #8 to d/s gate valve
% cryomodule drifts
DCMH0={'dr' '' 1.14662-CCAVL/2 []}';
DCMH1={'dr' '' LGV2HCAV-CCAVL/2 []}';
DCMH2={'dr' '' LHCAV2HCAV-CCAVL []}';
DCMH3={'dr' '' LHCAV2BPM-CCAVL/2 []}';
DCMH4={'dr' '' LHBPM2GV []}';
DCMHCMH1={'dr' '' LHGV2HHOM []}';
DCMHCMH2={'dr' '' LHHOM2HGV []}';
% ------------------------------------------------------------------------------
% end caps, stay-clears, and L3 vacuum break
% ------------------------------------------------------------------------------
% end cap and feed cap dimensions, mechanical stay-clear, and differential
% vacuum pumping stay-clear (mostly from drawing SD-375-000-99-02)
DCAP0U={'dr' '' 0.49294 []}';%EC-U to CSP01 = 6.965000 0.49044
DCAP0D={'dr' '' 1.89015 []}';%CSP01 to FC-1 = 7.328290 1.88765
DMSC0D={'dr' '' 1.829 []}';
DPSC1U={'dr' '' 2.52295 []}';
DMSC1U={'dr' '' 1.829 []}';
DCAP1U={'dr' '' 0.87294 []}';%FC-2 to CSP02 = 7.345000 0.87044
DCAP1D={'dr' '' 1.75429 []}';%CSPH2 to FC-3 = 6.333200
DMSC1D={'dr' '' 1.829 []}';
DPSC1D={'dr' '' 1.91205 []}';%1.91297
DPSC2U={'dr' '' 2.1388 []}';
DMSC2U={'dr' '' 1.829 []}';
DCAP2U={'dr' '' 0.87294 []}';%FC-4 to CSP04 = 7.345000 0.87044
DCAP2D={'dr' '' 1.58968 []}';%CSP15 to FC-5 = 7.193590
DMSC2D={'dr' '' 1.829 []}';
DPSC2D={'dr' '' 1.91806 []}';
DPSC3U={'dr' '' 2.32295 []}';
DMSC3U={'dr' '' 1.829 []}';
DCAP3U={'dr' '' 0.87294 []}';%FC-6 to CSP16 = 7.345000 0.87044
DBREAK={'dr' '' 2.54931 []}';
DCAP3D={'dr' '' 1.72438 []}';%CSP35 to EC-D = 7.328290
DMSC3D={'dr' '' 1.464 []}';
DPSC3D={'dr' '' 2.67004 []}';
% beamline flanges
LBLF =  0.0889 ;%beamline flange to cap face (m)
DMSC1UB={'dr' '' LBLF []}';
DMSC1UA={'dr' '' DMSC1U{3}-DMSC1UB{3} []}';
DMSC1DA={'dr' '' LBLF []}';
DMSC1DB={'dr' '' DMSC1D{3}-DMSC1DA{3} []}';
DMSC2UB={'dr' '' LBLF []}';
DMSC2UA={'dr' '' DMSC2U{3}-DMSC2UB{3} []}';
DMSC2DA={'dr' '' LBLF []}';
DMSC2DB={'dr' '' DMSC2D{3}-DMSC2DA{3} []}';
DMSC3UB={'dr' '' LBLF []}';
DMSC3UA={'dr' '' DMSC3U{3}-DMSC3UB{3} []}';
DMSC3DA={'dr' '' LBLF []}';
DMSC3DB={'dr' '' DMSC3D{3}-DMSC3DA{3} []}';
% split L0 downstream endcap drift for ASTRA treaty point (15 m from cathode)
LASTRA =  0.378513;
DCAP0DA={'dr' '' LASTRA []}';
DCAP0DB={'dr' '' DCAP0D{3}-DCMCM1{3}-DCAP0DA{3} []}';
% vacuum components after L0 endcap
DMSC0DA={'dr' '' LBLF []}';
DMSC0DB={'dr' '' 1.231893 []}';
DMSC0DC={'dr' '' 0.1016 []}';
DMSC0DD={'dr' '' 0.156107 []}';
DMSC0DE={'dr' '' DMSC0D{3}-DMSC0DA{3}-DMSC0DB{3}-DMSC0DC{3}-DMSC0DD{3} []}';
% miscellaneous definitions
LCRYOL =  DCM1{3}+8*LCAVL+7*DCM2{3}+DCM3{3}+DCM4{3}+LCMQ+DCM5{3};
LCRYOC =  DCMH1{3}+8*CCAVL+7*DCMH2{3}+DCMH3{3}+DCMH4{3};
LDCMFODO =  LCRYOL+LGV2GV-LCMQ;
% 
% 
% 
% 

% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
CMB01={'mo' 'CMB01' 0 []}';
CMB02={'mo' 'CMB02' 0 []}';
CMB03={'mo' 'CMB03' 0 []}';
CMBH1={'mo' 'CMBH1' 0 []}';
CMBH2={'mo' 'CMBH2' 0 []}';
CMB04={'mo' 'CMB04' 0 []}';
CMB05={'mo' 'CMB05' 0 []}';
CMB06={'mo' 'CMB06' 0 []}';
CMB07={'mo' 'CMB07' 0 []}';
CMB08={'mo' 'CMB08' 0 []}';
CMB09={'mo' 'CMB09' 0 []}';
CMB10={'mo' 'CMB10' 0 []}';
CMB11={'mo' 'CMB11' 0 []}';
CMB12={'mo' 'CMB12' 0 []}';
CMB13={'mo' 'CMB13' 0 []}';
CMB14={'mo' 'CMB14' 0 []}';
CMB15={'mo' 'CMB15' 0 []}';
CMB16={'mo' 'CMB16' 0 []}';
CMB17={'mo' 'CMB17' 0 []}';
CMB18={'mo' 'CMB18' 0 []}';
CMB19={'mo' 'CMB19' 0 []}';
CMB20={'mo' 'CMB20' 0 []}';
CMB21={'mo' 'CMB21' 0 []}';
CMB22={'mo' 'CMB22' 0 []}';
CMB23={'mo' 'CMB23' 0 []}';
CMB24={'mo' 'CMB24' 0 []}';
CMB25={'mo' 'CMB25' 0 []}';
CMB26={'mo' 'CMB26' 0 []}';
CMB27={'mo' 'CMB27' 0 []}';
CMB28={'mo' 'CMB28' 0 []}';
CMB29={'mo' 'CMB29' 0 []}';
CMB30={'mo' 'CMB30' 0 []}';
CMB31={'mo' 'CMB31' 0 []}';
CMB32={'mo' 'CMB32' 0 []}';
CMB33={'mo' 'CMB33' 0 []}';
CMB34={'mo' 'CMB34' 0 []}';
CMB35={'mo' 'CMB35' 0 []}';
RFB2C00={'mo' 'RFB2C00' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCM01={'mo' 'XCM01' 0 []}';
XCM02={'mo' 'XCM02' 0 []}';
XCM03={'mo' 'XCM03' 0 []}';
XCM04={'mo' 'XCM04' 0 []}';
XCM05={'mo' 'XCM05' 0 []}';
XCM06={'mo' 'XCM06' 0 []}';
XCM07={'mo' 'XCM07' 0 []}';
XCM08={'mo' 'XCM08' 0 []}';
XCM09={'mo' 'XCM09' 0 []}';
XCM10={'mo' 'XCM10' 0 []}';
XCM11={'mo' 'XCM11' 0 []}';
XCM12={'mo' 'XCM12' 0 []}';
XCM13={'mo' 'XCM13' 0 []}';
XCM14={'mo' 'XCM14' 0 []}';
XCM15={'mo' 'XCM15' 0 []}';
XCM16={'mo' 'XCM16' 0 []}';
XCM17={'mo' 'XCM17' 0 []}';
XCM18={'mo' 'XCM18' 0 []}';
XCM19={'mo' 'XCM19' 0 []}';
XCM20={'mo' 'XCM20' 0 []}';
XCM21={'mo' 'XCM21' 0 []}';
XCM22={'mo' 'XCM22' 0 []}';
XCM23={'mo' 'XCM23' 0 []}';
XCM24={'mo' 'XCM24' 0 []}';
XCM25={'mo' 'XCM25' 0 []}';
XCM26={'mo' 'XCM26' 0 []}';
XCM27={'mo' 'XCM27' 0 []}';
XCM28={'mo' 'XCM28' 0 []}';
XCM29={'mo' 'XCM29' 0 []}';
XCM30={'mo' 'XCM30' 0 []}';
XCM31={'mo' 'XCM31' 0 []}';
XCM32={'mo' 'XCM32' 0 []}';
XCM33={'mo' 'XCM33' 0 []}';
XCM34={'mo' 'XCM34' 0 []}';
XCM35={'mo' 'XCM35' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCM01={'mo' 'YCM01' 0 []}';
YCM02={'mo' 'YCM02' 0 []}';
YCM03={'mo' 'YCM03' 0 []}';
YCM04={'mo' 'YCM04' 0 []}';
YCM05={'mo' 'YCM05' 0 []}';
YCM06={'mo' 'YCM06' 0 []}';
YCM07={'mo' 'YCM07' 0 []}';
YCM08={'mo' 'YCM08' 0 []}';
YCM09={'mo' 'YCM09' 0 []}';
YCM10={'mo' 'YCM10' 0 []}';
YCM11={'mo' 'YCM11' 0 []}';
YCM12={'mo' 'YCM12' 0 []}';
YCM13={'mo' 'YCM13' 0 []}';
YCM14={'mo' 'YCM14' 0 []}';
YCM15={'mo' 'YCM15' 0 []}';
YCM16={'mo' 'YCM16' 0 []}';
YCM17={'mo' 'YCM17' 0 []}';
YCM18={'mo' 'YCM18' 0 []}';
YCM19={'mo' 'YCM19' 0 []}';
YCM20={'mo' 'YCM20' 0 []}';
YCM21={'mo' 'YCM21' 0 []}';
YCM22={'mo' 'YCM22' 0 []}';
YCM23={'mo' 'YCM23' 0 []}';
YCM24={'mo' 'YCM24' 0 []}';
YCM25={'mo' 'YCM25' 0 []}';
YCM26={'mo' 'YCM26' 0 []}';
YCM27={'mo' 'YCM27' 0 []}';
YCM28={'mo' 'YCM28' 0 []}';
YCM29={'mo' 'YCM29' 0 []}';
YCM30={'mo' 'YCM30' 0 []}';
YCM31={'mo' 'YCM31' 0 []}';
YCM32={'mo' 'YCM32' 0 []}';
YCM33={'mo' 'YCM33' 0 []}';
YCM34={'mo' 'YCM34' 0 []}';
YCM35={'mo' 'YCM35' 0 []}';
% ==============================================================================
% MARK, etc.
% ------------------------------------------------------------------------------
CM01BEG={'mo' 'CM01BEG' 0 []}';
CSP01={'mo' 'CSP01' 0 []}';
CM01END={'mo' 'CM01END' 0 []}';
CM02BEG={'mo' 'CM02BEG' 0 []}';
CSP02={'mo' 'CSP02' 0 []}';
CM02END={'mo' 'CM02END' 0 []}';
CM03BEG={'mo' 'CM03BEG' 0 []}';
CSP03={'mo' 'CSP03' 0 []}';
CM03END={'mo' 'CM03END' 0 []}';
CMH1BEG={'mo' 'CMH1BEG' 0 []}';
CSPH1={'mo' 'CSPH1' 0 []}';
CMH1END={'mo' 'CMH1END' 0 []}';
CMH2BEG={'mo' 'CMH2BEG' 0 []}';
CSPH2={'mo' 'CSPH2' 0 []}';
CMH2END={'mo' 'CMH2END' 0 []}';
CM04BEG={'mo' 'CM04BEG' 0 []}';
CSP04={'mo' 'CSP04' 0 []}';
CM04END={'mo' 'CM04END' 0 []}';
CM05BEG={'mo' 'CM05BEG' 0 []}';
CSP05={'mo' 'CSP05' 0 []}';
CM05END={'mo' 'CM05END' 0 []}';
CM06BEG={'mo' 'CM06BEG' 0 []}';
CSP06={'mo' 'CSP06' 0 []}';
CM06END={'mo' 'CM06END' 0 []}';
CM07BEG={'mo' 'CM07BEG' 0 []}';
CSP07={'mo' 'CSP07' 0 []}';
CM07END={'mo' 'CM07END' 0 []}';
CM08BEG={'mo' 'CM08BEG' 0 []}';
CSP08={'mo' 'CSP08' 0 []}';
CM08END={'mo' 'CM08END' 0 []}';
CM09BEG={'mo' 'CM09BEG' 0 []}';
CSP09={'mo' 'CSP09' 0 []}';
CM09END={'mo' 'CM09END' 0 []}';
CM10BEG={'mo' 'CM10BEG' 0 []}';
CSP10={'mo' 'CSP10' 0 []}';
CM10END={'mo' 'CM10END' 0 []}';
CM11BEG={'mo' 'CM11BEG' 0 []}';
CSP11={'mo' 'CSP11' 0 []}';
CM11END={'mo' 'CM11END' 0 []}';
CM12BEG={'mo' 'CM12BEG' 0 []}';
CSP12={'mo' 'CSP12' 0 []}';
CM12END={'mo' 'CM12END' 0 []}';
CM13BEG={'mo' 'CM13BEG' 0 []}';
CSP13={'mo' 'CSP13' 0 []}';
CM13END={'mo' 'CM13END' 0 []}';
CM14BEG={'mo' 'CM14BEG' 0 []}';
CSP14={'mo' 'CSP14' 0 []}';
CM14END={'mo' 'CM14END' 0 []}';
CM15BEG={'mo' 'CM15BEG' 0 []}';
CSP15={'mo' 'CSP15' 0 []}';
CM15END={'mo' 'CM15END' 0 []}';
CM16BEG={'mo' 'CM16BEG' 0 []}';
CSP16={'mo' 'CSP16' 0 []}';
CM16END={'mo' 'CM16END' 0 []}';
CM17BEG={'mo' 'CM17BEG' 0 []}';
CSP17={'mo' 'CSP17' 0 []}';
CM17END={'mo' 'CM17END' 0 []}';
CM18BEG={'mo' 'CM18BEG' 0 []}';
CSP18={'mo' 'CSP18' 0 []}';
CM18END={'mo' 'CM18END' 0 []}';
CM19BEG={'mo' 'CM19BEG' 0 []}';
CSP19={'mo' 'CSP19' 0 []}';
CM19END={'mo' 'CM19END' 0 []}';
CM20BEG={'mo' 'CM20BEG' 0 []}';
CSP20={'mo' 'CSP20' 0 []}';
CM20END={'mo' 'CM20END' 0 []}';
CM21BEG={'mo' 'CM21BEG' 0 []}';
CSP21={'mo' 'CSP21' 0 []}';
CM21END={'mo' 'CM21END' 0 []}';
CM22BEG={'mo' 'CM22BEG' 0 []}';
CSP22={'mo' 'CSP22' 0 []}';
CM22END={'mo' 'CM22END' 0 []}';
CM23BEG={'mo' 'CM23BEG' 0 []}';
CSP23={'mo' 'CSP23' 0 []}';
CM23END={'mo' 'CM23END' 0 []}';
CM24BEG={'mo' 'CM24BEG' 0 []}';
CSP24={'mo' 'CSP24' 0 []}';
CM24END={'mo' 'CM24END' 0 []}';
CM25BEG={'mo' 'CM25BEG' 0 []}';
CSP25={'mo' 'CSP25' 0 []}';
CM25END={'mo' 'CM25END' 0 []}';
CM26BEG={'mo' 'CM26BEG' 0 []}';
CSP26={'mo' 'CSP26' 0 []}';
CM26END={'mo' 'CM26END' 0 []}';
CM27BEG={'mo' 'CM27BEG' 0 []}';
CSP27={'mo' 'CSP27' 0 []}';
CM27END={'mo' 'CM27END' 0 []}';
CM28BEG={'mo' 'CM28BEG' 0 []}';
CSP28={'mo' 'CSP28' 0 []}';
CM28END={'mo' 'CM28END' 0 []}';
CM29BEG={'mo' 'CM29BEG' 0 []}';
CSP29={'mo' 'CSP29' 0 []}';
CM29END={'mo' 'CM29END' 0 []}';
CM30BEG={'mo' 'CM30BEG' 0 []}';
CSP30={'mo' 'CSP30' 0 []}';
CM30END={'mo' 'CM30END' 0 []}';
CM31BEG={'mo' 'CM31BEG' 0 []}';
CSP31={'mo' 'CSP31' 0 []}';
CM31END={'mo' 'CM31END' 0 []}';
CM32BEG={'mo' 'CM32BEG' 0 []}';
CSP32={'mo' 'CSP32' 0 []}';
CM32END={'mo' 'CM32END' 0 []}';
CM33BEG={'mo' 'CM33BEG' 0 []}';
CSP33={'mo' 'CSP33' 0 []}';
CM33END={'mo' 'CM33END' 0 []}';
CM34BEG={'mo' 'CM34BEG' 0 []}';
CSP34={'mo' 'CSP34' 0 []}';
CM34END={'mo' 'CM34END' 0 []}';
CM35BEG={'mo' 'CM35BEG' 0 []}';
CSP35={'mo' 'CSP35' 0 []}';
CM35END={'mo' 'CM35END' 0 []}';
BEAM0={'mo' 'BEAM0' 0 []}';%initial beam specified here
HOMCM={'mo' 'HOMCM' 0 []}';%cryomodule HOM absorber
ASTRA={'mo' 'ASTRA' 0 []}';%simulated Twiss from C. Papadopoulos here
VG0H00={'mo' 'VG0H00' 0 []}';
VP0H00={'mo' 'VP0H00' 0 []}';
VV0H00={'mo' 'VV0H00' 0 []}';
ECU={'mo' 'ECU' 0 []}';%u/s flange face
FC1={'mo' 'FC1' 0 []}';%d/s flange face
BLF1={'mo' 'BLF1' 0 []}';%beamline flange
MSC0D={'mo' 'MSC0D' 0 []}';%u/s flange face
PSC1U={'mo' 'PSC1U' 0 []}';%u/s flange face
MSC1U={'mo' 'MSC1U' 0 []}';%u/s flange face
BLF2={'mo' 'BLF2' 0 []}';%beamline flange
FC2={'mo' 'FC2' 0 []}';%u/s flange face
FC3={'mo' 'FC3' 0 []}';%d/s flange face
BLF3={'mo' 'BLF3' 0 []}';%beamline flange
MSC1D={'mo' 'MSC1D' 0 []}';%d/s flange face
PSC1D={'mo' 'PSC1D' 0 []}';%d/s flange face
PSC2U={'mo' 'PSC2U' 0 []}';%u/s flange face
MSC2U={'mo' 'MSC2U' 0 []}';%u/s flange face
BLF4={'mo' 'BLF4' 0 []}';%beamline flange
FC4={'mo' 'FC4' 0 []}';%u/s flange face
FC5={'mo' 'FC5' 0 []}';%d/s flange face
BLF5={'mo' 'BLF5' 0 []}';%beamline flange
MSC2D={'mo' 'MSC2D' 0 []}';%d/s flange face
PSC2D={'mo' 'PSC2D' 0 []}';%d/s flange face
PSC3U={'mo' 'PSC3U' 0 []}';%u/s flange face
MSC3U={'mo' 'MSC3U' 0 []}';%u/s flange face
BLF6={'mo' 'BLF6' 0 []}';%beamline flange
FC6={'mo' 'FC6' 0 []}';%u/s flange face
ECD={'mo' 'ECD' 0 []}';%d/s flange face
BLFD={'mo' 'BLFD' 0 []}';%beamline flange
MSC3D={'mo' 'MSC3D' 0 []}';%d/s flange face
PSC3D={'mo' 'PSC3D' 0 []}';%d/s flange face
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
CAVL015_FULL=[CAVL015A,CSP01,CAVL015B];
CAVL025_FULL=[CAVL025A,CSP02,CAVL025B];
CAVL035_FULL=[CAVL035A,CSP03,CAVL035B];
CAVC012_FULL=[CAVC012A,CSPH1,CAVC012B];
CAVC022_FULL=[CAVC022A,CSPH2,CAVC022B];
CAVL045_FULL=[CAVL045A,CSP04,CAVL045B];
CAVL055_FULL=[CAVL055A,CSP05,CAVL055B];
CAVL065_FULL=[CAVL065A,CSP06,CAVL065B];
CAVL075_FULL=[CAVL075A,CSP07,CAVL075B];
CAVL085_FULL=[CAVL085A,CSP08,CAVL085B];
CAVL095_FULL=[CAVL095A,CSP09,CAVL095B];
CAVL105_FULL=[CAVL105A,CSP10,CAVL105B];
CAVL115_FULL=[CAVL115A,CSP11,CAVL115B];
CAVL125_FULL=[CAVL125A,CSP12,CAVL125B];
CAVL135_FULL=[CAVL135A,CSP13,CAVL135B];
CAVL145_FULL=[CAVL145A,CSP14,CAVL145B];
CAVL155_FULL=[CAVL155A,CSP15,CAVL155B];
CAVL165_FULL=[CAVL165A,CSP16,CAVL165B];
CAVL175_FULL=[CAVL175A,CSP17,CAVL175B];
CAVL185_FULL=[CAVL185A,CSP18,CAVL185B];
CAVL195_FULL=[CAVL195A,CSP19,CAVL195B];
CAVL205_FULL=[CAVL205A,CSP20,CAVL205B];
CAVL215_FULL=[CAVL215A,CSP21,CAVL215B];
CAVL225_FULL=[CAVL225A,CSP22,CAVL225B];
CAVL235_FULL=[CAVL235A,CSP23,CAVL235B];
CAVL245_FULL=[CAVL245A,CSP24,CAVL245B];
CAVL255_FULL=[CAVL255A,CSP25,CAVL255B];
CAVL265_FULL=[CAVL265A,CSP26,CAVL265B];
CAVL275_FULL=[CAVL275A,CSP27,CAVL275B];
CAVL285_FULL=[CAVL285A,CSP28,CAVL285B];
CAVL295_FULL=[CAVL295A,CSP29,CAVL295B];
CAVL305_FULL=[CAVL305A,CSP30,CAVL305B];
CAVL315_FULL=[CAVL315A,CSP31,CAVL315B];
CAVL325_FULL=[CAVL325A,CSP32,CAVL325B];
CAVL335_FULL=[CAVL335A,CSP33,CAVL335B];
CAVL345_FULL=[CAVL345A,CSP34,CAVL345B];
CAVL355_FULL=[CAVL355A,CSP35,CAVL355B];
QCM01_FULL=[QCM01,XCM01,YCM01,QCM01];
QCM02_FULL=[QCM02,XCM02,YCM02,QCM02];
QCM03_FULL=[QCM03,XCM03,YCM03,QCM03];
QCM04_FULL=[QCM04,XCM04,YCM04,QCM04];
QCM05_FULL=[QCM05,XCM05,YCM05,QCM05];
QCM06_FULL=[QCM06,XCM06,YCM06,QCM06];
QCM07_FULL=[QCM07,XCM07,YCM07,QCM07];
QCM08_FULL=[QCM08,XCM08,YCM08,QCM08];
QCM09_FULL=[QCM09,XCM09,YCM09,QCM09];
QCM10_FULL=[QCM10,XCM10,YCM10,QCM10];
QCM11_FULL=[QCM11,XCM11,YCM11,QCM11];
QCM12_FULL=[QCM12,XCM12,YCM12,QCM12];
QCM13_FULL=[QCM13,XCM13,YCM13,QCM13];
QCM14_FULL=[QCM14,XCM14,YCM14,QCM14];
QCM15_FULL=[QCM15,XCM15,YCM15,QCM15];
QCM16_FULL=[QCM16,XCM16,YCM16,QCM16];
QCM17_FULL=[QCM17,XCM17,YCM17,QCM17];
QCM18_FULL=[QCM18,XCM18,YCM18,QCM18];
QCM19_FULL=[QCM19,XCM19,YCM19,QCM19];
QCM20_FULL=[QCM20,XCM20,YCM20,QCM20];
QCM21_FULL=[QCM21,XCM21,YCM21,QCM21];
QCM22_FULL=[QCM22,XCM22,YCM22,QCM22];
QCM23_FULL=[QCM23,XCM23,YCM23,QCM23];
QCM24_FULL=[QCM24,XCM24,YCM24,QCM24];
QCM25_FULL=[QCM25,XCM25,YCM25,QCM25];
QCM26_FULL=[QCM26,XCM26,YCM26,QCM26];
QCM27_FULL=[QCM27,XCM27,YCM27,QCM27];
QCM28_FULL=[QCM28,XCM28,YCM28,QCM28];
QCM29_FULL=[QCM29,XCM29,YCM29,QCM29];
QCM30_FULL=[QCM30,XCM30,YCM30,QCM30];
QCM31_FULL=[QCM31,XCM31,YCM31,QCM31];
QCM32_FULL=[QCM32,XCM32,YCM32,QCM32];
QCM33_FULL=[QCM33,XCM33,YCM33,QCM33];
QCM34_FULL=[QCM34,XCM34,YCM34,QCM34];
QCM35_FULL=[QCM35,XCM35,YCM35,QCM35];
% L0
CM01=[CM01BEG,DCM1,CAVL011,DCM2,CAVL012,DCM2,CAVL013,DCM2,CAVL014,DCM2,CAVL015_FULL,DCM2,CAVL016,DCM2,CAVL017,DCM2,CAVL018,DCM3,CMB01,DCM4A,BEAM0,DCM4B,QCM01_FULL,DCM5,CM01END];
% L1
CM02=[CM02BEG,DCM1,CAVL021,DCM2,CAVL022,DCM2,CAVL023,DCM2,CAVL024,DCM2,CAVL025_FULL,DCM2,CAVL026,DCM2,CAVL027,DCM2,CAVL028,DCM3,CMB02,DCM4,QCM02_FULL,DCM5,CM02END];
CM03=[CM03BEG,DCM1,CAVL031,DCM2,CAVL032,DCM2,CAVL033,DCM2,CAVL034,DCM2,CAVL035_FULL,DCM2,CAVL036,DCM2,CAVL037,DCM2,CAVL038,DCM3,CMB03,DCM4,QCM03_FULL,DCM5,CM03END];
CMH1=[CMH1BEG,DCMH0,CAVC011,DCMH2,CAVC012_FULL,DCMH2,CAVC013,DCMH2,CAVC014,DCMH2,CAVC015,DCMH2,CAVC016,DCMH2,CAVC017,DCMH2,CAVC018,DCMH3,CMBH1,DCMH4,CMH1END];
CMH2=[CMH2BEG,DCMH1,CAVC021,DCMH2,CAVC022_FULL,DCMH2,CAVC023,DCMH2,CAVC024,DCMH2,CAVC025,DCMH2,CAVC026,DCMH2,CAVC027,DCMH2,CAVC028,DCMH3,CMBH2,DCMH4,CMH2END];
% L2
CM04=[CM04BEG,DCM1,CAVL041,DCM2,CAVL042,DCM2,CAVL043,DCM2,CAVL044,DCM2,CAVL045_FULL,DCM2,CAVL046,DCM2,CAVL047,DCM2,CAVL048,DCM3,CMB04,DCM4,QCM04_FULL,DCM5,CM04END];
CM05=[CM05BEG,DCM1,CAVL051,DCM2,CAVL052,DCM2,CAVL053,DCM2,CAVL054,DCM2,CAVL055_FULL,DCM2,CAVL056,DCM2,CAVL057,DCM2,CAVL058,DCM3,CMB05,DCM4,QCM05_FULL,DCM5,CM05END];
CM06=[CM06BEG,DCM1,CAVL061,DCM2,CAVL062,DCM2,CAVL063,DCM2,CAVL064,DCM2,CAVL065_FULL,DCM2,CAVL066,DCM2,CAVL067,DCM2,CAVL068,DCM3,CMB06,DCM4,QCM06_FULL,DCM5,CM06END];
CM07=[CM07BEG,DCM1,CAVL071,DCM2,CAVL072,DCM2,CAVL073,DCM2,CAVL074,DCM2,CAVL075_FULL,DCM2,CAVL076,DCM2,CAVL077,DCM2,CAVL078,DCM3,CMB07,DCM4,QCM07_FULL,DCM5,CM07END];
CM08=[CM08BEG,DCM1,CAVL081,DCM2,CAVL082,DCM2,CAVL083,DCM2,CAVL084,DCM2,CAVL085_FULL,DCM2,CAVL086,DCM2,CAVL087,DCM2,CAVL088,DCM3,CMB08,DCM4,QCM08_FULL,DCM5,CM08END];
CM09=[CM09BEG,DCM1,CAVL091,DCM2,CAVL092,DCM2,CAVL093,DCM2,CAVL094,DCM2,CAVL095_FULL,DCM2,CAVL096,DCM2,CAVL097,DCM2,CAVL098,DCM3,CMB09,DCM4,QCM09_FULL,DCM5,CM09END];
CM10=[CM10BEG,DCM1,CAVL101,DCM2,CAVL102,DCM2,CAVL103,DCM2,CAVL104,DCM2,CAVL105_FULL,DCM2,CAVL106,DCM2,CAVL107,DCM2,CAVL108,DCM3,CMB10,DCM4,QCM10_FULL,DCM5,CM10END];
CM11=[CM11BEG,DCM1,CAVL111,DCM2,CAVL112,DCM2,CAVL113,DCM2,CAVL114,DCM2,CAVL115_FULL,DCM2,CAVL116,DCM2,CAVL117,DCM2,CAVL118,DCM3,CMB11,DCM4,QCM11_FULL,DCM5,CM11END];
CM12=[CM12BEG,DCM1,CAVL121,DCM2,CAVL122,DCM2,CAVL123,DCM2,CAVL124,DCM2,CAVL125_FULL,DCM2,CAVL126,DCM2,CAVL127,DCM2,CAVL128,DCM3,CMB12,DCM4,QCM12_FULL,DCM5,CM12END];
CM13=[CM13BEG,DCM1,CAVL131,DCM2,CAVL132,DCM2,CAVL133,DCM2,CAVL134,DCM2,CAVL135_FULL,DCM2,CAVL136,DCM2,CAVL137,DCM2,CAVL138,DCM3,CMB13,DCM4,QCM13_FULL,DCM5,CM13END];
CM14=[CM14BEG,DCM1,CAVL141,DCM2,CAVL142,DCM2,CAVL143,DCM2,CAVL144,DCM2,CAVL145_FULL,DCM2,CAVL146,DCM2,CAVL147,DCM2,CAVL148,DCM3,CMB14,DCM4,QCM14_FULL,DCM5,CM14END];
CM15=[CM15BEG,DCM1,CAVL151,DCM2,CAVL152,DCM2,CAVL153,DCM2,CAVL154,DCM2,CAVL155_FULL,DCM2,CAVL156,DCM2,CAVL157,DCM2,CAVL158,DCM3,CMB15,DCM4,QCM15_FULL,DCM5,CM15END];
% L3
CM16=[CM16BEG,DCM1,CAVL161,DCM2,CAVL162,DCM2,CAVL163,DCM2,CAVL164,DCM2,CAVL165_FULL,DCM2,CAVL166,DCM2,CAVL167,DCM2,CAVL168,DCM3,CMB16,DCM4,QCM16_FULL,DCM5,CM16END];
CM17=[CM17BEG,DCM1,CAVL171,DCM2,CAVL172,DCM2,CAVL173,DCM2,CAVL174,DCM2,CAVL175_FULL,DCM2,CAVL176,DCM2,CAVL177,DCM2,CAVL178,DCM3,CMB17,DCM4,QCM17_FULL,DCM5,CM17END];
CM18=[CM18BEG,DCM1,CAVL181,DCM2,CAVL182,DCM2,CAVL183,DCM2,CAVL184,DCM2,CAVL185_FULL,DCM2,CAVL186,DCM2,CAVL187,DCM2,CAVL188,DCM3,CMB18,DCM4,QCM18_FULL,DCM5,CM18END];
CM19=[CM19BEG,DCM1,CAVL191,DCM2,CAVL192,DCM2,CAVL193,DCM2,CAVL194,DCM2,CAVL195_FULL,DCM2,CAVL196,DCM2,CAVL197,DCM2,CAVL198,DCM3,CMB19,DCM4,QCM19_FULL,DCM5,CM19END];
CM20=[CM20BEG,DCM1,CAVL201,DCM2,CAVL202,DCM2,CAVL203,DCM2,CAVL204,DCM2,CAVL205_FULL,DCM2,CAVL206,DCM2,CAVL207,DCM2,CAVL208,DCM3,CMB20,DCM4,QCM20_FULL,DCM5,CM20END];
CM21=[CM21BEG,DCM1,CAVL211,DCM2,CAVL212,DCM2,CAVL213,DCM2,CAVL214,DCM2,CAVL215_FULL,DCM2,CAVL216,DCM2,CAVL217,DCM2,CAVL218,DCM3,CMB21,DCM4,QCM21_FULL,DCM5,CM21END];
CM22=[CM22BEG,DCM1,CAVL221,DCM2,CAVL222,DCM2,CAVL223,DCM2,CAVL224,DCM2,CAVL225_FULL,DCM2,CAVL226,DCM2,CAVL227,DCM2,CAVL228,DCM3,CMB22,DCM4,QCM22_FULL,DCM5,CM22END];
CM23=[CM23BEG,DCM1,CAVL231,DCM2,CAVL232,DCM2,CAVL233,DCM2,CAVL234,DCM2,CAVL235_FULL,DCM2,CAVL236,DCM2,CAVL237,DCM2,CAVL238,DCM3,CMB23,DCM4,QCM23_FULL,DCM5,CM23END];
CM24=[CM24BEG,DCM1,CAVL241,DCM2,CAVL242,DCM2,CAVL243,DCM2,CAVL244,DCM2,CAVL245_FULL,DCM2,CAVL246,DCM2,CAVL247,DCM2,CAVL248,DCM3,CMB24,DCM4,QCM24_FULL,DCM5,CM24END];
CM25=[CM25BEG,DCM1,CAVL251,DCM2,CAVL252,DCM2,CAVL253,DCM2,CAVL254,DCM2,CAVL255_FULL,DCM2,CAVL256,DCM2,CAVL257,DCM2,CAVL258,DCM3,CMB25,DCM4,QCM25_FULL,DCM5,CM25END];
CM26=[CM26BEG,DCM1,CAVL261,DCM2,CAVL262,DCM2,CAVL263,DCM2,CAVL264,DCM2,CAVL265_FULL,DCM2,CAVL266,DCM2,CAVL267,DCM2,CAVL268,DCM3,CMB26,DCM4,QCM26_FULL,DCM5,CM26END];
CM27=[CM27BEG,DCM1,CAVL271,DCM2,CAVL272,DCM2,CAVL273,DCM2,CAVL274,DCM2,CAVL275_FULL,DCM2,CAVL276,DCM2,CAVL277,DCM2,CAVL278,DCM3,CMB27,DCM4,QCM27_FULL,DCM5,CM27END];
CM28=[CM28BEG,DCM1,CAVL281,DCM2,CAVL282,DCM2,CAVL283,DCM2,CAVL284,DCM2,CAVL285_FULL,DCM2,CAVL286,DCM2,CAVL287,DCM2,CAVL288,DCM3,CMB28,DCM4,QCM28_FULL,DCM5,CM28END];
CM29=[CM29BEG,DCM1,CAVL291,DCM2,CAVL292,DCM2,CAVL293,DCM2,CAVL294,DCM2,CAVL295_FULL,DCM2,CAVL296,DCM2,CAVL297,DCM2,CAVL298,DCM3,CMB29,DCM4,QCM29_FULL,DCM5,CM29END];
CM30=[CM30BEG,DCM1,CAVL301,DCM2,CAVL302,DCM2,CAVL303,DCM2,CAVL304,DCM2,CAVL305_FULL,DCM2,CAVL306,DCM2,CAVL307,DCM2,CAVL308,DCM3,CMB30,DCM4,QCM30_FULL,DCM5,CM30END];
CM31=[CM31BEG,DCM1,CAVL311,DCM2,CAVL312,DCM2,CAVL313,DCM2,CAVL314,DCM2,CAVL315_FULL,DCM2,CAVL316,DCM2,CAVL317,DCM2,CAVL318,DCM3,CMB31,DCM4,QCM31_FULL,DCM5,CM31END];
CM32=[CM32BEG,DCM1,CAVL321,DCM2,CAVL322,DCM2,CAVL323,DCM2,CAVL324,DCM2,CAVL325_FULL,DCM2,CAVL326,DCM2,CAVL327,DCM2,CAVL328,DCM3,CMB32,DCM4,QCM32_FULL,DCM5,CM32END];
CM33=[CM33BEG,DCM1,CAVL331,DCM2,CAVL332,DCM2,CAVL333,DCM2,CAVL334,DCM2,CAVL335_FULL,DCM2,CAVL336,DCM2,CAVL337,DCM2,CAVL338,DCM3,CMB33,DCM4,QCM33_FULL,DCM5,CM33END];
CM34=[CM34BEG,DCM1,CAVL341,DCM2,CAVL342,DCM2,CAVL343,DCM2,CAVL344,DCM2,CAVL345_FULL,DCM2,CAVL346,DCM2,CAVL347,DCM2,CAVL348,DCM3,CMB34,DCM4,QCM34_FULL,DCM5,CM34END];
CM35=[CM35BEG,DCM1,CAVL351,DCM2,CAVL352,DCM2,CAVL353,DCM2,CAVL354,DCM2,CAVL355_FULL,DCM2,CAVL356,DCM2,CAVL357,DCM2,CAVL358,DCM3,CMB35,DCM4,QCM35_FULL,DCM5,CM35END];
L0=[BEGL0B,ECU,DCAP0U,CM01,DCMCM1,HOMCM,DCAP0DA,ASTRA,DCAP0DB,FC1,DMSC0DA,BLF1,DMSC0DB,VG0H00,DMSC0DC,VP0H00,DMSC0DD,VV0H00,DMSC0DE,MSC0D,ENDL0B];
L1=[BEGL1B,PSC1U,DPSC1U,MSC1U,DMSC1UA,BLF2,DMSC1UB,FC2,DCAP1U,CM02,DCMCM1,HOMCM,DCMCM2,CM03,DCMCMH1,HOMCM,DCMCMH2,CMH1,DCMHCMH1,HOMCM,DCMHCMH2,CMH2,DCAP1D,FC3,DMSC1DA,BLF3,DMSC1DB,MSC1D,DPSC1D,PSC1D,ENDL1B];
L2=[BEGL2B,PSC2U,DPSC2U,MSC2U,DMSC2UA,BLF4,DMSC2UB,FC4,DCAP2U,CM04,DCMCM1,HOMCM,DCMCM2,CM05,DCMCM1,HOMCM,DCMCM2,CM06,DCMCM1,HOMCM,DCMCM2,CM07,DCMCM1,HOMCM,DCMCM2,CM08,DCMCM1,HOMCM,DCMCM2,CM09,DCMCM1,HOMCM,DCMCM2,CM10,DCMCM1,HOMCM,DCMCM2,CM11,DCMCM1,HOMCM,DCMCM2,CM12,DCMCM1,HOMCM,DCMCM2,CM13,DCMCM1,HOMCM,DCMCM2,CM14,DCMCM1,HOMCM,DCMCM2,CM15,DCMCM1,HOMCM,DCAP2D,FC5,DMSC2DA,BLF5,DMSC2DB,MSC2D,RFB2C00,DPSC2D,PSC2D,ENDL2B];
L3=[BEGL3B,PSC3U,DPSC3U,MSC3U,DMSC3UA,BLF6,DMSC3UB,FC6,DCAP3U,CM16,DCMCM1,HOMCM,DCMCM2,CM17,DCMCM1,HOMCM,DCMCM2,CM18,DCMCM1,HOMCM,DCMCM2,CM19,DCMCM1,HOMCM,DCMCM2,CM20,DCMCM1,HOMCM,DCMCM2,CM21,DCMCM1,HOMCM,DCMCM2,CM22,DCMCM1,HOMCM,DCMCM2,CM23,DCMCM1,HOMCM,DCMCM2,CM24,DCMCM1,HOMCM,DCMCM2,CM25,DCMCM1,HOMCM,DCMCM2,DBREAK,CM26,DCMCM1,HOMCM,DCMCM2,CM27,DCMCM1,HOMCM,DCMCM2,CM28,DCMCM1,HOMCM,DCMCM2,CM29,DCMCM1,HOMCM,DCMCM2,CM30,DCMCM1,HOMCM,DCMCM2,CM31,DCMCM1,HOMCM,DCMCM2,CM32,DCMCM1,HOMCM,DCMCM2,CM33,DCMCM1,HOMCM,DCMCM2,CM34,DCMCM1,HOMCM,DCMCM2,CM35,DCMCM1,HOMCM,DCAP3D,ECD,DMSC3DA,BLFD,DMSC3DB,MSC3D,DPSC3D,PSC3D,ENDL3B];
% ==============================================================================
% coasting FODO
% ------------------------------------------------------------------------------
QFCMFODO1={'qu' 'QFCMFODO1' LCMQ/2 [KQCMFODO1 0]}';%L1 QF
QDCMFODO1={'qu' 'QDCMFODO1' LCMQ/2 [-KQCMFODO1 0]}';%L1 QD
QFCMFODO2={'qu' 'QFCMFODO2' LCMQ/2 [KQCMFODO2 0]}';%L2 QF
QDCMFODO2={'qu' 'QDCMFODO2' LCMQ/2 [-KQCMFODO2 0]}';%L2 QD
QFCMFODO3={'qu' 'QFCMFODO3' LCMQ/2 [KQCMFODO3 0]}';%L3 QF
QDCMFODO3={'qu' 'QDCMFODO3' LCMQ/2 [-KQCMFODO3 0]}';%L3 QD
DCMFODO={'dr' '' LDCMFODO []}';
CMFODO1=[QFCMFODO1,DCMFODO,QDCMFODO1,QDCMFODO1,DCMFODO,QFCMFODO1];
CMFODO2=[QFCMFODO2,DCMFODO,QDCMFODO2,QDCMFODO2,DCMFODO,QFCMFODO2];
CMFODO3=[QFCMFODO3,DCMFODO,QDCMFODO3,QDCMFODO3,DCMFODO,QFCMFODO3];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc post laser heater diagnostic beamline
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 26-NOV-2019, M. Woodley
%  * undefer TCXDG0 per D. Yeremian
% ------------------------------------------------------------------------------
% 17-JAN-2018, M. Woodley
%  * move BPMDG000 back to Z=33.832875 m per H. Alvarez (dY = +9.425 mm)
% ------------------------------------------------------------------------------
% 05-SEP-2017, M. Woodley
%  * move BPMDG000 u/s 0.540504 m (Z=33.293466) per P. Emma (dY = +5.000 mm)
% ------------------------------------------------------------------------------
% 04-MAY-2017, M. Woodley
%  * move BPMDG0RF u/s 0.02286 m (Z=42.668655) per C. Iverson
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * set BKRDG0 kicker gap to 35 mm (OD of ceramic chamber)
%  * assign TYPE="1.378K35.4" to BKRDG0
%  * undefer BPMDG001 (add-back list items)
% ------------------------------------------------------------------------------
% 06-JUN-2016, M. Woodley
%  * assign TYPE="0.984K35.4" to BKRDG0
%  * set BKRDG0 kicker gap to 25 mm
%  * center BPMDG000 between BKRDG0 and BLRDG0
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * remove YCDG000 (between kicker and septum)
%  * move BPMDG000 to upstream face of septum
%  * change TYPE of QDG001-03 to "QI" type (1.51Q7.00)
%  * change TYPE of XCDG001-02 and YCORDG001-02 to "class-6" and locate per
%    H. Alvarez
%  * move SCDG003 between QDG004 and QDG005
%  * change TYPE of OTRs and YAGs per Henrik's PRD
%  * move entire line into the aisle (X: Xgun+0.5 -> Xgun-0.5)
%  * use SETDG0 to turn kicker & septum ON/OFF
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * take yaw out of Lambertson septum
%  * replace 30 deg "0.98VD18.7" dipole with rolled 35 deg "BXS" dipole
%  * remove QDG012, XCDG012, and YCDG012
%  * undefer BPMDG012
%  * shorten the line by 1.556 m
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * roll kicker into bend plane of septum
%  * fix interferences per H. Alvarez
%  * replace QDG002 (1.26Q3.5) with 1.0Q3.1
%  * change BPMDG002 and BPMDG003 to "Stripline-9"
%  * define additional magnet TYPEs
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * interference resolution per H. Alvarez:
%    - move BPMDG00 38.1 cm (15 inches) upstream
%    - replace QDG001 and QDG003 (1.26Q3.5) with 1.0Q3.1
%    - move SCDG002 (XCDG002/YCDG002) 4.0 cm (1.5 inches) upstream
%    - move SCDG003 (XCDG003/YCDG003) 30.5 cm (12 inches) upstream
%    - move QDG004/BPMDG004 5.1 cm (2 inches) downstream
%    - move RFBDG003 20.4 cm (8 inches) downstream
%    - move RFBDG004 14.0 cm (5.5 inches) upstream
%  * replace RFBDG004 (defer=2) with BPMDG004 (defer=0)
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * move BYDG0/SCDG012 21 inches d/s to avoid interference with COL0 devices;
%    add an additional 20 cm between SCDG012 and OTRDG04 to match spectrometer
%    optics
% ------------------------------------------------------------------------------
% 13-OCT-2014, M. Woodley
%  * parameters of extraction magnets (BKYDG0, BLRDG0, and BXDG0) per "Post-LH
%    Diagnostic Beamline Requirements" PRD (LCLSII-2.4-PR-0068-R1)
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * decorate device TYPE attributes to indicate non-baseline status
% 17-APR-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * reduce horizontal beamline offset from 70 cm to 50 cm per H. Alvarez
%  * add WSDG01
%  * element names changed to conform to nomenclature PRD
% 27-FEB-2014, M. Woodley
%  * created (based on a previous deck from Paul Emma)
% ------------------------------------------------------------------------------
% geometry and horizontal dispersion matching parameters
% YANG0   : vertical kick angle (rad)
% XANG0   : septum bend angle (rad)
% SROL0   : kicker/septum roll angle (suppress vertical dispersion)
% AROLL0K : removes tiny coordinate roll from rolled kicker
% AROLL0L : removes tiny coordinate roll from rolled HLAM
% YK01    : simulates vertical kick due to misaligned QDG001
% YK02    : simulates vertical kick due to misaligned QDG003
% ZHH0    : z-distance from BLRDG0 center to BXDG0 center (m)
% ZTWK0a  : z-distance adjust (moves QDG001 and QDG003 w.r.t. QDG002)
% ZTWK0b  : z-distance adjust (moves QDG001/QDG002/QDG003 together)
% KQBF0   : strength of QDG001/QDG003
% KQBD0   : strength of QDG002
YANG0 =  -0.833318062396E-2 ;% -0.83334163902E-2 
XANG0 =   0.104888536538    ;%  0.104907047642    
SROL0 =   0.176699440628    ;% -0.178475547902   
AROLL0K =  -0.60084338373E-5  ;%  0.606659261643E-5 
AROLL0L =   0.105498270761E-3 ;% -0.115355538592E-3
YK01 =  -0.964722799243E-2 ;% -0.977848685269E-2
YK02 =  -0.597746163395E-3 ;% -0.655172413757E-3
ZHH0 =   4.73074234504     ;%  4.754790293502    
ZTWK0A =  -0.325585867843    ;% -0.284357486501   
ZTWK0B =  -0.014570470464    ;% -0.014622274147   
KQBF0 =   9.807425871432    ;% 19.917546719613   
KQBD0 =  -7.825140556488    ;%-13.410702917581  
% ==============================================================================
% LCAV
% ------------------------------------------------------------------------------
% transverse deflecting cavities
% (NOTE: TCYDG0 might be installed as an uprgade at a later time)
TCYDG0={'tc' 'TCYDG0' 0.8/2 [2856 0 0*TWOPI]}';%Y-deflector (split)
TCXDG0={'tc' 'TCXDG0' 0.8/2 [2856 0 0*TWOPI]}';%X-deflector (split)
% ==============================================================================
% SBEN
% ------------------------------------------------------------------------------
YKOFF0 =   15E-3      ;%vertical offset at septum face (m)
ZKS0 =   2.0        ;%z-distance from BKRDG0 center to BLRDG0 center (m)
DX0 =  -0.5        ;%x-distance from linac axis to diagnostic line axis (m)
XANG02 =   6.0*RADDEG ;%BXDG0 bend angle (rad)
% kicker
GK0 =  0.035;
ZK0 =  LBKSP;
AK0 =  YANG0;
AK0_2 =  AK0*AK0;
AK0_4 =  AK0_2*AK0_2;
AK0_6 =  AK0_4*AK0_2;
SINCAK0 =  1-AK0_2/6+AK0_4/120-AK0_6/5040 ;%~sinc(AK0)=sin(AK0)/AK0
LK0 =  ZK0/SINCAK0;
AK0S =  asin(sin(AK0)/2);
AK0S_2 =  AK0S*AK0S;
AK0S_4 =  AK0S_2*AK0S_2;
AK0S_6 =  AK0S_4*AK0S_2;
SINCAK0S =  1-AK0S_2/6+AK0S_4/120-AK0S_6/5040 ;%~sinc(AK0S)=sin(AK0S)/AK0S
LK0S =  ZK0/(2*SINCAK0S);
AK0L =  AK0-AK0S;
LK0L =  LK0-LK0S;
BKRDG0A={'be' 'BKRDG0' LK0S [AK0S GK0/2 0 0 0.5 0 90*RADDEG+SROL0]}';
BKRDG0B={'be' 'BKRDG0' LK0L [AK0L GK0/2 0 AK0 0 0.5 90*RADDEG+SROL0]}';
% septum
GS0 =  0.02;
ZS0 =  0.4;
AS0 =  XANG0;
AS0_2 =  AS0*AS0;
AS0_4 =  AS0_2*AS0_2;
AS0_6 =  AS0_4*AS0_2;
SINCAS0 =  1-AS0_2/6+AS0_4/120-AS0_6/5040 ;%~sinc(AS0)=sin(AS0)/AS0
LS0 =  (ZS0/cos(AK0))/SINCAS0;
AS0S =  asin(sin(AS0)/2);
AS0S_2 =  AS0S*AS0S;
AS0S_4 =  AS0S_2*AS0S_2;
AS0S_6 =  AS0S_4*AS0S_2;
SINCAS0S =  1-AS0S_2/6+AS0S_4/120-AS0S_6/5040 ;%~sinc(AS0S)=sin(AS0S)/AS0S
LS0S =  (ZS0/cos(AK0))/(2*SINCAS0S);
AS0L =  AS0-AS0S;
LS0L =  LS0-LS0S;
BLRDG0A={'be' 'BLRDG0' LS0S [AS0S GS0/2 0 0 0.5 0 SROL0]}';
BLRDG0B={'be' 'BLRDG0' LS0L [AS0L GS0/2 0 AS0 0 0.5 SROL0]}';
% horizontal bend
GH0 =  0.02;
ZH0 =  0.4;
AH0 =  XANG02;
AH0H =  AH0/2 ;%half-angle
AH0H_2 =  AH0H*AH0H;
AH0H_4 =  AH0H_2*AH0H_2;
AH0H_6 =  AH0H_4*AH0H_2;
SINCAH0H =  1-AH0H_2/6+AH0H_4/120-AH0H_6/5040 ;%~sinc(AH0h)=sin(AH0h)/AH0h
LH0 =  ZH0/SINCAH0H;
BXDG0A={'be' 'BXDG0' LH0/2 [-AH0H GH0/2 -AH0H 0 0.5 0 0]}';
BXDG0B={'be' 'BXDG0' LH0/2 [-AH0H GH0/2 0 -AH0H 0 0.5 0]}';
% spectrometer (dump) bend
LBDMP0 =  0.5435       ;%measured
GBDMP0 =  0.034;
ABDMP0 =  -35*RADDEG;
EBDMP0 =  -7.29*RADDEG ;%measured
FBDMP0 =  0.391        ;%measured
BYDG0A={'be' 'BYDG0' LBDMP0/2 [ABDMP0/2 GBDMP0/2 EBDMP0 0 FBDMP0 0 90*RADDEG]}';
BYDG0B={'be' 'BYDG0' LBDMP0/2 [ABDMP0/2 GBDMP0/2 0 EBDMP0 0 FBDMP0 90*RADDEG]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKRDG0={'be' 'BKRDG0' LK0 [AK0 GK0/2 0 AK0 0.5 0.5 90*RADDEG+SROL0]}';
BLRDG0={'be' 'BLRDG0' LS0 [AS0 GS0/2 0 AS0 0.5 0.5 SROL0]}';
BXDG0={'be' 'BXDG0' LH0 [-AH0 GH0/2 -AH0H -AH0H 0.5 0.5 0]}';
BYDG0={'be' 'BYDG0' LBDMP0 [ABDMP0 GBDMP0/2 EBDMP0 EBDMP0 FBDMP0 FBDMP0 90*RADDEG]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
KQDG004 =    8.650617883208;
KQDG005 =  -12.05998268496;
KQDG006 =    6.896965013903  ;
KQDG007 =   -4.414274650315;
KQDG008 =   11.243156019147;
KQDG009 =  -11.689200167844;
KQDG010 =   13.02067678689 ;
KQDG011 =  -10.983650981418;
QDG001={'qu' 'QDG001' LQS/2 [KQBF0 0]}';
QDG002={'qu' 'QDG002' LQS/2 [KQBD0 0]}';
QDG003={'qu' 'QDG003' LQS/2 [KQBF0 0]}';
QDG004={'qu' 'QDG004' LQX/2 [KQDG004 0]}';
QDG005={'qu' 'QDG005' LQX/2 [KQDG005 0]}';
QDG006={'qu' 'QDG006' LQX/2 [KQDG006 0]}';
QDG007={'qu' 'QDG007' LQX/2 [KQDG007 0]}';
QDG008={'qu' 'QDG008' LQX/2 [KQDG008 0]}';
QDG009={'qu' 'QDG009' LQX/2 [KQDG009 0]}';
QDG010={'qu' 'QDG010' LQX/2 [KQDG010 0]}';
QDG011={'qu' 'QDG011' LQX/2 [KQDG011 0]}';
% ==============================================================================
% MULT
% ------------------------------------------------------------------------------
% model misaligned quadrupoles
DYQDG001={'mu' 'DYQDG001' 0 [YK01 pi/2 0 0]}';
DYQDG003={'mu' 'DYQDG003' 0 [YK02 pi/2 0 0]}';
%VALUE, 1.E3*YK01/(KQBF0*LQs),1.E3*YK02/(KQBF0*LQs) vertical offsets (mm)
% ==============================================================================
% SROT
% ------------------------------------------------------------------------------
% removes creeping roll introduced by rolled Lambertson
RODG0K={'ro' 'RODG0K' 0 [-(AROLL0K)]}';
RODG0L={'ro' 'RODG0L' 0 [-(AROLL0L)]}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% dogleg
% ZKSD0  : dz between kicker exit and BLRDG0 entrance (m)
% ZHH1D0 : dz between BLRDG0 and 1st QDG001
% ZHH2D0 : dz between QDG001 and QDG002
% ZHH3D0 : dz between QDG002 and QDG003
% ZHH4D0 : dz between QDG003 and BXDG0
ZQS =  LQS*cos(XANG02);
ZKSD0 =  ZKS0-ZK0/2-ZS0/2;
ZKSD0A =  0.648904972995;
ZKSD0B =  ZKSD0-ZKSD0A;
ZHH1D0 =  ZHH0/4-ZQS/2-ZS0/2;
ZHH2D0 =  ZHH0/4-ZQS;
ZHH3D0 =  ZHH0/4-ZQS;
ZHH4D0 =  ZHH0/4-ZQS/2-ZH0/2;
DKV0={'dr' '' ZKSD0/cos(AK0) []}';
DQB01={'dr' '' (ZHH1D0-ZTWK0A+ZTWK0B)/cos(XANG02) []}';
DQB02={'dr' '' (ZHH2D0+ZTWK0A)/cos(XANG02) []}';
DQB03={'dr' '' (ZHH3D0+ZTWK0A)/cos(XANG02) []}';
DQB04={'dr' '' (ZHH4D0-ZTWK0A-ZTWK0B)/cos(XANG02) []}';
% 
% 
% 
% 
% 
% 

DKV0A={'dr' '' ZKSD0A/cos(AK0) []}';
DKV0B={'dr' '' ZKSD0B/cos(AK0) []}';
DQB01A={'dr' '' 0.15 []}';
DQB01C={'dr' '' 0.25 []}';
DQB01B={'dr' '' DQB01{3}-DQB01A{3}-DQB01C{3} []}';
DQB02B={'dr' '' 0.25 []}';
DQB02A={'dr' '' DQB02{3}-DQB02B{3} []}';
DQB03B={'dr' '' 0.25 []}';
DQB03A={'dr' '' DQB03{3}-DQB03B{3} []}';
DQB04B={'dr' '' 0.4532 []}';
DQB04A={'dr' '' DQB04{3}-DQB04B{3} []}';
% diagnostic line
DDG003={'dr' '' 0.374418820858 []}';%0.375213145904
DDG004={'dr' '' 0.541 []}';
DDG005={'dr' '' 0.592 []}';
DDG006={'dr' '' 2.492 []}';
DDG007={'dr' '' 0.592 []}';
DDG008={'dr' '' 0.592 []}';
DDG009={'dr' '' 2.962 []}';
DDG010={'dr' '' 0.592 []}';
DDG011={'dr' '' 1.4048 []}';
DDG012={'dr' '' 0.935296300379 []}';
DDG004A={'dr' '' DDG004{3}/2 []}';
DDG004B={'dr' '' DDG004{3}-DDG004A{3} []}';
DDG005A={'dr' '' DDG005{3}/2 []}';
DDG005B={'dr' '' DDG005{3}-DDG005A{3} []}';
DDG006A={'dr' '' 0.296 []}';
DDG006B={'dr' '' 0.12714 []}';
DDG006C={'dr' '' 0.17286 []}';
DDG006D={'dr' '' DDG006{3}-DDG006A{3}-2*TCYDG0{3}-DDG006B{3}-DDG006C{3}-2*TCXDG0{3} []}';
DDG008A={'dr' '' 0.296 []}';
DDG008B={'dr' '' DDG008{3}-DDG008A{3} []}';
DDG009A={'dr' '' 0.296 []}';
DDG009B={'dr' '' 0.7 []}';
DDG009C={'dr' '' 0.3 []}';
DDG009D={'dr' '' 0.3 []}';
DDG009E={'dr' '' 0.7 []}';
DDG009F={'dr' '' DDG009{3}-DDG009A{3}-DDG009B{3}-DDG009C{3}-DDG009D{3}-DDG009E{3} []}';
DDG010A={'dr' '' 0.296 []}';
DDG010B={'dr' '' DDG010{3}-DDG010A{3} []}';
DDG011A={'dr' '' 0.3 []}';
DDG011B={'dr' '' DDG011{3}-DDG011A{3} []}';
DDG012A={'dr' '' 0.395296300379 []}';
DDG012B={'dr' '' 0.24 []}';
DDG012C={'dr' '' DDG012{3}-(DDG012A{3}+DDG012B{3}) []}';
BMINDG0 =  (DDG009B{3}+DDG009C{3})/sqrt(3) ;%waist (120 deg between OTRs)
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMDG000={'mo' 'BPMDG000' 0 []}';
BPMDG001={'mo' 'BPMDG001' 0 []}';
BPMDG002={'mo' 'BPMDG002' 0 []}';
BPMDG003={'mo' 'BPMDG003' 0 []}';
BPMDG004={'mo' 'BPMDG004' 0 []}';
BPMDG005={'mo' 'BPMDG005' 0 []}';
BPMDG0RF={'mo' 'BPMDG0RF' 0 []}';
BPMDG008={'mo' 'BPMDG008' 0 []}';
BPMDG009={'mo' 'BPMDG009' 0 []}';
BPMDG011={'mo' 'BPMDG011' 0 []}';
RFBDG001={'mo' 'RFBDG001' 0 []}';
RFBDG002={'mo' 'RFBDG002' 0 []}';
RFBDG003={'mo' 'RFBDG003' 0 []}';
BPMDG012={'mo' 'BPMDG012' 0 []}';%RFBDG004 : MONI, TYPE="@2,CavityL-1"
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCDG001={'mo' 'XCDG001' 0 []}';
XCDG002={'mo' 'XCDG002' 0 []}';
XCDG003={'mo' 'XCDG003' 0 []}';
XCDG005={'mo' 'XCDG005' 0 []}';
XCDG008={'mo' 'XCDG008' 0 []}';
XCDG010={'mo' 'XCDG010' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCDG001={'mo' 'YCDG001' 0 []}';
YCDG002={'mo' 'YCDG002' 0 []}';
YCDG003={'mo' 'YCDG003' 0 []}';
YCDG005={'mo' 'YCDG005' 0 []}';
YCDG008={'mo' 'YCDG008' 0 []}';
YCDG010={'mo' 'YCDG010' 0 []}';
% ==============================================================================
% diagnostics, etc.
% ------------------------------------------------------------------------------
% profile monitors
OTRDG01={'mo' 'OTRDG01' 0 []}';
OTRDG02={'mo' 'OTRDG02' 0 []}';
OTRDG03={'mo' 'OTRDG03' 0 []}';
OTRDG04={'mo' 'OTRDG04' 0 []}';
% wire scanners
WSDG01={'mo' 'WSDG01' 0 []}';
% charge monitors
FCDG0DU={'mo' 'FCDG0DU' 0 []}';
% ==============================================================================
% marker points
% ------------------------------------------------------------------------------
M1DG0={'mo' 'M1DG0' 0 []}';
CNTDG0={'mo' 'CNTDG0' 0 []}';
M2DG0={'mo' 'M2DG0' 0 []}';
MTCYDG0={'mo' 'MTCYDG0' 0 []}';
MTCXDG0={'mo' 'MTCXDG0' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
TCYDG0_FULL=[TCYDG0,MTCYDG0,TCYDG0];
TCXDG0_FULL=[TCXDG0,MTCXDG0,TCXDG0];
BKRDG0_FULL=[BKRDG0A,BKRDG0B];
BLRDG0_FULL=[BLRDG0A,BLRDG0B];
BXDG0_FULL=[BXDG0A,BXDG0B];
BYDG0_FULL=[BYDG0A,BYDG0B];
QDG001_FULL=[QDG001,BPMDG001,DYQDG001,QDG001];
QDG002_FULL=[QDG002,BPMDG002,QDG002];
QDG003_FULL=[QDG003,BPMDG003,DYQDG003,QDG003];
QDG004_FULL=[QDG004,BPMDG004,QDG004];
QDG005_FULL=[QDG005,BPMDG005,QDG005];
QDG006_FULL=[QDG006,QDG006];
QDG007_FULL=[QDG007,QDG007];
QDG008_FULL=[QDG008,BPMDG008,QDG008];
QDG009_FULL=[QDG009,BPMDG009,QDG009];
QDG010_FULL=[QDG010,QDG010];
QDG011_FULL=[QDG011,BPMDG011,QDG011];
SCDG003=[XCDG003,YCDG003];
SCDG005=[XCDG005,YCDG005];
SCDG008=[XCDG008,YCDG008];
SCDG010=[XCDG010,YCDG010];
% %simplified
% DIAG0=[BEGDIAG0,BKRDG0A,BKRDG0B,RODG0K,DKV0,M1DG0,BLRDG0A,BLRDG0B,RODG0L,DQB01,QDG001,DYQDG001,QDG001,DQB02,QDG002,QDG002,DQB03,QDG003,DYQDG003,QDG003,DQB04,BXDG0A,BXDG0B,CNTDG0,M2DG0,DDG003,QDG004,QDG004,DDG004,QDG005,QDG005,DDG005,QDG006,QDG006,DDG006,QDG007,QDG007,DDG007,QDG008,QDG008,DDG008,QDG009,QDG009,DDG009,QDG010,QDG010,DDG010,QDG011,QDG011,DDG011,BYDG0A,BYDG0B,DDG012,ENDDIAG0];

%COMMENT complete
DIAG0=[BEGDIAG0,BKRDG0_FULL,RODG0K,DKV0A,BPMDG000,DKV0B,M1DG0,BLRDG0_FULL,RODG0L,DQB01A,RFBDG001,DQB01B,XCDG001,DQB01C,QDG001_FULL,DQB02A,YCDG001,DQB02B,QDG002_FULL,DQB03A,XCDG002,DQB03B,QDG003_FULL,DQB04A,YCDG002,DQB04B,BXDG0_FULL,CNTDG0,M2DG0,DDG003,QDG004_FULL,DDG004A,SCDG003,DDG004B,QDG005_FULL,DDG005A,SCDG005,DDG005B,QDG006_FULL,DDG006A,TCYDG0_FULL,DDG006B,BPMDG0RF,DDG006C,TCXDG0_FULL,DDG006D,QDG007_FULL,DDG007,QDG008_FULL,DDG008A,SCDG008,DDG008B,QDG009_FULL,DDG009A,OTRDG01,DDG009B,RFBDG002,DDG009C,OTRDG02,DDG009D,WSDG01,DDG009E,OTRDG03,DDG009F,QDG010_FULL,DDG010A,SCDG010,DDG010B,QDG011_FULL,DDG011A,RFBDG003,DDG011B,BYDG0_FULL,DDG012A,BPMDG012,DDG012B,OTRDG04,DDG012C,FCDG0DU,ENDDIAG0];
%ENDCOMMENT
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc injector: gun to start of L1 linac
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 26-NOV-2019, M. Woodley
%  * Remove IMBCSi3; undefer IMBCSi1 and IMBCSi2 ... per D. Yeremian
% 20-NOV-2019, M. Woodley
%  * New measured Leff (based on Bz^2) for gun solenoids per D. Dowell
% 11-NOV-2019, M. Woodley
%  * Use 9*lam as length of laser heater undulator per C. Mayes
% 03-JUL-2019, M. Woodley
%  * Use measured Leff for gun solenoids (SOL1B=0.1342 m, SOL2B=0.1350 m)
% ------------------------------------------------------------------------------
% 30-APR-2019, M. Woodley
%  * Update locations of GUNB devices per F. Zhou and G. Gassner
% ------------------------------------------------------------------------------
% 14-MAY-2018, M. Woodley
%  * use LCLS-II Phase 1 laser heater undulator per PRD (LCLSII-2.2-PR-0086-R1)
% 12-MAR-2018, M. Woodley
%  * update GUNB device locations to LBNL__Low_E_Beamline__030418.pdf
%  * move GUNB correctors to G. Gassner's measured locations
% ------------------------------------------------------------------------------
% 14-FEB-2018, M. Woodley
%  * remove STC0 per G. DeContreras
% 31-JAN-2018, M. Woodley
%  * use measured FINT (0.3887) for BCXH1-4
%  * add special beamline for Early Injector Commissioning (include Faraday cup)
% 20-DEC-2017, M. Woodley
%  * remove BCS ACM IMBCSC0 per C. Clarke
%  * add IMBCSi1-3 (BCS ACM triplet) per C. Clarke and H. Alvarez
% 06-DEC-2017, M. Woodley
%  * convert vacuum valves VV01B and VV02B from MARKers to INSTs per F. Zhou
% ------------------------------------------------------------------------------
% 05-SEP-2017, M. Woodley
%  * move YCHD03-RFBHD04 5" upstream per H. Alvarez
% ------------------------------------------------------------------------------
% 04-MAY-2017, M. Woodley
%  * change element names to equivalent LCLS names with appended "B"
%  * move IMBCSC0 u/s 0.009525 m (Z=55.425365) per C. Iverson
% ------------------------------------------------------------------------------
% 24-FEB-2017, M. Woodley
%  * undefer YCC005, XCC006, YCC009, and XCC010 per P. Emma
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * rearrange diagnostic devices around WS0H04 per H. Alvarez
%  * undefer PC0H00, BPMH1, BPMH2, and IMBCSC0 (add-back list items)
%  * add L0 u/s beamline flange
% ------------------------------------------------------------------------------
% 09-JUN-2016, M. Woodley
%  * adjust D0H00 and D0H00a lengths ... longer L0 d/s MSC; move PC0H00 1.5" u/s
%  * set BPMH1 and BPMH2 deferment level to 0
%  * move BPMDG000 to center between BKRDG0 and BLRDG0
%  * set IMBCSC0 TYPE="BCS cavity"
%  * move IMBCSC0 upstream of STC0
% ------------------------------------------------------------------------------
% 25-FEB-2016, M. Woodley
%  * use non-relativistic calculation of Brho in the GUNB region
%  * set BSOL01 = BSOL02 = 0
% 24-FEB-2016, M. Woodley
%  * new GUNB layout per M. Johnson (LBNL) and H. Alvarez
% 01-FEB-2016, M. Woodley
%  * new 100 pC input beams from J. Qiang/C. Mitchell
% 01-NOV-2015, M. Woodley
%  * new 100 pC input beam from F. Zhou (Twiss from P. Emma)
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * add MARKers for vacuum components upstream of Q0H01
%  * add fixed 60 mm long, 12 mm bore tungsten PC upstream of Q0H01 (deferred)
%  * change Q0H01-08 and QHD01-04 type to "2Q4"
%  * change class-1a correctors between L0 and DIAG0 to class-6 (separate X, Y)
%  * change "Stripline-1" BPMs between L0 and DIAG0 to "Stripline-12"
%  * switch locations of ST0 and IMBCSC0 per S. Mao
%  * change TYPE of OTRs and YAGs per Henrik's PRD
%  * define zero-angle SBENs at position of DIAG0 kicker and septum
%  * adjust locations of devices per H. Alvarez
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * add quad/skew quad MARKers at each end of each solenoid
%  * add 5th x/y corrector pair u/s of buncher ... renumber correctors
%  * undefer BUN01 (buncher) and UMHTR (laser heater undulator)
%  * adjust final drift length before L0 per H. Alvarez
%  * undefer WS0H04 and BZ0H04
%  * move laser heater BPMs to outer bend-to-bend drifts; new stripline type
%  * undefer YAGH1 and YAGH2
%  * positions of devices at laser heater chicane center per G. Bouchard
%  * undefer BPMC002, BPMC007, and BPMC008
%  * undefer YCC003
%  * move IMBCSC0/STC0 upstream per G. DeContreras
%  * move OTRC011 and WSC011 upstream, out of "particle free" zone; change
%    their names to OTRC006 and WSC006
%  * collimator gaps per P. Emma
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * location of components u/s of L0 per S. Virostek
%  * add BCS ACM downstream of COL0 collimators
%  * fix interferences per H. Alvarez
%  * set collimator lengths (tungsten) and gaps per LCLSII-2.4-PR-0095-R0
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * interference resolution mods per H. Alvarez:
%    - move SCC000 (XCC000/YCC000) 4.0 cm (1.5 inches) upstream
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * generate matched optics between laser heater chicane and DIAG0 extraction
%    point for LHUND off and LH chicane off
%  * adjust length of matching section between LH and COL0 to put gun at
%    Z= -10.0 m exactly
%  * move COL0 collimators 7 inches closer to their associated quadrupoles
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * new LBNL buncher cavity length per H. Alvarez
%  * add 4 LBNL design X/Y corrector pairs per H. Alvarez
%  * move differential pumping drift into L0 (u/s of Q0H01)
%  * reverse direction of laser heater chicane (into aisle) per H. Alvarez
%  * shorten COL0 FODO cell to 8.0 m
%  * replace narrow "Collins" quadrupole (1.0Q3.1) with standard 1.26Q3.5
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * update L0 d/s end cap and mechanical stay clear dimensions
%  * space for L0 differential vacuum pumping between Q0H02 and Q0H03
%  * add emittance measurement in L0-to-laser-heater matching section
%  * laser heater chicane lengthened to reduce R56 to 3.5 mm
%  * CEHTR collimator moved u/s of undulator
%  * COL0 collimation system now consists of four 45 degree FODO cells with 3
%    pairs of collimators separated by 45 degrees (22 m betas at collimators);
%    FODO cell length is 12 m
%  * add a wire scanner at the end of COL0 for "tomographic" emittance
%    measurement
%  * decorate device TYPE attributes to indicate non-baseline status
% ------------------------------------------------------------------------------
% 17-APR-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
%  * explicitly define R55=R66=1 in MATRs (for translation to BMAD)
% ------------------------------------------------------------------------------
% 19-MAR-2014, M. Woodley
%  * matching around extraction to DIAG0 changed
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% 13-JAN-2014, M. Woodley
%  * parameters of buncher and solenoids per C. Papadopoulos
%    (Parameters_GUN2013_10_08v3.docx) ...
% ------------------------------------------------------------------------------
% 07-JAN-2014, M. Woodley
%  * devices between CATHODE and CM01 per H. Alvarez
% ------------------------------------------------------------------------------
% ==============================================================================
% LCAV
% ------------------------------------------------------------------------------
% buncher cavity
% (no gradient/phase values available)
LBUN =  0.21876 ;%m
ABUN =  0.0517  ;%m
GBUN =  0       ;%MV/m
PBUN =  0       ;%deg
BUN1B={'lc' 'BUN1B' LBUN/2 [1300 GBUN*LBUN/2 PBUN/360*TWOPI]}';
% ==============================================================================
% SBEN
% ------------------------------------------------------------------------------
% laser heater chicane
% - approximate on-axis effective length per R. Carr (01-AUG-05 PE)
% - use series approximation for sinc(x)=sin(x)/x to allow BCXH=0
% Brhoh : beam rigidity at chicane (kG-m)
% GBh   : 5D3.9 gap height (m)
% ZBh   : 5D3.9 "Z" length (m)
% FBh   : measured chicane bend FINT/FINTX
% ABh   : chicane bend angle (rad)
% BBh   : heater-chicane bend field (kG)
% LBh   : chicane bend path length (m)
% ABhS  : "short" half chicane bend angle (rad)
% LBhS  : "short" half chicane bend path length (m)
% ABhL  : "long" half chicane bend angle (rad)
% LBhL  : "long" half chicane bend path length (m)
BRHOH =  CB*EI;
GBH =  0.03;
ZBH =  0.1244;
FBH =  0.3887;
ABH =  0.022113826596 ;%R56=0.0035
BBH =  BRHOH*sin(ABH)/ZBH;
ABH_2 =  ABH*ABH;
ABH_4 =  ABH_2*ABH_2;
ABH_6 =  ABH_4*ABH_2;
SINCABH =  1-ABH_2/6+ABH_4/120-ABH_6/5040 ;%~sinc(ABh)=sin(ABh)/ABh
LBH =  ZBH/SINCABH;
ABHS =  asin(sin(ABH)/2);
ABHS_2 =  ABHS*ABHS;
ABHS_4 =  ABHS_2*ABHS_2;
ABHS_6 =  ABHS_4*ABHS_2;
SINCABHS =  1-ABHS_2/6+ABHS_4/120-ABHS_6/5040 ;%~sinc(ABhS)=sin(ABhS)/ABhS
LBHS =  ZBH/(2*SINCABHS);
ABHL =  ABH-ABHS;
LBHL =  LBH-LBHS;
BCXH1A={'be' 'BCXH1' LBHS [+ABHS GBH/2 0 0 FBH 0 0]}';
BCXH1B={'be' 'BCXH1' LBHL [+ABHL GBH/2 0 +ABH 0 FBH 0]}';
BCXH2A={'be' 'BCXH2' LBHL [-ABHL GBH/2 -ABH 0 FBH 0 0]}';
BCXH2B={'be' 'BCXH2' LBHS [-ABHS GBH/2 0 0 0 FBH 0]}';
BCXH3A={'be' 'BCXH3' LBHS [-ABHS GBH/2 0 0 FBH 0 0]}';
BCXH3B={'be' 'BCXH3' LBHL [-ABHL GBH/2 0 -ABH 0 FBH 0]}';
BCXH4A={'be' 'BCXH4' LBHL [+ABHL GBH/2 +ABH 0 FBH 0 0]}';
BCXH4B={'be' 'BCXH4' LBHS [+ABHS GBH/2 0 0 0 FBH 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXH1={'be' 'BCXH' LBH [+ABH GBH/2 0 +ABH FBH FBH 0]}';
BCXH2={'be' 'BCXH' LBH [-ABH GBH/2 -ABH 0 FBH FBH 0]}';
BCXH3={'be' 'BCXH3' LBH [-ABH GBH/2 0 -ABH FBH FBH 0]}';
BCXH4={'be' 'BCXH4' LBH [+ABH GBH/2 +ABH 0 FBH FBH 0]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
% correction coils co-wound on GUNB solenoids
CQ01B={'mu' 'CQ01B' 0 [0 0 0 0]}';
SQ01B={'mu' 'SQ01B' 0 [0 0 0 pi/4]}';
CQ02B={'mu' 'CQ02B' 0 [0 0 0 0]}';
SQ02B={'mu' 'SQ02B' 0 [0 0 0 pi/4]}';
% L0 to WS/OTR (Q0H01-4 match to waists at WS0H04)
KQ0H01 =  -6.391217650404;
KQ0H02 =   5.905989161645;
KQ0H03 =   2.403934435238;
KQ0H04 =  -6.042774733767;
Q0H01={'qu' 'Q0H01' LQM/2 [KQ0H01 0]}';
Q0H02={'qu' 'Q0H02' LQM/2 [KQ0H02 0]}';
Q0H03={'qu' 'Q0H03' LQM/2 [KQ0H03 0]}';
Q0H04={'qu' 'Q0H04' LQM/2 [KQ0H04 0]}';
% WS/OTR to laser heater (Q0H05-8 match to 10x10 m beta waists LHMID)
%              heater ON        heater OFF        chicane OFF      
%           ---------------   ---------------   ---------------   
KQ0H05 =  -6.527332462108 ;% -7.451314362911  -7.50807265705   
KQ0H06 =   1.004021266025 ;%  1.835321162849   1.870908387703  
KQ0H07 =   7.966955932383 ;%  7.794364054297   7.804907479843  
KQ0H08 =  -8.322028344122 ;% -8.272683698332  -8.306722243052  
Q0H05={'qu' 'Q0H05' LQM/2 [KQ0H05 0]}';
Q0H06={'qu' 'Q0H06' LQM/2 [KQ0H06 0]}';
Q0H07={'qu' 'Q0H07' LQM/2 [KQ0H07 0]}';
Q0H08={'qu' 'Q0H08' LQM/2 [KQ0H08 0]}';
% laser heater to diagnostic line
%              heater ON        heater OFF        chicane OFF      
%           ---------------   ---------------   ---------------   
KQHD01 =  -9.146654274235 ;% -8.743988180274  -8.746794738551  
KQHD02 =   6.533213571851 ;%  6.400024201736   6.401620200767  
KQHD03 =  -8.452537880402 ;% -8.612136472635  -8.622952974047  
KQHD04 =   6.748361072085 ;%  6.860670404609   6.864937307631  
QHD01={'qu' 'QHD01' LQM/2 [KQHD01 0]}';
QHD02={'qu' 'QHD02' LQM/2 [KQHD02 0]}';
QHD03={'qu' 'QHD03' LQM/2 [KQHD03 0]}';
QHD04={'qu' 'QHD04' LQM/2 [KQHD04 0]}';
% collimation FODO
KQCOLL0 =  1.787850470726  ;%45 degree FODO
% BminColl0 := 6.996145818354
% BmaxColl0 := 15.616293369747
QFCOLL0={'qu' 'QFCOLL0' LQX/2 [KQCOLL0 0]}';
QDCOLL0={'qu' 'QDCOLL0' LQX/2 [-KQCOLL0 0]}';
% COL0 collimation section
KQC001 =   5.055115116374;
KQC002 =   0.157983741128;
KQC003 =  -5.345027237286;
KQC004 =   2.756594856365;
KQC005 =  -KQCOLL0;
KQC006 =   KQCOLL0;
KQC007 =  -KQCOLL0;
KQC008 =   KQCOLL0;
KQC009 =  -KQCOLL0;
KQC010 =   0.969436091839;
KQC011 =  -1.547365108062;
KQC012 =   1.300461653449;
QC001={'qu' 'QC001' LQX/2 [KQC001 0]}';
QC002={'qu' 'QC002' LQX/2 [KQC002 0]}';
QC003={'qu' 'QC003' LQX/2 [KQC003 0]}';
QC004={'qu' 'QC004' LQX/2 [KQC004 0]}';
QC005={'qu' 'QC005' LQX/2 [KQC005 0]}';
QC006={'qu' 'QC006' LQX/2 [KQC006 0]}';
QC007={'qu' 'QC007' LQX/2 [KQC007 0]}';
QC008={'qu' 'QC008' LQX/2 [KQC008 0]}';
QC009={'qu' 'QC009' LQX/2 [KQC009 0]}';
QC010={'qu' 'QC010' LQX/2 [KQC010 0]}';
QC011={'qu' 'QC011' LQX/2 [KQC011 0]}';
QC012={'qu' 'QC012' LQX/2 [KQC012 0]}';
% ==============================================================================
% SOLE
% ------------------------------------------------------------------------------
% solenoids between gun and L0
RSOL =  0.0475/2;
LSOL1 =  0.0861              ;%m (measured) 0.1342
LSOL2 =  0.0869              ;%m (measured) 0.1350
BSOL1 =  0                   ;%0.0570 T
BSOL2 =  0                   ;%0.0322 T
BRHO =  CB*sqrt(E0^2-MC2^2) ;%kG-m (non-relativistic)
KSOL1 =  (10*BSOL1)/BRHO     ;%1/m
KSOL2 =  (10*BSOL2)/BRHO     ;%1/m
SOL1BKB={'so' 'SOL1BKB' 0 [0]}';
SOL1B={'so' 'SOL1B' LSOL1/2 [KSOL1]}';
SOL2B={'so' 'SOL2B' LSOL2/2 [KSOL2]}';
% ==============================================================================
% MATR
% ------------------------------------------------------------------------------
% laser heater undulator
% - modeled as R-matrix to include vertical natural focusing
% - parameters from LCLS-II Phase 1 undulator
% lam   : laser-heater undulator period [m]
% lamr  : heater laser wavelength [m]
% gami  : Lorentz energy factor in laser-heater undulator [1]
% K_und : undulator K for laser heater undulator
% Lhun  : length of laser-heater undulator (10 periods) [m]
% Lhunh : half-length of laser-heater undulator [m]
% kqlh  : natural undulator focusing "k" in y-plane [1/m2]
LAM =  0.054 ;%0.0471204
LAMR =  1030E-9;
GAMI =  EI/EMASS;
K_UND =  sqrt(2*(LAMR*2*GAMI^2/LAM-1));
LHUN =  9*LAM ;%0.506263
LHUNH =  LHUN/2;
KQLH =  (K_UND*2*PI/LAM/sqrt(2)/GAMI)^2;
% handle K_und->0 by expressing R34 as an approximate SINC function
ARGH =  LHUNH*sqrt(KQLH);
ARGH2 =  ARGH*ARGH;
ARGH4 =  ARGH2*ARGH2;
ARGH6 =  ARGH4*ARGH2;
SINCARGH =  1-ARGH2/6+ARGH4/120-ARGH6/5040 ;%~sinc(ARGh)=sin(ARGh)/ARGh
R34H =  LHUNH*SINCARGH;
% undulator segment modeled as R-matrix to include vertical natural focusing
UMHTR={'un' 'UMHTR' LHUNH [KQLH LAM 1]}';%,                               &
%RM(5,6)=Lhunh/(gami^2)*(1+(K_und^2)/2)
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% gun to L0
LGUN =  0.04 ;%APEX gun
DGBCA={'dr' '' -0.071705 []}';
DGBCB={'dr' '' 0.071705 []}';
DGUN={'dr' '' LGUN []}';
DG001={'dr' '' 0.246530-LGUN-LSOL1/2 []}';
DG002={'dr' '' 0.140950-LSOL1/2 []}';
DG003={'dr' '' 0.097020 []}';
DG004={'dr' '' 0.005150 []}';
DG005={'dr' '' 0.105042 []}';
DG006={'dr' '' 0.075408 []}';
DG007={'dr' '' 0.139016-LBUN/2 []}';
DG008={'dr' '' 0.155084-LBUN/2 []}';
DG009={'dr' '' 0.181801 []}';
DG010={'dr' '' 0.222999 []}';
DG011={'dr' '' 0.121314 []}';
DG012={'dr' '' 0.155496-LSOL2/2 []}';
DG013={'dr' '' 0.136970-LSOL2/2 []}';
DG014={'dr' '' 0.101444 []}';
DG015={'dr' '' 0.004540 []}';
DG016={'dr' '' 0.163813 []}';
DG016B={'dr' '' 0.082968 []}';
DG016A={'dr' '' DG016{3}-DG016B{3} []}';
DGEIC={'dr' '' 3.0-2.052577 []}';
% L0 to laser heater
D0H00={'dr' '' 0.407975 []}';
D0H01={'dr' '' 0.427898 []}';
D0H02={'dr' '' 4.179215 []}';
D0H03={'dr' '' 0.409812 []}';
D0H04={'dr' '' 1.0979 []}';
D0H05={'dr' '' 0.409812 []}';
D0H06={'dr' '' 1.366076 []}';
D0H07={'dr' '' 0.409812 []}';
D0H08={'dr' '' 0.3687 []}';
D0H00B={'dr' '' 0.291975 []}';
D0H00A={'dr' '' D0H00{3}-LJAW-D0H00B{3} []}';
D0H01A={'dr' '' 0.213949 []}';
D0H01B={'dr' '' D0H01{3}-D0H01A{3} []}';
D0H02A={'dr' '' 0.204906 []}';
D0H02B={'dr' '' 0.443171 []}';
D0H02C={'dr' '' 0.64135 []}';
D0H02D={'dr' '' 0.64135 []}';
D0H02F={'dr' '' 0.204906 []}';
D0H02E={'dr' '' D0H02{3}-D0H02A{3}-D0H02B{3}-D0H02C{3}-D0H02D{3}-D0H02F{3} []}';
D0H03A={'dr' '' 0.204906 []}';
D0H03B={'dr' '' D0H03{3}-D0H03A{3} []}';
D0H04A={'dr' '' 0.2148 []}';
D0H04B={'dr' '' 0.0333 []}';
D0H04C={'dr' '' 0.2437 []}';
D0H04D={'dr' '' 0.2492 []}';
D0H04E={'dr' '' D0H04{3}-D0H04A{3}-D0H04B{3}-D0H04C{3}-D0H04D{3} []}';
D0H05A={'dr' '' 0.204906 []}';
D0H05B={'dr' '' D0H05{3}-D0H05A{3} []}';
D0H06A={'dr' '' 0.204906 []}';
D0H06C={'dr' '' 0.204906 []}';
D0H06B={'dr' '' D0H06{3}-D0H06A{3}-D0H06C{3} []}';
D0H07A={'dr' '' 0.204906 []}';
D0H07B={'dr' '' D0H07{3}-D0H07A{3} []}';
D0H08A={'dr' '' 0.1934 []}';
D0H08B={'dr' '' D0H08{3}-D0H08A{3} []}';
% laser heater
ZHBBO =  3.264933791099;
ZHBBI =  2.009304;
ZHBMO =  1.53742329;
ZHBMIU =  0.37561671;
ZHBMID =  1.389994208901;
DLHUN =  0.506263-9*LAM ;%adjust undulator length
DH01={'dr' '' ZHBBO/cos(ABH) []}';
DH01A={'dr' '' ZHBMO/cos(ABH) []}';
DH01B={'dr' '' ZHBMIU/cos(ABH) []}';
DH01C={'dr' '' DH01{3}-DH01A{3}-DH01B{3} []}';
DH02={'dr' '' ZHBBI []}';
DH02A={'dr' '' 0.192614-LJAW/2 []}';
DH02B={'dr' '' 0.298450-LJAW/2 []}';
DH02C={'dr' '' 0.2795065+DLHUN/2 []}';%0.2795065
DH02D={'dr' '' 0.2724707+DLHUN/2 []}';%0.2724707
DH02E={'dr' '' 0.4599998 []}';
DH03={'dr' '' ZHBBO/cos(ABH) []}';
DH03A={'dr' '' ZHBMID/cos(ABH) []}';
DH03C={'dr' '' ZHBMO/cos(ABH) []}';
DH03B={'dr' '' DH03{3}-DH03A{3}-DH03C{3} []}';
% laser heater to diagnostic line
DHD00={'dr' '' 0.381398817802 []}';
DHD01={'dr' '' 0.6566 []}';
DHD02={'dr' '' 2.580388 []}';
DHD03={'dr' '' 0.459812 []}';
DHD04={'dr' '' 0.3687996 []}';
DHD00B={'dr' '' 0.1 []}';
DHD00A={'dr' '' DHD00{3}-DHD00B{3} []}';
DHD01A={'dr' '' 0.204906 []}';
DHD01C={'dr' '' 0.204906 []}';
DHD01B={'dr' '' DHD01{3}-DHD01A{3}-DHD01C{3} []}';
DHD02B={'dr' '' 0.204906 []}';
DHD02A={'dr' '' DHD02{3}-DHD02B{3} []}';
DHD02A2={'dr' '' 0.305410 []}';
DHD02A3={'dr' '' 0.777294 []}';
DHD02A1={'dr' '' DHD02A{3}-DHD02A2{3}-DHD02A3{3} []}';
DHD03B={'dr' '' 0.204906 []}';
DHD03A={'dr' '' DHD03{3}-DHD03B{3} []}';
DHD04A={'dr' '' 0.1208998 []}';
DHD04B={'dr' '' DHD04{3}-DHD04A{3} []}';
% 
% 
% 
% 
% 
% 

% collimation FODO
DCOLL0={'dr' '' 4.0-LQX []}';
DCOLL0A={'dr' '' 0.2508 []}';
DCOLL0C={'dr' '' 0.325-LJAW/2 []}';
DCOLL0B={'dr' '' DCOLL0{3}-DCOLL0A{3}-LJAW-DCOLL0C{3} []}';
DCOLL0B2={'dr' '' 0.3 []}';
DCOLL0B3={'dr' '' 0.3151 []}';
DCOLL0B4={'dr' '' 0.25-LJAW/2 []}';
DCOLL0B1={'dr' '' DCOLL0B{3}-DCOLL0B2{3}-DCOLL0B3{3}-DCOLL0B4{3} []}';
DCOLL0B5={'dr' '' 3.2862 []}';
% DIAG0 extraction magnets
DBKRDG0A={'dr' '' 0.5 []}';
DBKRDG0B={'dr' '' 0.5 []}';
DBLRDG0A={'dr' '' 0.2 []}';
DBLRDG0B={'dr' '' 0.2 []}';
% COL0 collimation section
DC000={'dr' '' 5.4832+4E-7 []}';
DC001={'dr' '' 0.673 []}';
DC002={'dr' '' 0.8238 []}';
DC003={'dr' '' 1.533669597623 []}';
DC004={'dr' '' 5.2128 []}';
DC010={'dr' '' DCOLL0{3} []}';
DC011={'dr' '' 2.8252 []}';
DC000A={'dr' '' ZKSD0 []}';
DC000C={'dr' '' 0.19 []}';
DC000B={'dr' '' DC000{3}-ZK0-DC000A{3}-ZS0-DC000C{3} []}';%2.5932004
DC003A={'dr' '' 0.2508 []}';
DC003B={'dr' '' DC003{3}-DC003A{3} []}';
DC004A={'dr' '' 0.2508 []}';
DC004C={'dr' '' 0.325-LJAW/2 []}';
DC004B={'dr' '' DC004{3}-DC004A{3}-LJAW-DC004C{3} []}';
DC010A={'dr' '' DCOLL0A{3} []}';
DC010C={'dr' '' 0.3 []}';
DC010B={'dr' '' DC010{3}-DC010A{3}-DC010C{3} []}';
DC011A={'dr' '' 0.2508 []}';
DC011C={'dr' '' 0.327 []}';
DC011B={'dr' '' DC011{3}-DC011A{3}-DC011C{3} []}';
DC000AA={'dr' '' ZKSD0A []}';
DC000AB={'dr' '' ZKSD0B []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPM1B={'mo' 'BPM1B' 0 []}';
BPM2B={'mo' 'BPM2B' 0 []}';
BPM0H01={'mo' 'BPM0H01' 0 []}';
BPM0H04={'mo' 'BPM0H04' 0 []}';
BPM0H05={'mo' 'BPM0H05' 0 []}';
BPM0H08={'mo' 'BPM0H08' 0 []}';
BPMH1={'mo' 'BPMH1' 0 []}';
BPMH2={'mo' 'BPMH2' 0 []}';
BPMHD01={'mo' 'BPMHD01' 0 []}';
BPMHD02={'mo' 'BPMHD02' 0 []}';
BPMHD03={'mo' 'BPMHD03' 0 []}';
BPMHD04={'mo' 'BPMHD04' 0 []}';
BPMC001={'mo' 'BPMC001' 0 []}';
BPMC002={'mo' 'BPMC002' 0 []}';
BPMC003={'mo' 'BPMC003' 0 []}';
BPMC004={'mo' 'BPMC004' 0 []}';
BPMC005={'mo' 'BPMC005' 0 []}';
BPMC006={'mo' 'BPMC006' 0 []}';
BPMC007={'mo' 'BPMC007' 0 []}';
BPMC008={'mo' 'BPMC008' 0 []}';
BPMC009={'mo' 'BPMC009' 0 []}';
BPMC010={'mo' 'BPMC010' 0 []}';
BPMC011={'mo' 'BPMC011' 0 []}';
BPMC012={'mo' 'BPMC012' 0 []}';
RFB0H00={'mo' 'RFB0H00' 0 []}';
RFB0H04={'mo' 'RFB0H04' 0 []}';
RFB0H08={'mo' 'RFB0H08' 0 []}';
RFBHD00={'mo' 'RFBHD00' 0 []}';
RFBHD04={'mo' 'RFBHD04' 0 []}';
RFBC006={'mo' 'RFBC006' 0 []}';
RFBC011={'mo' 'RFBC011' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC01B={'mo' 'XC01B' 0 []}';
XC02B={'mo' 'XC02B' 0 []}';
XC03B={'mo' 'XC03B' 0 []}';
XC04B={'mo' 'XC04B' 0 []}';
XC05B={'mo' 'XC05B' 0 []}';
XC0H01={'mo' 'XC0H01' 0 []}';
XC0H03={'mo' 'XC0H03' 0 []}';
XC0H05={'mo' 'XC0H05' 0 []}';
XC0H07={'mo' 'XC0H07' 0 []}';
XCHD01={'mo' 'XCHD01' 0 []}';
XCHD03={'mo' 'XCHD03' 0 []}';
XCC000={'mo' 'XCC000' 0 []}';
XCC004={'mo' 'XCC004' 0 []}';
XCC006={'mo' 'XCC006' 0 []}';
XCC008={'mo' 'XCC008' 0 []}';
XCC010={'mo' 'XCC010' 0 []}';
XCC012={'mo' 'XCC012' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC01B={'mo' 'YC01B' 0 []}';
YC02B={'mo' 'YC02B' 0 []}';
YC03B={'mo' 'YC03B' 0 []}';
YC04B={'mo' 'YC04B' 0 []}';
YC05B={'mo' 'YC05B' 0 []}';
YC0H01={'mo' 'YC0H01' 0 []}';
YC0H03={'mo' 'YC0H03' 0 []}';
YC0H05={'mo' 'YC0H05' 0 []}';
YC0H07={'mo' 'YC0H07' 0 []}';
YCHD01={'mo' 'YCHD01' 0 []}';
YCHD03={'mo' 'YCHD03' 0 []}';
YCC000={'mo' 'YCC000' 0 []}';
YCC003={'mo' 'YCC003' 0 []}';
YCC005={'mo' 'YCC005' 0 []}';
YCC007={'mo' 'YCC007' 0 []}';
YCC009={'mo' 'YCC009' 0 []}';
YCC011={'mo' 'YCC011' 0 []}';
% ==============================================================================
% diagnostics, etc.
% ------------------------------------------------------------------------------
% halo/dark current collimator
PC0H00={'dr' 'PC0H00' LJAW []}';
% collimators
% (betatron X/Y half-gaps are 24/16 sigma for 1 um normalized emittance)
CEHTR={'dr' 'CEHTR' LJAW []}';%X momentum collimator
CYC01={'dr' 'CYC01' LJAW []}';%Y betatron collimator
CXC01={'dr' 'CXC01' LJAW []}';%X betatron collimator
CYC02={'dr' 'CYC02' LJAW []}';%Y betatron collimator
CXC02={'dr' 'CXC02' LJAW []}';%X betatron collimator
CYC03={'dr' 'CYC03' LJAW []}';%Y betatron collimator
CXC03={'dr' 'CXC03' LJAW []}';%X betatron collimator
% instruments
CATHODEB={'mo' 'CATHODEB' 0 []}';
VV01B={'mo' 'VV01B' 0 []}';
IM01B={'mo' 'IM01B' 0 []}';
YAG01B={'mo' 'YAG01B' 0 []}';
VV02B={'mo' 'VV02B' 0 []}';
WS0H04={'mo' 'WS0H04' 0 []}';
OTR0H04={'mo' 'OTR0H04' 0 []}';
BZ0H04={'mo' 'BZ0H04' 0 []}';
YAGH1={'mo' 'YAGH1' 0 []}';
YAGH2={'mo' 'YAGH2' 0 []}';
IMBCSI1={'mo' 'IMBCSI1' 0 []}';
IMBCSI2={'mo' 'IMBCSI2' 0 []}';
OTRC006={'mo' 'OTRC006' 0 []}';
WSC006={'mo' 'WSC006' 0 []}';
FC00EIC={'mo' 'FC00EIC' 0 []}';
% marker points
AM00B={'mo' 'AM00B' 0 []}';%gun laser injection mirror (MIR01)
BLFU={'mo' 'BLFU' 0 []}';%beamline flange
DP0H01={'mo' 'DP0H01' 0 []}';
DP0H02={'mo' 'DP0H02' 0 []}';
DP0H03={'mo' 'DP0H03' 0 []}';
LHBEGB={'mo' 'LHBEGB' 0 []}';
MIRLHU={'mo' 'MIRLHU' 0 []}';
HTRUNDB={'mo' 'HTRUNDB' 0 []}';
MIRLHD={'mo' 'MIRLHD' 0 []}';
CNTHTR={'mo' 'CNTHTR' 0 []}';
LHENDB={'mo' 'LHENDB' 0 []}';
BEGEIC={'mo' 'BEGEIC' 0 []}';
ECUEIC={'mo' 'ECUEIC' 0 []}';%u/s flange face
ENDEIC={'mo' 'ENDEIC' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
BUN1B_FULL=[BUN1B,BUN1B];
BCXH1_FULL=[BCXH1A,BCXH1B];
BCXH2_FULL=[BCXH2A,BCXH2B];
BCXH3_FULL=[BCXH3A,BCXH3B];
BCXH4_FULL=[BCXH4A,BCXH4B];
Q0H01_FULL=[Q0H01,BPM0H01,Q0H01];
Q0H02_FULL=[Q0H02,Q0H02];
Q0H03_FULL=[Q0H03,Q0H03];
Q0H04_FULL=[Q0H04,BPM0H04,Q0H04];
Q0H05_FULL=[Q0H05,BPM0H05,Q0H05];
Q0H06_FULL=[Q0H06,Q0H06];
Q0H07_FULL=[Q0H07,Q0H07];
Q0H08_FULL=[Q0H08,BPM0H08,Q0H08];
QHD01_FULL=[QHD01,BPMHD01,QHD01];
QHD02_FULL=[QHD02,BPMHD02,QHD02];
QHD03_FULL=[QHD03,BPMHD03,QHD03];
QHD04_FULL=[QHD04,BPMHD04,QHD04];
QC001_FULL=[QC001,BPMC001,QC001];
QC002_FULL=[QC002,BPMC002,QC002];
QC003_FULL=[QC003,BPMC003,QC003];
QC004_FULL=[QC004,BPMC004,QC004];
QC005_FULL=[QC005,BPMC005,QC005];
QC006_FULL=[QC006,BPMC006,QC006];
QC007_FULL=[QC007,BPMC007,QC007];
QC008_FULL=[QC008,BPMC008,QC008];
QC009_FULL=[QC009,BPMC009,QC009];
QC010_FULL=[QC010,BPMC010,QC010];
QC011_FULL=[QC011,BPMC011,QC011];
QC012_FULL=[QC012,BPMC012,QC012];
SOL1B_FULL=[SOL1B,CQ01B,SQ01B,SOL1B];
SOL2B_FULL=[SOL2B,CQ02B,SQ02B,SOL2B];
UMHTR_FULL=[UMHTR,HTRUNDB,UMHTR];
SC1B=[XC01B,YC01B];
SC2B=[XC02B,YC02B];
SC3B=[XC03B,YC03B];
SC4B=[XC04B,YC04B];
SC5B=[XC05B,YC05B];
SCC000=[XCC000,YCC000];
GUN=[BEGGUNB,DGBCA,SOL1BKB,DGBCB,CATHODEB,DGUN,DG001,SOL1B_FULL,DG002,VV01B,DG003,SC1B,DG004,BPM1B,DG005,IM01B,DG006,SC2B,DG007,BUN1B_FULL,DG008,SC3B,DG009,AM00B,DG010,SC4B,DG011,YAG01B,DG012,SOL2B_FULL,DG013,VV02B,DG014,BPM2B,DG015,SC5B,DG016A,BLFU,DG016B,ENDGUNB];
EIC=[BEGEIC,DGBCA,SOL1BKB,DGBCB,CATHODEB,DGUN,DG001,SOL1B_FULL,DG002,VV01B,DG003,SC1B,DG004,BPM1B,DG005,IM01B,DG006,SC2B,DG007,BUN1B_FULL,DG008,SC3B,DG009,AM00B,DG010,SC4B,DG011,YAG01B,DG012,SOL2B_FULL,DG013,VV02B,DG014,BPM2B,DG015,SC5B,DG016A,BLFU,DG016B,ECUEIC,DGEIC,FC00EIC,ENDEIC];
% %simplified
% LSRHTR=[LHBEGB,BCXH1A,BCXH1B,DH01A,DH01B,DH01C,BCXH2A,BCXH2B,DH02A,CEHTR,DH02B,DH02C,UMHTR,UMHTR,DH02D,DH02E,BCXH3A,BCXH3B,DH03A,DH03B,DH03C,BCXH4A,BCXH4B,LHENDB];

%COMMENT complete
LSRHTR=[LHBEGB,BCXH1_FULL,DH01A,BPMH1,DH01B,MIRLHU,DH01C,BCXH2_FULL,DH02A,CEHTR,DH02B,YAGH1,DH02C,UMHTR_FULL,DH02D,YAGH2,DH02E,BCXH3_FULL,DH03A,MIRLHD,DH03B,BPMH2,DH03C,BCXH4_FULL,CNTHTR,LHENDB];
%ENDCOMMENT
% %simplified
% HTR=[BEGHTR,D0H00,Q0H01,Q0H01,D0H01,Q0H02,Q0H02,D0H02,Q0H03,Q0H03,D0H03,Q0H04,Q0H04,D0H04,Q0H05,Q0H05,D0H05,Q0H06,Q0H06,D0H06,Q0H07,Q0H07,D0H07,Q0H08,Q0H08,D0H08,LSRHTR,DHD00,QHD01,QHD01,DHD01,QHD02,QHD02,DHD02,QHD03,QHD03,DHD03,QHD04,QHD04,DHD04,ENDHTR];

%COMMENT complete
HTR=[BEGHTR,RFB0H00,D0H00A,PC0H00,D0H00B,Q0H01_FULL,D0H01A,YC0H01,D0H01B,Q0H02_FULL,D0H02A,XC0H01,D0H02B,DP0H01,D0H02C,DP0H02,D0H02D,DP0H03,D0H02E,XC0H03,D0H02F,Q0H03_FULL,D0H03A,YC0H03,D0H03B,Q0H04_FULL,D0H04A,RFB0H04,D0H04B,OTR0H04,D0H04C,WS0H04,D0H04D,BZ0H04,D0H04E,Q0H05_FULL,D0H05A,YC0H05,D0H05B,Q0H06_FULL,D0H06A,XC0H05,D0H06B,XC0H07,D0H06C,Q0H07_FULL,D0H07A,YC0H07,D0H07B,Q0H08_FULL,D0H08A,RFB0H08,D0H08B,LSRHTR,DHD00A,RFBHD00,DHD00B,QHD01_FULL,DHD01A,YCHD01,DHD01B,XCHD01,DHD01C,QHD02_FULL,DHD02A1,IMBCSI1,DHD02A2,IMBCSI2,DHD02A3,YCHD03,DHD02B,QHD03_FULL,DHD03A,XCHD03,DHD03B,QHD04_FULL,DHD04A,RFBHD04,DHD04B,ENDHTR];
%ENDCOMMENT
% %simplified
% COL0=[BEGCOL0,DC000,QC001,QC001,DC001,QC002,QC002,DC002,QC003,QC003,DC003,QC004,QC004,DC004,QC005,QC005,DCOLL0,QC006,QC006,DCOLL0,QC007,QC007,DCOLL0,QC008,QC008,DCOLL0,QC009,QC009,DCOLL0,QC010,QC010,DCOLL0,QC011,QC011,DC011,QC012,QC012,ENDCOL0];

%COMMENT complete
COL0=[BEGCOL0,DBKRDG0A,DBKRDG0B,DC000AA,BPMDG000,DC000AB,DBLRDG0A,DBLRDG0B,DC000B,SCC000,DC000C,QC001_FULL,DC001,QC002_FULL,DC002,QC003_FULL,DC003A,YCC003,DC003B,QC004_FULL,DC004A,XCC004,DC004B,CYC01,DC004C,QC005_FULL,DCOLL0A,YCC005,DCOLL0B,CXC01,DCOLL0C,QC006_FULL,DCOLL0A,XCC006,DCOLL0B1,OTRC006,DCOLL0B2,WSC006,DCOLL0B3,RFBC006,DCOLL0B4,CYC02,DCOLL0C,QC007_FULL,DCOLL0A,YCC007,DCOLL0B5,CXC02,DCOLL0C,QC008_FULL,DCOLL0A,XCC008,DCOLL0B,CYC03,DCOLL0C,QC009_FULL,DCOLL0A,YCC009,DCOLL0B,CXC03,DCOLL0C,QC010_FULL,DC010A,XCC010,DC010B,RFBC011,DC010C,QC011_FULL,DC011A,YCC011,DC011B,XCC012,DC011C,QC012_FULL,ENDCOL0];
%ENDCOMMENT
C0FODO=[QFCOLL0,DCOLL0,QDCOLL0,QDCOLL0,DCOLL0,QFCOLL0];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc bunch compressor chicane #1
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 23-MAY-2019, M. Woodley
%  * move ENDBC1B to u/s face of QC101 per T. Maxwell
% 12-APR-2019, M. Woodley
%  * rename some MARKERs (to avoid conflicts with LCLS)
% ------------------------------------------------------------------------------
% 05-SEP-2017, M. Woodley
%  * rename: BPM11->BPM11B, CEBC1->CE11B, WS11->WS11B
%  * move BZ11B 0.12 m downstream per K. Fox
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * use measured FINT=0.3893 for BC1 bends
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * remove deferred items: kicker "BKYC1", septum "BLXC1", and TCAV "TCYC1"
%  * undefer XCC106, YCC109, and XCC110 (add-back list items)
%  * relocate COL1 correctors per K. Fox
% ------------------------------------------------------------------------------
% 07-JUN-2016, M. Woodley
%  * implement Kay Fox component moves (email 5/19)
%  * change deferment level to 0 for XCC106, YCC109, and XCC110
%  * move XCC112 to d/s side of QC112 ... shorten L2 u/s PSC drift
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * undefer IM11B
%  * change TYPE of OTRs and YAGs per Henrik's PRD
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * arrangement of devices at center of BC1 chicane copied from BC2
%  * undefer BPM11, OTR11B, BZ11B, and IM11B (change to ICT)
%  * undefer collimators CYC11, CXC11, CYC13, and CXC13
%  * collimator gaps per P. Emma
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * rematch after changes in COL0
%  * set collimator lengths (tungsten) and gaps per LCLSII-2.4-PR-0095-R0
%  * set WS11 deferment to level 3; set OTR11B deferment to level 0
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * increase space between Q1C01 and BCX11, and between BCX14 and QC101, per
%    N. Stewart; adjust inter-quad spacing between chicane and COL1 to keep
%    everything d/s of QC104 where it was
%  * change RFB11 (defer=2) to BPM11 (defer=0)
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * move COL1 collimators 7 inches closer to their associated quadrupoles
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * increase central drift of BC1 chicane from 0.8302 m to 1.75 m; add OTR11B
%  * shorten COL1 FODO cell to 8.0 m
%  * add 2 matching quadrupoles (each with a stripline BPM) to COL1
%  * add 6 stripline BPMs to COL1 ... omitted when we switched to 45 degree
%    FODO cells
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * OTR in BC1 chicane replaced with wire scanner; BPM replaced with RF BPM
%  * COL1 collimation system now consists of four 45 degree FODO cells with 3
%    pairs of collimators separated by 45 degrees (22 m betas at collimators);
%    FODO cell length is 12 m
%  * TCAV(Y), vertical kicker, and lambertson septum added d/s of BC1
%  * in-line emittance measurement system incorporated into COL1
%  * decorate device TYPE attributes to indicate non-baseline status
% 17-APR-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * replace chromatic BC1/DIAG1/COL1 match with BC1/COL1 non-chromatic match
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% 14-JAN-2014, M. Woodley
%  * change BC1 dipole names from "BX1*" to "BXC1*"
% ------------------------------------------------------------------------------
% 16-OCT-2013, M. Woodley
%  * change BC1 dipole TYPE from "5D7.1" to "1.69D6.28T" ... no change in
%    physical parameters
% ------------------------------------------------------------------------------
% ==============================================================================
% SBEN
% ------------------------------------------------------------------------------
% BC1 chicane
% - approximate on-axis effective length per R. Carr (01-AUG-05 PE)
% - use series approximation for sinc(x)=sin(x)/x to allow BXh=0
% GB1   : 1.69D6.28T gap height (m)
% ZB1   : 1.69D6.28T "Z" length (m)
% FB1   : measured chicane bend FINT/FINTX
% BB1   : chicane bend field (kG) for R56= 0.055 m @ 250 MeV
% AB1   : chicane bend angle (rad)
% LB1   : chicane bend path length (m)
% AB1S  : "short" half chicane bend angle (rad)
% LB1S  : "short" half chicane bend path length (m)
% AB1L  : "long" half chicane bend angle (rad)
% LB1L  : "long" half chicane bend path length (m)
GB1 =  0.04328;
ZB1 =  0.2032;
FB1 =  0.3893;
AB1 =  -0.100774150058 ;%R56=0.05285
BB1 =  BRHO1*sin(AB1)/ZB1;
AB1_2 =  AB1*AB1;
AB1_4 =  AB1_2*AB1_2;
AB1_6 =  AB1_4*AB1_2;
SINCAB1 =  1-AB1_2/6+AB1_4/120-AB1_6/5040 ;%~sinc(AB1)=sin(AB1)/AB1
LB1 =  ZB1/SINCAB1;
AB1S =  asin(sin(AB1)/2);
AB1S_2 =  AB1S*AB1S;
AB1S_4 =  AB1S_2*AB1S_2;
AB1S_6 =  AB1S_4*AB1S_2;
SINCAB1S =  1-AB1S_2/6+AB1S_4/120-AB1S_6/5040 ;%~sinc(AB1S)=sin(AB1S)/AB1S
LB1S =  ZB1/(2*SINCAB1S);
AB1L =  AB1-AB1S;
LB1L =  LB1-LB1S;
BCX11A={'be' 'BCX11' LB1S [+AB1S GB1/2 0 0 FB1 0 0]}';
BCX11B={'be' 'BCX11' LB1L [+AB1L GB1/2 0 +AB1 0 FB1 0]}';
BCX12A={'be' 'BCX12' LB1L [-AB1L GB1/2 -AB1 0 FB1 0 0]}';
BCX12B={'be' 'BCX12' LB1S [-AB1S GB1/2 0 0 0 FB1 0]}';
BCX13A={'be' 'BCX13' LB1S [-AB1S GB1/2 0 0 FB1 0 0]}';
BCX13B={'be' 'BCX13' LB1L [-AB1L GB1/2 0 -AB1 0 FB1 0]}';
BCX14A={'be' 'BCX14' LB1L [+AB1L GB1/2 +AB1 0 FB1 0 0]}';
BCX14B={'be' 'BCX14' LB1S [+AB1S GB1/2 0 0 0 FB1 0]}';
%F := (ZB1/GB1)*(COS(AB1)/(SINCAB1*(1+SIN(AB1)*SIN(AB1))))
%VALUE, AB1,F
%VALUE, F*GB1*(AB1/LB1)*(1+SIN(AB1)*SIN(AB1))/COS(AB1)
% define unsplit SBENs for BMAD ... not used by MAD
BCX11={'be' 'BCX1' LB1 [+AB1 GB1/2 0 +AB1 FB1 FB1 0]}';
BCX12={'be' 'BCX1' LB1 [-AB1 GB1/2 -AB1 0 FB1 FB1 0]}';
BCX13={'be' 'BCX13' LB1 [-AB1 GB1/2 0 -AB1 FB1 FB1 0]}';
BCX14={'be' 'BCX14' LB1 [+AB1 GB1/2 +AB1 0 FB1 FB1 0]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
% L1 to BC1 chicane
KQ1C01 =  0.974221026306;
Q1C01={'qu' 'Q1C01' LQX/2 [KQ1C01 0]}';
% BC1 chicane
KCQ11 =  0;
KSQ13 =  0;
KCQ12 =  0;
CQ11B={'qu' 'CQ11B' LQC/2 [KCQ11 0]}';
SQ13B={'qu' 'SQ13B' LQSB/2 [KSQ13 pi/4]}';
CQ12B={'qu' 'CQ12B' LQC/2 [KCQ12 0]}';
% collimation FODO
KQCOLL1 =  1.787850470726  ;%45 degree FODO
% BminColl1 := 6.996145818354
% BmaxColl1 := 15.616293369747
QFCOLL1={'qu' 'QFCOLL1' LQX/2 [KQCOLL1 0]}';
QDCOLL1={'qu' 'QDCOLL1' LQX/2 [-KQCOLL1 0]}';
% COL1 collimation section
KQC101 =  -0.346554514277;
KQC102 =   2.068585209648;
KQC103 =   0.0;
KQC104 =  -0.905335782198;
KQC105 =  -1.722699148158;
KQC106 =   KQCOLL1;
KQC107 =  -KQCOLL1;
KQC108 =   KQCOLL1;
KQC109 =  -KQCOLL1;
KQC110 =   1.409424568767 ;% KQColl1
KQC111 =  -1.791720274198;
KQC112 =   1.289917325561;
QC101={'qu' 'QC101' LQX/2 [KQC101 0]}';
QC102={'qu' 'QC102' LQX/2 [KQC102 0]}';
QC103={'qu' 'QC103' LQX/2 [KQC103 0]}';
QC104={'qu' 'QC104' LQX/2 [KQC104 0]}';
QC105={'qu' 'QC105' LQX/2 [KQC105 0]}';
QC106={'qu' 'QC106' LQX/2 [KQC106 0]}';
QC107={'qu' 'QC107' LQX/2 [KQC107 0]}';
QC108={'qu' 'QC108' LQX/2 [KQC108 0]}';
QC109={'qu' 'QC109' LQX/2 [KQC109 0]}';
QC110={'qu' 'QC110' LQX/2 [KQC110 0]}';
QC111={'qu' 'QC111' LQX/2 [KQC111 0]}';
QC112={'qu' 'QC112' LQX/2 [KQC112 0]}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% L1 to BC1 chicane
D1C00={'dr' '' 0.144 []}';
D1C01={'dr' '' 0.478 []}';
D1C01A={'dr' '' 0.15 []}';
D1C01B={'dr' '' D1C01{3}-D1C01A{3} []}';
% BC1 chicane
ZDC1O =  2.6381-ZB1                   ;%BCX11 exit to BCX12 entrance
ZDC1OA =  0.298542                     ;%BCX11 exit to CQ11B center
ZDC1OB =  0.610858                     ;%CQ11B center to YCM12B center
ZDC1OC =  ZDC1O-(ZDC1OA+ZDC1OB)        ;%YCM12B center to BCX12 entrance
ZDC1OD =  0.340947                     ;%BCX13 exit to SQ13B center
ZDC1OE =  1.184953                     ;%SQ13B center to XCM12B center
ZDC1OF =  0.610458                     ;%XCM12B center to CQ12B center
ZDC1OG =  ZDC1O-(ZDC1OD+ZDC1OE+ZDC1OF) ;%CQ12B center to BCX14 entrance
DC1O={'dr' '' ZDC1O/cos(AB1) []}';
DC1OA={'dr' '' ZDC1OA/cos(AB1)-LQC/2 []}';
DC1OB={'dr' '' ZDC1OB/cos(AB1)-LQC/2 []}';
DC1OC={'dr' '' ZDC1OC/cos(AB1) []}';
DC1I={'dr' '' 1.75 []}';
DC1IH={'dr' '' DC1I{3}/2 []}';
DC1IA={'dr' '' 0.24867 []}';
DC1IB={'dr' '' 0.16446-LJAW/2 []}';
DC1IC={'dr' '' 0.1826-LJAW/2 []}';
DC1ID={'dr' '' 0.415 []}';
DC1IE={'dr' '' DC1I{3}-DC1IA{3}-DC1IB{3}-LJAW-DC1IC{3}-DC1ID{3} []}';
DC1OD={'dr' '' ZDC1OD/cos(AB1)-LQSB/2 []}';
DC1OE={'dr' '' ZDC1OE/cos(AB1)-LQSB/2 []}';
DC1OF={'dr' '' ZDC1OF/cos(AB1)-LQC/2 []}';
DC1OG={'dr' '' ZDC1OG/cos(AB1)-LQC/2 []}';
% collimation FODO
DCOLL1={'dr' '' 4.0-LQX []}';
% COL1 collimation section
DC100={'dr' '' 0.637 []}';
DC101={'dr' '' 7.95 []}';
DC102={'dr' '' 0.8 []}';
DC103={'dr' '' 2.75 []}';
DC104={'dr' '' 4.316831888391 []}';
DC100A={'dr' '' 0.3 []}';
DC100B={'dr' '' 0.1 []}';
DC100C={'dr' '' DC100{3}-DC100A{3}-DC100B{3} []}';
DC101A={'dr' '' 0.214288 []}';
DC101B={'dr' '' 0.169862 []}';
DC101C={'dr' '' 0.25 []}';
DC101D={'dr' '' DC101{3}-DC101A{3}-DC101B{3}-DC101C{3} []}';
DC104A={'dr' '' 0.38415 []}';
DC104C={'dr' '' 0.1 []}';
DC104E={'dr' '' 0.613 []}';
DC104D={'dr' '' DCOLL1{3}/2-LJAW-DC104E{3} []}';
DC104B={'dr' '' DC104{3}-DC104A{3}-DC104C{3}-DC104D{3}-LJAW-DC104E{3} []}';
DC105A={'dr' '' 0.38415 []}';
DC105C={'dr' '' 0.613 []}';
DC105B={'dr' '' DCOLL1{3}-LJAW-DC105A{3}-DC105C{3} []}';
DC106A={'dr' '' 0.38415 []}';
DC106C={'dr' '' 0.1 []}';
DC106B={'dr' '' DCOLL1{3}/2-DC106A{3}-DC106C{3} []}';
DC106E={'dr' '' 0.613 []}';
DC106D={'dr' '' DCOLL1{3}/2-LJAW-DC106E{3} []}';
DC107A={'dr' '' 0.38415 []}';
DC107C={'dr' '' 0.613 []}';
DC107B={'dr' '' DCOLL1{3}-LJAW-DC107A{3}-DC107C{3} []}';
DC108A={'dr' '' 0.38415 []}';
DC108C={'dr' '' 0.1 []}';
DC108B={'dr' '' DCOLL1{3}/2-DC108A{3}-DC108C{3} []}';
DC108E={'dr' '' 0.613 []}';
DC108D={'dr' '' DCOLL1{3}/2-LJAW-DC108E{3} []}';
DC109A={'dr' '' 0.38415 []}';
DC109C={'dr' '' 0.613 []}';
DC109B={'dr' '' DCOLL1{3}-LJAW-DC109A{3}-DC109C{3} []}';
DC110A={'dr' '' 0.38415 []}';
DC110C={'dr' '' 0.1 []}';
DC110B={'dr' '' DCOLL1{3}/2-DC110A{3}-DC110C{3} []}';
DC110D={'dr' '' DCOLL1{3}/2 []}';
DC111A={'dr' '' 0.38415 []}';
DC111B={'dr' '' DCOLL1{3}-DC111A{3} []}';
DC112A={'dr' '' 0.38415 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPM1C01={'mo' 'BPM1C01' 0 []}';
BPMC101={'mo' 'BPMC101' 0 []}';
BPMC102={'mo' 'BPMC102' 0 []}';
BPMC103={'mo' 'BPMC103' 0 []}';
BPMC104={'mo' 'BPMC104' 0 []}';
BPMC105={'mo' 'BPMC105' 0 []}';
BPMC106={'mo' 'BPMC106' 0 []}';
BPMC107={'mo' 'BPMC107' 0 []}';
BPMC108={'mo' 'BPMC108' 0 []}';
BPMC109={'mo' 'BPMC109' 0 []}';
BPMC110={'mo' 'BPMC110' 0 []}';
BPMC111={'mo' 'BPMC111' 0 []}';
BPMC112={'mo' 'BPMC112' 0 []}';
RFB1C01={'mo' 'RFB1C01' 0 []}';
BPM11B={'mo' 'BPM11B' 0 []}';%RFB11 : MONI, TYPE="@2,CavityL-1"
RFBC104={'mo' 'RFBC104' 0 []}';
RFBC106={'mo' 'RFBC106' 0 []}';
RFBC108={'mo' 'RFBC108' 0 []}';
RFBC110={'mo' 'RFBC110' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC1C00={'mo' 'XC1C00' 0 []}';
XCM12B={'mo' 'XCM12B' 0 []}';
XCC101={'mo' 'XCC101' 0 []}';
XCC104={'mo' 'XCC104' 0 []}';
XCC106={'mo' 'XCC106' 0 []}';
XCC108={'mo' 'XCC108' 0 []}';
XCC110={'mo' 'XCC110' 0 []}';
XCC112={'mo' 'XCC112' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC1C00={'mo' 'YC1C00' 0 []}';
YCM12B={'mo' 'YCM12B' 0 []}';
YCC101={'mo' 'YCC101' 0 []}';
YCC105={'mo' 'YCC105' 0 []}';
YCC107={'mo' 'YCC107' 0 []}';
YCC109={'mo' 'YCC109' 0 []}';
YCC111={'mo' 'YCC111' 0 []}';
% ==============================================================================
% marker points, etc.
% ------------------------------------------------------------------------------
% collimators
% (betatron X/Y half-gaps are 27/18 sigma for 1 um normalized emittance)
CE11B={'dr' 'CE11B' LJAW []}';%X momentum collimator
CYC11={'dr' 'CYC11' LJAW []}';%Y betatron collimator
CXC11={'dr' 'CXC11' LJAW []}';%X betatron collimator
CYC12={'dr' 'CYC12' LJAW []}';%Y betatron collimator
CXC12={'dr' 'CXC12' LJAW []}';%X betatron collimator
CYC13={'dr' 'CYC13' LJAW []}';%Y betatron collimator
CXC13={'dr' 'CXC13' LJAW []}';%X betatron collimator
% instruments
OTR11B={'mo' 'OTR11B' 0 []}';%BC1 energy spread
WS11B={'mo' 'WS11B' 0 []}';%BC1 energy spread
BZ11B={'mo' 'BZ11B' 0 []}';%CSR-based relative bunch length monitor
BZC1={'mo' 'BZC1' 0 []}';%relative bunch length monitor
IM11B={'mo' 'IM11B' 0 []}';%Beam Current Monitor
WSC104={'mo' 'WSC104' 0 []}';%post-BC1 emittance
WSC106={'mo' 'WSC106' 0 []}';%post-BC1 emittance
WSC108={'mo' 'WSC108' 0 []}';%post-BC1 emittance
WSC110={'mo' 'WSC110' 0 []}';%post-BC1 emittance
% markers
BC1BCBEG={'mo' 'BC1BCBEG' 0 []}';
BC1BCMID={'mo' 'BC1BCMID' 0 []}';
CNTBC1={'mo' 'CNTBC1' 0 []}';
BC1BCEND={'mo' 'BC1BCEND' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
BCX11_FULL=[BCX11A,BCX11B];
BCX12_FULL=[BCX12A,BCX12B];
BCX13_FULL=[BCX13A,BCX13B];
BCX14_FULL=[BCX14A,BCX14B];
Q1C01_FULL=[Q1C01,BPM1C01,Q1C01];
CQ11B_FULL=[CQ11B,CQ11B];
SQ13B_FULL=[SQ13B,SQ13B];
CQ12B_FULL=[CQ12B,CQ12B];
QC101_FULL=[QC101,BPMC101,QC101];
QC102_FULL=[QC102,BPMC102,QC102];
QC103_FULL=[QC103,BPMC103,QC103];
QC104_FULL=[QC104,BPMC104,QC104];
QC105_FULL=[QC105,BPMC105,QC105];
QC106_FULL=[QC106,BPMC106,QC106];
QC107_FULL=[QC107,BPMC107,QC107];
QC108_FULL=[QC108,BPMC108,QC108];
QC109_FULL=[QC109,BPMC109,QC109];
QC110_FULL=[QC110,BPMC110,QC110];
QC111_FULL=[QC111,BPMC111,QC111];
QC112_FULL=[QC112,BPMC112,QC112];
SC1C00=[XC1C00,YC1C00];
BC1I0=[D1C00,Q1C01,Q1C01,D1C01A,D1C01B];
BC1I=[SC1C00,D1C00,Q1C01_FULL,D1C01A,RFB1C01,D1C01B];
BC1C0=[BC1BCBEG,BCX11A,BCX11B,DC1O,BCX12A,BCX12B,DC1IH,BC1BCMID,DC1IH,BCX13A,BCX13B,DC1O,BCX14A,BCX14B,BC1BCEND];
BC1C=[BC1BCBEG,BCX11_FULL,DC1OA,CQ11B_FULL,DC1OB,YCM12B,DC1OC,BCX12_FULL,DC1IA,BPM11B,DC1IB,CE11B,DC1IC,OTR11B,DC1ID,WS11B,DC1IE,BCX13_FULL,DC1OD,SQ13B_FULL,DC1OE,XCM12B,DC1OF,CQ12B_FULL,DC1OG,BCX14_FULL,CNTBC1,BC1BCEND];
BC1=[BEGBC1B,BC1I,BC1C];
% %simplified
% COL1=[DC100,ENDBC1B,BEGCOL1,QC101,QC101,DC101,QC102,QC102,DC102,QC103,QC103,DC103,QC104,QC104,DC104,QC105,QC105,DCOLL1,QC106,QC106,DCOLL1,QC107,QC107,DCOLL1,QC108,QC108,DCOLL1,QC109,QC109,DCOLL1,QC110,QC110,DCOLL1,QC111,QC111,DCOLL1,QC112,QC112,DC112A,ENDCOL1];

%COMMENT complete
COL1=[DC100A,BZ11B,DC100B,BZC1,DC100C,ENDBC1B,BEGCOL1,QC101_FULL,DC101A,IM11B,DC101B,XCC101,DC101C,YCC101,DC101D,QC102_FULL,DC102,QC103_FULL,DC103,QC104_FULL,DC104A,XCC104,DC104B,RFBC104,DC104C,WSC104,DC104D,CYC11,DC104E,QC105_FULL,DC105A,YCC105,DC105B,CXC11,DC105C,QC106_FULL,DC106A,XCC106,DC106B,RFBC106,DC106C,WSC106,DC106D,CYC12,DC106E,QC107_FULL,DC107A,YCC107,DC107B,CXC12,DC107C,QC108_FULL,DC108A,XCC108,DC108B,RFBC108,DC108C,WSC108,DC108D,CYC13,DC108E,QC109_FULL,DC109A,YCC109,DC109B,CXC13,DC109C,QC110_FULL,DC110A,XCC110,DC110B,RFBC110,DC110C,WSC110,DC110D,QC111_FULL,DC111A,YCC111,DC111B,QC112_FULL,DC112A,XCC112,ENDCOL1];
%ENDCOMMENT
C1FODO=[QFCOLL1,DCOLL1,QDCOLL1,QDCOLL1,DCOLL1,QFCOLL1];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc bunch compressor chicane #2
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 23-MAY-2019, M. Woodley
%  * move ENDBC2B to u/s face of QE201 per T. Maxwell
% 12-APR-2019, M. Woodley
%  * rename some MARKERs (to avoid conflicts with LCLS)
% ------------------------------------------------------------------------------
% 05-SEP-2017, M. Woodley
%  * rename: BPM21->BPM21B, CEBC2->CE21B, WS21->WS21B
%  * move BZ21B 0.076976 m upstream per F. Carillo
%  * move QE201/BPME201 0.050338 m downstream per F. Carillo
% 16-AUG-2017, M. Woodley
%  * set FINT for BC2 bends to 0.6287 per Magnetic Measurements data
% ------------------------------------------------------------------------------
% 28-FEB-2017, M. Woodley
%  * relocate YC2C00, YCE201, XCE202, YCE203, and XCE204 per F. Carillo
% ------------------------------------------------------------------------------
% 28-NOV-2016, M. Woodley
%  * merge LCLS-II' version 28NOV16 with LCLS2sc version 04NOV16
% ------------------------------------------------------------------------------
% 26-AUG-2016, M. Woodley
%  * add two 1.259Q3.5 quadrupoles to EMIT2
%  * create double-waist in EMIT2 for emittance measurement
% 01-JUL-2016, M. Woodley
%  * LCLS-II-HE
%  * remove COL2 and replace with direct match into L3
% ------------------------------------------------------------------------------
% 03-JUN-2016, M. Woodley
%  * change deferment level to 0 for XCC204, YCC207, and XCC208
%  * move XCC210 to d/s side of QC210 ... shorten L3 u/s PSC drift
% ------------------------------------------------------------------------------
% 23-FEB-2016, M. Woodley
%  * push extra drift from L2 d/s PSC into D2C00 (DPSC2d[L]+D2C00[L]=constant)
%  * per F. Carillo: move XC2C00 u/s 11 cm, BZ21B d/s 18 cm, XCC210 u/s 14 cm
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * fix negative D2C00a drift length error by shortening DPSC2D drift; set
%    D2C00a length to zero
%  * undefer CEBC2
%  * change TYPE of OTRs and YAGs per Henrik's PRD
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * device locations per F. Carrillo
%  * undefer BPM21 and OTR21B
%  * defer collimators CYC21, CXC21, CYC23, and CXC23
%  * undefer WSC202, WSC204, WSC206, and WSC208
%  * collimator gaps per P. Emma
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * device locations per F. Carillo
%  * set WS21 deferment to level 3; set OTR21B deferment to level 0
%  * set collimator lengths (tungsten) and gaps per LCLSII-2.4-PR-0095-R0
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * change RFB21 (defer=2) to BPM21 (defer=0)
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * move COL2 collimators 7 inches closer to their associated quadrupoles
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * increase central drift of BC1 chicane from 1.0926 m to 1.75 m; add OTR21B
%  * remove 0.6574 m (1.75 m - 1.0926 m) from COL2 to keep L1-L2 separation
%    constant
%  * add 6 stripline BPMs to COL2 ... omitted when we switched to 45 degree
%    FODO cells
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * change bending direction in BC2 chicane ... toward the aisle
%  * OTR in BC2 chicane replaced with wire scanner; BPM replaced with RF BPM
%  * COL2 collimation system now consists of four 45 degree FODO cells with 3
%    pairs of collimators separated by 45 degrees (22 m betas at collimators);
%    FODO cell length is 12 m
%  * TCAV(Y) added d/s of BC2
%  * in-line emittance measurement system incorporated into COL2
%  * decorate device TYPE attributes to indicate non-baseline status
% 17-APR-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
% ------------------------------------------------------------------------------
% 28-MAR-2014, M. Woodley
%  * remove elements associated with now-defunct DIAG2 diagnostic line
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% 14-JAN-2014, M. Woodley
%  * change BC2 dipole names from "BX2*" to "BXC2*"
% ------------------------------------------------------------------------------
% ==============================================================================
% SBEN
% ------------------------------------------------------------------------------
% BC2 chicane
% - approximate on-axis effective length per R. Carr (01-AUG-05 PE)
% - use series approximation for sinc(x)=sin(x)/x to allow BXh=0
% GB2   : 1D19.7 gap height (m)
% ZB2   : 1D19.7 "Z" length (m)
% FB2   : measured fringe field
% AB2   : chicane bend angle (rad)
% BB2   : chicane bend field (kG)
% LB2   : chicane bend path length (m)
% AB2S  : "short" half chicane bend angle (rad)
% LB2S  : "short" half chicane bend path length (m)
% AB2L  : "long" half chicane bend angle (rad)
% LB2L  : "long" half chicane bend path length (m)
GB2 =  0.03335;
ZB2 =  0.549;
FB2 =  0.6287;
AB2 =  0.043924602172 ;%R56=0.03955
BB2 =  BRHO2*sin(AB2)/ZB2;
AB2_2 =  AB2*AB2;
AB2_4 =  AB2_2*AB2_2;
AB2_6 =  AB2_4*AB2_2;
SINCAB2 =  1-AB2_2/6+AB2_4/120-AB2_6/5040 ;%~sinc(AB2)=sin(AB2)/AB2
LB2 =  ZB2/SINCAB2;
AB2S =  asin(sin(AB2)/2);
AB2S_2 =  AB2S*AB2S;
AB2S_4 =  AB2S_2*AB2S_2;
AB2S_6 =  AB2S_4*AB2S_2;
SINCAB2S =  1-AB2S_2/6+AB2S_4/120-AB2S_6/5040 ;%~sinc(AB2S)=sin(AB2S)/AB2S
LB2S =  ZB2/(2*SINCAB2S);
AB2L =  AB2-AB2S;
LB2L =  LB2-LB2S;
BCX21A={'be' 'BCX21' LB2S [+AB2S GB2/2 0 0 FB2 0 0]}';
BCX21B={'be' 'BCX21' LB2L [+AB2L GB2/2 0 +AB2 0 FB2 0]}';
BCX22A={'be' 'BCX22' LB2L [-AB2L GB2/2 -AB2 0 FB2 0 0]}';
BCX22B={'be' 'BCX22' LB2S [-AB2S GB2/2 0 0 0 FB2 0]}';
BCX23A={'be' 'BCX23' LB2S [-AB2S GB2/2 0 0 FB2 0 0]}';
BCX23B={'be' 'BCX23' LB2L [-AB2L GB2/2 0 -AB2 0 FB2 0]}';
BCX24A={'be' 'BCX24' LB2L [+AB2L GB2/2 +AB2 0 FB2 0 0]}';
BCX24B={'be' 'BCX24' LB2S [+AB2S GB2/2 0 0 0 FB2 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX21={'be' 'BCX2' LB2 [+AB2 GB2/2 0 +AB2 FB2 FB2 0]}';
BCX22={'be' 'BCX2' LB2 [-AB2 GB2/2 -AB2 0 FB2 FB2 0]}';
BCX23={'be' 'BCX23' LB2 [-AB2 GB2/2 0 -AB2 FB2 FB2 0]}';
BCX24={'be' 'BCX24' LB2 [+AB2 GB2/2 +AB2 0 FB2 FB2 0]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
% L2 to BC2 chicane
KQ2C01 =  0.509106837541;
Q2C01={'qu' 'Q2C01' LQX/2 [KQ2C01 0]}';
% BC2 chicane
KCQ21 =  0;
KCQ22 =  0;
CQ21B={'qu' 'CQ21B' LQC/2 [KCQ21 0]}';
CQ22B={'qu' 'CQ22B' LQC/2 [KCQ22 0]}';
% match into L3
KQE201 =  -1.311184352516;
KQE202 =   1.991949996425;
KQE203 =  -1.816251165832;
KQE204 =   1.650789479332;
QE201={'qu' 'QE201' LQX/2 [KQE201 0]}';
QE202={'qu' 'QE202' LQX/2 [KQE202 0]}';
QE203={'qu' 'QE203' LQX/2 [KQE203 0]}';
QE204={'qu' 'QE204' LQX/2 [KQE204 0]}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% L2 to BC2 chicane
D2C00={'dr' '' 1.150310011609 []}';
D2C01={'dr' '' 0.5 []}';
D2C00B={'dr' '' 0.338951 []}';
D2C00C={'dr' '' 0.321049 []}';
D2C00A={'dr' '' D2C00{3}-D2C00B{3}-D2C00C{3} []}';
D2C01A={'dr' '' 0.133 []}';
D2C01B={'dr' '' D2C01{3}-D2C01A{3} []}';
% BC2 chicane
ZDC2O =  10.4092-ZB2 ;%BXC21 exit to BCX22 entrance
ZDC2I =  2.299-ZB2   ;%BXC22 exit to BCX23 entrance
DC2O={'dr' '' ZDC2O/cos(AB2) []}';
DC2I={'dr' '' ZDC2I []}';
ZDC2OA =  2.009462     ;%BXC21 exit to CQ21B center
ZDC2OB =  ZDC2O-ZDC2OA ;%CQ21B center to BCX22 entrance
ZDC2OD =  2.009462     ;%CQ22B center to BXC24 entrance
ZDC2OC =  ZDC2O-ZDC2OD ;%BXC23 exit to CQ22B center
DC2OA={'dr' '' ZDC2OA/cos(AB2)-LQC/2 []}';
DC2OB={'dr' '' ZDC2OB/cos(AB2)-LQC/2 []}';
DC2IH={'dr' '' DC2I{3}/2 []}';
DC2IA={'dr' '' 0.3795 []}';%0.35
DC2IB={'dr' '' 0.165-LJAW/2 []}';%0.35
DC2IC={'dr' '' 0.183-LJAW/2 []}';%0.35
DC2ID={'dr' '' 0.598 []}';%0.35
DC2IE={'dr' '' 0.4245 []}';%0.35
DC2OC={'dr' '' ZDC2OC/cos(AB2)-LQC/2 []}';
DC2OD={'dr' '' ZDC2OD/cos(AB2)-LQC/2 []}';
% match into L3
LEMIT2 =  28.859648;
DE200={'dr' '' 1.050338 []}';
DE201={'dr' '' 4.906343360384 []}';
DE202A={'dr' '' 10.974020455558 []}';
DE203={'dr' '' 3.0 []}';
DE204={'dr' '' 0.670516558157 []}';
DE202B={'dr' '' LEMIT2-4*LQX-DE200{3}-DE201{3}-DE202A{3}-DE203{3}-DE204{3} []}';
DE202={'dr' '' DE202A{3}+DE202B{3} []}';
DE200A={'dr' '' 0.687372 []}';
DE200B={'dr' '' DE200{3}-DE200A{3} []}';
DE201A={'dr' '' 0.321044 []}';
DE201B={'dr' '' 0.328618 []}';
DE201C={'dr' '' DE201{3}-DE201A{3}-DE201B{3} []}';
DE202A1={'dr' '' 0.321864 []}';
DE202A2={'dr' '' DE202A{3}-DE202A1{3} []}';
DE203A={'dr' '' 0.321044 []}';
DE203B={'dr' '' DE203{3}-DE203A{3} []}';
DE204A={'dr' '' 0.321864 []}';
DE204B={'dr' '' DE204{3}-DE204A{3} []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPM2C01={'mo' 'BPM2C01' 0 []}';
BPME201={'mo' 'BPME201' 0 []}';
BPME202={'mo' 'BPME202' 0 []}';
BPME203={'mo' 'BPME203' 0 []}';
BPME204={'mo' 'BPME204' 0 []}';
RFB2C01={'mo' 'RFB2C01' 0 []}';
BPM21B={'mo' 'BPM21B' 0 []}';%RFB21 : MONI, TYPE="@2,CavityL-1"
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC2C00={'mo' 'XC2C00' 0 []}';
XCE202={'mo' 'XCE202' 0 []}';
XCE204={'mo' 'XCE204' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC2C00={'mo' 'YC2C00' 0 []}';
YCE201={'mo' 'YCE201' 0 []}';
YCE203={'mo' 'YCE203' 0 []}';
% ==============================================================================
% marker points, etc.
% ------------------------------------------------------------------------------
% collimator
CE21B={'dr' 'CE21B' LJAW []}';%X momentum collimator
% instruments
OTR21B={'mo' 'OTR21B' 0 []}';%BC2 energy spread
WS21B={'mo' 'WS21B' 0 []}';%BC2 energy spread
BZ21B={'mo' 'BZ21B' 0 []}';%CSR-based relative bunch length monitor
IM21B={'mo' 'IM21B' 0 []}';%Beam Current Monitor
WSEMIT2={'mo' 'WSEMIT2' 0 []}';%post-BC2 emittance
% markers
BC2BCBEG={'mo' 'BC2BCBEG' 0 []}';
BC2BCMID={'mo' 'BC2BCMID' 0 []}';
CNTBC2={'mo' 'CNTBC2' 0 []}';
BC2BCEND={'mo' 'BC2BCEND' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
BCX21_FULL=[BCX21A,BCX21B];
BCX22_FULL=[BCX22A,BCX22B];
BCX23_FULL=[BCX23A,BCX23B];
BCX24_FULL=[BCX24A,BCX24B];
Q2C01_FULL=[Q2C01,BPM2C01,Q2C01];
CQ21B_FULL=[CQ21B,CQ21B];
CQ22B_FULL=[CQ22B,CQ22B];
QE201_FULL=[QE201,BPME201,QE201];
QE202_FULL=[QE202,BPME202,QE202];
QE203_FULL=[QE203,BPME203,QE203];
QE204_FULL=[QE204,BPME204,QE204];
BC2I0=[D2C00,Q2C01,Q2C01,D2C01];
BC2I=[D2C00A,XC2C00,D2C00B,YC2C00,D2C00C,Q2C01_FULL,D2C01A,RFB2C01,D2C01B];
BC2C0=[BC2BCBEG,BCX21A,BCX21B,DC2O,BCX22A,BCX22B,DC2IH,BC2BCMID,DC2IH,BCX23A,BCX23B,DC2O,BCX24A,BCX24B,BC2BCEND];
BC2C=[BC2BCBEG,BCX21_FULL,DC2OA,CQ21B_FULL,DC2OB,BCX22_FULL,DC2IA,BPM21B,DC2IB,CE21B,DC2IC,OTR21B,DC2ID,WS21B,DC2IE,BCX23_FULL,DC2OC,CQ22B_FULL,DC2OD,BCX24_FULL,CNTBC2,BC2BCEND];
BC2=[BEGBC2B,BC2I,BC2C];
EMIT2=[DE200A,BZ21B,DE200B,ENDBC2B,BEGEMIT2,QE201_FULL,DE201A,YCE201,DE201B,IM21B,DE201C,QE202_FULL,DE202A1,XCE202,DE202A2,WSEMIT2,DE202B,QE203_FULL,DE203A,YCE203,DE203B,QE204_FULL,DE204A,XCE204,DE204B,ENDEMIT2];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc linac extension: end of L3 to start of bypass dogleg
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * move EXT/DOG boundary so that CCDLU is in DOG (per K. Fant)
%  * remove IPEXTDOG (per K. Fant)
% ------------------------------------------------------------------------------
% 28-NOV-2016, M. Woodley
%  * merge LCLS-II' version 28NOV16 with LCLS2sc version 04NOV16
% ------------------------------------------------------------------------------
% 26-AUG-2016, M. Woodley
%  * remove EXT FODO lattice and replace with direct match from L3 into dogleg
% ------------------------------------------------------------------------------
% 26-MAY-2016, M. Woodley
%  * set TYPE="0.788D11.50" for R56-compensation chicane bends
% 20-APR-2016, M. Woodley
%  * add IPEXTDOG ion pump (defines EXT-DOG boundary)
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * add BPMX09 (@0); to be replaced later by RFBX09 (@2)
%  * undefer R56-compensation chicane
%  * scale bend angles of R56-compensation chicane up by 15%
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * corrector locations per F. Carrillo
%  * stripline BPM types per M. Carrasco
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * lengthen EXT FODO cells by 12 m (57 m to 69 m)
%  * rematch EXT (layout and optics)
%  * add resistive-wall wakefield MARKer (for ELEGANT) per P. Emma
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * switch to 45 degree FODO cells
%  * add R56 compensation chicane (steal 2.5 m from space reserved for CM
%    transport)
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * EXT FODO cell length increased from 38 m to 57 m ... phase advance per
%    cell reduced to 60 degrees
%  * use QW quadrupoles for FODO lattice ... last two EXT quadrupoles are QEs
%  * decorate device TYPE attributes to indicate non-baseline status
% ------------------------------------------------------------------------------
% 28-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
KQX01 =   0.953828315174;
KQX02 =  -1.076664690711;
QX01={'qu' 'QX01' LQE/2 [KQX01 0]}';
QX02={'qu' 'QX02' LQE/2 [KQX02 0]}';
% %GL < 106 kG for QEs
% 
% 

% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
LLDX =  21.0-2*LQE ;%21 m particle-free before CCDLU
DX00={'dr' '' 5.8 []}';
DX02={'dr' '' 5.8 []}';
DX01={'dr' '' LLDX-DX00{3}-DX02{3} []}';
DX01A={'dr' '' 0.4-LQE/2 []}';
DX01C={'dr' '' 0.2 []}';
DX01B={'dr' '' DX01{3}-DX01A{3}-DX01C{3} []}';
DX02A={'dr' '' 0.31-LQE/2 []}';
DX02B={'dr' '' DX02{3}-DX02A{3} []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMX01={'mo' 'BPMX01' 0 []}';
BPMX02={'mo' 'BPMX02' 0 []}';
RFBX02={'mo' 'RFBX02' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCX01={'mo' 'XCX01' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCX02={'mo' 'YCX02' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
QX01_FULL=[QX01,BPMX01,QX01];
QX02_FULL=[QX02,BPMX02,QX02];
EXT0=[BEGEXT,DX00,QX01,QX01,DX01,QX02,QX02,DX02,ENDEXT];
EXT=[BEGEXT,DX00,QX01_FULL,DX01A,XCX01,DX01B,RFBX02,DX01C,QX02_FULL,DX02A,YCX02,DX02B,ENDEXT];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc sector 7 dogleg plus match to bypass line
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-APR-2019, M. Woodley
%  * use measured FINT=0.4875 for 1.0D38.37 @ 262A
% ------------------------------------------------------------------------------
% 07-JAN-2019, M. Woodley
%  * add sector 10 shielding wall
% ------------------------------------------------------------------------------
% 11-OCT-2018, M. Woodley
%  * use average measured FINT for 0.788D11.50's
% ------------------------------------------------------------------------------
% 20-DEC-2017, M. Woodley
%  * remove BCS ACM IMBCSDOG per C. Clarke
% 02-NOV-2017, M. Woodley
%  * add sector boundary MARKERs
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * move EXT/DOG boundary so that CCDLU is in DOG (per K. Fant)
%  * remove IPEXTDOG (per K. Fant)
% ------------------------------------------------------------------------------
% 16-FEB-2016, M. Woodley
%  * move Dogleg/Bypass boundary to Z= 1202.631303 m per G. DeContreras
%  * move RFBWSBP4 and WSBP4 from 1 FODO cell downstream of WSBP3 to 1 FODO
%    cell upstream of WSBP1 ... rename
%  * adjust locations of QL1P-QL4P for more robust matching
% ------------------------------------------------------------------------------
% 28-NOV-2016, M. Woodley
%  * merge LCLS-II' version 28NOV16 with LCLS2sc version 04NOV16
%  * include extended NIT line
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * undefer IMBCSDOG (add-back list item)
% ------------------------------------------------------------------------------
% 06-JUN-2016, M. Woodley
%  * set TYPE="0.788D11.50" for R56-compensation chicane bends
%  * reposition SDOG1, SDOG2, and WSDOG according to M. Gaynor & N. Stewart
%  * set IMBCSDOG TYPE="BCS cavity"
% ------------------------------------------------------------------------------
% 28-FEB-2016, Y. Nosochkov
%  * place RFBWSBP1, WSBP1 u/s of QBP13 two sectors u/s of RFBWSBP2, WSBP2 (Tor)
% 08-FEB-2016, M. Woodley
%  * add sextupoles to correct 2nd-order dispersion per P. Emma
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * undefer OTRDOG
%  * change keyword of WSDOG to WIRE
%  * undefer R56-compensation chicane
%  * scale bend angles of R56-compensation chicane up by 15%
% ------------------------------------------------------------------------------
% 03-AUG-2015, M. Woodley
%  * change TYPE of OTRs and YAGs per Henrik's PRD
% ------------------------------------------------------------------------------
% 19-JUN-2015, M. Woodley
%  * set CEDOG collimator length to 6 cm
%  * undefer BPMDOG2 and BPMDOG6
%  * add OTRDOG; move WSDOG; move YCDOG6
%  * collimator gaps per P. Emma
% ------------------------------------------------------------------------------
% 20-MAR-2014, M. Woodley
%  * dogleg BPMs TYPE="Stripline-5"
%  * new dogleg and bypass match BPM and corrector locations per T. O'Heron
%  * replace QL1P (1.97Q20) and QL2P (1.97Q10) with 2Q10s
%  * add BCS ACM downstream of BRB2
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * replace dogleg quadrupoles (1.625Q27.3) with 2Q10 quadrupoles
%  * move dogleg collimator and wire scanner (and associated RFBs) to high
%    vertical dispersion points
%  * change RFBs (defer=2) to BPMs (defer=0)
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * move stripline BPMs from quadrupole centers to ~0.543 m u/s of quadrupole
%    center per D. Hanquist and J. Amann
%  * add resistive-wall wakefield MARKer (for ELEGANT) per P. Emma
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * add R56 compensation chicane
%  * adjust deferment/deprecation levels
% ------------------------------------------------------------------------------
% 07-AUG-2014, M. Woodley
%  * diagnostics complement per "Electron Beam Diagnostics Systems" PRD
%    (LCLSII-2.7-PR-0170)
%  * replace some dogleg stripline BPMs with cavity BPMs
%  * remove BC3
%  * decorate device TYPE attributes to indicate non-baseline status
% 17-APR-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
% ------------------------------------------------------------------------------
% 26-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% ------------------------------------------------------------------------------
% 01-MAR-2014, M. Woodley
%  * change BC3 dipole type from 1.0D38.37 to 1D19.7 (BC2 dipole)
% 14-JAN-2014, M. Woodley
%  * add BC3
% ------------------------------------------------------------------------------
DZDOG =  77.99997504 ;%Z-extent of dogleg (BRB1 entrance to BRB2 exit)
% ==============================================================================
% SBEN
% ------------------------------------------------------------------------------
% upstream R56 compensation chicane:
%   ABCX..  = chicane bend angle (rad)
%   BBCX..  = chicane bend field (kG)
%   LBCX..  = chicane bend path length (m)
%   ABCX..S = "short" half chicane bend angle (rad)
%   ABCX..L = "long" half chicane bend angle (rad)
%   LBCX..S = "short" half chicane bend path length (m)
%   LBCX..L = "long" half chicane bend path length (m)
ABCXDLU0 =  0.010734075009 ;%R56=9.99E-5
ABCXDLU =  1.15*ABCXDLU0  ;%R56=1.32E-4
BBCXDLU =  BRHOF*sin(ABCXDLU)/ZBCC;
ABCXDLU_2 =  ABCXDLU*ABCXDLU;
ABCXDLU_4 =  ABCXDLU_2*ABCXDLU_2;
ABCXDLU_6 =  ABCXDLU_4*ABCXDLU_2;
SINCBCXDLU =  1-ABCXDLU_2/6+ABCXDLU_4/120-ABCXDLU_6/5040;
LBCXDLU =  ZBCC/SINCBCXDLU;
ABCXDLUS =  asin(sin(ABCXDLU)/2);
ABCXDLUS_2 =  ABCXDLUS*ABCXDLUS;
ABCXDLUS_4 =  ABCXDLUS_2*ABCXDLUS_2;
ABCXDLUS_6 =  ABCXDLUS_4*ABCXDLUS_2;
SINCBCXDLUS =  1-ABCXDLUS_2/6+ABCXDLUS_4/120-ABCXDLUS_6/5040;
LBCXDLUS =  ZBCC/(2*SINCBCXDLUS);
ABCXDLUL =  ABCXDLU-ABCXDLUS;
LBCXDLUL =  LBCXDLU-LBCXDLUS;
BCXDLU1A={'be' 'BCXDLU1' LBCXDLUS [+ABCXDLUS GBCC/2 0 0 FBCC 0 0]}';
BCXDLU1B={'be' 'BCXDLU1' LBCXDLUL [+ABCXDLUL GBCC/2 0 +ABCXDLU 0 FBCC 0]}';
BCXDLU2A={'be' 'BCXDLU2' LBCXDLUL [-ABCXDLUL GBCC/2 -ABCXDLU 0 FBCC 0 0]}';
BCXDLU2B={'be' 'BCXDLU2' LBCXDLUS [-ABCXDLUS GBCC/2 0 0 0 FBCC 0]}';
BCXDLU3A={'be' 'BCXDLU3' LBCXDLUS [-ABCXDLUS GBCC/2 0 0 FBCC 0 0]}';
BCXDLU3B={'be' 'BCXDLU3' LBCXDLUL [-ABCXDLUL GBCC/2 0 -ABCXDLU 0 FBCC 0]}';
BCXDLU4A={'be' 'BCXDLU4' LBCXDLUL [+ABCXDLUL GBCC/2 +ABCXDLU 0 FBCC 0 0]}';
BCXDLU4B={'be' 'BCXDLU4' LBCXDLUS [+ABCXDLUS GBCC/2 0 0 0 FBCC 0]}';
% dogleg
% XOFF  : x-offset of bypass line (old PEP-II 9-GeV) w.r.t. old linac axis
%         (<0 is south)
% YOFF  : y-offset of bypass line (old PEP-II 9-GeV) w.r.t. old linac axis
%         (>0 is up)
% ROLLA : roll angle of sec-10 bends to get XOFF and YOFF bypass offsets
GBR =  0.0254          ;%1.0D38.37 gap height (m)
LBR =  1.0             ;%1.0D38.37 gap height (m)
FBR =  0.4875          ;%1.0D38.37 FINT @ 262 A
ANGA =  0.024477314712  ;%dogleg bend angle (rad)
XOFF =  -25.610*IN2M;
YOFF =  25.570*IN2M;
ROLLA =  -1.054575132367;
BRB1A={'be' 'BRB1' LBR/2 [ANGA/2 GBR/2 ANGA/2 0 FBR 0 ROLLA]}';
BRB1B={'be' 'BRB1' LBR/2 [ANGA/2 GBR/2 0 ANGA/2 0 FBR ROLLA]}';
BRB2A={'be' 'BRB2' LBR/2 [-ANGA/2 GBR/2 -ANGA/2 0 FBR 0 ROLLA]}';
BRB2B={'be' 'BRB2' LBR/2 [-ANGA/2 GBR/2 0 -ANGA/2 0 FBR ROLLA]}';
% downstream R56 compensation chicane:
%   ABCX..  = chicane bend angle (rad)
%   BBCX..  = chicane bend field (kG)
%   LBCX..  = chicane bend path length (m)
%   ABCX..S = "short" half chicane bend angle (rad)
%   ABCX..L = "long" half chicane bend angle (rad)
%   LBCX..S = "short" half chicane bend path length (m)
%   LBCX..L = "long" half chicane bend path length (m)
ABCXDLD0 =  0.010734075009 ;%R56=9.99E-5
ABCXDLD =  1.15*ABCXDLD0  ;%R56=1.32E-4
BBCXDLD =  BRHOF*sin(ABCXDLD)/ZBCC;
ABCXDLD_2 =  ABCXDLD*ABCXDLD;
ABCXDLD_4 =  ABCXDLD_2*ABCXDLD_2;
ABCXDLD_6 =  ABCXDLD_4*ABCXDLD_2;
SINCBCXDLD =  1-ABCXDLD_2/6+ABCXDLD_4/120-ABCXDLD_6/5040;
LBCXDLD =  ZBCC/SINCBCXDLD;
ABCXDLDS =  asin(sin(ABCXDLD)/2);
ABCXDLDS_2 =  ABCXDLDS*ABCXDLDS;
ABCXDLDS_4 =  ABCXDLDS_2*ABCXDLDS_2;
ABCXDLDS_6 =  ABCXDLDS_4*ABCXDLDS_2;
SINCBCXDLDS =  1-ABCXDLDS_2/6+ABCXDLDS_4/120-ABCXDLDS_6/5040;
LBCXDLDS =  ZBCC/(2*SINCBCXDLDS);
ABCXDLDL =  ABCXDLD-ABCXDLDS;
LBCXDLDL =  LBCXDLD-LBCXDLDS;
BCXDLD1A={'be' 'BCXDLD1' LBCXDLDS [+ABCXDLDS GBCC/2 0 0 FBCC 0 0]}';
BCXDLD1B={'be' 'BCXDLD1' LBCXDLDL [+ABCXDLDL GBCC/2 0 +ABCXDLD 0 FBCC 0]}';
BCXDLD2A={'be' 'BCXDLD2' LBCXDLDL [-ABCXDLDL GBCC/2 -ABCXDLD 0 FBCC 0 0]}';
BCXDLD2B={'be' 'BCXDLD2' LBCXDLDS [-ABCXDLDS GBCC/2 0 0 0 FBCC 0]}';
BCXDLD3A={'be' 'BCXDLD3' LBCXDLDS [-ABCXDLDS GBCC/2 0 0 FBCC 0 0]}';
BCXDLD3B={'be' 'BCXDLD3' LBCXDLDL [-ABCXDLDL GBCC/2 0 -ABCXDLD 0 FBCC 0]}';
BCXDLD4A={'be' 'BCXDLD4' LBCXDLDL [+ABCXDLDL GBCC/2 +ABCXDLD 0 FBCC 0 0]}';
BCXDLD4B={'be' 'BCXDLD4' LBCXDLDS [+ABCXDLDS GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXDLU1={'be' 'BCXDLU' LBCXDLU [+ABCXDLU GBCC/2 0 +ABCXDLU FBCC FBCC 0]}';
BCXDLU2={'be' 'BCXDLU' LBCXDLU [-ABCXDLU GBCC/2 -ABCXDLU 0 FBCC FBCC 0]}';
BCXDLU3={'be' 'BCXDLU3' LBCXDLU [-ABCXDLU GBCC/2 0 -ABCXDLU FBCC FBCC 0]}';
BCXDLU4={'be' 'BCXDLU4' LBCXDLU [+ABCXDLU GBCC/2 +ABCXDLU 0 FBCC FBCC 0]}';
BRB1={'be' 'BRB' LBR [ANGA GBR/2 ANGA/2 ANGA/2 FBR FBR ROLLA]}';
BRB2={'be' 'BRB' LBR [-ANGA GBR/2 -ANGA/2 -ANGA/2 FBR FBR ROLLA]}';
BCXDLD1={'be' 'BCXDLD' LBCXDLD [+ABCXDLD GBCC/2 0 +ABCXDLD FBCC FBCC 0]}';
BCXDLD2={'be' 'BCXDLD' LBCXDLD [-ABCXDLD GBCC/2 -ABCXDLD 0 FBCC FBCC 0]}';
BCXDLD3={'be' 'BCXDLD3' LBCXDLD [-ABCXDLD GBCC/2 0 -ABCXDLD FBCC FBCC 0]}';
BCXDLD4={'be' 'BCXDLD4' LBCXDLD [+ABCXDLD GBCC/2 +ABCXDLD 0 FBCC FBCC 0]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
% dogleg
KQDOG =  0.563669043742;
QDOG1={'qu' 'QDOG1' LQR/2 [KQDOG 0]}';
QDOG2={'qu' 'QDOG2' LQR/2 [-KQDOG 0]}';
QDOG3={'qu' 'QDOG3' LQR/2 [KQDOG 0]}';
QDOG4={'qu' 'QDOG4' LQR/2 [-KQDOG 0]}';
QDOG5={'qu' 'QDOG5' LQR/2 [KQDOG 0]}';
QDOG6={'qu' 'QDOG6' LQR/2 [-KQDOG 0]}';
QDOG7={'qu' 'QDOG7' LQR/2 [KQDOG 0]}';
QDOG8={'qu' 'QDOG8' LQR/2 [-KQDOG 0]}';
% match to bypass line
KQL1P =   0.322623395309;
KQL2P =  -0.155036336326;
KQL3P =   0.223203385308;
KQL4P =  -0.284566066043;
KQL5P =   0.151439029009;
QL1P={'qu' 'QL1P' LQR/2 [KQL1P 0]}';
QL2P={'qu' 'QL2P' LQR/2 [KQL2P 0]}';
QL3P={'qu' 'QL3P' LQM/2 [KQL3P 0]}';
QL4P={'qu' 'QL4P' LQM/2 [KQL4P 0]}';
QL5P={'qu' 'QL5P' LQM/2 [KQL5P 0]}';
% bypass line FODO
KQBYP =   0.060580505638 ;%45 degree per cell
QBPF={'qu' 'QBPF' LQM/2 [KQBYP 0]}';
QBPD={'qu' 'QBPD' LQM/2 [-KQBYP 0]}';
QBP10={'qu' 'QBP10' LQM/2 [-KQBYP 0]}';
QBP11={'qu' 'QBP11' LQM/2 [KQBYP 0]}';
QBP12={'qu' 'QBP12' LQM/2 [-KQBYP 0]}';
% integrated strengths
% %nominal energy
% 
% 
% 
% 
% 
% 
% 

% %maximum energy (10 GeV)
% 
% 
% 
% 
% 
% 
% 

% ==============================================================================
% SEXT
% ------------------------------------------------------------------------------
KSDOG1 =  -9.188528777604 ;%-9.801 
KSDOG2 =  22.656285406772 ;%-20.61 
TSDOG1 =  -13.252537412109 ;%-0.2331*DEGRAD
TSDOG2 =   16.730337124259 ;% 0.3342*DEGRAD
SDOG1={'dr' 'SDOG1' LSB/2 []}';
SDOG2={'dr' 'SDOG2' LSB/2 []}';
% 
% 
% 

% ==============================================================================
% ROLL
% ------------------------------------------------------------------------------
AROBRB1 =  -0.12862097585E-3;
AROBRB2 =  -AROBRB1;
ROBRB1={'ro' 'ROBRB1' 0 [-(AROBRB1)]}';
ROBRB2={'ro' 'ROBRB2' 0 [-(AROBRB2)]}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% R56 compensation chicane
DCCDLUO={'dr' '' ZDCC/cos(ABCXDLU) []}';
DCCDLUI={'dr' '' ZDCC/2 []}';
% dogleg
NQBD =  8                    ;%number of dogleg quads
LTOTA =  76.022947763944      ;%path length from BRB1-exit to BRB2-entrance
LDBD =  (LTOTA+LBR)/(NQBD/2) ;%FODO cell half length
DLDBD =  -0.1248168861E-4     ;%adjustment for dispersion correction
LDBDH =  LDBD/2+DLDBD         ;%FODO cell half length
DBDM1={'dr' '' 0.5 []}';%drift between CCDLU and BRB1
DBD={'dr' '' LTOTA []}';
DBD0={'dr' '' (LDBDH-LBR-LQR)/2-4*DLDBD []}';
DBD1={'dr' '' LDBDH-LQR []}';
DBD2={'dr' '' LDBDH-LQR []}';
DBD3={'dr' '' LDBDH-LQR []}';
DBD4={'dr' '' LDBDH-LQR []}';
DBD5={'dr' '' LDBDH-LQR []}';
DBD6={'dr' '' LDBDH-LQR []}';
DBD7={'dr' '' LDBDH-LQR []}';
DBD8={'dr' '' (LDBDH-LQR-LBR)/2-4*DLDBD []}';
% 
% 
% 

DBD1SB={'dr' '' 0.2016 []}';
DBD1SA={'dr' '' DBD1{3}-LSB-DBD1SB{3} []}';
DBD6SB={'dr' '' 0.203095 []}';
DBD6SA={'dr' '' DBD6{3}-LSB-DBD6SB{3} []}';
DBD0A={'dr' '' 1.0 []}';
DBD0C={'dr' '' 0.5185-LQR/2 []}';
DBD0B={'dr' '' DBD0{3}-DBD0A{3}-DBD0C{3} []}';
DBD1A={'dr' '' 0.5786-LQR/2 []}';
DBD1D={'dr' '' 0.2016 []}';
DBD1C={'dr' '' 0.536-LSB-DBD1D{3} []}';
DBD1B={'dr' '' DBD1{3}-DBD1A{3}-LJAW-DBD1C{3}-LSB-DBD1D{3} []}';
DBD2A={'dr' '' 0.5786-LQR/2 []}';
DBD2B={'dr' '' 0.6368 []}';
DBD2D={'dr' '' 0.5185-LQR/2 []}';
DBD2C={'dr' '' DBD2{3}-DBD2A{3}-DBD2B{3}-DBD2D{3} []}';
DBD3A={'dr' '' 0.5786-LQR/2 []}';
DBD3C={'dr' '' 0.5185-LQR/2 []}';
DBD3B={'dr' '' DBD3{3}-DBD3A{3}-DBD3C{3} []}';
DBD4A={'dr' '' 0.5786-LQR/2 []}';
DBD4C={'dr' '' 0.5185-LQR/2 []}';
DBD4B={'dr' '' DBD4{3}-DBD4A{3}-DBD4C{3} []}';
DBD4H={'dr' '' DBD4{3}/2 []}';
DBD5A={'dr' '' 0.5786-LQR/2 []}';
DBD5C={'dr' '' 0.5 []}';
DBD5D={'dr' '' 0.536 []}';
DBD5B={'dr' '' DBD5{3}-DBD5A{3}-DBD5C{3}-DBD5D{3} []}';
DBD6A={'dr' '' 0.5786-LQR/2 []}';
DBD6B={'dr' '' 0.527 []}';
DBD6E={'dr' '' 0.203095 []}';
DBD6D={'dr' '' 0.772576-LQR/2-LSB-DBD6E{3} []}';
DBD6C={'dr' '' DBD6{3}-DBD6A{3}-DBD6B{3}-DBD6D{3}-LSB-DBD6E{3} []}';
DBD7A={'dr' '' 0.5786-LQR/2 []}';
DBD7C={'dr' '' 0.5185-LQR/2 []}';
DBD7B={'dr' '' DBD7{3}-DBD7A{3}-DBD7C{3} []}';
DBD8A={'dr' '' 0.5786-LQR/2 []}';
DBD8B={'dr' '' DBD8{3}-DBD8A{3} []}';
% R56 compensation chicane
DCCDLDO={'dr' '' ZDCC/cos(ABCXDLD) []}';
DCCDLDI={'dr' '' ZDCC/2 []}';
% bypass line FODO
DBP={'dr' '' (101.6-LQM)/2 []}';
DBPSA={'dr' '' 15.468697 []}';%to sector boundary
DBPSB={'dr' '' DBP{3}-DBPSA{3} []}';
% match to bypass line
LLTOT =  99.751028062374;
LL0 =   5.0;
LL1 =  18.0;
LL2 =  34.5;
LL3 =  11.0;
LL4 =  LLTOT-LL0-LL1-LL2-LL3;
DLCCP={'dr' '' 0.5 []}';
DL0P={'dr' '' LL0 []}';
DL1P={'dr' '' LL1 []}';
DL2P={'dr' '' LL2 []}';
DL3P={'dr' '' LL3 []}';
DL4P={'dr' '' LL4 []}';
DL0PA={'dr' '' 0.3 []}';
DL0PB={'dr' '' LL0-DL0PA{3} []}';
DL1PA={'dr' '' 0.4471 []}';
DL1PB={'dr' '' 0.6368 []}';
DL1PC={'dr' '' LL1-DL1PA{3}-DL1PB{3} []}';
DL2PA={'dr' '' 0.4471 []}';
DL2PB={'dr' '' 0.6368 []}';
DL2PC={'dr' '' LL2-DL2PA{3}-DL2PB{3} []}';
DL3PA={'dr' '' 0.4598 []}';
DL3PB={'dr' '' 0.7433 []}';
DL3PC={'dr' '' 5.9032251 []}';
DL3PD={'dr' '' LL3-DL3PA{3}-DL3PB{3}-DL3PC{3} []}';
DL4PA={'dr' '' 0.4598 []}';
DL4PB={'dr' '' 0.7433 []}';
DL4PC={'dr' '' LL4-DL4PA{3}-DL4PB{3} []}';
DBPA={'dr' '' 0.4598 []}';
DBPB={'dr' '' 0.7433 []}';
DBPC={'dr' '' DBP{3}-DBPA{3}-DBPB{3} []}';
DBPE={'dr' '' 0.1 []}';
DBPF={'dr' '' 1.0 []}';
DBPD={'dr' '' DBP{3}-DBPA{3}-DBPB{3}-DBPE{3}-DBPF{3} []}';
DBPD1={'dr' '' 21.403397 []}';
S10WALL={'dr' '' 1.83 []}';
DBPD2={'dr' '' DBPD{3}-DBPD1{3}-S10WALL{3} []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMDOG1={'mo' 'BPMDOG1' 0 []}';
BPMDOG2={'mo' 'BPMDOG2' 0 []}';%RFBDOG2 : MONI, TYPE="@2,CavityL-1"
BPMDOG3={'mo' 'BPMDOG3' 0 []}';
BPMDOG4={'mo' 'BPMDOG4' 0 []}';
BPMDOG5={'mo' 'BPMDOG5' 0 []}';
BPMDOG6={'mo' 'BPMDOG6' 0 []}';%RFBDOG6 : MONI, TYPE="@2,CavityL-1"
BPMDOG7={'mo' 'BPMDOG7' 0 []}';
BPMDOG8={'mo' 'BPMDOG8' 0 []}';
BPML1P={'mo' 'BPML1P' 0 []}';
BPML2P={'mo' 'BPML2P' 0 []}';
BPML3P={'mo' 'BPML3P' 0 []}';
BPML4P={'mo' 'BPML4P' 0 []}';
BPML5P={'mo' 'BPML5P' 0 []}';
BPMBP10={'mo' 'BPMBP10' 0 []}';
BPMBP11={'mo' 'BPMBP11' 0 []}';
BPMBP12={'mo' 'BPMBP12' 0 []}';
RFBWSBP1={'mo' 'RFBWSBP1' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCDOG1={'mo' 'XCDOG1' 0 []}';
XCDOG3={'mo' 'XCDOG3' 0 []}';
XCDOG5={'mo' 'XCDOG5' 0 []}';
XCDOG7={'mo' 'XCDOG7' 0 []}';
XCL1P={'mo' 'XCL1P' 0 []}';
XCL3P={'mo' 'XCL3P' 0 []}';
XCL5P={'mo' 'XCL5P' 0 []}';
XCBP11={'mo' 'XCBP11' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCDOG0={'mo' 'YCDOG0' 0 []}';
YCDOG2={'mo' 'YCDOG2' 0 []}';
YCDOG4={'mo' 'YCDOG4' 0 []}';
YCDOG6={'mo' 'YCDOG6' 0 []}';
YCDOG8={'mo' 'YCDOG8' 0 []}';
YCL2P={'mo' 'YCL2P' 0 []}';
YCL4P={'mo' 'YCL4P' 0 []}';
YCBP10={'mo' 'YCBP10' 0 []}';
YCBP12={'mo' 'YCBP12' 0 []}';
% ==============================================================================
% marker points, etc.
% ------------------------------------------------------------------------------
% collimator
% CEDOG : energy coll in bypass dog-leg (YSIZE is half-gap)
CEDOG={'dr' 'CEDOG' LJAW []}';
% beam profile measurement
OTRDOG={'mo' 'OTRDOG' 0 []}';
WSDOG={'mo' 'WSDOG' 0 []}';
OTR31={'mo' 'OTR31' 0 []}';%CSR-induced coupling from dogleg
WSBP1={'mo' 'WSBP1' 0 []}';
% markers
CCDLUBEG={'mo' 'CCDLUBEG' 0 []}';
CCDLUMID={'mo' 'CCDLUMID' 0 []}';
CNTDLU={'mo' 'CNTDLU' 0 []}';
CCDLUEND={'mo' 'CCDLUEND' 0 []}';
BDBEG={'mo' 'BDBEG' 0 []}';
CLBRB1={'mo' 'CLBRB1' 0 []}';%BRB1 centerline
MIDBD={'mo' 'MIDBD' 0 []}';
CLBRB2={'mo' 'CLBRB2' 0 []}';%BRB2 centerline
CNTDOG={'mo' 'CNTDOG' 0 []}';
BDEND={'mo' 'BDEND' 0 []}';
CCDLDBEG={'mo' 'CCDLDBEG' 0 []}';
CCDLDMID={'mo' 'CCDLDMID' 0 []}';
CNTDLD={'mo' 'CNTDLD' 0 []}';
CCDLDEND={'mo' 'CCDLDEND' 0 []}';
RWWAKE1={'mo' 'RWWAKE1' 0 []}';%EXT+BD beampipe wake applied here
% sector boundaries (ZBEG=101.6*(n-1); ZEND=101.6*n)
BPN09BEG={'mo' 'BPN09BEG' 0 []}';
BPN09END={'mo' 'BPN09END' 0 []}';
BPN10BEG={'mo' 'BPN10BEG' 0 []}';
BPN10END={'mo' 'BPN10END' 0 []}';
BPN11BEG={'mo' 'BPN11BEG' 0 []}';
BPN11END={'mo' 'BPN11END' 0 []}';
BPN12BEG={'mo' 'BPN12BEG' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
BCXDLU1_FULL=[BCXDLU1A,BCXDLU1B];
BCXDLU2_FULL=[BCXDLU2A,BCXDLU2B];
BCXDLU3_FULL=[BCXDLU3A,BCXDLU3B];
BCXDLU4_FULL=[BCXDLU4A,BCXDLU4B];
BRB1_FULL=[BRB1A,CLBRB1,BRB1B];
BRB2_FULL=[BRB2A,CLBRB2,BRB2B];
BCXDLD1_FULL=[BCXDLD1A,BCXDLD1B];
BCXDLD2_FULL=[BCXDLD2A,BCXDLD2B];
BCXDLD3_FULL=[BCXDLD3A,BCXDLD3B];
BCXDLD4_FULL=[BCXDLD4A,BCXDLD4B];
QDOG1_FULL=[QDOG1,QDOG1];
QDOG2_FULL=[QDOG2,QDOG2];
QDOG3_FULL=[QDOG3,QDOG3];
QDOG4_FULL=[QDOG4,QDOG4];
QDOG5_FULL=[QDOG5,QDOG5];
QDOG6_FULL=[QDOG6,QDOG6];
QDOG7_FULL=[QDOG7,QDOG7];
QDOG8_FULL=[QDOG8,QDOG8];
QL1P_FULL=[QL1P,QL1P];
QL2P_FULL=[QL2P,QL2P];
QL3P_FULL=[QL3P,QL3P];
QL4P_FULL=[QL4P,QL4P];
QL5P_FULL=[QL5P,QL5P];
QBP10_FULL=[QBP10,QBP10];
QBP11_FULL=[QBP11,QBP11];
QBP12_FULL=[QBP12,QBP12];
SDOG1_FULL=[SDOG1,SDOG1];
SDOG2_FULL=[SDOG2,SDOG2];
CCDLU=[CCDLUBEG,BCXDLU1_FULL,DCCDLUO,BCXDLU2_FULL,DCCDLUI,CCDLUMID,DCCDLUI,BCXDLU3_FULL,DCCDLUO,BCXDLU4_FULL,CNTDLU,CCDLUEND];
CCDLD=[CCDLDBEG,BCXDLD1_FULL,DCCDLDO,BCXDLD2_FULL,DCCDLDI,CCDLDMID,DCCDLDI,BCXDLD3_FULL,DCCDLDO,BCXDLD4_FULL,CNTDLD,CCDLDEND];
% %simplified (1st order)
% DLBP=[BDBEG,BRB1A,CLBRB1,BRB1B,ROBRB1,DBD0,QDOG1,QDOG1,DBD1,QDOG2,QDOG2,DBD2,QDOG3,QDOG3,DBD3,QDOG4,QDOG4,DBD4H,MIDBD,DBD4H,QDOG5,QDOG5,DBD5,QDOG6,QDOG6,DBD6,QDOG7,QDOG7,DBD7,QDOG8,QDOG8,DBD8,ROBRB2,BRB2A,CLBRB2,BRB2B,BDEND];

% %simplified (2nd order)
% DLBP=[BDBEG,BRB1A,CLBRB1,BRB1B,ROBRB1,DBD0,QDOG1,QDOG1,DBD1SA,SDOG1,SDOG1,DBD1SB,QDOG2,QDOG2,DBD2,QDOG3,QDOG3,DBD3,QDOG4,QDOG4,DBD4H,MIDBD,DBD4H,QDOG5,QDOG5,DBD5,QDOG6,QDOG6,DBD6SA,SDOG2,SDOG2,DBD6SB,QDOG7,QDOG7,DBD7,QDOG8,QDOG8,DBD8,ROBRB2,BRB2A,CLBRB2,BRB2B,BDEND];

%COMMENT complete
DLBP=[BDBEG,BRB1_FULL,ROBRB1,DBD0A,YCDOG0,DBD0B,XCDOG1,DBD0C,QDOG1_FULL,DBD1A,BPMDOG1,DBD1B,CEDOG,DBD1C,SDOG1_FULL,DBD1D,QDOG2_FULL,DBD2A,BPMDOG2,DBD2B,YCDOG2,DBD2C,XCDOG3,DBD2D,QDOG3_FULL,DBD3A,BPMDOG3,DBD3B,YCDOG4,DBD3C,QDOG4_FULL,DBD4A,BPMDOG4,DBD4B,XCDOG5,DBD4C,QDOG5_FULL,DBD5A,BPMDOG5,DBD5B,YCDOG6,DBD5C,OTRDOG,DBD5D,QDOG6_FULL,DBD6A,BPMDOG6,DBD6B,WSDOG,DBD6C,XCDOG7,DBD6D,SDOG2_FULL,DBD6E,QDOG7_FULL,DBD7A,BPMDOG7,DBD7B,YCDOG8,DBD7C,QDOG8_FULL,DBD8A,BPMDOG8,DBD8B,ROBRB2,BRB2_FULL,CNTDOG,RWWAKE1,BDEND];
%ENDCOMMENT
% %simplified
% MTCH1=[DLCCP,CCDLD,DL0P,QL1P,QL1P,DL1P,QL2P,QL2P,DL2P,QL3P,QL3P,DL3P,QL4P,QL4P,DL4P,QL5P,QL5P,DBP,DBP,QBP10,QBP10,DBPA,DBPB,DBPD,DBPE,WSBP0,DBPF,DBP,QBP11,QBP11,DBP,DBP,QBP12,QBP12,DBPA,DBPB,DBPD];

%COMMENT complete
MTCH1=[DLCCP,CCDLD,DL0PA,OTR31,DL0PB,QL1P_FULL,DL1PA,BPML1P,DL1PB,XCL1P,DL1PC,QL2P_FULL,DL2PA,BPML2P,DL2PB,YCL2P,DL2PC,QL3P_FULL,DL3PA,BPML3P,DL3PB,XCL3P,DL3PC,BPN09BEG,DL3PD,QL4P_FULL,DL4PA,BPML4P,DL4PB,YCL4P,DL4PC,QL5P_FULL,DBPA,BPML5P,DBPB,XCL5P,DBPC,DBPSA,BPN09END,BPN10BEG,DBPSB,QBP10_FULL,DBPA,BPMBP10,DBPB,YCBP10,DBPD1,S10WALL,DBPD2,RFBWSBP1,DBPE,WSBP1,DBPF,DBPSA,BPN10END,BPN11BEG,DBPSB,QBP11_FULL,DBPA,BPMBP11,DBPB,XCBP11,DBPC,DBPSA,BPN11END,BPN12BEG,DBPSB,QBP12_FULL,DBPA,BPMBP12,DBPB,YCBP12,DBPD];
%ENDCOMMENT
DLBM=[BEGDOG,CCDLU,DBDM1,DLBP,MTCH1,ENDDOG];
BFODO=[QBPF,DBP,DBP,QBPD,QBPD,DBP,DBP,QBPF];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc 3-way spreader system
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 26-NOV-2019, M. Woodley
%  * remove IMBCSh3, IMBCSs3, and IMBCSd3 per Y. Ding
%  * undefer BKXRASD and BKYRASD (already installed)
% 11-NOV-2019, M. Woodley
%  * defer (level 0) BKXRASD and BKYRASD per D. Hanquist
% 11-OCT-2019, M. Woodley
%  * remove PCSP3D/BTMSP3D per S. Trovati
% ------------------------------------------------------------------------------
% 06-JUN-2019, M. Woodley
%  * adjust location of BSY dump face per A. Ibrahimov
% 30-APR-2019, M. Woodley
%  * use measured FINT=0.4861 for 1.0D38.37 @ 200A
% ------------------------------------------------------------------------------
% 31-OCT-2018, Y. Nosochkov
%  * drift adjustment for DASEL with 25G kickers
%  * BSY dump face to BTM face = 61.120" (per Alev)
% 11-OCT-2018, M. Woodley
%  * use measured FINT for 1.0D22.265's
% ------------------------------------------------------------------------------
% 30-MAY-2018, M. Woodley
%  * add backup DC spreader definitions per J. Chan
% ------------------------------------------------------------------------------
% 30-JAN-2018, M. Woodley
%  * remove PCSP1H/BTMSP1H,PCSP1D/BTMSP1D,PCSP2D/BTMSP2D per D. Hanquist
%  * remove PCSP2H/BTMSP2H,PCSP3D per A. Ibramimov
%  * set length of PCSP3D to 2" per A. Ibrahimov
% 22-DEC-2017, M. Woodley
%  * remove BCS ACMs IMSP1s,IMSP2s,IMSP1h,IMSP2h,IMSP1d,IMSP2d per C. Clarke
%  * add BCS ACM triplets IMBCSh1-3,IMBCSs1-3,IMBCSd1-3 per C. Clarke
% ------------------------------------------------------------------------------
% 06-SEP-2017, Y. Nosochkov
%  * add placeholder zero-strength deferred large aperture kickers 
%    BKYSP5H, BKYSP5S for future LCLS-II-HE 
%  * remove baseline stoppers STSP6hb, STSP5s and the corresponding BTMs
%    BTMSP6hb, BTMSP5s (J. Blaha, J. Welch)
%  * remove deferred stoppers STSP6hc, STSP6hd as they will never be needed
%    (P. Emma)
%  * move BCS collimators PCSP1s,2s and the corresponding BTMs BTMSP1s,2s
%    downstream, per RP-RPG-170802-MEM-01 (M. Santana)
% 09-AUG-2017, M. Woodley
%  * move TWSSP BETA0 definition to LCLS2sc_main.mad8 (for BMAD compatability)
%  * move SETKIKs and SETKIKh definitions here from common.xsif
% ------------------------------------------------------------------------------
% 05-MAY-2017, Y. Nosochkov
%  * move OTRSPDMP 0.5 m downstream of BPMSP5d (P. Emma, J. Welch)
%  * replace 1.97Q20 type quads (QSP3H,11H and QSP1S,2S,3S,7S,8S,9S) with
%    1.26Q12 type quads, keep BPMs unchanged (J. Amann, P. Emma)
%  * add two type-5 deferred correctors XCSP5d, YCSP6d in BSY dumpline (P. Emma)
% 24-FEB-2017, Y. Nosochkov
%  * move BPMSP5D 0.761425 m upstream to Z=3203.327 m (M. Kosovsky)
% 23-NOV-2016, Y. Nosochkov
%  * redefine SPRDd line for updated DASEL kicker
% 04-NOV-2016, M. Woodley
%  * fix drift lengths around WOODDOOR in SPRDh line
% 02-NOV-2016, Y. Nosochkov
%  * move BPMSP1d 4.457 m upstream to provide space for DASEL kicker
%  * add a note that BTM behind stopper is part of the stopper design
%  * add a note that BXSP1h is a special merge DC-bend which is turned ON
%    for SCRF beam to HXR or OFF for CURF beam to HXR
%  * move to baseline: BPMSPH, BPMSP1, XCSP1, BPMSP2, YCSP2, BPMSPS, IMSP1H,
%    BTMSP6HB, BTMSP5S, PCSP1D, PCSP1H, PCSP1S, BTMSP1D, BTMSP1H, BTMSP1S,
%    IMSP1S, PCSP2S, BTMSP2S, XCSP3D, YCSP4D, IMSP1D, IMSP2D, PCSP2D, BTMSPDMP,
%    BTMSP2D, PCSP2H, BTMSP2H, BKXRASD, BKYRASD, BPMSP5D, PCSP3D, BTMSP3D
% 29-JUN-2016, M. Woodley
%  * adjust location of WOODDOOR (Z=3050.512)
% 24-JUN-2016, Y. Nosochkov
%  * move BPMSPh, BPMSPs upstream to the positions where kicked orbit is 5 mm
%    (P. Emma)
%  * move BPMs inside the 1.085Q4.31 quads QSP2h, QSP7h, QSP12h
%    (M. Gaynor, Alev)
%  * add deferred XCSP3d, YCSP4d correctors just after BYSP2d (P. Emma)
%  * add deferred BKXRASd, BKYRASd rastering kickers 60 m upstream of the
%    BSY dump (J. Welch)
%  * move the deferred OTRSPDMP upstream of the rastering kickers (P. Emma)
%  * move BPMSP4d upstream of OTRSPDMP (J. Welch)
%  * add deferred large aperture BPMSP5d (Stripline-14 with 5" ID)
%    within 5 m of BSY dump (J. Welch)
%  * move BPMSP2D 12" upstream and BPMSP3D 24" upstream (M. Gaynor)
%  * remove deferred STSP6ha (S. Mao)
%  * remove STSP6hc, STSP6hd stoppers from baseline and defer them at level 9
%    (for cost tracking -- P. Emma)
%  * designate all stoppers to be PPS stoppers (S. Mao)
%  * add deferred BTMSP6hb behind PPS stopper STSP6hb (S. Mao)
%  * add deferred BTMSP5s behind PPS stopper STSP5s (S. Mao)
%  * move IMSP1h to just downstream of QSP6h (S. Mao)
%  * move IMSP1s to just downstream of BXSP2s (S. Mao)
%  * add deferred IMSP2h, IMSP2s BCS cavity current monitors (S. Mao, J. Welch)
%  * update engineering type designations of current monitors (J. Welch)
%  * update the engineering type of BKYSP0h,...,BKYSP4h and BKYSP0s,...,BKYSP4s
%    kickers to "0.787K35.4" (J. Amann)
% ------------------------------------------------------------------------------
% 26-FEB-2016, Y. Nosochkov
%  * adjust positions of QSP3h,4h,5h,9h,10h,11h and corresponding
%    BPMs and correctors to resolve interferences (T. O'Heron)
%  * move XCSP1 1.216 m downstream (T. O'Heron)
%  * move WSSP1d 1.0 m downstream (T. O'Heron)
%  * adjust positions of STSP6Ha,b,c,d to resolve interferences (T. O'Heron)
%  * change engineering name of BSY dump from "D10" to "DUMPBSY"
%  * move BYSP1s, BYSP2s 9" (0.2286 m) upstream (T. O'Heron)
%  * align PCSP1h, PCSP1s, PCSP1d at the same Z (S. Mao)
%  * move IMSP2d to just downstream of IMSP1d (S. Mao)
%  * move IMSP1h to just dowstream of BRSP2H (S. Mao)
%  * increase distance between 1-m kicker sections from 15 cm to 30 cm
%    (T. Beukers)
%  * add BPMSPh and BPMSPs between fast kickers and septa for calibration
%    of the kick angle and kicker phase (per P. Emma) -- deferred @0
%  * add BCS BTM (BTMSPDMP) behind BSY dump (per S. Mao) -- deferred @0
%  * move BPMSP1 upstream to within 23 m of the HXR septum (for greater
%    phase advance with BPMSP2)
% 12-FEB-2016, M. Woodley
%  * remove SETKIKh and SETKIKs; remove SEQnn MARKers
%  * add sextupoles to correct 2nd-order dispersion per P. Emma
%  * add wood door at LI30/BSY boundary (WOODDOOR)
% ------------------------------------------------------------------------------
% 25-SEP-2015, Y. Nosochkov
%  * update definition of BXSP1h to allow zero angle
% 24-AUG-2015, Y. Nosochkov
%  * add placeholder kickers for future  expansion (2 HXR and 2 SXR sections)
%    deferred at level @2
%  * move BYSP1h 1.8 m downstream to increase separation with dump line
%  * update the TYPE of septa from 0.39SD38.98 to 0.625SD38.98 (J. Amann)
%  * add two quads QSP1, QSP2 (baseline) with BPMs/correctors (deferred
%    at level @0)
%  * separate the HXR/SXR spreader kickers by moving the SXR kicker, septum
%    and chicane ~86 m downstream
%  * use positive sign of vertical kick in both HXR/SXR kickers for the same
%    style septa in HXR and SXR
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * add OTRSPDMP ~12 m before the muon wall, deferred at @0 (per Paul)
%  * move WSSP1D upstream to between vertical bends where Dy=0.4 m (per Paul)
%  * add deferred BTMs behind BCS PCSP collimators (per S. Mao)
%  * move IMSP1D upstream of PCSP2D (per S. Mao)
%  * remove PCSP4D, move PCSP3D close to muon wall (per S. Mao)
%  * move BPMSP1d upstream to within 23 m of the septum (per Tor and T. O'Heron)
%  * change the type of BPMSP4D to "Stripline-5" (per C. Iverson)
%  * change the status of IMSP0D, WSSP1D, STSP5S from deferred to baseline
%  * move BPMSP2H,7H,12H outside of the quads (per T. O'Heron)
%  * move QSP1S 5 cm downstream and QSP9S 5 cm upstream (per T. O'Heron)
%  * change type of quads QSP1S,2S,3S,7S,8S,9S,3H,11H to 1.97Q20
%  * adjust positions of correctors and BPMs at 1.97Q20 quads (per T. O'Heron)
%  * remove BXSP1D assuming new BSY dump will be installed (per A. Ibrahimov)
%  * adjust positions of BPMSP3D, IMSP0D, IMSP0H, IMSP0S (per T. O'Heron)
%  * change BPMSP3D to "Stripline-8" (per M. Gaynor)
%  * change type of BPMs at 2Q10 quads to "Stripline-5" (per M. Gaynor)
% ------------------------------------------------------------------------------
% 16-APR-2015, M. Woodley
%  * restore "LQL" parameter and its dependencies
% 20-MAR-2015, M. Woodley
%  * remove dependences on (now undefined) parameter "LQL"
%  * assign TYPEs to BCS devices ... defer at level 0
% 12-MAR-2015, Y. Nosochkov
%  * move QSP3H u/s and QSP11H d/s by 15 inches (per T. O'Heron)
%  * move BPMs outside of 2Q10 quads and adjust positions of corresponding
%    correctors (per T. O'Heron)
%  * move STSP6HB 32 inches downstream (per T. O'Heron)
% 28-FEB-2015, Y. Nosochkov
%  * minor update to definiton of the spreader kickers and septa
%  * change type of QSP1S-QSP9S, QSP1H, QSP3H-QSP6H, QSP8H-QSP11H, QSP13H,
%    QSP1D, QSP2D from "1.97Q10" to "2Q10"
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * assign BPM TYPE attributes per PRD LCLSII-2.4-PR-0136
% 09-DEC-2014, Y. Nosochkov
%  * move STBP32 stopper to inside of the SXR spreader chicane and rename it
%    to STSP5s
%  * move D10 dump inside the muon wall in the BSY
%  * change engineering TYPE of QSP1d, QSP2d to "1.97Q10"
%  * rename BXSPd to BXSP1d and change its engineering TYPE to "9D28.5"
%  * rename ROSPs to ROSP1s
%  * rename IMSPs -> IMSP0s, IMSPh -> IMSP0h, IMSPd -> IMSP0d
%  * add BSC current monitors IMSP1d, IMSP2d in SPD (S. Mao)
%  * add BCS collimators PCSP1s, PCSP2s in SPS (S. Mao)
%  * add BCS collimators PCSP1h, PCSP2h in SPH (S. Mao)
%  * add BCS collimators PCSP1d, PCSP2d, PCSP3d, PCSP4d in SPD (S. Mao)
%  * change TYPE of septum magnets from "HLAM" to "0.39SD38.98" (J. Amann)
%  * add BPMSP3d, BPMSP4d at the last two bends in SPD
%  * add fast wire WSSP1d to measure beam size upstream of D10 dump (J. Frisch)
%  * change to type "QE" the following quadrupoles: QSP2h, QSP7h, QSP12h
%  * change to type "1.97Q10" the quads: QSP1h, QSP3h,...,QSP6h,
%    QSP8h,...,QSP11h, QSP13h, QSP1s,...,QSP9s
%    note: field of QSP1s,3s,7s,9s reaches the limit at 7.8 GeV
% ------------------------------------------------------------------------------
% 10-OCT-2014, Y. Nosochkov
%  * update the TYPE of STSP6ha (BCS stopper) and IMSPd (toroid) to indicate
%    the non-baseline level "0"
% 28-JUL-2014, Y. Nosochkov
%  * replace a 3-hole spreader septum with two separate 2-hole septa for SXR
%    and HXR
%  * replace a 1-m deflector in the spreader with six 1-m magnetic kickers
%    (per T. Beukers)
%  * replace dipole corrector type "1.0D18.69" with "1.0D22.625" (per J. Amann)
% 15-JUL-2014, Y. Nosochkov
%  * replace RFBSP1d, RFBSP2d with stripline BPMSP1d, BPMSP2d (per J. Frisch)
% 02-MAY-2014, M. Woodley
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
% 01-MAY-2014, Y. Nosochkov
%  * replace BPMSP1d, BPMSP2d with cavity BPMs RFBSP1d, RFBSP2d (per J. Frisch)
% 30-APR-2014, Y. Nosochkov
%  * add average current monitors IMSPs, IMSPh, IMSPd (per J. Frisch)
% 28-APR-2014, Y. Nosochkov
%  * remove QSP3D, QSP4D and their BPMs and correctors in BSY dumpline
%    assuming OTR and beta waist are not needed (per J. Frisch)
% 23-APR-2014, Y. Nosochkov
%  * remove OTRDMPd in SPD near D10 (per J. Frisch)
% 07-APR-2014, M. Woodley
%  * reorder and/or modify some drift length parameter definitions to avoid
%    using parameters before they are defined
% 04-APR-2014, Y. Nosochkov
% *  add BCS stopper upstream of 3 PPS stoppers in HXR,
%    name the BCS stopper STSP6ha, and PPS stoppers STSP6hb, STSP6hc, STSP6hd
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% 25-MAR-2014, Y. Nosochkov
%  * add insertable beam stoppers STSP6ha, STSP6hb, STSP6hc in HXR
% 07-MAR-2014, Y. Nosochkov
%  * move corrector YCSP8h upstream of quad QSP8h for better separation with
%    nearby LCLS-1 quad
% 26-FEB-2014, Y. Nosochkov
%  * change from L=2.623 m dipoles (type 1.26D102.0T) to L=1.0 m dipoles
%    (type 1.0D38.37)
%  * reduce septum length from 2.0 to 1.0 m
%  * change type of BCSP1, BCSP2 dipoles from 1.26D18.43 to 1.0D18.69
% 14-FEB-2014, Y. Nosochkov
%  * add a dumpline from the spreader to D10 dump including optics
%    for energy diagnostic
% 17-JAN-2014, Y. Nosochkov
%  * modify HXR spreader from 1-step to 2-step dogleg for tunable R56
%    and better magnet separation
% 18-DEC-2013, Y. Nosochkov
%  * adjust magnet positions in the spreader for less magnet interference
% 16-DEC-2013, Y. Nosochkov
%  * 3-way spreader design with low R56
% ------------------------------------------------------------------------------
% XYZ (linac system) and optimized Twiss at the beginning of spreader (BEGSPH)
XSP =  XOFF;
YSP =  YOFF;
ZSP =  2780.276003;
THSP =  0.0;
PHSP =  0.0;
PSSP =  0.0;
TBXSP =  1.112796938491E2;
TBYSP =  60.000000012297;
TAXSP =  2.930243793946;
TAYSP =  0.853023050724;
% XYZ (linac system) at the end of HXR merge bend BXSP1h
XSPH =   0.0;
YSPH =   0.0;
ZSPH =   3110.961492;
THSPH =   0.0;
PHSPH =   0.0;
PSSPH =   0.0;
% HXR quads
KQSP1H =   0.492283667698 ;% 0.492284061187
KQSP2H =  -1.000975451311 ;%-1.000975933726
KQSP3H =   0.304631037813 ;% 0.304631069714
KQSP4H =  -0.301467336919 ;%-0.301467337182
KQSP5H =   0.179797525903 ;% 0.179797501925
KQSP6H =  -0.221916299351 ;%-0.221916295184
KQSP7H =   0.447153951126 ;% 0.447153906987
KQSP10H =  -0.301520274195 ;%-0.301520272128
KQSP11H =   0.304797784837 ;% 0.304797809076
KQSP12H =  -0.991899431333 ;%-0.991897597733
KQSP13H =   0.491351727496 ;% 0.49135154631
KQSP8H =   KQSP6H;
KQSP9H =   KQSP5H;
QSP1H={'qu' 'QSP1H' LQR/2 [KQSP1H 0]}';
QSP2H={'qu' 'QSP2H' LQE/2 [KQSP2H 0]}';
QSP3H={'qu' 'QSP3H' LQA/2 [KQSP3H 0]}';
QSP4H={'qu' 'QSP4H' LQR/2 [KQSP4H 0]}';
QSP5H={'qu' 'QSP5H' LQR/2 [KQSP5H 0]}';
QSP6H={'qu' 'QSP6H' LQR/2 [KQSP6H 0]}';
QSP7H={'qu' 'QSP7H' LQE/2 [KQSP7H 0]}';
QSP8H={'qu' 'QSP8H' LQR/2 [KQSP8H 0]}';
QSP9H={'qu' 'QSP9H' LQR/2 [KQSP9H 0]}';
QSP10H={'qu' 'QSP10H' LQR/2 [KQSP10H 0]}';
QSP11H={'qu' 'QSP11H' LQA/2 [KQSP11H 0]}';
QSP12H={'qu' 'QSP12H' LQE/2 [KQSP12H 0]}';
QSP13H={'qu' 'QSP13H' LQR/2 [KQSP13H 0]}';
% HXR sextupoles
KSSP1H =  -20.980886636913 ;%-20.980854539502
KSSP2H =   22.597513710817 ;% 22.597505265891
TSSP1H =   15.249352738505 ;% 15.249361095235
TSSP2H =   17.803041269766 ;% 17.803035424509
SSP1H={'dr' 'SSP1H' LSB/2 []}';
SSP2H={'dr' 'SSP2H' LSB/2 []}';
% 
% 
% 

% SXR & dumpline shared quads
KQSP1 =   0.52687626083;
KQSP2 =  -0.521500809125;
QSP1={'qu' 'QSP1' LQR/2 [KQSP1 0]}';
QSP2={'qu' 'QSP2' LQR/2 [KQSP2 0]}';
% SXR quads
KQSP1S =   0.633675228645 ;% 0.633675409102
KQSP2S =  -0.558846778994 ;%-0.558846970939
KQSP3S =   0.652027259917 ;% 0.652027344684
KQSP4S =  -0.497671456472 ;%-0.497671571574
KQSP5S =   0.184431144204 ;% 0.184431117493
KQSP8S =  -0.559080484823 ;%-0.559079941433
KQSP9S =   0.633806872701 ;% 0.633806671882
KQSP6S =   KQSP4S;
KQSP7S =   KQSP3S;
QSP1S={'qu' 'QSP1S' LQA/2 [KQSP1S 0]}';
QSP2S={'qu' 'QSP2S' LQA/2 [KQSP2S 0]}';
QSP3S={'qu' 'QSP3S' LQA/2 [KQSP3S 0]}';
QSP4S={'qu' 'QSP4S' LQR/2 [KQSP4S 0]}';
QSP5S={'qu' 'QSP5S' LQR/2 [KQSP5S 0]}';
QSP6S={'qu' 'QSP6S' LQR/2 [KQSP6S 0]}';
QSP7S={'qu' 'QSP7S' LQA/2 [KQSP7S 0]}';
QSP8S={'qu' 'QSP8S' LQA/2 [KQSP8S 0]}';
QSP9S={'qu' 'QSP9S' LQA/2 [KQSP9S 0]}';
% SXR sextupoles
KSSP1S =   12.701345963181 ;% 12.701341641754
KSSP2S =   12.699237045946 ;% 12.699235330279
SSP1S={'dr' 'SSP1S' LSB/2 []}';
SSP2S={'dr' 'SSP2S' LSB/2 []}';
% 
% 
% 

% BSY dumpline quads
KQSP1D =  -0.258027172416;
KQSP2D =   0.232777714022;
QSP1D={'qu' 'QSP1D' LQR/2 [KQSP1D 0]}';
QSP2D={'qu' 'QSP2D' LQR/2 [KQSP2D 0]}';
% HXR vertical magnetic kickers
% All kickers aligned along the same z-axis (per T. Beukers)
% Assume the same z-length per kicker and same field (in SXR or HXR)
GBKYSP =  GBKSP ;%kicker gap (m) - round pipe, square bore aperture
LBKYSP =  LBKSP ;%kicker straight length (m)
SETKIKH =  0.5*SETSP*(SETSP-1)    ;%scale for HXR spreader kicker & septum
ABKYSPH0 =  -0.75E-3;
ABKYSPH =  ABKYSPH0 *SETKIKH      ;%total HXR kicker y-angle (rad)
ABKYSP1H =  asin(  sin(ABKYSPH)/3) ;%1st HXR kicker y-angle (rad)
ABKYSP12H =  asin(2*sin(ABKYSPH)/3) ;%1st+2nd HXR kicker y-angle (rad)
ABKYSP2H =  ABKYSP12H-ABKYSP1H     ;%2nd HXR kicker y-angle (rad)
ABKYSP3H =  ABKYSPH  -ABKYSP12H    ;%3rd HXR kicker y-angle (rad)
LBKYSP1H =    LBKYSP/(1-ABKYSP1H *ABKYSP1H /6);
LBKYSP12H =  2*LBKYSP/(1-ABKYSP12H*ABKYSP12H/6);
LBKYSP13H =  3*LBKYSP/(1-ABKYSPH  *ABKYSPH  /6);
LBKYSP2H =    LBKYSP12H-LBKYSP1H;
LBKYSP3H =    LBKYSP13H-LBKYSP12H;
BKYSP1HA={'be' 'BKYSP1H' LBKYSP1H/2 [ABKYSP1H/2 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP1HB={'be' 'BKYSP1H' LBKYSP1H/2 [ABKYSP1H/2 GBKYSP/2 0 ABKYSP1H 0 0.5 pi/2]}';
BKYSP2HA={'be' 'BKYSP2H' LBKYSP2H/2 [ABKYSP2H/2 GBKYSP/2 -ABKYSP1H 0 0.5 0 pi/2]}';
BKYSP2HB={'be' 'BKYSP2H' LBKYSP2H/2 [ABKYSP2H/2 GBKYSP/2 0 ABKYSP12H 0 0.5 pi/2]}';
BKYSP3HA={'be' 'BKYSP3H' LBKYSP3H/2 [ABKYSP3H/2 GBKYSP/2 -ABKYSP12H 0 0.5 0 pi/2]}';
BKYSP3HB={'be' 'BKYSP3H' LBKYSP3H/2 [ABKYSP3H/2 GBKYSP/2 0 ABKYSPH 0 0.5 pi/2]}';
% placeholder zero-strength magnets for future LCLS-II-HE HXR kickers
LBKYSP0H =  LBKYSP;
LBKYSP4H =  LBKYSP/cos(ABKYSPH);
BKYSP0HA={'be' 'BKYSP0H' LBKYSP0H/2 [0 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP0HB={'be' 'BKYSP0H' LBKYSP0H/2 [0 GBKYSP/2 0 0 0 0.5 pi/2]}';
BKYSP4HA={'be' 'BKYSP4H' LBKYSP4H/2 [0 GBKYSP/2 -ABKYSPH 0 0.5 0 pi/2]}';
BKYSP4HB={'be' 'BKYSP4H' LBKYSP4H/2 [0 GBKYSP/2 0 ABKYSPH 0 0.5 pi/2]}';
GBKYSP5H =  0.035;
ZBKYSP5H =  1.0;
LBKYSP5H =  ZBKYSP5H/cos(ABKYSPH);
BKYSP5HA={'be' 'BKYSP5H' LBKYSP5H/2 [0 GBKYSP5H/2 -ABKYSPH 0 0.5 0 pi/2]}';
BKYSP5HB={'be' 'BKYSP5H' LBKYSP5H/2 [0 GBKYSP5H/2 0 ABKYSPH 0 0.5 pi/2]}';
% SXR vertical magnetic kickers
% All kickers aligned along the same z-axis (per T. Beukers)
% Assume the same z-length per kicker and same field (in SXR or HXR)
SETKIKS =  0.5*SETSP*(SETSP+1)    ;%scale for SXR spreader kicker & septum
ABKYSPS0 =  -0.75E-3;
ABKYSPS =  ABKYSPS0 *SETKIKS      ;%total SXR kicker y-angle (rad)
ABKYSP1S =  asin(  sin(ABKYSPS)/3) ;%1st SXR kicker y-angle (rad)
ABKYSP12S =  asin(2*sin(ABKYSPS)/3) ;%1st+2nd SXR kicker y-angle (rad)
ABKYSP2S =  ABKYSP12S-ABKYSP1S     ;%2nd SXR kicker y-angle (rad)
ABKYSP3S =  ABKYSPS  -ABKYSP12S    ;%3rd SXR kicker y-angle (rad)
LBKYSP1S =    LBKYSP/(1-ABKYSP1S *ABKYSP1S /6);
LBKYSP12S =  2*LBKYSP/(1-ABKYSP12S*ABKYSP12S/6);
LBKYSP13S =  3*LBKYSP/(1-ABKYSPS  *ABKYSPS  /6);
LBKYSP2S =    LBKYSP12S-LBKYSP1S;
LBKYSP3S =    LBKYSP13S-LBKYSP12S;
BKYSP1SA={'be' 'BKYSP1S' LBKYSP1S/2 [ABKYSP1S/2 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP1SB={'be' 'BKYSP1S' LBKYSP1S/2 [ABKYSP1S/2 GBKYSP/2 0 ABKYSP1S 0 0.5 pi/2]}';
BKYSP2SA={'be' 'BKYSP2S' LBKYSP2S/2 [ABKYSP2S/2 GBKYSP/2 -ABKYSP1S 0 0.5 0 pi/2]}';
BKYSP2SB={'be' 'BKYSP2S' LBKYSP2S/2 [ABKYSP2S/2 GBKYSP/2 0 ABKYSP12S 0 0.5 pi/2]}';
BKYSP3SA={'be' 'BKYSP3S' LBKYSP3S/2 [ABKYSP3S/2 GBKYSP/2 -ABKYSP12S 0 0.5 0 pi/2]}';
BKYSP3SB={'be' 'BKYSP3S' LBKYSP3S/2 [ABKYSP3S/2 GBKYSP/2 0 ABKYSPS 0 0.5 pi/2]}';
% placeholder zero-strength magnets for future LCLS-II-HE SXR kickers
LBKYSP0S =  LBKYSP;
LBKYSP4S =  LBKYSP/cos(ABKYSPS);
BKYSP0SA={'be' 'BKYSP0S' LBKYSP0S/2 [0 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP0SB={'be' 'BKYSP0S' LBKYSP0S/2 [0 GBKYSP/2 0 0 0 0.5 pi/2]}';
BKYSP4SA={'be' 'BKYSP4S' LBKYSP4S/2 [0 GBKYSP/2 -ABKYSPS 0 0.5 0 pi/2]}';
BKYSP4SB={'be' 'BKYSP4S' LBKYSP4S/2 [0 GBKYSP/2 0 ABKYSPS 0 0.5 pi/2]}';
GBKYSP5S =  0.035;
ZBKYSP5S =  1.0;
LBKYSP5S =  ZBKYSP5S/cos(ABKYSPS);
BKYSP5SA={'be' 'BKYSP5S' LBKYSP5S/2 [0 GBKYSP5S/2 -ABKYSPS 0 0.5 0 pi/2]}';
BKYSP5SB={'be' 'BKYSP5S' LBKYSP5S/2 [0 GBKYSP5S/2 0 ABKYSPS 0 0.5 pi/2]}';
% 2-hole HXR horizontal septum aligned along the bypass axis
GBLXSP =  GBLSP ;%septum gap height (m)
LBLXSP =  LBLSP ;%septum straight length (m)
ABLXSPH0 =  -0.0055277237035;
ABLXSPH =  ABLXSPH0 *SETKIKH;
ABLXSPHA =  asin(sin(ABLXSPH)/2);
ABLXSPHB =  ABLXSPH-ABLXSPHA;
ABLXSPH_2 =  ABLXSPH   *ABLXSPH;
ABLXSPH_4 =  ABLXSPH_2 *ABLXSPH_2;
ABLXSPHA_2 =  ABLXSPHA  *ABLXSPHA;
ABLXSPHA_4 =  ABLXSPHA_2*ABLXSPHA_2;
LBLXSPH =  LBLXSP   /(1-ABLXSPH_2/6 +ABLXSPH_4/120 )/cos(ABKYSPH);
LBLXSPHA =  LBLXSP/2 /(1-ABLXSPHA_2/6+ABLXSPHA_4/120)/cos(ABKYSPH);
LBLXSPHB =  LBLXSPH-LBLXSPHA;
BLXSPHA={'be' 'BLXSPH' LBLXSPHA [ABLXSPHA GBLXSP/2 0 0 0.5 0 0]}';
BLXSPHB={'be' 'BLXSPH' LBLXSPHB [ABLXSPHB GBLXSP/2 0 ABLXSPH 0 0.5 0]}';
% 2-hole SXR horizontal septum aligned along the bypass axis
ABLXSPS0 =  0.011055447407;
ABLXSPS =  ABLXSPS0 *SETKIKS;
ABLXSPSA =  asin(sin(ABLXSPS)/2);
ABLXSPSB =  ABLXSPS-ABLXSPSA;
ABLXSPS_2 =  ABLXSPS   *ABLXSPS;
ABLXSPS_4 =  ABLXSPS_2 *ABLXSPS_2;
ABLXSPSA_2 =  ABLXSPSA  *ABLXSPSA;
ABLXSPSA_4 =  ABLXSPSA_2*ABLXSPSA_2;
LBLXSPS =  LBLXSP   /(1-ABLXSPS_2/6 +ABLXSPS_4/120 )/cos(ABKYSPS);
LBLXSPSA =  LBLXSP/2 /(1-ABLXSPSA_2/6+ABLXSPSA_4/120)/cos(ABKYSPS);
LBLXSPSB =  LBLXSPS-LBLXSPSA;
BLXSPSA={'be' 'BLXSPS' LBLXSPSA [ABLXSPSA GBLXSP/2 0 0 0.5 0 0]}';
BLXSPSB={'be' 'BLXSPS' LBLXSPSB [ABLXSPSB GBLXSP/2 0 ABLXSPS 0 0.5 0]}';
% measured FINT for 1.0D38.37 @ 200A
FBSP =  0.4861;
% HXR rolled bends
ABRSPH =  0.650488048269E-2;
LBRSPH =  LBSP*ABRSPH/(2*sin(ABRSPH/2)) ;%BRSPh path length (m)
TBRSPH =  0.555232529864                ;%BRSPh roll angle (rad)
BRSP1HA={'be' 'BRSP1H' LBRSPH/2 [ABRSPH/2 GBSP/2 ABRSPH/2 0 FBSP 0 TBRSPH]}';
BRSP1HB={'be' 'BRSP1H' LBRSPH/2 [ABRSPH/2 GBSP/2 0 ABRSPH/2 0 FBSP TBRSPH]}';
BRSP2HA={'be' 'BRSP2H' LBRSPH/2 [-ABRSPH/2 GBSP/2 -ABRSPH/2 0 FBSP 0 TBRSPH]}';
BRSP2HB={'be' 'BRSP2H' LBRSPH/2 [-ABRSPH/2 GBSP/2 0 -ABRSPH/2 0 FBSP TBRSPH]}';
% HXR horizontal bend
% Note: BXSP1h is a merge DC-bend which is either turned ON to operate
%       SCRF beam in HXR, or turned OFF to operate CURF beam in HXR
DABXSPH =  0.155464098791E-8;
ABXSPH =  (-ABLXSPH0+DABXSPH) *SETKIKH;
ABXSPHH =  ABXSPH/2;
ABXSPHH_2 =  ABXSPHH   *ABXSPHH;
ABXSPHH_4 =  ABXSPHH_2 *ABXSPHH_2;
LBXSPH =  LBSP/(1-ABXSPHH_2/6 +ABXSPHH_4/120) ;%BXSP1h path length (m)
BXSP1HA={'be' 'BXSP1H' LBXSPH/2 [ABXSPH/2 GBSP/2 ABXSPH/2 0 FBSP 0 0]}';
BXSP1HB={'be' 'BXSP1H' LBXSPH/2 [ABXSPH/2 GBSP/2 0 ABXSPH/2 0 FBSP 0]}';
% SXR horizontal bends
DABXSPS =  0.310901777441E-8;
ABXSPS =  ABLXSPS0+DABXSPS;
LBXSPS =  LBSP*ABXSPS/(2*sin(ABXSPS/2)) ;%BXSPs path length (m)
BXSP1SA={'be' 'BXSP1S' LBXSPS/2 [-ABXSPS/2 GBSP/2 -ABXSPS/2 0 FBSP 0 0]}';
BXSP1SB={'be' 'BXSP1S' LBXSPS/2 [-ABXSPS/2 GBSP/2 0 -ABXSPS/2 0 FBSP 0]}';
BXSP2SA={'be' 'BXSP2S' LBXSPS/2 [-ABXSPS/2 GBSP/2 -ABXSPS/2 0 FBSP 0 0]}';
BXSP2SB={'be' 'BXSP2S' LBXSPS/2 [-ABXSPS/2 GBSP/2 0 -ABXSPS/2 0 FBSP 0]}';
BXSP3SA={'be' 'BXSP3S' LBXSPS/2 [ABXSPS/2 GBSP/2 ABXSPS/2 0 FBSP 0 0]}';
BXSP3SB={'be' 'BXSP3S' LBXSPS/2 [ABXSPS/2 GBSP/2 0 ABXSPS/2 0 FBSP 0]}';
% BSY dumpline vertical bends
ABYSPD =  0.877684127155E-2;
LBYSPD =  LBSP*ABYSPD/(2*sin(ABYSPD/2)) ;%BYSPd path length (m)
BYSP1DA={'be' 'BYSP1D' LBYSPD/2 [ABYSPD/2 GBSP/2 ABYSPD/2 0 FBSP 0 pi/2]}';
BYSP1DB={'be' 'BYSP1D' LBYSPD/2 [ABYSPD/2 GBSP/2 0 ABYSPD/2 0 FBSP pi/2]}';
BYSP2DA={'be' 'BYSP2D' LBYSPD/2 [-ABYSPD/2 GBSP/2 -ABYSPD/2 0 FBSP 0 pi/2]}';
BYSP2DB={'be' 'BYSP2D' LBYSPD/2 [-ABYSPD/2 GBSP/2 0 -ABYSPD/2 0 FBSP pi/2]}';
% HXR DC bend correctors to compensate kicker orbit and dispersion
LBCSP =  0.6    ;%DC corrector length
GBCSP =  0.0254 ;%DC corrector gap
FBCSP =  0.4725 ;%measured DC corrector FINT value
ABCSP1H =   0.445436076072E-2;
ABCSP2H =  -0.370437221909E-2;
LBCSP1H =  LBCSP*ABCSP1H/(2*sin(ABCSP1H/2)) ;%BYSP1h path length (m)
LBCSP2H =  LBCSP*ABCSP2H/(2*sin(ABCSP2H/2)) ;%BYSP2h path length (m)
BYSP1HA={'be' 'BYSP1H' LBCSP1H/2 [ABCSP1H/2 GBCSP/2 ABCSP1H/2 0 FBCSP 0 pi/2]}';
BYSP1HB={'be' 'BYSP1H' LBCSP1H/2 [ABCSP1H/2 GBCSP/2 0 ABCSP1H/2 0 FBCSP pi/2]}';
BYSP2HA={'be' 'BYSP2H' LBCSP2H/2 [ABCSP2H/2 GBCSP/2 ABCSP2H/2 0 FBCSP 0 pi/2]}';
BYSP2HB={'be' 'BYSP2H' LBCSP2H/2 [ABCSP2H/2 GBCSP/2 0 ABCSP2H/2 0 FBCSP pi/2]}';
% SXR DC bend correctors to compensate kicker orbit and dispersion
ABCSP1S =   0.315465742092E-2;
ABCSP2S =  -0.240470325405E-2;
LBCSP1S =  LBCSP*ABCSP1S/(2*sin(ABCSP1S/2)) ;%BYSP1s path length (m)
LBCSP2S =  LBCSP*ABCSP2S/(2*sin(ABCSP2S/2)) ;%BYSP2s path length (m)
BYSP1SA={'be' 'BYSP1S' LBCSP1S/2 [ABCSP1S/2 GBCSP/2 ABCSP1S/2 0 FBCSP 0 pi/2]}';
BYSP1SB={'be' 'BYSP1S' LBCSP1S/2 [ABCSP1S/2 GBCSP/2 0 ABCSP1S/2 0 FBCSP pi/2]}';
BYSP2SA={'be' 'BYSP2S' LBCSP2S/2 [ABCSP2S/2 GBCSP/2 ABCSP2S/2 0 FBCSP 0 pi/2]}';
BYSP2SB={'be' 'BYSP2S' LBCSP2S/2 [ABCSP2S/2 GBCSP/2 0 ABCSP2S/2 0 FBCSP pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKYSP0H={'be' 'BKYSP0H' LBKYSP0H [0 GBKYSP/2 0 0 0.5 0.5 pi/2]}';
BKYSP1H={'be' 'BKYSP1H' LBKYSP1H [ABKYSP1H GBKYSP/2 0 ABKYSP1H 0.5 0.5 pi/2]}';
BKYSP2H={'be' 'BKYSP2H' LBKYSP2H [ABKYSP2H GBKYSP/2 -ABKYSP1H ABKYSP12H 0.5 0.5 pi/2]}';
BKYSP3H={'be' 'BKYSP3H' LBKYSP3H [ABKYSP3H GBKYSP/2 -ABKYSP12H ABKYSPH 0.5 0.5 pi/2]}';
BKYSP4H={'be' 'BKYSP4H' LBKYSP4H [0 GBKYSP/2 -ABKYSPH ABKYSPH 0.5 0.5 pi/2]}';
BKYSP5H={'be' 'BKYSP5H' LBKYSP5H [0 GBKYSP5H/2 -ABKYSPH ABKYSPH 0.5 0.5 pi/2]}';
BLXSPH={'be' 'BLXSPH' LBLXSPH [ABLXSPH GBLXSP/2 0 ABLXSPH 0.5 0.5 0]}';
BYSP1H={'be' 'BYSP1H' LBCSP1H [ABCSP1H GBCSP/2 ABCSP1H/2 ABCSP1H/2 FBCSP FBCSP pi/2]}';
BYSP2H={'be' 'BYSP2H' LBCSP2H [ABCSP2H GBCSP/2 ABCSP2H/2 ABCSP2H/2 FBCSP FBCSP pi/2]}';
BRSP1H={'be' 'BRSP1H' LBRSPH [ABRSPH GBSP/2 ABRSPH/2 ABRSPH/2 FBSP FBSP TBRSPH]}';
BRSP2H={'be' 'BRSP2H' LBRSPH [-ABRSPH GBSP/2 -ABRSPH/2 -ABRSPH/2 FBSP FBSP TBRSPH]}';
BXSP1H={'be' 'BXSP1H' LBXSPH [ABXSPH GBSP/2 ABXSPH/2 ABXSPH/2 FBSP FBSP 0]}';
BKYSP0S={'be' 'BKYSP0S' LBKYSP0S [0 GBKYSP/2 0 0 0.5 0.5 pi/2]}';
BKYSP1S={'be' 'BKYSP1S' LBKYSP1S [ABKYSP1S GBKYSP/2 0 ABKYSP1S 0.5 0.5 pi/2]}';
BKYSP2S={'be' 'BKYSP2S' LBKYSP2S [ABKYSP2S GBKYSP/2 -ABKYSP1S ABKYSP12S 0.5 0.5 pi/2]}';
BKYSP3S={'be' 'BKYSP3S' LBKYSP3S [ABKYSP3S GBKYSP/2 -ABKYSP12S ABKYSPS 0.5 0.5 pi/2]}';
BKYSP4S={'be' 'BKYSP4S' LBKYSP4S [0 GBKYSP/2 -ABKYSPS ABKYSPS 0.5 0.5 pi/2]}';
BKYSP5S={'be' 'BKYSP5S' LBKYSP5S [0 GBKYSP5S/2 -ABKYSPS ABKYSPS 0.5 0.5 pi/2]}';
BLXSPS={'be' 'BLXSPS' LBLXSPS [ABLXSPS GBLXSP/2 0 ABLXSPS 0.5 0.5 0]}';
BYSP1S={'be' 'BYSP1S' LBCSP1S [ABCSP1S GBCSP/2 ABCSP1S/2 ABCSP1S/2 FBCSP FBCSP pi/2]}';
BYSP2S={'be' 'BYSP2S' LBCSP2S [ABCSP2S GBCSP/2 ABCSP2S/2 ABCSP2S/2 FBCSP FBCSP pi/2]}';
BXSP1S={'be' 'BXSP1S' LBXSPS [-ABXSPS GBSP/2 -ABXSPS/2 -ABXSPS/2 FBSP FBSP 0]}';
BXSP2S={'be' 'BXSP2S' LBXSPS [-ABXSPS GBSP/2 -ABXSPS/2 -ABXSPS/2 FBSP FBSP 0]}';
BXSP3S={'be' 'BXSP3S' LBXSPS [ABXSPS GBSP/2 ABXSPS/2 ABXSPS/2 FBSP FBSP 0]}';
BYSP1D={'be' 'BYSP1D' LBYSPD [ABYSPD GBSP/2 ABYSPD/2 ABYSPD/2 FBSP FBSP pi/2]}';
BYSP2D={'be' 'BYSP2D' LBYSPD [-ABYSPD GBSP/2 -ABYSPD/2 -ABYSPD/2 FBSP FBSP pi/2]}';
% drifts
LDSPCOR1 =  0.3617;
LDSPCOR2 =  0.5263;
LDSPBPM1 =  0.4471;
LDSPBPM2 =  0.5342;
LDSPBK =  0.3;
LDSPBK0H =  LDSPBK;
LDSPBK1H =  LDSPBK/cos(ABKYSP1H);
LDSPBK2H =  LDSPBK/cos(ABKYSP12H);
LDSPBK3H =  LDSPBK/cos(ABKYSPH);
LDSPBK4H =  LDSPBK/cos(ABKYSPH);
LDSPBK5H =  15.1  /cos(ABKYSPH);
LDSPBK5HA =   2.267/cos(ABKYSPH);
LDSPBK5HB =  LDSPBK5H-LDSPBK5HA;
DSPBK0H={'dr' '' LDSPBK0H []}';
DSPBK1H={'dr' '' LDSPBK1H []}';
DSPBK2H={'dr' '' LDSPBK2H []}';
DSPBK3H={'dr' '' LDSPBK3H []}';
DSPBK4H={'dr' '' LDSPBK4H []}';
DSPBK5HA={'dr' '' LDSPBK5HA []}';
DSPBK5HB={'dr' '' LDSPBK5HB []}';
DLDSP2H =  0.0;
LDSP2H =  43.284 +DLDSP2H;
LDSP2HB =  10.0;
LDSP2HC =  0.5285;
LDSP2HA =  LDSP2H-LDSP2HB-LDSP2HC-LBCSP1H-LBCSP2H;
DLDSP3H =  0.0;
LDSP3H =  4.6611 +DLDSP3H;
LDSP3HA =  LDSPBPM1;
LDSP3HAA =  0.1;
LDSP3HAB =  LDSP3HA-LDSP3HAA-LSB;
LDSP3HB =  0.6368;
LDSP3HD =  0.1924;
LDSP3HC =  LDSP3H-LDSP3HA-LDSP3HB-LDSP3HD;
DLDSP4H =  0.012085492416;
LDSP4H =  9.5126 -DLDSP2H-DLDSP3H+DLDSP4H;
LDSP4HA =  0.4;
LDSP4HC =  0.3459992;
LDSP4HB =  LDSP4H-LDSP4HA-LDSP4HC;
DLDSP5H =  0.0 ;%adjust position of QSP3h,QSP11h
LDSP5H =  14.474 +(LQN-LQA)/2 +DLDSP5H;
LDSP5HA =  1.424131;
LDSP5HC =  LDSPCOR2 +(LQN-LQA)/2;
LDSP5HCB =  0.1 +(LQN-LQA)/2;
LDSP5HCA =  LDSP5HC-LDSP5HCB-LSB;
LDSP5HB =  LDSP5H-LDSP5HA-LDSP5HC;
DLDSP6H =  0.0 ;%adjust position of QSP4h,QSP10h
LDSP6H =  8.6805 +(LQN-LQA)/2 -DLDSP5H+DLDSP6H ;
LDSP6HA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP6HC =  LDSPCOR1;
LDSP6HB =  LDSP6H-LDSP6HA-LDSP6HC;
DLDSP7H =  0.0 ;%adjust position of QSP5h,QSP9h
LDSP7H =  21.795894248291 -DLDSP6H+DLDSP7H;
LDSP7HA =  LDSPBPM1;
LDSP7HC =  LDSPCOR1;
LDSP7HB =  LDSP7H-LDSP7HA-LDSP7HC;
LDSP8H =  23.795894248291 -DLDSP7H;
LDSP8HA =  LDSPBPM1;
LDSP8HC =  LDSPCOR1;
LDSP8HB =  LDSP8H-LDSP8HA-LDSP8HC;
DLDSP9H =  0.0 ;%adjust length of dogleg
LDSP9H =  188.409365489746/2-3*LQR-LQA-LQE/2-LDSP5H-LDSP6H-LDSP7H-LDSP8H +DLDSP9H;
LDSP9HA =  LDSPBPM1;
LDSP9HB =  0.5;
LDSP9HC =  5.7942;
LDSP9HD =  10.6452;
LDSP9HE =  1.616;
LDSP9HG =  0.1924;
LDSP9HF =  LDSP9H-LDSP9HA-LDSP9HB-LDSP9HC-LDSP9HD-LDSP9HE-LDSP9HG;
LDSP10H =  LDSP9H;
LDSP10HA =  0.4;
LDSP10HB =  17.6279586;
LDSP10HD =  LDSPCOR1;
LDSP10HC =  LDSP10H-LDSP10HA-LDSP10HB-LDSP10HD;
LDSP11H =  LDSP8H;
LDSP11HA =  LDSPBPM1;
LDSP11HC =  0.4781;
LDSP11HB =  LDSP11H-LDSP11HA-LDSP11HC;
LDSP12H =  LDSP7H;
LDSP12HA =  0.4475;
LDSP12HB =  0.644;
LDSP12HD =  0.759;
LDSP12HE =  0.3315;
LDSP12HC =  LDSP12H-LDSP12HA-LDSP12HB-LDSP12HD-LDSP12HE;
LDSP13H =  LDSP6H;
LDSP13HB =  0.778;
LDSP13HC =  0.749 +(LQN-LQA)/2;
LDSP13HA =  LDSP13H-LDSP13HB-LDSP13HC;
LDSP14H =  LDSP5H;
LDSP14HA =  13.863119 +(LQN-LQA)/2;
LDSP14HB =  LDSP14H-LDSP14HA;
LDSP15H =  LDSP4H;
LDSP15HA =  0.5;
LDSP15HB =  0.5;
LDSP15HD =  0.1924;
LDSP15HC =  LDSP15H-LDSP15HA-LDSP15HB-LDSP15HD;
LDSP16H =  LDSP3H;
LDSP16HA =  0.4;
LDSP16HC =  LDSPCOR1;
LDSP16HB =  LDSP16H-LDSP16HA-LDSP16HC;
DLDSP17H =  -0.801500183647E-4;
LDSP17H =  LDSP2H +DLDSP17H +LBLXSPH/2-LBXSPH/2;
LDSP17HA =  LDSPBPM1;
LDSP17HB =  LDSP17H-LDSP17HA;
DSP2HA={'dr' '' LDSP2HA []}';
DSP2HB={'dr' '' LDSP2HB []}';
DSP2HC={'dr' '' LDSP2HC []}';
DSP3HA={'dr' '' LDSP3HA []}';
DSP3HAA={'dr' '' LDSP3HAA []}';
DSP3HAB={'dr' '' LDSP3HAB []}';
DSP3HB={'dr' '' LDSP3HB []}';
DSP3HC={'dr' '' LDSP3HC []}';
DSP3HD={'dr' '' LDSP3HD []}';
DSP4HA={'dr' '' LDSP4HA []}';
DSP4HB={'dr' '' LDSP4HB []}';
DSP4HC={'dr' '' LDSP4HC []}';
DSP5H={'dr' '' LDSP5H []}';
DSP5HA={'dr' '' LDSP5HA []}';
DSP5HB={'dr' '' LDSP5HB []}';
DSP5HC={'dr' '' LDSP5HC []}';
DSP5HCA={'dr' '' LDSP5HCA []}';
DSP5HCB={'dr' '' LDSP5HCB []}';
DSP6HA={'dr' '' LDSP6HA []}';
DSP6HB={'dr' '' LDSP6HB []}';
DSP6HC={'dr' '' LDSP6HC []}';
DSP7HA={'dr' '' LDSP7HA []}';
DSP7HB={'dr' '' LDSP7HB []}';
DSP7HC={'dr' '' LDSP7HC []}';
DSP8HA={'dr' '' LDSP8HA []}';
DSP8HB={'dr' '' LDSP8HB []}';
DSP8HC={'dr' '' LDSP8HC []}';
DSP9HA={'dr' '' LDSP9HA []}';
DSP9HB={'dr' '' LDSP9HB []}';
DSP9HC={'dr' '' LDSP9HC []}';
DSP9HD={'dr' '' LDSP9HD []}';
DSP9HE={'dr' '' LDSP9HE []}';
DSP9HF={'dr' '' LDSP9HF []}';
DSP9HG={'dr' '' LDSP9HG []}';
DSP10HA={'dr' '' LDSP10HA []}';
DSP10HB={'dr' '' LDSP10HB []}';
DSP10HC={'dr' '' LDSP10HC []}';
DSP10HD={'dr' '' LDSP10HD []}';
DSP11HA={'dr' '' LDSP11HA []}';
DSP11HB={'dr' '' LDSP11HB []}';
DSP11HC={'dr' '' LDSP11HC []}';
DSP12HA={'dr' '' LDSP12HA []}';
DSP12HB={'dr' '' LDSP12HB []}';
DSP12HC={'dr' '' LDSP12HC []}';
DSP12HC1={'dr' '' 9.035399208502 []}';
DSP12HC2={'dr' '' 0.30541 []}';
DSP12HC3={'dr' '' DSP12HC{3}-DSP12HC1{3}-DSP12HC2{3} []}';
DSP12HD={'dr' '' LDSP12HD []}';
DSP12HE={'dr' '' LDSP12HE []}';
DSP13HA={'dr' '' LDSP13HA []}';
DSP13HB={'dr' '' LDSP13HB []}';
DSP13HC={'dr' '' LDSP13HC []}';
DSP14HA={'dr' '' LDSP14HA []}';
DSP14HB={'dr' '' LDSP14HB []}';
DSP15H={'dr' '' LDSP15H []}';
DSP15HA={'dr' '' LDSP15HA []}';
DSP15HB={'dr' '' LDSP15HB []}';
DSP15HC={'dr' '' LDSP15HC []}';
DSP15HD={'dr' '' LDSP15HD []}';
DSP16HA={'dr' '' LDSP16HA []}';
DSP16HB={'dr' '' LDSP16HB []}';
DSP16HC={'dr' '' LDSP16HC []}';
DSP17HA={'dr' '' LDSP17HA []}';
DSP17HB={'dr' '' LDSP17HB []}';
LDSPQ1 =  45.126;
LDSPQ1A =  23.0;
LDSPQ1C =  LDSPCOR1;
LDSPQ1B =  LDSPQ1-LDSPQ1A-LDSPQ1C;
DLDSPQ2 =  0.0;
LDSPQ2 =  1.8 +DLDSPQ2;
LDSPQ2A =  0.5913;
LDSPQ2C =  0.4781;
LDSPQ2B =  LDSPQ2-LDSPQ2A-LDSPQ2C;
LDSPQ3 =  16.124 -DLDSPQ2 ;
LDSPQ3A =  0.4285;
LDSPQ3B =  LDSPQ3-LDSPQ3A;
DSPQ1A={'dr' '' LDSPQ1A []}';
DSPQ1B={'dr' '' LDSPQ1B []}';
DSPQ1C={'dr' '' LDSPQ1C []}';
DSPQ2A={'dr' '' LDSPQ2A []}';
DSPQ2B={'dr' '' LDSPQ2B []}';
DSPQ2C={'dr' '' LDSPQ2C []}';
DSPQ3A={'dr' '' LDSPQ3A []}';
DSPQ3B={'dr' '' LDSPQ3B []}';
LDSPBK0S =  LDSPBK;
LDSPBK1S =  LDSPBK/cos(ABKYSP1S);
LDSPBK2S =  LDSPBK/cos(ABKYSP12S);
LDSPBK3S =  LDSPBK/cos(ABKYSPS);
LDSPBK4S =  LDSPBK/cos(ABKYSPS);
LDSPBK5S =  15.1  /cos(ABKYSPS);
LDSPBK5SA =   2.267/cos(ABKYSPS);
LDSPBK5SB =  LDSPBK5S-LDSPBK5SA;
DSPBK0S={'dr' '' LDSPBK0S []}';
DSPBK1S={'dr' '' LDSPBK1S []}';
DSPBK2S={'dr' '' LDSPBK2S []}';
DSPBK3S={'dr' '' LDSPBK3S []}';
DSPBK4S={'dr' '' LDSPBK4S []}';
DSPBK5SA={'dr' '' LDSPBK5SA []}';
DSPBK5SB={'dr' '' LDSPBK5SB []}';
DLDSP2S =  0.0;
DLDSP2SA =  -0.781886051378E-6;
LDSP2S =  32.6265 +(LQN-LQA)/2 +DLDSP2S +DLDSP2SA;
LDSP2SB =  11.8;
LDSP2SC =  0.6676 +(LQN-LQA)/2;
LDSP2SA =  LDSP2S-LDSP2SB-LDSP2SC-LBCSP1S-LBCSP2S;
DLDSP3S =  0.0;
LDSP3S =  1.828 +(LQN-LQA) +DLDSP3S;
LDSP3SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP3SAA =  0.1 +(LQN-LQA)/2;
LDSP3SAB =  LDSP3SA-LDSP3SAA-LSB;
LDSP3SB =  0.6445;
LDSP3SC =  LDSP3S-LDSP3SA-LDSP3SB;
LDSP4S =  8.689 +(LQN-LQA)/2 -DLDSP2S -DLDSP3S;
LDSP4SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP4SB =  0.6445;
LDSP4SD =  0.3442954;
LDSP4SC =  LDSP4S-LDSP4SA-LDSP4SB-LDSP4SD;
DLDSP5S =  0.0;
LDSP5S =  6.512 +(LQN-LQA)/2 +DLDSP5S;
LDSP5SB =  LDSPCOR2 +(LQN-LQA)/2;
LDSP5SA =  LDSP5S-LDSP5SB;
DLDSP6S =  0.0;
LDSP6S =  2.5925 +(LQN-LQA)/2 +DLDSP6S;
LDSP6SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP6SC =  LDSPCOR1;
LDSP6SB =  LDSP6S-LDSP6SA-LDSP6SC;
LDSP7S =  56.746/2-LQA-1.5*LQR-LDSP5S-LDSP6S;
LDSP7SA =  LDSPBPM1;
LDSP7SB =  1.2814;
LDSP7SD =  LDSPCOR1;
LDSP7SC =  LDSP7S-LDSP7SA-LDSP7SB-LDSP7SD;
LDSP8S =  LDSP7S;
LDSP8SA =  LDSPBPM1;
LDSP8SB =  1.9614;
LDSP8SC =  7.810257;
LDSP8SE =  LDSPCOR1;
LDSP8SD =  LDSP8S-LDSP8SA-LDSP8SB-LDSP8SC-LDSP8SE;
LDSP9S =  LDSP6S;
LDSP9SA =  LDSPBPM1;
LDSP9SC =  LDSPCOR2 +(LQN-LQA)/2;
LDSP9SB =  LDSP9S-LDSP9SA-LDSP9SC;
LDSP10S =  LDSP5S;
LDSP10SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP10SB =  LDSP10S-LDSP10SA;
LDSP11S =  LDSP4S;
LDSP11SA =  0.5;
LDSP11SB =  0.5;
LDSP11SC =  0.5;
LDSP11SE =  LDSPCOR2 +(LQN-LQA)/2;
LDSP11SD =  LDSP11S-LDSP11SA-LDSP11SB-LDSP11SC-LDSP11SE;
LDSP12S =  LDSP3S;
LDSP12SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP12SC =  LDSPCOR2 +(LQN-LQA)/2;
LDSP12SCB =  0.1 +(LQN-LQA)/2;
LDSP12SCA =  LDSP12SC-LDSP12SCB-LSB;
LDSP12SB =  LDSP12S-LDSP12SA-LDSP12SC;
DLDSP13S =  -0.406195675138E-4;
LDSP13S =  LDSP2S +DLDSP13S +LBLXSPS/2-LBXSPS/2;
LDSP13SA =  LDSPBPM2 +(LQN-LQA)/2;
LDSP13SB =  LDSP13S-LDSP13SA;
DSP2SA={'dr' '' LDSP2SA []}';
DSP2SB={'dr' '' LDSP2SB []}';
DSP2SC={'dr' '' LDSP2SC []}';
DSP3SA={'dr' '' LDSP3SA []}';
DSP3SAA={'dr' '' LDSP3SAA []}';
DSP3SAB={'dr' '' LDSP3SAB []}';
DSP3SB={'dr' '' LDSP3SB []}';
DSP3SC={'dr' '' LDSP3SC []}';
DSP4SA={'dr' '' LDSP4SA []}';
DSP4SB={'dr' '' LDSP4SB []}';
DSP4SC={'dr' '' LDSP4SC []}';
DSP4SD={'dr' '' LDSP4SD []}';
DSP5SA={'dr' '' LDSP5SA []}';
DSP5SB={'dr' '' LDSP5SB []}';
DSP6SA={'dr' '' LDSP6SA []}';
DSP6SB={'dr' '' LDSP6SB []}';
DSP6SC={'dr' '' LDSP6SC []}';
DSP7SA={'dr' '' LDSP7SA []}';
DSP7SB={'dr' '' LDSP7SB []}';
DSP7SC={'dr' '' LDSP7SC []}';
DSP7SD={'dr' '' LDSP7SD []}';
DSP8SA={'dr' '' LDSP8SA []}';
DSP8SB={'dr' '' LDSP8SB []}';
DSP8SC={'dr' '' LDSP8SC []}';
DSP8SD={'dr' '' LDSP8SD []}';
DSP8SE={'dr' '' LDSP8SE []}';
DSP9SA={'dr' '' LDSP9SA []}';
DSP9SB={'dr' '' LDSP9SB []}';
DSP9SC={'dr' '' LDSP9SC []}';
DSP10SA={'dr' '' LDSP10SA []}';
DSP10SB={'dr' '' LDSP10SB []}';
DSP11SA={'dr' '' LDSP11SA []}';
DSP11SB={'dr' '' LDSP11SB []}';
DSP11SC={'dr' '' LDSP11SC []}';
DSP11SD={'dr' '' LDSP11SD []}';
DSP11SE={'dr' '' LDSP11SE []}';
DSP12SA={'dr' '' LDSP12SA []}';
DSP12SB={'dr' '' LDSP12SB []}';
DSP12SC={'dr' '' LDSP12SC []}';
DSP12SCA={'dr' '' LDSP12SCA []}';
DSP12SCB={'dr' '' LDSP12SCB []}';
DSP13SA={'dr' '' LDSP13SA []}';
DSP13SB={'dr' '' LDSP13SB []}';
DSP13SB1={'dr' '' 9.337992506693 []}';
DSP13SB2={'dr' '' 0.30541 []}';
DSP13SB3={'dr' '' DSP13SB{3}-DSP13SB1{3}-DSP13SB2{3} []}';
LDSP2DA2 =  2.0;
LDSP2DA1 =  23.0-4.457-LDSP2DA2 ;%adjusted for DASEL
LDSP2DB =  1.657;
LDSP2DC1 =  27.25 +3.685 ;%adjustment for DASEL with 25G kickers
LDSP2DD =  LDSPCOR1;
DLDSP3D =  0.0;
LDSP3D =  3.317 +DLDSP3D;
LDSP3DA =  LDSPBPM1;
LDSP3DB =  0.6234;
LDSP3DD =  0.4781+0.3048 ;%=0.7829
LDSP3DC =  LDSP3D-LDSP3DA-LDSP3DB-LDSP3DD;
LDSP4D =  4.5085 -DLDSP3D;
LDSP4DA =  0.4285;
LDSP4DB =  LDSP4D-LDSP4DA;
LDSP2DC2 =  76.149-LDSP2DA1-LDSP2DA2-LDSP2DB-LDSP2DC1-LDSP2DD-LDSP3D-LDSP4D;
LDSP5D =  73.0 ;%distance between two bends
LDSP5DA =  6.2732486;
LDSP5DB =  45.575+1.0-LDSP5DA-LBYSPD/2;
LDSP5DD =  0.2298134+0.609623481 ;%=0.839436881
LDSP5DC =  LDSP5D-LDSP5DA-LDSP5DB-LDSP5DD;
DLDSP6D =  0.0 ;%adjust Z at muon wall
LDSP6D =  143.648999999997-0.4 +18.115253 -0.761425 +DLDSP6D;
LDSP6DA =  0.5;
LDSP6DB =  0.5;
LDSP6DC =  1.0;
LDSP6DD =  0.3048;
LDSP6DE =  1.1952;
LDSP6DG =  0.5;
LDSP6DH =  0.5;
LDSP6DI =  0.5;
LDSP6DJ =  37.0 +18.0 -0.761425;
LDSP6DF =  LDSP6D-LDSP6DA-LDSP6DB-LDSP6DC-LDSP6DD-LDSP6DE-LDSP6DG-LDSP6DH -LDSP6DI-LDSP6DJ;
LDSP6DFA =  4.287828;
LDSP6DFC =  0.5;
LDSP6DFD =  1.0;
LDSP6DFB =  LDSP6DF-LDSP6DFA-LDSP6DFC-LDSP6DFD;
LDSP7D =  20.0818610101+0.4+0.803391932471 -18.115253 +0.761425;
LDSP7DB =  1.5;
LDSP7DA =  LDSP7D-LDSP7DB;
LDSP7DAA =  0.5;
LDSP7DAB =  LDSP7DA-LDSP7DAA;
DSP2DA1={'dr' '' LDSP2DA1 []}';
DSP2DA2={'dr' '' LDSP2DA2 []}';
DSP2DB={'dr' '' LDSP2DB []}';
DSP2DC1={'dr' '' LDSP2DC1 []}';
DSP2DC2={'dr' '' LDSP2DC2 []}';
DSP2DD={'dr' '' LDSP2DD []}';
DSP3DA={'dr' '' LDSP3DA []}';
DSP3DB={'dr' '' LDSP3DB []}';
DSP3DC={'dr' '' LDSP3DC []}';
DSP3DD={'dr' '' LDSP3DD []}';
DSP4DA={'dr' '' LDSP4DA []}';
DSP4DB={'dr' '' LDSP4DB []}';
DSP5DA={'dr' '' LDSP5DA []}';
DSP5DB={'dr' '' LDSP5DB []}';
DSP5DC={'dr' '' LDSP5DC []}';
DSP5DC1={'dr' '' 0.694411378263 []}';
DSP5DC2={'dr' '' 0.30541 []}';
DSP5DC3={'dr' '' DSP5DC{3}-DSP5DC1{3}-DSP5DC2{3} []}';
DSP5DD={'dr' '' LDSP5DD []}';
DSP6DA={'dr' '' LDSP6DA []}';
DSP6DB={'dr' '' LDSP6DB []}';
DSP6DC={'dr' '' LDSP6DC []}';
DSP6DD={'dr' '' LDSP6DD []}';
DSP6DE={'dr' '' LDSP6DE []}';
DSP6DF={'dr' '' LDSP6DF []}';
DSP6DFA={'dr' '' LDSP6DFA []}';
DSP6DFB={'dr' '' LDSP6DFB []}';
DSP6DFC={'dr' '' LDSP6DFC []}';
DSP6DFD={'dr' '' LDSP6DFD []}';
DSP6DG={'dr' '' LDSP6DG []}';
DSP6DH={'dr' '' LDSP6DH []}';
DSP6DI={'dr' '' LDSP6DI []}';
DSP6DJ={'dr' '' LDSP6DJ []}';
DSP7DAA={'dr' '' LDSP7DAA []}';
DSP7DAB={'dr' '' LDSP7DAB []}';
DSP7DB={'dr' '' LDSP7DB []}';
DWALLAD={'dr' '' 1.840975 []}';%distance from face of muon wall to BSY dump
DDUMPBSY={'dr' '' 61.120*IN2M []}';%length of BSY dump (per A. Ibrahimov)
% markers
CNTSP1S={'mo' 'CNTSP1S' 0 []}';
CNTSP2S={'mo' 'CNTSP2S' 0 []}';
CNTSP1H={'mo' 'CNTSP1H' 0 []}';
CNTSP2H={'mo' 'CNTSP2H' 0 []}';
CNTSP3H={'mo' 'CNTSP3H' 0 []}';
CNTSP1D={'mo' 'CNTSP1D' 0 []}';
RWWAKE3D={'mo' 'RWWAKE3D' 0 []}';%SPRDD/BSY beampipe wake applied here
MUWALLD={'mo' 'MUWALLD' 0 []}';%front face of muon wall for dump beam
DUMPBSY={'mo' 'DUMPBSY' 0 []}';%front face of BSY dump
% monitors
BPMSPH={'mo' 'BPMSPH' 0 []}';
BPMSPS={'mo' 'BPMSPS' 0 []}';
BPMSP1={'mo' 'BPMSP1' 0 []}';
BPMSP2={'mo' 'BPMSP2' 0 []}';
BPMSP1H={'mo' 'BPMSP1H' 0 []}';
BPMSP2H={'mo' 'BPMSP2H' 0 []}';
BPMSP3H={'mo' 'BPMSP3H' 0 []}';
BPMSP4H={'mo' 'BPMSP4H' 0 []}';
BPMSP5H={'mo' 'BPMSP5H' 0 []}';
BPMSP6H={'mo' 'BPMSP6H' 0 []}';
BPMSP7H={'mo' 'BPMSP7H' 0 []}';
BPMSP8H={'mo' 'BPMSP8H' 0 []}';
BPMSP9H={'mo' 'BPMSP9H' 0 []}';
BPMSP10H={'mo' 'BPMSP10H' 0 []}';
BPMSP11H={'mo' 'BPMSP11H' 0 []}';
BPMSP12H={'mo' 'BPMSP12H' 0 []}';
BPMSP13H={'mo' 'BPMSP13H' 0 []}';
BPMSP1S={'mo' 'BPMSP1S' 0 []}';
BPMSP2S={'mo' 'BPMSP2S' 0 []}';
BPMSP3S={'mo' 'BPMSP3S' 0 []}';
BPMSP4S={'mo' 'BPMSP4S' 0 []}';
BPMSP5S={'mo' 'BPMSP5S' 0 []}';
BPMSP6S={'mo' 'BPMSP6S' 0 []}';
BPMSP7S={'mo' 'BPMSP7S' 0 []}';
BPMSP8S={'mo' 'BPMSP8S' 0 []}';
BPMSP9S={'mo' 'BPMSP9S' 0 []}';
BPMSP1D={'mo' 'BPMSP1D' 0 []}';
BPMSP2D={'mo' 'BPMSP2D' 0 []}';
BPMSP3D={'mo' 'BPMSP3D' 0 []}';%has been already ordered
BPMSP4D={'mo' 'BPMSP4D' 0 []}';
BPMSP5D={'mo' 'BPMSP5D' 0 []}';%large aperture BPM for raster
MRFBSP1D={'mo' 'MRFBSP1D' 0 []}';%MONI, TYPE="CavityS-1" make RF-bpm if spreader is RF
MRFBSP2D={'mo' 'MRFBSP2D' 0 []}';%MONI, TYPE="CavityS-1" make RF-bpm if spreader is RF
% steering correctors
XCSP1H={'mo' 'XCSP1H' 0 []}';
XCSP3H={'mo' 'XCSP3H' 0 []}';
XCSP5H={'mo' 'XCSP5H' 0 []}';
XCSP7H={'mo' 'XCSP7H' 0 []}';
XCSP9H={'mo' 'XCSP9H' 0 []}';
XCSP11H={'mo' 'XCSP11H' 0 []}';
XCSP13H={'mo' 'XCSP13H' 0 []}';
YCSP2H={'mo' 'YCSP2H' 0 []}';
YCSP4H={'mo' 'YCSP4H' 0 []}';
YCSP6H={'mo' 'YCSP6H' 0 []}';
YCSP8H={'mo' 'YCSP8H' 0 []}';
YCSP10H={'mo' 'YCSP10H' 0 []}';
YCSP12H={'mo' 'YCSP12H' 0 []}';
XCSP1={'mo' 'XCSP1' 0 []}';
YCSP2={'mo' 'YCSP2' 0 []}';
XCSP1S={'mo' 'XCSP1S' 0 []}';
XCSP3S={'mo' 'XCSP3S' 0 []}';
XCSP5S={'mo' 'XCSP5S' 0 []}';
XCSP7S={'mo' 'XCSP7S' 0 []}';
XCSP9S={'mo' 'XCSP9S' 0 []}';
YCSP2S={'mo' 'YCSP2S' 0 []}';
YCSP4S={'mo' 'YCSP4S' 0 []}';
YCSP6S={'mo' 'YCSP6S' 0 []}';
YCSP8S={'mo' 'YCSP8S' 0 []}';
XCSP1D={'mo' 'XCSP1D' 0 []}';
XCSP3D={'mo' 'XCSP3D' 0 []}';
XCSP5D={'mo' 'XCSP5D' 0 []}';
YCSP2D={'mo' 'YCSP2D' 0 []}';
YCSP4D={'mo' 'YCSP4D' 0 []}';
YCSP6D={'mo' 'YCSP6D' 0 []}';
% rastering kickers operating at ~60 Hz with 90 deg phase between each other
BKXRASD={'mo' 'BKXRASD' 0 []}';
BKYRASD={'mo' 'BKYRASD' 0 []}';
% SROT to remove rotation angle
AROSP1H =   0.414577244197E-5;
AROSP2H =   0.947723870567E-5;
AROSP3H =  -AROSP2H;
AROSP1S =  -0.829141820709E-5;
ROSP1H={'ro' 'ROSP1H' 0 [-(AROSP1H)]}';
ROSP2H={'ro' 'ROSP2H' 0 [-(AROSP2H)]}';
ROSP3H={'ro' 'ROSP3H' 0 [-(AROSP3H)]}';
ROSP1S={'ro' 'ROSP1S' 0 [-(AROSP1S)]}';
% other diagnostic
IMSP0H={'mo' 'IMSP0H' 0 []}';%diagnostic ACM in SPH
IMSP0S={'mo' 'IMSP0S' 0 []}';%diagnostic ACM in SPS
IMSP0D={'mo' 'IMSP0D' 0 []}';%diagnostic ACM in SPD
IMBCSH1={'mo' 'IMBCSH1' 0 []}';%BCS ACM doublet in SPH
IMBCSH2={'mo' 'IMBCSH2' 0 []}';%BCS ACM doublet in SPH
IMBCSS1={'mo' 'IMBCSS1' 0 []}';%BCS ACM doublet in SPS
IMBCSS2={'mo' 'IMBCSS2' 0 []}';%BCS ACM doublet in SPS
IMBCSD1={'mo' 'IMBCSD1' 0 []}';%BCS ACM doublet in SPD
IMBCSD2={'mo' 'IMBCSD2' 0 []}';%BCS ACM doublet in SPD
BTMSPDMP={'mo' 'BTMSPDMP' 0 []}';%Burn-Through-Monitor behind BSY dump
WSSP1D={'mo' 'WSSP1D' 0 []}';%to measure beam size and energy before BSY dump
OTRSPDMP={'mo' 'OTRSPDMP' 0 []}';%OTR screen before BSY dump
% beamlines
BKYSP0H_FULL=[BKYSP0HA,BKYSP0HB];
BKYSP1H_FULL=[BKYSP1HA,BKYSP1HB];
BKYSP2H_FULL=[BKYSP2HA,BKYSP2HB];
BKYSP3H_FULL=[BKYSP3HA,BKYSP3HB];
BKYSP4H_FULL=[BKYSP4HA,BKYSP4HB];
BKYSP5H_FULL=[BKYSP5HA,BKYSP5HB];
BLXSPH_FULL=[BLXSPHA,BLXSPHB];
SPRDKH=[BKYSP0H_FULL,DSPBK0H,BKYSP1H_FULL,DSPBK1H,BKYSP2H_FULL,DSPBK2H,BKYSP3H_FULL,DSPBK3H,BKYSP4H_FULL,DSPBK4H,BKYSP5H_FULL,DSPBK5HA,BPMSPH,DSPBK5HB,BLXSPH_FULL];
QSP1_FULL=[QSP1,QSP1];
QSP2_FULL=[QSP2,QSP2];
SPRDKSA=[DSPQ1A,BPMSP1,DSPQ1B,DSPQ1C,QSP1_FULL,DSPQ2A,XCSP1,DSPQ2B,BPMSP2,DSPQ2C,QSP2_FULL,DSPQ3A,YCSP2,DSPQ3B];
BKYSP0S_FULL=[BKYSP0SA,BKYSP0SB];
BKYSP1S_FULL=[BKYSP1SA,BKYSP1SB];
BKYSP2S_FULL=[BKYSP2SA,BKYSP2SB];
BKYSP3S_FULL=[BKYSP3SA,BKYSP3SB];
BKYSP4S_FULL=[BKYSP4SA,BKYSP4SB];
BKYSP5S_FULL=[BKYSP5SA,BKYSP5SB];
BLXSPS_FULL=[BLXSPSA,BLXSPSB];
SPRDKSB=[BKYSP0S_FULL,DSPBK0S,BKYSP1S_FULL,DSPBK1S,BKYSP2S_FULL,DSPBK2S,BKYSP3S_FULL,DSPBK3S,BKYSP4S_FULL,DSPBK4S,BKYSP5S_FULL,DSPBK5SA,BPMSPS,DSPBK5SB,BLXSPS_FULL];
SPRDKS=[SPRDKSA,SPRDKSB];
BYSP1H_FULL=[BYSP1HA,BYSP1HB];
BYSP2H_FULL=[BYSP2HA,BYSP2HB];
BRSP1H_FULL=[BRSP1HA,BRSP1HB];
QSP1H_FULL=[QSP1H,QSP1H];
QSP2H_FULL=[QSP2H,BPMSP2H,QSP2H];
QSP3H_FULL=[QSP3H,QSP3H];
QSP4H_FULL=[QSP4H,QSP4H];
QSP5H_FULL=[QSP5H,QSP5H];
QSP6H_FULL=[QSP6H,QSP6H];
QSP7H_FULL=[QSP7H,BPMSP7H,QSP7H];
QSP8H_FULL=[QSP8H,QSP8H];
QSP9H_FULL=[QSP9H,QSP9H];
QSP10H_FULL=[QSP10H,QSP10H];
QSP11H_FULL=[QSP11H,QSP11H];
SSP1H_FULL=[SSP1H,SSP1H];
SSP2H_FULL=[SSP2H,SSP2H];
SPRDHA=[ROSP1H,DSP2HA,BYSP1H_FULL,DSP2HB,BYSP2H_FULL,CNTSP1H,DSP2HC,QSP1H_FULL,DSP3HAA,SSP1H_FULL,DSP3HAB,BPMSP1H,DSP3HB,XCSP1H,DSP3HC,DSP3HD,QSP2H_FULL,DSP4HA,YCSP2H,DSP4HB,IMSP0H,DSP4HC,BRSP1H_FULL,ROSP2H,DSP5HA,DSP5HB,XCSP3H,DSP5HCA,SSP2H_FULL,DSP5HCB,QSP3H_FULL,DSP6HA,BPMSP3H,DSP6HB,YCSP4H,DSP6HC,QSP4H_FULL,DSP7HA,BPMSP4H,DSP7HB,XCSP5H,DSP7HC,QSP5H_FULL,DSP8HA,BPMSP5H,DSP8HB,YCSP6H,DSP8HC,QSP6H_FULL,DSP9HA,BPMSP6H,DSP9HB,DSP9HC,DSP9HD,DSP9HE,DSP9HF,DSP9HG,QSP7H_FULL,DSP10HA,XCSP7H,DSP10HB,DSP10HC,YCSP8H,DSP10HD,QSP8H_FULL,DSP11HA,BPMSP8H,DSP11HB,DSP11HC,QSP9H_FULL,DSP12HA,BPMSP9H,DSP12HB,XCSP9H,DSP12HC1,IMBCSH1,DSP12HC2,IMBCSH2,DSP12HC3,BPMSP10H,DSP12HD,YCSP10H,DSP12HE,QSP10H_FULL,DSP13HA,XCSP11H,DSP13HB,BPMSP11H,DSP13HC,QSP11H_FULL,DSP14HA,WOODDOOR];
BRSP2H_FULL=[BRSP2HA,BRSP2HB];
BXSP1H_FULL=[BXSP1HA,BXSP1HB];
QSP12H_FULL=[QSP12H,BPMSP12H,QSP12H];
QSP13H_FULL=[QSP13H,QSP13H];
SPRDHB=[DSP14HB,ROSP3H,BRSP2H_FULL,CNTSP2H,DSP15HA,DSP15HB,DSP15HC,DSP15HD,QSP12H_FULL,DSP16HA,YCSP12H,DSP16HB,XCSP13H,DSP16HC,QSP13H_FULL,DSP17HA,BPMSP13H,DSP17HB,BXSP1H_FULL,CNTSP3H];
SPRDH=[SPRDKH,SPRDHA,SPRDHB];
SPRDSA=[SPRDKH,SPRDKS];
BYSP1S_FULL=[BYSP1SA,BYSP1SB];
BYSP2S_FULL=[BYSP2SA,BYSP2SB];
BXSP1S_FULL=[BXSP1SA,BXSP1SB];
BXSP2S_FULL=[BXSP2SA,BXSP2SB];
BXSP3S_FULL=[BXSP3SA,BXSP3SB];
QSP1S_FULL=[QSP1S,QSP1S];
QSP2S_FULL=[QSP2S,QSP2S];
QSP3S_FULL=[QSP3S,QSP3S];
QSP4S_FULL=[QSP4S,QSP4S];
QSP5S_FULL=[QSP5S,QSP5S];
QSP6S_FULL=[QSP6S,QSP6S];
QSP7S_FULL=[QSP7S,QSP7S];
QSP8S_FULL=[QSP8S,QSP8S];
QSP9S_FULL=[QSP9S,QSP9S];
SSP1S_FULL=[SSP1S,SSP1S];
SSP2S_FULL=[SSP2S,SSP2S];
SPRDSB=[ROSP1S,DSP2SA,BYSP1S_FULL,DSP2SB,BYSP2S_FULL,CNTSP1S,DSP2SC,QSP1S_FULL,DSP3SAA,SSP1S_FULL,DSP3SAB,BPMSP1S,DSP3SB,XCSP1S,DSP3SC,QSP2S_FULL,DSP4SA,BPMSP2S,DSP4SB,YCSP2S,DSP4SC,IMSP0S,DSP4SD,BXSP1S_FULL,DSP5SA,XCSP3S,DSP5SB,QSP3S_FULL,DSP6SA,BPMSP3S,DSP6SB,YCSP4S,DSP6SC,QSP4S_FULL,DSP7SA,BPMSP4S,DSP7SB,DSP7SC,XCSP5S,DSP7SD,QSP5S_FULL,DSP8SA,BPMSP5S,DSP8SB,DSP8SC,DSP8SD,YCSP6S,DSP8SE,QSP6S_FULL,DSP9SA,BPMSP6S,DSP9SB,XCSP7S,DSP9SC,QSP7S_FULL,DSP10SA,BPMSP7S,DSP10SB,BXSP2S_FULL,DSP11SA,DSP11SB,DSP11SC,DSP11SD,YCSP8S,DSP11SE,QSP8S_FULL,DSP12SA,BPMSP8S,DSP12SB,XCSP9S,DSP12SCA,SSP2S_FULL,DSP12SCB,QSP9S_FULL,DSP13SA,BPMSP9S,DSP13SB1,IMBCSS1,DSP13SB2,IMBCSS2,DSP13SB3,BXSP3S_FULL,CNTSP2S];
SPRDS=[SPRDSA,SPRDSB];
SPRDDA=[DSP2DA1,MRFBSP1D,DSP2DA2,BPMSP1D,DSP2DB];
SPRDDB=[DSP2DC1];
BYSP1D_FULL=[BYSP1DA,BYSP1DB];
BYSP2D_FULL=[BYSP2DA,BYSP2DB];
QSP1D_FULL=[QSP1D,QSP1D];
QSP2D_FULL=[QSP2D,QSP2D];
SPRDDC=[DSP2DC2,XCSP1D,DSP2DD,QSP1D_FULL,DSP3DA,DSP3DB,IMSP0D,DSP3DC,MRFBSP2D,BPMSP2D,DSP3DD,QSP2D_FULL,DSP4DA,YCSP2D,DSP4DB,BYSP1D_FULL,DSP5DA,DSP5DB,WSSP1D,DSP5DC1,IMBCSD1,DSP5DC2,IMBCSD2,DSP5DC3,BPMSP3D,DSP5DD,BYSP2D_FULL,CNTSP1D,DSP6DA,XCSP3D,DSP6DB,YCSP4D,DSP6DC,DSP6DD,DSP6DE,DSP6DFA,WOODDOOR];
SPRDDD=[DSP6DFB,XCSP5D,DSP6DFC,YCSP6D,DSP6DFD,BPMSP4D,DSP6DG,DSP6DH,RWWAKE3D,BKXRASD,DSP6DI,BKYRASD,DSP6DJ,BPMSP5D,DSP7DAA,OTRSPDMP,DSP7DAB,DSP7DB,MUWALLD,DWALLAD,DUMPBSY,DDUMPBSY,BTMSPDMP];
SPRDD=[SPRDKH,SPRDKS,SPRDDA,SPRDDB,SPRDDC,SPRDDD];

% ==============================================================================
% DC spreader option (HXR): single type-5 corrector (SA-388-310-30)
GBSPDC =  0.0254       ;%wrapped around a 2" OD pipe (m)
ZBSPDC =  0.3375       ;%measured B vs Z (m)
FBSPDC =  0.5          ;%dummy
ABSPDC =  -0.75E-3     ;%total HXR spreader y-angle (rad)
BLSPDC =  BRHOF*ABSPDC ;%kG-m
ABSPDC_2 =  ABSPDC*ABSPDC;
ABSPDC_4 =  ABSPDC_2*ABSPDC_2;
ABSPDC_6 =  ABSPDC_4*ABSPDC_2;
SINCABSPDC =  1-ABSPDC_2/6+ABSPDC_4/120-ABSPDC_6/5040 ;%~sinc(x)=sin(x)/x
LBSPDC =  ZBSPDC/SINCABSPDC;
ABSPDCS =  asin(sin(ABSPDC)/2);
ABSPDCS_2 =  ABSPDCS*ABSPDCS;
ABSPDCS_4 =  ABSPDCS_2*ABSPDCS_2;
ABSPDCS_6 =  ABSPDCS_4*ABSPDCS_2;
SINCABSPDCS =  1-ABSPDCS_2/6+ABSPDCS_4/120-ABSPDCS_6/5040 ;%~sinc(x)=sin(x)/x
LBSPDCS =  ZBSPDC/(2*SINCABSPDCS);
ABSPDCL =  ABSPDC-ABSPDCS;
LBSPDCL =  LBSPDC-LBSPDCS;
BYSPHA={'be' 'BYSPH' LBSPDCL [ABSPDCL GBSPDC 0 0 FBSPDC 0 pi/2]}';
BYSPHB={'be' 'BYSPH' LBSPDCS [ABSPDCS GBSPDC 0 ABSPDC 0 FBSPDC pi/2]}';
LZSPDC =  23.1 ;%Z distance from BEGSPH to BLXSPH center (m)
LDSPDC =  LZSPDC-LBLSP/2-ZBSPDC ;%sum of drift lengths (m)
DSPDC1={'dr' '' 2.931253585645 []}';%BEGSPH to BYSPH
DSPDC2={'dr' '' (LDSPDC-DSPDC1{3})/cos(ABSPDC) []}';%BYSPH to BLXSPH
DSPDC2B={'dr' '' 12.833/cos(ABSPDC) []}';%BPMSPH to BLXSPH
DSPDC2A={'dr' '' DSPDC2{3}-DSPDC2B{3} []}';%BYSPH to BPMSPH
BYSPH_FULL=[BYSPHA,BYSPHB];
SPRDKHDC=[DSPDC1,BYSPH_FULL,DSPDC2A,BPMSPH,DSPDC2B,BLXSPH_FULL];
% DC spreader option (SXR): single type-5 corrector (SA-388-310-30)
BYSPSA={'be' 'BYSPS' LBSPDCL [ABSPDCL GBSPDC 0 0 FBSPDC 0 pi/2]}';
BYSPSB={'be' 'BYSPS' LBSPDCS [ABSPDCS GBSPDC 0 ABSPDC 0 FBSPDC pi/2]}';
BYSPS_FULL=[BYSPSA,BYSPSB];
SPRDKSBDC=[DSPDC1,BYSPS_FULL,DSPDC2A,BPMSPS,DSPDC2B,BLXSPS_FULL];
% BDES and IDES
BDES =  BLSPDC;
IDES =  47.04*BDES+671*BDES^3;

% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc transport from Cu-linac to SXR
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 28-MAY-2019, M. Woodley
%  * relocate XCCUS1, YCCUS2, and BPMCUS3 per L. Borzenets
% 13-MAY-2019, M. Woodley
%  * change length of STCLTS to 30" and move 5.1 cm d/s per A. Ibrahimov
% 30-APR-2019, M. Woodley
%  * use measured FINT=0.4861 for 1.0D38.37 @ 200A
% ------------------------------------------------------------------------------
% 04-OCT-2018, M. Woodley
%  * include alternative DC extraction into CUSXR
%  * replace 1.0D22.265 dipoles (BYCUS1&2) with 3D8.8MK3 corrector magnets
% 15-AUG-2018, M. Woodley
%  * add STCLTS (PEP-II insertable PPS stopper) between QCUS8 and QCUS9
% 04-MAY-2018, M. Woodley
%  * undefer everything (LCLS pays)
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * minor adjustment to kicker angle
%  * add a note that BRCUS1 is a special merge DC-bend which is turned ON
%    for CURF beam to SXR or OFF for SCRF beam to SXR
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * add deferred BPMCUS between kicker and septum
%  * move BPMs inside the quads QCUS4, QCUS5, QCUS7
%  * update the engineering type of BKRCUS kicker to "1.92K41.2" (J. Amann)
%  * remove corrector dipoles BRCCUS1&2, rematch geometry and optics
% ------------------------------------------------------------------------------
% 26-FEB-2016, M. Woodley
%  * remove SEQnn MARKers
% 26-FEB-2016, Y. Nosochkov
%  * replace 5 kickers (based on spreader kicker design) with one kicker
%    based on BYKIK1 design (per T. Beukers)
%  * increase CUSXR length by 1.2 m to avoid interference with A-line kicker
%    (septum and first 3 quad positions are not changed, but the rest is moved
%    downstream while keeping the CUSXR symmetry) 
% ------------------------------------------------------------------------------
% 25-SEP-2015, Y. Nosochkov
%  * update definitions of kickers, septum and last DC bend to allow
%    zero angle
% 24-AUG-2015, Y. Nosochkov
%  * move BPMCUS2 downstream of QCUS2
%  * move XCCUS10 upstream of QCUS10
%  * replace the first DC bend with a fast kicker and a septum (deferred at @3)
%  * increase the distance from first/last bend to the nearest quad
%  * add two corrector bends to cancel the kicker orbit and dispersion (at @3)
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * add additional deferred quadrupole at center of CUSXR
%  * rename some magnets/devices to put the names in order
%  * change magnet type of QCUS4, QCUS5, QCUS6, QCUS7 from 2Q10 to 1.085Q4.31
%  * change BPM type at 2Q10 to Stripline-5, and at 1.085Q4.31 to Stripline-2
%  * move BPMs outside of the quads
%  * adjust distance from BPM/corr to the quad
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * move definitions of BEGCUSXR and ENDCUSXR MARKERs to common.xsif
%  * add SEQ20BEG and SEQ20END MARKERs
% 12-MAR-2015, Y. Nosochkov
%  * add a dogleg transport line from Cu-linac to SXR (deferred to level 3)
% ------------------------------------------------------------------------------
% XYZ (linac system) at entrance of the kicker (BEGCLTS)
XCUS1 =  -3.309962022E-7 ;%per existing LCLS-1 coordinates
YCUS1 =   0.0;
ZCUS1 =   3058.456916    ;%moved upstream for CUSXR DC extraction
THCUS1 =   0.0;
PHCUS1 =   0.0;
PSCUS1 =   0.0;
% XYZ (linac system) at exit of the last bend (ENDCUSXR)
XCUS2 =  -25.610*IN2M;
YCUS2 =   25.570*IN2M;
ZCUS2 =   3177.65;
THCUS2 =   0.0;
PHCUS2 =   0.0;
PSCUS2 =   0.0;
% Twiss at BEGCLTS
TBXCUS1 =  28.733475248907;
TBYCUS1 =  51.61209559579;
TAXCUS1 =  -0.11996119728;
TAYCUS1 =   0.738889504715;
% ------------------------------------------------------------------------------
% quads (Cu-linac energy is limited to 10 GeV)
KQCUS1 =   0.491233972308;
KQCUS2 =  -0.414060432356;
KQCUS3 =  -0.314369385154;
KQCUS4 =   2.369394892073;
KQCUS5 =  -1.396338070942;
KQCUS9 =  -0.456516817666;
KQCUS10 =   0.496780961708;
KQCUS6 =   KQCUS5;
KQCUS7 =   KQCUS4;
KQCUS8 =   KQCUS3;
QCUS1={'qu' 'QCUS1' LQR/2 [KQCUS1 0]}';
QCUS2={'qu' 'QCUS2' LQR/2 [KQCUS2 0]}';
QCUS3={'qu' 'QCUS3' LQR/2 [KQCUS3 0]}';
QCUS4={'qu' 'QCUS4' LQE/2 [KQCUS4 0]}';
QCUS5={'qu' 'QCUS5' LQE/2 [KQCUS5 0]}';
QCUS6={'qu' 'QCUS6' LQE/2 [KQCUS6 0]}';
QCUS7={'qu' 'QCUS7' LQE/2 [KQCUS7 0]}';
QCUS8={'qu' 'QCUS8' LQR/2 [KQCUS8 0]}';
QCUS9={'qu' 'QCUS9' LQR/2 [KQCUS9 0]}';
QCUS10={'qu' 'QCUS10' LQR/2 [KQCUS10 0]}';
% ------------------------------------------------------------------------------
% kicker is aligned along the BSY1 axis and rolled approx. -45 deg
% kicker design is based on existing BYKIK1 (max. field ~600G per T. Beukers)
TCUSXR =  -0.673868825333 ;%roll angle of kicker (+pi/2) and septum (rad)
GBKRCUS =  25.4E-3 ;%kicker gap (m)
ZBKRCUS =  1.0601  ;%kicker straight length (m)
ABKRCUS0 =  -0.87326308078E-3;
PULSED =  abs(SETCUS)*(1+SETCUS)/2;
ABKRCUS =  ABKRCUS0*PULSED          ;%total kicker angle (rad)
ABKRCUSA =  asin(sin(ABKRCUS)/2)     ;%1st half-kicker angle (rad)
ABKRCUSB =  ABKRCUS-ABKRCUSA         ;%2nd half-kicker angle (rad)
ABKRCUS_2 =  ABKRCUS   *ABKRCUS;
ABKRCUS_4 =  ABKRCUS_2 *ABKRCUS_2;
ABKRCUSA_2 =  ABKRCUSA  *ABKRCUSA;
ABKRCUSA_4 =  ABKRCUSA_2*ABKRCUSA_2;
LBKRCUS =  ZBKRCUS   /(1 -ABKRCUS_2 /6 +ABKRCUS_4 /120);
LBKRCUSA =  ZBKRCUS/2 /(1 -ABKRCUSA_2/6 +ABKRCUSA_4/120);
LBKRCUSB =  LBKRCUS-LBKRCUSA;
BKRCUSA={'be' 'BKRCUS' LBKRCUSA [ABKRCUSA GBKRCUS/2 0 0 0.5 0 PI/2+TCUSXR]}';
BKRCUSB={'be' 'BKRCUS' LBKRCUSB [ABKRCUSB GBKRCUS/2 0 ABKRCUS 0 0.5 PI/2+TCUSXR]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKRCUS={'be' 'BKRCUS' LBKRCUS [ABKRCUS GBKRCUS/2 0 ABKRCUS 0.5 0.5 PI/2+TCUSXR]}';
% ------------------------------------------------------------------------------
% DC alternative to kicker comprised of two 3D8.8MK3 correctors, one at each end of BKRCUS
% - both correctors are aligned along the linac z-axis
GBRCUSDC =  2.031*IN2M ;%full gap (m)
ZBRCUSDC =  0.2691     ;%on-axis effective length (m) (measured)
FBRCUSDC =  0.3041     ;%FINT (measured)
TBRCUSDC =  TCUSXR     ;%roll angle (+pi/2)
DCMODE =  abs(SETCUS)*(1-SETCUS)/2;
ABRCUSDC =  ABKRCUS0*DCMODE          ;%total bend angle (rad)
ABRCUSDC1 =  asin(sin(ABRCUSDC)/2)    ;%1st corrector bend angle (rad)
ABRCUSDC2 =  ABRCUSDC-ABRCUSDC1       ;%2nd corrector bend angle (rad)
% Note: 1-theta^2/6 ~ sinc(theta)
LBRCUSDC =  2*ZBRCUSDC/(1-ABRCUSDC*ABRCUSDC/6);
LBRCUSDC1 =  ZBRCUSDC/(1-ABRCUSDC1*ABRCUSDC1/6);
LBRCUSDC2 =  LBRCUSDC-LBRCUSDC1;
LBRCUSDC1A =  0.134538920784 ;%ZBRCUSdc/2
LBRCUSDC1B =  LBRCUSDC1-LBRCUSDC1A;
ABRCUSDC1A =  ABRCUSDC1*(LBRCUSDC1A/LBRCUSDC1);
ABRCUSDC1B =  ABRCUSDC1-ABRCUSDC1A;
BRCUSDC1A={'be' 'BRCUSDC1' LBRCUSDC1A [ABRCUSDC1A GBRCUSDC/2 0 0 FBRCUSDC 0 PI/2+TBRCUSDC]}';
BRCUSDC1B={'be' 'BRCUSDC1' LBRCUSDC1B [ABRCUSDC1B GBRCUSDC/2 0 ABRCUSDC1 0 FBRCUSDC PI/2+TBRCUSDC]}';
LBRCUSDC2A =  0.1345578935 ;%ZBRCUSdc/2
LBRCUSDC2B =  LBRCUSDC2-LBRCUSDC2A;
ABRCUSDC2A =  ABRCUSDC2*(LBRCUSDC2A/LBRCUSDC2);
ABRCUSDC2B =  ABRCUSDC2-ABRCUSDC2A;
BRCUSDC2A={'be' 'BRCUSDC2' LBRCUSDC2A [ABRCUSDC2A GBRCUSDC/2 -ABRCUSDC1 0 FBRCUSDC 0 PI/2+TBRCUSDC]}';
BRCUSDC2B={'be' 'BRCUSDC2' LBRCUSDC2B [ABRCUSDC2B GBRCUSDC/2 0 ABRCUSDC 0 FBRCUSDC PI/2+TBRCUSDC]}';
LDCK =  40.03*IN2M                ;%center-to-center Z-distance between corrector and kicker
ZCKDC =  LDCK-(ZBRCUSDC+ZBKRCUS)/2 ;%Z-distance between corrector and kicker
ZCUSBLR =  16.1469-ZCKDC-ZBRCUSDC    ;%Z-distance between kicker and septum
ZCUSBLRA =  5.1956-(ZCKDC+ZBRCUSDC)   ;%Z-distance between corrector and BPM
ZCUSBLRB =  ZCUSBLR-ZCUSBLRA          ;%Z-distance between BPM and septum
LDCKDC1 =  ZCKDC/cos(ABRCUSDC1);
LDCKDC2 =  ZCKDC/cos(ABRCUSDC1+ABKRCUS)   ;%one of these angles will be zero
LDCUSBLR =  ZCUSBLR/cos(ABRCUSDC+ABKRCUS)  ;%one of these angles will be zero
LDCUSBLRA =  ZCUSBLRA/cos(ABRCUSDC+ABKRCUS) ;%one of these angles will be zero
LDCUSBLRB =  ZCUSBLRB/cos(ABRCUSDC+ABKRCUS) ;%one of these angles will be zero
DCKDC1={'dr' '' LDCKDC1 []}';
DCKDC2={'dr' '' LDCKDC2 []}';
DCUSBLRA={'dr' '' LDCUSBLRA []}';
DCUSBLRB={'dr' '' LDCUSBLRB []}';
% define unsplit SBENs for BMAD ... not used by MAD
BRCUSDC1={'be' 'BRCUSDC' LBRCUSDC1 [ABRCUSDC1 GBRCUSDC/2 0 ABRCUSDC1 FBRCUSDC FBRCUSDC PI/2+TBRCUSDC]}';
BRCUSDC2={'be' 'BRCUSDC' LBRCUSDC2 [ABRCUSDC2 GBRCUSDC/2 -ABRCUSDC1 ABRCUSDC FBRCUSDC FBRCUSDC PI/2+TBRCUSDC]}';
% ------------------------------------------------------------------------------
% 2-hole rolled septum aligned along the BSY1 axis
GBLRCUS =  GBLSP ;%septum gap height (m)
ZBLRCUS =  LBLSP ;%septum straight length (m)
ABLRCUS0 =  0.911077773379E-2;
ABLRCUS =  ABLRCUS0*abs(SETCUS) ;%septum bending angle (rad)
ABLRCUSA =  asin(sin(ABLRCUS)/2) ;%angle per 1st half of the septum
ABLRCUSB =  ABLRCUS-ABLRCUSA     ;%angle per 2nd half of the septum
ABLRCUS_2 =  ABLRCUS   *ABLRCUS;
ABLRCUS_4 =  ABLRCUS_2 *ABLRCUS_2;
ABLRCUSA_2 =  ABLRCUSA  *ABLRCUSA;
ABLRCUSA_4 =  ABLRCUSA_2*ABLRCUSA_2;
LBLRCUS =  ZBLRCUS   /(1 -ABLRCUS_2/6  +ABLRCUS_4 /120)/cos(ABKRCUS);
LBLRCUSA =  ZBLRCUS/2 /(1 -ABLRCUSA_2/6 +ABLRCUSA_4/120)/cos(ABKRCUS);
LBLRCUSB =  LBLRCUS-LBLRCUSA;
BLRCUSA={'be' 'BLRCUS' LBLRCUSA [ABLRCUSA GBLRCUS/2 0 0 0.5 0 TCUSXR]}';
BLRCUSB={'be' 'BLRCUS' LBLRCUSB [ABLRCUSB GBLRCUS/2 0 ABLRCUS 0 0.5 TCUSXR]}';
% define unsplit SBENs for BMAD ... not used by MAD
BLRCUS={'be' 'BLRCUS' LBLRCUS [ABLRCUS GBLRCUS/2 0 ABLRCUS 0.5 0.5 TCUSXR]}';
% rolled DC bend
% Note: BRCUS1 is a merge DC-bend which is either turned ON to operate
%       CURF beam in SXR, or turned OFF to operate SCRF beam in SXR
TBRCUS =  -0.769423721099 ;%roll angle of DC bend (rad)
GBRCUS =  GBSP ;%bend gap height (m)
ZBRCUS =  LBSP ;%bend straight length (1.0D38.37) (m)
FBRCUS =  0.4861 ;%measured FINT
DABRCUS =  -0.417540592574E-4;
ABRCUS =  (-ABLRCUS0+DABRCUS)*abs(SETCUS);
ABRCUSH =  ABRCUS/2;
ABRCUSH_2 =  ABRCUSH   *ABRCUSH;
ABRCUSH_4 =  ABRCUSH_2 *ABRCUSH_2;
LBRCUS =  ZBRCUS/(1-ABRCUSH_2/6 +ABRCUSH_4/120) ;%bend path length (m)
BRCUS1A={'be' 'BRCUS1' LBRCUS/2 [ABRCUS/2 GBRCUS/2 ABRCUS/2 0 FBRCUS 0 TBRCUS]}';
BRCUS1B={'be' 'BRCUS1' LBRCUS/2 [ABRCUS/2 GBRCUS/2 0 ABRCUS/2 0 FBRCUS TBRCUS]}';
% define unsplit SBENs for BMAD ... not used by MAD
BRCUS1={'be' 'BRCUS' LBRCUS [ABRCUS GBRCUS/2 ABRCUS/2 ABRCUS/2 FBRCUS FBRCUS TBRCUS]}';
% inner vertical bends for R56 cancellation
% NOTE: 1.0D22.265 dipoles replaced with 3D8.8MK3 correctors
GBYCUS =  GBRCUSDC       ;%full gap (m)
ZBYCUS =  ZBRCUSDC       ;%on-axis effective length (m)
FBYCUS =  0.5 ;%FBRCUSdc  FINT
DLD2C =  (0.6-ZBYCUS)/2 ;%1.0D22.265 -> 3D8.8MK3 
ABYCUS =  0.4E-3;
LBYCUS =  ZBYCUS*ABYCUS/(2*sin(ABYCUS/2)) ;%bend path length (m)
BYCUS1A={'be' 'BYCUS1' LBYCUS/2 [ABYCUS/2 GBYCUS/2 ABYCUS/2 0 FBYCUS 0 PI/2]}';
BYCUS1B={'be' 'BYCUS1' LBYCUS/2 [ABYCUS/2 GBYCUS/2 0 ABYCUS/2 0 FBYCUS PI/2]}';
BYCUS2A={'be' 'BYCUS2' LBYCUS/2 [-ABYCUS/2 GBYCUS/2 -ABYCUS/2 0 FBYCUS 0 PI/2]}';
BYCUS2B={'be' 'BYCUS2' LBYCUS/2 [-ABYCUS/2 GBYCUS/2 0 -ABYCUS/2 0 FBYCUS PI/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYCUS1={'be' 'BYCUS' LBYCUS [ABYCUS GBYCUS/2 ABYCUS/2 ABYCUS/2 FBYCUS FBYCUS PI/2]}';
BYCUS2={'be' 'BYCUS' LBYCUS [-ABYCUS GBYCUS/2 -ABYCUS/2 -ABYCUS/2 FBYCUS FBYCUS PI/2]}';
% rolled DC corrector bends -- removed
LBRCCUS =  0.6;
DBRCCUS1={'dr' '' LBRCCUS/2 []}';
DBRCCUS2={'dr' '' LBRCCUS/2 []}';
% ------------------------------------------------------------------------------
% drifts
DLDCUS0 =   0.0  ;%adjust length of CUSXR
DLDCUS2 =   0.0  ;%adjust positions of QCUS2,9
DLDCUS3 =  -0.9  ;%adjust positions of QCUS3,8
DLDCUS4 =   0.16 ;%adjust positions of QCUS4,7
DLDCUS13 =   0.0  ;%asymmetry between LDCUS1 and LDCUS13
LDCUS0 =  5.133675753223652 +DLDCUS0;
LDCUS1 =  29.4;
LDCUS2 =  LDCUS0         +DLDCUS2;
LDCUS3 =  LDCUS0 -DLDCUS2+DLDCUS3;
LDCUS4 =  LDCUS0 -DLDCUS3+DLDCUS4 +0.599963125932;
LDCUS5 =  1.5-0.25 -DLDCUS4 +DLD2C;
LDCUS6 =  1.0+0.25 +DLD2C;
LDCUS7 =  0.3/2;
LDCUS8 =  LDCUS6;
LDCUS9 =  LDCUS5;
LDCUS10 =  LDCUS4;
LDCUS11 =  LDCUS3;
LDCUS12 =  LDCUS2;
LDCUS13 =  LDCUS1+LBLRCUS/2-LBRCUS/2 +DLDCUS13;
LDCUS1B =  7.0;
LDCUS1C =  0.5;
LDCUS1A =  LDCUS1-LDCUS1B-LDCUS1C-LBRCCUS-LBRCCUS -DLDCUS13;
LDCUS2A =  0.464083 ;%0.4471
LDCUS2B =  0.747032 ;%0.619817
LDCUS2C =  LDCUS2-LDCUS2A-LDCUS2B;
LDCUS3A =  0.463634 ;%0.4471
LDCUS3B =  0.747031 ;%0.843035
LDCUS3D =  0.389900 ;%0.593909
LDCUS3C =  LDCUS3-LDCUS3A-LDCUS3B-LDCUS3D;
LDCUS4A =  0.4285;
LDCUS4C =  0.1924;
LDCUS4B =  LDCUS4-LDCUS4A-LDCUS4C +(LQR-LQE)/2;
LDCUS5A =  0.4;
LDCUS5B =  LDCUS5-LDCUS5A +(LQR-LQE)/2;
LDCUS6B =  0.1924;
LDCUS6A =  LDCUS6-LDCUS6B +(LQR-LQE)/2 -LQE/2-LDCUS7;
LDCUS8A =  0.4;
LDCUS8B =  LDCUS8-LDCUS8A +(LQR-LQE)/2 -LQE/2-LDCUS7;
LDCUS9B =  0.1924;
LDCUS9A =  LDCUS9-LDCUS9B +(LQR-LQE)/2;
LDCUS10A =  0.4;
LDCUS10C =  0.390327 ;%0.4781
LDCUS10B =  LDCUS10-LDCUS10A-LDCUS10C +(LQR-LQE)/2;
LDCUS11A =  0.4285;
LDCUS11C =  0.390815 ;%0.4781
LDCUS11B =  LDCUS11-LDCUS11A-LDCUS11C;
LDCUS12A =  0.4285;
LDCUS12C =  0.821035 ;%0.6058
LDCUS12D =  0.390264 ;%0.4781
LDCUS12B =  LDCUS12-LDCUS12A-LDCUS12C-LDCUS12D;
DCUS1A={'dr' '' LDCUS1A []}';
DCUS1B={'dr' '' LDCUS1B []}';
DCUS1C={'dr' '' LDCUS1C []}';
DCUS2A={'dr' '' LDCUS2A []}';
DCUS2B={'dr' '' LDCUS2B []}';
DCUS2C={'dr' '' LDCUS2C []}';
DCUS3A={'dr' '' LDCUS3A []}';
DCUS3B={'dr' '' LDCUS3B []}';
DCUS3C={'dr' '' LDCUS3C []}';
DCUS3D={'dr' '' LDCUS3D []}';
DCUS4A={'dr' '' LDCUS4A []}';
DCUS4B={'dr' '' LDCUS4B []}';
DCUS4C={'dr' '' LDCUS4C []}';
DCUS5A={'dr' '' LDCUS5A []}';
DCUS5B={'dr' '' LDCUS5B []}';
DCUS6A={'dr' '' LDCUS6A []}';
DCUS6B={'dr' '' LDCUS6B []}';
DCUS7={'dr' '' LDCUS7 []}';
DCUS8A={'dr' '' LDCUS8A []}';
DCUS8B={'dr' '' LDCUS8B []}';
DCUS9A={'dr' '' LDCUS9A []}';
DCUS9B={'dr' '' LDCUS9B []}';
DCUS10A={'dr' '' LDCUS10A []}';
DCUS10B={'dr' '' LDCUS10B []}';
DCUS10C={'dr' '' LDCUS10C []}';
DCUS11A={'dr' '' LDCUS11A []}';
DCUS11B={'dr' '' LDCUS11B []}';
DCUS11C={'dr' '' LDCUS11C []}';
DCUS12A={'dr' '' LDCUS12A []}';
DCUS12B={'dr' '' LDCUS12B []}';
DCUS12C={'dr' '' LDCUS12C []}';
DCUS12D={'dr' '' LDCUS12D []}';
DCUS13={'dr' '' LDCUS13 []}';
% markers
BEGCUSXR={'mo' 'BEGCUSXR' 0 []}';
MIDCUSXR={'mo' 'MIDCUSXR' 0 []}';%center of CUSXR
CNTCUS1={'mo' 'CNTCUS1' 0 []}';
CNTCUS2={'mo' 'CNTCUS2' 0 []}';
CNTCUS3={'mo' 'CNTCUS3' 0 []}';
CNTCUS4={'mo' 'CNTCUS4' 0 []}';
CNTCUS5={'mo' 'CNTCUS5' 0 []}';
ENDCUSXR={'mo' 'ENDCUSXR' 0 []}';
% monitors
BPMCUS={'mo' 'BPMCUS' 0 []}';
BPMCUS1={'mo' 'BPMCUS1' 0 []}';
BPMCUS2={'mo' 'BPMCUS2' 0 []}';
BPMCUS3={'mo' 'BPMCUS3' 0 []}';
BPMCUS4={'mo' 'BPMCUS4' 0 []}';
BPMCUS5={'mo' 'BPMCUS5' 0 []}';
BPMCUS7={'mo' 'BPMCUS7' 0 []}';
BPMCUS8={'mo' 'BPMCUS8' 0 []}';
BPMCUS9={'mo' 'BPMCUS9' 0 []}';
BPMCUS10={'mo' 'BPMCUS10' 0 []}';
% steering correctors
XCCUS1={'mo' 'XCCUS1' 0 []}';%type TBD
XCCUS4={'mo' 'XCCUS4' 0 []}';%type TBD
XCCUS7={'mo' 'XCCUS7' 0 []}';%type TBD
XCCUS10={'mo' 'XCCUS10' 0 []}';%type TBD
YCCUS2={'mo' 'YCCUS2' 0 []}';%type TBD
YCCUS3={'mo' 'YCCUS3' 0 []}';%type TBD
YCCUS6={'mo' 'YCCUS6' 0 []}';%type TBD
YCCUS8={'mo' 'YCCUS8' 0 []}';%type TBD
YCCUS9={'mo' 'YCCUS9' 0 []}';%type TBD
% insertable stopper / tuneup dump
STCLTS={'mo' 'STCLTS' 0.30 []}';%from PEP-II injection line
BTMCLTS={'mo' 'BTMCLTS' 0 []}';
DCUS11B1={'dr' '' 2.114313 []}';%1.883313
DCUS11B2={'dr' '' DCUS11B{3}-DCUS11B1{3}-STCLTS{3} []}';
% SROT to remove rotation angle
AROCUS1 =  -0.249098811997E-4;
AROCUS2 =   0.209318005136E-4;
AROCUS3 =   0.117879544139E-19;
AROCUS4 =  -AROCUS3;
ROCUS1={'ro' 'ROCUS1' 0 [-(AROCUS1)]}';
ROCUS2={'ro' 'ROCUS2' 0 [-(AROCUS2)]}';
ROCUS3={'ro' 'ROCUS3' 0 [-(AROCUS3)]}';
ROCUS4={'ro' 'ROCUS4' 0 [-(AROCUS4)]}';
% beamlines
BRCUSDC1_FULL=[BRCUSDC1A,BRCUSDC1B];
BKRCUS_FULL=[BKRCUSA,BKRCUSB];
BRCUSDC2_FULL=[BRCUSDC2A,BRCUSDC2B];
BLRCUS_FULL=[BLRCUSA,BLRCUSB];
BYCUS1_FULL=[BYCUS1A,BYCUS1B];
BYCUS2_FULL=[BYCUS2A,BYCUS2B];
BRCUS1_FULL=[BRCUS1A,BRCUS1B];
QCUS1_FULL=[QCUS1,QCUS1];
QCUS2_FULL=[QCUS2,QCUS2];
QCUS3_FULL=[QCUS3,QCUS3];
QCUS4_FULL=[QCUS4,BPMCUS4,QCUS4];
QCUS5_FULL=[QCUS5,BPMCUS5,QCUS5];
QCUS6_FULL=[QCUS6,QCUS6];
QCUS7_FULL=[QCUS7,BPMCUS7,QCUS7];
QCUS8_FULL=[QCUS8,QCUS8];
QCUS9_FULL=[QCUS9,QCUS9];
QCUS10_FULL=[QCUS10,QCUS10];
KCUSXRA=[BRCUSDC1_FULL,DCKDC1,BKRCUS_FULL,DCKDC2,BRCUSDC2_FULL,DCUSBLRA,BPMCUS,DCUSBLRB,BLRCUS_FULL];
KCUSXRB=[CNTCUS1,ROCUS1,DCUS1A,DBRCCUS1,DBRCCUS1,DCUS1B,DBRCCUS2,DBRCCUS2,CNTCUS5];
KCUSXR=[KCUSXRA,KCUSXRB];
DLCUSXR=[DCUS1C,QCUS1_FULL,DCUS2A,BPMCUS1,DCUS2B,XCCUS1,DCUS2C,QCUS2_FULL,DCUS3A,BPMCUS2,DCUS3B,YCCUS2,DCUS3C,BPMCUS3,DCUS3D,QCUS3_FULL,DCUS4A,YCCUS3,DCUS4B,DCUS4C,QCUS4_FULL,DCUS5A,XCCUS4,DCUS5B,BYCUS1_FULL,CNTCUS3,ROCUS3,DCUS6A,DCUS6B,QCUS5_FULL,DCUS7,MIDCUSXR,DCUS7,QCUS6_FULL,DCUS8A,YCCUS6,DCUS8B,ROCUS4,BYCUS2_FULL,CNTCUS4,DCUS9A,DCUS9B,QCUS7_FULL,DCUS10A,XCCUS7,DCUS10B,BPMCUS8,DCUS10C,QCUS8_FULL,DCUS11A,YCCUS8,DCUS11B1,STCLTS,BTMCLTS,DCUS11B2,BPMCUS9,DCUS11C,QCUS9_FULL,DCUS12A,YCCUS9,DCUS12B,XCCUS10,DCUS12C,BPMCUS10,DCUS12D,QCUS10_FULL,DCUS13,ROCUS2,BRCUS1_FULL,CNTCUS2];
CUSXR=[BEGCUSXR,KCUSXR,DLCUSXR,ENDCUSXR];

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc A-line
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 26-MAR-2019, M. Woodley
%  * split BSYA area into two subareas, BSYA_1 and BSYA_2
% ------------------------------------------------------------------------------
% 31-OCT-2018, Y. Nosochkov
%  * minor adjustment of DA04c drift length for DASEL with 25G kicker field
% 09-OCT-2018, M. Woodley
%  * add YCBSYA per D. McCormick
% ------------------------------------------------------------------------------
% 25-MAY-2018, M. Woodley
%  * change name of E158 bends in ESA to avoid redefinitions
% ------------------------------------------------------------------------------
% 07-FEB-2018, M. Woodley
%  * add TYPE designations for A-line magnets
% 05-FEB-2018, Y. Nosochkov
%  * minor optics rematch
% 25-JAN-2018, M. Woodley
%  * remove PCBSY2/BTMBSY2 per A. Ibrahimov
% ------------------------------------------------------------------------------
% 07-JUL-2017, Y. Nosochkov
%  * minor optics rematch for LCLS-II-HE
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * remove deferral designations
%  * remove unused element definitions
%  * pulsed correctors XCAPM2/YCAPM2 will be timed to affect the straight-ahead
%    LTUH beam, but not the A-line beam
%  * extend line to 3PR2
% ------------------------------------------------------------------------------
% 02-MAR-2017, M. Woodley
%  * rename "SQ27.5" to SQ27p5 per G. White
%  * expand BSYA area to include entire A-line (up to End Station wall)
%  * add definitions for ABRDAS2 and TBRDAS2 (copied from DASEL.xsif)
% 24-FEB-2017, Y. Nosochkov
%  * merge with A-line deck containing diagnostic + E158 (from M. Woodley)
%  * rename rolled BKXAPM1-4 to BKRAPM1-4 (per naming convention)
%  * rename rolled BXAM1 to BRAM1 (per naming convention)
%  * remove ROLL4 S-rotation and replace it with BRAM1 tilt angle
%  * update ROLL2 value
%  * rename some parameters and drifts
%  * update definition of 2-hole DUMPBSYA copper collimator using two separate
%    collimators: for A-line (PCBSYA) and straight ahead BSY (PCBSYH)
%  * move PCBSYA/PCBSYH (formerly DUMPBSYA) 1.35 m upstream (D. McCormick)
%  * add deferred profile monitor PRBRAM1 and Cu target TGTBRAM1 upstream of
%    BRAM1 (D. McCormick)
%  * make the PRAPM profile monitor a YAG monitor (D. McCormick) and change
%    name to YAGAPM 
%  * add deferred corrector package XCAPM2/YCAPM2 to the pulsed magnets
%    (D. McCormick)
%  * change deferment level of new A-line components from @3 to @1
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * replace fast kicker/septum magnets with 120 Hz pulsed magnets (deferred)
%    for ESTB (D. McCormick, J. Amann)
%  * the pulsed magnets and other ESTB devices are not funded by LCLS-II (Paul)
%  * update eng. type of BXAM1 from 1.0D38.37 to 2.0D38.37 (J. Amann)
%  * move to baseline: PCBSY2, BTMBSY2
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * add deferred BPMCUA between A-line kicker and septum
%  * update the engineering type of BKYAL1,...,BKYAL5 kickers to
%    "0.787K35.4" (J. Amann)
% ------------------------------------------------------------------------------
% 26-FEB-2016, M. Woodley
%  * remove SEQnn MARKers
% 26-FEB-2016, Y. Nosochkov
%  * add BCS PCBSY2/BTMBSY2 at Z=3124 m (deferred @0) (S. Mao)
%  * increase distance between kickers from 15 cm to 30 cm
% ------------------------------------------------------------------------------
% 25-SEP-2015, Y. Nosochkov
%  * update definitions of kickers and septum to allow zero angle
% 24-AUG-2015, Y. Nosochkov
%  * update the TYPE of septum from 0.39SD38.98 to 0.625SD38.98 (J. Amann)
%  * adjust quad strengths for match to the updated BSY optics
%  * match geometry to the updated positions of A-line kicker & septum
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * add SEQ21BEG, SEQ21END, BEGBSYA, ENDBSYA MARKERs
% 12-MAR-2015, Y. Nosochkov
%  * add fast kickers and septum (as in spreader) to deflect beam into A-line
%  * A-line optics based on original design per M. Woodley's deck
% ------------------------------------------------------------------------------
% NOTE: ABRDAS2 and TBRDAS2 are defined in common.xsif
% ==============================================================================
% dipoles
% ------------------------------------------------------------------------------
% yawed pulsed magnets
GBKRAPM =  35.687E-3      ;%1.405K40.83 pulsed magnet gap (m)
SBKRAPM =  1.055          ;%PM eff. straight length (m)
TBKRAPM =  0.014303833885 ;%PM tilt angle (rad)
ABKRAPM0 =  -0.276615046502E-2;
ABKRAPM =  ABKRAPM0 *SETAL     ;%angle per one PM (rad)
ABKRAPMH =  ABKRAPM/2           ;%PM half-angle
ABKRAPMH2 =  ABKRAPMH *ABKRAPMH;
ABKRAPMH4 =  ABKRAPMH2*ABKRAPMH2;
LBKRAPM =  SBKRAPM/(1 -ABKRAPMH2/6 +ABKRAPMH4/120) ;%PM path length
BKRAPM1A={'be' 'BKRAPM1' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 ABKRAPM/2 0 0.5 0 TBKRAPM]}';
BKRAPM1B={'be' 'BKRAPM1' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 0 ABKRAPM/2 0 0.5 TBKRAPM]}';
BKRAPM2A={'be' 'BKRAPM2' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 ABKRAPM/2 0 0.5 0 TBKRAPM]}';
BKRAPM2B={'be' 'BKRAPM2' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 0 ABKRAPM/2 0 0.5 TBKRAPM]}';
BKRAPM3A={'be' 'BKRAPM3' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 ABKRAPM/2 0 0.5 0 TBKRAPM]}';
BKRAPM3B={'be' 'BKRAPM3' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 0 ABKRAPM/2 0 0.5 TBKRAPM]}';
BKRAPM4A={'be' 'BKRAPM4' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 ABKRAPM/2 0 0.5 0 TBKRAPM]}';
BKRAPM4B={'be' 'BKRAPM4' LBKRAPM/2 [ABKRAPM/2 GBKRAPM/2 0 ABKRAPM/2 0 0.5 TBKRAPM]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKRAPM1={'be' 'BKRAPM' LBKRAPM [ABKRAPM GBKRAPM/2 ABKRAPM/2 ABKRAPM/2 0.5 0.5 TBKRAPM]}';
BKRAPM2={'be' 'BKRAPM' LBKRAPM [ABKRAPM GBKRAPM/2 ABKRAPM/2 ABKRAPM/2 0.5 0.5 TBKRAPM]}';
BKRAPM3={'be' 'BKRAPM3' LBKRAPM [ABKRAPM GBKRAPM/2 ABKRAPM/2 ABKRAPM/2 0.5 0.5 TBKRAPM]}';
BKRAPM4={'be' 'BKRAPM4' LBKRAPM [ABKRAPM GBKRAPM/2 ABKRAPM/2 ABKRAPM/2 0.5 0.5 TBKRAPM]}';
% PM projections onto BSY HXR beam
ZBKRAPM1 =  SBKRAPM*cos(ABKRAPM0*1/2);
ZBKRAPM2 =  SBKRAPM*cos(ABKRAPM0*3/2);
ZBKRAPM3 =  SBKRAPM*cos(ABKRAPM0*5/2);
ZBKRAPM4 =  SBKRAPM*cos(ABKRAPM0*7/2);
DBKRAPM1A={'dr' '' ZBKRAPM1/2 []}';
DBKRAPM1B={'dr' '' ZBKRAPM1/2 []}';
DBKRAPM2A={'dr' '' ZBKRAPM2/2 []}';
DBKRAPM2B={'dr' '' ZBKRAPM2/2 []}';
DBKRAPM3A={'dr' '' ZBKRAPM3/2 []}';
DBKRAPM3B={'dr' '' ZBKRAPM3/2 []}';
DBKRAPM4A={'dr' '' ZBKRAPM4/2 []}';
DBKRAPM4B={'dr' '' ZBKRAPM4/2 []}';
% A-line merge bend 
GBRAM1 =  50.8E-3                         ;%2.0D38.37 gap height (m)
SBRAM1 =  1.025                           ;%2.0D38.37 straight length (m)
ABRAM1 =  0.23261117109E-2                ;%bend angle (rad)
LBRAM1 =  SBRAM1*ABRAM1/(2*sin(ABRAM1/2)) ;%path length (m)
TBRAM1 =  0.014303788803                  ;%bend roll (rad)
BRAM1A={'be' 'BRAM1' LBRAM1/2 [ABRAM1/2 GBRAM1/2 ABRAM1/2 0 0.5 0 TBRAM1]}';
BRAM1B={'be' 'BRAM1' LBRAM1/2 [ABRAM1/2 GBRAM1/2 0 ABRAM1/2 0 0.5 TBRAM1]}';
% define unsplit SBENs for BMAD ... not used by MAD
BRAM1={'be' 'BRAM' LBRAM1 [ABRAM1 GBRAM1/2 ABRAM1/2 ABRAM1/2 0.5 0.5 TBRAM1]}';
% A-bends
AARC =  -24*RADDEG             ;%total arc bend angle (24 degrees)
NBEND =  12                     ;%number of arc bends
%ABA   := AARC/Nbend             nominal arc bend angle
ABA =  -1.999526617334*RADDEG ;%arc bend angle per Transport deck
LBA =  3.024;
GBA =  0.06  ;%Blue Book value
B11A={'be' 'B11' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B11B={'be' 'B11' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B12A={'be' 'B12' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B12B={'be' 'B12' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B13A={'be' 'B13' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B13B={'be' 'B13' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B14A={'be' 'B14' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B14B={'be' 'B14' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B15A={'be' 'B15' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B15B={'be' 'B15' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B16A={'be' 'B16' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B16B={'be' 'B16' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B21A={'be' 'B21' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B21B={'be' 'B21' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B22A={'be' 'B22' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B22B={'be' 'B22' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B23A={'be' 'B23' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B23B={'be' 'B23' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B24A={'be' 'B24' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B24B={'be' 'B24' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B25A={'be' 'B25' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B25B={'be' 'B25' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
B26A={'be' 'B26' LBA/2 [ABA/2 GBA/2 ABA/2 0 0.5 0 0]}';
B26B={'be' 'B26' LBA/2 [ABA/2 GBA/2 0 ABA/2 0 0.5 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
B11={'be' 'B1' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B12={'be' 'B1' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B13={'be' 'B13' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B14={'be' 'B14' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B15={'be' 'B15' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B16={'be' 'B16' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B21={'be' 'B2' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B22={'be' 'B2' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B23={'be' 'B23' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B24={'be' 'B24' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B25={'be' 'B25' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
B26={'be' 'B26' LBA [ABA GBA/2 ABA/2 ABA/2 0.5 0.5 0]}';
% ESA bends (E158)
LD1S =  1.83;
LD2S =  3.45;
LD3S =  3.45;
AD1S =   0.022344631354;
AD2S =  -0.044690490267;
AD3S =   0.022345239962;
BXD1SA={'be' 'BXD1S' LD1S/2 [AD1S/2 0 0 0 0 0 0]}';
BXD1SB={'be' 'BXD1S' LD1S/2 [AD1S/2 0 0 0 0 0 0]}';
BXD2SA={'be' 'BXD2S' LD2S/2 [AD2S/2 0 0 0 0 0 0]}';
BXD2SB={'be' 'BXD2S' LD2S/2 [AD2S/2 0 0 0 0 0 0]}';
BXD3SA={'be' 'BXD3S' LD3S/2 [AD3S/2 0 0 0 0 0 0]}';
BXD3SB={'be' 'BXD3S' LD3S/2 [AD3S/2 0 0 0 0 0 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BXD1S={'be' 'BXD1S' LD1S [AD1S 0 0 0 0 0 0]}';
BXD2S={'be' 'BXD2S' LD2S [AD2S 0 0 0 0 0 0]}';
BXD3S={'be' 'BXD3S' LD3S [AD3S 0 0 0 0 0 0]}';
% ==============================================================================
% quadrupoles
% ------------------------------------------------------------------------------
LQ8CM =  2.0;
RQ8CM =  0.08/2;
LQ19 =  2.0;
RQ19 =  0.186/2;
LQ20 =  1.31318;
RQ20 =  8.25*0.0254/2;
LSQ =  0.55;
RSQ =  0.08/2;
% * the K-values below are for SC beam; also copy these settings 
%   to SETK2scA in "LCLS2sc_main.mad8"
% * settings for Cu beam are in SETK2cuA in "LCLS2cu_main.mad8"
% * settings for DASEL are in SETK2scDA in "LCLS2sc_main.mad8"
KQ10 =   0.04078118414  ;% 0.040732418682
KQ11 =  -0.035978491015 ;%-0.035470391686
KQ19 =   0.0288935235   ;% 0.028832646424
KQ20 =   0.011673337852 ;% 0.011866327361
KQ27 =  -0.069796542848 ;%-0.068187477866
KQ28 =   0.029206357304 ;% 0.029868541394
KQ30 =  -0.029497355276 ;%-0.029618830812
KQ38 =   0.034805766493 ;% 0.034798028844
Q10={'qu' 'Q10' LQ8CM/2 [KQ10 0]}';
Q11={'qu' 'Q11' LQ8CM/2 [KQ11 0]}';
Q19={'qu' 'Q19' LQ19/2 [KQ19 0]}';
Q20={'qu' 'Q20' LQ20/2 [KQ20 0]}';
Q27={'qu' 'Q27' LQ8CM/2 [KQ27 0]}';
Q28={'qu' 'Q28' LQ8CM/2 [KQ28 0]}';
Q30={'qu' 'Q30' LQ8CM/2 [KQ30 0]}';
Q38={'qu' 'Q38' LQ8CM/2 [KQ38 0]}';
KSQ =  0.0;
SQ27P5={'qu' 'SQ27P5' LSQ/2 [KSQ pi/4]}';
% ESA quads (E158)
LQSA =  1.327;
RQSA =  193.0E-3;
% E158 run value (P. Bosted)
KQ1SA =   0.016723215505;
KQ2SA =  -0.031838409505;
KQ3SA =   0.031838409505;
KQ4SA =  -0.016080013116;
Q1S={'qu' 'Q1S' LQSA/2 [KQ1SA 0]}';
Q2S={'qu' 'Q2S' LQSA/2 [KQ2SA 0]}';
Q3S={'qu' 'Q3S' LQSA/2 [KQ3SA 0]}';
Q4S={'qu' 'Q4S' LQSA/2 [KQ4SA 0]}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
D105={'dr' '' 5.5372 []}';
D106={'dr' '' 0.727 []}';
D107={'dr' '' 0.7755 []}';
D108={'dr' '' 3.84839 []}';
D109={'dr' '' 0.7755 []}';
D110={'dr' '' 3.84839 []}';
D111={'dr' '' 0.7755 []}';
D112={'dr' '' 15.74899 []}';
D113={'dr' '' 9.0997 []}';
D114={'dr' '' 5.94572 []}';
D115={'dr' '' 0.7755 []}';
D116={'dr' '' 3.84839 []}';
D117={'dr' '' 0.7755 []}';
D118={'dr' '' 3.84839 []}';
D119={'dr' '' 0.7755 []}';
D120={'dr' '' 1.744768 []}';%1.74477
D121={'dr' '' 1.525 []}';
D122={'dr' '' 1.925 []}';
D123={'dr' '' 38.1116 []}';
D124={'dr' '' 21.4778 []}';
D125={'dr' '' 5.04065 []}';
DPR2={'dr' '' 12.25174 []}';%wall to 3PR2 in ESA alcove
D201={'dr' '' 20.44174-DPR2{3} []}';
D202={'dr' '' 2.5 []}';
D203={'dr' '' 1.69 []}';
D204={'dr' '' 1.4865 []}';
D205={'dr' '' 1.413 []}';
D206={'dr' '' 2.603 []}';
D207={'dr' '' 1.013 []}';
D208={'dr' '' 31.04932 []}';
D209={'dr' '' 92.118 []}';
% drifts for diagnostic and correction devices
D002A={'dr' '' 0.090479 []}';
D002B={'dr' '' 1.654993 []}';
D002C={'dr' '' 0.0184 []}';
D002D={'dr' '' 2.466807 []}';
D002E={'dr' '' 0.34925 []}';
D002F={'dr' '' 4.3434 []}';
D002G={'dr' '' 6.213125 []}';
D002H={'dr' '' 0.3429 []}';
D002I={'dr' '' 0.447449 []}';
D003A={'dr' '' 0.128016 []}';
D003B={'dr' '' 1.609344 []}';
D003C={'dr' '' 0.331248 []}';
D003D={'dr' '' 0.628073 []}';
D003E={'dr' '' 0.2286 []}';
D003F={'dr' '' 0.4826 []}';
D003G={'dr' '' 0.3556 []}';
D003H={'dr' '' 0.415546 []}';
D004A={'dr' '' 0.204216 []}';
D004B={'dr' '' 0.581559 []}';
D005A={'dr' '' 0.762 []}';
D005B={'dr' '' 2.329 []}';
D005C={'dr' '' 5.402548 []}';
D101A={'dr' '' 7.405675 []}';
D101B={'dr' '' 3.2853 []}';
D101C={'dr' '' 0.635 []}';
D101D={'dr' '' 0.787 []}';
D101E={'dr' '' 0.534 []}';
D101F={'dr' '' 0.813 []}';
D101G={'dr' '' 0.685 []}';
D101H={'dr' '' 0.61 []}';
D101I={'dr' '' 1.27 []}';
D101J={'dr' '' 1.778 []}';
D101K={'dr' '' 0.457 []}';
D101L={'dr' '' 0.153 []}';
D101M={'dr' '' 0.177 []}';
D101N={'dr' '' 0.483 []}';
D101O={'dr' '' 0.483 []}';
D101P={'dr' '' 0.587 []}';
PMV={'dr' '' 0.4 []}';
D101Q={'dr' '' 0.589942 []}';
D102A={'dr' '' 1.06296 []}';
PM={'dr' '' 7.0 []}';
D102B={'dr' '' 1.06296 []}';
D103A={'dr' '' 66.20934 []}';
D103B={'dr' '' 0.615959 []}';
D103C={'dr' '' 2.850589 []}';
D103D={'dr' '' 0.15875 []}';
D105A={'dr' '' 0.808 []}';
D105B={'dr' '' 0.38 []}';
D105C={'dr' '' 0.478 []}';
D105D={'dr' '' 0.628 []}';
D105E={'dr' '' 0.684 []}';
D105F={'dr' '' 0.62 []}';
D105G={'dr' '' 0.88 []}';
D105H={'dr' '' 0.668 []}';
D105I={'dr' '' 0.3912 []}';
D108A={'dr' '' 0.829 []}';
D108B={'dr' '' 0.785 []}';
D108C={'dr' '' 2.23439 []}';
D110A={'dr' '' 2.98539 []}';
D110B={'dr' '' 0.863 []}';
D112A={'dr' '' 7.4348 []}';
D112B={'dr' '' 3.19319 []}';
D112C={'dr' '' 1.159 []}';
D112D={'dr' '' 1.302 []}';
D112E={'dr' '' 1.264 []}';
D112F={'dr' '' 0.723 []}';
D112G={'dr' '' 0.673 []}';
D113A={'dr' '' 1.32 []}';
D113B={'dr' '' 1.981 []}';
D113C={'dr' '' 5.7987 []}';
D114A={'dr' '' 4.47 []}';
D114B={'dr' '' 0.775 []}';
D114C={'dr' '' 0.70072 []}';
D116A={'dr' '' 2.81239 []}';
D116B={'dr' '' 1.036 []}';
D118A={'dr' '' 0.65139 []}';
D118B={'dr' '' 0.707 []}';
D118C={'dr' '' 1.131 []}';
D118D={'dr' '' 0.501 []}';
D118E={'dr' '' 0.858 []}';
D120B={'dr' '' 0.35 []}';
D120C={'dr' '' 0.513 []}';
D120A={'dr' '' D120{3}-D120B{3}-D120C{3} []}';%0.881768
D123A={'dr' '' 0.655 []}';
D123B={'dr' '' 0.673 []}';
D123C={'dr' '' 0.644 []}';
D123D={'dr' '' 0.657 []}';
D123E={'dr' '' 0.816 []}';
D123F={'dr' '' 0.445 []}';
D123G={'dr' '' 0.844 []}';
D123H={'dr' '' 31.9656 []}';
D123I={'dr' '' 0.729 []}';
D123J={'dr' '' 0.683 []}';
D124A={'dr' '' 0.629 []}';
D124B={'dr' '' 0.381 []}';
D124C={'dr' '' 0.635 []}';
D124D={'dr' '' 0.559 []}';
D124E={'dr' '' 1.041 []}';
D124F={'dr' '' 16.5857 []}';
D124G={'dr' '' 1.6471 []}';
% PM drifts along A-line
ZPCAPM =  0.1824 ;%length of PM collimator aligned along BSY HXR beam
LPCAPM1 =  ZPCAPM/cos(1*ABKRAPM);
LPCAPM2 =  ZPCAPM/cos(2*ABKRAPM);
LPCAPM3 =  ZPCAPM/cos(3*ABKRAPM);
LPCAPM4 =  ZPCAPM/cos(4*ABKRAPM);
LDAPM =  0.5951 ;%space between two PMs along A-line trajectory
LDAPM1 =  (LDAPM-LPCAPM1)/2;
LDAPM2 =  (LDAPM-LPCAPM2)/2;
LDAPM3 =  (LDAPM-LPCAPM3)/2;
LDAPM4 =  (LDAPM-LPCAPM4)/2;
DAPM1={'dr' '' LDAPM1 []}';
DAPM2={'dr' '' LDAPM2 []}';
DAPM2A={'dr' '' LDAPM2/2 []}';
DAPM2B={'dr' '' LDAPM2/2 []}';
DAPM3={'dr' '' LDAPM3 []}';
DAPM4={'dr' '' LDAPM4 []}';
LDA01 =  0.0471765+0.15 ;
LDA02 =  4.371494-LDA01-1.35/cos(4*ABKRAPM0);
LDA03 =  1.3206+1.35/cos(4*ABKRAPM0);
LDA04 =  47.451381526647;
LDBRDAS2 =  LBSP*cos(ABRDAS2*sin(TBRDAS2)/2)*cos(ABRDAS2*cos(TBRDAS2)/2)/ cos(ABRDAS2*cos(TBRDAS2));
LDA04B =  0.5;
LDA04C =  19.829173726034 ;
LDA04A =  LDA04-LDBRDAS2-LDA04B-LDA04C;
LDA05 =  0.5;
LDA06 =  0.5;
DA01={'dr' '' LDA01 []}';
DA02={'dr' '' LDA02 []}';
DA03={'dr' '' LDA03 []}';
DA03B={'dr' '' 0.6 []}';
DA03A={'dr' '' DA03{3}-DA03B{3} []}';
DBRDAS2A={'dr' '' LDBRDAS2/2 []}';
DBRDAS2B={'dr' '' LDBRDAS2/2 []}';
DRCDAS19={'dr' '' 0.0 []}';
DA04A={'dr' '' LDA04A []}';
DA04B={'dr' '' LDA04B []}';
DA04C={'dr' '' LDA04C []}';
DA05={'dr' '' LDA05 []}';
DA06={'dr' '' LDA06 []}';
DAMQ10={'dr' '' 0.9875 []}';
% PM drifts projected onto BSY HXR beamline
LDZAPM1 =  (LDAPM*cos(1*ABKRAPM0)-ZPCAPM)/2;
LDZAPM2 =  (LDAPM*cos(2*ABKRAPM0)-ZPCAPM)/2;
LDZAPM3 =  (LDAPM*cos(3*ABKRAPM0)-ZPCAPM)/2;
LDZAPM4 =  (LDAPM*cos(4*ABKRAPM0)-ZPCAPM)/2;
LDZA01 =   LDA01*cos(4*ABKRAPM0);
LDZA02 =   LDA02*cos(4*ABKRAPM0);
DZAPM1={'dr' '' LDZAPM1 []}';
DZAPM2={'dr' '' LDZAPM2 []}';
DZAPM2A={'dr' '' LDZAPM2/2 []}';
DZAPM2B={'dr' '' LDZAPM2/2 []}';
DZAPM3={'dr' '' LDZAPM3 []}';
DZAPM4={'dr' '' LDZAPM4 []}';
DZA01={'dr' '' LDZA01 []}';
DZA02={'dr' '' LDZA02 []}';
DSCAPM2={'dr' '' 0.0 []}';
% ==============================================================================
% coordinate rolls ... bend plane rotated to remove linac slope
% ------------------------------------------------------------------------------

% original A-line values
%ROLL1 : SROT, ANGLE= 0.014303845885    * ROLLON
%ROLL2 : SROT, ANGLE=-0.393462907527E-2 * ROLLON
%ROLL3 : SROT, ANGLE=-0.011395368282    * ROLLON
% new values
%ROLL4 : SROT, ANGLE= 0.014303788803    * ROLLON
%ROLL2 : SROT, ANGLE=-0.399639784046E-2 * ROLLON
%ROLL3 : SROT, ANGLE= 0.0               * ROLLON no ROLL3 per alignment group
ROLL2={'ro' 'ROLL2' 0 [-((0.014303788803-0.399639784046E-2)*ROLLON)]}';
ROLL3={'ro' 'ROLL3' 0 [-(0.0*ROLLON)]}';%no ROLL3 per alignment group
% ==============================================================================
% XCORs and YCORs
% ------------------------------------------------------------------------------
XCAPM2={'mo' 'XCAPM2' 0 []}';%type to be determined
A28X={'mo' 'A28X' 0 []}';
A32X={'mo' 'A32X' 0 []}';
YCAPM2={'mo' 'YCAPM2' 0 []}';%type to be determined
YCBSYA={'mo' 'YCBSYA' 0 []}';
A10Y={'mo' 'A10Y' 0 []}';
A18Y={'mo' 'A18Y' 0 []}';
A29Y={'mo' 'A29Y' 0 []}';
A33Y={'mo' 'A33Y' 0 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
% rename BPM10 and BPM12 to avoid conflicts
BPM10A={'mo' 'BPM10A' 0 []}';
BPM12A={'mo' 'BPM12A' 0 []}';
BPM17={'mo' 'BPM17' 0 []}';
BPM24={'mo' 'BPM24' 0 []}';
BPM28={'mo' 'BPM28' 0 []}';
BPM31={'mo' 'BPM31' 0 []}';
BPM32={'mo' 'BPM32' 0 []}';
% ==============================================================================
% profile monitors, wire scanners, wire arrays, synchrotron light ports, 
% spectrum foils, burn-through monitors, and Cu-target
% ------------------------------------------------------------------------------
PR10={'mo' 'PR10' 0 []}';
SYNC={'mo' 'SYNC' 0 []}';
PR18={'mo' 'PR18' 0 []}';
SP18={'mo' 'SP18' 0 []}';
PR20={'mo' 'PR20' 0 []}';
PR28={'mo' 'PR28' 0 []}';
PR33={'mo' 'PR33' 0 []}';
% new devices
YAGAPM={'mo' 'YAGAPM' 0 []}';%YAG profile monitor
PRBRAM1={'mo' 'PRBRAM1' 0 []}';%profile monitor, type to be determined
TGTBRAM1={'mo' 'TGTBRAM1' 0 []}';%secondary production Cu target
% ==============================================================================
% toroids and beam charge monitors
% ------------------------------------------------------------------------------
I10={'mo' 'I10' 0 []}';
I11={'mo' 'I11' 0 []}';
I24={'mo' 'I24' 0 []}';
I28={'mo' 'I28' 0 []}';
I29={'mo' 'I29' 0 []}';
% ==============================================================================
% collimators and slits
% ------------------------------------------------------------------------------
PC10={'dr' 'PC10' 0 []}';
PC12={'dr' 'PC12' 0 []}';
PC14={'dr' 'PC14' 0 []}';
PC17={'dr' 'PC17' 0 []}';
SL19={'dr' 'SL19' 0 []}';
SL10={'dr' 'SL10' 0 []}';
PC20={'dr' 'PC20' 0 []}';
PC24={'dr' 'PC24' 0 []}';
C24={'dr' 'C24' 0 []}';
PC26={'dr' 'PC26' 0 []}';
PC29={'dr' 'PC29' 0 []}';
C37={'dr' 'C37' 0 []}';
PCAPM1={'dr' 'PCAPM1' LPCAPM1 []}';
PCAPM2={'dr' 'PCAPM2' LPCAPM2 []}';
PCAPM3={'dr' 'PCAPM3' LPCAPM3 []}';
PCAPM4={'dr' 'PCAPM4' LPCAPM4 []}';
% 1" ID A-line collimator -- part of 2-hole copper collimator d/s of A-line PM
PCBSYA={'dr' 'PCBSYA' 0.45/cos(4*ABKRAPM0) []}';
% ==============================================================================
% vacuum components
% ------------------------------------------------------------------------------
IV10={'mo' 'IV10' 0 []}';
FV10={'mo' 'FV10' 0 []}';
IV26={'mo' 'IV26' 0 []}';
FV28={'mo' 'FV28' 0 []}';
% ==============================================================================
% points of interest
% ------------------------------------------------------------------------------
BEGB={'mo' 'BEGB' 0 []}';%start of A-line bending
ST22={'mo' 'ST22' 0 []}';%beam stopper
MARC={'mo' 'MARC' 0 []}';%match point
ENDB={'mo' 'ENDB' 0 []}';%end of A-line bending (final emittance)
ST29={'mo' 'ST29' 0 []}';%beam stopper
ALWALL={'mo' 'ALWALL' 0 []}';%upstream face of wall that separates A-line tunnel from alcove
ESAE={'mo' 'ESAE' 0 []}';%east wall of ESA
BMDE={'mo' 'BMDE' 0 []}';%Beam Dump East
% ==============================================================================
% beamlines
% ------------------------------------------------------------------------------
BKRAPM1_FULL=[BKRAPM1A,BKRAPM1B];
BKRAPM2_FULL=[BKRAPM2A,BKRAPM2B];
BKRAPM3_FULL=[BKRAPM3A,BKRAPM3B];
BKRAPM4_FULL=[BKRAPM4A,BKRAPM4B];
BRAM1_FULL=[BRAM1A,BRAM1B];
B11_FULL=[B11A,B11B];
B12_FULL=[B12A,B12B];
B13_FULL=[B13A,B13B];
B14_FULL=[B14A,B14B];
B15_FULL=[B15A,B15B];
B16_FULL=[B16A,B16B];
B21_FULL=[B21A,B21B];
B22_FULL=[B22A,B22B];
B23_FULL=[B23A,B23B];
B24_FULL=[B24A,B24B];
B25_FULL=[B25A,B25B];
B26_FULL=[B26A,B26B];
BXD1S_FULL=[BXD1SA,BXD1SB];
BXD2S_FULL=[BXD2SA,BXD2SB];
BXD3S_FULL=[BXD3SA,BXD3SB];
Q10_FULL=[Q10,Q10];
Q11_FULL=[Q11,Q11];
Q19_FULL=[Q19,Q19];
Q20_FULL=[Q20,Q20];
Q27_FULL=[Q27,Q27];
SQ27P5_FULL=[SQ27P5,SQ27P5];
Q28_FULL=[Q28,Q28];
Q30_FULL=[Q30,Q30];
Q38_FULL=[Q38,Q38];
Q1S_FULL=[Q1S,Q1S];
Q2S_FULL=[Q2S,Q2S];
Q3S_FULL=[Q3S,Q3S];
Q4S_FULL=[Q4S,Q4S];
SCAPM2=[XCAPM2,YCAPM2];
LD105=[D105A,PC10,D105B,IV10,D105C,FV10,D105D,BPM10A,D105E,I10,D105F,PR10,D105G,A10Y,D105H,I11,D105I];
LD108=[D108A,PC12,D108B,BPM12A,D108C];
LD110=[D110A,PC14,D110B];
LD112=[D112A,SYNC,D112B,PC17,D112C,BPM17,D112D,A18Y,D112E,PR18,D112F,SP18,D112G];
LD113=[D113A,SL19,D113B,SL10,D113C];
LD114=[D114A,PC20,D114B,PR20,D114C];
LD116=[D116A,ST22,D116B];
LD118=[D118A,PC24,D118B,BPM24,D118C,I24,D118D,C24,D118E];
LD120=[D120A,PC26,D120B,IV26,D120C];
LD123=[D123A,FV28,D123B,BPM28,D123C,I28,D123D,PR28,D123E,A28X,D123F,A29Y,D123G,ST29,D123H,PC29,D123I,I29,D123J];
LD124=[D124A,A32X,D124B,A33Y,D124C,BPM31,D124D,BPM32,D124E,PR33,D124F,C37,D124G];
% shared line with BSY
ALINEA=[BEGBSYA_1,BKRAPM1_FULL,DAPM1,PCAPM1,DAPM1,BKRAPM2_FULL,DAPM2A,DSCAPM2,DAPM2B,PCAPM2,DAPM2,BKRAPM3_FULL,DAPM3,PCAPM3,DAPM3,BKRAPM4_FULL,DAPM4,PCAPM4,DA01,DA02];
% separate line from BSY
ALINEB=[PCBSYA,DA03A,YCBSYA,DA03B,YAGAPM,DA04A,DBRDAS2A,DBRDAS2B,DA04B,DRCDAS19,ENDBSYA_1];
ALINEC=[BEGBSYA_2,DA04C,PRBRAM1,DA05,TGTBRAM1,DA06,BRAM1_FULL,ROLL2,DAMQ10,Q10_FULL,LD105,Q11_FULL,D106,BEGB,B11_FULL,D107,B12_FULL,LD108,B13_FULL,D109,B14_FULL,LD110,B15_FULL,D111,B16_FULL,LD112,Q19_FULL,LD113,Q20_FULL,LD114,B21_FULL,D115,B22_FULL,LD116,B23_FULL,D117,B24_FULL,LD118,B25_FULL,D119,B26_FULL,MARC,ROLL3,ENDB,LD120,Q27_FULL,D121,SQ27P5_FULL,D122,Q28_FULL,LD123,Q30_FULL,LD124,Q38_FULL,D125,ALWALL,DPR2,ENDBSYA_2];
ESAS=[D201,BXD1S_FULL,D202,BXD2S_FULL,D203,BXD3S_FULL,D204,Q1S_FULL,D205,Q2S_FULL,D206,Q3S_FULL,D207,Q4S_FULL,D208,ESAE,D209,BMDE];
ALINE=[ALINEA,ALINEB,ALINEC,ESAS];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc bypass line, plus match to LTU
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 07-AUG-2019, M. Woodley
%  * combine BYPi and FODOLa BEAMLINEs (changes Zbyp)
% 17-JUL-2019, M. Woodley
%  * relocate STBP34B/BTMBP34B per L. Borzenets
% ------------------------------------------------------------------------------
% 11-JUN-2019, M. Woodley
%  * change STBP34A/STBP34B from ST60-type to LCLS EBD-type per A. Ibrahimov
%  * move STBP34A/BTMBP34A and STBP34B/BTMBP34B u/s ~17 m per L. Borzenets
% 20-FEB-2019, M. Woodley
%  * move CBP33 ~20 cm u/s per A. Ibrahimov
% ------------------------------------------------------------------------------
% 07-JAN-2019, M. Woodley
%  * remove BTMSP1s, BTMSP2s, BTMSP3s, and BTMSP4s per RP-RPG-181130-MEM-01
% ------------------------------------------------------------------------------
% 17-OCT-2018, M. Woodley (per A. Ibrahimov)
%  * add CBP33 (PPS "collimator" plate w/o BTM)
% 31-MAY-2018, M. Woodley (per A. Ibrahimov)
%  * remove STBP34A (D2-type)
%  * STBP34B and STBP34C (ST60-type) move into STBP34A and STBP34B locations
%  * undefer STBP34A,B ... LCLS will pay for them
% ------------------------------------------------------------------------------
% 25-JAN-2018, M. Woodley
%  * set length of PCSP1S-4S to 2" per A. Ibrahimov
%  * remove PC90B per A. Ibrahimov
% 20-DEC-2017, M. Woodley
%  * remove BCS ACM IMBP28 per C. Clarke
% 02-NOV-2017, M. Woodley
%  * add sector boundary MARKERs
% ------------------------------------------------------------------------------
% 06-SEP-2017, Y. Nosochkov
%  * update positions of BCS collimators PCSP1S,2S,3S,4S and the corresponding
%    BTMs BTMSP1S,2S,3S,4S per RP-RPG-170802-MEM-01 (M. Santana)
%  * add deferred BCS collimator PC90B (M. Santana)
%  * defer stoppers STBP34a,b,c, and the corresponding BTMs BTMBP34a,b,c
%    to level 4 as they are not required for baseline (J. Welch, P. Emma)
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * move BPMBP32 0.060376 m downstream (M. Kosovsky)
% 16-FEB-2016, M. Woodley
%  * move Dogleg/Bypass boundary to Z= 1202.631303 m per G. DeContreras
%  * move RFBWSBP4 and WSBP4 to DLBM.xsif ... rename WSBPs
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * move BPMBP36 1.2 cm downstream (Alev)
%  * add a note that BTM behind stopper is part of the stopper design
%  * move BPMBP32 to upstream side of QBP32 (M. Kosovsky)
%  * move to baseline: BPMBP24, BPMBP35, IMBP28, PCSP3s, BTMSP3s, XCBP33,
%    YCBP33, PCSP4S, BTMSP4S, BTMBP34A, BTMBP34B, BTMBP34C
% ------------------------------------------------------------------------------
% 29-JUN-2016, M. Woodley
%  * adjust location of WOODDOOR (Z=3050.512)
% 24-JUN-2016, Y. Nosochkov
%  * change engineering type of the following correctors from "Bypass"
%    to "class-4": XCBP30 through XCBP34 and YCBP30 through YCBP34 (P. Emma)
%  * add deferred BTMBP34a, BTMBP34b, BTMBP34c behind the corresponding
%    PPS stoppers (S. Mao)
%  * move IMSP1s to just downstream of the BXSP2s (S. Mao)
%  * update engineering type designations of current monitors (J. Welch)
% ------------------------------------------------------------------------------
% 26-FEB-2016, M. Woodley
%  * add wood door at LI30/BSY boundary (WOODDOOR)
%  * remove SEQnn MARKers
% 26-FEB-2016, Y. Nosochkov
%  * move RFBWSBP4, WSBP4 to linac sector 12 and rename to RFBWSBP1, WSBP1
%    (see DLBM.xsif) (Tor)
%  * rename the remaining three sets of RFBWSBP/WSBP in this file with
%    numbers 2,3,4
%  * move BPMBP32, XCBP32, YCBP32 24" downstream (C.Iverson)
%  * remove IMSP2s (per S. Mao)
%  * move QBP28 0.3 m upstream to provide space for a longer spreader kicker
%  * move CYBP20, CYBP24 two sectors downstream to avoid interference with
%    FACET-II and change their names to CYBP22, CYBP26
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * move CYBP20, CXBP21, CYBP24, and CXBP25 0.381 m downstream per T. O'Heron
%  * set collimator gaps per P. Emma
% 25-SEP-2015, Y. Nosochkov
%  * make the CUSXR merge bend to appear in LCLS2scS line
% 24-AUG-2015, Y. Nosochkov
%  * add stripline BPMBP24, BPMBP35 (deferred @0) next to deferred
%    RFBBP24, RFBBP35 to improve orbit correction (per P. Emma)
%  * restore correctors XCBP33, YCBP33 (deferred at level @0)
%  * move CXBP34 1 m upstream of QBP34 for a higher beta-x
%  * adjust length of FODOLb, BYPM sections to accommodate the shifted
%    downstream SXR chicane
%  * adjust positions of QBP35, QBP36, QBP30, QBP31, QBP32, QBP33 and
%    corresponding devices
%  * adjust position of CXBP30 for optimal phase and beta function
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * add deferred BTMSP3s and BTMSP4s behind PCSP3s and PCSP4s (per S. Mao)
%  * move IMSP1s, IMSP2s, PCSP3s just d/s of BXSP3S (per S. Mao)
%  * remove QBP37, QBP38 and the corresponding BPMs/corrs
%  * rename STBP33a,STBP33b,STBP33c -> STBP34a,STBP34b,STBP34c and move them
%    close to the muon wall (per S. Mao)
%  * move CXBP34, PCSP4S ~6 m upstream
%  * update gaps of the halo collimators (per P. Emma)
%  * reduce length of halo collimators (CX.., CY..) from 8 cm to 6 cm (P. Emma)
%  * move CXBP30 ~30 m downstream for 100 m beta function (per P. Emma)
%  * adjust position of BPMBP36 (per T. O'Heron)
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * assign TYPEs to BCS devices ... defer at level 0
% 12-MAR-2015, Y. Nosochkov
%  * modify drifts downstream of QBP32 to include the CUSXR merge point
%  * add QBP37, QBP38 (with BPM & corrs) for optics match with CUSXR beamline
%  * adjust positions of QBP33, QBP34 for a better match with CUSXR
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * assign BPM TYPE attributes per PRD LCLSII-2.4-PR-0136
% 09-DEC-2014, Y. Nosochkov
%  * move STBP32 stopper to inside of the SXR spreader chicane and rename it
%    to STSP5s
%  * move D10 dump inside the muon wall in the BSY
%  * add BCS current monitor IMBP28 upstream of the spreader (S. Mao)
%  * add BCS current monitors IMSP1s, IMSP2s upstream of muon wall
%    in SXR (S. Mao)
%  * add BCS collimators PCSP3s, PCSP4s in SPS
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * rematch downstream end bypass line (matching subroutine MBYPSP)
%  * set TYPE="fast" for all wire scanners
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * rematch downstream end bypass line (matching subroutine MBYPSP)
% 13-OCT-2014, Y. Nosochkov
%  * remove XCBP37, YCBP37 and XCBP33, YCBP33 correctors as redundant
% 10-OCT-2014, Y. Nosochkov
%  * update the TYPE of (4) RFBPMs to indicate the non-baseline level "0"
% 07-AUG-2014, M. Woodley
%  * change "Q2MRK" to "MQBP23" to obey naming convention
%  * restore existing stripline BPMs BPMBP14, BPMPB16, BPMBP18, and BPMBP20;
%    add cavity BPMs near wire scanners
%  * decorate device TYPE attributes to indicate non-baseline status
% 30-JUL-2014, Y. Nosochkov
%  * adjust positions of QBP31, QBP32, QBP35, QBP36 to minimize beta functions
%  * remove quad QBP37
% 22-JUL-2014, Y. Nosochkov
%  * move 4 bypass betatron collimators further downstream
% 02-MAY-2014, M. Woodley
%  * add RWWAKEss MARKER at end of bypass line (for resistive wall wakefield)
% 01-MAY-2014, Y. Nosochkov
%  * replace BPMBP30, BPMBP33 with cavity BPMs RFBBP30, RFBBP33 (per J. Frisch)
% 23-APR-2014, Y. Nosochkov
%  * replace stripline BPMs BPMBP14, BPMBP16, BPMBP18, BPMBP20, BPMBP24,
%    BPMBP35 with cavity BPMs RFBBP14, RFBBP16, RFBBP18, RFBBP20, RFBBP24,
%    RFBBP35 (per J. Frisch)
% 15-APR-2014, Y. Nosochkov
%  * update collimator jaw aperture per LCLSII-2.4-PR-0095
% 09-APR-2014, Y. Nosochkov
%  * add SXR betatron collimators CXBP30, CXBP34
% 07-APR-2014, M. Woodley
%  * reorder some drift length parameter definitions and drift length
%    definitions to avoid using parameters/attributes before they are defined
% 04-APR-2014, Y. Nosochkov
%  * add BCS stopper STBP32 upstream of 3 PPS stoppers in SXR
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% 25-MAR-2014, Y. Nosochkov
%  * add marker D10Js for location of D10 dump face in SXR line
%  * remove BYKIKb, SPOILERb, TDKIKb, SPOILD2b
%  * change names: D2b -> STBP33a, ST60b -> STBP33b, ST61b -> STBP33c
% 06-MAR-2014, Y. Nosochkov
%  * minor matching update
% 26-FEB-2014, Y. Nosochkov
%  * rematch to the updated spreader
% 17-JAN-2014, Y. Nosochkov
%  * add QBP36, rematch to the updated spreader
% 18-DEC-2013, Y. Nosochkov
%  * update match to the spreader
% 16-DEC-2013, Y. Nosochkov
%  * match to the updated 3-way spreader with low R56
% 03-DEC-2013, Y. Nosochkov
%  * match to the updated spreader
% 21-NOV-2013, Y. Nosochkov
%  * rematch bypass quads for the 3-way spreader system
% 17-OCT-2013, M. Woodley
%  * merge Yuri's LTU.xsif into BYP.xsif ... this file now defines QBP13
%   (center) to MUWALL
% ------------------------------------------------------------------------------
% ==============================================================================
% dipoles
% ------------------------------------------------------------------------------
% single beam dumper vertical kicker (removed)
LKIKY =  1.0601 ;%kicker coil length per magnet (m) [41.737"; SA-380-330-02]
% ==============================================================================
% quadrupoles
% ------------------------------------------------------------------------------
KQY =   0.060580505638 ;%45 degree bypass FODO
QFY={'qu' 'QFY' LQM/2 [KQY 0]}';%dummy magnet
QDY={'qu' 'QDY' LQM/2 [-KQY 0]}';%dummy magnet
KQBP25 =   0.070273904791;
KQBP26 =  -0.10552161126;
KQBP27 =   0.11147451141;
KQBP35 =  -0.291127425586;
KQBP28 =   0.323836147473;
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQBP36 =   0.581699291896;
KQBP30 =  -0.590323263504;
KQBP31 =   0.613692078346;
KQBP32 =  -0.489569044425;
KQBP33 =  -0.372430827402;
KQBP34 =   0.548586085637;
QBP13={'qu' 'QBP13' LQM/2 [KQY 0]}';
QBP14={'qu' 'QBP14' LQM/2 [-KQY 0]}';
QBP15={'qu' 'QBP15' LQM/2 [KQY 0]}';
QBP16={'qu' 'QBP16' LQM/2 [-KQY 0]}';
QBP17={'qu' 'QBP17' LQM/2 [KQY 0]}';
QBP18={'qu' 'QBP18' LQM/2 [-KQY 0]}';
QBP19={'qu' 'QBP19' LQM/2 [KQY 0]}';
QBP20={'qu' 'QBP20' LQM/2 [-KQY 0]}';
QBP21={'qu' 'QBP21' LQM/2 [KQY 0]}';
QBP22={'qu' 'QBP22' LQM/2 [-KQY 0]}';
QBP23={'qu' 'QBP23' LQM/2 [KQY 0]}';
QBP24={'qu' 'QBP24' LQM/2 [-KQY 0]}';
QBP25={'qu' 'QBP25' LQM/2 [KQBP25 0]}';
QBP26={'qu' 'QBP26' LQM/2 [KQBP26 0]}';
QBP27={'qu' 'QBP27' LQM/2 [KQBP27 0]}';
QBP35={'qu' 'QBP35' LQM/2 [KQBP35 0]}';
QBP28={'qu' 'QBP28' LQM/2 [KQBP28 0]}';
QBP36={'qu' 'QBP36' LQM/2 [KQBP36 0]}';
QBP30={'qu' 'QBP30' LQM/2 [KQBP30 0]}';
QBP31={'qu' 'QBP31' LQM/2 [KQBP31 0]}';
QBP32={'qu' 'QBP32' LQM/2 [KQBP32 0]}';
QBP33={'qu' 'QBP33' LQM/2 [KQBP33 0]}';
QBP34={'qu' 'QBP34' LQM/2 [KQBP34 0]}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
% bypass drifts which locate BPMs, XCORs, YCORs, WSs, and collimators w.r.t.
% bypass line "2Q4" QUADs
LCM2A =  31.2135115 ;%places upstream face of muon wall at proper z-location
ZQBP35 =  28.5 ;%adjust position of QBP35
ZQBP36 =   0.0 ;%adjust position of QBP36
ZQBP30 =   0.0 ;%adjust position of QBP30
ZQBP31 =   0.0 ;%adjust position of QBP31
ZQBP32 =   0.0 ;%adjust position of QPB32
ZQBP33 =   0.0 ;%adjust position of QBP33
ZQBP34 =   0.0 ;%adjust position of QBP34
ZMRGCUS =   0.0 ;%adjust position of MRGCUSXR
% DCY : 1/2 dist. between bypass quads - from PEP-II deck
DCY={'dr' '' (101.6-LQM)/2 []}';
DCYSA={'dr' '' 15.468697 []}';%to sector boundary
DCYSB={'dr' '' DCY{3}-DCYSA{3} []}';
DCYC={'dr' '' 15.28728-ZQBP30 []}';
% D2Q4a : QUAD to BPM
% D2Q4b : BPM to XCOR
% D2Q4c : XCOR to YCOR
% D2Q4d : a+b+c+d=DCY
% DQ24e : YCOR to COLL
D2Q4A={'dr' '' 0.4598 []}';
D2Q4B={'dr' '' 0.7433 []}';
%D2Q4aa : DRIF, L=D2Q4a[L] -0.012
%D2Q4ba : DRIF, L=D2Q4b[L] +0.012
D2Q4AB={'dr' '' D2Q4A{3}+0.6096 []}';
D2Q4C={'dr' '' 0.2794 []}';
D2Q4D={'dr' '' DCY{3}-(D2Q4A{3}+D2Q4B{3}+D2Q4C{3}) []}';
DDCYD =  0.0 ;%adjust Z at BSYEND
DCYD={'dr' '' 35.977199997076+DDCYD+ZQBP31 []}';
DCYDB={'dr' '' 1.0 []}';
DCYDA={'dr' '' DCYD{3}-DCYDB{3}-LJAW []}';
DCYFA={'dr' '' 1.0 []}';
DCYFB={'dr' '' 0.5 []}';
DCYFC={'dr' '' 1.0 []}';
DCYFD={'dr' '' 5.952523028144+0.3 []}';
DCYFE={'dr' '' 12.43034602883-DCYFA{3}-DCYFB{3}-DCYFC{3}-DCYFD{3}+ZQBP36 []}';
DCYFEA={'dr' '' 2.512 []}';%3.0
DCYFEB={'dr' '' DCYFE{3}-DCYFEA{3} []}';
DCYG={'dr' '' 3.9034-ZQBP36+ZQBP30 []}';
DBP1B={'dr' '' 19.48139075 []}';
DBP2B={'dr' '' 0.0 []}';
DBP3B={'dr' '' 1.0 []}';
DBP3A={'dr' '' 10.02938-LQM-(D2Q4A{3}+D2Q4B{3}+D2Q4C{3})-DBP3B{3}-LJAW-ZQBP33+ZQBP34 []}';
DBP3AA={'dr' '' 5.091435 []}';%4.854935+0.2492
DBP3AB={'dr' '' DBP3A{3}-DBP3AA{3}-LPLATE []}';
LDCWL =  7.0;
DCWLB={'dr' '' 2.158425 []}';
DCWLA={'dr' '' LDCWL-LPLATE-DCWLB{3} []}';
D2Q4E={'dr' '' 1.651 []}';%1.27
D2Q4F={'dr' '' D2Q4D{3}-(D2Q4E{3}+LJAW) []}';
D2Q4H={'dr' '' 2.4 []}';
D2Q4G={'dr' '' D2Q4F{3}-D2Q4H{3} []}';
D2Q4G2={'dr' '' 0.1 []}';
D2Q4G1={'dr' '' D2Q4G{3}-D2Q4G2{3} []}';
D2Q4J={'dr' '' 1.0 []}';
D2Q4I={'dr' '' D2Q4D{3}-D2Q4J{3} []}';
D2Q4I2={'dr' '' 0.1 []}';
D2Q4I1={'dr' '' D2Q4I{3}-D2Q4I2{3} []}';
D2Q4K={'dr' '' 2.0 []}';
D2Q4L={'dr' '' 4.47139075-(D2Q4A{3}+D2Q4B{3}+D2Q4C{3})-ZQBP31+ZQBP32 []}';
D2Q4LB={'dr' '' 0.52015-0.060376 []}';
D2Q4LA={'dr' '' D2Q4L{3}-D2Q4LB{3} []}';
D2Q4LAA={'dr' '' 1.270097 []}';%1.282797
D2Q4LAB={'dr' '' D2Q4LA{3}-D2Q4LAA{3}-LPLATE []}';
D2Q4M={'dr' '' 72.3206715-0.6096-(D2Q4A{3}+D2Q4B{3}+D2Q4C{3})-LQM/2-ZQBP32+ZQBP33 []}';
D2Q4MA={'dr' '' 61.387806499999-LBRCUS-0.6096-ZQBP32+ZMRGCUS []}';
D2Q4MA1={'dr' '' 6.364706 []}';%6.128206+0.2492
D2Q4MA2={'dr' '' D2Q4MA{3}-D2Q4MA1{3}-LPLATE []}';
LSTEBD =  11.75*IN2M ;%length of EBD-type stopper 2*(3.125*in2m)
D2Q4MB={'dr' '' D2Q4M{3}-D2Q4MA{3}-LBRCUS []}';
D2Q4MBA={'dr' '' 2.12069 []}';%2.15244
D2Q4MBB={'dr' '' 4.916585 []}';%5.018185
D2Q4MBC={'dr' '' 1.26655 []}';%1.48925
D2Q4MBD={'dr' '' D2Q4MB{3}-D2Q4MBA{3}-D2Q4MBB{3}-D2Q4MBC{3}-LPLATE-2*LSTEBD []}';
D2Q4O={'dr' '' 8.58398-LDCWL-ZQBP34 []}';
D2Q4Q={'dr' '' 0.5 []}';
D2Q4S={'dr' '' D2Q4D{3}-LQM/2+ZQBP35 []}';
D2Q4SA={'dr' '' 64.723997 []}';
D2Q4SB={'dr' '' D2Q4S{3}-D2Q4SA{3} []}';
D2Q4T={'dr' '' D2Q4D{3}-LQM/2-ZQBP35-0.3 []}';
% ==============================================================================
% collimators
% ------------------------------------------------------------------------------
CXBP21={'dr' 'CXBP21' LJAW []}';
CYBP22={'dr' 'CYBP22' LJAW []}';
CXBP25={'dr' 'CXBP25' LJAW []}';
CYBP26={'dr' 'CYBP26' LJAW []}';
CXBP30={'dr' 'CXBP30' LJAW []}';
CXBP34={'dr' 'CXBP34' LJAW []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMBP13={'mo' 'BPMBP13' 0 []}';
BPMBP14={'mo' 'BPMBP14' 0 []}';
BPMBP15={'mo' 'BPMBP15' 0 []}';
BPMBP16={'mo' 'BPMBP16' 0 []}';
BPMBP17={'mo' 'BPMBP17' 0 []}';
BPMBP18={'mo' 'BPMBP18' 0 []}';
BPMBP19={'mo' 'BPMBP19' 0 []}';
BPMBP20={'mo' 'BPMBP20' 0 []}';
BPMBP21={'mo' 'BPMBP21' 0 []}';
BPMBP22={'mo' 'BPMBP22' 0 []}';
BPMBP23={'mo' 'BPMBP23' 0 []}';%2/22/11
BPMBP24={'mo' 'BPMBP24' 0 []}';%to be replaced by RF BPM later
BPMBP25={'mo' 'BPMBP25' 0 []}';%2/22/11
BPMBP26={'mo' 'BPMBP26' 0 []}';%2/22/11
BPMBP27={'mo' 'BPMBP27' 0 []}';%2/22/11
BPMBP28={'mo' 'BPMBP28' 0 []}';%2/22/11
BPMBP35={'mo' 'BPMBP35' 0 []}';%to be replaced by RF BPM later
BPMBP36={'mo' 'BPMBP36' 0 []}';
BPMBP31={'mo' 'BPMBP31' 0 []}';
BPMBP32={'mo' 'BPMBP32' 0 []}';
BPMBP34={'mo' 'BPMBP34' 0 []}';
RFBWSBP2={'mo' 'RFBWSBP2' 0 []}';
RFBWSBP3={'mo' 'RFBWSBP3' 0 []}';
RFBWSBP4={'mo' 'RFBWSBP4' 0 []}';
RFBBP24={'mo' 'RFBBP24' 0 []}';%4/23/14
RFBBP35={'mo' 'RFBBP35' 0 []}';%4/23/14
RFBBP30={'mo' 'RFBBP30' 0 []}';
RFBBP33={'mo' 'RFBBP33' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCBP13={'mo' 'XCBP13' 0 []}';
XCBP14={'mo' 'XCBP14' 0 []}';
XCBP15={'mo' 'XCBP15' 0 []}';
XCBP16={'mo' 'XCBP16' 0 []}';
XCBP17={'mo' 'XCBP17' 0 []}';
XCBP18={'mo' 'XCBP18' 0 []}';
XCBP19={'mo' 'XCBP19' 0 []}';
XCBP20={'mo' 'XCBP20' 0 []}';
XCBP21={'mo' 'XCBP21' 0 []}';
XCBP22={'mo' 'XCBP22' 0 []}';
XCBP23={'mo' 'XCBP23' 0 []}';%2/22/11
XCBP24={'mo' 'XCBP24' 0 []}';%4/18/13
XCBP25={'mo' 'XCBP25' 0 []}';%4/18/13
XCBP26={'mo' 'XCBP26' 0 []}';%4/18/13
XCBP27={'mo' 'XCBP27' 0 []}';%4/18/13
XCBP35={'mo' 'XCBP35' 0 []}';%10/1/13
XCBP28={'mo' 'XCBP28' 0 []}';%4/18/13
%XCBP36 : HKIC, TYPE="class-4"  remove
XCBP30={'mo' 'XCBP30' 0 []}';
XCBP31={'mo' 'XCBP31' 0 []}';
XCBP32={'mo' 'XCBP32' 0 []}';
XCBP33={'mo' 'XCBP33' 0 []}';%restore
XCBP34={'mo' 'XCBP34' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCBP13={'mo' 'YCBP13' 0 []}';
YCBP14={'mo' 'YCBP14' 0 []}';
YCBP15={'mo' 'YCBP15' 0 []}';
YCBP16={'mo' 'YCBP16' 0 []}';
YCBP17={'mo' 'YCBP17' 0 []}';
YCBP18={'mo' 'YCBP18' 0 []}';
YCBP19={'mo' 'YCBP19' 0 []}';
YCBP20={'mo' 'YCBP20' 0 []}';
YCBP21={'mo' 'YCBP21' 0 []}';
YCBP22={'mo' 'YCBP22' 0 []}';
YCBP23={'mo' 'YCBP23' 0 []}';%2/22/11
YCBP24={'mo' 'YCBP24' 0 []}';%4/18/13
YCBP25={'mo' 'YCBP25' 0 []}';%4/18/13
YCBP26={'mo' 'YCBP26' 0 []}';%4/18/13
YCBP27={'mo' 'YCBP27' 0 []}';%4/18/13
YCBP35={'mo' 'YCBP35' 0 []}';%10/1/13
YCBP28={'mo' 'YCBP28' 0 []}';%4/18/13
%YCBP36 : VKIC, TYPE="class-4"  remove
YCBP30={'mo' 'YCBP30' 0 []}';
YCBP31={'mo' 'YCBP31' 0 []}';
YCBP32={'mo' 'YCBP32' 0 []}';
YCBP33={'mo' 'YCBP33' 0 []}';%restore
YCBP34={'mo' 'YCBP34' 0 []}';
% ==============================================================================
% diagnostics, etc.
% ------------------------------------------------------------------------------
WSBP2={'mo' 'WSBP2' 0 []}';
WSBP3={'mo' 'WSBP3' 0 []}';
WSBP4={'mo' 'WSBP4' 0 []}';
STBP34A={'mo' 'STBP34A' LSTEBD []}';%LCLS EBD-type stopper
BTMBP34A={'mo' 'BTMBP34A' 0 []}';%Burn-Through-Monitor behind STBP34A
STBP34B={'mo' 'STBP34B' LSTEBD []}';%LCLS EBD-type stopper
BTMBP34B={'mo' 'BTMBP34B' 0 []}';%Burn-Through-Monitor behind STBP34B
PCSP1S={'mo' 'PCSP1S' LPLATE []}';%shielding plate
PCSP2S={'mo' 'PCSP2S' LPLATE []}';%shielding plate
PCSP3S={'mo' 'PCSP3S' LPLATE []}';%shielding plate
PCSP4S={'mo' 'PCSP4S' LPLATE []}';%shielding plate
PCBP33={'mo' 'PCBP33' LPLATE []}';%shielding plate (no BTM)
% ==============================================================================
% MARKER points
% ------------------------------------------------------------------------------
% MQBP23 : QBP23 (Q285330T) quad center (Z=2270.531303)
% S100B  : Station-100B is same Z as Station-100, but off axis in X & Y
MQBP13={'mo' 'MQBP13' 0 []}';%QBP13 FODO quad center ... Z=1254.531303 (a.k.a. "QB01")
MQBP23={'mo' 'MQBP23' 0 []}';
S100B={'mo' 'S100B' 0 []}';
RWWAKE2={'mo' 'RWWAKE2' 0 []}';%bypass line beampipe wake applied here
LTUSPLIT={'mo' 'LTUSPLIT' 0 []}';%SXR/HXR/Dump split point
MRGCUSXR={'mo' 'MRGCUSXR' 0 []}';%merge point (with CUSXR)
% sector boundaries (ZBEG=101.6*(n-1); ZEND=101.6*n)
BPN12END={'mo' 'BPN12END' 0 []}';
BPN13BEG={'mo' 'BPN13BEG' 0 []}';
BPN13END={'mo' 'BPN13END' 0 []}';
BPN14BEG={'mo' 'BPN14BEG' 0 []}';
BPN14END={'mo' 'BPN14END' 0 []}';
BPN15BEG={'mo' 'BPN15BEG' 0 []}';
BPN15END={'mo' 'BPN15END' 0 []}';
BPN16BEG={'mo' 'BPN16BEG' 0 []}';
BPN16END={'mo' 'BPN16END' 0 []}';
BPN17BEG={'mo' 'BPN17BEG' 0 []}';
BPN17END={'mo' 'BPN17END' 0 []}';
BPN18BEG={'mo' 'BPN18BEG' 0 []}';
BPN18END={'mo' 'BPN18END' 0 []}';
BPN19BEG={'mo' 'BPN19BEG' 0 []}';
BPN19END={'mo' 'BPN19END' 0 []}';
BPN20BEG={'mo' 'BPN20BEG' 0 []}';
BPN20END={'mo' 'BPN20END' 0 []}';
BPN21BEG={'mo' 'BPN21BEG' 0 []}';
BPN21END={'mo' 'BPN21END' 0 []}';
BPN22BEG={'mo' 'BPN22BEG' 0 []}';
BPN22END={'mo' 'BPN22END' 0 []}';
BPN23BEG={'mo' 'BPN23BEG' 0 []}';
BPN23END={'mo' 'BPN23END' 0 []}';
BPN24BEG={'mo' 'BPN24BEG' 0 []}';
BPN24END={'mo' 'BPN24END' 0 []}';
BPN25BEG={'mo' 'BPN25BEG' 0 []}';
BPN25END={'mo' 'BPN25END' 0 []}';
BPN26BEG={'mo' 'BPN26BEG' 0 []}';
BPN26END={'mo' 'BPN26END' 0 []}';
BPN27BEG={'mo' 'BPN27BEG' 0 []}';
BPN27END={'mo' 'BPN27END' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
QBP13_FULL=[QBP13,MQBP13,QBP13];
QBP14_FULL=[QBP14,QBP14];
QBP15_FULL=[QBP15,QBP15];
QBP16_FULL=[QBP16,QBP16];
QBP17_FULL=[QBP17,QBP17];
QBP18_FULL=[QBP18,QBP18];
QBP19_FULL=[QBP19,QBP19];
QBP20_FULL=[QBP20,QBP20];
QBP21_FULL=[QBP21,QBP21];
QBP22_FULL=[QBP22,QBP22];
QBP23_FULL=[QBP23,MQBP23,QBP23];
QBP24_FULL=[QBP24,QBP24];
QBP25_FULL=[QBP25,QBP25];
QBP26_FULL=[QBP26,QBP26];
QBP27_FULL=[QBP27,QBP27];
QBP35_FULL=[QBP35,QBP35];
QBP28_FULL=[QBP28,QBP28];
QBP36_FULL=[QBP36,QBP36];
QBP30_FULL=[QBP30,QBP30];
QBP31_FULL=[QBP31,QBP31];
QBP32_FULL=[QBP32,QBP32];
QBP33_FULL=[QBP33,QBP33];
QBP34_FULL=[QBP34,QBP34];
FODO=[QFY,DCY,DCY,QDY,QDY,DCY,DCY,QFY];
FODOLA=[BEGBYP,RFBWSBP2,D2Q4I2,WSBP2,D2Q4J,DCYSA,BPN12END,BPN13BEG,DCYSB,QBP13_FULL,D2Q4A,BPMBP13,D2Q4B,XCBP13,D2Q4C,YCBP13,D2Q4D,DCYSA,BPN13END,BPN14BEG,DCYSB,QBP14_FULL,D2Q4A,BPMBP14,D2Q4B,XCBP14,D2Q4C,YCBP14,D2Q4I1,RFBWSBP3,D2Q4I2,WSBP3,D2Q4J,DCYSA,BPN14END,BPN15BEG,DCYSB,QBP15_FULL,D2Q4A,BPMBP15,D2Q4B,XCBP15,D2Q4C,YCBP15,D2Q4D,DCYSA,BPN15END,BPN16BEG,DCYSB,QBP16_FULL,D2Q4A,BPMBP16,D2Q4B,XCBP16,D2Q4C,YCBP16,D2Q4I1,RFBWSBP4,D2Q4I2,WSBP4,D2Q4J,DCYSA,BPN16END,BPN17BEG,DCYSB,QBP17_FULL,D2Q4A,BPMBP17,D2Q4B,XCBP17,D2Q4C,YCBP17,D2Q4D,DCYSA,BPN17END,BPN18BEG,DCYSB,QBP18_FULL,D2Q4A,BPMBP18,D2Q4B,XCBP18,D2Q4C,YCBP18,D2Q4D,DCYSA,BPN18END,BPN19BEG,DCYSB,QBP19_FULL,D2Q4A,BPMBP19,D2Q4B,XCBP19,D2Q4C,YCBP19,D2Q4D,DCYSA,BPN19END,BPN20BEG,DCYSB,QBP20_FULL,D2Q4A,BPMBP20,D2Q4B,XCBP20,D2Q4C,YCBP20,D2Q4D,DCYSA,BPN20END,BPN21BEG,DCYSB,QBP21_FULL,D2Q4A,BPMBP21,D2Q4B,XCBP21,D2Q4C,YCBP21,D2Q4E,CXBP21,D2Q4F,DCYSA,BPN21END,BPN22BEG,DCYSB,QBP22_FULL,D2Q4A,BPMBP22,D2Q4B,XCBP22,D2Q4C,YCBP22,D2Q4E,CYBP22,D2Q4F,DCYSA,BPN22END,BPN23BEG,DCYSB,QBP23_FULL,D2Q4A,BPMBP23,D2Q4B,XCBP23,D2Q4C,YCBP23,D2Q4D,DCYSA,BPN23END,BPN24BEG,DCYSB,QBP24_FULL,D2Q4A,BPMBP24,RFBBP24,D2Q4B,XCBP24,D2Q4C,YCBP24,D2Q4D,DCYSA,BPN24END,BPN25BEG,DCYSB,QBP25_FULL,D2Q4A,BPMBP25,D2Q4B,XCBP25,D2Q4C,YCBP25,D2Q4E,CXBP25,D2Q4F,DCYSA,BPN25END,BPN26BEG,DCYSB,QBP26_FULL,D2Q4A,BPMBP26,D2Q4B,XCBP26,D2Q4C,YCBP26,D2Q4E,CYBP26,D2Q4F,DCYSA,BPN26END,BPN27BEG,DCYSB,QBP27_FULL,D2Q4A,BPMBP27,D2Q4B,XCBP27,D2Q4C,YCBP27,D2Q4SA,BPN27END,D2Q4SB,QBP35_FULL,D2Q4A,BPMBP35,RFBBP35,D2Q4B,XCBP35,D2Q4C,YCBP35,D2Q4T,QBP28_FULL,D2Q4A,BPMBP28,D2Q4B,XCBP28,D2Q4C,YCBP28,D2Q4Q,LTUSPLIT,RWWAKE2,ENDBYP];
FODOLB=[DCYFA,DCYFB,DCYFC,DCYFD,S100B,DCYFEA,WOODDOOR];
FODOLC=[DCYFEB,QBP36_FULL,D2Q4A,BPMBP36,D2Q4B,D2Q4C ,DCYG ,QBP30_FULL,D2Q4A,RFBBP30,D2Q4B,XCBP30,D2Q4C,YCBP30,DCYC];
FODOL=[FODOLA,SPRDS,FODOLB,FODOLC];
BYPM1=[DCYDA ,CXBP30 ,DCYDB,QBP31_FULL,D2Q4A ,BPMBP31,D2Q4B,XCBP31,D2Q4C,YCBP31,D2Q4LAA,PCSP1S,D2Q4LAB,BPMBP32,D2Q4LB,QBP32_FULL,D2Q4AB,D2Q4B,XCBP32,D2Q4C,YCBP32,D2Q4MA1,PCSP2S,D2Q4MA2];
BYPM2=[D2Q4MBA,PCBP33,D2Q4MBB,STBP34A,BTMBP34A,D2Q4MBC,STBP34B,BTMBP34B,D2Q4MBD,DBP2B,QBP33_FULL,D2Q4A,RFBBP33,D2Q4B,XCBP33,D2Q4C,YCBP33,DBP3AA,PCSP3S,DBP3AB,CXBP34,DBP3B,QBP34_FULL,D2Q4A,BPMBP34,D2Q4B,XCBP34,D2Q4C,YCBP34,D2Q4O,DCWLA,PCSP4S,DCWLB];
BYPM=[BYPM1,BRCUS1A,BRCUS1B,MRGCUSXR,BYPM2];
BYPASS=[FODOL,BYPM];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc LTU and dump
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 05-NOV-2019, M. Woodley
%  * add BCS "collimator" plates per E. Johnson spreadsheet (10/24/2019)
%  * remove LCLS CX31 per D. Hanquist
% 09-SEP-2019, M. Woodley
%  * reinstall LTUH BLTOF per D. Bohler
% 05-SEP-2019, M. Woodley
%  * change gap height of BX31/32/35/36 (now 0.68D102.36T) to 0.679"
%  * change gap height of BX31B/32B (now 1.06D103.3T) to 1.06"
% 19-AUG-2019, M. Woodley
%  * remove RFBPM's associated with XLEAP-II undulators per G. Kraft
% 24-JUL-2019, M. Woodley
%  * new LTUH/LTUS BTM complement and locations per RP-RPG-170714-MEM-01-R5 ...
%    installation locations per E. Johnson
%  * relocate TDUNDB and PCMUONB per T. O'Heron
% 17-JUL-2019, M. Woodley
%  * reinstall OTR30 per P. Krejcik
%  * relocate TDUNDB and PCMUONB per T. O'Heron
% ------------------------------------------------------------------------------
% 06-JUN-2019, M. Woodley
%  * adjust location of BSY dump face per A. Ibrahimov
% 28-MAY-2019, M. Woodley
%  * remove LTUS BFWXL1, BFWXL2, BFWXL3, BFWXL4 per G. Kraft
%  * remove LTUH OTR30 per G. Kraft
%  * add XCXL1/YCXL1 u/s of UMXL1, amd XCXL2/YCXL2 u/s of UMXL3 per T. O'Heron
%  * flip RFBXL1-4 per T. O'Heron ... each moves 0.61" d/s
% 23-MAY-2019, M. Woodley
%  * move TDKIKS and PCTDKIK1-4 u/s 0.020651 m per T. O'Heron
%  * adjust BYKIK1S/BYKIK2S separation per T. O'Heron
% 24-APR-2019, M. Woodley
%  * fix edge angle definitions for XLEAP-II self-seeding chicane per Yuri
% 20-FEB-2019, M. Woodley
%  * remove CY32, CX35, and CY36 per D. Hanquist (reconfigured as CYBX32,
%    CXQT22, and CYBX36 respectively)
% ------------------------------------------------------------------------------
% 07-JAN-2019, M. Woodley
%  * remove BTMBSY3, BTMBSY4, and BTMBSY5 per RP-RPG-181130-MEM-01
% 24-JAN-2019, M. Woodley
%  * move CC36 5.8" d/s per T. O'Heron
% ------------------------------------------------------------------------------
% 24-NOV-2018, M. Woodley
%  * EBD dump face to BTM face = 61.120" (per Alev)
% 09-NOV-2018, M. Woodley
%  * move CC32 1.2924 m d/s per T. O'Heron
%  * move WSVM2 0.0046 m d/s per T. O'Heron
% 29-OCT-2018, M. Woodley
%  * add XLEAP-II components (4 undulators, self-seeding chicane, wiggler)
%    > wiggler and undulators scale with Eu
% 19-OCT-2018, M. Woodley
%  * move BTM06 d/s 4 cm per T. O'Heron
% 11-OCT-2018, M. Woodley
%  * use average measured FINT for 0.788D11.50's
% 04-OCT-2018, M. Woodley
%  * include alternative DC extraction into CUSXR:
%    - change length of DBSY52b (moves BEGCLTH2 and BEGCLTS u/s 0.621262 m)
%    - change definition of DBSY52c
%  * undefer all BCS BTMs listed in RP-RPG-170714-MEM-01-R1 (Table 1)
% 24-SEP-2018, M. Woodley
%  * defer OTRDMPB (level 1) per D. Hanquist
% 10-SEP-2018, M. Woodley
%  * set TYPE of "YAGPSI" (in LTUH) to "YAG-PAL", as in LCLS
% 15-AUG-2018, M. Woodley
%  * remove BXKIK1, SPOILER1, and TDKIK1 (replaced by STCLTS)
% 06-AUG-2018, M. Woodley
%  * move LCLS XLEAP self-seeding chicane to LTUS (between QUM3B and QUM4B)
% 26-JUL-2018, Y. Nosochkov
%  * add BYKIK1S,2S, BPMBYKS, SPOILERS and TDKIKS to SXR (P. Krejcik, A. Brachmann)
% 15-MAY-2018, M. Woodley
%  * PCPM1L/PCPM1LB and PCPM2L/PCPM2LB are aligned along the beamline (not
%    pitched/yawed)
% 12-MAR-2018, M. Woodley
%  * move PC119 to its present location (Z=3191 (center)) per A. Ibrahimov
%  * move CXQ6 to Z=3202.672 (center) per L. Borzenets
%  * add PCBSY5 (2" long) at Z=3203.2 (d/s face) per L. Borzenets
% ------------------------------------------------------------------------------
% 30-JAN-2018, M. Woodley
%  * set length of PCBSY3 and PCBSY4 to 2" per A. Ibrahimov
%  * remove PCBSY1/BTMBSY1 per A. Ibrahimov
%  * change complement/locations of BCS BTMs in BTH per RP-RPG-170714-MEM-01-R1
%    > BTM_X352 removed
%    > BTM06 has the wrong Z and needs to be relocated
% 20-DEC-2017, M. Woodley
%  * change engineering type of BX31B,32B from "1.0D103.3T" to "1.14D103.3T"
%    NOTE: don't change gap until new magnetic measurements are complete
%  * use measured FINT (0.5513) for BYD1B, BYD2B, and BYD3B
%  * remove BCS ACMs IMDUMPH and IMDUMPS per C. Clarke
% ------------------------------------------------------------------------------
% 06-SEP-2017, Y. Nosochkov
%  * update aperture size of PCMUON and PCMUONB (P. Emma)
%  * reduce gap of BX31B,32B to 1.0 inch and change engineering type to
%    1.0D103.3T (J. Amann) -- this is to allow these bends to be on the same
%    string with BYD1B,2B,3B
%  * update positions and aperture of BSC collimators and BTMs:
%    PCBSY3/BTMBSY3, PCBSY4/BTMBSY4, PC90, PC119 per RP-RPG-170802-MEM-01
%    (M. Santana);
%    notes: 1) position of PC119 is adjusted by +45 cm to avoid interference 
%    with CXQ6; 2) PCBSY3 may interfere with CuSXR line
% 09-AUG-2017, M. Woodley
%  * move wiggler definitions to top of file (for BMAD compatability)
% ------------------------------------------------------------------------------
% 08-MAY-2017, M. Woodley
%  * add 0.000001 m to LDBSY00 to align downstream Z-locations with 06MAR17
%  * put XCUM3 back where it was prior to XLEAP
%  * set D2, ST60, and ST61 lengths ... remove half-drifts
%  * undefer YCBSYQ1, XCBSYQ2, and XCBSYQ3 ... installed as part of BSY
%    Reconfiguration
%  * set minimum ID of PCPM1L/PCPM1LB to 1.125" per E. Ortiz
% 05-MAY-2017, Y. Nosochkov
%  * Update FINT, FINTX values in BX31B, BX32B to 0.4297 (M. Woodley)
% ------------------------------------------------------------------------------
% 02-MAR-2017, M. Woodley
%  * add XLEAP components between QUM2 and QUM3 (Kwig=0 ... fully open gap)
%  * assign WIRE TYPEs
%  * remove WS35 and WS36 (LTUH) ... not installed per D. Bohler, A. Cedillos
% 24-FEB-2017, Y. Nosochkov
%  * move VV999, VV999b 0.05 m downstream (D. Bruch)
%  * move RFBHX12 0.129 m upstream (from UND to LTUH) (D. Bruch)
%  * add toroids IMBSY1B, IMBSY2B, IMBSY3B as a backup for IMBSY1, IMBSY2,
%    IMBSY3 (K. Grouev); they are un-deferred since they will be installed
%  * update positions of IMBSY2, IMBSY3 (K. Grouev)
%  * update some drift names
%  * add deferred PCBSYH collimator -- it is HXR part of 2-hole copper
%    collimator downstream of A-line pulsed magnets
%  * move BPMBSYQ1 0.017624 m downstream to Z=3050.7319 m (K. Grouev)
%  * per recent measurements update Z-positions in BSY for:
%    D2 (-0.349426 m) -> Z=3192.8882 m, ST60 (-0.282226 m) -> Z=3194.3270 m,
%    DM60 (-0.342826 m) -> 3195.1480 m (K. Grouev)
%  * add new (deferred) HXR BTM_X352 at Z=3334.2 m (M. Santana, J. Stieber)
%  * move BTM_1B through BTM_6B, and BTM_8B, BTM_9B in SXR,
%    add deferred BTM_X352 in HXR (M. Santana, RP-RPG-170202-MEM-01-DRAFT)
%  * update aperture of PCPM1L, PCPM1LB, PCPM2L, PCPM2LB per present
%    engineering design (A. Ibrahimov)
% ------------------------------------------------------------------------------
% 23-NOV-2016, Y. Nosochkov
%  * change "1.259Q3.5" to "1.26Q3.5"
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * move definition of DRFB drift from common.xsif
%  * move BPMBSYQ1 0.0585 m downstream (K. Grouev)
%  * move BPMDL13, BPMDL16, BPMDL17 to the downstream side of a corresponding
%    collimator (J. Stieber)
%  * increase vertical half-aperture of PCMUON to 4 mm to satisfy BSC,
%    however it is an existing device, so it will need to be either rebuilt
%    or removed (J. Welch)
%  * make half-aperture of PCMUONB equal to 4 mm to satisfy BSC
%  * increase vertical half-aperture of PCPM2L, PCPM2LB to 37 mm to satisfy
%    BSC, but note that PCPM2L is an existing device
%  * move to baseline: Q50Q1, Q50Q2, IMBSY1, IMBSY2, IMBSY3, BPMBSYQ1,
%    BPMBSYQ2, PCBSY1, BTMBSY1, BPMBSYQ4, PCBSY3, BTMBSY3, PCBSY4, BTMBSY4,
%    XCVB2, BTM_1B through BTM_9B, XCVB2B, BPMEM4B, BPME32B, BPME34B, BPME36B,
%    IMDUMPH, IMDUMPS, BPMDD, BPMDDB
% ------------------------------------------------------------------------------
% 29-JUN-2016, M. Woodley
%  * adjust location of WOODDOOR (Z=3050.512)
%  * undefer OTRDMP and OTRDMPB
%  * BSY BPM names per R. Iverson and S. Hoobler
% 24-JUN-2016, Y. Nosochkov
%  * change engineering type "R56" to "0.788D11.50" (J. Amann)
%  * remove deferred BXKIK2 and change the type of deferred BXKIK1 to
%    1.26D18.43 (DC bend) (Tor, J. Amann)
%  * replace existing deferred Q50Q1 with a larger aperture quad type 2Q10 
%    to provide enough aperture for the kicked beam
%  * change the type of BPMBSY1 from Stripline-6 to Stripline-5 to
%    match the aperture of "2Q10" Q50Q1
%  * change the type of BPME31B,...,BPME36B from Stripline-2 to Stripline-1
%    (E. Kraft, J. Stieber)
%  * change the type of BPMDL11,...,BPMDL19 from Stripline-2 to
%    Stripline-5 and move them outside of the quads (E. Kraft, J. Stieber);
%    this resolves BSC at QDL13 & 17, and fits the quads better
%  * update the engineering types of existing LTUH BPMs (M. Woodley)
%  * remove existing toroids IMDUMP, IMBCS4 as they are not compatible
%    with SCRF beam (S. Mao, P. Emma)
%  * remove deferred IMBCS4B (S. Mao)
%  * add deferred BCS cavity ACMs IMDUMPH, IMDUMPS downstream of dumpline bends
%    (S. Mao)
%  * add deferred BPMEM4B (Stripline-2) at QEM4B (J. Welch)
%  * update engineering type designations of current monitors (J. Welch)
%  * move CXQ6 to the downstream side of CC31 chicane to be closer to
%    a BPM (J. Welch); move CC31 chicane 1 m upstream to provide space for CXQ6;
%    update CXQ6 X-aperture as sqrt(betx)
%  * move CYBX36 1.9 m downstream to get it closer to the nearest BPM (J. Welch)
%    and have it at a similar location relative to a bend as CYBX32 (P. Emma);
%    update CYBX36 Y-aperture as sqrt(bety)
%  * restore existing LCLS collimators CX31, CX35, CY32, CY36 (D. Hanquist)
%  * restore the existing length (8 cm) of existing collimators CEDL1, CEDL3
%  * update the engineering type of BYKIK1,2 to "1.92K41.2" (J. Amann)
%  * restore YCBSYQ1, XCBSYQ2, XCBSYQ3 correctors in BSY to deferment level 0
%  * put the existing BPMBSY39, BPMBSY88 in the baseline (P. Emma)
%  * move PC119 7.0 m upstream to Z=3191 m (S. Mao)
%  * move YCBSYQ1 upstream of Q50Q1 (K. Grouev)
%  * change the type of QVM3B to 1.26Q12 and the corresponding BPMVM3B
%    to Stripline-10 (P. Emma)
%  * move XCVM3B 0.1066 m upstream to fit with the longer QVM3B (J. Stieber)
% ------------------------------------------------------------------------------
% 15-MAR-2016, M. Woodley
%  * assign IMON TYPEs per R. Iverson
% 26-FEB-2016, Y. Nosochkov
%  * adjust positions of BPMBSY1, BPMBSY29, BPMBSY39, BPMBSY88 to match to
%    their existing installation at the corresponding BSY quads (C. Iverson)
%  * change engineering type of BPMBSY39 to Stripline-6 (C. Iverson)
%  * add existing BCS PC119 d/s of CXQ6 at Z=3198 m and existing BCS PC90
%    d/s of PCBSY4/BTMBSY4 at Z=3176 m (baseline) (S. Mao)
%  * add BCS PCBSY4/BTMBSY4 at Z=3174 (deferred @0) (S. Mao)
%  * add BCS PCBSY3/BTMBSY3 at Z=3155 m (deferred @0) (S. Mao)
%  * place BCS PCBSY1/BTMBSY1 39.199" d/s of Q50Q3 center (S. Mao & C. Iverson)
%  * place XCBSY36 64" downstream of Q50Q3 center (C. Iverson)
%  * remove BCS PCSP3H/BTMSP3H (S. Mao)
%  * move IMDUMP, IMBCS4, IMBCS4b upstream to near PCPM1L(b) to avoid 
%    potential hazard from the high power load on the dump (S. Mao)
%  * move YCBSY35 to the upstream side of Q4 to ease interference with CUSXR
%  * move IMSP1h to just dowstream of BRSP2H (S. Mao)
%  * remove IMSP2h (S. Mao)
%  * add BCS ACM IMBSY3 in the BSY1 (R. Ragle)
%  * designate the IMBSY1 as a BCS toroid (R. Ragle)
%  * designate the IMBSY34 as a diagnostic current monitor (not a BCS device)
%  * reserve separate power supply for QDL11 for future match with Cu-linac beam
% 09-FEB-2016, M. Woodley
%  * add sextupoles to correct 2nd-order dispersion per P. Emma
%  * remove SEQnn MARKers
%  * add wood door at LI30/BSY boundary (WOODDOOR)
% 13-OCT-2015, M. Woodley
%  * fix error in definition of HXR dechirpers
% ------------------------------------------------------------------------------
% 01-OCT-2015, M. Woodley
%  * add "BEG" and "END" MARKers to R56 compensation chicanes
%  * set collimator gaps per P. Emma
% 25-SEP-2015, Y. Nosochkov
%  * correct the deferment level of OTRDMP to @1
%  * change type of QDMP1B,2B from 3.25Q20 to 3.94Q17 (per D. Hanquist, P. Emma)
%  * make kickers & septum of CUSXR, and the merge bend of HXR spreader
%    to appear in LCLS2cuH, LCLS2cuAL lines
%  * make kickers & septum of A-line to appear in LCLS2cuH, LCLS2scH lines
%  * include stripline BPMDD(B) (deferred @0) at the current location of
%    RFBDD(B); move RFBDD(B) to just downstream of OTRDMP(B) (per Alev, P. Emma)
%  * defer WSDUMP, WSDUMPB to @3 as they violate BSC (per P. Emma)
%  * IMDUMP will be replaced with the toroid design as in the existing 
%    IMBCS4 for larger aperture (per Alev)
%  * existing OTRDMP will be replaced with the design SA380-536-84 for
%    larger aperture (per Alev)
%  * increase bending angle in the R56 chicanes by 15%
%  * move IMBSY34 upstream to just after the IMBSY2 (per R. Ragle)
%  * group IMBSY1, IMBSY2, IMBSY34 together separated by 12" center-to-center
%  * (per R. Ragle)
% 28-AUG-2015, M. Woodley
%  * undefer R56 compensation chicane bends (CC32, CC35, CC36, CC31B, CC32B)
%  * add wire scanner WSDL4
%  * add dechirper modules DCHIRPV and DCHIRPH (split in half)
%  * move correctors XCDL4 and YCDL4 downstream
%  * remove BEGCuSXR MARKer point from S100BSY1 line
%  * set deferment level of YCWIGS and YCWIGH same as wigglers themselves
% 24-AUG-2015, Y. Nosochkov
%  * add correctors XCVB2, XCVB2B deferred at @0 (type TBD) (per P. Emma)
%  * restore stripline BPMBSY39, BPMBSY88, BPME32B, BPME34B, BPME36B
%    (deferred @0) next to deferred RFBBSY39, RFBBSY88, RFBE32B, RFBE34B,
%    RFBE36B to improve orbit correction (per P. Emma)
%  * match dumpline optics to new TCAV/OTR constraints (per Y. Ding)
%  * add XCBSY36 corrector in BSY (deferred @0)
%  * move BPMBSY29 ~6" downstream (per C. Iverson)
%  * adjust positions of Q50Q1, Q50Q2, SPOILER1, TDKIK1 and BCS devices
%  * assume 85% larger BXKIK1,2 kick angle due to shorter distance to TDKIK1
%  * adjust position of Q6 in BSY for lower beta functions
%  * add Q4 quadrupole (baseline) and BPMBSYQ4 (deferred @0) in BSY
%  * rematch the updated spreader and BSY optics
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * move CXQ6 1 m downstream of DM60 for higher beta-x (per Paul)
%  * assign IMDUMP, IMBCS4b to be BCS current monitors
%  * add deferred BTMSP3h and BTMBSY1 behind PCSP3h and PCBSY1 (per S. Mao)
%  * move IMBSY2 upstream of BXKIK1
%  * exchange positions of IMBSY34 and PCBSY1 (per S. Mao)
%  * move IMSP2H to just d/s of IMSP1H, adjust positions of IMSP1H, PCSP3H
%    (per S. Mao)
%  * update gaps of the halo collimators (per P. Emma)
%  * reduce length of halo collimators (CX.., CY..) from 8 cm to 6 cm (P. Emma)
%  * change the status of BPMQD, BPMQDB from deferred to baseline
%  * rename CEDL14 -> CEDL13 and CEDL18 -> CEDL17 and move them next to
%    QDL13 and QDL17 (larger dispersion and ratio of disp/sqrt(beta)) 
%  * change the type of BPMQD, BPMQDB to "stripline-8" (per M. Owens)
%  * rename SPOILER -> SPOILER1 and TDKIK -> TDKIK1 in BSY1
%  * defer BXKIK, SPOILER1 and TDKIK1 in BSY1 at level @2 (per Tor)
%  * defer BSY1 magnets and devices at level @0 (per Tor)
%  * restore existing BYKIK, SPOILER, TDKIK and PCTDKIK1-4 in LTUH (per Tor)
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * change TYPE for BPMVM4B, BPMBSY1, BPMBSY29, BPMBSY85, and BPMBSY92
%  * assign TYPEs to BCS devices ... defer at level 0
% 12-MAR-2015, Y. Nosochkov
%  * change type of QVM4B to "1.26Q12" in order to provide enough strength
%  * rename WSVM1 to WSVM2 and move it downstream of QVM2 (per LCLS-I update)
%  * move XCVM2 upstream between QVM1 and QVM2 (per LCLS-I update)
%  * add existing wire scanners WS35, WS36 (per LCLS-I update)
%  * remove PCTDKIK1-4 collimators in BSY1 (per S. Mao)
%  * move XCUM1B downstream of QUM1B, and then move both QUM1B and XCUM1B 0.5 m
%    downstream to provide extra 1 m room upstream for moving undulators
%    through the BTH East maze
%  * change type of QDL11-QDL19 from "1.97Q10" to "2Q10"
%  * add split point for transport from BSY1 to SXR (CUSXR beamline)
%  * add scaling with energy for R56 chicane field
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * un-defer existing LTUH wire scanners (WSDL31,WS31,WS32,WS33,WS34)
%  * change some RFBs (defer=2) to BPMs (defer=0)
%  * assign BPM TYPE attributes per PRD LCLSII-2.4-PR-0136
% 09-DEC-2014, Y. Nosochkov
%  * add four PCTDKIK muon collimators d/s of the TDKIK in-line dump in BSY1
%  * restore existing YAGPSI profile monitor in HXR
%  * rename marker MUWALL (for front face of muon wall) to MUWALLb in SXR,
%    and add a corresponding marker MUWALL in HXR
%  * update length of main dump slug (DDUMP)
%  * restore existing RFB07, RFB08
%  * move D10 dump inside the muon wall in the BSY
%  * add 9 BCS burn-through-monitors BTM_1,...,BTM_9 in LTUH (S. Mao)
%  * add 9 BCS burn-through-monitors BTM_1b,...,BTM_9b in LTUS (S. Mao)
%  * add BCS current monitors IMSP1h, IMSP2h in HXR BSY (SPH)
%  * add BCS current monitors IMBSY1, IMBSY2, IMBSY34 in BSY1
%  * add BCS collimator PCBSY1 in BSY1
%  * add BCS collimator PCSP3h in HXR BSY (SPH)
%  * assign the BCX311, BCX312, BCX313, BCX314 R56 chicane bends to
%    non-baseline level "2"
%  * change to type "QE" the quads: QDBL1, QDBL2, QDL20, QDL21, QDL22, QVB1b,
%    QVB2b, QVB3b, QVM3b, QVM4b, QEM1b,...,QEM4b, QUM1b,...,QUM4b
%    note: field of QVM4b reaches the limit at 8.2 GeV
%  * change to type "1.97Q10" the quads QDL11,...,QDL19
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * add resistive-wall wakefield MARKers (for ELEGANT) per P. Emma
%  * set TYPE="fast" for all wire scanners
%  * redefine start of BSY to be LI30 IV30-9 (Z=3042.005)
%  * add SEQ17 MARKers; move BSY1END MARKer to entrance of SPhBSY line
% 27-OCT-2014, Y. Nosochkov
%  * move wiggler EWIGH ~1.4 m downstream and restore existing positions of
%    CEDL1, YCDL1, XCDL1, WSDL31 in LTUH
%  * add missing existing TYPE of XCA0, YCA0
% ------------------------------------------------------------------------------
% 15-OCT-2014, M. Woodley
%  * move Brhof, GBCC, ZBCC, and ZDCC parameter definitions to common.xsif
%  * change names of R56 compensation chicane bends from "BX..." to "BCX..."
%    to conform with nomenclature rules
%  * rematch BSY to DL2 dogleg (matching subroutine MBSYDL2)
% 14-OCT-2014, Y. Nosochkov
%  * add four R56 compensating chicanes in HXR (u/s of muon wall,
%    d/s of BX32, u/s of BX35, and d/s of BX36) and two chicanes in SXR
%    (u/s of BX31b, and d/s of BX32b) -- set to non-baseline level "0"
%  * add existing WSVM1 wire scanner in the LTUH VBEND area at Z'=177.4709 m
%    (per J. Stieber)
%  * restore dumpline toroids IMDUMP, IMBCS4, IMBCS4b (per LCLSII-2.4-PR-0107)
%  * modify locations of various devices in the dumpline (per A. Callen)
% 10-OCT-2014, Y. Nosochkov
%  * update the TYPE of (13) RFBPMs to indicate the non-baseline level "0"
%  * update the TYPE of (5) LTUH WIRE scanners to indicate the non-baseline
%    level "0"
% 30-SEP-2014, Y. Nosochkov
%  * rematch geometry and optics for the updated type of BX31B, BX32B
%    (1.26D103.3T)
%  * restore TDUND to its existing position in LCLS-I, specify TDUND length
%    per D. Bruch
%  * restore locations of QUM1B, QUM2B, QUM3B, QUM4B as in LCLS-I
%  * add markers for BTH/UH walls
%  * change type of XCDL4 from class-4f to class-5f (per J. Amann)
%  * restore existing LCLS-I devices IMUNDI, IM31, IM36, IMBCS1, IMBCS2,
%    OTR33, BPMEM4, BPMDL1, BPME32, BPME34, BPME36 (not part of LCLS2)
%    to avoid cost of their removal (per A. Callen)
%  * replace YCEM1B with XCEM1B, XCEM2B with YCEM2B, YCEM3B with XCEM3B,
%    and XCEM4B with YCEM4B
% 15-SEP-2014, Y. Nosochkov
%  * designate BSY1 line connecting the end of LCLS-I L3 with the beginning of
%    LCLS2 HXR merge bend BXSP1h
% 07-AUG-2014, M. Woodley
%  * change bend type of BX31B, BX32B to 1.26D103.3T (per J. Amann) ... did
%    not change length (yet)
%  * decorate device TYPE attributes to indicate non-baseline status
% 31-JUL-2014, Y. Nosochkov
%  * replace BPMDL1 with RFBDL1 in HXR
%  * remove IM31, IM31b, IMBCS1, IMBCS1b, IM36, IM36b, IMBCS2, IMUNDI, IMUNDIb,
%    RFB07, RFB07b, RFB08, RFB08b, IMDUMP, IMDUMPb, IMBCS4, IMBCS4b
% 23-JUL-2014, Y. Nosochkov
%  * move TDUNDb 2.8 m downstream (per J. Stieber)
% 15-JUL-2014, Y. Nosochkov
%  * move SXR quad QUM1b 2.0 m downstream (per J. Stieber)
% 14-JUL-2014, Y. Nosochkov
%  * move SXR quad QDL19 2.5 m downstream (per J. Stieber) -- this requires
%    moving along (2.5 m d/s) the quads QDL11 to QDL18 (to maintain dispersion
%    cancellation without moving the bends)
% 17-JUN-2014, Y. Nosochkov
%  * remove OTR33 in HXR (per J. Frisch)
%  * replace all stripline BPMs downstream of the undulators with RFBPMs
%    (per J. Frisch)
%  * move OTR33B to dispersive location near QDL18 and rename it to OTRDL18
% 12-MAY-2014, Y. Nosochkov
%  * add beam abort horizontal kicker BXKIK, SPOILER and in-line dump TDKIK
%    in the beginning of LCLS-I BSY, upstream of the LCLS2 HXR merge bend BXSP1h
% 02-MAY-2014, M. Woodley
%  * move definition of DRFB drift to common.xsif
%  * add "CNT" MARKERs after dispersive areas (ELEGANT CENTERing)
%  * remove RWWAKEal* MARKER points per P. Emma
%  * change names of wiggler segments (WIG11s/WIG12s -> WIG1SA/WIG1SB, etc.)
% 01-MAY-2014, Y. Nosochkov
%  * change YCUM3 -> XCUM3, XCUM4 -> YCUM4, YCUM3B -> XCUM3B, XCUM4B -> YCUM4B
%  * replace BPMBSY39, BPMBSY88 with cavity BPMs RFBBSY39, RFBBSY88
% 29-APR-2014, Y. Nosochkov
%  * add sync. light vertical wiggler EWIGh in LTUH
%  * add sync. light vertical wiggler EWIGs in LTUS (per J. Frisch)
% 23-APR-2014, Y. Nosochkov
%  * replace stripline BPMs BPMEM4B, BPME32B, BPME34B, BPME36B, BPMEM4,
%    BPME32, BPME34, BPME36, BPMDDB, BPMDD with cavity BPMs RFBEM4B, RFBE32B,
%    RFBE34B, RFBE36B, RFBEM4, RFBE32, RFBE34, RFBE36, RFBDDB, RFBDD
%    (per J. Frisch)
% 22-APR-2014, Y. Nosochkov
%  * add missing existing DM60 BTM monitor in the HXR BSY
%  * adjust length of PCPM1L,PCPM2L,PCPM1Lb,PCPM2Lb
%  * change magnet type of QDMP1, QDMP2 to 3.94Q17
%  * change magnet type of QDMP1b, QDMP2b to 3.25Q20
% 17-APR-2014, Y. Nosochkov
%  * change D2 definition from MARK to INST
% 15-APR-2014, Y. Nosochkov
%  * update collimator jaw aperture per LCLSII-2.4-PR-0095
% 08-APR-2014, Y. Nosochkov
%  * remove HXR betatron collimators CX31, CY32, CX35, CY36
%  * remove SXR betatron collimators CX31b, CY32b, CX35b, CY36b
%  * add HXR betatron collimators CXQ6, CYBX32, CXQT22, CYBX36
%  * add SXR betatron collimator CYBDL, CYDL16
%  * rename YCQT22 to YCQT21 and move it upstream of QT21
% 07-APR-2014, M. Woodley
%  * reorder some drift length parameter definitions and drift length
%    definitions to avoid using parameters/attributes before they are defined
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% 26-MAR-2014, Y. Nosochkov
%  * remove PCTDKIK1,2,3,4 from HXR LTU
%  * update beta match to undulator
% 25-MAR-2014, Y. Nosochkov
%  * remove BYKIK, TDKIK and SPOILER from HXR LTU
%  * add missing ST60, ST61 stoppers in the BSY
% 21-MAR-2014, Y. Nosochkov
%  * rematch to updated undulator cells
% 07-MAR-2014, Y. Nosochkov
%  * increase main dump length (from DUMPFACE to BTMDUMP) to 1.5 m (to be
%    confirmed), remove markers EOL, EOLB
% 06-MAR-2014, Y. Nosochkov
%  * add a 0.6 mrad soft bend in front of the dump bends
%  * roll the HXR/SXR dumplines starting from the soft bend by 10 deg
%    to reduce the beam-to-beam x-separation at the dumps to ~1.88 m
%    and the vertical descent (relative to undulator) to ~1.76 m
%  * adjust Z-positions of the dump face and QDMP quads (per Mario and Maceo)
% ------------------------------------------------------------------------------
% 28-FEB-2014, Y. Nosochkov
%  * rematch to the updated undulator
% 26-FEB-2014, Y. Nosochkov
%  * rematch to the updated spreader
% 17-JAN-2014, Y. Nosochkov
%  * rematch to the updated spreader
% 18-DEC-2013, Y. Nosochkov
%  * update match to the spreader
% 16-DEC-2013, Y. Nosochkov
%  * update match to the 3-way spreader with low R56
% 03-DEC-2013, Y. Nosochkov
%  * update match to the spreader
% 25-NOV-2013, Y. Nosochkov
%  * remove QBSY1, QBSY2 and adjust locations of Q50Q1,Q50Q2,Q50Q3,Q5,Q6 to
%    maintain FODO optics while avoiding interference with divergent and
%    biconcave chambers
% 21-NOV-2013, Y. Nosochkov
%  * update QDBL1,2 strengths for the 3-way spreader system
% 26-OCT-2013, Y. Nosochkov
%  * update quadrupole type 1.26Q12 in SXR
%  * move QDBL1, QDBL2 0.5 m downstream
% 25-OCT-2013, Y. Nosochkov
%  * add BPMs, correctors to FODO BSY in HXR
%  * add place holder for pulse magnets to FODO BSY (per R. Iverson)
% 22-OCT-2013, Y. Nosochkov
%  * move TDUNDb 4.844538 m upstream
% 18-OCT-2013, Y. Nosochkov
%  * change quadrupole type of QBSY1, QBSY2 to 1.26Q12
% 17-OCT-2013, Y. Nosochkov
%  * change quadrupole type of QVB1B, QVB2B, QVB3B, QVM3B, QVM4B to 1.26Q12
%  * change bend type of BX31B, BX32B to 1.26D102.0T (per C. Spencer)
% 17-OCT-2013, M. Woodley
%  * from Yuri's LTU.xsif ... this file now defines MUWALL to SXXSTART, plus
%    the SXR dump line
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% SXR R56 compensating chicanes
% - use series approximation for sinc(x)=sin(x)/x to allow zero field
% ------------------------------------------------------------------------------
% Brhof  : beam rigidity at chicane (kG-m)
% GBCC   : gap height (m)
% ZBCC   : magnet Z-length along axis (m)
% ZDCC   : Z-space between magnets (m)
% BBX..  : chicane bend field (kG) at 4 GeV
% ABX..  : chicane bend angle (rad)
% LBX..  : chicane bend path length (m)
% ABX..S : "short" half chicane bend angle (rad)
% ABX..L : "long" half chicane bend angle (rad)
% LBX..S : "short" half chicane bend path length (m)
% LBX..L : "long" half chicane bend path length (m)
BBX31B =  5.0450 *EF/4.0 *1.15;
ARG31B =  ZBCC*BBX31B/BRHOF;
ABX31B =  asin(ARG31B);
ABX31B_2 =  ABX31B*ABX31B;
ABX31B_4 =  ABX31B_2*ABX31B_2;
ABX31B_6 =  ABX31B_4*ABX31B_2;
SINC31B =  1-ABX31B_2/6+ABX31B_4/120-ABX31B_6/5040;
LBX31B =  ZBCC/SINC31B;
ABX31BS =  asin(ARG31B/2);
ABX31BS_2 =  ABX31BS*ABX31BS;
ABX31BS_4 =  ABX31BS_2*ABX31BS_2;
ABX31BS_6 =  ABX31BS_4*ABX31BS_2;
SINC31BS =  1-ABX31BS_2/6+ABX31BS_4/120-ABX31BS_6/5040;
LBX31BS =  ZBCC/(2*SINC31BS);
ABX31BL =  ABX31B-ABX31BS;
LBX31BL =  LBX31B-LBX31BS;
BCX31B11={'be' 'BCX31B1' LBX31BS [+ABX31BS GBCC/2 0 0 FBCC 0 0]}';
BCX31B12={'be' 'BCX31B1' LBX31BL [+ABX31BL GBCC/2 0 +ABX31B 0 FBCC 0]}';
BCX31B21={'be' 'BCX31B2' LBX31BL [-ABX31BL GBCC/2 -ABX31B 0 FBCC 0 0]}';
BCX31B22={'be' 'BCX31B2' LBX31BS [-ABX31BS GBCC/2 0 0 0 FBCC 0]}';
BCX31B31={'be' 'BCX31B3' LBX31BS [-ABX31BS GBCC/2 0 0 FBCC 0 0]}';
BCX31B32={'be' 'BCX31B3' LBX31BL [-ABX31BL GBCC/2 0 -ABX31B 0 FBCC 0]}';
BCX31B41={'be' 'BCX31B4' LBX31BL [+ABX31BL GBCC/2 +ABX31B 0 FBCC 0 0]}';
BCX31B42={'be' 'BCX31B4' LBX31BS [+ABX31BS GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX31B1={'be' 'BCX31B' LBX31B [+ABX31B GBCC/2 0 +ABX31B FBCC FBCC 0]}';
BCX31B2={'be' 'BCX31B' LBX31B [-ABX31B GBCC/2 -ABX31B 0 FBCC FBCC 0]}';
BCX31B3={'be' 'BCX31B3' LBX31B [-ABX31B GBCC/2 0 -ABX31B FBCC FBCC 0]}';
BCX31B4={'be' 'BCX31B4' LBX31B [+ABX31B GBCC/2 +ABX31B 0 FBCC FBCC 0]}';
DCC31BO={'dr' '' ZDCC/cos(ABX31B) []}';
DCC31BI={'dr' '' ZDCC []}';
CC31BBEG={'mo' 'CC31BBEG' 0 []}';
CC31BEND={'mo' 'CC31BEND' 0 []}';
BCX31B1_FULL=[BCX31B11,BCX31B12];
BCX31B2_FULL=[BCX31B21,BCX31B22];
BCX31B3_FULL=[BCX31B31,BCX31B32];
BCX31B4_FULL=[BCX31B41,BCX31B42];
CC31B=[CC31BBEG,BCX31B1_FULL,DCC31BO,BCX31B2_FULL,DCC31BI,BCX31B3_FULL,DCC31BO,BCX31B4_FULL,CC31BEND];
BBX32B =  5.0450 *EF/4.0 *1.15;
ARG32B =  ZBCC*BBX32B/BRHOF;
ABX32B =  asin(ARG32B);
ABX32B_2 =  ABX32B*ABX32B;
ABX32B_4 =  ABX32B_2*ABX32B_2;
ABX32B_6 =  ABX32B_4*ABX32B_2;
SINC32B =  1-ABX32B_2/6+ABX32B_4/120-ABX32B_6/5040;
LBX32B =  ZBCC/SINC32B;
ABX32BS =  asin(ARG32B/2);
ABX32BS_2 =  ABX32BS*ABX32BS;
ABX32BS_4 =  ABX32BS_2*ABX32BS_2;
ABX32BS_6 =  ABX32BS_4*ABX32BS_2;
SINC32BS =  1-ABX32BS_2/6+ABX32BS_4/120-ABX32BS_6/5040;
LBX32BS =  ZBCC/(2*SINC32BS);
ABX32BL =  ABX32B-ABX32BS;
LBX32BL =  LBX32B-LBX32BS;
BCX32B11={'be' 'BCX32B1' LBX32BS [+ABX32BS GBCC/2 0 0 FBCC 0 0]}';
BCX32B12={'be' 'BCX32B1' LBX32BL [+ABX32BL GBCC/2 0 +ABX32B 0 FBCC 0]}';
BCX32B21={'be' 'BCX32B2' LBX32BL [-ABX32BL GBCC/2 -ABX32B 0 FBCC 0 0]}';
BCX32B22={'be' 'BCX32B2' LBX32BS [-ABX32BS GBCC/2 0 0 0 FBCC 0]}';
BCX32B31={'be' 'BCX32B3' LBX32BS [-ABX32BS GBCC/2 0 0 FBCC 0 0]}';
BCX32B32={'be' 'BCX32B3' LBX32BL [-ABX32BL GBCC/2 0 -ABX32B 0 FBCC 0]}';
BCX32B41={'be' 'BCX32B4' LBX32BL [+ABX32BL GBCC/2 +ABX32B 0 FBCC 0 0]}';
BCX32B42={'be' 'BCX32B4' LBX32BS [+ABX32BS GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX32B1={'be' 'BCX32B' LBX32B [+ABX32B GBCC/2 0 +ABX32B FBCC FBCC 0]}';
BCX32B2={'be' 'BCX32B' LBX32B [-ABX32B GBCC/2 -ABX32B 0 FBCC FBCC 0]}';
BCX32B3={'be' 'BCX32B3' LBX32B [-ABX32B GBCC/2 0 -ABX32B FBCC FBCC 0]}';
BCX32B4={'be' 'BCX32B4' LBX32B [+ABX32B GBCC/2 +ABX32B 0 FBCC FBCC 0]}';
DCC32BO={'dr' '' ZDCC/cos(ABX32B) []}';
DCC32BI={'dr' '' ZDCC []}';
CC32BBEG={'mo' 'CC32BBEG' 0 []}';
CC32BEND={'mo' 'CC32BEND' 0 []}';
BCX32B1_FULL=[BCX32B11,BCX32B12];
BCX32B2_FULL=[BCX32B21,BCX32B22];
BCX32B3_FULL=[BCX32B31,BCX32B32];
BCX32B4_FULL=[BCX32B41,BCX32B42];
CC32B=[CC32BBEG,BCX32B1_FULL,DCC32BO,BCX32B2_FULL,DCC32BI,BCX32B3_FULL,DCC32BO,BCX32B4_FULL,CC32BEND];
% ------------------------------------------------------------------------------
% wiggler for sync. light energy diagnostic (described in SLAC-PUB-3945)
% based on FACET optics model (M. Woodley)
% (series approximation for sinc(x)=sin(x)/x to enable setting with x=0)
% ------------------------------------------------------------------------------
GWIG =  0.02032       ;%gap height
ZWHP =  0.244         ;%half-pole Z length
ZDWG =  0.126525      ;%pole-to-pole Z spacing
ZWIG =  4*ZWHP+2*ZDWG ;%total wiggler Z length
BWGS =  1.E-12                  ;%wiggler bend field (kG)
AWGS =  asin(BWGS*ZWHP/(EF*CB)) ;%bend angle per half-pole
AWGS2 =  AWGS*AWGS;
AWGS4 =  AWGS2*AWGS2;
AWGS6 =  AWGS4*AWGS2;
SINCS =  1-AWGS2/6+AWGS4/120-AWGS6/5040;
LWGS =  ZWHP/SINCS              ;%half-pole path length
AWG1S =  asin(sin(AWGS)/2) ;%"short half" half-pole bend angle
AWG1S2 =  AWG1S*AWG1S;
AWG1S4 =  AWG1S2*AWG1S2;
AWG1S6 =  AWG1S4*AWG1S2;
SINC1S =  1-AWG1S2/6+AWG1S4/120-AWG1S6/5040;
LWG1S =  (ZWHP/2)/SINC1S   ;%"short half" half-pole path length
AWG2S =  AWGS-AWG1S        ;%"long half" half-pole bend angle
LWG2S =  LWGS-LWG1S        ;%"long half" half-pole path length
WIG1S1={'be' 'WIG1S' LWG1S [AWG1S GWIG/2 0 0 0.5 0 pi/2]}';
WIG1S2={'be' 'WIG1S' LWG2S [AWG2S GWIG/2 0 AWGS 0 0.5 pi/2]}';
WIG2S1={'be' 'WIG2S' LWGS [-AWGS GWIG/2 -AWGS 0 0.5 0 pi/2]}';
WIG2S2={'be' 'WIG2S' LWGS [-AWGS GWIG/2 0 -AWGS 0 0.5 pi/2]}';
WIG3S1={'be' 'WIG3S' LWG2S [AWG2S GWIG/2 AWGS 0 0.5 0 pi/2]}';
WIG3S2={'be' 'WIG3S' LWG1S [AWG1S GWIG/2 0 0 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
WIG1S={'be' 'WIG1S' LWGS [+AWGS GWIG/2 0 +AWGS 0.5 0.5 pi/2]}';
WIG2S={'be' 'WIG2S' 2*LWGS [-2*AWGS GWIG/2 -AWGS -AWGS 0.5 0.5 pi/2]}';
WIG3S={'be' 'WIG3S' LWGS [+AWGS GWIG/2 +AWGS 0 0.5 0.5 pi/2]}';
LDWGS =  ZDWG/cos(AWGS);
DWGS={'dr' '' LDWGS []}';
YCWIGS={'mo' 'YCWIGS' 0 []}';
CNTWIGS={'mo' 'CNTWIGS' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
WIG1S_FULL=[WIG1S1,WIG1S2];
WIG2S_FULL=[WIG2S1,YCWIGS,WIG2S2];
WIG3S_FULL=[WIG3S1,WIG3S2];
EWIGS=[WIG1S_FULL,DWGS,WIG2S_FULL,DWGS,WIG3S_FULL,CNTWIGS];
% replace deferred wiggler with a drift
DWIGS={'dr' '' ZWIG []}';
DWIGSA={'dr' '' 1.135414 []}';
DWIGSB={'dr' '' DWIGS{3}-DWIGSA{3}-LPLATE []}';
% ------------------------------------------------------------------------------
% SXR dogleg
% ------------------------------------------------------------------------------
% note: the K-values below are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQDBL1 =  -0.048819823179;
KQDBL2 =  -0.560812460035;
QDBL1={'qu' 'QDBL1' LQE/2 [KQDBL1 0]}';
QDBL2={'qu' 'QDBL2' LQE/2 [KQDBL2 0]}';
KQDLB =  0.424676241757;
KQDL11 =  KQDLB;
QDL11={'qu' 'QDL11' LQR/2 [KQDL11 0]}';%reserve separate PS
QDL12={'qu' 'QDL12' LQR/2 [-KQDLB 0]}';
QDL13={'qu' 'QDL13' LQR/2 [KQDLB 0]}';
QDL14={'qu' 'QDL14' LQR/2 [-KQDLB 0]}';
QDL15={'qu' 'QDL15' LQR/2 [KQDLB 0]}';
QDL16={'qu' 'QDL16' LQR/2 [-KQDLB 0]}';
QDL17={'qu' 'QDL17' LQR/2 [KQDLB 0]}';
QDL18={'qu' 'QDL18' LQR/2 [-KQDLB 0]}';
QDL19={'qu' 'QDL19' LQR/2 [KQDLB 0]}';
KQDL20 =  -0.487979625759;
KQDL21 =  -1.904057641444;
KQDL22 =   2.191453247156;
QDL20={'qu' 'QDL20' LQE/2 [KQDL20 0]}';
QDL21={'qu' 'QDL21' LQE/2 [KQDL21 0]}';
QDL22={'qu' 'QDL22' LQE/2 [KQDL22 0]}';
KSDL1 =   -8.734519131209;
KSDL2 =  -24.395452957066;
SDL1={'dr' 'SDL1' LSB/2 []}';
SDL2={'dr' 'SDL2' LSB/2 []}';
% 
% 
% 

LB3B =  2.656     ;%1.06D103.3T effective length (m)
GB3B =  1.06*IN2M ;%1.06D103.3T gap height (m)
AB3PB =  0.018633330237;
AB3MB =  -AB3PB;
LEFFB3B =  LB3B*AB3PB/(2*sin(AB3PB/2)) ;%full bend eff. path length (m)
BX31B1={'be' 'BX31B' LEFFB3B/2 [AB3MB/2 GB3B/2 AB3MB/2 0 0.4297 0.0 0]}';
BX31B2={'be' 'BX31B' LEFFB3B/2 [AB3MB/2 GB3B/2 0 AB3MB/2 0.0 0.4297 0]}';
BX32B1={'be' 'BX32B' LEFFB3B/2 [AB3PB/2 GB3B/2 AB3PB/2 0 0.4297 0.0 0]}';
BX32B2={'be' 'BX32B' LEFFB3B/2 [AB3PB/2 GB3B/2 0 AB3PB/2 0.0 0.4297 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BX31B={'be' 'BX31' LEFFB3B [AB3MB GB3B/2 AB3MB/2 AB3MB/2 0.4297 0.4297 0]}';
BX32B={'be' 'BX32' LEFFB3B [AB3PB GB3B/2 AB3PB/2 AB3PB/2 0.4297 0.4297 0]}';
% SXR single beam dumper vertical kicker, BPM, spoiler and in-line dump
LKIKS =  1.0601 ;%kicker coil length per magnet (m) [41.737 in from SA-380-330-02, rev. 0]
ABYKIKS =  1E-20  ;%=0.889371410732E-3 when BYKIKS1,2 are turned on
BYKIK1S1={'be' 'BYKIK1S' LKIKS/2 [ABYKIKS/4 25.4E-3 ABYKIKS/4 0 0.5 0 pi/2]}';
BYKIK1S2={'be' 'BYKIK1S' LKIKS/2 [ABYKIKS/4 25.4E-3 0 ABYKIKS/4 0 0.5 pi/2]}';
BYKIK2S1={'be' 'BYKIK2S' LKIKS/2 [ABYKIKS/4 25.4E-3 ABYKIKS/4 0 0.5 0 pi/2]}';
BYKIK2S2={'be' 'BYKIK2S' LKIKS/2 [ABYKIKS/4 25.4E-3 0 ABYKIKS/4 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYKIK1S={'be' 'BYKIK1S' LKIKS [ABYKIKS/2 25.4E-3 ABYKIKS/4 ABYKIKS/4 0.5 0.5 pi/2]}';
BYKIK2S={'be' 'BYKIK2S' LKIKS [ABYKIKS/2 25.4E-3 ABYKIKS/4 ABYKIKS/4 0.5 0.5 pi/2]}';
BPMBYKS={'mo' 'BPMBYKS' 0 []}';
SPOILERS={'mo' 'SPOILERS' 0 []}';%TDKIKS dump spoiler (1 mm Ti)
TDKIKS={'mo' 'TDKIKS' 0.6096 []}';%vertical off-axis in-line dump
LDBLDL =  3.0 ;% length of LTU doublet including drifts
WALL={'dr' '' 16.764 []}';%length of muon wall
DWALLA={'dr' '' 1.840975 []}';%distance from face of muon wall to face of BSY dump
DWALLB={'dr' '' WALL{3}-DWALLA{3} []}';
DDBLDLB={'dr' '' 0.5+(LQA-LQE)/2 []}';
DDBLDLC={'dr' '' 0.4 []}';
DDBLDLD={'dr' '' (LQA-LQE)/2 []}';
DDBLDLA={'dr' '' 0.5*(LDBLDL-2*LQE-DDBLDLB{3}-2*DDBLDLC{3}-DDBLDLD{3}-LJAW) []}';
DDBLDLA1={'dr' '' 0.654660 []}';
DDBLDLA2={'dr' '' 2*DDBLDLA{3}-DDBLDLA1{3} []}';
LDLCEL =  25.5;
LDL6B =  0.4;
LDL0A =  LDLCEL/2-LQA-LDL6B;
LDL0B =  LDLCEL/2-LQA-LDL6B+(LQA-LQR);
LDL0BA =  0.1953;
LDL0BB =  3.213005+(LQA-LQR)/2-LDL0BA;
LDL0BC =  LDL0B-LDL0BA-LDL0BB;
LDL1B =  2.9815+(LQA-LQR)/2;
LDL1BA =  1.316489-LPLATE ;%1.317304
LDL1BC =  0.1953;
LDL1BB =  LDL1B-LDL1BA-LPLATE-LDL1BC;
LDL2B =  LDL0B+LDL6B-LDL1B-LB3B+(LEFFB3B-LB3B)*3;
LDL2BA =  0.1953;
LDL2BB =  LDL2B-LDL2BA;
LDL4B =  1.996-LDL6B+(LQA-LQE);
LDL3B =  LDL0A-LQA-LDL4B-2*LDL6B+1.0+2*(LQA-LQE);
LDL5B =  0.498+(LQA-LQE)/2;
LDL7B =  0.93209;
LDL8B =  LDL0B-LDL7B-LJAW;
LDL8C =  1.0;
LDL8CA =  0.1953;
LDL8CB =  LDL8C-LDL8CA;
LDL8D =  LDL0B-LDL8C-ZWIG;
%LDL8da := 0.019865 251052
%LDL8db := LDL8d-LDL8da
LDL9B =  LDL0B-LDL6B;
LDL9BA =  6.045762 ;%5.076366+(LQA-LQR)/2 +2.7012019
LDL9BB =  LDL9B-LDL9BA;
LDL10B =  1.230797;
LDL10BA =  0.81;
LDL10BB =  LDL10B-LDL10BA;
LDL11B =  LDL0B-LDL10B-LJAW;
LDL11BA =  0.162952;
LDL11BB =  LDL11B-LDL11BA;
LDL13B =  0.4;
LDL12B =  LDL0B-LDL13B-LDL7B-LJAW;
DLDL14B =  0.0;
LDL14B =  0.4815+(LQA-LQE)/2 +DLDL14B;
LDL16B =  0.5;
LDL15B =  LDL2B-LDL16B-2.0;
LDL15BA =  0.1953;
LDL15BB =  1.224657+(LQA-LQR)/2-LDL15BA;
LDL15BC =  LDL15B-LDL15BA-LDL15BB;
LDL17B =  0.5;
LDL18B =  LDL3B-LDL17B-2.0;
LDL18BA =  1.076255 ;%1.139755
LDL18BB =  LDL18B-LDL18BA-LPLATE;
LDL19BA =  0.1953;
LDL19BB =  6.150346 ;%221641 6.201146
LDL19BC =  LDL0B-LDL19BA-LDL19BB-LPLATE;
LDL20B =  LDL0B+1.002-(LQA-LQR)/2;
DDL0B={'dr' '' LDL0B []}';
DDL0BA={'dr' '' LDL0BA []}';
DDL0BB={'dr' '' LDL0BB []}';
DDL0BC={'dr' '' LDL0BC []}';
DDL1B={'dr' '' LDL1B []}';
DDL1BA={'dr' '' LDL1BA []}';
DDL1BB={'dr' '' LDL1BB []}';
DDL1BC={'dr' '' LDL1BC []}';
DDL2B={'dr' '' LDL2B []}';
DDL2BA={'dr' '' LDL2BA []}';
DDL2BB={'dr' '' LDL2BB []}';
DDL4B={'dr' '' LDL4B []}';
DDL5B={'dr' '' LDL5B []}';
DDL6B={'dr' '' LDL6B []}';
DDL6BB={'dr' '' 0.1 []}';
DDL6BA={'dr' '' DDL6B{3}-DDL6BB{3}-LSB []}';
DDL7B={'dr' '' LDL7B []}';
DDL7BA={'dr' '' 0.51 []}';
DDL7BB={'dr' '' LDL7B-DDL7BA{3} []}';
DDL7BBA={'dr' '' 0.135832 []}';
DDL7BBB={'dr' '' DDL7BB{3}-DDL7BBA{3} []}';
DDL8B={'dr' '' LDL8B []}';
DDL8C={'dr' '' LDL8C []}';
DDL8CA={'dr' '' LDL8CA []}';
DDL8CB={'dr' '' LDL8CB []}';
DDL8D={'dr' '' LDL8D []}';
%DDL8da : DRIFT, L=LDL8da
%DDL8db : DRIFT, L=LDL8db
DDL9B={'dr' '' LDL9B []}';
DDL10B={'dr' '' LDL10B []}';
DDL10BA={'dr' '' LDL10BA []}';
DDL10BB={'dr' '' LDL10BB []}';
DDL11B={'dr' '' LDL11B []}';
DDL11BA={'dr' '' LDL11BA []}';
DDL11BB={'dr' '' LDL11BB []}';
DDL12B={'dr' '' LDL12B []}';
DDL13B={'dr' '' LDL13B []}';
DDL14B={'dr' '' LDL14B []}';
DDL15B={'dr' '' LDL15B []}';
DDL15BA={'dr' '' LDL15BA []}';
DDL15BB={'dr' '' LDL15BB []}';
DDL15BC={'dr' '' LDL15BC []}';
DDL16B={'dr' '' LDL16B []}';
DDL17B={'dr' '' LDL17B []}';
DDL18B={'dr' '' LDL18B []}';
DDL18BA={'dr' '' LDL18BA []}';
DDL18BB={'dr' '' LDL18BB []}';
DDL19BA={'dr' '' LDL19BA []}';
DDL19BB={'dr' '' LDL19BB []}';
DDL19BC={'dr' '' LDL19BC []}';
DDL20B={'dr' '' LDL20B []}';
% drifts for BYKIKS system
LDBYKS =  LDLCEL/2-LQR ;%DL cell drift length
DLMDW =  0;
DBYKS01={'dr' '' DDL10BA{3} []}';%QDL16 to CYDL16
DBYKS02={'dr' '' DDL10BB{3} []}';%CYDL16 to BPMDL16
DBYKS03={'dr' '' 1.145230 []}';%BPMDL16 to BTM04B (DDL11BA[L]+0.299779)
DBYKS05={'dr' '' 0.5893-LKIKS/2 []}';%(BYKIK1S to BYKIK2S)/2 (0.609226)
DBYKS06={'dr' '' 4.360149 []}';%BYKIK2S to XCDL17      (4.340223)
DBYKS07={'dr' '' 0.634128 []}';%XCDL17 to BPMDL17
DBYKS08={'dr' '' 0.415873 []}';%BPMDL17 to QDL17
DBYKS04={'dr' '' LDBYKS-DBYKS01{3}-LJAW-DBYKS02{3}-DBYKS03{3}-LPLATE-2*(LKIKS+DBYKS05{3})-DBYKS06{3}-DBYKS07{3}-DBYKS08{3} []}';%BTM04B to BYKIK1S
DBYKS11={'dr' '' 0.51 []}';%QDL17 to CEDL17
DBYKS12={'dr' '' 0.735832 []}';%CEDL17 to (removed) BTM05B
DBYKS13={'dr' '' 0.687668 []}';%(removed) BTM05B to SPOILERS
DBYKS14={'dr' '' 3.200208 []}';%SPOILERS to TDKIKS (3.220859)
DBYKS15={'dr' '' 0.257457 []}';%TDKIKS to PCTDKIKS1 (0.257426)
DBYKS16={'dr' '' 0.266697 []}';%PCTDKIKS to PCTDKIKS
DBYKS18={'dr' '' 0.4 []}';%OTRDL18 to YCDL18
DBYKS19={'dr' '' 0.4 []}';%YCDL18 to QDL18
DBYKS17={'dr' '' LDBYKS-DBYKS11{3}-LJAW-DBYKS12{3}-DBYKS13{3}-DBYKS14{3}-TDKIKS{3}-DBYKS15{3}-4*LPCTDKIK-3*DBYKS16{3}-DBYKS18{3}-DBYKS19{3} []}';%PCTDKIK4S to OTRDL18
BPMDBL1={'mo' 'BPMDBL1' 0 []}';
BPMDBL2={'mo' 'BPMDBL2' 0 []}';
BPMDL11={'mo' 'BPMDL11' 0 []}';
BPMDL12={'mo' 'BPMDL12' 0 []}';
BPMDL13={'mo' 'BPMDL13' 0 []}';
BPMDL14={'mo' 'BPMDL14' 0 []}';
BPMDL15={'mo' 'BPMDL15' 0 []}';
BPMDL16={'mo' 'BPMDL16' 0 []}';
BPMDL17={'mo' 'BPMDL17' 0 []}';
BPMDL18={'mo' 'BPMDL18' 0 []}';
BPMDL19={'mo' 'BPMDL19' 0 []}';
BPMDL20={'mo' 'BPMDL20' 0 []}';
BPMDL21={'mo' 'BPMDL21' 0 []}';
BPMDL22={'mo' 'BPMDL22' 0 []}';
XCDBL2={'mo' 'XCDBL2' 0 []}';
XCDL11={'mo' 'XCDL11' 0 []}';
XCDL13={'mo' 'XCDL13' 0 []}';
XCDL15={'mo' 'XCDL15' 0 []}';
XCDL17={'mo' 'XCDL17' 0 []}';
XCDL19={'mo' 'XCDL19' 0 []}';
XCDL22={'mo' 'XCDL22' 0 []}';
YCDBL1={'mo' 'YCDBL1' 0 []}';
YCDL12={'mo' 'YCDL12' 0 []}';
YCDL14={'mo' 'YCDL14' 0 []}';
YCDL16={'mo' 'YCDL16' 0 []}';
YCDL18={'mo' 'YCDL18' 0 []}';
YCDL20={'mo' 'YCDL20' 0 []}';
YCDL21={'mo' 'YCDL21' 0 []}';
CEDL13={'dr' 'CEDL13' LJAW []}';
CEDL17={'dr' 'CEDL17' LJAW []}';
CYBDL={'dr' 'CYBDL' LJAW []}';
CYDL16={'dr' 'CYDL16' LJAW []}';
% muon collimators after SBD TDKIKS in-line dump
PCTDKIK1S={'dr' 'PCTDKIK1S' LPCTDKIK []}';
PCTDKIK2S={'dr' 'PCTDKIK2S' LPCTDKIK []}';
PCTDKIK3S={'dr' 'PCTDKIK3S' LPCTDKIK []}';
PCTDKIK4S={'dr' 'PCTDKIK4S' LPCTDKIK []}';
OTRDL18={'mo' 'OTRDL18' 0 []}';
PC01B={'mo' 'PC01B' LPLATE []}';
BTM01B={'mo' 'BTM01B' 0 []}';
PC03B={'mo' 'PC03B' LPLATE []}';
BTM03B={'mo' 'BTM03B' 0 []}';
PC04B={'mo' 'PC04B' LPLATE []}';
BTM04B={'mo' 'BTM04B' 0 []}';
PC06B={'mo' 'PC06B' LPLATE []}';
BTM06B={'mo' 'BTM06B' 0 []}';
PC07B={'mo' 'PC07B' LPLATE []}';
BTM07B={'mo' 'BTM07B' 0 []}';
DBMARK34B={'mo' 'DBMARK34B' 0 []}';%entrance of BX31
CNTLT1S={'mo' 'CNTLT1S' 0 []}';
BX31B_FULL=[BX31B1,BX31B2];
BYKIK1S_FULL=[BYKIK1S1,BYKIK1S2];
BYKIK2S_FULL=[BYKIK2S1,BYKIK2S2];
BX32B_FULL=[BX32B1,BX32B2];
QDBL1_FULL=[QDBL1,BPMDBL1,QDBL1];
QDBL2_FULL=[QDBL2,BPMDBL2,QDBL2];
QDL11_FULL=[QDL11,QDL11];
QDL12_FULL=[QDL12,QDL12];
QDL13_FULL=[QDL13,QDL13];
QDL14_FULL=[QDL14,QDL14];
QDL15_FULL=[QDL15,QDL15];
QDL16_FULL=[QDL16,QDL16];
QDL17_FULL=[QDL17,QDL17];
QDL18_FULL=[QDL18,QDL18];
QDL19_FULL=[QDL19,QDL19];
QDL20_FULL=[QDL20,BPMDL20,QDL20];
QDL21_FULL=[QDL21,BPMDL21,QDL21];
QDL22_FULL=[QDL22,BPMDL22,QDL22];
SDL1_FULL=[SDL1,SDL1];
SDL2_FULL=[SDL2,SDL2];
DBLDL21=[BEGLTUS,DDBLDLB,QDBL1_FULL,DDBLDLC,YCDBL1,DDBLDLA1,CYBDL,DDBLDLA2,XCDBL2,DDBLDLC,QDBL2_FULL,DDBLDLD];
DL2SC=[DBMARK34B,DDL20B,XCDL11,DDL6B,QDL11_FULL,DDL15BA,BPMDL11,DDL15BB,DDL15BC,CC31B,DDL16B,BX31B_FULL,DDL1BA,PC01B,BTM01B,DDL1BB,BPMDL12,DDL1BC,QDL12_FULL,DDL6B,YCDL12,DDL9B,XCDL13,DDL6BA,SDL1_FULL,DDL6BB,QDL13_FULL,DDL7BA,CEDL13,DDL7BB,BPMDL13,DDL8B,YCDL14,DDL6B,QDL14_FULL,DDL8CA,BPMDL14,DDL8CB,DWIGSA,PC03B,BTM03B,DWIGSB,DDL8D,XCDL15,DDL6BA,SDL2_FULL,DDL6BB,QDL15_FULL,DDL0BA,BPMDL15,DDL0BB,DDL0BC,YCDL16,DDL6B,QDL16_FULL,DBYKS01,CYDL16,DBYKS02,BPMDL16,DBYKS03,PC04B,BTM04B,DBYKS04,BYKIK1S_FULL,DBYKS05,DBYKS05,BYKIK2S_FULL,DBYKS06,XCDL17,DBYKS07,BPMDL17,DBYKS08,QDL17_FULL,DBYKS11,CEDL17,DBYKS12,DBYKS13,SPOILERS,DBYKS14,TDKIKS,DBYKS15,PCTDKIK1S,DBYKS16,PCTDKIK2S,DBYKS16,PCTDKIK3S,DBYKS16,PCTDKIK4S,DBYKS17,OTRDL18,DBYKS18,YCDL18,DBYKS19,QDL18_FULL,DDL19BA,BPMDL18,DDL19BB,PC06B,BTM06B,DDL19BC,XCDL19,DDL6B,QDL19_FULL,DDL2BA,BPMDL19,DDL2BB,BX32B_FULL,CNTLT1S,DDL14B,QDL20_FULL,DDL6B,YCDL20,DDL17B,CC32B,DDL18BA,PC07B,BTM07B,DDL18BB,YCDL21,DDL6B,QDL21_FULL,DDL4B,XCDL22,DDL6B,QDL22_FULL,DDL5B];
% %test line to find ABYKIKS angle for -14.2 mm offset at front face of TDKIKS
% 
% KYKIK1S={'mo' 'KYKIK1S' LKIKS/2 []}';
% KYKIK2S={'mo' 'KYKIK2S' LKIKS/2 []}';
% KYKIK1S_FULL=[KYKIK1S,KYKIK1S];
% KYKIK2S_FULL=[KYKIK2S,KYKIK2S];
% TESTBYKIKS=[KYKIK1S_FULL,DBYKS05,DBYKS05,KYKIK2S_FULL,DBYKS06,XCDL17,DBYKS07,BPMDL17,DBYKS08,QDL17_FULL,DBYKS11,CEDL17,DBYKS12,BTM05B,DBYKS13,SPOILERS,DBYKS14];
% 
% 
% 
% 
% %LMDIF, TOL=1.E-20
% %MIGRAD, TOL=1.E-20
% 
% 
% 
% 
% 

% ------------------------------------------------------------------------------
% SXR VBEND
% ------------------------------------------------------------------------------
KQVBB =  -2.509359002417;
KQVM3B =   0.953555362463;
KQVM4B =  -1.16254158193;
QVB1B={'qu' 'QVB1B' LQE/2 [KQVBB 0]}';
QVB2B={'qu' 'QVB2B' LQE/2 [-KQVBB 0]}';
QVB3B={'qu' 'QVB3B' LQE/2 [KQVBB 0]}';
QVM3B={'qu' 'QVM3B' LQA/2 [KQVM3B 0]}';
QVM4B={'qu' 'QVM4B' LQA/2 [KQVM4B 0]}';
S100_PITCH =  -4.760000E-3;
S100_HEIGHT =  77.643680;
Z_S100_UNDH =  583.000000;
R_EARTH =  6.372508025E6;
LVB =  1.025      ;%3D39 vertical bend effective length (m)
GVB =  0.034925   ;%gap width (m)
AVB =  (S100_PITCH+asin(Z_S100_UNDH/(R_EARTH+S100_HEIGHT)))/2 ;%bend up twice this angle so e- is level in cnt. of und.
BY1B1={'be' 'BY1B' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY1B2={'be' 'BY1B' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
BY2B1={'be' 'BY2B' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY2B2={'be' 'BY2B' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BY1B={'be' 'BY1' LVB [AVB GVB/2 AVB/2 AVB/2 0.5 0.5 pi/2]}';
BY2B={'be' 'BY2' LVB [AVB GVB/2 AVB/2 AVB/2 0.5 0.5 pi/2]}';
DDVB =  4.114978912453 ;%adjust Y in undulator
DVB1B={'dr' '' 7.44546-DDVB*0.5+(LQA-LQE)/2 []}';
DVB2B={'dr' '' 4.14092-DDVB*0.5+(LQA-LQE) []}';
DVB2M80CMB={'dr' '' 3.34092-DDVB*0.5+(LQA-LQE) []}';
DVB1M40CMB={'dr' '' 7.04546-DDVB*0.5+(LQA-LQE)/2 []}';
DVB1M40CMBA={'dr' '' 2.9267695 []}';%13976 2.990270
DVB1M40CMBB={'dr' '' DVB1M40CMB{3}-DVB1M40CMBA{3}-LPLATE []}';
D40CMC={'dr' '' 0.40 []}';
DYCVM1={'dr' '' 0.40 []}';
DQVM1={'dr' '' 0.34 []}';
DQVM2={'dr' '' 0.5 []}';
DRQVM1={'dr' '' LQF/2 []}';
DRQVM2={'dr' '' LQF/2 []}';
DRQVM2BA={'dr' '' 0.320870 []}';%154231 0.384366
DRQVM2BB={'dr' '' 2*DRQVM2{3}-DRQVM2BA{3}-LPLATE []}';
DXCVM2={'dr' '' 0.25 []}';
DVB25CM={'dr' '' 0.25 []}';
DVB25CMCB={'dr' '' 1.32046 []}';
D25CM={'dr' '' 0.25 []}';
DVBEM25CMB={'dr' '' 1.39092 []}';
DVBEM15CMB={'dr' '' 0.243073 []}';
D10CMB={'dr' '' 0.1064869 []}';
D25CMA={'dr' '' 0.2209001 []}';
BPMVB1B={'mo' 'BPMVB1B' 0 []}';
BPMVB2B={'mo' 'BPMVB2B' 0 []}';
BPMVB3B={'mo' 'BPMVB3B' 0 []}';
BPMVM3B={'mo' 'BPMVM3B' 0 []}';
BPMVM4B={'mo' 'BPMVM4B' 0 []}';
XCVB2B={'mo' 'XCVB2B' 0 []}';
XCVM3B={'mo' 'XCVM3B' 0 []}';
YCVB1B={'mo' 'YCVB1B' 0 []}';
YCVB3B={'mo' 'YCVB3B' 0 []}';
YCVM4B={'mo' 'YCVM4B' 0 []}';
PC08B={'mo' 'PC08B' LPLATE []}';
BTM08B={'mo' 'BTM08B' 0 []}';
PC09B={'mo' 'PC09B' LPLATE []}';
BTM09B={'mo' 'BTM09B' 0 []}';
VBINB={'mo' 'VBINB' 0 []}';%start of vert. bend system
VBOUTB={'mo' 'VBOUTB' 0 []}';%end of vert. bend system
CNTLT2S={'mo' 'CNTLT2S' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BY1B_FULL=[BY1B1,BY1B2];
BY2B_FULL=[BY2B1,BY2B2];
QVB1B_FULL=[QVB1B,BPMVB1B,QVB1B];
QVB2B_FULL=[QVB2B,BPMVB2B,QVB2B];
QVB3B_FULL=[QVB3B,BPMVB3B,QVB3B];
QVM3B_FULL=[QVM3B,BPMVM3B,QVM3B];
QVM4B_FULL=[QVM4B,BPMVM4B,QVM4B];
VBENDB=[VBINB,BY1B_FULL,DVB1B,QVB1B_FULL,D40CMC,YCVB1B,DVB2M80CMB,XCVB2B,D40CMC,QVB2B_FULL,DVB2B,QVB3B_FULL,D40CMC,YCVB3B,DVB1M40CMBA,PC09B,BTM09B,DVB1M40CMBB,BY2B_FULL,CNTLT2S,VBOUTB];
VBSYSB=[DYCVM1,DQVM1,DRQVM1,DRQVM1,DQVM2,DRQVM2BA,PC08B,BTM08B,DRQVM2BB,DXCVM2,DVB25CM,VBENDB,DVB25CMCB,XCVM3B,D25CM,QVM3B_FULL,DVBEM25CMB,YCVM4B,D25CM,QVM4B_FULL,DVBEM15CMB,D10CMB,D25CMA];
% ------------------------------------------------------------------------------
% SXR emittance diagnostic
% ------------------------------------------------------------------------------
KQEM1B =   1.994771712802;
KQEM2B =  -1.809226178089;
KQEM3B =   1.263611884311;
KQEM4B =  -0.891717464061;
QEM1B={'qu' 'QEM1B' LQE/2 [KQEM1B 0]}';
QEM2B={'qu' 'QEM2B' LQE/2 [KQEM2B 0]}';
QEM3B={'qu' 'QEM3B' LQE/2 [KQEM3B 0]}';
QEM4B={'qu' 'QEM4B' LQE/2 [KQEM4B 0]}';
QEM3VB={'qu' 'QEM3VB' LQX/2 [0 0]}';
KQED2B =  0.402753197988 ;%ED2 FODO quad strength
KQE31B =  +KQED2B;
KQE32B =  -KQED2B;
KQE33B =  +KQED2B;
KQE34B =  -KQED2B;
KQE35B =  +KQED2B;
KQE36B =  -KQED2B;
QE31B={'qu' 'QE31B' LQX/2 [KQE31B 0]}';
QE32B={'qu' 'QE32B' LQX/2 [KQE32B 0]}';
QE33B={'qu' 'QE33B' LQX/2 [KQE33B 0]}';
QE34B={'qu' 'QE34B' LQX/2 [KQE34B 0]}';
QE35B={'qu' 'QE35B' LQX/2 [KQE35B 0]}';
QE36B={'qu' 'QE36B' LQX/2 [KQE36B 0]}';
DZ_ADJUST =  47.825;
DDMM =  0.161670898486E-2 ;%adjust Z in undulator
DRFB={'dr' '' 0.2 []}';%separation between (warm) quadrupole and RF BPM
D25CMB={'dr' '' 0.2627 []}';
D25CMC={'dr' '' 0.2373 []}';
DMM1M90CMB={'dr' '' DDVB*2-0.79954+DDMM+(LQA-LQE)/2 []}';
DMM1M90CMBA={'dr' '' 3.485365 []}';%3.548865
DMM1M90CMBB={'dr' '' DMM1M90CMB{3}-DMM1M90CMBA{3}-LPLATE []}';
DEM1A={'dr' '' 0.37 []}';
DEM1B={'dr' '' 4.14092 []}';
DEM1BAB={'dr' '' 1.086830+(LQA-LQE)/2 []}';
DEM1BBB={'dr' '' DEM1B{3}-DEM1BAB{3}+(LQA-LQE) []}';
DEM2B={'dr' '' 0.50 []}';
DMM3M80CM={'dr' '' 11.27092 []}';
DMM3M80CMX={'dr' '' DMM3M80CM{3}+(LQA-LQE) []}';
DMM3MAB={'dr' '' 4.425910+(LQA-LQE)/2 []}';
DMM3MBB={'dr' '' DMM3M80CM{3}-DMM3MAB{3}+(LQA-LQE) []}';
DEM3A={'dr' '' 0.37 []}';
DEM3B={'dr' '' 0.773299 []}';
DEM3BB={'dr' '' DEM3B{3}+(LQA-LQE)/2 []}';
DMM4M90CM={'dr' '' 2.759621 []}';
DMM4M90CMB={'dr' '' DMM4M90CM{3}+(LQA-LQE)/2 []}';
DMM4M90CMBA={'dr' '' 0.9601915 []}';%0.523691
DMM4M90CMBB={'dr' '' DMM4M90CMB{3}-DMM4M90CMBA{3}-LPLATE []}';
DEM4A={'dr' '' 0.50 []}';
DMM5={'dr' '' 2.07046-DRFB{3} []}';
DMM5A={'dr' '' 0.690570 []}';%0.754070
DMM5B={'dr' '' DMM5{3}-DMM5A{3}-LPLATE []}';
DMM5AB={'dr' '' 0.90407+(LQA-LQE)/2 []}';
DMM5BB={'dr' '' DMM5{3}-DMM5AB{3}+(LQA-LQE)/2 []}';
D40CM={'dr' '' 0.40 []}';
D40CMW={'dr' '' 0.3915855 []}';
DE3M80CMA={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12+0.15046 []}';
DE3MAB={'dr' '' 5.333610 []}';
DE3MBB={'dr' '' DE3M80CMA{3}-DE3MAB{3} []}';
DQEA={'dr' '' 0.40+(LQF-LQX)/2-0.15046 []}';
DQEBX={'dr' '' 0.32+(LQF-LQX)/2+0.33655-0.0768665+0.04 []}';
DQEBX2={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12-0.33655+0.0768665-0.04 []}';
DE3A={'dr' '' 4.6+DZ_ADJUST/12+0.14046 []}';
DE3ABA={'dr' '' 1.341982 []}';
DE3ABB={'dr' '' DE3A{3}-DE3ABA{3} []}';
DXL2BTM={'dr' '' 0.286375 []}';%0.299875
DBTM2YC={'dr' '' DE3ABB{3}-DXL2BTM{3}-LPLATE []}';
DQEAA={'dr' '' 0.40+(LQF-LQX)/2-0.14046 []}';
DQEBY={'dr' '' 0.32+(LQF-LQX)/2+0.33655-0.0768665+0.04 []}';
DQEBY1={'dr' '' DQEBY{3}-DRFB{3} []}';
DQEBY2={'dr' '' 4.6-0.4+DZ_ADJUST/12-0.33655+0.0768665-0.04 []}';
DE3M80CMB={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12+0.12046 []}';
DQEAB={'dr' '' 0.40+(LQF-LQX)/2-0.12046 []}';
DQEC={'dr' '' 4.6+DZ_ADJUST/12+(LQF-LQX)/2 []}';
DQEC1={'dr' '' DQEC{3}-DRFB{3} []}';
DE3M40CM={'dr' '' 4.6-0.4+DZ_ADJUST/12+0.15046 []}';
DE3M80CM={'dr' '' 4.6-0.4-0.4+DZ_ADJUST/12-0.02954 []}';
DQEAC={'dr' '' 0.40+(LQF-LQX)/2+0.02954 []}';
DE3={'dr' '' 4.6+DZ_ADJUST/12+0.15046 []}';
BPMEM1B={'mo' 'BPMEM1B' 0 []}';
BPMEM2B={'mo' 'BPMEM2B' 0 []}';
BPMEM3B={'mo' 'BPMEM3B' 0 []}';
BPMEM4B={'mo' 'BPMEM4B' 0 []}';
RFBEM4B={'mo' 'RFBEM4B' 0 []}';
BPME31B={'mo' 'BPME31B' 0 []}';
BPME32B={'mo' 'BPME32B' 0 []}';%type to be checked
RFBE32B={'mo' 'RFBE32B' 0 []}';
BPME33B={'mo' 'BPME33B' 0 []}';
BPME34B={'mo' 'BPME34B' 0 []}';%type to be checked
RFBE34B={'mo' 'RFBE34B' 0 []}';
BPME35B={'mo' 'BPME35B' 0 []}';
BPME36B={'mo' 'BPME36B' 0 []}';%type to be checked
RFBE36B={'mo' 'RFBE36B' 0 []}';
XCEM1B={'mo' 'XCEM1B' 0 []}';
XCEM3B={'mo' 'XCEM3B' 0 []}';
XCE31B={'mo' 'XCE31B' 0 []}';
XCE33B={'mo' 'XCE33B' 0 []}';
XCE35B={'mo' 'XCE35B' 0 []}';
YCEM2B={'mo' 'YCEM2B' 0 []}';
YCEM4B={'mo' 'YCEM4B' 0 []}';
YCE32B={'mo' 'YCE32B' 0 []}';
YCE34B={'mo' 'YCE34B' 0 []}';
YCE36B={'mo' 'YCE36B' 0 []}';
WS31B={'mo' 'WS31B' 0 []}';%LTU emittance
WS32B={'mo' 'WS32B' 0 []}';%LTU emittance
WS33B={'mo' 'WS33B' 0 []}';%LTU emittance
WS34B={'mo' 'WS34B' 0 []}';%LTU emittance
PC10B={'mo' 'PC10B' LPLATE []}';
BTM10B={'mo' 'BTM10B' 0 []}';
PC11B={'mo' 'PC11B' LPLATE []}';
BTM11B={'mo' 'BTM11B' 0 []}';
PC12B={'mo' 'PC12B' LPLATE []}';
BTM12B={'mo' 'BTM12B' 0 []}';
DCX31B={'dr' '' 0.08 []}';
DCY32B={'dr' '' 0.08 []}';
DCX35B={'dr' '' 0.08 []}';
DCY36B={'dr' '' 0.08 []}';
DBMARK36B={'mo' 'DBMARK36B' 0 []}';%center of WS31B
% ==============================================================================
% XLEAP-II devices
% ==============================================================================
% ------------------------------------------------------------------------------
% recycled XLEAP type-4 correctors
% ------------------------------------------------------------------------------
YCXL1={'mo' 'YCXL1' 0 []}';
XCXL1={'mo' 'XCXL1' 0 []}';
YCXL2={'mo' 'YCXL2' 0 []}';
XCXL2={'mo' 'XCXL2' 0 []}';
% ------------------------------------------------------------------------------
% recycled LCLS undulators
% ------------------------------------------------------------------------------
% definition of Eu is in LCLS2sc_master.xsif and LCLS2cu_master.xsif
GAMXL =  EU/MC2       ;%Lorentz energy factor [ ]
KUND =  50           ;%undulator parameter (rms) [ ]
LAMU =  0.40         ;%undulator period [m]
LSEG =  3.400        ;%undulator segment length [m]
LUE =  0.035        ;%undulator termination length (approx) [m]
LUND =  LSEG - 2*LUE ;%undulator segment length without terminations [m]
LUNDH =  LUND/2       ;%undulator segment half-length [m]
% natural undulator focusing "k" in y-plane [m^-2]
KQUND =  SETXLEAP2*(KUND*2*PI/LAMU/sqrt(2)/GAMXL)^2;
% handle K_und->0 (undulator moved out of beam) by expressing R34 as an
% approximate SINC function
ARGU =  LUNDH*sqrt(KQUND);
ARGU2 =  ARGU*ARGU;
ARGU4 =  ARGU2*ARGU2;
ARGU6 =  ARGU4*ARGU2;
SINCARGU =  1-ARGU2/6+ARGU4/120-ARGU6/5040 ;%~sinc(ARGu)=sin(ARGu)/ARGu
R34U =  LUNDH*SINCARGU;
% undulator segment modeled as R-matrix to include vertical natural focusing
% over all but its edge terminations:
UMXL={'un' 'UMXL' LUNDH [KQUND LAMU 1]}';
UMXL1=UMXL;UMXL1{2}='UMXL1';
UMXL2=UMXL;UMXL2{2}='UMXL2';
UMXL3=UMXL;UMXL3{2}='UMXL3';
UMXL4=UMXL;UMXL4{2}='UMXL4';
SHRT =  0.470                                 ;%standard short break length [m]
LRFBU =  0                                     ;%undulator RF-BPM only implemented as zero length monitor
LBR1 =  6.889E-2                              ;%und-seg to quad [m]
LBR3 =  9.111E-2                              ;%quad to BPM [m]
LBR4 =  5.8577E-2                             ;%radiation monitor to segment [m]
LBRWM =  7.1683E-2                             ;%BFW to radiation monitor [m]
LBRS =  SHRT-LRFBU-0.078-LBR1-LBR3-LBR4-LBRWM ;%standard short break length (BPM-to-quad distance) [m]
DLBFW =  3.6016-3.63815 ;%BFW location adjustment per H. Loos
DBRS={'dr' '' LBRS-DLBFW []}';%standard short undulator drift from BPM to segment
DBWM={'dr' '' LBRWM+DLBFW []}';%BFW to radiation monitor drift
DB4={'dr' '' LBR4 []}';%radiation monitor to segment drift
DT={'dr' '' LUE []}';%undulator segment small terminations modeled as drift
DUU={'dr' '' 0.238/2 []}';%undulator pair half-drift
DRFBXL={'dr' '' LRFBU []}';%RFBPMs associated with XLEAP-II undulators removed
% flip RF BPMs
DRFBF =  0.61*IN2M;
DUUF={'dr' '' DUU{3}+DRFBF []}';
DBRSF={'dr' '' DBRS{3}-DRFBF []}';
UMXL1_FULL=[UMXL1,UMXL1];
UMXL2_FULL=[UMXL2,UMXL2];
UMXL3_FULL=[UMXL3,UMXL3];
UMXL4_FULL=[UMXL4,UMXL4];
XL2UND1=[DRFBXL,DBRSF,DBWM,DB4,DT,UMXL1_FULL,DT];
XL2UND2=[DRFBXL,DBRSF,DBWM,DB4,DT,UMXL2_FULL,DT];
XL2UND3=[DRFBXL,DBRSF,DBWM,DB4,DT,UMXL3_FULL,DT];
XL2UND4=[DRFBXL,DBRSF,DBWM,DB4,DT,UMXL4_FULL,DT];
LXL2UND =  2*(DRFBXL{3}+DBRS{3}+DBWM{3}+DB4{3}+DT{3}+UMXL1{3}+ UMXL1{3}+DT{3})+2*DUU{3};
% drifts around undulator pair
LXL3132 =  DQEBX{3}+DCX31B{3}+DQEBX2{3}+DE3ABA{3};
DXLUA={'dr' '' (LXL3132-LXL2UND)/2 []}';
DXLUB={'dr' '' LXL3132-LXL2UND-DXLUA{3} []}';
%VALUE, DXLUa[L],DXLUb[L]
DXLUA1={'dr' '' 0.404978 []}';
DXLUA2={'dr' '' 0.395986 []}';
DXLUA3={'dr' '' DXLUA{3}-DXLUA1{3}-DXLUA2{3} []}';
DXLUA3F={'dr' '' DXLUA3{3}+DRFBF []}';%flip RF BPM
% ------------------------------------------------------------------------------
% original XLEAP self-seeding chicane (normally OFF)
% ------------------------------------------------------------------------------
% - from RadiaBeam (C-bends; 0.75 T peak field; 1 degree max)
% - use series approximation for sinc(x)=sin(x)/x to allow ABXL=0
% - deflects toward +X (to the left/north/wall)
% - Dieter Walz designation: 1.575D14-C (pole-width rather than gap height)
% GBXL  : 0.433D14-C gap height (m)
% ZBXL  : 0.433D14-C "Z" length (m)
% FBXL  : measured fringe field
% ABXL  : chicane bend angle (rad)
% BBXL  : chicane bend field (kG)
% LBXL  : chicane bend path length (m)
% ABXLs : "short" half chicane bend angle (rad)
% LBXLs : "short" half chicane bend path length (m)
% ABXLl : "long" half chicane bend angle (rad)
% LBXLl : "long" half chicane bend path length (m)
% BCXXL1 gets an X-offset of  -5 mm (toward the aisle)
% BCXXL2 gets an X-offset of -12 mm (toward the aisle)
% BCXXL3 gets an X-offset of -12 mm (toward the aisle)
% BCXXL4 gets an X-offset of  -5 mm (toward the aisle)
GBXL =  0.011;
ZBXL =  0.364;
FBXL =  0.5;
ABXL0 =  0.0174 ;%R56=0.56 mm
ABXL =  ABXL0*SETXLEAP2;
BBXL =  BRHOF*sin(ABXL)/ZBXL;
ABXL_2 =  ABXL*ABXL;
ABXL_4 =  ABXL_2*ABXL_2;
ABXL_6 =  ABXL_4*ABXL_2;
SINCABXL =  1-ABXL_2/6+ABXL_4/120-ABXL_6/5040 ;%~sinc(ABXL)=sin(ABXL)/ABXL
LBXL =  ZBXL/SINCABXL;
ABXLS =  asin(sin(ABXL)/2);
ABXLS_2 =  ABXLS*ABXLS;
ABXLS_4 =  ABXLS_2*ABXLS_2;
ABXLS_6 =  ABXLS_4*ABXLS_2;
SINCABXLS =  1-ABXLS_2/6+ABXLS_4/120-ABXLS_6/5040 ;%~sinc(ABXLs)=sin(ABXLs)/ABXLs
LBXLS =  ZBXL/(2*SINCABXLS);
ABXLL =  ABXL-ABXLS;
LBXLL =  LBXL-LBXLS;
BCXXL11={'be' 'BCXXL1' LBXLS [-ABXLS GBXL/2 0 0 FBXL 0 0]}';
BCXXL12={'be' 'BCXXL1' LBXLL [-ABXLL GBXL/2 0 -ABXL 0 FBXL 0]}';
BCXXL21={'be' 'BCXXL2' LBXLL [+ABXLL GBXL/2 +ABXL 0 FBXL 0 0]}';
BCXXL22={'be' 'BCXXL2' LBXLS [+ABXLS GBXL/2 0 0 0 FBXL 0]}';
BCXXL31={'be' 'BCXXL3' LBXLS [+ABXLS GBXL/2 0 0 FBXL 0 0]}';
BCXXL32={'be' 'BCXXL3' LBXLL [+ABXLL GBXL/2 0 +ABXL 0 FBXL 0]}';
BCXXL41={'be' 'BCXXL4' LBXLL [-ABXLL GBXL/2 -ABXL 0 FBXL 0 0]}';
BCXXL42={'be' 'BCXXL4' LBXLS [-ABXLS GBXL/2 0 0 0 FBXL 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXXL1={'be' 'BCXXL' LBXL [-ABXL GBXL/2 0 -ABXL FBXL FBXL 0]}';
BCXXL2={'be' 'BCXXL' LBXL [+ABXL GBXL/2 +ABXL 0 FBXL FBXL 0]}';
BCXXL3={'be' 'BCXXL3' LBXL [+ABXL GBXL/2 0 +ABXL FBXL FBXL 0]}';
BCXXL4={'be' 'BCXXL4' LBXL [-ABXL GBXL/2 -ABXL 0 FBXL FBXL 0]}';
% magnet-to-magnet path lengths
ZDXLO =  1.046-ZBXL ;%outer bend-to-bend Z distance (m)
ZDXLI =  0.520-ZBXL ;%inner bend-to-bend Z distance (m)
DXLO={'dr' '' ZDXLO/cos(ABXL) []}';
DXLI={'dr' '' ZDXLI/2 []}';
LBCXL =  4*ZBXL+2*ZDXLO+ZDXLI ;%chicane length
% MARKers
BCXLSSBEG={'mo' 'BCXLSSBEG' 0 []}';
BCXLSSMID={'mo' 'BCXLSSMID' 0 []}';
BCXLSSEND={'mo' 'BCXLSSEND' 0 []}';
% beamline
BCXXL1_FULL=[BCXXL11,BCXXL12];
BCXXL2_FULL=[BCXXL21,BCXXL22];
BCXXL3_FULL=[BCXXL31,BCXXL32];
BCXXL4_FULL=[BCXXL41,BCXXL42];
BCXLSS=[BCXLSSBEG, BCXXL1_FULL,DXLO,BCXXL2_FULL,DXLI,BCXLSSMID,DXLI,BCXXL3_FULL,DXLO,BCXXL4_FULL,BCXLSSEND];
% drifts around chicane and undulator pair
LXL3536 =  DQEBX{3}+DCX35B{3}+DQEBX2{3}+DE3{3};
DXLUC={'dr' '' 3.5 []}';
DXLUD={'dr' '' 1.0 []}';
DXLUE={'dr' '' LXL3536-DXLUC{3}-LBCXL-DXLUD{3}-LXL2UND []}';
%VALUE, DXLUc[L],DXLUd[L],DXLUe[L]
DXLUD1={'dr' '' 0.323714 []}';
DXLUD2={'dr' '' 0.393700 []}';
DXLUD3={'dr' '' DXLUD{3}-DXLUD1{3}-DXLUD2{3} []}';
DXLUD3F={'dr' '' DXLUD3{3}+DRFBF []}';%flip RF BPM
% ------------------------------------------------------------------------------
% original XLEAP wiggler
% ------------------------------------------------------------------------------
% wiggler is modeled as R-matrix to include natural vertical focusing;
% it is nominally OFF (opened to full gap, with Kwig~2); at minimum gap, Kwig=50
KWIG =  34                                        ;%wiggler parameter [m^-1]
LAMW =  0.34                                      ;%wiggler period [m]
LWIGH =  2.38/2                                    ;%wiggler half-length [m]
GAMW =  EU/MC2                                    ;%Lorentz energy factor in wiggler [ ]
KQWIG =  SETXLEAP2*(2*PI*KWIG/LAMW/sqrt(2)/GAMW)^2 ;%natural vertical focusing "k" [m^-2]
% handle Kwig->0 by expressing R34 as an approximate SINC function
ARGW =  LWIGH*sqrt(KQWIG);
ARGW2 =  ARGW*ARGW;
ARGW4 =  ARGW2*ARGW2;
ARGW6 =  ARGW4*ARGW2;
SINCARGW =  1-ARGW2/6+ARGW4/120-ARGW6/5040 ;%~sinc(ARGw)=sin(ARGw)/ARGw
R34W =  LWIGH*SINCARGW;
WIGXL={'un' 'WIGXL' LWIGH [KQWIG LAMW 1]}';
%VALUE, WIGXL[RM(1,1)],WIGXL[RM(1,2)],WIGXL[RM(2,1)],WIGXL[RM(2,2)]
%VALUE, WIGXL[RM(3,3)],WIGXL[RM(3,4)],WIGXL[RM(4,3)],WIGXL[RM(4,4)]
% ------------------------------------------------------------------------------
% SXR emittance diagnostic beamline
% ------------------------------------------------------------------------------
QEM1B_FULL=[QEM1B,BPMEM1B,QEM1B];
QEM2B_FULL=[QEM2B,BPMEM2B,QEM2B];
QEM3B_FULL=[QEM3B,BPMEM3B,QEM3B];
QEM3VB_FULL=[QEM3VB,QEM3VB];
QEM4B_FULL=[QEM4B,BPMEM4B,QEM4B];
QE31B_FULL=[QE31B,BPME31B,QE31B];
QE32B_FULL=[QE32B,BPME32B,QE32B];
QE33B_FULL=[QE33B,BPME33B,QE33B];
QE34B_FULL=[QE34B,BPME34B,QE34B];
QE35B_FULL=[QE35B,BPME35B,QE35B];
QE36B_FULL=[QE36B,BPME36B,QE36B];
EDMCHB=[D25CMB,D25CMC,DMM1M90CMBA,PC10B,BTM10B,DMM1M90CMBB,XCEM1B,DEM1A,QEM1B_FULL,DEM1BAB,DEM1BBB,QEM2B_FULL,DEM2B,YCEM2B,DMM3M80CMX,XCEM3B,DEM3A,QEM3B_FULL,DEM3BB,QEM3VB_FULL,DMM4M90CMBA,PC11B,BTM11B,DMM4M90CMBB,YCEM4B,DEM4A,QEM4B_FULL,DRFB,RFBEM4B,DMM5AB,DMM5BB];
%XLEAP2a : LINE=(DQEBx,DCX31B,DQEBx2,DE3aBa)
XLEAP2A=[DXLUA1,YCXL1,DXLUA2,XCXL1,DXLUA3F,XL2UND1,DUU,DUUF,XL2UND2,DXLUB];
%XLEAP2b : LINE=(DQEBx,DCX35B,DQEBx2,DE3)
XLEAP2B=[DXLUC,BCXLSS,DXLUD1,YCXL2,DXLUD2,XCXL2,DXLUD3F,XL2UND3,DUU,DUUF,XL2UND4,DXLUE];
EDSYSB=[DBMARK36B,WS31B,D40CM,DE3MAB,DE3MBB,XCE31B,DQEA,QE31B_FULL,XLEAP2A,DXL2BTM,PC12B,BTM12B,DBTM2YC,YCE32B,DQEAA,QE32B_FULL,DRFB,RFBE32B,DQEBY1,DCY32B,DQEBY2,WS32B,D40CM,DE3M80CMB,XCE33B,DQEAB,QE33B_FULL,DQEC,DE3M40CM,YCE34B,DQEA,QE34B_FULL,DRFB,RFBE34B,DQEC1,WS33B,D40CM,DE3M80CM,XCE35B,DQEAC,QE35B_FULL,XLEAP2B,YCE36B,DQEA,QE36B_FULL,DRFB,RFBE36B,DQEBY1,DCY36B,DQEBY2,WS34B,D40CM];
ECELLB=[QE31B,DQEC,DQEC,QE32B,QE32B,DQEC,DQEC,QE31B];
% ------------------------------------------------------------------------------
% SXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values come from Y. Nosochkov's UNDS_KQ5_US.xsif file,
%       for E= 4.0 GeV and KSXU= 5.0 (IntgSX= 30.0 kG)
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
KQUM1B =   0.311729673613;
KQUM2B =  -0.13;
KQUM3B =   0.384569277452;
KQUM4B =  -0.522052682614;
QUM1B={'qu' 'QUM1B' LQE/2 [KQUM1B 0]}';
QUM2B={'qu' 'QUM2B' LQE/2 [KQUM2B 0]}';
QUM3B={'qu' 'QUM3B' LQE/2 [KQUM3B 0]}';
QUM4B={'qu' 'QUM4B' LQE/2 [KQUM4B 0]}';
DU1M80CM={'dr' '' 4.550 []}';
DCX37={'dr' '' 0.08 []}';
DCY38={'dr' '' 0.08 []}';
D32CMCB={'dr' '' 1.30046+(LQA-LQE)/2+0.5 []}';
DUM1A={'dr' '' 0.49 []}';
DUM1B={'dr' '' 0.47046 []}';
D32CM={'dr' '' 0.32 []}';
DU2M120CMB={'dr' '' 3.730+(LQA-LQE)-0.5 []}';
D32CMA={'dr' '' 0.42046 []}';
DUM2A={'dr' '' 0.37 []}';
DUM2B={'dr' '' 0.47046 []}';
DU3M80CM={'dr' '' 7.29046 []}';
DU3M80CMB={'dr' '' DU3M80CM{3}+(LQA-LQE) []}';
DUM3A={'dr' '' 0.38 []}';
DUM3B={'dr' '' 0.47046 []}';
D40CMA={'dr' '' 1.807939 []}';
DU4M120CM={'dr' '' 1.362521 []}';
DU4M120CMB={'dr' '' DU4M120CM{3}+(LQA-LQE) []}';
DUM4A={'dr' '' 0.50 []}';
DUM4B={'dr' '' 0.59746 []}';
DU5M80CM={'dr' '' 0.5 []}';
DU5M80CMB={'dr' '' DU5M80CM{3}+(LQA-LQE)/2 []}';
DUHWALL1={'dr' '' 0.250825 []}';%length of BTH/UH wall-1
DUHVEST={'dr' '' 2.009175 []}';%length of BTH/UH vestibule
DUHVESTA={'dr' '' 1.605684 []}';
DUHVESTB={'dr' '' DUHVEST{3}-DUHVESTA{3} []}';
DUHWALL2={'dr' '' 0.250825 []}';%length of BTH/UH wall-2
DW2TDUNDB={'dr' '' 3.001537+0.060429 []}';%drift from BTH/UH wall-2 to TDUNDB u/s flange
DTDUND1={'dr' '' 0.855853 []}';%from u/s TDUND flange to TDUND center
DTDUND2={'dr' '' 0.347853 []}';%from TDUND center to d/s TDUND flange
DPCMUON={'dr' '' 0.031498 []}';
DMUON1={'dr' '' 0.154859+0.05 []}';
DMUON1B={'dr' '' 0.154859+0.05-0.060429 []}';
DMUON3B={'dr' '' 0.310592-0.05 []}';
DW2TDB1={'dr' '' 61.51*IN2M-WIGXL{3} []}';
DW2TDB2={'dr' '' DW2TDUNDB{3}-DW2TDB1{3}-2*WIGXL{3} []}';
%VALUE, DW2TDb1[L],DW2TDb2[L]
%VALUE, DW2TDb1[L]+2*WIGXL[L]+DW2TDb2[L],DW2TDUNDb[L]
BPMUM1B={'mo' 'BPMUM1B' 0 []}';
BPMUM2B={'mo' 'BPMUM2B' 0 []}';
BPMUM3B={'mo' 'BPMUM3B' 0 []}';
BPMUM4B={'mo' 'BPMUM4B' 0 []}';
XCUM1B={'mo' 'XCUM1B' 0 []}';%fast-feedback (loop-5)
XCUM3B={'mo' 'XCUM3B' 0 []}';%fast-feedback (loop-5)
YCUM2B={'mo' 'YCUM2B' 0 []}';%fast-feedback (loop-5)
YCUM4B={'mo' 'YCUM4B' 0 []}';%fast-feedback (loop-5)
TDUNDB={'mo' 'TDUNDB' 0 []}';%LTU insertable block at und. extension entrance (w/ screen)
% Note: PCMUONb Y-aperture violates standard BSC -- approved by P. Emma
PCMUONB={'dr' 'PCMUONB' 1.1684 []}';%muon scattering collimator
VV999B={'mo' 'VV999B' 0 []}';%vacuum valve just upbeam of undulator - TBD
PFILT1B={'mo' 'PFILT1B' 0 []}';
MM1B={'mo' 'MM1B' 0 []}';
MM2B={'mo' 'MM2B' 0 []}';
MM3B={'mo' 'MM3B' 0 []}';
MUWALLB={'mo' 'MUWALLB' 0 []}';%front face of muon wall for SXR beam
DUMPBSYS={'mo' 'DUMPBSYS' 0 []}';%front face of BSY dump for SXR beam
BSYENDB={'mo' 'BSYENDB' 0 []}';%FFTB side of muon plug wall
RWWAKE3S={'mo' 'RWWAKE3S' 0 []}';%SPRDS/BSY beampipe wake applied here
MUHWALL1B={'mo' 'MUHWALL1B' 0 []}';%upstream end of BTH/UH wall-1
MUHWALL2B={'mo' 'MUHWALL2B' 0 []}';%upstream end of BTH/UH wall-2
DBMARK37B={'mo' 'DBMARK37B' 0 []}';%end of undulator match
RWWAKE4S={'mo' 'RWWAKE4S' 0 []}';%LTUS beampipe wake applied here
WIGXL_FULL=[WIGXL,WIGXL];
%LW2TDb     : LINE=(DW2TDUNDb)
LW2TDB=[DW2TDB1,WIGXL_FULL,DW2TDB2];
QUM1B_FULL=[QUM1B,BPMUM1B,QUM1B];
QUM2B_FULL=[QUM2B,BPMUM2B,QUM2B];
QUM3B_FULL=[QUM3B,BPMUM3B,QUM3B];
QUM4B_FULL=[QUM4B,BPMUM4B,QUM4B];
UNMCHB=[DU1M80CM,DCX37,D32CMCB,DUM1A,QUM1B_FULL,DUM1B,XCUM1B,D32CM,DU2M120CMB,DCY38,D32CMA,YCUM2B,DUM2A,QUM2B_FULL,DUM2B,DU3M80CMB,XCUM3B,DUM3A,QUM3B_FULL,DUM3B,D40CMA,DU4M120CMB,YCUM4B,DUM4A,QUM4B_FULL,DUM4B,DU5M80CMB,D40CMW,MUHWALL1B,DUHWALL1,DUHVEST,MUHWALL2B,DUHWALL2,LW2TDB,DTDUND1,TDUNDB,DTDUND2,DPCMUON,PCMUONB,DMUON1B,VV999B];
LTUSC=[MM1B,DL2SC,VBSYSB,MM2B,EDMCHB,EDSYSB,UNMCHB];
PREUNDS=[DMUON3B,MM3B,PFILT1B,DBMARK37B];
BSYLTUSC=[MUWALLB,DWALLA,DUMPBSYS,DWALLB,BSYENDB,ENDSPS,DBLDL21,LTUSC,PREUNDS];
% ------------------------------------------------------------------------------
% SXR dumpline
% ------------------------------------------------------------------------------
KQDMPB =  -0.155745965723 ;%-0.15522011426
QDMP1B={'qu' 'QDMP1B' LQP/2 [KQDMPB 0]}';
QDMP2B={'qu' 'QDMP2B' LQP/2 [KQDMPB 0]}';
LBYDS =  0.5   ;%effective straight length of dump soft bend 1.26D18.43
GBYDS =  0.032 ;%full gap of dump soft bend
ABYDS =  6.E-4;
LEFFBYDS =  LBYDS*ABYDS/(2*sin(ABYDS/2)) ;%bend path length (m)
BYDSS1={'be' 'BYDSS' LEFFBYDS/2 [ABYDS/2 GBYDS/2 ABYDS/2 0 0.5 0.0 pi/2]}';
BYDSS2={'be' 'BYDSS' LEFFBYDS/2 [ABYDS/2 GBYDS/2 0 ABYDS/2 0.0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYDSS={'be' 'BYDSS' LEFFBYDS [ABYDS GBYDS/2 ABYDS/2 ABYDS/2 0.5 0.5 pi/2]}';
LBDM =  1.452  ;%effective straight bend length of main dump bends - from J. Tanabe (m)
GBDM =  0.043  ;%full gap (m) of main dump bends (SA-380-328-03 shows magnet half-gap = 0.866")
FBDM =  0.5513 ;%measured FINT
ABDM =  0.02240073511             ;%angle per main dump bend (rad)
LEFFBDM =  LBDM*ABDM/(2*sin(ABDM/2)) ;%bend path length (m)
BYD1B1={'be' 'BYD1B' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 FBDM 0.0 pi/2]}';
BYD1B2={'be' 'BYD1B' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 FBDM pi/2]}';
BYD2B1={'be' 'BYD2B' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 FBDM 0.0 pi/2]}';
BYD2B2={'be' 'BYD2B' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 FBDM pi/2]}';
BYD3B1={'be' 'BYD3B' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 FBDM 0.0 pi/2]}';
BYD3B2={'be' 'BYD3B' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 FBDM pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYD1B={'be' 'BYD1' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 FBDM FBDM pi/2]}';
BYD2B={'be' 'BYD2' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 FBDM FBDM pi/2]}';
BYD3B={'be' 'BYD3' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 FBDM FBDM pi/2]}';
PCPM1LB={'dr' 'PCPM1LB' LPCPM []}';
PCPM2LB={'dr' 'PCPM2LB' LPCPM []}';
LDS1 =   0.3158763;
LDS =   0.247946;
LDMP1 =  11.516159251113 ;%BYD3/BYD3B to QDmp1/QDmp1B
DDMPV =  -0.73352263654;
DDWSDUMP =   0.248126313572 ;%set Z at DUMPFACEB
DS1={'dr' '' LDS1 []}';
DS={'dr' '' LDS []}';
DD1BA={'dr' '' 0.577681352129 []}';
DD1BB={'dr' '' 1.000087502327 []}';
DD1BC={'dr' '' 0.3048 []}';
DD1BE={'dr' '' 0.24963810293 []}';
DD1BF={'dr' '' 0.409240108574 []}';
DD1BD={'dr' '' LDMP1-(DD1BA{3}+PCPM1LB{3}+DD1BB{3}+DD1BC{3}+DD1BE{3}+PCPM2LB{3}+DD1BF{3}) []}';
DD12A={'dr' '' 0.25-0.0079372+0.06 []}';
DD12B={'dr' '' 0.0079372 []}';
DD12C={'dr' '' 0.25+0.06 []}';
DD2A={'dr' '' 0.4+0.0634916+0.0115084 []}';
DD2C={'dr' '' 1.0 []}';
DD2B={'dr' '' 8.1507760-LQD/2+DDMPV-DD2C{3}+0.06 []}';
DD3A={'dr' '' 0.3+0.049684+0.001583 []}';
DD3B={'dr' '' 0.3-0.001583-0.1447026 []}';
DWSDUMPA={'dr' '' 0.44156/2 []}';
DWSDUMPB={'dr' '' 0.44156-DWSDUMPA{3} []}';
DWSDUMPC={'dr' '' 2.038949+DDWSDUMP []}';
DDUMP={'dr' '' 61.120*IN2M []}';%length of EBD dump (per A. Ibrahimov)
BPMQDB={'mo' 'BPMQDB' 0 []}';%RFBQDB : MONI, TYPE="@2,CavityL-1"
BPMDDB={'mo' 'BPMDDB' 0 []}';
RFBDDB={'mo' 'RFBDDB' 0 []}';
XCDDB={'mo' 'XCDDB' 0 []}';
YCDDB={'mo' 'YCDDB' 0 []}';
OTRDMPB={'mo' 'OTRDMPB' 0 []}';%Dump screen
WSDUMPB={'mo' 'WSDUMPB' 0 []}';
MIMBCS4B={'mo' 'MIMBCS4B' 0 []}';
BTM1LB={'mo' 'BTM1LB' 0 []}';%Burn-Through-Monitor behind PCPM1LB
BTM2LB={'mo' 'BTM2LB' 0 []}';%Burn-Through-Monitor behind PCPM2LB
DUMPFACEB={'mo' 'DUMPFACEB' 0 []}';%entrance face of main e- dump
BTMDUMPB={'mo' 'BTMDUMPB' 0 []}';%Burn-Through-Monitor of main e- dump
MQDMPB={'mo' 'MQDMPB' 0 []}';
DMPENDB={'mo' 'DMPENDB' 0 []}';
DBMARK38B={'mo' 'DBMARK38B' 0 []}';%end of final undulator dump
ARODMP1S =  -0.174519678252;
ARODMP2S =   0.174913455104;
RODMP1S={'ro' 'RODMP1S' 0 [-(ARODMP1S)]}';
RODMP2S={'ro' 'RODMP2S' 0 [-(ARODMP2S)]}';
BYDSS_FULL=[BYDSS1,BYDSS2];
BYD1B_FULL=[BYD1B1,BYD1B2];
BYD2B_FULL=[BYD2B1,BYD2B2];
BYD3B_FULL=[BYD3B1,BYD3B2];
QDMP1B_FULL=[QDMP1B,QDMP1B];
QDMP2B_FULL=[QDMP2B,QDMP2B];
DUMPLINEB=[BEGDMPS_2,RODMP1S,BYDSS_FULL,DS1,BYD1B_FULL,DS,BYD2B_FULL,DS,BYD3B_FULL,DD1BA,PCPM1LB,BTM1LB,DD1BB,DD1BC,MIMBCS4B,DD1BD,YCDDB,DD1BE,PCPM2LB,BTM2LB,DD1BF,QDMP1B_FULL,DD12A,BPMQDB,DD12B,MQDMPB,DD12C,QDMP2B_FULL,DD2A,XCDDB,DD2B,DD2C,DD3A,BPMDDB,DD3B,OTRDMPB,DWSDUMPA,RFBDDB,DWSDUMPB,WSDUMPB,DWSDUMPC,RODMP2S,DUMPFACEB,DDUMP,DMPENDB,BTMDUMPB,DBMARK38B,ENDDMPS_2];
% ==============================================================================
% HXR LTU and dump
% ==============================================================================
% ------------------------------------------------------------------------------
% HXR R56 compensating chicanes
% - use series approximation for sinc(x)=sin(x)/x to allow zero field
% ------------------------------------------------------------------------------
% Brhof  : beam rigidity at chicane (kG-m)
% GBCC   : gap height (m)
% ZBCC   : magnet Z-length along axis (m)
% ZDCC   : Z-space between magnets (m)
% BBX..  : chicane bend field (kG) at 4 GeV
% ABX..  : chicane bend angle (rad)
% LBX..  : chicane bend path length (m)
% ABX..S : "short" half chicane bend angle (rad)
% ABX..L : "long" half chicane bend angle (rad)
% LBX..S : "short" half chicane bend path length (m)
% LBX..L : "long" half chicane bend path length (m)
BBX31 =  0.0 *EF/4.0;
ARG31 =  ZBCC*BBX31/BRHOF;
ABX31 =  asin(ARG31);
ABX31_2 =  ABX31*ABX31;
ABX31_4 =  ABX31_2*ABX31_2;
ABX31_6 =  ABX31_4*ABX31_2;
SINC31 =  1.0-ABX31_2/6+ABX31_4/120-ABX31_6/5040;
LBX31 =  ZBCC/SINC31;
ABX31S =  asin(ARG31/2);
ABX31S_2 =  ABX31S*ABX31S;
ABX31S_4 =  ABX31S_2*ABX31S_2;
ABX31S_6 =  ABX31S_4*ABX31S_2;
SINC31S =  1.0-ABX31S_2/6+ABX31S_4/120-ABX31S_6/5040;
LBX31S =  ZBCC/(2*SINC31S);
ABX31L =  ABX31-ABX31S;
LBX31L =  LBX31-LBX31S;
BCX3111={'be' 'BCX311' LBX31S [+ABX31S GBCC/2 0 0 FBCC 0 0]}';
BCX3112={'be' 'BCX311' LBX31L [+ABX31L GBCC/2 0 +ABX31 0 FBCC 0]}';
BCX3121={'be' 'BCX312' LBX31L [-ABX31L GBCC/2 -ABX31 0 FBCC 0 0]}';
BCX3122={'be' 'BCX312' LBX31S [-ABX31S GBCC/2 0 0 0 FBCC 0]}';
BCX3131={'be' 'BCX313' LBX31S [-ABX31S GBCC/2 0 0 FBCC 0 0]}';
BCX3132={'be' 'BCX313' LBX31L [-ABX31L GBCC/2 0 -ABX31 0 FBCC 0]}';
BCX3141={'be' 'BCX314' LBX31L [+ABX31L GBCC/2 +ABX31 0 FBCC 0 0]}';
BCX3142={'be' 'BCX314' LBX31S [+ABX31S GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX311={'be' 'BCX31' LBX31 [+ABX31 GBCC/2 0 +ABX31 FBCC FBCC 0]}';
BCX312={'be' 'BCX31' LBX31 [-ABX31 GBCC/2 -ABX31 0 FBCC FBCC 0]}';
BCX313={'be' 'BCX313' LBX31 [-ABX31 GBCC/2 0 -ABX31 FBCC FBCC 0]}';
BCX314={'be' 'BCX314' LBX31 [+ABX31 GBCC/2 +ABX31 0 FBCC FBCC 0]}';
DCC31O={'dr' '' ZDCC/cos(ABX31) []}';
DCC31I={'dr' '' ZDCC []}';
CC31BEG={'mo' 'CC31BEG' 0 []}';
CC31END={'mo' 'CC31END' 0 []}';
BCX311_FULL=[BCX3111,BCX3112];
BCX312_FULL=[BCX3121,BCX3122];
BCX313_FULL=[BCX3131,BCX3132];
BCX314_FULL=[BCX3141,BCX3142];
CC31=[CC31BEG,BCX311_FULL,DCC31O,BCX312_FULL,DCC31I,BCX313_FULL,DCC31O,BCX314_FULL,CC31END];
BBX32 =  2.3628*sqrt(2.0) *EF/4.0 *1.15;
ARG32 =  ZBCC*BBX32/BRHOF;
ABX32 =  asin(ARG32);
ABX32_2 =  ABX32*ABX32;
ABX32_4 =  ABX32_2*ABX32_2;
ABX32_6 =  ABX32_4*ABX32_2;
SINC32 =  1-ABX32_2/6+ABX32_4/120-ABX32_6/5040;
LBX32 =  ZBCC/SINC32;
ABX32S =  asin(ARG32/2);
ABX32S_2 =  ABX32S*ABX32S;
ABX32S_4 =  ABX32S_2*ABX32S_2;
ABX32S_6 =  ABX32S_4*ABX32S_2;
SINC32S =  1-ABX32S_2/6+ABX32S_4/120-ABX32S_6/5040;
LBX32S =  ZBCC/(2*SINC32S);
ABX32L =  ABX32-ABX32S;
LBX32L =  LBX32-LBX32S;
BCX3211={'be' 'BCX321' LBX32S [+ABX32S GBCC/2 0 0 FBCC 0 0]}';
BCX3212={'be' 'BCX321' LBX32L [+ABX32L GBCC/2 0 +ABX32 0 FBCC 0]}';
BCX3221={'be' 'BCX322' LBX32L [-ABX32L GBCC/2 -ABX32 0 FBCC 0 0]}';
BCX3222={'be' 'BCX322' LBX32S [-ABX32S GBCC/2 0 0 0 FBCC 0]}';
BCX3231={'be' 'BCX323' LBX32S [-ABX32S GBCC/2 0 0 FBCC 0 0]}';
BCX3232={'be' 'BCX323' LBX32L [-ABX32L GBCC/2 0 -ABX32 0 FBCC 0]}';
BCX3241={'be' 'BCX324' LBX32L [+ABX32L GBCC/2 +ABX32 0 FBCC 0 0]}';
BCX3242={'be' 'BCX324' LBX32S [+ABX32S GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX321={'be' 'BCX32' LBX32 [+ABX32 GBCC/2 0 +ABX32 FBCC FBCC 0]}';
BCX322={'be' 'BCX32' LBX32 [-ABX32 GBCC/2 -ABX32 0 FBCC FBCC 0]}';
BCX323={'be' 'BCX323' LBX32 [-ABX32 GBCC/2 0 -ABX32 FBCC FBCC 0]}';
BCX324={'be' 'BCX324' LBX32 [+ABX32 GBCC/2 +ABX32 0 FBCC FBCC 0]}';
DCC32O={'dr' '' ZDCC/cos(ABX32) []}';
DCC32I={'dr' '' ZDCC []}';
CC32BEG={'mo' 'CC32BEG' 0 []}';
CC32END={'mo' 'CC32END' 0 []}';
BCX321_FULL=[BCX3211,BCX3212];
BCX322_FULL=[BCX3221,BCX3222];
BCX323_FULL=[BCX3231,BCX3232];
BCX324_FULL=[BCX3241,BCX3242];
CC32=[CC32BEG,BCX321_FULL,DCC32O,BCX322_FULL,DCC32I,BCX323_FULL,DCC32O,BCX324_FULL,CC32END];
BBX35 =  2.3628 *EF/4.0 *1.15;
ARG35 =  ZBCC*BBX35/BRHOF;
ABX35 =  asin(ARG35);
ABX35_2 =  ABX35*ABX35;
ABX35_4 =  ABX35_2*ABX35_2;
ABX35_6 =  ABX35_4*ABX35_2;
SINC35 =  1-ABX35_2/6+ABX35_4/120-ABX35_6/5040;
LBX35 =  ZBCC/SINC35;
ABX35S =  asin(ARG35/2);
ABX35S_2 =  ABX35S*ABX35S;
ABX35S_4 =  ABX35S_2*ABX35S_2;
ABX35S_6 =  ABX35S_4*ABX35S_2;
SINC35S =  1-ABX35S_2/6+ABX35S_4/120-ABX35S_6/5040;
LBX35S =  ZBCC/(2*SINC35S);
ABX35L =  ABX35-ABX35S;
LBX35L =  LBX35-LBX35S;
BCX3511={'be' 'BCX351' LBX35S [+ABX35S GBCC/2 0 0 FBCC 0 0]}';
BCX3512={'be' 'BCX351' LBX35L [+ABX35L GBCC/2 0 +ABX35 0 FBCC 0]}';
BCX3521={'be' 'BCX352' LBX35L [-ABX35L GBCC/2 -ABX35 0 FBCC 0 0]}';
BCX3522={'be' 'BCX352' LBX35S [-ABX35S GBCC/2 0 0 0 FBCC 0]}';
BCX3531={'be' 'BCX353' LBX35S [-ABX35S GBCC/2 0 0 FBCC 0 0]}';
BCX3532={'be' 'BCX353' LBX35L [-ABX35L GBCC/2 0 -ABX35 0 FBCC 0]}';
BCX3541={'be' 'BCX354' LBX35L [+ABX35L GBCC/2 +ABX35 0 FBCC 0 0]}';
BCX3542={'be' 'BCX354' LBX35S [+ABX35S GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX351={'be' 'BCX35' LBX35 [+ABX35 GBCC/2 0 +ABX35 FBCC FBCC 0]}';
BCX352={'be' 'BCX35' LBX35 [-ABX35 GBCC/2 -ABX35 0 FBCC FBCC 0]}';
BCX353={'be' 'BCX353' LBX35 [-ABX35 GBCC/2 0 -ABX35 FBCC FBCC 0]}';
BCX354={'be' 'BCX354' LBX35 [+ABX35 GBCC/2 +ABX35 0 FBCC FBCC 0]}';
DCC35O={'dr' '' ZDCC/cos(ABX35) []}';
DCC35I={'dr' '' ZDCC []}';
CC35BEG={'mo' 'CC35BEG' 0 []}';
CC35END={'mo' 'CC35END' 0 []}';
BCX351_FULL=[BCX3511,BCX3512];
BCX352_FULL=[BCX3521,BCX3522];
BCX353_FULL=[BCX3531,BCX3532];
BCX354_FULL=[BCX3541,BCX3542];
CC35=[CC35BEG,BCX351_FULL,DCC35O,BCX352_FULL,DCC35I,BCX353_FULL,DCC35O,BCX354_FULL,CC35END];
BBX36 =  2.3628 *EF/4.0 *1.15;
ARG36 =  ZBCC*BBX36/BRHOF;
ABX36 =  asin(ARG36);
ABX36_2 =  ABX36*ABX36;
ABX36_4 =  ABX36_2*ABX36_2;
ABX36_6 =  ABX36_4*ABX36_2;
SINC36 =  1-ABX36_2/6+ABX36_4/120-ABX36_6/5040;
LBX36 =  ZBCC/SINC36;
ABX36S =  asin(ARG36/2);
ABX36S_2 =  ABX36S*ABX36S;
ABX36S_4 =  ABX36S_2*ABX36S_2;
ABX36S_6 =  ABX36S_4*ABX36S_2;
SINC36S =  1-ABX36S_2/6+ABX36S_4/120-ABX36S_6/5040;
LBX36S =  ZBCC/(2*SINC36S);
ABX36L =  ABX36-ABX36S;
LBX36L =  LBX36-LBX36S;
BCX3611={'be' 'BCX361' LBX36S [+ABX36S GBCC/2 0 0 FBCC 0 0]}';
BCX3612={'be' 'BCX361' LBX36L [+ABX36L GBCC/2 0 +ABX36 0 FBCC 0]}';
BCX3621={'be' 'BCX362' LBX36L [-ABX36L GBCC/2 -ABX36 0 FBCC 0 0]}';
BCX3622={'be' 'BCX362' LBX36S [-ABX36S GBCC/2 0 0 0 FBCC 0]}';
BCX3631={'be' 'BCX363' LBX36S [-ABX36S GBCC/2 0 0 FBCC 0 0]}';
BCX3632={'be' 'BCX363' LBX36L [-ABX36L GBCC/2 0 -ABX36 0 FBCC 0]}';
BCX3641={'be' 'BCX364' LBX36L [+ABX36L GBCC/2 +ABX36 0 FBCC 0 0]}';
BCX3642={'be' 'BCX364' LBX36S [+ABX36S GBCC/2 0 0 0 FBCC 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX361={'be' 'BCX36' LBX36 [+ABX36 GBCC/2 0 +ABX36 FBCC FBCC 0]}';
BCX362={'be' 'BCX36' LBX36 [-ABX36 GBCC/2 -ABX36 0 FBCC FBCC 0]}';
BCX363={'be' 'BCX363' LBX36 [-ABX36 GBCC/2 0 -ABX36 FBCC FBCC 0]}';
BCX364={'be' 'BCX364' LBX36 [+ABX36 GBCC/2 +ABX36 0 FBCC FBCC 0]}';
DCC36O={'dr' '' ZDCC/cos(ABX36) []}';
DCC36I={'dr' '' ZDCC []}';
CC36BEG={'mo' 'CC36BEG' 0 []}';
CC36END={'mo' 'CC36END' 0 []}';
BCX361_FULL=[BCX3611,BCX3612];
BCX362_FULL=[BCX3621,BCX3622];
BCX363_FULL=[BCX3631,BCX3632];
BCX364_FULL=[BCX3641,BCX3642];
CC36=[CC36BEG,BCX361_FULL,DCC36O,BCX362_FULL,DCC36I,BCX363_FULL,DCC36O,BCX364_FULL,CC36END];
% ------------------------------------------------------------------------------
% HXR BSY downstream of the merge bend
% ------------------------------------------------------------------------------
% note: the K-values below are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQ50Q3 =   0.434154040462 ;
KQ4 =  -0.217498744833;
KQ5 =   0.110634649191;
KQ6 =  -0.107282100403;
KQA0 =   0.096403505318;
Q50Q3={'qu' 'Q50Q3' 0.143254 [KQ50Q3 0]}';
Q4={'qu' 'Q4' LQF/2 [KQ4 0]}';
Q5={'qu' 'Q5' LQF/2 [KQ5 0]}';
Q6={'qu' 'Q6' LQF/2 [KQ6 0]}';
QA0={'qu' 'QA0' LQF/2 [KQA0 0]}';
CXQ6={'dr' 'CXQ6' LJAW []}';
PCBSY3={'mo' 'PCBSY3' LPLATE []}';%shielding plate
PCBSY4={'mo' 'PCBSY4' LPLATE []}';%shielding plate
PCBSY5={'mo' 'PCBSY5' LPLATE []}';%shielding plate
LPC90 =  0.453644;
LPC119 =  0.453644;
PC90={'dr' 'PC90' LPC90 []}';%existing protection collimator in BSY
PC119={'dr' 'PC119' LPC119 []}';%existing protection collimator in BSY
% 2" ID BSY collimator -- part of 2-hole copper collimator d/s of A-line pulsed magnets
PCBSYH={'dr' 'PCBSYH' 0.45 []}';
DM3={'dr' '' 0.8438 []}';%0.2196
DM4A={'dr' '' 0.4410 []}';%0.2114
DM4C={'dr' '' 0.331133-LJAW/2 []}';
DM4D={'dr' '' 1.168867-LJAW/2 []}';
DM4DA={'dr' '' 0.27685 []}';%0.2832
DM4DB={'dr' '' DM4D{3}-DM4DA{3}-LPLATE []}';
DM4B={'dr' '' 8.851641-DM4A{3}-DM4C{3}-DM4D{3}-LJAW-2.0+0.282226 []}';%8.622041
DXCA0={'dr' '' 0.31 []}';
DYCA0={'dr' '' 0.509021 []}';%0.279421
DM5={'dr' '' 0.790979 []}';%0.561379
DM6={'dr' '' 0.567588 []}';
DMONI={'dr' '' 0.009525 []}';
ZQ5 =  0.0 ;%adjust position of Q5
ZQ6 =  0.0 ;%adjust position of Q6
DBSY52D={'dr' '' 0.5 []}';
DBSY53A={'dr' '' 0.091696 []}';
DBSY53B={'dr' '' 0.760705-0.15 []}';
DBSY53C={'dr' '' 0.629945+0.15 []}';
DBSY53F={'dr' '' 0.5 []}';
DBSY53D={'dr' '' 4.0-DBSY53A{3}-DBSY53B{3}-DBSY53C{3}-DBSY53F{3} []}';
DBSY53G={'dr' '' 1.2 []}';
DBSY53GA={'dr' '' 0.91293 []}';%0.91928
DBSY53GB={'dr' '' DBSY53G{3}-DBSY53GA{3}-LPLATE []}';
DBSY53H={'dr' '' 34.45562-DBSY53G{3}-ZBKRAPM1-ZBKRAPM2-ZBKRAPM3-ZBKRAPM4-2*LDZAPM1-2*LDZAPM2-2*LDZAPM3-LDZAPM4-LDZA01-LDZA02-PCBSYH{3}-LPCAPM1-LPCAPM2-LPCAPM3-LPCAPM4+ZQ5 []}';
DBSY54A={'dr' '' 0.5 []}';
DBSY54B={'dr' '' 3.22454-ZQ5 []}';
DBSY54C={'dr' '' 19.260056-DBSY54A{3}-DBSY54B{3}-ZQ5+ZQ6 []}';
DBSY55A={'dr' '' 0.5 []}';
DBSY55B={'dr' '' 4.226742 []}';
DBSY55C={'dr' '' 8.016028-ZQ6 []}';%8.022378
DBSY55D={'dr' '' 6.466828 []}';%6.473178
DBSY55E={'dr' '' 21.826764-DRFB{3}-DBSY55A{3}-DBSY55B{3}-LPC90-DBSY55C{3}-LPLATE-DBSY55D{3}-LPC119-ZQ6 []}';%21.432164
BPMBSYQ3={'mo' 'BPMBSYQ3' 0 []}';%per C. Iverson
RFBBSYQ3={'mo' 'RFBBSYQ3' 0 []}';
BPMBSYQ4={'mo' 'BPMBSYQ4' 0 []}';
BPMBSYQ5={'mo' 'BPMBSYQ5' 0 []}';%per C. Iverson
BPMBSYQ6={'mo' 'BPMBSYQ6' 0 []}';%per C. Iverson
RFBBSYQ6={'mo' 'RFBBSYQ6' 0 []}';
BPMBSYQA0={'mo' 'BPMBSYQA0' 0 []}';%per C. Iverson
XCBSYQ3={'mo' 'XCBSYQ3' 0 []}';%barcode=4602
XCBSYQ5={'mo' 'XCBSYQ5' 0 []}';%barcode=2100
XCA0={'mo' 'XCA0' 0 []}';%barcode=2195
YCBSYQ4={'mo' 'YCBSYQ4' 0 []}';%barcode=4603
YCBSYQ6={'mo' 'YCBSYQ6' 0 []}';%barcode=2107
YCA0={'mo' 'YCA0' 0 []}';%barcode=2195
D2={'mo' 'D2' 0.43 []}';%stopper
ST60={'mo' 'ST60' 0.76 []}';%backup stopper
DM60={'mo' 'DM60' 0 []}';%"disaster" BTM behind ST60
ST61={'mo' 'ST61' 0.76 []}';%backup stopper
BSYEND={'mo' 'BSYEND' 0 []}';%FFTB side of muon plug wall: Z=3224.022426 (Z'=176.020508 m, X'=0.0 m, Y'=-0.821761 m)
DUMPBSYH={'mo' 'DUMPBSYH' 0 []}';%front face of BSY dump for HXR beam
MUWALL={'mo' 'MUWALL' 0 []}';%front face of muon wall for HXR beam
MRGALINE={'mo' 'MRGALINE' 0 []}';%merge point with A-line
RWWAKE3H={'mo' 'RWWAKE3H' 0 []}';%BSY/SPRDH beampipe wake applied here
Q50Q3_FULL=[Q50Q3,Q50Q3];
Q4_FULL=[Q4,BPMBSYQ4,Q4];
Q5_FULL=[Q5,BPMBSYQ5,Q5];
Q6_FULL=[Q6,BPMBSYQ6,Q6];
QA0_FULL=[QA0,BPMBSYQA0,QA0];
SPHAL=[DBSY52D,Q50Q3_FULL,DBSY53A,BPMBSYQ3,RFBBSYQ3,DBSY53B,DBSY53C,XCBSYQ3,DBSY53D,YCBSYQ4,DBSY53F,Q4_FULL,DBSY53GA,PCBSY3,DBSY53GB,MRGALINE];
SPHBSYA=[SPHAL,ALINEA];
SPHBSYB=[PCBSYH,DBSY53H,Q5_FULL,DBSY54A,XCBSYQ5,DBSY54B,DBSY54C,Q6_FULL,DRFB,RFBBSYQ6,DBSY55A,YCBSYQ6,DBSY55B,PC90,DBSY55C,PCBSY4,DBSY55D,PC119,DBSY55E,D2,DM3,ST60,DM4A,DM60,DM4B,CC31,DM4C,CXQ6,DM4DA,PCBSY5,DM4DB,XCA0,DXCA0,YCA0,DYCA0,ST61,DM5,QA0_FULL,DM6,DMONI,DMONI,MUWALL,DWALLA,DUMPBSYH,DWALLB,BSYEND,RWWAKE3H];
SPHBSY=[SPHBSYA,SPHBSYB,ENDSPH];
% ------------------------------------------------------------------------------
% BSY1 upstream of the HXR merge bend
% ------------------------------------------------------------------------------
KQ30701 =  -0.396231020082 ;%-0.395649272846
KQ30801 =   0.480592172677 ;% 0.480537684959
KQ50Q1 =  -0.231522298208 ;%-0.231937689242
KQ50Q2 =   0.10207433021  ;% 0.102502945834
Q50Q1={'qu' 'Q50Q1' LQR/2 [KQ50Q1 0]}';
Q50Q2={'qu' 'Q50Q2' 0.162151 [KQ50Q2 0]}';
LDBSY01 =  5.995 ;%from beginning of BSY to Station 100
DBSY01A={'dr' '' 0.7286 []}';
DBSY01B={'dr' '' 0.25005 []}';
DBSY01C={'dr' '' 0.25005 []}';
DBSY01D={'dr' '' 0.4143 []}';
DBSY01E={'dr' '' 2.9046 []}';%0.807+0.6+1.4976
DBSY01F={'dr' '' 0.31575 []}';
DBSY01G={'dr' '' 0.31575 []}';
DBSY01H={'dr' '' 0.7975 []}';
DBSY01I={'dr' '' 0.0184 []}';
LDBSY50 =  2.144276 ;%Station 100 to center of Q50Q1
DBSY50={'dr' '' LDBSY50-LQR/2 []}';
DBSY50A={'dr' '' 0.5782 []}';
DBSY50B={'dr' '' DBSY50{3}-DBSY50A{3} []}';
DBSY02={'dr' '' 0.456124 []}';
DBSY02B={'dr' '' 0.2199 []}';
DBSY02A={'dr' '' DBSY02{3}-DBSY02B{3} []}';
DBSY51={'dr' '' 5.521976 []}';
DBSY51B={'dr' '' 0.5 []}';
DBSY51A={'dr' '' DBSY51{3}-DBSY51B{3} []}';
DBSY52={'dr' '' 54.883314 []}';
DBSY52A={'dr' '' 0.079149 []}';
DBSY52B={'dr' '' 1.799589 []}';%2.420851
DBSY52C={'dr' '' DBSY52{3}-DBSY52A{3}-DBSY52B{3}-LBRCUSDC1-DCKDC1{3}-LBKRCUS-DCKDC2{3}-LBRCUSDC2-DCUSBLRA{3}-DCUSBLRB{3}-LBLRCUS-LBXSPH-DBSY52D{3} []}';
BPMBSYQ1={'mo' 'BPMBSYQ1' 0 []}';%changed from "-6" to fit 2Q10
BPMBSYQ2={'mo' 'BPMBSYQ2' 0 []}';%per C. Iverson
YCBSYQ1={'mo' 'YCBSYQ1' 0 []}';%barcode=4600
XCBSYQ2={'mo' 'XCBSYQ2' 0 []}';%barcode=4601
IMBSY1={'mo' 'IMBSY1' 0 []}';%Bergoz toroid
IMBSY2={'mo' 'IMBSY2' 0 []}';%Bergoz toroid
IMBSY3={'mo' 'IMBSY3' 0 []}';%Bergoz toroid
IMBSY1B={'mo' 'IMBSY1B' 0 []}';%PEP2 backup toroid for IMBSY1
IMBSY2B={'mo' 'IMBSY2B' 0 []}';%PEP2 backup toroid for IMBSY2
IMBSY3B={'mo' 'IMBSY3B' 0 []}';%PEP2 backup toroid for IMBSY3
IMBSY34={'mo' 'IMBSY34' 0 []}';%diagnostic toroid - existing LCLS device
LPCBSY =  0.3 ;%TBD
BSYBEG={'mo' 'BSYBEG' 0 []}';
FFTBORGN={'mo' 'FFTBORGN' 0 []}';
S100={'mo' 'S100' 0 []}';%station 100
ZLIN15={'mo' 'ZLIN15' 0 []}';%station-100 (or "S100"): Z=3048.0 (Z'=X'=Y'=0.0 m)
BSY1BEG={'mo' 'BSY1BEG' 0 []}';
BSY1END={'mo' 'BSY1END' 0 []}';
Q50Q1_FULL=[Q50Q1,Q50Q1];
Q50Q2_FULL=[Q50Q2,Q50Q2];
BSYS100=[BSY1BEG,DBSY01A,IMBSY1,DBSY01B,IMBSY2,DBSY01C,IMBSY3,DBSY01D,IMBSY34,DBSY01E,IMBSY1B,DBSY01F,IMBSY2B,DBSY01G,IMBSY3B,DBSY01H,FFTBORGN,DBSY01I];
S100SXRA=[S100,ZLIN15,DBSY50A,YCBSYQ1,DBSY50B,Q50Q1_FULL,DBSY02A,WOODDOOR];
S100SXRB=[DBSY02B,BPMBSYQ1,DBSY51A,XCBSYQ2,DBSY51B,Q50Q2_FULL,DBSY52A,BPMBSYQ2,DBSY52B];
S100SXR=[S100SXRA,S100SXRB];
%BSYSXR : LINE=(BSYbeg,BSYS100,S100SXR)
%S100BSY1 : LINE=(S100SXR,KCUSXRa,DBSY52c,BXSP1Ha,BXSP1Hb)
%BSY1 : LINE=(BSYS100,S100BSY1)
%BSY : LINE=(BSYbeg,BSY1,BSY1END,SPhBSY)
% ------------------------------------------------------------------------------
% HXR VBEND
% ------------------------------------------------------------------------------
KQVM1 =  -0.33743727324;
KQVM2 =   0.236577259388;
KQVM3 =   0.715150825178;
KQVM4 =  -0.681650171008;
QVM1={'qu' 'QVM1' LQF/2 [KQVM1 0]}';
QVM2={'qu' 'QVM2' LQF/2 [KQVM2 0]}';
QVM3={'qu' 'QVM3' LQF/2 [KQVM3 0]}';
QVM4={'qu' 'QVM4' LQF/2 [KQVM4 0]}';
KQVB =  -0.42223036711;
QVB1={'qu' 'QVB1' LQF/2 [KQVB 0]}';
QVB2={'qu' 'QVB2' LQF/2 [-KQVB 0]}';
QVB3={'qu' 'QVB3' LQF/2 [KQVB 0]}';
BY11={'be' 'BY1' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY12={'be' 'BY1' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
BY21={'be' 'BY2' LVB/2 [AVB/2 GVB/2 AVB/2 0 0.5 0 pi/2]}';
BY22={'be' 'BY2' LVB/2 [AVB/2 GVB/2 0 AVB/2 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BY1={'be' 'BY' LVB [AVB GVB/2 AVB/2 AVB/2 0.5 0.5 pi/2]}';
BY2={'be' 'BY' LVB [AVB GVB/2 AVB/2 AVB/2 0.5 0.5 pi/2]}';
DVB1={'dr' '' 8.0-2*0.3125 []}';
DVB2M80CM={'dr' '' 4.0-0.4-0.4 []}';
DVB2={'dr' '' 4.0 []}';
DVB2HA={'dr' '' 0.870432 []}';%0.981620
DVB2HB={'dr' '' DVB2{3}-DVB2HA{3}-LPLATE []}';
DVB1M40CM={'dr' '' 8.0-0.4-2*0.3125 []}';
DVB25CMC={'dr' '' 0.5-0.25 []}';
DVBEM25CM={'dr' '' 0.5-0.25 []}';
DVBEM15CM={'dr' '' 0.150+0.00381+0.018803 []}';
DQVM2B={'dr' '' 0.24954 []}';
DQVM2A={'dr' '' DQVM2{3}-DQVM2B{3} []}';
DWSVM2={'dr' '' DXCVM2{3}+DVB25CM{3} []}';
DWSVM2A={'dr' '' 0.24954+0.0046 []}';
DWSVM2B={'dr' '' DWSVM2{3}-DWSVM2A{3} []}';
BPMVM1={'mo' 'BPMVM1' 0 []}';
BPMVM2={'mo' 'BPMVM2' 0 []}';
BPMVM3={'mo' 'BPMVM3' 0 []}';
BPMVM4={'mo' 'BPMVM4' 0 []}';
BPMVB1={'mo' 'BPMVB1' 0 []}';
BPMVB2={'mo' 'BPMVB2' 0 []}';
BPMVB3={'mo' 'BPMVB3' 0 []}';
XCVB2={'mo' 'XCVB2' 0 []}';
XCVM2={'mo' 'XCVM2' 0 []}';
XCVM3={'mo' 'XCVM3' 0 []}';
YCVM1={'mo' 'YCVM1' 0 []}';%calibrated to <1%
YCVB1={'mo' 'YCVB1' 0 []}';
YCVB3={'mo' 'YCVB3' 0 []}';
YCVM4={'mo' 'YCVM4' 0 []}';
IM31={'mo' 'IM31' 0 []}';%comparator with IM36 (existing LCLS device)
IMBCS1={'mo' 'IMBCS1' 0 []}';%comparator with IMBCS2 (existing LCLS device)
WSVM2={'mo' 'WSVM2' 0 []}';%existing LCLS device
PC01={'mo' 'PC01' LPLATE []}';
BTM01={'mo' 'BTM01' 0 []}';
VBIN={'mo' 'VBIN' 0 []}';%start of vert. bend system: Z=3226.684265 (Z'=178.682318 m, X'=0.0 m, Y'=-0.834187 m)
VBOUT={'mo' 'VBOUT' 0 []}';%end of vert. bend system: Z=3252.866951 (Z'=204.865005 m, X'= 0.0 m, Y'=-0.895304 m)
CNTLT1H={'mo' 'CNTLT1H' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BY1_FULL=[BY11,BY12];
BY2_FULL=[BY21,BY22];
QVM1_FULL=[QVM1,BPMVM1,QVM1];
QVM2_FULL=[QVM2,BPMVM2,QVM2];
QVM3_FULL=[QVM3,BPMVM3,QVM3];
QVM4_FULL=[QVM4,BPMVM4,QVM4];
QVB1_FULL=[QVB1,BPMVB1,QVB1];
QVB2_FULL=[QVB2,BPMVB2,QVB2];
QVB3_FULL=[QVB3,BPMVB3,QVB3];
VBEND=[VBIN,BY1_FULL,DVB1,QVB1_FULL,D40CMC,YCVB1,DVB2M80CM,XCVB2,D40CMC,QVB2_FULL,DVB2HA,PC01,BTM01,DVB2HB, QVB3_FULL,D40CMC,YCVB3,DVB1M40CM,BY2_FULL,CNTLT1H,VBOUT];
VBSYS=[BEGLTUH,DYCVM1,YCVM1,DQVM1,QVM1_FULL,DQVM2A,XCVM2,DQVM2B,QVM2_FULL,DWSVM2A,WSVM2,DWSVM2B,VBEND,DVB25CMC,XCVM3,D25CM,QVM3_FULL,DVBEM25CM,YCVM4,D25CM,QVM4_FULL,DVBEM15CM,IM31,D10CMB,IMBCS1,D25CMA];
% ------------------------------------------------------------------------------
% HXR dogleg
% ------------------------------------------------------------------------------
KQDL =  0.437183970154;
QDL31={'qu' 'QDL31' LQA/2 [KQDL 0]}';
QDL32={'qu' 'QDL32' LQA/2 [KQDL 0]}';
QDL33={'qu' 'QDL33' LQA/2 [KQDL 0]}';
QDL34={'qu' 'QDL34' LQA/2 [KQDL 0]}';
KCQ31 =  0;
KCQ32 =  0;
CQ31={'qu' 'CQ31' LQX/2 [KCQ31 0]}';
CQ32={'qu' 'CQ32' LQX/2 [KCQ32 0]}';
KQT1 = -0.420937827343;
KQT2 =  0.839614778043;
QT11={'qu' 'QT11' LQF/2 [KQT1 0]}';
QT12={'qu' 'QT12' LQF/2 [KQT2 0]}';
QT13={'qu' 'QT13' LQF/2 [KQT1 0]}';
QT21={'qu' 'QT21' LQF/2 [KQT1 0]}';
QT22={'qu' 'QT22' LQF/2 [KQT2 0]}';
QT23={'qu' 'QT23' LQF/2 [KQT1 0]}';
QT31={'qu' 'QT31' LQF/2 [KQT1 0]}';
QT32={'qu' 'QT32' LQF/2 [KQT2 0]}';
QT33={'qu' 'QT33' LQF/2 [KQT1 0]}';
QT41={'qu' 'QT41' LQF/2 [KQT1 0]}';
QT42={'qu' 'QT42' LQF/2 [KQT2 0]}';
QT43={'qu' 'QT43' LQF/2 [KQT1 0]}';
LB3 =   2.623                   ;%0.68D102.36T effective length (m)
GB3 =   0.679*IN2M              ;%0.68D102.36T gap height (m)
FB3 =   0.5237                  ;%0.68D102.36T FINT (measured)
AB3P =   0.499999821952*RADDEG;
AB3M =  -AB3P;
LEFFB3 =  LB3*AB3P/(2*sin(AB3P/2)) ;%full bend eff. path length (m)
BX311={'be' 'BX31' LEFFB3/2 [AB3P/2 GB3/2 AB3P/2 0 FB3 0 0]}';
BX312={'be' 'BX31' LEFFB3/2 [AB3P/2 GB3/2 0 AB3P/2 0 FB3 0]}';
BX321={'be' 'BX32' LEFFB3/2 [AB3P/2 GB3/2 AB3P/2 0 FB3 0 0]}';
BX322={'be' 'BX32' LEFFB3/2 [AB3P/2 GB3/2 0 AB3P/2 0 FB3 0]}';
BX351={'be' 'BX35' LEFFB3/2 [AB3M/2 GB3/2 AB3M/2 0 FB3 0 0]}';
BX352={'be' 'BX35' LEFFB3/2 [AB3M/2 GB3/2 0 AB3M/2 0 FB3 0]}';
BX361={'be' 'BX36' LEFFB3/2 [AB3M/2 GB3/2 AB3M/2 0 FB3 0 0]}';
BX362={'be' 'BX36' LEFFB3/2 [AB3M/2 GB3/2 0 AB3M/2 0 FB3 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BX31={'be' 'BX3' LEFFB3 [AB3P GB3/2 AB3P/2 AB3P/2 FB3 FB3 0]}';
BX32={'be' 'BX3' LEFFB3 [AB3P GB3/2 AB3P/2 AB3P/2 FB3 FB3 0]}';
BX35={'be' 'BX35' LEFFB3 [AB3M GB3/2 AB3M/2 AB3M/2 FB3 FB3 0]}';
BX36={'be' 'BX36' LEFFB3 [AB3M GB3/2 AB3M/2 AB3M/2 FB3 FB3 0]}';
% single beam dumper vertical kicker (existing, restored)
LKIK =  1.0601 ;%kicker coil length per magnet (m) [41.737 in from SA-380-330-02, rev. 0]
ABYKIK =  0.75E-3 *1E-12 ;%full angle =0.75E-3 when BYKIK1,2 are turned on
BYKIK11={'be' 'BYKIK1' LKIK/2 [ABYKIK/4 25.4E-3 ABYKIK/4 0 0.5 0 pi/2]}';
BYKIK12={'be' 'BYKIK1' LKIK/2 [ABYKIK/4 25.4E-3 0 ABYKIK/4 0 0.5 pi/2]}';
BYKIK21={'be' 'BYKIK2' LKIK/2 [ABYKIK/4 25.4E-3 ABYKIK/4 0 0.5 0 pi/2]}';
BYKIK22={'be' 'BYKIK2' LKIK/2 [ABYKIK/4 25.4E-3 0 ABYKIK/4 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYKIK1={'be' 'BYKIK' LKIK [ABYKIK/2 25.4E-3 ABYKIK/4 ABYKIK/4 0.5 0.5 pi/2]}';
BYKIK2={'be' 'BYKIK' LKIK [ABYKIK/2 25.4E-3 ABYKIK/4 ABYKIK/4 0.5 0.5 pi/2]}';
%DBYKIK1 : DRIF, L=LKIK
%DBYKIK2 : DRIF, L=LKIK
LSPONT =  1.5 ;%length of possible spontaneous undulator (<=5 m now that TDKIK is also there)
DCB32={'dr' '' 0.8+0.01 []}';
DDL10W={'dr' '' 11.99440265 []}';
DDL10WA={'dr' '' 0.986719 []}';%1.050219
DDL10WB={'dr' '' DDL10W{3}-DDL10WA{3}-LPLATE []}';
DWSDL31A={'dr' '' 0.096237 []}';
DWSDL31B={'dr' '' 0.153763 []}';
DDL10X={'dr' '' 0.126314 []}';
D32CMB={'dr' '' 0.6638034 []}';
D31A={'dr' '' 0.562465-0.002 []}';
D31B={'dr' '' 0.5624381-DRFB{3}-0.002 []}';
D31C={'dr' '' 0.5 []}';
DDL10EM80CM={'dr' '' 9.017887+0.01 []}';
DDL10EM80CMA={'dr' '' 3.703275 []}';%3.906475
DDL10EM80CMB={'dr' '' DDL10EM80CM{3}-DDL10EM80CMA{3}-LSPOTS []}';
DX33A={'dr' '' 1.4154 []}';%LB3-DX33B[L]-2.0
DX33B={'dr' '' 0.385637 []}';%0.449137
DX34B={'dr' '' 0.5 []}';
DX34A={'dr' '' LB3-DX34B{3}-2.0 []}';
DX37B={'dr' '' 0.5 []}';
DX37A={'dr' '' LB3-DX37B{3}-2.0 []}';
DX38A={'dr' '' LB3/2 []}';
DX38B={'dr' '' LB3/2 []}';
DDL1A={'dr' '' 5.820626-LKIK/2 []}';
DDL1AA={'dr' '' 1.220046 []}';%1.261541
DDL1AB={'dr' '' 4.049039 []}';
DDL1D={'dr' '' 0.609226-LKIK/2 []}';
DDL1E={'dr' '' 5.421642-LKIK/2 []}';
D32A={'dr' '' 0.47046 []}';
D32B={'dr' '' 0.47046 []}';
D33A={'dr' '' 0.39 []}';
D33B={'dr' '' 0.32 []}';
D34A={'dr' '' 0.56 []}';
D34B={'dr' '' 0.32 []}';
DSPLR={'dr' '' 0.43036 []}';
DDL1CM40CM={'dr' '' 6.03036-0.43036-0.6096/2 []}';
D30CMA={'dr' '' 0.257426 []}';
DPC1={'dr' '' 0.266697 []}';
DPC2={'dr' '' 0.266697 []}';
DPC3={'dr' '' 0.266697 []}';
DPC4={'dr' '' 0.266697+0.339613-0.8128/2 []}';
DSPONTUA={'dr' '' LSPONT/2 []}';
DSPONTUB={'dr' '' LSPONT/2 []}';
DDL1DM30CM={'dr' '' 0.379160-0.262228 []}';%allow possible new spontaneous undulator here
DCQ31A={'dr' '' 6.037182 []}';
DCQ31AA={'dr' '' 1.350967 []}';%1.514938
DCQ31AB={'dr' '' DCQ31A{3}-DCQ31AA{3}-LPLATE []}';
DCQ31B={'dr' '' 5.811658 []}';
DCQ31BA={'dr' '' 0.827094 []}';
DCQ31BB={'dr' '' DCQ31B{3}-DCQ31BA{3}-LPLATE []}';
D29CMA={'dr' '' 0.29+0.023878+0.1000244+0.1704396 []}';
D32CMD={'dr' '' 0.32-0.056221+0.4000244+0.2404381 []}';
DCQ32A={'dr' '' 5.4817585 []}';
DCB36={'dr' '' 2.7+0.01-1.9 []}';%make it identical to DCB32[L]
DCQ32B={'dr' '' 6.0371785-DCB36{3}-LJAW []}';
D30CM={'dr' '' 0.30 []}';
DDL10M70CM={'dr' '' 12.86072-0.4-0.3-0.09+0.00046 []}';
DDL10MA={'dr' '' 1.365410 []}';
DDL10MB={'dr' '' DDL10M70CM{3}-DDL10MA{3} []}';
DDL10UM25CM={'dr' '' 0.5-0.25-0.2399776+0.2404376 []}';
DDL10V={'dr' '' 12.86072-0.5 []}';
DDL20E={'dr' '' 0.5 []}';
DDL30EM40CM={'dr' '' 1.0-0.4-0.090013 []}';
D40CMB={'dr' '' 0.40+0.090013 []}';
D46CM={'dr' '' (1.0-LJAW)/2 []}';
DDL20={'dr' '' 0.5 []}';
DDL30EM40CMA={'dr' '' 1.0-0.4-0.090013+0.000473 []}';
D40CMD={'dr' '' 0.40+0.090013-0.000473 []}';
D40CME={'dr' '' 0.40+0.090013+0.010447 []}';
DDL30EM40CMB={'dr' '' 1.0-0.4-0.090013-0.010447 []}';
DDL30EM40CMC={'dr' '' 1.0-0.4-0.090013+0.065013 []}';
D40CMF={'dr' '' 0.40+0.090013-0.065013 []}';
% RFBHX12 is moved upstream of BEGHXR
RFBHX12={'mo' 'RFBHX12' LRFBUB []}';
DMUON4={'dr' '' 0.059608016 []}';
DMUON3={'dr' '' DMUON3B{3}-DMUON4{3}-LRFBUB []}';
% dechirper installation (August, 2015)
LCHIRP =  2.0;
D37A={'dr' '' 0.27032 []}';%0.123
D37B={'dr' '' 0.65268 []}';%0.8
D37BA={'dr' '' 0.12489 []}';%0.304687
D37BB={'dr' '' D37B{3}-D37BA{3}-LSPOTS []}';
D37C={'dr' '' 1.261910 []}';%2.804723
D37D={'dr' '' 7.6979813 []}';%6.218668237037
WSDL4={'mo' 'WSDL4' 0 []}';%Patrick K. says this device is used only with the dechirper
D37E={'dr' '' 1.097522857741 []}';
DCHIRPV={'mo' 'DCHIRPV' LCHIRP/2 []}';%split in half
MDCHIRPV={'mo' 'MDCHIRPV' 0 []}';%center of dechirper
%D37f     : DRIF, L=DDL10mb[L]+D34A[L]-7.657981237037-D37e[L]-LCHIRP D37d changed
D37F={'dr' '' 12.63118-D37C{3}-LPLATE-D37D{3}-D37E{3}-LCHIRP []}';
D38A={'dr' '' 0.509870493892 []}';
DCHIRPH={'mo' 'DCHIRPH' LCHIRP/2 []}';%split in half
MDCHIRPH={'mo' 'MDCHIRPH' 0 []}';%center of dechirper
D38B={'dr' '' 0.609117535347 []}';
D38C={'dr' '' 0.540705892339 []}';
D38D={'dr' '' (D34B{3}+DDL10UM25CM{3}+DDL10V{3}+DX38A{3}+DX38B{3})-(D38A{3}+LCHIRP+D38B{3}+D38C{3}) []}';
D38DA={'dr' '' 7.151036 []}';
D38DB={'dr' '' D38D{3}-D38DA{3}-LPLATE []}';
RFBDL1={'mo' 'RFBDL1' 0 []}';
BPMDL2={'mo' 'BPMDL2' 0 []}';
BPMDL3={'mo' 'BPMDL3' 0 []}';
BPMDL4={'mo' 'BPMDL4' 0 []}';
BPMT12={'mo' 'BPMT12' 0 []}';
BPMT22={'mo' 'BPMT22' 0 []}';
BPMT32={'mo' 'BPMT32' 0 []}';
BPMT42={'mo' 'BPMT42' 0 []}';
BPMDL1={'mo' 'BPMDL1' 0 []}';%existing LCLS device
XCDL1={'mo' 'XCDL1' 0 []}';
XCDL2={'mo' 'XCDL2' 0 []}';
XCDL3={'mo' 'XCDL3' 0 []}';
XCQT12={'mo' 'XCQT12' 0 []}';
XCQT22={'mo' 'XCQT22' 0 []}';
XCQT42={'mo' 'XCQT42' 0 []}';
YCDL1={'mo' 'YCDL1' 0 []}';
YCDL2={'mo' 'YCDL2' 0 []}';
YCDL3={'mo' 'YCDL3' 0 []}';
YCDL4={'mo' 'YCDL4' 0 []}';
YCQT12={'mo' 'YCQT12' 0 []}';
YCQT21={'mo' 'YCQT21' 0 []}';
XCQT32={'mo' 'XCQT32' 0 []}';%fast-feedback (loop-4)
XCDL4={'mo' 'XCDL4' 0 []}';%fast-feedback (loop-4)
YCQT32={'mo' 'YCQT32' 0 []}';%fast-feedback (loop-4)
YCQT42={'mo' 'YCQT42' 0 []}';%fast-feedback (loop-4)
SPOILER={'mo' 'SPOILER' 0 []}';%TDKIK dump spoiler
TDKIK={'mo' 'TDKIK' 0.6096 []}';%vertical off-axis in-line dump
%DSPOILER : MARK
%DTDKIK   : DRIF, L=0.6096
WSDL31={'mo' 'WSDL31' 0 []}';
OTR30={'mo' 'OTR30' 0 []}';%LTU slice energy spread (90 deg from TCAV3)
%MOTR30 : MARK             OTR30 abandoned in place
CEDL1={'dr' 'CEDL1' 0.08 []}';%existing LCLS
CEDL3={'dr' 'CEDL3' 0.08 []}';%existing LCLS
CYBX32={'dr' 'CYBX32' LJAW []}';%reconfigured LCLS CY32
CXQT22={'dr' 'CXQT22' LJAW []}';%reconfigured LCLS CX35
CYBX36={'dr' 'CYBX36' LJAW []}';%reconfigured LCLS CY36
% muon collimators after SBD TDKIK in-line dump
PCTDKIK1={'dr' 'PCTDKIK1' LPCTDKIK []}';
PCTDKIK2={'dr' 'PCTDKIK2' LPCTDKIK []}';
PCTDKIK3={'dr' 'PCTDKIK3' LPCTDKIK []}';
PCTDKIK4={'dr' 'PCTDKIK4' LPCTDKIK []}';
%DPCTDKIK : DRIF, L=LPCTDKIK
IMBCS2={'mo' 'IMBCS2' 0 []}';%comparator with IMBCS1 (existing LCLS device)
PC02={'mo' 'PC02' LPLATE []}';
BTM02={'mo' 'BTM02' 0 []}';
PC22={'mo' 'PC22' LSPOTS []}';
PC03={'mo' 'PC03' LPLATE []}';
BTM03={'mo' 'BTM03' 0 []}';
PC04={'mo' 'PC04' LPLATE []}';
BTM04={'mo' 'BTM04' 0 []}';
PC42={'mo' 'PC42' LPLATE []}';
BTM42={'mo' 'BTM42' 0 []}';
PC43={'mo' 'PC43' LSPOTS []}';
BTM43={'mo' 'BTM43' 0 []}';
PC05={'mo' 'PC05' LPLATE []}';
BTM05={'mo' 'BTM05' 0 []}';
PC06={'mo' 'PC06' LPLATE []}';
BTM06={'mo' 'BTM06' 0 []}';
DL23BEG={'mo' 'DL23BEG' 0 []}';
CNTWIGH={'mo' 'CNTWIGH' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
CNTLT2H={'mo' 'CNTLT2H' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
CNTLT3H={'mo' 'CNTLT3H' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
SS1={'mo' 'SS1' 0 []}';
SS3={'mo' 'SS3' 0 []}';
DBMARK34={'mo' 'DBMARK34' 0 []}';%entrance of BX31
% wiggler for sync. light energy diagnostic (described in SLAC-PUB-3945)
% based on FACET optics model (M. Woodley)
% (series approximation for sinc(x)=sin(x)/x to enable setting with x=0)
BWGH =  1.E-12                  ;%wiggler bend field (kG)
AWGH =  asin(BWGH*ZWHP/(EF*CB)) ;%bend angle per half-pole
AWGH2 =  AWGH*AWGH;
AWGH4 =  AWGH2*AWGH2;
AWGH6 =  AWGH4*AWGH2;
SINCH =  1-AWGH2/6+AWGH4/120-AWGH6/5040;
LWGH =  ZWHP/SINCH              ;%half-pole path length
AWG1H =  asin(sin(AWGH)/2) ;%"short half" half-pole bend angle
AWG1H2 =  AWG1H*AWG1H;
AWG1H4 =  AWG1H2*AWG1H2;
AWG1H6 =  AWG1H4*AWG1H2;
SINC1H =  1-AWG1H2/6+AWG1H4/120-AWG1H6/5040;
LWG1H =  (ZWHP/2)/SINC1H   ;%"short half" half-pole path length
AWG2H =  AWGH-AWG1H        ;%"long half" half-pole bend angle
LWG2H =  LWGH-LWG1H        ;%"long half" half-pole path length
WIG1H1={'be' 'WIG1H' LWG1H [AWG1H GWIG/2 0 0 0.5 0 pi/2]}';
WIG1H2={'be' 'WIG1H' LWG2H [AWG2H GWIG/2 0 AWGH 0 0.5 pi/2]}';
WIG2H1={'be' 'WIG2H' LWGH [-AWGH GWIG/2 -AWGH 0 0.5 0 pi/2]}';
WIG2H2={'be' 'WIG2H' LWGH [-AWGH GWIG/2 0 -AWGH 0 0.5 pi/2]}';
WIG3H1={'be' 'WIG3H' LWG2H [AWG2H GWIG/2 AWGH 0 0.5 0 pi/2]}';
WIG3H2={'be' 'WIG3H' LWG1H [AWG1H GWIG/2 0 0 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
WIG1H={'be' 'WIG1H' LWGH [+AWGH GWIG/2 0 +AWGH 0.5 0.5 pi/2]}';
WIG2H={'be' 'WIG2H' 2*LWGH [-2*AWGH GWIG/2 -AWGH -AWGH 0.5 0.5 pi/2]}';
WIG3H={'be' 'WIG3H' LWGH [+AWGH GWIG/2 +AWGH 0 0.5 0.5 pi/2]}';
LDWGH =  ZDWG/cos(AWGH);
DWGH={'dr' '' LDWGH []}';
YCWIGH={'mo' 'YCWIGH' 0 []}';
WIG1H_FULL=[WIG1H1,WIG1H2];
WIG2H_FULL=[WIG2H1,YCWIGH,WIG2H2];
WIG3H_FULL=[WIG3H1,WIG3H2];
EWIGH=[WIG1H_FULL,DWGH,WIG2H_FULL,DWGH,WIG3H_FULL,CNTWIGH];
BX31_FULL=[BX311,BX312];
BX32_FULL=[BX321,BX322];
BYKIK1_FULL=[BYKIK11,BYKIK12];
BYKIK2_FULL=[BYKIK21,BYKIK22];
BX35_FULL=[BX351,BX352];
BX36_FULL=[BX361,BX362];
QDL31_FULL=[QDL31,BPMDL1,QDL31];
QDL32_FULL=[QDL32,BPMDL2,QDL32];
CQ31_FULL=[CQ31,CQ31];
QDL33_FULL=[QDL33,BPMDL3,QDL33];
CQ32_FULL=[CQ32,CQ32];
QDL34_FULL=[QDL34,BPMDL4,QDL34];
QT11_FULL=[QT11,QT11];
QT12_FULL=[QT12,BPMT12,QT12];
QT13_FULL=[QT13,QT13];
QT21_FULL=[QT21,QT21];
QT22_FULL=[QT22,BPMT22,QT22];
QT23_FULL=[QT23,QT23];
QT31_FULL=[QT31,QT31];
QT32_FULL=[QT32,BPMT32,QT32];
QT33_FULL=[QT33,QT33];
QT41_FULL=[QT41,QT41];
QT42_FULL=[QT42,BPMT42,QT42];
QT43_FULL=[QT43,QT43];
DCHIRPV_FULL=[DCHIRPV,MDCHIRPV,DCHIRPV];
DCHIRPH_FULL=[DCHIRPH,MDCHIRPH,DCHIRPH];
DL21=[DBMARK34,BX31_FULL,DDL10WA,PC02,BTM02,DDL10WB,DWSDL31A,WSDL31,DWSDL31B,DDL10X,XCDL1,D31A,QDL31_FULL,DRFB,RFBDL1,D31B,YCDL1,D32CMB,CEDL1,D31C,EWIGH,DDL10EM80CMA,PC22,DDL10EM80CMB,CYBX32,DCB32,BX32_FULL,CNTLT2H];
DL22=[DX33A,CC32,DX33B,PC03,BTM03,DDL1AB,BYKIK1_FULL,DDL1D,DDL1D,BYKIK2_FULL,DDL1E,XCDL2,D32A,QDL32_FULL,D32B,YCDL2,DSPLR,SPOILER,DDL1CM40CM,TDKIK,D30CMA,PCTDKIK1,DPC1,PCTDKIK2,DPC2,PCTDKIK3,DPC3,PCTDKIK4,DPC4,DSPONTUA,DSPONTUB,DDL1DM30CM,DX34A,CC35,DX34B];
DL23=[DL23BEG,BX35_FULL,DCQ31AA,PC04,BTM04,DCQ31AB,CQ31_FULL,DCQ31BA,PC42,BTM42,DCQ31BB,OTR30,D29CMA,XCDL3,D33A,QDL33_FULL,D33B,YCDL3,D32CMD,CEDL3,DCQ32A, CQ32_FULL,DCQ32B,CYBX36,DCB36,BX36_FULL,CNTLT3H];
DL24=[D37A,CC36,D37BA,PC43,BTM43,D37BB,IMBCS2,D37C,PC05,BTM05,D37D,WSDL4,D37E,DCHIRPV_FULL,D37F,QDL34_FULL,D38A,DCHIRPH_FULL,D38B,XCDL4,D38C,YCDL4,D38DA,PC06,BTM06,D38DB];
TRIP1=[DDL20E,QT11_FULL,DDL30EM40CM,XCQT12,D40CMB,QT12_FULL,D40CMB,YCQT12,DDL30EM40CM,QT13_FULL,DDL20E];
TRIP2=[YCQT21,DDL20,QT21_FULL,DDL30EM40CM,XCQT22,D40CMB,QT22_FULL,D46CM,CXQT22,D46CM,QT23_FULL,DDL20];
TRIP3=[DDL20E,QT31_FULL,DDL30EM40CMA,XCQT32,D40CMD,QT32_FULL,D40CME,YCQT32,DDL30EM40CMB,QT33_FULL,DDL20E];
TRIP4=[DDL20,QT41_FULL,DDL30EM40CMC,XCQT42,D40CMF,QT42_FULL,D40CMB,YCQT42,DDL30EM40CM,QT43_FULL,DDL20];
DOGLG2A=[DL21,TRIP1,SS1,DL22,TRIP2];
DOGLG2B=[DL23,TRIP3,SS3,DL24,TRIP4];
% ------------------------------------------------------------------------------
% HXR emittance diagnostic
% ------------------------------------------------------------------------------
KQEM1 =  -0.386250956878;
KQEM2 =   0.429466776058;
KQEM3 =  -0.596168395282;
KQEM4 =   0.419766074433;
QEM1={'qu' 'QEM1' LQA/2 [KQEM1 0]}';
QEM2={'qu' 'QEM2' LQA/2 [KQEM2 0]}';
QEM3={'qu' 'QEM3' LQA/2 [KQEM3 0]}';
QEM3V={'qu' 'QEM3V' LQX/2 [0 0]}';
QEM4={'qu' 'QEM4' LQA/2 [KQEM4 0]}';
KQED2 =  0.402753198232;
KQE31 =  +KQED2;
KQE32 =  -KQED2;
KQE33 =  +KQED2;
KQE34 =  -KQED2;
KQE35 =  +KQED2;
KQE36 =  -KQED2;
QE31={'qu' 'QE31' LQX/2 [KQE31 0]}';
QE32={'qu' 'QE32' LQX/2 [KQE32 0]}';
QE33={'qu' 'QE33' LQX/2 [KQE33 0]}';
QE34={'qu' 'QE34' LQX/2 [KQE34 0]}';
QE35={'qu' 'QE35' LQX/2 [KQE35 0]}';
QE36={'qu' 'QE36' LQX/2 [KQE36 0]}';
DMM1M90CM={'dr' '' 1.20046 []}';
DMM3MA={'dr' '' 4.362410 []}';%4.425910
DMM3MB={'dr' '' DMM3M80CM{3}-DMM3MA{3}-LPLATE []}';
DE3MA={'dr' '' 5.430110 []}';%5.493610
DE3MB={'dr' '' DE3M80CMA{3}-DE3MA{3}-LPLATE []}';
DQECA={'dr' '' 7.950716+0.000011 []}';
DQECB={'dr' '' DQEC{3}-DQECA{3} []}';
D40CMH={'dr' '' 0.0317 []}';
D40CMG={'dr' '' D40CM{3}-D40CMH{3} []}';
DEM1C={'dr' '' DEM1B{3} []}';
BPMEM1={'mo' 'BPMEM1' 0 []}';
BPMEM2={'mo' 'BPMEM2' 0 []}';
BPMEM3={'mo' 'BPMEM3' 0 []}';
BPMEM4={'mo' 'BPMEM4' 0 []}';%existing LCLS device
RFBEM4={'mo' 'RFBEM4' 0 []}';
BPME31={'mo' 'BPME31' 0 []}';
BPME32={'mo' 'BPME32' 0 []}';%existing LCLS device
RFBE32={'mo' 'RFBE32' 0 []}';
BPME33={'mo' 'BPME33' 0 []}';
BPME34={'mo' 'BPME34' 0 []}';%existing LCLS device
RFBE34={'mo' 'RFBE34' 0 []}';
BPME35={'mo' 'BPME35' 0 []}';
BPME36={'mo' 'BPME36' 0 []}';%existing LCLS device
RFBE36={'mo' 'RFBE36' 0 []}';
XCEM2={'mo' 'XCEM2' 0 []}';
XCEM4={'mo' 'XCEM4' 0 []}';
XCE31={'mo' 'XCE31' 0 []}';
XCE33={'mo' 'XCE33' 0 []}';
XCE35={'mo' 'XCE35' 0 []}';
YCEM1={'mo' 'YCEM1' 0 []}';
YCEM3={'mo' 'YCEM3' 0 []}';
YCE32={'mo' 'YCE32' 0 []}';
YCE34={'mo' 'YCE34' 0 []}';
YCE36={'mo' 'YCE36' 0 []}';
WS31={'mo' 'WS31' 0 []}';%LTU emittance
WS32={'mo' 'WS32' 0 []}';%LTU emittance
WS33={'mo' 'WS33' 0 []}';%LTU emittance
WS34={'mo' 'WS34' 0 []}';%LTU emittance
%  WS35 : WIRE, TYPE="fast"  prototype ... not installed
%  WS36 : WIRE, TYPE="piezo" prototype ... not installed
DWS35={'mo' 'DWS35' 0 []}';
DWS36={'mo' 'DWS36' 0 []}';
IM36={'mo' 'IM36' 0 []}';%comparator with IM31 (existing LCLS device)
YAGPSI={'mo' 'YAGPSI' 0 []}';%existing LCLS device
OTR33={'mo' 'OTR33' 0 []}';%LTU slice emittance (existing LCLS device)
PC07={'mo' 'PC07' LPLATE []}';
BTM07={'mo' 'BTM07' 0 []}';
PC08={'mo' 'PC08' LPLATE []}';
BTM08={'mo' 'BTM08' 0 []}';
PC09={'mo' 'PC09' LPLATE []}';
BTM09={'mo' 'BTM09' 0 []}';
DCX31={'dr' '' 0.08 []}';
DCX35={'dr' '' 0.08 []}';
DCY32={'dr' '' 0.08 []}';
DCY36={'dr' '' 0.08 []}';
%CX31 : RCOL, L=0.08 LCLS collimator removed
%CX35 : RCOL, L=0.08 reconfigured as CXQT22
%CY32 : RCOL, L=0.08 reconfigured as CYBX32
%CY36 : RCOL, L=0.08 reconfigured as CYBX36
DBMARK36={'mo' 'DBMARK36' 0 []}';%center of WS31
QEM1_FULL=[QEM1,BPMEM1,QEM1];
QEM2_FULL=[QEM2,BPMEM2,QEM2];
QEM3_FULL=[QEM3,BPMEM3,QEM3];
QEM3V_FULL=[QEM3V,QEM3V];
QEM4_FULL=[QEM4,BPMEM4,QEM4];
QE31_FULL=[QE31,BPME31,QE31];
QE32_FULL=[QE32,BPME32,QE32];
QE33_FULL=[QE33,BPME33,QE33];
QE34_FULL=[QE34,BPME34,QE34];
QE35_FULL=[QE35,BPME35,QE35];
QE36_FULL=[QE36,BPME36,QE36];
EDMCH=[D25CMB,IM36,D25CMC,DMM1M90CM,YCEM1,DEM1A,QEM1_FULL,DEM1C,QEM2_FULL,DEM2B,XCEM2,DMM3MA,PC07,BTM07,DMM3MB,YCEM3,DEM3A,QEM3_FULL,DEM3B,QEM3V_FULL,DMM4M90CM,XCEM4,DEM4A,QEM4_FULL,DRFB,RFBEM4,DMM5A,PC08,BTM08,DMM5B];
EDSYS=[DBMARK36,WS31,D40CM,DE3MA,PC09,BTM09,DE3MB,XCE31,DQEA,QE31_FULL,DQEBX,DCX31,DQEBX2,DE3A,YCE32,DQEAA,QE32_FULL,DRFB,RFBE32,DQEBY1,DCY32,DQEBY2,WS32,D40CM,DE3M80CMB,XCE33,DQEAB,QE33_FULL,DQECA,YAGPSI,DQECB,OTR33,DE3M40CM,YCE34,DQEA,QE34_FULL,DRFB,RFBE34,DQEC1,WS33,D40CM,DE3M80CM,XCE35,DQEAC,QE35_FULL,DQEBX,DCX35,DQEBX2,DE3,YCE36,DQEA,QE36_FULL,DRFB,RFBE36,DQEBY1,DCY36,DQEBY2,WS34,D40CMG,DWS35,D40CMH];
% ------------------------------------------------------------------------------
% HXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values come from Y. Nosochkov's UNDH_KQ4_USDS.xsif file,
%       for E= 4.0 GeV and KHXU= 2.0 (IntgHX= 30.0 kG)
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
KQUM1 =   0.21295276718  ;% 0.266446647337
KQUM2 =  -0.256692261825 ;%-0.257070322217
KQUM3 =   0.472597881562 ;% 0.249191553356
KQUM4 =  -0.42682658336  ;%-0.21849398386
QUM1={'qu' 'QUM1' LQA/2 [KQUM1 0]}';
QUM2={'qu' 'QUM2' LQA/2 [KQUM2 0]}';
QUM3={'qu' 'QUM3' LQA/2 [KQUM3 0]}';
QUM4={'qu' 'QUM4' LQA/2 [KQUM4 0]}';
DU1M80CMA={'dr' '' 0.16515 []}';
DU1M80CMB={'dr' '' DU1M80CM{3}-DU1M80CMA{3} []}';
D32CMC={'dr' '' 0.30046 []}';
DU2M120CM={'dr' '' 4.730 []}';
DW2TDUND={'dr' '' 0.201537 []}';%drift from BTH/UH wall-2 to TDUNDB u/s flange
D40CMWB={'dr' '' 0.140042 []}';
D40CMWA={'dr' '' D40CMW{3}-D40CMWB{3} []}';
BPMUM1={'mo' 'BPMUM1' 0 []}';
BPMUM2={'mo' 'BPMUM2' 0 []}';
BPMUM3={'mo' 'BPMUM3' 0 []}';
BPMUM4={'mo' 'BPMUM4' 0 []}';
RFB07={'mo' 'RFB07' 0 []}';%existing LCLS device
RFB08={'mo' 'RFB08' 0 []}';%existing LCLS device
IMUNDI={'mo' 'IMUNDI' 0 []}';%FEL-undulator input toroid (existing LCLS device)
XCUM1={'mo' 'XCUM1' 0 []}';%fast-feedback (loop-5)
XCUM3={'mo' 'XCUM3' 0 []}';%fast-feedback (loop-5)
YCUM2={'mo' 'YCUM2' 0 []}';%fast-feedback (loop-5)
YCUM4={'mo' 'YCUM4' 0 []}';%fast-feedback (loop-5)
% Note: PCMUON is rolled 90 degree to have X-aperture smaller than Y-aperture
%       X-aperture violates standard BSC -- approved by P. Emma
%PCMUON : ECOL,L=1.1684,XSIZE=8.64E-3/2,YSIZE=4.32E-3/2 original muon scattering collimator after pre-undulator tune-up dump (ID from Rago: 7/18/08)
PCMUON={'dr' 'PCMUON' 1.1684 []}';%90 deg rolled muon scattering collimator
TDUND={'mo' 'TDUND' 0 []}';%LTU insertable block at und. extension entrance (w/ screen)
MM1={'mo' 'MM1' 0 []}';
MM2={'mo' 'MM2' 0 []}';
MM3={'mo' 'MM3' 0 []}';
EOBLM={'mo' 'EOBLM' 0 []}';%future electro-optic bunch length monitor?
BLTOF={'mo' 'BLTOF' 0 []}';%LTUH (gas-jet time-of-flight bunch length monitor)
MUHWALL1={'mo' 'MUHWALL1' 0 []}';%upstream end of BTH/UH wall-1
MUHWALL2={'mo' 'MUHWALL2' 0 []}';%upstream end of BTH/UH wall-2
VV999={'mo' 'VV999' 0 []}';%new vacuum valve just upbeam of undulator
PFILT1={'mo' 'PFILT1' 0 []}';
DBMARK37={'mo' 'DBMARK37' 0 []}';%end of undulator match
RWWAKE4H={'mo' 'RWWAKE4H' 0 []}';%LTUH beampipe wake applied here
QUM1_FULL=[QUM1,BPMUM1,QUM1];
QUM2_FULL=[QUM2,BPMUM2,QUM2];
QUM3_FULL=[QUM3,BPMUM3,QUM3];
QUM4_FULL=[QUM4,BPMUM4,QUM4];
UNMCH=[DU1M80CMA,DWS36,DU1M80CMB,DCX37,D32CMC,XCUM1,DUM1A,QUM1_FULL,DUM1B,D32CM,DU2M120CM,DCY38,D32CMA,YCUM2,DUM2A,QUM2_FULL,DUM2B,DU3M80CM,XCUM3,DUM3A,QUM3_FULL,DUM3B,D40CMA,EOBLM,DU4M120CM,YCUM4,DUM4A,QUM4_FULL,DUM4B,RFB07,DU5M80CM,IMUNDI,D40CMWA,BLTOF,D40CMWB,MUHWALL1,DUHWALL1,DUHVESTA,RFB08,DUHVESTB,MUHWALL2,DUHWALL2,DW2TDUND,DTDUND1,TDUND,DTDUND2,DPCMUON,PCMUON,DMUON1,VV999];
PREUNDH=[DMUON3,RFBHX12,DMUON4,MM3,PFILT1,DBMARK37];
LTU=[VBSYS,MM1,DOGLG2A,DOGLG2B,MM2,EDMCH,EDSYS,UNMCH,RWWAKE4H,ENDLTUH,BEGUNDH,PREUNDH];
% ------------------------------------------------------------------------------
% HXR dumpline
% ------------------------------------------------------------------------------
KQDMP =  -0.155212710055;
QDMP1={'qu' 'QDMP1' LQP/2 [KQDMP 0]}';
QDMP2={'qu' 'QDMP2' LQP/2 [KQDMP 0]}';
BYDSH1={'be' 'BYDSH' LEFFBYDS/2 [ABYDS/2 GBYDS/2 ABYDS/2 0 0.5 0.0 pi/2]}';
BYDSH2={'be' 'BYDSH' LEFFBYDS/2 [ABYDS/2 GBYDS/2 0 ABYDS/2 0.0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYDSH={'be' 'BYDSH' LEFFBYDS [ABYDS GBYDS/2 ABYDS/2 ABYDS/2 0.5 0.5 pi/2]}';
BYD11={'be' 'BYD1' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 0.57 0.00 pi/2]}';
BYD12={'be' 'BYD1' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 0.57 pi/2]}';
BYD21={'be' 'BYD2' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 0.57 0.00 pi/2]}';
BYD22={'be' 'BYD2' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 0.57 pi/2]}';
BYD31={'be' 'BYD3' LEFFBDM/2 [ABDM/2 GBDM/2 ABDM/2 0 0.57 0.00 pi/2]}';
BYD32={'be' 'BYD3' LEFFBDM/2 [ABDM/2 GBDM/2 0 ABDM/2 0.00 0.57 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYD1={'be' 'BYD' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 0.57 0.57 pi/2]}';
BYD2={'be' 'BYD' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 0.57 0.57 pi/2]}';
BYD3={'be' 'BYD3' LEFFBDM [ABDM GBDM/2 ABDM/2 ABDM/2 0.57 0.57 pi/2]}';
PCPM1L={'dr' 'PCPM1L' LPCPM []}';
PCPM2L={'dr' 'PCPM2L' LPCPM []}';
DD1A={'dr' '' 0.577681302427 []}';
DD1B={'dr' '' 1.000087502327 []}';
DD1C={'dr' '' 0.3048 []}';
DD1E={'dr' '' 0.249638105611 []}';
DD1F={'dr' '' 0.409240058046 []}';
DD1D={'dr' '' LDMP1-(DD1A{3}+PCPM1L{3}+DD1B{3}+DD1C{3}+DD1E{3}+PCPM2L{3}+DD1F{3}) []}';
BPMQD={'mo' 'BPMQD' 0 []}';%RFBQD : MONI, TYPE="@2,CavityL-1"
BPMDD={'mo' 'BPMDD' 0 []}';
RFBDD={'mo' 'RFBDD' 0 []}';
XCDD={'mo' 'XCDD' 0 []}';
YCDD={'mo' 'YCDD' 0 []}';
OTRDMP={'mo' 'OTRDMP' 0 []}';%Dump screen
WSDUMP={'mo' 'WSDUMP' 0 []}';
%IMDUMP  : IMON, TYPE="BCS toroid" BCS toroid in dumpline after Y-bends
%IMBCS4  : IMON, TYPE="BCS toroid" BCS comparator toroid (ACM) in dumpline after Y-bends
MIMDUMP={'mo' 'MIMDUMP' 0 []}';
MIMBCS4={'mo' 'MIMBCS4' 0 []}';
BTM1L={'mo' 'BTM1L' 0 []}';%Burn-Through-Monitor behind PCPM1L
BTM2L={'mo' 'BTM2L' 0 []}';%Burn-Through-Monitor behind PCPM2L
DUMPFACE={'mo' 'DUMPFACE' 0 []}';%entrance face of main e- dump
BTMDUMP={'mo' 'BTMDUMP' 0 []}';%Burn-Through-Monitor of main e- dump
MQDMP={'mo' 'MQDMP' 0 []}';
DMPEND={'mo' 'DMPEND' 0 []}';
DBMARK38={'mo' 'DBMARK38' 0 []}';%end of final undulator dump
ARODMP1H =  -ARODMP1S;
ARODMP2H =  -ARODMP2S;
RODMP1H={'ro' 'RODMP1H' 0 [-(ARODMP1H)]}';
RODMP2H={'ro' 'RODMP2H' 0 [-(ARODMP2H)]}';
BYDSH_FULL=[BYDSH1,BYDSH2];
BYD1_FULL=[BYD11,BYD12];
BYD2_FULL=[BYD21,BYD22];
BYD3_FULL=[BYD31,BYD32];
QDMP1_FULL=[QDMP1,QDMP1];
QDMP2_FULL=[QDMP2,QDMP2];
DUMPLINE=[BEGDMPH_2,RODMP1H,BYDSH_FULL,DS1,BYD1_FULL,DS,BYD2_FULL,DS,BYD3_FULL,DD1A,PCPM1L,BTM1L,DD1B,MIMDUMP,DD1C,MIMBCS4,DD1D,YCDD,DD1E,PCPM2L,BTM2L,DD1F,QDMP1_FULL,DD12A,BPMQD,DD12B,MQDMP,DD12C,QDMP2_FULL,DD2A,XCDD,DD2B,DD2C,DD3A,BPMDD,DD3B,OTRDMP,DWSDUMPA,RFBDD,DWSDUMPB,WSDUMP,DWSDUMPC,RODMP2H,DUMPFACE,DDUMP,DMPEND,BTMDUMP,DBMARK38,ENDDMPH_2];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc undulator and undulator extension
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 20-NOV-2019, M. Woodley
%  * add BOD10 and BOD12 for SXRSS-II project per D. Bruch
% 13-NOV-2019, M. Woodley
%  * KQDHXM, KQUE1, KQUE2, and KQDMP values come from Y. Nosochkov's
%    UNDH_KQ4_USDS.xsif file, for E= 4.0 GeV and KHXU= 2.0 (IntgHX= 30.0 kG)
% 17-JUL-2019, M. Woodley
%  * add cell number to phase shifter names
% ------------------------------------------------------------------------------
% 10-MAY-2019, M. Woodley
%  * move BLM's in HXR cells from before undulator to after per H.-D. Nuhn
% 30-APR-2019, M. Woodley
%  * remove M1, M2, and YAGBRAG from HXRSS self-seeding chicane per H.-D. Nuhn
% 19-FEB-2019, M. Woodley
%  * move SXRSS self-seeding chicane from undulator cell 33 to cell 35 per
%    G. Marcus (DCR_2018-012)
%  * move undulator 35 and associated devices to cell 33 (replace "35" with
%    "33" in device names)
% ------------------------------------------------------------------------------
% 08-JAN-2019, M. Woodley
%  * define HXRSS and SXRSS chicane bend angles (rather than integrated
%    strengths) to allow constant R56 when energy changes
%  * set nominal SXRSS beam offset to +17.0 mm per G. Marcus
%  * set nominal HXRSS R56 to +15.0 um per G. Marcus
% ------------------------------------------------------------------------------
% 27-NOV-2018, M. Woodley
%  * move definition of Eu to LCLS2sc_master.xsif and LCLS2cu_master.xsif
%    (for BMAD compatability)
% 29-MAY-2018, M. Woodley
%  * install LCLS HXRSS self-seeding chicane in HXR cell #28 per
%    LCLSII-3.2-PR-0102-R1; chicane is off for high-rate beams from SC linac
%  * install LCLS SXRSS self-seeding chicane in SXR cell #33 per
%    LCLSII-3.2-PR-0101-R0
% 30-APR-2018, M. Woodley
%  * set aperture radius of PCPM0/PCPM0B to 1.75 cm (circular) per RP-14-15-R5
%    section 4.3 (two permanant magnet bends in SXR safety dump line)
% 27-APR-2018, M. Woodley
%  * add a second set of beam phase monitors 1.5 m u/s of original set per
%    C. Xu (TID); original cavities (PH31-32,PH31B-32B, for low-rate beam) are
%    2805 MHz ... new cavities (PH33-34,PH33B-34B, for high-rate beam) will be
%    2604 MHz; all but original LCLS cavities (PH31-32) are deferred
% ------------------------------------------------------------------------------
% 22-JAN-2018, M. Woodley
%  * move SXR phase shifters 5 mm upstream per D. Bruch
% 20-DEC-2017, M. Woodley
%  * defer (level 0) PH31b and PH32b
% 04-DEC-2017, M. Woodley
%  * define dzHXTES parameter to adjust lengths of DUE5e and DDLWALL by ~0.7 um
%    to set BSY-Z of MDLWALL to exactly 685 m (to align with HXR XTES system)
%  * define drifts DUE5eB and DDLWALLB (DUE5e and DDLWALL on SXR side)
%  * define dzSXTES parameter to adjust lengths of DUE5eB and DDLWALLB by ~0.7 um
%    to set BSY-Z of MDLWALLb to exactly 685 m (to align with SXR XTES system)
% ------------------------------------------------------------------------------
% 06-SEP-2017, Y. Nosochkov
%  * move PH32, PH32B 0.012 m upstream to Z = 674.062492 (BSY coordinates)
%    (M. Kosovsky)
%  * change length of DU2h drift from negative value to zero, adjust lengths
%    of nearby drifts to keep the same device positions
%  * update definition of phase shifters in undulators (H.-D. Nuhn),
%    increase phase shifter period to 75 mm (SXR) and 45 mm (HXR),
%    define phase shifter undulator K-parameter through phase integral (PI)
%  * note: the present setting of the integrated field IntgHX of HXR undulator
%    quadrupoles is 12 kG. Per H.-D. Nuhn, it needs to be increased to 26 kG.
%    This however, does not match well with the dumpline optics at 4 GeV.
%    Additional quad(s) may need to be included downstream of the undulator
%    or in the dumpline -- to be studied
% 05-SEP-2017, M. Woodley
%  * move IntgSX and IntgHX defn's to LCLS2sc_main.xsif and LCLS2cu_main.xsif
%  * move XbandF definition to common.xsif
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * Beam Loss Monitors (BLMS*, BLMH*): keyword=INST
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * update device positions in the undulator cells (D. Bruch)
%    note that RFBHX12 moves upstream into LTUH
%  * remove RFBHX49 (D. Bruch, H-D. Nuhn)
%  * move RFBHX51, RFBSX51 0.057 m upstream (D. Bruch)
%  * move BTMQUEB 0.1016 m downstream (M. Owens)
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * specify half-aperture of PCTCX, PCTCXB to be 4.5 mm (per deck note)
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * defer PCTCXB, SPTCXB to level @1 (P. Emma)
%  * change the type of existing BPMUE1, BPMUE2 from Stripline-1 to
%    Stripline-13 (M. Woodley, Alev)
%  * change the type of BPMUE1B, BPMUE2B from Stripline-1 to Stripline-5 to
%    fit the 2Q10 quads
%  * remove existing toroids IMUNDO, IMBCS3 as they are not compatible
%    with SCRF beam (S. Mao, P. Emma)
%  * remove deferred IMUNDOB (S. Mao)
%  * update positions of BPMUE1&2, BPMUE1B&2B and BTMQUEB (M. Owens)
% ------------------------------------------------------------------------------
% 26-FEB-2016, Y. Nosochkov
%  * replace the HXR undulator with HGVPU undulator (D. Bruch, M. Rowen)
%  * VPU undulator length: 3.373968 m
%  * VPU undulator cell length: 4.01266666667 m
%  * same undulator period and K-value in VPU as before (H-D. Nuhn)
%  * move the RFBHX16, previously located upstream of undulator, to just after
%    the VPU undulator and rename to RFBHX49 -- this keeps the number
%    of RFBPMs unchanged
% 26-FEB-2016, M. Woodley
%  * remove SEQnn MARKers
%  * define new areas: UEH (HXR end to BYD1) and UES (SXR end to BYD1B)
% ------------------------------------------------------------------------------
% 24-AUG-2015, Y. Nosochkov
%  * adjust positions of BPMUE1, BPMUE2 (per M. Owens)
%  * match dumpline optics to new TCAV/OTR constraints (per Y. Ding)
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * assign IMUNDO, IMUNDOb to be BCS current monitors
% 20-MAY-2015, Y. Nosochkov
%  * change the status of BPMUE1, BPMUE2, BPMUE1B, BPMUE2B from deferred
%    to baseline
%  * update aperture of PCPM0, PCPM0B (per Shanjie)
%  * defer THz Be foils TRUE1, TRUE1B at level @5 (per Tor and A. Fisher)
% ------------------------------------------------------------------------------
% 20-MAR-2015, M. Woodley
%  * assign TYPEs to BCS devices ... defer at level 0
% 12-MAR-2015, Y. Nosochkov
%  * change type of QUE1B, QUE2B from "1.97Q10" to "2Q10"
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * change some RFBs (defer=2) to BPMs (defer=0)
%  * assign BPM TYPE attributes per PRD LCLSII-2.4-PR-0136
% 09-DEC-2014, Y. Nosochkov
%  * restore dumpline toroid IMBCS3 in HXR (per LCLSII-2.4-PR-0107)
%  * assign the non-baseline level "4" to TRUE1b (Be foil, THz) in SXR
%  * change type of QUE1b, QUE2b to "1.97Q10"
%  * change type of undulator quads to "0.433Q3.1" (per J. Amann)
%  * rename BTM0, BTM0b to BTMQUE, BTMQUEb (per Shanjie Xiao)
%  * add BTM0, BTM0b downstream of PCPM0 and PCPM0b (per Shanjie Xiao)
%  * change stripline to RF bpms in the SXR undulator extension:
%    BPMSX16 -> RFBSX16, BPMSX19 -> RFBSX19, BPMSX21 -> RFBSX21
%  * add PH31, PH32, PH31b, PH32b post-undulator phase measurement cavities
% ------------------------------------------------------------------------------
% 13-OCT-2014, Y. Nosochkov
%  * remove RFBUE3, RFBUE3B in the dumplines
%  * replace XCUE1 -> YCUE1, YCUE2 -> XCUE2, XCUE1b -> YCUE1b, YCUE2b -> XCUE2b
%  * add marker for dumpline wall
% 10-OCT-2014, Y. Nosochkov
%  * update TYPE of (6) RFBPMs to indicate the non-baseline level "0"
% 07-AUG-2014, M. Woodley
%  * decorate device TYPE attributes to indicate non-baseline status
% 31-JUL-2014, Y. Nosochkov
%  * remove IMBCS3, IMBCS3b
% 23-JUL-2014, Y. Nosochkov
%  * remove SXR extension cell SXCEL15, use this space (4.4 m) for moving
%    TDUNDb 2.8 m downstream,
%  * replace the quads QSXh15 and QSXh22 with QSXh16 and QSXh21
% 17-JUN-2014, Y. Nosochkov
%  * replace all stripline BPMs downstream of the undulators with RFBPMs
%    (per J. Frisch)
%  * change type of IMUNDO, IMUNDOB from toroid to beam current monitor
%    (per J. Frisch)
% 21-MAY-2014, Y. Nosochkov
%  * move marker points ENDSXR, BEGDMPS and ENDHXR, BEGDMPH to the downstream
%    end of RFBSX51 and RFBHX51 in order to include these RFBPMs into the
%    SXR and HXR areas as defined in PRD LCLSII-2.1-PR-0134
%    (per request from D. Hanquist)
% 02-MAY-2014, M. Woodley
%  * add MTCX01 and MTCX01b MARKERs (for ELEGANT WATCH points)
%  * explicitly define R55=R66=1 in MATRs (for translation to BMAD)
% 24-APR-2014, Y. Nosochkov
%  * include place holder DBKXDMPS(H) for dumpline x-kicker (per J. Frisch)
% 22-APR-2014, Y. Nosochkov
%  * restore T-cavities TCX01B, TCX02B in SXR dumpline (per J. Frisch)
% 07-APR-2014, M. Woodley
%  * move undulator phase shifter definitions earlier in this file to avoid
%    using LPSSH and LPSHX parameters before they are defined
% ------------------------------------------------------------------------------
% 31-MAR-2014, M. Woodley
%  * element names changed to conform to nomenclature PRD
% 26-MAR-2014, Y. Nosochkov
%  * put phase shifter and RFBPM positions back to 03/14 version
% 21-MAR-2014, Y. Nosochkov
%  * update positions of phase shifters and RFBPMs in undulator cells
%  * add Y-corrector to each undulator
%  * update phase shifter parameters (per H-D. Nuhn)
% 07-MAR-2014, Y. Nosochkov
%  * remove transverse deflecting cavities from SXR dumpline
%  * slightly adjust Z-position of dumpline bends
% 06-MAR-2014, Y. Nosochkov
%  * minor matching update
% ------------------------------------------------------------------------------
% 28-FEB-2014, Y. Nosochkov
%  * reduce undulator break length from 1.15 m to 1.0 m for cell length of 4.4 m
%    use cell numbering from 15 to 50 (this includes cells with and without
%    undulators)
%    put SXR undulators in cells 26-32, 34-47
%    put HXR undulators in cells 17-23, 25-31, 33-50
%    the SXR cell-33 and HXR cells 24 and 32 have only quad and RFBPM --
%    these cells will be used for self-seeding
%    reduce length of undulator quadrupole to 0.084 m
%    add one extra RFBPM about ~1 m after end of cell-50 in SXR and HXR
%    add two RFBPMs in two cells upstream of SXR and HXR undulators
%    use the last undulator quadrupole in cell-50 for matching to dump line
% 17-JAN-2014, Y. Nosochkov
%  * minor matching update
% 18-DEC-2013, Y. Nosochkov
%  * minor matching update
% 16-DEC-2013, Y. Nosochkov
%  * minor matching update
% 23-OCT-2013, Y. Nosochkov
%  * change the number of SXR undulator cells to 22 and the number of
%    SXR extension cells to 12
%  * change the number of HXR undulator cells to 34
%  * change undulator cell length to 4.55 m
%  * update undulator parameters and undulator quad field (per H.-D. Nuhn)
%  * new position of SXRTERM, HXRTERM is at Z'=669.586491 m in BSY coordinates
%  * move QUE1, QUE1B 4.0 m downstream
%  * adjust strengths in the last two undulator quads to help with
%    beta match in the dumpline
% 17-OCT-2013, Y. Nosochkov
%  * change quadrupole type of QUE1B, QUE2B, QDMP1B, QDMP2B to 3.94Q17
% ------------------------------------------------------------------------------
% ==============================================================================
% SXR undulator and extension (north)
% ==============================================================================
% ------------------------------------------------------------------------------
% SXR undulator PPM phase shifter
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited September 06, 2017
% - 10.0 mm miminum Undulator Gap
% ------------------------------------------------------------------------------
% - LPSSX  = SXR Phase Shifter length
% - luPSSX = SXR Phase Shifter period
% - PIPSSX = SXR Phase Shifter phase integral
% - KPSSX  = SXR Phase Shifter Undulator parameter (rms); range 1.34-3.59
% - kQPSSX = natural SXR Phase Shifter undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
%Eu     :  definition moved to LCLS2sc_master.xsif and LCLS2cu_master.xsif
GAMU =  EU/MC2                             ;%Lorentz energy factor in undulator [ ]
LPSSX =  0.0825                             ;%m
LUPSSX =  0.075                              ;%m
LPSSXH =  LPSSX/2;
PIPSSX =  3814                               ;%T^2mm^3 (180-3814)
KPSSX =  1.E-9*CLIGHT/MC2*sqrt(2.E-9*PIPSSX/LUPSSX);
KQPSSX =  (KPSSX*2*PI/LUPSSX/sqrt(2)/GAMU)^2 ;%m^-2
PSSX={'un' 'PSSX' LPSSXH [KQPSSX LUPSSX 1]}';
PSSX26=PSSX;PSSX26{2}='PSSX26';
PSSX27=PSSX;PSSX27{2}='PSSX27';
PSSX28=PSSX;PSSX28{2}='PSSX28';
PSSX29=PSSX;PSSX29{2}='PSSX29';
PSSX30=PSSX;PSSX30{2}='PSSX30';
PSSX31=PSSX;PSSX31{2}='PSSX31';
PSSX32=PSSX;PSSX32{2}='PSSX32';
PSSX33=PSSX;PSSX33{2}='PSSX33';
PSSX34=PSSX;PSSX34{2}='PSSX34';
PSSX36=PSSX;PSSX36{2}='PSSX36';
PSSX37=PSSX;PSSX37{2}='PSSX37';
PSSX38=PSSX;PSSX38{2}='PSSX38';
PSSX39=PSSX;PSSX39{2}='PSSX39';
PSSX40=PSSX;PSSX40{2}='PSSX40';
PSSX41=PSSX;PSSX41{2}='PSSX41';
PSSX42=PSSX;PSSX42{2}='PSSX42';
PSSX43=PSSX;PSSX43{2}='PSSX43';
PSSX44=PSSX;PSSX44{2}='PSSX44';
PSSX45=PSSX;PSSX45{2}='PSSX45';
PSSX46=PSSX;PSSX46{2}='PSSX46';
% ------------------------------------------------------------------------------
% SXR drifts
% ------------------------------------------------------------------------------
LDUSEGS =  3.4;
LDU1S =  0.1;
LDU2S =  0.03;
LDU3S =  0.25-LPSSXH -0.04 -0.005;
LDU4S =  (0.25-LPSSXH-0.5*LQU)/2 +0.04 +0.005;
LDU5S =  (0.25-LPSSXH-0.5*LQU)/2;
LDU6S =  0.12-LQU/2-LRFBUB/2 +0.01;
LDU7S =  0.25-LRFBUB/2 -0.01;
DLDU0S =  0.0 ;%fine tune Z in undulator
LDU0S =  2.1359-LDU6S-LDU7S-LQU +DLDU0S;
DU0S={'dr' '' LDU0S []}';
DU1S={'dr' '' LDU1S []}';
DU2S={'dr' '' LDU2S []}';
DU3S={'dr' '' LDU3S []}';
DU4S={'dr' '' LDU4S []}';
DU5S={'dr' '' LDU5S []}';
DU6S={'dr' '' LDU6S []}';
DU7S={'dr' '' LDU7S []}';
DUE1AB={'dr' '' 0.9-LRFBUB-0.057 []}';
DUE1E={'dr' '' 0.057 []}';
% ------------------------------------------------------------------------------
% SXR extension quads
% ------------------------------------------------------------------------------
% note: the below K-values come from Y. Nosochkov's UNDS_KQ5_US.xsif file,
%       for E= 4.0 GeV and KSXU= 5.0 (IntgXS= 30.0 kG)
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
KQSX16 =   0.386434780667 ;
KQSX19 =  -0.894006742269;
KQSX21 =   1.22862150816;
KQSX24 =  -1.251292803834 ;
QSX16={'qu' 'QSX16' LQU/2 [KQSX16 0]}';
QSX19={'qu' 'QSX19' LQU/2 [KQSX19 0]}';
QSX21={'qu' 'QSX21' LQU/2 [KQSX21 0]}';
QSX24={'qu' 'QSX24' LQU/2 [KQSX24 0]}';
% ------------------------------------------------------------------------------
% SXR extension X-steering coils in quads
% ------------------------------------------------------------------------------
XCSX16={'mo' 'XCSX16' 0 []}';
XCSX19={'mo' 'XCSX19' 0 []}';
XCSX21={'mo' 'XCSX21' 0 []}';
XCSX24={'mo' 'XCSX24' 0 []}';
% ------------------------------------------------------------------------------
% SXR extension Y-steering coils in quads
% ------------------------------------------------------------------------------
YCSX16={'mo' 'YCSX16' 0 []}';
YCSX19={'mo' 'YCSX19' 0 []}';
YCSX21={'mo' 'YCSX21' 0 []}';
YCSX24={'mo' 'YCSX24' 0 []}';
% ------------------------------------------------------------------------------
% SXR extension BPMs
% ------------------------------------------------------------------------------
RFBSX16={'mo' 'RFBSX16' LRFBUB []}';
DRFBS17={'dr' '' LRFBUB []}';
DRFBS18={'dr' '' LRFBUB []}';
RFBSX19={'mo' 'RFBSX19' LRFBUB []}';
DRFBS20={'dr' '' LRFBUB []}';
RFBSX21={'mo' 'RFBSX21' LRFBUB []}';
DRFBS22={'dr' '' LRFBUB []}';
DRFBS23={'dr' '' LRFBUB []}';
RFBSX24={'mo' 'RFBSX24' LRFBUB []}';
RFBSX25={'mo' 'RFBSX25' LRFBUB []}';
SXXSTART={'mo' 'SXXSTART' 0 []}';%start of soft X-ray extension system
SXXTERM={'mo' 'SXXTERM' 0 []}';%end of soft X-ray extension system
SXRSTART={'mo' 'SXRSTART' 0 []}';%start of undulator system
RWWAKE5S={'mo' 'RWWAKE5S' 0 []}';%SXR beampipe wake applied here
SXRTERM={'mo' 'SXRTERM' 0 []}';%~end of undulator system
MUQS={'mo' 'MUQS' 0 []}';
MPHS={'mo' 'MPHS' 0 []}';
QSX16_FULL=[QSX16,XCSX16,YCSX16,QSX16];
DQSX17={'dr' '' LQU []}';
DQSX18={'dr' '' LQU []}';
QSX19_FULL=[QSX19,XCSX19,YCSX19,QSX19];
DQSX20={'dr' '' LQU []}';
QSX21_FULL=[QSX21,XCSX21,YCSX21,QSX21];
DQSX22={'dr' '' LQU []}';
DQSX23={'dr' '' LQU []}';
QSX24_FULL=[QSX24,XCSX24,YCSX24,QSX24];
DQSX25={'dr' '' LQU []}';
DPSSX17={'dr' '' LPSSX []}';
DPSSX18={'dr' '' LPSSX []}';
DPSSX19={'dr' '' LPSSX []}';
DPSSX20={'dr' '' LPSSX []}';
DPSSX21={'dr' '' LPSSX []}';
DPSSX22={'dr' '' LPSSX []}';
DPSSX23={'dr' '' LPSSX []}';
DPSSX24={'dr' '' LPSSX []}';
DPSSX25={'dr' '' LPSSX []}';
SXBRK17=[DU3S,DPSSX17,DU4S,DU5S,DQSX17    ,DU6S,DRFBS17,DU7S];
SXBRK18=[DU3S,DPSSX18,DU4S,DU5S,DQSX18    ,DU6S,DRFBS18,DU7S];
SXBRK19=[DU3S,DPSSX19,DU4S,DU5S,QSX19_FULL,DU6S,RFBSX19,DU7S];
SXBRK20=[DU3S,DPSSX20,DU4S,DU5S,DQSX20    ,DU6S,DRFBS20,DU7S];
SXBRK21=[DU3S,DPSSX21,DU4S,DU5S,QSX21_FULL,DU6S,RFBSX21,DU7S];
SXBRK22=[DU3S,DPSSX22,DU4S,DU5S,DQSX22    ,DU6S,DRFBS22,DU7S];
SXBRK23=[DU3S,DPSSX23,DU4S,DU5S,DQSX23    ,DU6S,DRFBS23,DU7S];
SXBRK24=[DU3S,DPSSX24,DU4S,DU5S,QSX24_FULL,DU6S,RFBSX24,DU7S];
SXBRK25=[DU3S,DPSSX25,DU4S,DU5S,DQSX25    ,DU6S,RFBSX25,DU7S];
DUSEGS17={'dr' '' LDUSEGS []}';
DUSEGS18={'dr' '' LDUSEGS []}';
DUSEGS19={'dr' '' LDUSEGS []}';
DUSEGS20={'dr' '' LDUSEGS []}';
DUSEGS21={'dr' '' LDUSEGS []}';
DUSEGS22={'dr' '' LDUSEGS []}';
DUSEGS23={'dr' '' LDUSEGS []}';
DUSEGS24={'dr' '' LDUSEGS []}';
DUSEGS25={'dr' '' LDUSEGS []}';
SXCEL17=[DU1S,DU2S,DUSEGS17,SXBRK17];
SXCEL18=[DU1S,DU2S,DUSEGS18,SXBRK18];
SXCEL19=[DU1S,DU2S,DUSEGS19,SXBRK19];%Q+RFBPM
SXCEL20=[DU1S,DU2S,DUSEGS20,SXBRK20];
SXCEL21=[DU1S,DU2S,DUSEGS21,SXBRK21];%Q+RFBPM
SXCEL22=[DU1S,DU2S,DUSEGS22,SXBRK22];
SXCEL23=[DU1S,DU2S,DUSEGS23,SXBRK23];
SXCEL24=[DU1S,DU2S,DUSEGS24,SXBRK24];%Q+RFBPM
SXCEL25=[DU1S,DU2S,DUSEGS25,SXBRK25];%RFBPM
SXRXX=[SXXSTART,DU0S,QSX16_FULL,DU6S,RFBSX16,DU7S,SXCEL17,SXCEL18,SXCEL19,SXCEL20,SXCEL21,SXCEL22,SXCEL23,SXCEL24,SXCEL25,SXXTERM];
% ------------------------------------------------------------------------------
% SXR undulator
% ------------------------------------------------------------------------------
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited Mar 03, 2014
% - 7.2 mm miminum Undulator Gap; only constant break length each
% - include natural vertical focusing over all but edge terminations
% ------------------------------------------------------------------------------
% - IntgSX  = integrated quadrupole gradient
% - GQFSX   = QF and QD gradients can be made different to compensate for
%             undulator focussing ...
% - GQDSX   = ... but since undulator focussing depends on gamma^2, compensation
%             will only work for one energy
% - kQFSX   = QF undulator quadrupole focusing "k"
% - kQDSX   = QD undulator quadrupole focusing "k"
% - LDUSEGS = SXR Undulator segment length
% - luSXU   = SXR Undulator period
% - NpSXU   = SXR Undulator period count
% - LSXUCR  = SXR Undulator magnetic length
% - LSXUe   = SXR Undulator spacing between magnet array and strongback end
% - KSXU    = SXR Undulator parameter (rms); range 2-5.5
% - kQSX    = natural SXR undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
%IntgSX :   definition moved to LCLS2sc_main.xsif and LCLS2cu_main.xsif
GQFSX =   INTGSX/LQU/10*1.0           ;%T/m
GQDSX =  -INTGSX/LQU/10*1.0           ;%T/m
KQFSX =   1.E-9*GQFSX*CLIGHT/GAMU/MC2 ;%m^-2
KQDSX =   1.E-9*GQDSX*CLIGHT/GAMU/MC2 ;%m^-2
KQDSXM =  -1.28484                     ;%-0.266792876891
QSX26={'qu' 'QSX26' LQU/2 [KQFSX 0]}';
QSX27={'qu' 'QSX27' LQU/2 [KQDSX 0]}';
QSX28={'qu' 'QSX28' LQU/2 [KQFSX 0]}';
QSX29={'qu' 'QSX29' LQU/2 [KQDSX 0]}';
QSX30={'qu' 'QSX30' LQU/2 [KQFSX 0]}';
QSX31={'qu' 'QSX31' LQU/2 [KQDSX 0]}';
QSX32={'qu' 'QSX32' LQU/2 [KQFSX 0]}';
QSX33={'qu' 'QSX33' LQU/2 [KQDSX 0]}';
QSX34={'qu' 'QSX34' LQU/2 [KQFSX 0]}';
QSX35={'qu' 'QSX35' LQU/2 [KQDSX 0]}';
QSX36={'qu' 'QSX36' LQU/2 [KQFSX 0]}';
QSX37={'qu' 'QSX37' LQU/2 [KQDSX 0]}';
QSX38={'qu' 'QSX38' LQU/2 [KQFSX 0]}';
QSX39={'qu' 'QSX39' LQU/2 [KQDSX 0]}';
QSX40={'qu' 'QSX40' LQU/2 [KQFSX 0]}';
QSX41={'qu' 'QSX41' LQU/2 [KQDSX 0]}';
QSX42={'qu' 'QSX42' LQU/2 [KQFSX 0]}';
QSX43={'qu' 'QSX43' LQU/2 [KQDSX 0]}';
QSX44={'qu' 'QSX44' LQU/2 [KQFSX 0]}';
QSX45={'qu' 'QSX45' LQU/2 [KQDSX 0]}';
QSX46={'qu' 'QSX46' LQU/2 [KQFSX 0]}';
QSX47={'qu' 'QSX47' LQU/2 [KQDSXM 0]}';
LUSXU =  0.039                            ;%m
NPSXU =  87;
LSXUCR =  LUSXU*NPSXU                      ;%m
LSXUE =  (LDUSEGS-LSXUCR)/2               ;%m
LSXUH =  LSXUCR/2;
KSXU =  5.0;
KQSX =  (KSXU*2*PI/LUSXU/sqrt(2)/GAMU)^2 ;%m^-2
UMASX={'un' 'UMASX' LSXUH [KQSX LUSXU 1]}';
UMASX26=UMASX;UMASX26{2}='UMASX26';
UMASX27=UMASX;UMASX27{2}='UMASX27';
UMASX28=UMASX;UMASX28{2}='UMASX28';
UMASX29=UMASX;UMASX29{2}='UMASX29';
UMASX30=UMASX;UMASX30{2}='UMASX30';
UMASX31=UMASX;UMASX31{2}='UMASX31';
UMASX32=UMASX;UMASX32{2}='UMASX32';
UMASX33=UMASX;UMASX33{2}='UMASX33';
UMASX34=UMASX;UMASX34{2}='UMASX34';
UMASX36=UMASX;UMASX36{2}='UMASX36';
UMASX37=UMASX;UMASX37{2}='UMASX37';
UMASX38=UMASX;UMASX38{2}='UMASX38';
UMASX39=UMASX;UMASX39{2}='UMASX39';
UMASX40=UMASX;UMASX40{2}='UMASX40';
UMASX41=UMASX;UMASX41{2}='UMASX41';
UMASX42=UMASX;UMASX42{2}='UMASX42';
UMASX43=UMASX;UMASX43{2}='UMASX43';
UMASX44=UMASX;UMASX44{2}='UMASX44';
UMASX45=UMASX;UMASX45{2}='UMASX45';
UMASX46=UMASX;UMASX46{2}='UMASX46';
UMASX47=UMASX;UMASX47{2}='UMASX47';
% ------------------------------------------------------------------------------
% SXR undulator X-steering coils in quads
% ------------------------------------------------------------------------------
XCSX26={'mo' 'XCSX26' 0 []}';
XCSX27={'mo' 'XCSX27' 0 []}';
XCSX28={'mo' 'XCSX28' 0 []}';
XCSX29={'mo' 'XCSX29' 0 []}';
XCSX30={'mo' 'XCSX30' 0 []}';
XCSX31={'mo' 'XCSX31' 0 []}';
XCSX32={'mo' 'XCSX32' 0 []}';
XCSX33={'mo' 'XCSX33' 0 []}';
XCSX34={'mo' 'XCSX34' 0 []}';
XCSX35={'mo' 'XCSX35' 0 []}';
XCSX36={'mo' 'XCSX36' 0 []}';
XCSX37={'mo' 'XCSX37' 0 []}';
XCSX38={'mo' 'XCSX38' 0 []}';
XCSX39={'mo' 'XCSX39' 0 []}';
XCSX40={'mo' 'XCSX40' 0 []}';
XCSX41={'mo' 'XCSX41' 0 []}';
XCSX42={'mo' 'XCSX42' 0 []}';
XCSX43={'mo' 'XCSX43' 0 []}';
XCSX44={'mo' 'XCSX44' 0 []}';
XCSX45={'mo' 'XCSX45' 0 []}';
XCSX46={'mo' 'XCSX46' 0 []}';
XCSX47={'mo' 'XCSX47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator Y-steering coils in quads
% ------------------------------------------------------------------------------
YCSX26={'mo' 'YCSX26' 0 []}';
YCSX27={'mo' 'YCSX27' 0 []}';
YCSX28={'mo' 'YCSX28' 0 []}';
YCSX29={'mo' 'YCSX29' 0 []}';
YCSX30={'mo' 'YCSX30' 0 []}';
YCSX31={'mo' 'YCSX31' 0 []}';
YCSX32={'mo' 'YCSX32' 0 []}';
YCSX33={'mo' 'YCSX33' 0 []}';
YCSX34={'mo' 'YCSX34' 0 []}';
YCSX35={'mo' 'YCSX35' 0 []}';
YCSX36={'mo' 'YCSX36' 0 []}';
YCSX37={'mo' 'YCSX37' 0 []}';
YCSX38={'mo' 'YCSX38' 0 []}';
YCSX39={'mo' 'YCSX39' 0 []}';
YCSX40={'mo' 'YCSX40' 0 []}';
YCSX41={'mo' 'YCSX41' 0 []}';
YCSX42={'mo' 'YCSX42' 0 []}';
YCSX43={'mo' 'YCSX43' 0 []}';
YCSX44={'mo' 'YCSX44' 0 []}';
YCSX45={'mo' 'YCSX45' 0 []}';
YCSX46={'mo' 'YCSX46' 0 []}';
YCSX47={'mo' 'YCSX47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator X-steering coils in undulator segments
% ------------------------------------------------------------------------------
XCSU26={'mo' 'XCSU26' 0 []}';
XCSU27={'mo' 'XCSU27' 0 []}';
XCSU28={'mo' 'XCSU28' 0 []}';
XCSU29={'mo' 'XCSU29' 0 []}';
XCSU30={'mo' 'XCSU30' 0 []}';
XCSU31={'mo' 'XCSU31' 0 []}';
XCSU32={'mo' 'XCSU32' 0 []}';
XCSU33={'mo' 'XCSU33' 0 []}';
XCSU34={'mo' 'XCSU34' 0 []}';
XCSU36={'mo' 'XCSU36' 0 []}';
XCSU37={'mo' 'XCSU37' 0 []}';
XCSU38={'mo' 'XCSU38' 0 []}';
XCSU39={'mo' 'XCSU39' 0 []}';
XCSU40={'mo' 'XCSU40' 0 []}';
XCSU41={'mo' 'XCSU41' 0 []}';
XCSU42={'mo' 'XCSU42' 0 []}';
XCSU43={'mo' 'XCSU43' 0 []}';
XCSU44={'mo' 'XCSU44' 0 []}';
XCSU45={'mo' 'XCSU45' 0 []}';
XCSU46={'mo' 'XCSU46' 0 []}';
XCSU47={'mo' 'XCSU47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator Y-steering coils in undulator segments
% ------------------------------------------------------------------------------
YCSU26={'mo' 'YCSU26' 0 []}';
YCSU27={'mo' 'YCSU27' 0 []}';
YCSU28={'mo' 'YCSU28' 0 []}';
YCSU29={'mo' 'YCSU29' 0 []}';
YCSU30={'mo' 'YCSU30' 0 []}';
YCSU31={'mo' 'YCSU31' 0 []}';
YCSU32={'mo' 'YCSU32' 0 []}';
YCSU33={'mo' 'YCSU33' 0 []}';
YCSU34={'mo' 'YCSU34' 0 []}';
YCSU36={'mo' 'YCSU36' 0 []}';
YCSU37={'mo' 'YCSU37' 0 []}';
YCSU38={'mo' 'YCSU38' 0 []}';
YCSU39={'mo' 'YCSU39' 0 []}';
YCSU40={'mo' 'YCSU40' 0 []}';
YCSU41={'mo' 'YCSU41' 0 []}';
YCSU42={'mo' 'YCSU42' 0 []}';
YCSU43={'mo' 'YCSU43' 0 []}';
YCSU44={'mo' 'YCSU44' 0 []}';
YCSU45={'mo' 'YCSU45' 0 []}';
YCSU46={'mo' 'YCSU46' 0 []}';
YCSU47={'mo' 'YCSU47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator BPMs
% ------------------------------------------------------------------------------
RFBSX26={'mo' 'RFBSX26' LRFBUB []}';
RFBSX27={'mo' 'RFBSX27' LRFBUB []}';
RFBSX28={'mo' 'RFBSX28' LRFBUB []}';
RFBSX29={'mo' 'RFBSX29' LRFBUB []}';
RFBSX30={'mo' 'RFBSX30' LRFBUB []}';
RFBSX31={'mo' 'RFBSX31' LRFBUB []}';
RFBSX32={'mo' 'RFBSX32' LRFBUB []}';
RFBSX33={'mo' 'RFBSX33' LRFBUB []}';
RFBSX34={'mo' 'RFBSX34' LRFBUB []}';
RFBSX35={'mo' 'RFBSX35' LRFBUB []}';
RFBSX36={'mo' 'RFBSX36' LRFBUB []}';
RFBSX37={'mo' 'RFBSX37' LRFBUB []}';
RFBSX38={'mo' 'RFBSX38' LRFBUB []}';
RFBSX39={'mo' 'RFBSX39' LRFBUB []}';
RFBSX40={'mo' 'RFBSX40' LRFBUB []}';
RFBSX41={'mo' 'RFBSX41' LRFBUB []}';
RFBSX42={'mo' 'RFBSX42' LRFBUB []}';
RFBSX43={'mo' 'RFBSX43' LRFBUB []}';
RFBSX44={'mo' 'RFBSX44' LRFBUB []}';
RFBSX45={'mo' 'RFBSX45' LRFBUB []}';
RFBSX46={'mo' 'RFBSX46' LRFBUB []}';
RFBSX47={'mo' 'RFBSX47' LRFBUB []}';
DRFBS48={'dr' '' LRFBUB []}';
DRFBS49={'dr' '' LRFBUB []}';
DRFBS50={'dr' '' LRFBUB []}';
RFBSX51={'mo' 'RFBSX51' LRFBUB []}';
% ------------------------------------------------------------------------------
% DTSXU  = SXU undulator segment small terminations modeled as drift
% ------------------------------------------------------------------------------
DTSXU={'dr' '' LSXUE []}';
% ------------------------------------------------------------------------------
% SXR undulator phase shifters
% ------------------------------------------------------------------------------
PSSX26_FULL=[PSSX26,MPHS,PSSX26];
PSSX27_FULL=[PSSX27,MPHS,PSSX27];
PSSX28_FULL=[PSSX28,MPHS,PSSX28];
PSSX29_FULL=[PSSX29,MPHS,PSSX29];
PSSX30_FULL=[PSSX30,MPHS,PSSX30];
PSSX31_FULL=[PSSX31,MPHS,PSSX31];
PSSX32_FULL=[PSSX32,MPHS,PSSX32];
PSSX33_FULL=[PSSX33,MPHS,PSSX33];
PSSX34_FULL=[PSSX34,MPHS,PSSX34];
DPSSX35={'dr' '' LPSSX []}';
PSSX36_FULL=[PSSX36,MPHS,PSSX36];
PSSX37_FULL=[PSSX37,MPHS,PSSX37];
PSSX38_FULL=[PSSX38,MPHS,PSSX38];
PSSX39_FULL=[PSSX39,MPHS,PSSX39];
PSSX40_FULL=[PSSX40,MPHS,PSSX40];
PSSX41_FULL=[PSSX41,MPHS,PSSX41];
PSSX42_FULL=[PSSX42,MPHS,PSSX42];
PSSX43_FULL=[PSSX43,MPHS,PSSX43];
PSSX44_FULL=[PSSX44,MPHS,PSSX44];
PSSX45_FULL=[PSSX45,MPHS,PSSX45];
PSSX46_FULL=[PSSX46,MPHS,PSSX46];
DPSSX47={'dr' '' LPSSX []}';
DPSSX48={'dr' '' LPSSX []}';
DPSSX49={'dr' '' LPSSX []}';
DPSSX50={'dr' '' LPSSX []}';
% ------------------------------------------------------------------------------
% SXR undulator inline valves, VAT Series 48
% ------------------------------------------------------------------------------
VVSXU26={'mo' 'VVSXU26' 0 []}';
VVSXU32={'mo' 'VVSXU32' 0 []}';
VVSXU38={'mo' 'VVSXU38' 0 []}';
VVSXU44={'mo' 'VVSXU44' 0 []}';
VVSXU47={'mo' 'VVSXU47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator Beam Loss Monitors
% ------------------------------------------------------------------------------
BLMS26={'mo' 'BLMS26' 0 []}';
BLMS27={'mo' 'BLMS27' 0 []}';
BLMS28={'mo' 'BLMS28' 0 []}';
BLMS29={'mo' 'BLMS29' 0 []}';
BLMS30={'mo' 'BLMS30' 0 []}';
BLMS31={'mo' 'BLMS31' 0 []}';
BLMS32={'mo' 'BLMS32' 0 []}';
BLMS33={'mo' 'BLMS33' 0 []}';
BLMS34={'mo' 'BLMS34' 0 []}';
BLMS36={'mo' 'BLMS36' 0 []}';
BLMS37={'mo' 'BLMS37' 0 []}';
BLMS38={'mo' 'BLMS38' 0 []}';
BLMS39={'mo' 'BLMS39' 0 []}';
BLMS40={'mo' 'BLMS40' 0 []}';
BLMS41={'mo' 'BLMS41' 0 []}';
BLMS42={'mo' 'BLMS42' 0 []}';
BLMS43={'mo' 'BLMS43' 0 []}';
BLMS44={'mo' 'BLMS44' 0 []}';
BLMS45={'mo' 'BLMS45' 0 []}';
BLMS46={'mo' 'BLMS46' 0 []}';
BLMS47={'mo' 'BLMS47' 0 []}';
% ------------------------------------------------------------------------------
% SXRSS self-seeding chicane (LCLSII-3.2-PR-0101-R0 doesn't specify chicane
% requirements ... use LCLS PRD SLAC-I-081-101-003-00-R000)
% NOTE: chicane slides across the aisle from LCLS to SXR; now bends toward the
%       (north) wall, away from the aisle
% ------------------------------------------------------------------------------
% NOTEs:
% - in LCLS: BXSS1-4
% - nominal beam energy range is 3.35-4.74 GeV
% - minimum energy is 2.6 GeV; maximum energy is 5.2 GeV
% - Bmax = 2.56 kG-m @ 9 A (20 mm maximum beam offset)
% - use series approximation for sinc(x)=sin(x)/x to allow AB5=0
% - deflects toward +X (to the left/north/wall)
% - bends toward coil side
% - Dieter Walz designation: 1.575D14-C (pole-width rather than gap height)
% BCXSS1 gets an X-offset of +1.0 mm (toward the wall)
% BCXSS2 gets an X-offset of +9.7 mm (toward the wall)
% BCXSS3 gets an X-offset of +9.7 mm (toward the wall)
% BCXSS4 gets an X-offset of +1.0 mm (toward the wall)
BRHO5 =  CB*EU                             ;%beam rigidity at chicane (kG-m)
GB5 =  0.315*IN2M                        ;%full gap height [m]
ZB5 =  14.315*IN2M                       ;%on-axis effective length is 14" + gap (rule-of-thumb)
FB5 =  0.5                               ;%not measured
AB5 =  -0.014249046471*SETSXRSS          ;%bend angle (rad) for dX=+17.0 mm
BLB5 =  BRHO5*AB5                         ;%integrated strength (-1.901188 kG-m @ 4 GeV)
AB5_2 =  AB5*AB5;
AB5_4 =  AB5_2*AB5_2;
AB5_6 =  AB5_4*AB5_2;
SINCAB5 =  1-AB5_2/6+AB5_4/120-AB5_6/5040    ;%~sinc(AB5)=sin(AB5)/AB5
LB5 =  ZB5/SINCAB5                       ;%chicane bend path length (m)
AB5S =  asin(sin(AB5)/2)                  ;%"short" half chicane bend angle (rad)
AB5S_2 =  AB5S*AB5S;
AB5S_4 =  AB5S_2*AB5S_2;
AB5S_6 =  AB5S_4*AB5S_2;
SINCAB5S =  1-AB5S_2/6+AB5S_4/120-AB5S_6/5040 ;%~sinc(AB5s)=sin(AB5s)/AB5s
LB5S =  ZB5/(2*SINCAB5S)                  ;%"short" half chicane bend path length (m)
AB5L =  AB5-AB5S                          ;%"long" half chicane bend angle (rad)
LB5L =  LB5-LB5S                          ;%"long" half chicane bend path length (m)
BCXSS1A={'be' 'BCXSS1' LB5S [+AB5S GB5/2 0 0 0.5 0 0]}';
BCXSS1B={'be' 'BCXSS1' LB5L [+AB5L GB5/2 0 +AB5 0 0.5 0]}';
BCXSS2A={'be' 'BCXSS2' LB5L [-AB5L GB5/2 -AB5 0 0.5 0 0]}';
BCXSS2B={'be' 'BCXSS2' LB5S [-AB5S GB5/2 0 0 0 0.5 0]}';
BCXSS3A={'be' 'BCXSS3' LB5S [-AB5S GB5/2 0 0 0.5 0 0]}';
BCXSS3B={'be' 'BCXSS3' LB5L [-AB5L GB5/2 0 -AB5 0 0.5 0]}';
BCXSS4A={'be' 'BCXSS4' LB5L [+AB5L GB5/2 +AB5 0 0.5 0 0]}';
BCXSS4B={'be' 'BCXSS4' LB5S [+AB5S GB5/2 0 0 0 0.5 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXSS1={'be' 'BCXSS' LB5 [+AB5 GB5/2 0 +AB5 0.5 0.5 0]}';
BCXSS2={'be' 'BCXSS' LB5 [-AB5 GB5/2 -AB5 0 0.5 0.5 0]}';
BCXSS3={'be' 'BCXSS3' LB5 [-AB5 GB5/2 0 -AB5 0.5 0.5 0]}';
BCXSS4={'be' 'BCXSS4' LB5 [+AB5 GB5/2 +AB5 0 0.5 0.5 0]}';
LSSSB2BO =  1.193 ;%outer bend center-to-center (PRD Table 3)
LSSSB2BI =  0.52  ;%inner bend center-to-center (PRD Table 3)
ZD1S =  LSSSB2BO-ZB5;
ZD1SA =  0.44;
ZD1SB =  0.049;
ZD1SC =  ZD1S-(ZD1SA+ZD1SB);
ZD1SD =  0.077;
ZD1SE =  0.185;
ZD1SF =  0.128;
ZD1SG =  ZD1S-(ZD1SD+ZD1SE+ZD1SF);
DMONOS={'dr' '' (3.4-2*LSSSB2BO-LSSSB2BI-ZB5)/2 []}';
D1SA={'dr' '' ZD1SA/cos(AB5) []}';
D1SB={'dr' '' ZD1SB/cos(AB5) []}';
D1SC={'dr' '' ZD1SC/cos(AB5) []}';
D1SD={'dr' '' ZD1SD/cos(AB5) []}';
D1SE={'dr' '' ZD1SE/cos(AB5) []}';
D1SF={'dr' '' ZD1SF/cos(AB5) []}';
D1SG={'dr' '' ZD1SG/cos(AB5) []}';
DCHS={'dr' '' (LSSSB2BI-ZB5)/2 []}';
SXRSSBEG={'mo' 'SXRSSBEG' 0 []}';
GSXS1={'mo' 'GSXS1' 0 []}';
MSXS1={'mo' 'MSXS1' 0 []}';
CNTRS={'mo' 'CNTRS' 0 []}';
SLSXS1={'mo' 'SLSXS1' 0 []}';
MSXS2={'mo' 'MSXS2' 0 []}';
MSXS3={'mo' 'MSXS3' 0 []}';
SXRSSEND={'mo' 'SXRSSEND' 0 []}';
BCXSS1_FULL=[BCXSS1A,BCXSS1B];
BCXSS2_FULL=[BCXSS2A,BCXSS2B];
BCXSS3_FULL=[BCXSS3A,BCXSS3B];
BCXSS4_FULL=[BCXSS4A,BCXSS4B];
SCHICANE=[SXRSSBEG,DMONOS,BCXSS1_FULL,D1SA,GSXS1,D1SB,MSXS1,D1SC,BCXSS2_FULL,DCHS,CNTRS,DCHS,BCXSS3_FULL,D1SD,SLSXS1,D1SE,MSXS2,D1SF,MSXS3,D1SG,BCXSS4_FULL,DMONOS,SXRSSEND];
% ------------------------------------------------------------------------------
% SXR undulator cells
% ------------------------------------------------------------------------------
UMASX26_FULL=[UMASX26,XCSU26,YCSU26,UMASX26];
UMASX27_FULL=[UMASX27,XCSU27,YCSU27,UMASX27];
UMASX28_FULL=[UMASX28,XCSU28,YCSU28,UMASX28];
UMASX29_FULL=[UMASX29,XCSU29,YCSU29,UMASX29];
UMASX30_FULL=[UMASX30,XCSU30,YCSU30,UMASX30];
UMASX31_FULL=[UMASX31,XCSU31,YCSU31,UMASX31];
UMASX32_FULL=[UMASX32,XCSU32,YCSU32,UMASX32];
UMASX33_FULL=[UMASX33,XCSU33,YCSU33,UMASX33];
UMASX34_FULL=[UMASX34,XCSU34,YCSU34,UMASX34];
UMASX36_FULL=[UMASX36,XCSU36,YCSU36,UMASX36];
UMASX37_FULL=[UMASX37,XCSU37,YCSU37,UMASX37];
UMASX38_FULL=[UMASX38,XCSU38,YCSU38,UMASX38];
UMASX39_FULL=[UMASX39,XCSU39,YCSU39,UMASX39];
UMASX40_FULL=[UMASX40,XCSU40,YCSU40,UMASX40];
UMASX41_FULL=[UMASX41,XCSU41,YCSU41,UMASX41];
UMASX42_FULL=[UMASX42,XCSU42,YCSU42,UMASX42];
UMASX43_FULL=[UMASX43,XCSU43,YCSU43,UMASX43];
UMASX44_FULL=[UMASX44,XCSU44,YCSU44,UMASX44];
UMASX45_FULL=[UMASX45,XCSU45,YCSU45,UMASX45];
UMASX46_FULL=[UMASX46,XCSU46,YCSU46,UMASX46];
UMASX47_FULL=[UMASX47,XCSU47,YCSU47,UMASX47];
USEGSX26=[DTSXU,UMASX26_FULL,DTSXU];
USEGSX27=[DTSXU,UMASX27_FULL,DTSXU];
USEGSX28=[DTSXU,UMASX28_FULL,DTSXU];
USEGSX29=[DTSXU,UMASX29_FULL,DTSXU];
USEGSX30=[DTSXU,UMASX30_FULL,DTSXU];
USEGSX31=[DTSXU,UMASX31_FULL,DTSXU];
USEGSX32=[DTSXU,UMASX32_FULL,DTSXU];
USEGSX33=[DTSXU,UMASX33_FULL,DTSXU];
USEGSX34=[DTSXU,UMASX34_FULL,DTSXU];
DUSEGS35=[SCHICANE];%DRIF, L=LDUSEGS
USEGSX36=[DTSXU,UMASX36_FULL,DTSXU];
USEGSX37=[DTSXU,UMASX37_FULL,DTSXU];
USEGSX38=[DTSXU,UMASX38_FULL,DTSXU];
USEGSX39=[DTSXU,UMASX39_FULL,DTSXU];
USEGSX40=[DTSXU,UMASX40_FULL,DTSXU];
USEGSX41=[DTSXU,UMASX41_FULL,DTSXU];
USEGSX42=[DTSXU,UMASX42_FULL,DTSXU];
USEGSX43=[DTSXU,UMASX43_FULL,DTSXU];
USEGSX44=[DTSXU,UMASX44_FULL,DTSXU];
USEGSX45=[DTSXU,UMASX45_FULL,DTSXU];
USEGSX46=[DTSXU,UMASX46_FULL,DTSXU];
USEGSX47=[DTSXU,UMASX47_FULL,DTSXU];
DUSEGS48={'dr' '' LDUSEGS []}';
DUSEGS49={'dr' '' LDUSEGS []}';
DUSEGS50={'dr' '' LDUSEGS []}';
QSX26_FULL=[QSX26,XCSX26,MUQS,YCSX26,QSX26];
QSX27_FULL=[QSX27,XCSX27,MUQS,YCSX27,QSX27];
QSX28_FULL=[QSX28,XCSX28,MUQS,YCSX28,QSX28];
QSX29_FULL=[QSX29,XCSX29,MUQS,YCSX29,QSX29];
QSX30_FULL=[QSX30,XCSX30,MUQS,YCSX30,QSX30];
QSX31_FULL=[QSX31,XCSX31,MUQS,YCSX31,QSX31];
QSX32_FULL=[QSX32,XCSX32,MUQS,YCSX32,QSX32];
QSX33_FULL=[QSX33,XCSX33,MUQS,YCSX33,QSX33];
QSX34_FULL=[QSX34,XCSX34,MUQS,YCSX34,QSX34];
QSX35_FULL=[QSX35,XCSX35,MUQS,YCSX35,QSX35];
QSX36_FULL=[QSX36,XCSX36,MUQS,YCSX36,QSX36];
QSX37_FULL=[QSX37,XCSX37,MUQS,YCSX37,QSX37];
QSX38_FULL=[QSX38,XCSX38,MUQS,YCSX38,QSX38];
QSX39_FULL=[QSX39,XCSX39,MUQS,YCSX39,QSX39];
QSX40_FULL=[QSX40,XCSX40,MUQS,YCSX40,QSX40];
QSX41_FULL=[QSX41,XCSX41,MUQS,YCSX41,QSX41];
QSX42_FULL=[QSX42,XCSX42,MUQS,YCSX42,QSX42];
QSX43_FULL=[QSX43,XCSX43,MUQS,YCSX43,QSX43];
QSX44_FULL=[QSX44,XCSX44,MUQS,YCSX44,QSX44];
QSX45_FULL=[QSX45,XCSX45,MUQS,YCSX45,QSX45];
QSX46_FULL=[QSX46,XCSX46,MUQS,YCSX46,QSX46];
QSX47_FULL=[QSX47,XCSX47,MUQS,YCSX47,QSX47];
DQSX48={'dr' '' LQU []}';
DQSX49={'dr' '' LQU []}';
DQSX50={'dr' '' LQU []}';
% SXRSS-II BOD's
DU4SA={'dr' '' 0.117258 []}';
BOD10={'mo' 'BOD10' 0 []}';
DU4SB={'dr' '' DU4S{3}-DU4SA{3} []}';
DU7SA={'dr' '' 0.078508 []}';
BOD12={'mo' 'BOD12' 0 []}';
DU7SB={'dr' '' DU7S{3}-DU7SA{3} []}';
SXBRK26=[DU3S,PSSX26_FULL,DU4S,VVSXU26,DU5S,QSX26_FULL,DU6S,RFBSX26,DU7S];
SXBRK27=[DU3S,PSSX27_FULL,DU4S,        DU5S,QSX27_FULL,DU6S,RFBSX27,DU7S];
SXBRK28=[DU3S,PSSX28_FULL,DU4S,        DU5S,QSX28_FULL,DU6S,RFBSX28,DU7S];
SXBRK29=[DU3S,PSSX29_FULL,DU4S,        DU5S,QSX29_FULL,DU6S,RFBSX29,DU7S];
SXBRK30=[DU3S,PSSX30_FULL,DU4S,        DU5S,QSX30_FULL,DU6S,RFBSX30,DU7S];
SXBRK31=[DU3S,PSSX31_FULL,DU4S,        DU5S,QSX31_FULL,DU6S,RFBSX31,DU7S];
SXBRK32=[DU3S,PSSX32_FULL,DU4S,VVSXU32,DU5S,QSX32_FULL,DU6S,RFBSX32,DU7S];
SXBRK33=[DU3S,PSSX33_FULL,DU4S,        DU5S,QSX33_FULL,DU6S,RFBSX33,DU7S];
SXBRK34=[DU3S,PSSX34_FULL,DU4S,        DU5S,QSX34_FULL,DU6S,RFBSX34,DU7S];
SXBRK35=[DU3S,DPSSX35,DU4SA,BOD10,DU4SB,DU5S,QSX35_FULL,DU6S,RFBSX35,DU7S];
SXBRK36=[DU3S,PSSX36_FULL,DU4S,        DU5S,QSX36_FULL,DU6S,RFBSX36,DU7S];
SXBRK37=[DU3S,PSSX37_FULL,DU4S,DU5S,QSX37_FULL,DU6S,RFBSX37,DU7SA,BOD12,DU7SB];
SXBRK38=[DU3S,PSSX38_FULL,DU4S,VVSXU38,DU5S,QSX38_FULL,DU6S,RFBSX38,DU7S];
SXBRK39=[DU3S,PSSX39_FULL,DU4S,        DU5S,QSX39_FULL,DU6S,RFBSX39,DU7S];
SXBRK40=[DU3S,PSSX40_FULL,DU4S,        DU5S,QSX40_FULL,DU6S,RFBSX40,DU7S];
SXBRK41=[DU3S,PSSX41_FULL,DU4S,        DU5S,QSX41_FULL,DU6S,RFBSX41,DU7S];
SXBRK42=[DU3S,PSSX42_FULL,DU4S,        DU5S,QSX42_FULL,DU6S,RFBSX42,DU7S];
SXBRK43=[DU3S,PSSX43_FULL,DU4S,        DU5S,QSX43_FULL,DU6S,RFBSX43,DU7S];
SXBRK44=[DU3S,PSSX44_FULL,DU4S,VVSXU44,DU5S,QSX44_FULL,DU6S,RFBSX44,DU7S];
SXBRK45=[DU3S,PSSX45_FULL,DU4S,        DU5S,QSX45_FULL,DU6S,RFBSX45,DU7S];
SXBRK46=[DU3S,PSSX46_FULL,DU4S,        DU5S,QSX46_FULL,DU6S,RFBSX46,DU7S];
SXBRK47=[DU3S,DPSSX47    ,DU4S,VVSXU47,DU5S,QSX47_FULL,DU6S,RFBSX47,DU7S];
SXBRK48=[DU3S,DPSSX48    ,DU4S,        DU5S,DQSX48    ,DU6S,DRFBS48,DU7S];
SXBRK49=[DU3S,DPSSX49    ,DU4S,        DU5S,DQSX49    ,DU6S,DRFBS49,DU7S];
SXBRK50=[DU3S,DPSSX50    ,DU4S,        DU5S,DQSX50    ,DU6S,DRFBS50,DU7S];
SXCEL26=[DU1S,BLMS26,DU2S,USEGSX26,SXBRK26];
SXCEL27=[DU1S,BLMS27,DU2S,USEGSX27,SXBRK27];
SXCEL28=[DU1S,BLMS28,DU2S,USEGSX28,SXBRK28];
SXCEL29=[DU1S,BLMS29,DU2S,USEGSX29,SXBRK29];
SXCEL30=[DU1S,BLMS30,DU2S,USEGSX30,SXBRK30];
SXCEL31=[DU1S,BLMS31,DU2S,USEGSX31,SXBRK31];
SXCEL32=[DU1S,BLMS32,DU2S,USEGSX32,SXBRK32];
SXCEL33=[DU1S,BLMS33,DU2S,USEGSX33,SXBRK33];
SXCEL34=[DU1S,BLMS34,DU2S,USEGSX34,SXBRK34];
SXCEL35=[DU1S,       DU2S,DUSEGS35,SXBRK35];%empty with Q+RFBPM
SXCEL36=[DU1S,BLMS36,DU2S,USEGSX36,SXBRK36];
SXCEL37=[DU1S,BLMS37,DU2S,USEGSX37,SXBRK37];
SXCEL38=[DU1S,BLMS38,DU2S,USEGSX38,SXBRK38];
SXCEL39=[DU1S,BLMS39,DU2S,USEGSX39,SXBRK39];
SXCEL40=[DU1S,BLMS40,DU2S,USEGSX40,SXBRK40];
SXCEL41=[DU1S,BLMS41,DU2S,USEGSX41,SXBRK41];
SXCEL42=[DU1S,BLMS42,DU2S,USEGSX42,SXBRK42];
SXCEL43=[DU1S,BLMS43,DU2S,USEGSX43,SXBRK43];
SXCEL44=[DU1S,BLMS44,DU2S,USEGSX44,SXBRK44];
SXCEL45=[DU1S,BLMS45,DU2S,USEGSX45,SXBRK45];
SXCEL46=[DU1S,BLMS46,DU2S,USEGSX46,SXBRK46];
SXCEL47=[DU1S,BLMS47,DU2S,USEGSX47,SXBRK47];
SXCEL48=[DU1S,       DU2S,DUSEGS48,SXBRK48];%empty
SXCEL49=[DU1S,       DU2S,DUSEGS49,SXBRK49];%empty
SXCEL50=[DU1S,       DU2S,DUSEGS50,SXBRK50];%empty
SXRCL=[SXCEL26,SXCEL27,SXCEL28,SXCEL29,SXCEL30,SXCEL31,SXCEL32,SXCEL33,SXCEL34,SXCEL35,SXCEL36,SXCEL37,SXCEL38,SXCEL39,SXCEL40,SXCEL41,SXCEL42,SXCEL43,SXCEL44,SXCEL45,SXCEL46,SXCEL47,SXCEL48,SXCEL49,SXCEL50];
SXR=[SXRSTART,SXRCL,RWWAKE5S,SXRTERM,DUE1AB,RFBSX51,DUE1E,ENDUNDS];
% ------------------------------------------------------------------------------
% SXR undulator exit section
% ------------------------------------------------------------------------------
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQUE1B =  -0.066533038872 ;%-0.306247962224
KQUE2B =   0.317255382568 ;% 0.394195575969
QUE1B={'qu' 'QUE1B' LQR/2 [KQUE1B 0]}';
QUE2B={'qu' 'QUE2B' LQR/2 [KQUE2B 0]}';
TCX01B={'tc' 'TCX01B' 1.0/2 [XBANDF 0 0*TWOPI]}';%horiz. deflection
TCX02B={'tc' 'TCX02B' 1.0/2 [XBANDF 0 0*TWOPI]}';%horiz. deflection
LBKXDMP =  1.0 ;%x-kicker length in dumpline
DBKXDMPS={'dr' '' LBKXDMP []}';%placeholder for x-kicker in SXR dumpline
DZSXTES =  0.468389399848E-10 ;%set MDLWALLb at 685 m exactly to align with SXR XTES system
DZHXTES =  0.749541186639E-6  ;%set MDLWALL at 685 m exactly to align with HXR XTES system
DUE1D={'dr' '' 0.1 []}';
DUE1B={'dr' '' 1.5 []}';
DUE1C={'dr' '' 0.5 []}';
DUE1CA={'dr' '' 0.3 []}';
DUE1CB={'dr' '' 0.188-0.012 []}';
DUE1CC={'dr' '' DUE1C{3}-DUE1CA{3}-DUE1CB{3} []}';
DUE2A={'dr' '' 0.5 []}';
DUE2B={'dr' '' 0.8 []}';
DUE2D={'dr' '' 0.188-0.012 []}';
DUE2E={'dr' '' 1.740055-DUE2B{3}-DUE2D{3} []}';
DUE2CB={'dr' '' 0.615+(LQP-LQR)/2 []}';
DUE3AB={'dr' '' 0.375504+(LQP-LQR)/2-0.014955 []}';
DUE3BB={'dr' '' 1.2630495+0.014955 []}';
DUE3C={'dr' '' (1.7968755-LBKXDMP)/2 []}';
DPCVV={'dr' '' 0.397 []}';
DVVTCX={'dr' '' 0.32 []}';
DTCX12={'dr' '' 0.373/2 []}';
DTCXSP={'dr' '' 0.381 []}';
DUE4B={'dr' '' 0.454+(LQP-LQR)/2 []}';
DUE5AB={'dr' '' 0.477799+(LQP-LQR)/2-0.114162 []}';
DUE5BB={'dr' '' 0.264+0.114162-0.1016+0.1016 []}';
DUE5CB={'dr' '' 0.2674+0.1016-0.1016 []}';
DUE5D={'dr' '' 0.137055-0.05 []}';
DUE5F={'dr' '' 0.05 []}';
DUE5E={'dr' '' 0.252825-DUE5D{3}-DUE5F{3}-DZHXTES []}';
DSB0A={'dr' '' 0.260150 []}';
DSB0B={'dr' '' 0.344 []}';
DSB0C={'dr' '' 0.32646 []}';
DSB0D={'dr' '' 0.123366 []}';
DDSB0E =  -0.403705866174E-3;
DSB0E={'dr' '' 0.1059327+DDSB0E []}';
DDLWALL={'dr' '' 0.250825+DZHXTES []}';%length of dumpline thermal barrier wall
DUE5EB={'dr' '' 0.252825-DUE5D{3}-DUE5F{3}+DZSXTES []}';
DDLWALLB={'dr' '' 0.250825-DZSXTES []}';%length of dumpline thermal barrier wall
XCUE2B={'mo' 'XCUE2B' 0 []}';
XCD3B={'mo' 'XCD3B' 0 []}';
YCUE1B={'mo' 'YCUE1B' 0 []}';
YCD3B={'mo' 'YCD3B' 0 []}';
BPMUE1B={'mo' 'BPMUE1B' 0 []}';%RFBUE1B : MONI, TYPE="@2,CavityS-1"
BPMUE2B={'mo' 'BPMUE2B' 0 []}';%RFBUE2B : MONI, TYPE="@2,CavityS-1"
%RFBUE3B : MONI, TYPE="@2,CavityS-1"
TRUE1B={'mo' 'TRUE1B' 0 []}';%Be foil inserter (THz)
SPTCXB={'mo' 'SPTCXB' 0 []}';%XTCAV spoiler
BTMQUEB={'mo' 'BTMQUEB' 0 []}';%Burn-Through-Monitor
BTM0B={'mo' 'BTM0B' 0 []}';%Burn-Through-Monitor behind the PCPM0B
PCTCXB={'dr' 'PCTCXB' 0 []}';%XTCAV photon collimator (9 mm aperture)
PCPM0B={'dr' 'PCPM0B' LPCPM []}';
%IMUNDOB : IMON, TYPE="@0,BCS ACM" BCS ACM
MIMUNDOB={'mo' 'MIMUNDOB' 0 []}';
PH31B={'mo' 'PH31B' 0 []}';%post-undulator phase measurement RF cavity (low rate)
PH32B={'mo' 'PH32B' 0 []}';%post-undulator phase measurement RF cavity (low rate)
PH33B={'mo' 'PH33B' 0 []}';%post-undulator phase measurement RF cavity (high rate)
PH34B={'mo' 'PH34B' 0 []}';%post-undulator phase measurement RF cavity (high rate)
UEBEGB={'mo' 'UEBEGB' 0 []}';
VVTCXB={'mo' 'VVTCXB' 0 []}';%XTCAV vacuum valve
MTCX01B={'mo' 'MTCX01B' 0 []}';%entrance to TCX01B (for ELEGANT WATCH point)
MTCXB={'mo' 'MTCXB' 0 []}';%centerline between TCX01B and TCX02B (for matching)
UEENDB={'mo' 'UEENDB' 0 []}';
VV36B={'mo' 'VV36B' 0 []}';%treaty-point vacuum valve just downbeam of undulator
VV37B={'mo' 'VV37B' 0 []}';%vac. valve in dumpline
DLSTARTB={'mo' 'DLSTARTB' 0 []}';
MDLWALLB={'mo' 'MDLWALLB' 0 []}';%front face of dumpline thermal barrier wall
QUE1B_FULL=[QUE1B,QUE1B];
QUE2B_FULL=[QUE2B,QUE2B];
UNDEXITB=[BEGDMPS_1,UEBEGB,DUE1D,VV36B,DUE1B,MIMUNDOB,DUE1CA,PH33B,DUE1CB,PH34B,DUE1CC,DUE2A,YCUE1B,DUE2B,PH31B,DUE2D,PH32B,DUE2E,XCUE2B,DUE2CB,QUE1B_FULL,DUE3AB,BPMUE1B,DUE3BB,TRUE1B,DUE3C,DBKXDMPS,DUE3C,PCTCXB,DPCVV,VVTCXB,DVVTCX,MTCX01B,TCX01B,TCX01B,DTCX12,MTCXB,DTCX12,TCX02B,TCX02B,DTCXSP,SPTCXB,DUE4B,QUE2B_FULL,DUE5AB,BPMUE2B,DUE5BB,BTMQUEB,DUE5CB,PCPM0B,DUE5F,BTM0B,DUE5D,DUE5EB,MDLWALLB,DDLWALLB,UEENDB,DLSTARTB,DSB0A,YCD3B,DSB0B,XCD3B,DSB0C,VV37B,DSB0D,DSB0E,ENDDMPS_1];
SXRUND=[SXRXX,SXR,UNDEXITB];
% ==============================================================================
% HXR HGVPU undulator (south)
% ==============================================================================
% ------------------------------------------------------------------------------
% HXR undulator PPM phase shifter
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited September 06, 2017
% - 10.0 mm miminum Undulator Gap
% ------------------------------------------------------------------------------
% - LPSHX  = HXR Phase Shifter length
% - luPSHX = HXR Phase Shifter period
% - PIPSHX = HXR Phase Shifter phase integral 
% - KPSHX  = HXR Phase Shifter Undulator parameter (rms); range 0.18-1.91
% - kQPSHX = natural HXR Phase Shifter undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LPSHX =  0.0495                             ;%m
LUPSHX =  0.045                              ;%m
LPSHXH =  LPSHX/2;
PIPSHX =  490                                ;%T^2mm^3 (80-490)
KPSHX =  1.E-9*CLIGHT/MC2*sqrt(2.E-9*PIPSHX/LUPSHX);
KQPSHX =  (KPSHX*2*PI/LUPSHX/sqrt(2)/GAMU)^2 ;%m^-2
PSHX={'un' 'PSHX' LPSHXH [KQPSHX LUPSHX 1]}';
PSHX13=PSHX;PSHX13{2}='PSHX13';
PSHX14=PSHX;PSHX14{2}='PSHX14';
PSHX15=PSHX;PSHX15{2}='PSHX15';
PSHX16=PSHX;PSHX16{2}='PSHX16';
PSHX17=PSHX;PSHX17{2}='PSHX17';
PSHX18=PSHX;PSHX18{2}='PSHX18';
PSHX19=PSHX;PSHX19{2}='PSHX19';
PSHX21=PSHX;PSHX21{2}='PSHX21';
PSHX22=PSHX;PSHX22{2}='PSHX22';
PSHX23=PSHX;PSHX23{2}='PSHX23';
PSHX24=PSHX;PSHX24{2}='PSHX24';
PSHX25=PSHX;PSHX25{2}='PSHX25';
PSHX26=PSHX;PSHX26{2}='PSHX26';
PSHX27=PSHX;PSHX27{2}='PSHX27';
PSHX29=PSHX;PSHX29{2}='PSHX29';
PSHX30=PSHX;PSHX30{2}='PSHX30';
PSHX31=PSHX;PSHX31{2}='PSHX31';
PSHX32=PSHX;PSHX32{2}='PSHX32';
PSHX33=PSHX;PSHX33{2}='PSHX33';
PSHX34=PSHX;PSHX34{2}='PSHX34';
PSHX35=PSHX;PSHX35{2}='PSHX35';
PSHX36=PSHX;PSHX36{2}='PSHX36';
PSHX37=PSHX;PSHX37{2}='PSHX37';
PSHX38=PSHX;PSHX38{2}='PSHX38';
PSHX39=PSHX;PSHX39{2}='PSHX39';
PSHX40=PSHX;PSHX40{2}='PSHX40';
PSHX41=PSHX;PSHX41{2}='PSHX41';
PSHX42=PSHX;PSHX42{2}='PSHX42';
PSHX43=PSHX;PSHX43{2}='PSHX43';
PSHX44=PSHX;PSHX44{2}='PSHX44';
PSHX45=PSHX;PSHX45{2}='PSHX45';
% ------------------------------------------------------------------------------
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Edited Mar 03, 2014
% - Updated Dec 02, 2015 for HGVPU (Y. Nosochkov, D. Bruch)
% - 7.2 mm miminum Undulator Gap; only constant break length each
% - include natural horizontal focusing over all but edge terminations
% ------------------------------------------------------------------------------
% - IntgHX  = integrated quadrupole gradient
% - GQFHX   = QF and QD gradients can be made different to compensate for
%             undulator focussing ...
% - GQDHX   = ... but since undulator focussing depends on gamma^2, compensation
%             will only work for one energy
% - kQFHX   = QF undulator quadrupole focusing "k"
% - kQDHX   = QD undulator quadrupole focusing "k"
% - LDUSEGH = HXR Undulator segment length
% - luHXU   = HXR Undulator period
% - NpHXU   = HXR Undulator period count
% - LHXUCR  = HXR Undulator magnetic length
% - LHXUe   = HXR Undulator spacing between magnet array and strongback end
% - KHXU    = HXR Undulator parameter (rms); range 0.54-2.45
% - kQHX    = natural HXR undulator focusing "k" in x-plane
% ------------------------------------------------------------------------------
LDUSEGH =  3.372032;
LDU1H =  0.040984;
LDU2H =  0.0;
LDU3H =  (1.83-LDUSEGH/2-LQU/2)/2;
LDU4H =  0.13-LQU/2-LRFBUB/2;
LDU5H =  0.1275-LPSHXH-LRFBUB/2;
LDU6H =  0.109243-LPSHXH;
LDU7H =  0.08892366667;
LDU8H =  0.025;
DLDU0H =  0.0 ;%fine tune Z of undulator
LDU0H =  0.094391984077-LDU8H-LRFBUB +LRFBUB +DLDU0H;
DU0H={'dr' '' LDU0H []}';
DU1H={'dr' '' LDU1H []}';
DU2H={'dr' '' LDU2H []}';
DU3H={'dr' '' LDU3H []}';
DU4H={'dr' '' LDU4H []}';
DU5H={'dr' '' LDU5H []}';
DU6H={'dr' '' LDU6H []}';
DU7H={'dr' '' LDU7H []}';
DU8H={'dr' '' LDU8H []}';
DDUE1A =  0.0;
DUE1A={'dr' '' 2.853174666558-LRFBUB+DDUE1A []}';
%IntgHX :   definition moved to LCLS2sc_main.xsif and LCLS2cu_main.xsif
GQFHX =   INTGHX/LQU/10*1.0           ;%T/m
GQDHX =  -INTGHX/LQU/10*1.0           ;%T/m
KQFHX =   1.E-9*GQFHX*CLIGHT/GAMU/MC2 ;%m^-2
KQDHX =   1.E-9*GQDHX*CLIGHT/GAMU/MC2 ;%m^-2
KQDHXM =  -2.482122917065 ;%-0.51857909178
QHX13={'qu' 'QHX13' LQU/2 [KQFHX 0]}';
QHX14={'qu' 'QHX14' LQU/2 [KQDHX 0]}';
QHX15={'qu' 'QHX15' LQU/2 [KQFHX 0]}';
QHX16={'qu' 'QHX16' LQU/2 [KQDHX 0]}';
QHX17={'qu' 'QHX17' LQU/2 [KQFHX 0]}';
QHX18={'qu' 'QHX18' LQU/2 [KQDHX 0]}';
QHX19={'qu' 'QHX19' LQU/2 [KQFHX 0]}';
QHX20={'qu' 'QHX20' LQU/2 [KQDHX 0]}';
QHX21={'qu' 'QHX21' LQU/2 [KQFHX 0]}';
QHX22={'qu' 'QHX22' LQU/2 [KQDHX 0]}';
QHX23={'qu' 'QHX23' LQU/2 [KQFHX 0]}';
QHX24={'qu' 'QHX24' LQU/2 [KQDHX 0]}';
QHX25={'qu' 'QHX25' LQU/2 [KQFHX 0]}';
QHX26={'qu' 'QHX26' LQU/2 [KQDHX 0]}';
QHX27={'qu' 'QHX27' LQU/2 [KQFHX 0]}';
QHX28={'qu' 'QHX28' LQU/2 [KQDHX 0]}';
QHX29={'qu' 'QHX29' LQU/2 [KQFHX 0]}';
QHX30={'qu' 'QHX30' LQU/2 [KQDHX 0]}';
QHX31={'qu' 'QHX31' LQU/2 [KQFHX 0]}';
QHX32={'qu' 'QHX32' LQU/2 [KQDHX 0]}';
QHX33={'qu' 'QHX33' LQU/2 [KQFHX 0]}';
QHX34={'qu' 'QHX34' LQU/2 [KQDHX 0]}';
QHX35={'qu' 'QHX35' LQU/2 [KQFHX 0]}';
QHX36={'qu' 'QHX36' LQU/2 [KQDHX 0]}';
QHX37={'qu' 'QHX37' LQU/2 [KQFHX 0]}';
QHX38={'qu' 'QHX38' LQU/2 [KQDHX 0]}';
QHX39={'qu' 'QHX39' LQU/2 [KQFHX 0]}';
QHX40={'qu' 'QHX40' LQU/2 [KQDHX 0]}';
QHX41={'qu' 'QHX41' LQU/2 [KQFHX 0]}';
QHX42={'qu' 'QHX42' LQU/2 [KQDHX 0]}';
QHX43={'qu' 'QHX43' LQU/2 [KQFHX 0]}';
QHX44={'qu' 'QHX44' LQU/2 [KQDHX 0]}';
QHX45={'qu' 'QHX45' LQU/2 [KQFHX 0]}';
QHX46={'qu' 'QHX46' LQU/2 [KQDHXM 0]}';
LUHXU =  0.026                            ;%m
NPHXU =  129;
LHXUCR =  LUHXU*NPHXU                      ;%m
LHXUE =  (LDUSEGH-LHXUCR)/2               ;%m
LHXUH =  LHXUCR/2;
KHXU =  2.0;
KQHX =  (KHXU*2*PI/LUHXU/sqrt(2)/GAMU)^2 ;%m^-2
UMAHX={'un' 'UMAHX' LHXUH [KQHX LUHXU 0]}';
UMAHX13=UMAHX;UMAHX13{2}='UMAHX13';
UMAHX14=UMAHX;UMAHX14{2}='UMAHX14';
UMAHX15=UMAHX;UMAHX15{2}='UMAHX15';
UMAHX16=UMAHX;UMAHX16{2}='UMAHX16';
UMAHX17=UMAHX;UMAHX17{2}='UMAHX17';
UMAHX18=UMAHX;UMAHX18{2}='UMAHX18';
UMAHX19=UMAHX;UMAHX19{2}='UMAHX19';
UMAHX21=UMAHX;UMAHX21{2}='UMAHX21';
UMAHX22=UMAHX;UMAHX22{2}='UMAHX22';
UMAHX23=UMAHX;UMAHX23{2}='UMAHX23';
UMAHX24=UMAHX;UMAHX24{2}='UMAHX24';
UMAHX25=UMAHX;UMAHX25{2}='UMAHX25';
UMAHX26=UMAHX;UMAHX26{2}='UMAHX26';
UMAHX27=UMAHX;UMAHX27{2}='UMAHX27';
UMAHX29=UMAHX;UMAHX29{2}='UMAHX29';
UMAHX30=UMAHX;UMAHX30{2}='UMAHX30';
UMAHX31=UMAHX;UMAHX31{2}='UMAHX31';
UMAHX32=UMAHX;UMAHX32{2}='UMAHX32';
UMAHX33=UMAHX;UMAHX33{2}='UMAHX33';
UMAHX34=UMAHX;UMAHX34{2}='UMAHX34';
UMAHX35=UMAHX;UMAHX35{2}='UMAHX35';
UMAHX36=UMAHX;UMAHX36{2}='UMAHX36';
UMAHX37=UMAHX;UMAHX37{2}='UMAHX37';
UMAHX38=UMAHX;UMAHX38{2}='UMAHX38';
UMAHX39=UMAHX;UMAHX39{2}='UMAHX39';
UMAHX40=UMAHX;UMAHX40{2}='UMAHX40';
UMAHX41=UMAHX;UMAHX41{2}='UMAHX41';
UMAHX42=UMAHX;UMAHX42{2}='UMAHX42';
UMAHX43=UMAHX;UMAHX43{2}='UMAHX43';
UMAHX44=UMAHX;UMAHX44{2}='UMAHX44';
UMAHX45=UMAHX;UMAHX45{2}='UMAHX45';
UMAHX46=UMAHX;UMAHX46{2}='UMAHX46';
% ------------------------------------------------------------------------------
% HXR undulator X-steering coils in quads
% ------------------------------------------------------------------------------
XCHX13={'mo' 'XCHX13' 0 []}';
XCHX14={'mo' 'XCHX14' 0 []}';
XCHX15={'mo' 'XCHX15' 0 []}';
XCHX16={'mo' 'XCHX16' 0 []}';
XCHX17={'mo' 'XCHX17' 0 []}';
XCHX18={'mo' 'XCHX18' 0 []}';
XCHX19={'mo' 'XCHX19' 0 []}';
XCHX20={'mo' 'XCHX20' 0 []}';
XCHX21={'mo' 'XCHX21' 0 []}';
XCHX22={'mo' 'XCHX22' 0 []}';
XCHX23={'mo' 'XCHX23' 0 []}';
XCHX24={'mo' 'XCHX24' 0 []}';
XCHX25={'mo' 'XCHX25' 0 []}';
XCHX26={'mo' 'XCHX26' 0 []}';
XCHX27={'mo' 'XCHX27' 0 []}';
XCHX28={'mo' 'XCHX28' 0 []}';
XCHX29={'mo' 'XCHX29' 0 []}';
XCHX30={'mo' 'XCHX30' 0 []}';
XCHX31={'mo' 'XCHX31' 0 []}';
XCHX32={'mo' 'XCHX32' 0 []}';
XCHX33={'mo' 'XCHX33' 0 []}';
XCHX34={'mo' 'XCHX34' 0 []}';
XCHX35={'mo' 'XCHX35' 0 []}';
XCHX36={'mo' 'XCHX36' 0 []}';
XCHX37={'mo' 'XCHX37' 0 []}';
XCHX38={'mo' 'XCHX38' 0 []}';
XCHX39={'mo' 'XCHX39' 0 []}';
XCHX40={'mo' 'XCHX40' 0 []}';
XCHX41={'mo' 'XCHX41' 0 []}';
XCHX42={'mo' 'XCHX42' 0 []}';
XCHX43={'mo' 'XCHX43' 0 []}';
XCHX44={'mo' 'XCHX44' 0 []}';
XCHX45={'mo' 'XCHX45' 0 []}';
XCHX46={'mo' 'XCHX46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator Y-steering coils in quads
% ------------------------------------------------------------------------------
YCHX13={'mo' 'YCHX13' 0 []}';
YCHX14={'mo' 'YCHX14' 0 []}';
YCHX15={'mo' 'YCHX15' 0 []}';
YCHX16={'mo' 'YCHX16' 0 []}';
YCHX17={'mo' 'YCHX17' 0 []}';
YCHX18={'mo' 'YCHX18' 0 []}';
YCHX19={'mo' 'YCHX19' 0 []}';
YCHX20={'mo' 'YCHX20' 0 []}';
YCHX21={'mo' 'YCHX21' 0 []}';
YCHX22={'mo' 'YCHX22' 0 []}';
YCHX23={'mo' 'YCHX23' 0 []}';
YCHX24={'mo' 'YCHX24' 0 []}';
YCHX25={'mo' 'YCHX25' 0 []}';
YCHX26={'mo' 'YCHX26' 0 []}';
YCHX27={'mo' 'YCHX27' 0 []}';
YCHX28={'mo' 'YCHX28' 0 []}';
YCHX29={'mo' 'YCHX29' 0 []}';
YCHX30={'mo' 'YCHX30' 0 []}';
YCHX31={'mo' 'YCHX31' 0 []}';
YCHX32={'mo' 'YCHX32' 0 []}';
YCHX33={'mo' 'YCHX33' 0 []}';
YCHX34={'mo' 'YCHX34' 0 []}';
YCHX35={'mo' 'YCHX35' 0 []}';
YCHX36={'mo' 'YCHX36' 0 []}';
YCHX37={'mo' 'YCHX37' 0 []}';
YCHX38={'mo' 'YCHX38' 0 []}';
YCHX39={'mo' 'YCHX39' 0 []}';
YCHX40={'mo' 'YCHX40' 0 []}';
YCHX41={'mo' 'YCHX41' 0 []}';
YCHX42={'mo' 'YCHX42' 0 []}';
YCHX43={'mo' 'YCHX43' 0 []}';
YCHX44={'mo' 'YCHX44' 0 []}';
YCHX45={'mo' 'YCHX45' 0 []}';
YCHX46={'mo' 'YCHX46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator X-steering coils in undulator segments
% ------------------------------------------------------------------------------
XCHU13={'mo' 'XCHU13' 0 []}';
XCHU14={'mo' 'XCHU14' 0 []}';
XCHU15={'mo' 'XCHU15' 0 []}';
XCHU16={'mo' 'XCHU16' 0 []}';
XCHU17={'mo' 'XCHU17' 0 []}';
XCHU18={'mo' 'XCHU18' 0 []}';
XCHU19={'mo' 'XCHU19' 0 []}';
XCHU21={'mo' 'XCHU21' 0 []}';
XCHU22={'mo' 'XCHU22' 0 []}';
XCHU23={'mo' 'XCHU23' 0 []}';
XCHU24={'mo' 'XCHU24' 0 []}';
XCHU25={'mo' 'XCHU25' 0 []}';
XCHU26={'mo' 'XCHU26' 0 []}';
XCHU27={'mo' 'XCHU27' 0 []}';
XCHU29={'mo' 'XCHU29' 0 []}';
XCHU30={'mo' 'XCHU30' 0 []}';
XCHU31={'mo' 'XCHU31' 0 []}';
XCHU32={'mo' 'XCHU32' 0 []}';
XCHU33={'mo' 'XCHU33' 0 []}';
XCHU34={'mo' 'XCHU34' 0 []}';
XCHU35={'mo' 'XCHU35' 0 []}';
XCHU36={'mo' 'XCHU36' 0 []}';
XCHU37={'mo' 'XCHU37' 0 []}';
XCHU38={'mo' 'XCHU38' 0 []}';
XCHU39={'mo' 'XCHU39' 0 []}';
XCHU40={'mo' 'XCHU40' 0 []}';
XCHU41={'mo' 'XCHU41' 0 []}';
XCHU42={'mo' 'XCHU42' 0 []}';
XCHU43={'mo' 'XCHU43' 0 []}';
XCHU44={'mo' 'XCHU44' 0 []}';
XCHU45={'mo' 'XCHU45' 0 []}';
XCHU46={'mo' 'XCHU46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator Y-steering coils in undulator segments
% ------------------------------------------------------------------------------
YCHU13={'mo' 'YCHU13' 0 []}';
YCHU14={'mo' 'YCHU14' 0 []}';
YCHU15={'mo' 'YCHU15' 0 []}';
YCHU16={'mo' 'YCHU16' 0 []}';
YCHU17={'mo' 'YCHU17' 0 []}';
YCHU18={'mo' 'YCHU18' 0 []}';
YCHU19={'mo' 'YCHU19' 0 []}';
YCHU21={'mo' 'YCHU21' 0 []}';
YCHU22={'mo' 'YCHU22' 0 []}';
YCHU23={'mo' 'YCHU23' 0 []}';
YCHU24={'mo' 'YCHU24' 0 []}';
YCHU25={'mo' 'YCHU25' 0 []}';
YCHU26={'mo' 'YCHU26' 0 []}';
YCHU27={'mo' 'YCHU27' 0 []}';
YCHU29={'mo' 'YCHU29' 0 []}';
YCHU30={'mo' 'YCHU30' 0 []}';
YCHU31={'mo' 'YCHU31' 0 []}';
YCHU32={'mo' 'YCHU32' 0 []}';
YCHU33={'mo' 'YCHU33' 0 []}';
YCHU34={'mo' 'YCHU34' 0 []}';
YCHU35={'mo' 'YCHU35' 0 []}';
YCHU36={'mo' 'YCHU36' 0 []}';
YCHU37={'mo' 'YCHU37' 0 []}';
YCHU38={'mo' 'YCHU38' 0 []}';
YCHU39={'mo' 'YCHU39' 0 []}';
YCHU40={'mo' 'YCHU40' 0 []}';
YCHU41={'mo' 'YCHU41' 0 []}';
YCHU42={'mo' 'YCHU42' 0 []}';
YCHU43={'mo' 'YCHU43' 0 []}';
YCHU44={'mo' 'YCHU44' 0 []}';
YCHU45={'mo' 'YCHU45' 0 []}';
YCHU46={'mo' 'YCHU46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator BPMs
% ------------------------------------------------------------------------------
RFBHX13={'mo' 'RFBHX13' LRFBUB []}';
RFBHX14={'mo' 'RFBHX14' LRFBUB []}';
RFBHX15={'mo' 'RFBHX15' LRFBUB []}';
RFBHX16={'mo' 'RFBHX16' LRFBUB []}';
RFBHX17={'mo' 'RFBHX17' LRFBUB []}';
RFBHX18={'mo' 'RFBHX18' LRFBUB []}';
RFBHX19={'mo' 'RFBHX19' LRFBUB []}';
RFBHX20={'mo' 'RFBHX20' LRFBUB []}';
RFBHX21={'mo' 'RFBHX21' LRFBUB []}';
RFBHX22={'mo' 'RFBHX22' LRFBUB []}';
RFBHX23={'mo' 'RFBHX23' LRFBUB []}';
RFBHX24={'mo' 'RFBHX24' LRFBUB []}';
RFBHX25={'mo' 'RFBHX25' LRFBUB []}';
RFBHX26={'mo' 'RFBHX26' LRFBUB []}';
RFBHX27={'mo' 'RFBHX27' LRFBUB []}';
RFBHX28={'mo' 'RFBHX28' LRFBUB []}';
RFBHX29={'mo' 'RFBHX29' LRFBUB []}';
RFBHX30={'mo' 'RFBHX30' LRFBUB []}';
RFBHX31={'mo' 'RFBHX31' LRFBUB []}';
RFBHX32={'mo' 'RFBHX32' LRFBUB []}';
RFBHX33={'mo' 'RFBHX33' LRFBUB []}';
RFBHX34={'mo' 'RFBHX34' LRFBUB []}';
RFBHX35={'mo' 'RFBHX35' LRFBUB []}';
RFBHX36={'mo' 'RFBHX36' LRFBUB []}';
RFBHX37={'mo' 'RFBHX37' LRFBUB []}';
RFBHX38={'mo' 'RFBHX38' LRFBUB []}';
RFBHX39={'mo' 'RFBHX39' LRFBUB []}';
RFBHX40={'mo' 'RFBHX40' LRFBUB []}';
RFBHX41={'mo' 'RFBHX41' LRFBUB []}';
RFBHX42={'mo' 'RFBHX42' LRFBUB []}';
RFBHX43={'mo' 'RFBHX43' LRFBUB []}';
RFBHX44={'mo' 'RFBHX44' LRFBUB []}';
RFBHX45={'mo' 'RFBHX45' LRFBUB []}';
RFBHX46={'mo' 'RFBHX46' LRFBUB []}';
DRFBH47={'dr' '' LRFBUB []}';
DRFBH48={'dr' '' LRFBUB []}';
DRFBH49={'dr' '' LRFBUB []}';
DRFBH50={'dr' '' LRFBUB []}';
RFBHX51={'mo' 'RFBHX51' LRFBUB []}';
% ------------------------------------------------------------------------------
% DTHXU = HXU undulator segment small terminations modeled as drift
% ------------------------------------------------------------------------------
DTHXU={'dr' '' LHXUE []}';
% ------------------------------------------------------------------------------
% markers
% ------------------------------------------------------------------------------
HXRSTART={'mo' 'HXRSTART' 0 []}';%start of undulator system
RWWAKE5H={'mo' 'RWWAKE5H' 0 []}';%HXR beampipe wake applied here
HXRTERM={'mo' 'HXRTERM' 0 []}';%end of undulator system
MUQH={'mo' 'MUQH' 0 []}';
MPHH={'mo' 'MPHH' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator phase shifters
% ------------------------------------------------------------------------------
PSHX13_FULL=[PSHX13,MPHH,PSHX13];
PSHX14_FULL=[PSHX14,MPHH,PSHX14];
PSHX15_FULL=[PSHX15,MPHH,PSHX15];
PSHX16_FULL=[PSHX16,MPHH,PSHX16];
PSHX17_FULL=[PSHX17,MPHH,PSHX17];
PSHX18_FULL=[PSHX18,MPHH,PSHX18];
PSHX19_FULL=[PSHX19,MPHH,PSHX19];
DPSHX20={'dr' '' LPSHX []}';
PSHX21_FULL=[PSHX21,MPHH,PSHX21];
PSHX22_FULL=[PSHX22,MPHH,PSHX22];
PSHX23_FULL=[PSHX23,MPHH,PSHX23];
PSHX24_FULL=[PSHX24,MPHH,PSHX24];
PSHX25_FULL=[PSHX25,MPHH,PSHX25];
PSHX26_FULL=[PSHX26,MPHH,PSHX26];
PSHX27_FULL=[PSHX27,MPHH,PSHX27];
DPSHX28={'dr' '' LPSHX []}';
PSHX29_FULL=[PSHX29,MPHH,PSHX29];
PSHX30_FULL=[PSHX30,MPHH,PSHX30];
PSHX31_FULL=[PSHX31,MPHH,PSHX31];
PSHX32_FULL=[PSHX32,MPHH,PSHX32];
PSHX33_FULL=[PSHX33,MPHH,PSHX33];
PSHX34_FULL=[PSHX34,MPHH,PSHX34];
PSHX35_FULL=[PSHX35,MPHH,PSHX35];
PSHX36_FULL=[PSHX36,MPHH,PSHX36];
PSHX37_FULL=[PSHX37,MPHH,PSHX37];
PSHX38_FULL=[PSHX38,MPHH,PSHX38];
PSHX39_FULL=[PSHX39,MPHH,PSHX39];
PSHX40_FULL=[PSHX40,MPHH,PSHX40];
PSHX41_FULL=[PSHX41,MPHH,PSHX41];
PSHX42_FULL=[PSHX42,MPHH,PSHX42];
PSHX43_FULL=[PSHX43,MPHH,PSHX43];
PSHX44_FULL=[PSHX44,MPHH,PSHX44];
PSHX45_FULL=[PSHX45,MPHH,PSHX45];
DPSHX46={'dr' '' LPSHX []}';
DPSHX47={'dr' '' LPSHX []}';
DPSHX48={'dr' '' LPSHX []}';
DPSHX49={'dr' '' LPSHX []}';
DPSHX50={'dr' '' LPSHX []}';
% ------------------------------------------------------------------------------
% HXR undulator inline valves (VAT Series 48?)
% ------------------------------------------------------------------------------
VVHXU13={'mo' 'VVHXU13' 0 []}';
VVHXU14={'mo' 'VVHXU14' 0 []}';
VVHXU15={'mo' 'VVHXU15' 0 []}';
VVHXU16={'mo' 'VVHXU16' 0 []}';
VVHXU17={'mo' 'VVHXU17' 0 []}';
VVHXU18={'mo' 'VVHXU18' 0 []}';
VVHXU19={'mo' 'VVHXU19' 0 []}';
VVHXU21={'mo' 'VVHXU21' 0 []}';
VVHXU22={'mo' 'VVHXU22' 0 []}';
VVHXU23={'mo' 'VVHXU23' 0 []}';
VVHXU24={'mo' 'VVHXU24' 0 []}';
VVHXU25={'mo' 'VVHXU25' 0 []}';
VVHXU26={'mo' 'VVHXU26' 0 []}';
VVHXU27={'mo' 'VVHXU27' 0 []}';
VVHXU29={'mo' 'VVHXU29' 0 []}';
VVHXU30={'mo' 'VVHXU30' 0 []}';
VVHXU31={'mo' 'VVHXU31' 0 []}';
VVHXU32={'mo' 'VVHXU32' 0 []}';
VVHXU33={'mo' 'VVHXU33' 0 []}';
VVHXU34={'mo' 'VVHXU34' 0 []}';
VVHXU35={'mo' 'VVHXU35' 0 []}';
VVHXU36={'mo' 'VVHXU36' 0 []}';
VVHXU37={'mo' 'VVHXU37' 0 []}';
VVHXU38={'mo' 'VVHXU38' 0 []}';
VVHXU39={'mo' 'VVHXU39' 0 []}';
VVHXU40={'mo' 'VVHXU40' 0 []}';
VVHXU41={'mo' 'VVHXU41' 0 []}';
VVHXU42={'mo' 'VVHXU42' 0 []}';
VVHXU43={'mo' 'VVHXU43' 0 []}';
VVHXU44={'mo' 'VVHXU44' 0 []}';
VVHXU45={'mo' 'VVHXU45' 0 []}';
VVHXU46={'mo' 'VVHXU46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator Beam Loss Monitors
% ------------------------------------------------------------------------------
BLMH13={'mo' 'BLMH13' 0 []}';
BLMH14={'mo' 'BLMH14' 0 []}';
BLMH15={'mo' 'BLMH15' 0 []}';
BLMH16={'mo' 'BLMH16' 0 []}';
BLMH17={'mo' 'BLMH17' 0 []}';
BLMH18={'mo' 'BLMH18' 0 []}';
BLMH19={'mo' 'BLMH19' 0 []}';
BLMH21={'mo' 'BLMH21' 0 []}';
BLMH22={'mo' 'BLMH22' 0 []}';
BLMH23={'mo' 'BLMH23' 0 []}';
BLMH24={'mo' 'BLMH24' 0 []}';
BLMH25={'mo' 'BLMH25' 0 []}';
BLMH26={'mo' 'BLMH26' 0 []}';
BLMH27={'mo' 'BLMH27' 0 []}';
BLMH29={'mo' 'BLMH29' 0 []}';
BLMH30={'mo' 'BLMH30' 0 []}';
BLMH31={'mo' 'BLMH31' 0 []}';
BLMH32={'mo' 'BLMH32' 0 []}';
BLMH33={'mo' 'BLMH33' 0 []}';
BLMH34={'mo' 'BLMH34' 0 []}';
BLMH35={'mo' 'BLMH35' 0 []}';
BLMH36={'mo' 'BLMH36' 0 []}';
BLMH37={'mo' 'BLMH37' 0 []}';
BLMH38={'mo' 'BLMH38' 0 []}';
BLMH39={'mo' 'BLMH39' 0 []}';
BLMH40={'mo' 'BLMH40' 0 []}';
BLMH41={'mo' 'BLMH41' 0 []}';
BLMH42={'mo' 'BLMH42' 0 []}';
BLMH43={'mo' 'BLMH43' 0 []}';
BLMH44={'mo' 'BLMH44' 0 []}';
BLMH45={'mo' 'BLMH45' 0 []}';
BLMH46={'mo' 'BLMH46' 0 []}';
% ------------------------------------------------------------------------------
% HXRSS self-seeding chicane (LCLSII-3.2-PR-0102-R1)
% ------------------------------------------------------------------------------
% NOTEs:
% - in LCLS: BXHS1-4
% - Bmax = 1.9 kG-m @ 6 A (~24 mm beam offset)
% - use series approximation for sinc(x)=sin(x)/x to allow BLB4=0
% - deflects toward -X (to the right/south/wall)
% - bends away from coil side
% BCXHS1 gets an X-offset of  0    mm (toward the wall)
% BCXHS2 gets an X-offset of -2.39 mm (toward the wall)
% BCXHS3 gets an X-offset of -2.39 mm (toward the wall)
% BCXHS4 gets an X-offset of  0    mm (toward the wall)
BRHO4 =  CB*EU                             ;%beam rigidity at chicane (kG-m)
GB4 =  0.315*IN2M                        ;%full gap height [m]
ZB4 =  14.315*IN2M                       ;%on-axis effective length is 14" + gap (rule-of-thumb)
FB4 =  0.5                               ;%not measured
AB4 =  +3.02786616797E-3*SETHXRSS        ;%bend angle (rad) for R56=+15.0 um
BLB4 =  BRHO4*AB4                         ;%integrated strength (1.377623 kG-m @ 13.64 GeV)
AB4_2 =  AB4*AB4;
AB4_4 =  AB4_2*AB4_2;
AB4_6 =  AB4_4*AB4_2;
SINCAB4 =  1-AB4_2/6+AB4_4/120-AB4_6/5040    ;%~sinc(AB4)=sin(AB4)/AB4
LB4 =  ZB4/SINCAB4                       ;%chicane bend path length (m)
AB4S =  asin(sin(AB4)/2)                  ;%"short" half chicane bend angle (rad)
AB4S_2 =  AB4S*AB4S;
AB4S_4 =  AB4S_2*AB4S_2;
AB4S_6 =  AB4S_4*AB4S_2;
SINCAB4S =  1-AB4S_2/6+AB4S_4/120-AB4S_6/5040 ;%~sinc(AB4s)=sin(AB4s)/AB4s
LB4S =  (ZB4/2)/SINCAB4S                  ;%"short" half chicane bend path length (m)
AB4L =  AB4-AB4S                          ;%"long" half chicane bend angle (rad)
LB4L =  LB4-LB4S                          ;%"long" half chicane bend path length (m)
BCXHS1A={'be' 'BCXHS1' LB4S [+AB4S GB4/2 0 0 FB4 0 0]}';
BCXHS1B={'be' 'BCXHS1' LB4L [+AB4L GB4/2 0 +AB4 0 FB4 0]}';
BCXHS2A={'be' 'BCXHS2' LB4L [-AB4L GB4/2 -AB4 0 FB4 0 0]}';
BCXHS2B={'be' 'BCXHS2' LB4S [-AB4S GB4/2 0 0 0 FB4 0]}';
BCXHS3A={'be' 'BCXHS3' LB4S [-AB4S GB4/2 0 0 FB4 0 0]}';
BCXHS3B={'be' 'BCXHS3' LB4L [-AB4L GB4/2 0 -AB4 0 FB4 0]}';
BCXHS4A={'be' 'BCXHS4' LB4L [+AB4L GB4/2 +AB4 0 FB4 0 0]}';
BCXHS4B={'be' 'BCXHS4' LB4S [+AB4S GB4/2 0 0 0 FB4 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXHS1={'be' 'BCXHS' LB4 [+AB4 GB4/2 0 +AB4 FB4 FB4 0]}';
BCXHS2={'be' 'BCXHS' LB4 [-AB4 GB4/2 -AB4 0 FB4 FB4 0]}';
BCXHS3={'be' 'BCXHS3' LB4 [-AB4 GB4/2 0 -AB4 FB4 FB4 0]}';
BCXHS4={'be' 'BCXHS4' LB4 [+AB4 GB4/2 +AB4 0 FB4 FB4 0]}';
LHSSB2BO =  0.939 ;%outer bend center-to-center (PRD Table 3)
LHSSB2BI =  0.936 ;%inner bend center-to-center (PRD Table 3)
D1={'dr' '' (LHSSB2BO-ZB4)/cos(AB4) []}';
DCH={'dr' '' (LHSSB2BI-ZB4)/2 []}';
DMONO={'dr' '' (LDUSEGH-2*LHSSB2BO-LHSSB2BI-ZB4)/2 []}';
HXRSSBEG={'mo' 'HXRSSBEG' 0 []}';
DIAMOND={'mo' 'DIAMOND' 0 []}';
HXRSSEND={'mo' 'HXRSSEND' 0 []}';
BCXHS1_FULL=[BCXHS1A,BCXHS1B];
BCXHS2_FULL=[BCXHS2A,BCXHS2B];
BCXHS3_FULL=[BCXHS3A,BCXHS3B];
BCXHS4_FULL=[BCXHS4A,BCXHS4B];
HCHICANE=[HXRSSBEG,DMONO,BCXHS1_FULL,D1,BCXHS2_FULL,DCH,DIAMOND,DCH,BCXHS3_FULL,D1,BCXHS4_FULL,DMONO,HXRSSEND];
% ------------------------------------------------------------------------------
% HXR undulator cells
% ------------------------------------------------------------------------------
UMAHX13_FULL=[UMAHX13,XCHU13,YCHU13,UMAHX13];
UMAHX14_FULL=[UMAHX14,XCHU14,YCHU14,UMAHX14];
UMAHX15_FULL=[UMAHX15,XCHU15,YCHU15,UMAHX15];
UMAHX16_FULL=[UMAHX16,XCHU16,YCHU16,UMAHX16];
UMAHX17_FULL=[UMAHX17,XCHU17,YCHU17,UMAHX17];
UMAHX18_FULL=[UMAHX18,XCHU18,YCHU18,UMAHX18];
UMAHX19_FULL=[UMAHX19,XCHU19,YCHU19,UMAHX19];
UMAHX21_FULL=[UMAHX21,XCHU21,YCHU21,UMAHX21];
UMAHX22_FULL=[UMAHX22,XCHU22,YCHU22,UMAHX22];
UMAHX23_FULL=[UMAHX23,XCHU23,YCHU23,UMAHX23];
UMAHX24_FULL=[UMAHX24,XCHU24,YCHU24,UMAHX24];
UMAHX25_FULL=[UMAHX25,XCHU25,YCHU25,UMAHX25];
UMAHX26_FULL=[UMAHX26,XCHU26,YCHU26,UMAHX26];
UMAHX27_FULL=[UMAHX27,XCHU27,YCHU27,UMAHX27];
UMAHX29_FULL=[UMAHX29,XCHU29,YCHU29,UMAHX29];
UMAHX30_FULL=[UMAHX30,XCHU30,YCHU30,UMAHX30];
UMAHX31_FULL=[UMAHX31,XCHU31,YCHU31,UMAHX31];
UMAHX32_FULL=[UMAHX32,XCHU32,YCHU32,UMAHX32];
UMAHX33_FULL=[UMAHX33,XCHU33,YCHU33,UMAHX33];
UMAHX34_FULL=[UMAHX34,XCHU34,YCHU34,UMAHX34];
UMAHX35_FULL=[UMAHX35,XCHU35,YCHU35,UMAHX35];
UMAHX36_FULL=[UMAHX36,XCHU36,YCHU36,UMAHX36];
UMAHX37_FULL=[UMAHX37,XCHU37,YCHU37,UMAHX37];
UMAHX38_FULL=[UMAHX38,XCHU38,YCHU38,UMAHX38];
UMAHX39_FULL=[UMAHX39,XCHU39,YCHU39,UMAHX39];
UMAHX40_FULL=[UMAHX40,XCHU40,YCHU40,UMAHX40];
UMAHX41_FULL=[UMAHX41,XCHU41,YCHU41,UMAHX41];
UMAHX42_FULL=[UMAHX42,XCHU42,YCHU42,UMAHX42];
UMAHX43_FULL=[UMAHX43,XCHU43,YCHU43,UMAHX43];
UMAHX44_FULL=[UMAHX44,XCHU44,YCHU44,UMAHX44];
UMAHX45_FULL=[UMAHX45,XCHU45,YCHU45,UMAHX45];
UMAHX46_FULL=[UMAHX46,XCHU46,YCHU46,UMAHX46];
USEGHX13=[DTHXU,UMAHX13_FULL,DTHXU];
USEGHX14=[DTHXU,UMAHX14_FULL,DTHXU];
USEGHX15=[DTHXU,UMAHX15_FULL,DTHXU];
USEGHX16=[DTHXU,UMAHX16_FULL,DTHXU];
USEGHX17=[DTHXU,UMAHX17_FULL,DTHXU];
USEGHX18=[DTHXU,UMAHX18_FULL,DTHXU];
USEGHX19=[DTHXU,UMAHX19_FULL,DTHXU];
DUSEGH20={'dr' '' LDUSEGH []}';
USEGHX21=[DTHXU,UMAHX21_FULL,DTHXU];
USEGHX22=[DTHXU,UMAHX22_FULL,DTHXU];
USEGHX23=[DTHXU,UMAHX23_FULL,DTHXU];
USEGHX24=[DTHXU,UMAHX24_FULL,DTHXU];
USEGHX25=[DTHXU,UMAHX25_FULL,DTHXU];
USEGHX26=[DTHXU,UMAHX26_FULL,DTHXU];
USEGHX27=[DTHXU,UMAHX27_FULL,DTHXU];
DUSEGH28=[HCHICANE];%DRIF, L=LDUSEGH
USEGHX29=[DTHXU,UMAHX29_FULL,DTHXU];
USEGHX30=[DTHXU,UMAHX30_FULL,DTHXU];
USEGHX31=[DTHXU,UMAHX31_FULL,DTHXU];
USEGHX32=[DTHXU,UMAHX32_FULL,DTHXU];
USEGHX33=[DTHXU,UMAHX33_FULL,DTHXU];
USEGHX34=[DTHXU,UMAHX34_FULL,DTHXU];
USEGHX35=[DTHXU,UMAHX35_FULL,DTHXU];
USEGHX36=[DTHXU,UMAHX36_FULL,DTHXU];
USEGHX37=[DTHXU,UMAHX37_FULL,DTHXU];
USEGHX38=[DTHXU,UMAHX38_FULL,DTHXU];
USEGHX39=[DTHXU,UMAHX39_FULL,DTHXU];
USEGHX40=[DTHXU,UMAHX40_FULL,DTHXU];
USEGHX41=[DTHXU,UMAHX41_FULL,DTHXU];
USEGHX42=[DTHXU,UMAHX42_FULL,DTHXU];
USEGHX43=[DTHXU,UMAHX43_FULL,DTHXU];
USEGHX44=[DTHXU,UMAHX44_FULL,DTHXU];
USEGHX45=[DTHXU,UMAHX45_FULL,DTHXU];
USEGHX46=[DTHXU,UMAHX46_FULL,DTHXU];
DUSEGH47={'dr' '' LDUSEGH []}';
DUSEGH48={'dr' '' LDUSEGH []}';
DUSEGH49={'dr' '' LDUSEGH []}';
DUSEGH50={'dr' '' LDUSEGH []}';
QHX13_FULL=[QHX13,XCHX13,MUQH,YCHX13,QHX13];
QHX14_FULL=[QHX14,XCHX14,MUQH,YCHX14,QHX14];
QHX15_FULL=[QHX15,XCHX15,MUQH,YCHX15,QHX15];
QHX16_FULL=[QHX16,XCHX16,MUQH,YCHX16,QHX16];
QHX17_FULL=[QHX17,XCHX17,MUQH,YCHX17,QHX17];
QHX18_FULL=[QHX18,XCHX18,MUQH,YCHX18,QHX18];
QHX19_FULL=[QHX19,XCHX19,MUQH,YCHX19,QHX19];
QHX20_FULL=[QHX20,XCHX20,MUQH,YCHX20,QHX20];
QHX21_FULL=[QHX21,XCHX21,MUQH,YCHX21,QHX21];
QHX22_FULL=[QHX22,XCHX22,MUQH,YCHX22,QHX22];
QHX23_FULL=[QHX23,XCHX23,MUQH,YCHX23,QHX23];
QHX24_FULL=[QHX24,XCHX24,MUQH,YCHX24,QHX24];
QHX25_FULL=[QHX25,XCHX25,MUQH,YCHX25,QHX25];
QHX26_FULL=[QHX26,XCHX26,MUQH,YCHX26,QHX26];
QHX27_FULL=[QHX27,XCHX27,MUQH,YCHX27,QHX27];
QHX28_FULL=[QHX28,XCHX28,MUQH,YCHX28,QHX28];
QHX29_FULL=[QHX29,XCHX29,MUQH,YCHX29,QHX29];
QHX30_FULL=[QHX30,XCHX30,MUQH,YCHX30,QHX30];
QHX31_FULL=[QHX31,XCHX31,MUQH,YCHX31,QHX31];
QHX32_FULL=[QHX32,XCHX32,MUQH,YCHX32,QHX32];
QHX33_FULL=[QHX33,XCHX33,MUQH,YCHX33,QHX33];
QHX34_FULL=[QHX34,XCHX34,MUQH,YCHX34,QHX34];
QHX35_FULL=[QHX35,XCHX35,MUQH,YCHX35,QHX35];
QHX36_FULL=[QHX36,XCHX36,MUQH,YCHX36,QHX36];
QHX37_FULL=[QHX37,XCHX37,MUQH,YCHX37,QHX37];
QHX38_FULL=[QHX38,XCHX38,MUQH,YCHX38,QHX38];
QHX39_FULL=[QHX39,XCHX39,MUQH,YCHX39,QHX39];
QHX40_FULL=[QHX40,XCHX40,MUQH,YCHX40,QHX40];
QHX41_FULL=[QHX41,XCHX41,MUQH,YCHX41,QHX41];
QHX42_FULL=[QHX42,XCHX42,MUQH,YCHX42,QHX42];
QHX43_FULL=[QHX43,XCHX43,MUQH,YCHX43,QHX43];
QHX44_FULL=[QHX44,XCHX44,MUQH,YCHX44,QHX44];
QHX45_FULL=[QHX45,XCHX45,MUQH,YCHX45,QHX45];
QHX46_FULL=[QHX46,XCHX46,MUQH,YCHX46,QHX46];
DQHX47={'dr' '' LQU []}';
DQHX48={'dr' '' LQU []}';
DQHX49={'dr' '' LQU []}';
DQHX50={'dr' '' LQU []}';
HXBRK13=[DU3H,BLMH13,DU3H,QHX13_FULL,DU4H,RFBHX13,DU5H,PSHX13_FULL,DU6H,VVHXU13,DU7H];
HXBRK14=[DU3H,BLMH14,DU3H,QHX14_FULL,DU4H,RFBHX14,DU5H,PSHX14_FULL,DU6H,VVHXU14,DU7H];
HXBRK15=[DU3H,BLMH15,DU3H,QHX15_FULL,DU4H,RFBHX15,DU5H,PSHX15_FULL,DU6H,VVHXU15,DU7H];
HXBRK16=[DU3H,BLMH16,DU3H,QHX16_FULL,DU4H,RFBHX16,DU5H,PSHX16_FULL,DU6H,VVHXU16,DU7H];
HXBRK17=[DU3H,BLMH17,DU3H,QHX17_FULL,DU4H,RFBHX17,DU5H,PSHX17_FULL,DU6H,VVHXU17,DU7H];
HXBRK18=[DU3H,BLMH18,DU3H,QHX18_FULL,DU4H,RFBHX18,DU5H,PSHX18_FULL,DU6H,VVHXU18,DU7H];
HXBRK19=[DU3H,BLMH19,DU3H,QHX19_FULL,DU4H,RFBHX19,DU5H,PSHX19_FULL,DU6H,VVHXU19,DU7H];
HXBRK20=[DU3H       ,DU3H,QHX20_FULL,DU4H,RFBHX20,DU5H,DPSHX20    ,DU6H        ,DU7H];
HXBRK21=[DU3H,BLMH21,DU3H,QHX21_FULL,DU4H,RFBHX21,DU5H,PSHX21_FULL,DU6H,VVHXU21,DU7H];
HXBRK22=[DU3H,BLMH22,DU3H,QHX22_FULL,DU4H,RFBHX22,DU5H,PSHX22_FULL,DU6H,VVHXU22,DU7H];
HXBRK23=[DU3H,BLMH23,DU3H,QHX23_FULL,DU4H,RFBHX23,DU5H,PSHX23_FULL,DU6H,VVHXU23,DU7H];
HXBRK24=[DU3H,BLMH24,DU3H,QHX24_FULL,DU4H,RFBHX24,DU5H,PSHX24_FULL,DU6H,VVHXU24,DU7H];
HXBRK25=[DU3H,BLMH25,DU3H,QHX25_FULL,DU4H,RFBHX25,DU5H,PSHX25_FULL,DU6H,VVHXU25,DU7H];
HXBRK26=[DU3H,BLMH26,DU3H,QHX26_FULL,DU4H,RFBHX26,DU5H,PSHX26_FULL,DU6H,VVHXU26,DU7H];
HXBRK27=[DU3H,BLMH27,DU3H,QHX27_FULL,DU4H,RFBHX27,DU5H,PSHX27_FULL,DU6H,VVHXU27,DU7H];
HXBRK28=[DU3H       ,DU3H,QHX28_FULL,DU4H,RFBHX28,DU5H,DPSHX28    ,DU6H        ,DU7H];
HXBRK29=[DU3H,BLMH29,DU3H,QHX29_FULL,DU4H,RFBHX29,DU5H,PSHX29_FULL,DU6H,VVHXU29,DU7H];
HXBRK30=[DU3H,BLMH30,DU3H,QHX30_FULL,DU4H,RFBHX30,DU5H,PSHX30_FULL,DU6H,VVHXU30,DU7H];
HXBRK31=[DU3H,BLMH31,DU3H,QHX31_FULL,DU4H,RFBHX31,DU5H,PSHX31_FULL,DU6H,VVHXU31,DU7H];
HXBRK32=[DU3H,BLMH32,DU3H,QHX32_FULL,DU4H,RFBHX32,DU5H,PSHX32_FULL,DU6H,VVHXU32,DU7H];
HXBRK33=[DU3H,BLMH33,DU3H,QHX33_FULL,DU4H,RFBHX33,DU5H,PSHX33_FULL,DU6H,VVHXU33,DU7H];
HXBRK34=[DU3H,BLMH34,DU3H,QHX34_FULL,DU4H,RFBHX34,DU5H,PSHX34_FULL,DU6H,VVHXU34,DU7H];
HXBRK35=[DU3H,BLMH35,DU3H,QHX35_FULL,DU4H,RFBHX35,DU5H,PSHX35_FULL,DU6H,VVHXU35,DU7H];
HXBRK36=[DU3H,BLMH36,DU3H,QHX36_FULL,DU4H,RFBHX36,DU5H,PSHX36_FULL,DU6H,VVHXU36,DU7H];
HXBRK37=[DU3H,BLMH37,DU3H,QHX37_FULL,DU4H,RFBHX37,DU5H,PSHX37_FULL,DU6H,VVHXU37,DU7H];
HXBRK38=[DU3H,BLMH38,DU3H,QHX38_FULL,DU4H,RFBHX38,DU5H,PSHX38_FULL,DU6H,VVHXU38,DU7H];
HXBRK39=[DU3H,BLMH39,DU3H,QHX39_FULL,DU4H,RFBHX39,DU5H,PSHX39_FULL,DU6H,VVHXU39,DU7H];
HXBRK40=[DU3H,BLMH40,DU3H,QHX40_FULL,DU4H,RFBHX40,DU5H,PSHX40_FULL,DU6H,VVHXU40,DU7H];
HXBRK41=[DU3H,BLMH41,DU3H,QHX41_FULL,DU4H,RFBHX41,DU5H,PSHX41_FULL,DU6H,VVHXU41,DU7H];
HXBRK42=[DU3H,BLMH42,DU3H,QHX42_FULL,DU4H,RFBHX42,DU5H,PSHX42_FULL,DU6H,VVHXU42,DU7H];
HXBRK43=[DU3H,BLMH43,DU3H,QHX43_FULL,DU4H,RFBHX43,DU5H,PSHX43_FULL,DU6H,VVHXU43,DU7H];
HXBRK44=[DU3H,BLMH44,DU3H,QHX44_FULL,DU4H,RFBHX44,DU5H,PSHX44_FULL,DU6H,VVHXU44,DU7H];
HXBRK45=[DU3H,BLMH45,DU3H,QHX45_FULL,DU4H,RFBHX45,DU5H,PSHX45_FULL,DU6H,VVHXU45,DU7H];
HXBRK46=[DU3H,BLMH46,DU3H,QHX46_FULL,DU4H,RFBHX46,DU5H,DPSHX46    ,DU6H,VVHXU46,DU7H];
HXBRK47=[DU3H       ,DU3H,DQHX47    ,DU4H,DRFBH47,DU5H,DPSHX47    ,DU6H        ,DU7H];
HXBRK48=[DU3H       ,DU3H,DQHX48    ,DU4H,DRFBH48,DU5H,DPSHX48    ,DU6H        ,DU7H];
HXBRK49=[DU3H       ,DU3H,DQHX49    ,DU4H,DRFBH49,DU5H,DPSHX49    ,DU6H        ,DU7H];
HXBRK50=[DU3H       ,DU3H,DQHX50    ,DU4H,DRFBH50,DU5H,DPSHX50    ,DU6H        ,DU7H];
HXCEL13=[DU1H,DU2H,USEGHX13,HXBRK13];
HXCEL14=[DU1H,DU2H,USEGHX14,HXBRK14];
HXCEL15=[DU1H,DU2H,USEGHX15,HXBRK15];
HXCEL16=[DU1H,DU2H,USEGHX16,HXBRK16];
HXCEL17=[DU1H,DU2H,USEGHX17,HXBRK17];
HXCEL18=[DU1H,DU2H,USEGHX18,HXBRK18];
HXCEL19=[DU1H,DU2H,USEGHX19,HXBRK19];
HXCEL20=[DU1H,DU2H,DUSEGH20,HXBRK20];%empty with Q+RFBPM
HXCEL21=[DU1H,DU2H,USEGHX21,HXBRK21];
HXCEL22=[DU1H,DU2H,USEGHX22,HXBRK22];
HXCEL23=[DU1H,DU2H,USEGHX23,HXBRK23];
HXCEL24=[DU1H,DU2H,USEGHX24,HXBRK24];
HXCEL25=[DU1H,DU2H,USEGHX25,HXBRK25];
HXCEL26=[DU1H,DU2H,USEGHX26,HXBRK26];
HXCEL27=[DU1H,DU2H,USEGHX27,HXBRK27];
HXCEL28=[DU1H,DU2H,DUSEGH28,HXBRK28];%empty with Q+RFBPM
HXCEL29=[DU1H,DU2H,USEGHX29,HXBRK29];
HXCEL30=[DU1H,DU2H,USEGHX30,HXBRK30];
HXCEL31=[DU1H,DU2H,USEGHX31,HXBRK31];
HXCEL32=[DU1H,DU2H,USEGHX32,HXBRK32];
HXCEL33=[DU1H,DU2H,USEGHX33,HXBRK33];
HXCEL34=[DU1H,DU2H,USEGHX34,HXBRK34];
HXCEL35=[DU1H,DU2H,USEGHX35,HXBRK35];
HXCEL36=[DU1H,DU2H,USEGHX36,HXBRK36];
HXCEL37=[DU1H,DU2H,USEGHX37,HXBRK37];
HXCEL38=[DU1H,DU2H,USEGHX38,HXBRK38];
HXCEL39=[DU1H,DU2H,USEGHX39,HXBRK39];
HXCEL40=[DU1H,DU2H,USEGHX40,HXBRK40];
HXCEL41=[DU1H,DU2H,USEGHX41,HXBRK41];
HXCEL42=[DU1H,DU2H,USEGHX42,HXBRK42];
HXCEL43=[DU1H,DU2H,USEGHX43,HXBRK43];
HXCEL44=[DU1H,DU2H,USEGHX44,HXBRK44];
HXCEL45=[DU1H,DU2H,USEGHX45,HXBRK45];
HXCEL46=[DU1H,DU2H,USEGHX46,HXBRK46];%no phase shifter
HXCEL47=[DU1H,DU2H,DUSEGH47,HXBRK47];%empty
HXCEL48=[DU1H,DU2H,DUSEGH48,HXBRK48];%empty
HXCEL49=[DU1H,DU2H,DUSEGH49,HXBRK49];%empty with RFBPM
HXCEL50=[DU1H,DU2H,DUSEGH50,HXBRK50];%empty
HXRCL=[HXCEL13,HXCEL14,HXCEL15,HXCEL16,HXCEL17,HXCEL18,HXCEL19,HXCEL20,HXCEL21,HXCEL22,HXCEL23,HXCEL24,HXCEL25,HXCEL26,HXCEL27,HXCEL28,HXCEL29,HXCEL30,HXCEL31,HXCEL32,HXCEL33,HXCEL34,HXCEL35,HXCEL36,HXCEL37,HXCEL38,HXCEL39,HXCEL40,HXCEL41,HXCEL42,HXCEL43,HXCEL44,HXCEL45,HXCEL46,HXCEL47,HXCEL48,HXCEL49,HXCEL50];
HXR=[DU0H,DU8H,HXRSTART,HXRCL,RWWAKE5H,HXRTERM,DUE1A,RFBHX51,DUE1E,ENDUNDH];
% ------------------------------------------------------------------------------
% HXR undulator exit section
% ------------------------------------------------------------------------------
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQUE1 =   0.178908931125 ;%-0.09207220416
KQUE2 =  -0.136231234699 ;% 0.160489725306
QUE1={'qu' 'QUE1' LQD/2 [KQUE1 0]}';
QUE2={'qu' 'QUE2' LQD/2 [KQUE2 0]}';
TCX01={'tc' 'TCX01' 1.0/2 [XBANDF 0 0*TWOPI]}';%horizontal deflection
TCX02={'tc' 'TCX02' 1.0/2 [XBANDF 0 0*TWOPI]}';%horizontal deflection
DBKXDMPH={'dr' '' LBKXDMP []}';%placeholder for x-kicker in HXR dumpline
DUE2C={'dr' '' DUE2CB{3}+(LQR-LQD)/2 []}';%0.555
DUE3A={'dr' '' 0.375504+(LQP-LQD)/2+0.11496-0.063643 []}';
DUE3B={'dr' '' 1.2630495-0.11496+0.063643 []}';
DUE4={'dr' '' DUE4B{3}+(LQR-LQD)/2 []}';%0.394
DUE5A={'dr' '' 0.477799+(LQP-LQD)/2+0.012675-0.063653 []}';
DUE5B={'dr' '' 0.264-0.012675+0.063653 []}';
DUE5C={'dr' '' 0.2674 []}';
XCUE2={'mo' 'XCUE2' 0 []}';
XCD3={'mo' 'XCD3' 0 []}';
YCUE1={'mo' 'YCUE1' 0 []}';
YCD3={'mo' 'YCD3' 0 []}';
BPMUE1={'mo' 'BPMUE1' 0 []}';%RFBUE1 : MONI, TYPE="@2,CavityS-1"
BPMUE2={'mo' 'BPMUE2' 0 []}';%RFBUE2 : MONI, TYPE="@2,CavityS-1"
%RFBUE3 : MONI, TYPE="@2,CavityS-1"
%IMUNDO : IMON, TYPE="BCS toroid" BCS toroid
%IMBCS3 : IMON, TYPE="BCS toroid" BCS toroid before dump bend (comparator with IMBCS4)
MIMUNDO={'mo' 'MIMUNDO' 0 []}';
MIMBCS3={'mo' 'MIMBCS3' 0 []}';
TRUE1={'mo' 'TRUE1' 0 []}';%Be foil inserter (THz) -- existing LCLS device
SPTCX={'mo' 'SPTCX' 0 []}';%XTCAV spoiler
BTMQUE={'mo' 'BTMQUE' 0 []}';%Burn-Through-Monitor
BTM0={'mo' 'BTM0' 0 []}';%Burn-Through-Monitor behind the PCPM0
PCTCX={'dr' 'PCTCX' 0 []}';%XTCAV photon collimator (9 mm aperture)
PCPM0={'dr' 'PCPM0' LPCPM []}';
PH31={'mo' 'PH31' 0 []}';%post-undulator phase measurement RF cavity (existing LCLS device)
PH32={'mo' 'PH32' 0 []}';%post-undulator phase measurement RF cavity (existing LCLS device)
PH33={'mo' 'PH33' 0 []}';%post-undulator phase measurement RF cavity (high rate)
PH34={'mo' 'PH34' 0 []}';%post-undulator phase measurement RF cavity (high rate)
UEBEG={'mo' 'UEBEG' 0 []}';
UEEND={'mo' 'UEEND' 0 []}';
VVTCX={'mo' 'VVTCX' 0 []}';%XTCAV vacuum valve
VV36={'mo' 'VV36' 0 []}';%treaty-point vacuum valve just downbeam of undulator
VV37={'mo' 'VV37' 0 []}';%vac. valve in dumpline
MTCX01={'mo' 'MTCX01' 0 []}';%entrance to TCX01 (for ELEGANT WATCH point)
MTCX={'mo' 'MTCX' 0 []}';%centerline between TCX01 and TCX02 (for matching)
DLSTART={'mo' 'DLSTART' 0 []}';%start of dumpline
MDLWALL={'mo' 'MDLWALL' 0 []}';%front face of dumpline thermal barrier wall
QUE1_FULL=[QUE1,QUE1];
QUE2_FULL=[QUE2,QUE2];
UNDEXIT=[BEGDMPH_1,UEBEG,DUE1D,VV36,DUE1B,MIMUNDO,DUE1CA,PH33,DUE1CB,PH34,DUE1CC,DUE2A,YCUE1,DUE2B,PH31,DUE2D,PH32,DUE2E,XCUE2,DUE2C,QUE1_FULL,DUE3A,BPMUE1,DUE3B,TRUE1,DUE3C,DBKXDMPH,DUE3C,PCTCX,DPCVV,VVTCX,DVVTCX,MTCX01,TCX01,TCX01,DTCX12,MTCX,DTCX12,TCX02,TCX02,DTCXSP,SPTCX,DUE4,QUE2_FULL,DUE5A,BPMUE2,DUE5B,BTMQUE,DUE5C,PCPM0,DUE5F,BTM0,DUE5D,MIMBCS3,DUE5E,MDLWALL,DDLWALL,UEEND,DLSTART,DSB0A,YCD3,DSB0B,XCD3,DSB0C,VV37,DSB0D,DSB0E,ENDDMPH_1];
HXRUND=[HXR,UNDEXIT];

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc safety dump lines
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 26-MAR-2019, M. Woodley
%  * split SFTH and SFTS areas into two subareas each: SFTH_1/SFTH_2
%    and SFTS_1/SFTS_2
% ------------------------------------------------------------------------------
% 08-OCT-2018, M. Woodley
%  * locations of devices downstream of HXR XTES treaty flange per
%    2017-11-21__REF__XTES_BG_HXR__mo37504899_update2017-12-19.xlsx
%  * locations of devices downstream of SXR XTES treaty flange per
%    2017-11-21__REF__XTES_BG_SXR__mo37504999_update2017-12-19.xlsx
%  * some device locations per SD-375-048-01 (SFTH) and SD-375-049-01 (SFTS)
% 20-JUN-2018, M. Woodley
%  * redefine SFTDUMP1 and SFTDUMPB1 beamlines: end at entrance to PM bends
% ------------------------------------------------------------------------------
% 14-FEB-2018, M. Woodley
%  * split SFTDUMP and SFTDUMPb lines to allow XTES output in linac coordinates
% 06-DEC-2017, M. Woodley
%  * add HXTES0 (treaty point flange for HXR XTES system)
%  * add SXTES0 (treaty point flange for SXR XTES system)
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * update some parameter names
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * move XDCXRAY & YAGXRAY 0.75 m downstream (E. Johnson)
% ------------------------------------------------------------------------------
% 24-AUG-2015, Y. Nosochkov
%  * remove PCPM3/BTM3, PCPM3B/BTM3B as they are not part of electron line
% ------------------------------------------------------------------------------
% 20-MAY-2015, Y. Nosochkov
%  * add PCPM3, PCPM3B, remove BXPM3 (per Shanjie)
%  * update aperture of PCPM1,2,3 and PCPM1B,2B,3B (per LCLSII-3.5-PR-0111-R1)
%  * update positions of PCPM2, BXPM1, BXPM2 (per Shanjie)
%  * move PCPM1, PCPM1B 0.135 m downstream (per A. Ibrahimov)
% ------------------------------------------------------------------------------
% 12-MAR-2015, Y. Nosochkov
%  * add existing XDCXRAY screen in the XDC chamber in HXR
% ------------------------------------------------------------------------------
% 12-DEC-2014, M. Woodley
%  * move area BEG/END MARKers to common.xsif
%  * add SEQ BEG/END MARKers
% 09-DEC-2014, Y. Nosochkov
%  * safety dump lines based on LCLS-I design and PRD LCLSII-3.5-PR-0111
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% HXR safety dump
% ------------------------------------------------------------------------------
% note that axis of BXPM1H,2H bends is parallel to HXR undulator axis but
% horizontally offset by +35 mm towards the North
LBXPM =  0.944               ;%effective straight length of permanent magnet FFTB dump bends (m)
GBXPM0 =  0.0381              ;%original gap height in FFTB magnets in 2005 (m)
GBXPM =  0.052               ;%modified (larger) gap height for LCLS safety dump
BBXPM0 =  4.3                 ;%original magnetic field (kG) at gap = 3.81 cm
BBXPM =  BBXPM0*GBXPM0/GBXPM ;%magnetic field (kG) at gap = 5.2 cm
RBXPM =  BRHOF/BBXPM         ;%bending radius (m) in permanent magnets
ABXPM =  (LBXPM/RBXPM)/2             ;%PM bend half-angle
ABXPM1S =  asin(1*ABXPM)               ;%bending angle of "short" half of BXPM1
ABXPM1L =  asin(2*ABXPM)-asin(1*ABXPM) ;%bending angle of "long"  half of BXPM1
ABXPM2S =  asin(3*ABXPM)-asin(2*ABXPM) ;%bending angle of "short" half of BXPM2
ABXPM2L =  asin(4*ABXPM)-asin(3*ABXPM) ;%bending angle of "long"  half of BXPM2
ABXPM1 =  ABXPM1S+ABXPM1L;
ABXPM2 =  ABXPM2S+ABXPM2L;
LBXPM1S =  RBXPM*ABXPM1S ;%path length in "short" half of BXPM1
LBXPM1L =  RBXPM*ABXPM1L ;%path length in "long"  half of BXPM1
LBXPM2S =  RBXPM*ABXPM2S ;%path length in "short" half of BXPM2
LBXPM2L =  RBXPM*ABXPM2L ;%path length in "long"  half of BXPM2
LBXPM1 =  LBXPM1S+LBXPM1L;
LBXPM2 =  LBXPM2S+LBXPM2L;
BXPM11={'be' 'BXPM1' LBXPM1S [ABXPM1S GBXPM/2 0 0 0.5 0.0 0]}';
BXPM12={'be' 'BXPM1' LBXPM1L [ABXPM1L GBXPM/2 0 ABXPM1 0.0 0.5 0]}';
BXPM21={'be' 'BXPM2' LBXPM2S [ABXPM2S GBXPM/2 -ABXPM1 0 0.5 0.0 0]}';
BXPM22={'be' 'BXPM2' LBXPM2L [ABXPM2L GBXPM/2 0 ABXPM1+ABXPM2 0.0 0.5 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BXPM1={'be' 'BXPM' LBXPM1 [ABXPM1 GBXPM/2 0 ABXPM1 0.5 0.5 0]}';
BXPM2={'be' 'BXPM' LBXPM2 [ABXPM2 GBXPM/2 -ABXPM1 ABXPM1+ABXPM2 0.5 0.5 0]}';
DYDS={'dr' '' LBYDS*cos(ABYDS/2) []}';
DYD1={'dr' '' LBDM*cos(ABYDS+ABDM/2) []}';
DYD2={'dr' '' LBDM*cos(ABYDS+3*ABDM/2) []}';
DYD3={'dr' '' LBDM*cos(ABYDS+5*ABDM/2) []}';
LDSCA =  0.479300-0.000001 ;%0.479298938157
LDSCB =  0.094517171073;
DS1S={'dr' '' LDS1*cos(ABYDS) []}';
DSSA={'dr' '' LDS*cos(ABYDS+ABDM) []}';
DSSB={'dr' '' LDS*cos(ABYDS+2*ABDM) []}';
DSCSA={'dr' '' LDSCA*cos(ABYDS+3*ABDM) []}';
DSCSB={'dr' '' LDSCB*cos(ABYDS+3*ABDM) []}';
LDPM3 =  8.784;
LDPM31 =  8.2704483799;
LDPM32 =  LDPM3-LDPM31;
ZSFTDMP =  0.0762 ;%safety dump Z-length
DPCBTM1={'dr' '' 0.15-0.135 []}';
DPCBTM2={'dr' '' 0.15 []}';
DPM1={'dr' '' 0.5350338 []}';%0.298
DPM11={'dr' '' 0.188644 []}';
DPM12={'dr' '' DPM1{3}-DPM11{3} []}';
DPM2={'dr' '' 0.30/cos(ABXPM1) []}';
DPM3={'dr' '' LDPM3/cos(ABXPM1+ABXPM2) []}';
DPM31={'dr' '' LDPM31/cos(ABXPM1+ABXPM2) []}';
DPM32={'dr' '' LDPM32/cos(ABXPM1+ABXPM2) []}';
DPCBTM3={'dr' '' 0 []}';%BTM3 is attached to d/s face of PCPM3
DPM4={'dr' '' 2.42/cos(ABXPM1+ABXPM2) []}';
DSFTDMP={'dr' '' ZSFTDMP/cos(ABXPM1+ABXPM2) []}';
DXDCU={'dr' '' 1.092223+0.75 []}';
DXDCU1={'dr' '' 0.8783 []}';
DXDCU1A={'dr' '' 0.840799 []}';
DXDCU1B={'dr' '' DXDCU1{3}-DXDCU1A{3} []}';
DXDCU2={'dr' '' DXDCU{3}-DXDCU1{3} []}';
DXDCU2A={'dr' '' 0.878201 []}';
DXDCU2B={'dr' '' DXDCU2{3}-DXDCU2A{3} []}';
XDCA={'dr' '' 0.312777 []}';%XDC chamber
XDCB={'dr' '' 0.693 []}';%XDC chamber
XDCC={'dr' '' 0.542 []}';%XDC chamber
XDCD={'dr' '' 0.255376 []}';%XDC chamber
DXDCD={'dr' '' 7.1789662-DXDCU{3}-XDCA{3}-XDCB{3}-XDCC{3}-XDCD{3} []}';%7.266
DXDCD1={'dr' '' 2.661321 []}';
DXDCD2={'dr' '' 0.512986 []}';
DXDCD2A={'dr' '' 0.142402 []}';
DXDCD2B={'dr' '' DXDCD2{3}-DXDCD2A{3} []}';
DXDCD3={'dr' '' DXDCD{3}-DXDCD1{3}-DXDCD2{3} []}';
PCPM1={'dr' 'PCPM1' LPCPM []}';%per LCLSII-3.5-PR-0111-R1
PCPM2={'dr' 'PCPM2' LPCPM []}';
%PCPM3  : ECOL, L=LPCPMW/COS(ABXPM1+ABXPM2), XSIZE=0.0080, YSIZE=0.0080
DPCPM3={'dr' '' LPCPMW/cos(ABXPM1+ABXPM2) []}';%placeholder for PCPM3
BTM1={'mo' 'BTM1' 0 []}';%Burn-Through-Monitor behind PCPM1
BTM2={'mo' 'BTM2' 0 []}';%Burn-Through-Monitor behind PCPM2
%BTM3   : INST Burn-Through-Monitor behind PCPM3
MBTM3={'mo' 'MBTM3' 0 []}';%placeholder for BTM3
BTMSFT={'mo' 'BTMSFT' 0 []}';%Burn-Through-Monitor behind HXR safety dump
RTDSL0={'mo' 'RTDSL0' 0 []}';
RTDSL0_YAGXRAY={'mo' 'RTDSL0_YAGXRAY' 0 []}';
TP_HXTES0={'mo' 'TP_HXTES0' 0 []}';%treaty point for HXR XTES system
TV1L0_VGC_1={'mo' 'TV1L0_VGC_1' 0 []}';
TV1L0_VRM_1={'mo' 'TV1L0_VRM_1' 0 []}';
TV1L0_GCC_1={'mo' 'TV1L0_GCC_1' 0 []}';
TV1L0_GPI_1={'mo' 'TV1L0_GPI_1' 0 []}';
IM1L0_XTES_VGC_1={'mo' 'IM1L0_XTES_VGC_1' 0 []}';
IM1L0_XTES_VRM_1={'mo' 'IM1L0_XTES_VRM_1' 0 []}';
IM1L0_XTES={'mo' 'IM1L0_XTES' 0 []}';
MBXPM1_PIP_1={'mo' 'MBXPM1_PIP_1' 0 []}';
SFTDMP={'mo' 'SFTDMP' 0 []}';%front face of HXR safety dump (Z'=712-715 m per PRD)
VV38={'mo' 'VV38' 0 []}';%vac. valve in HXR safety dump line
MVV10={'mo' 'MVV10' 0 []}';%placeholder for vac. valve in HXR XTES line
BXPM1_FULL=[BXPM11,BXPM12];
BXPM2_FULL=[BXPM21,BXPM22];
SFTDUMP1=[BEGSFTH_1,DYDS,DS1S,DYD1,DSSA,DYD2,DSSB,DYD3,DSCSA,VV38,DSCSB,PCPM1,DPCBTM1,BTM1,DXDCU1A,TV1L0_VGC_1,DXDCU1B,TP_HXTES0,DXDCU2A,TV1L0_VRM_1,TV1L0_GCC_1,TV1L0_GPI_1,DXDCU2B,XDCA,RTDSL0,XDCB,XDCC,RTDSL0_YAGXRAY,XDCD,DXDCD1,IM1L0_XTES_VGC_1,DXDCD2A,IM1L0_XTES_VRM_1,DXDCD2B,IM1L0_XTES,DXDCD3,PCPM2,BTM2,DPM11,MBXPM1_PIP_1,DPM12,ENDSFTH_1];
SFTDUMP2=[BEGSFTH_2,BXPM1_FULL,DPM2,BXPM2_FULL,DPM31,MVV10,DPM32,DPCPM3,DPCBTM3,MBTM3,DPM4,SFTDMP,DSFTDMP,BTMSFT,ENDSFTH_2];
SFTDUMP=[SFTDUMP1,SFTDUMP2];
% ------------------------------------------------------------------------------
% SXR safety dump
% ------------------------------------------------------------------------------
% note that BXPM1b bend axis is aligned with the SXR undulator axis without
% any offset
RBXPMB =  BRHOF/BBXPM ;%bending radius (m) in permanent magnet
ABXPMBH =  (LBXPM/RBXPMB)/2              ;%PM bend half-angle
ABXPM1BS =  asin(ABXPMBH)                 ;%bending angle of "short" half of BXPM1B
ABXPM1BL =  asin(2*ABXPMBH)-asin(ABXPMBH) ;%bending angle of "long"  half of BXPM1B
ABXPM1B =  ABXPM1BS+ABXPM1BL;
LBXPM1BS =  RBXPMB*ABXPM1BS ;%path length in "short" half of BXPM1B
LBXPM1BL =  RBXPMB*ABXPM1BL ;%path length in "long"  half of BXPM1B
LBXPM1B =  LBXPM1BS+LBXPM1BL;
BXPM1B1={'be' 'BXPM1B' LBXPM1BS [ABXPM1BS GBXPM/2 0 0 0.5 0.0 0]}';
BXPM1B2={'be' 'BXPM1B' LBXPM1BL [ABXPM1BL GBXPM/2 0 ABXPM1B 0.0 0.5 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BXPM1B={'be' 'BXPM1' LBXPM1B [ABXPM1B GBXPM/2 0 ABXPM1B 0.5 0.5 0]}';
DSCSB1={'dr' '' 0.478198407804 []}';%DSCSa[L]
DSCSB2={'dr' '' 0.0943 []}';%DSCSa[L]
DXDCUB={'dr' '' 1.842223 []}';%1.092223
DXDCUB1={'dr' '' 0.8407994 []}';%0.878299738776
DXDCUB2={'dr' '' 0.0375006 []}';
DXDCUB3={'dr' '' DXDCUB{3}-DXDCUB1{3}-DXDCUB2{3} []}';
XDCBA={'dr' '' 0.312777 []}';%XDC chamber
XDCBB={'dr' '' 0.693 []}';%XDC chamber
XDCBC={'dr' '' 0.542 []}';%XDC chamber
XDCBD={'dr' '' 0.255376 []}';%XDC chamber
DXDCDB={'dr' '' 7.266-DXDCUB{3}-XDCBA{3}-XDCBB{3}-XDCBC{3}-XDCBD{3} []}';
DXDCDB1={'dr' '' 0.262395 []}';
DXDCDB2={'dr' '' 0.363747 []}';
DXDCDB3={'dr' '' 0.966253 []}';
DXDCDB4={'dr' '' 1.492023 []}';
DXDCDB5={'dr' '' DXDCDB{3}-DXDCDB1{3}-DXDCDB2{3}-DXDCDB3{3}-DXDCDB4{3} []}';
DPM1B={'dr' '' 0.448 []}';
DPM2B={'dr' '' 3.8732111/cos(ABXPM1BS+ABXPM1BL) []}';%10.03
DPM2BA={'dr' '' 3.8732111/cos(ABXPM1BS+ABXPM1BL) []}';
DPM2BB={'dr' '' DPM2B{3}-DPM2BA{3} []}';
DPCBTM3B={'dr' '' 0 []}';%BTM3B is attached to d/s face of PCPM3B
DPM3B={'dr' '' 8.5747889/cos(ABXPM1BS+ABXPM1BL) []}';%2.272
DPM3BA={'dr' '' 0.6560246/cos(ABXPM1BS+ABXPM1BL) []}';
DPM3BB={'dr' '' DPM3B{3}-DPM3BA{3} []}';
DSFTDMPB={'dr' '' ZSFTDMP/cos(ABXPM1BS+ABXPM1BL) []}';
PCPM1B={'dr' 'PCPM1B' LPCPM []}';%per LCLSII-3.5-PR-0111-R1
PCPM2B={'dr' 'PCPM2B' LPCPM []}';
%PCPM3B  : ECOL, L=LPCPM/COS(ABXPM1BS+ABXPM1BL), XSIZE=0.0100, YSIZE=0.0100
DPCPM3B={'dr' '' LPCPMW/cos(ABXPM1BS+ABXPM1BL) []}';%placeholder for PCPM3B
BTM1B={'mo' 'BTM1B' 0 []}';%Burn-Through-Monitor behind PCPM1B
BTM2B={'mo' 'BTM2B' 0 []}';%Burn-Through-Monitor behind PCPM2B
%BTM3B   : INST Burn-Through-Monitor behind PCPM3B
MBTM3B={'mo' 'MBTM3B' 0 []}';%placeholder for BTM3B
BTMSFTB={'mo' 'BTMSFTB' 0 []}';%Burn-Through-Monitor behind SXR safety dump
YAGXRAYB={'mo' 'YAGXRAYB' 0 []}';%safety dump line X-ray screen
SXTES0={'mo' 'SXTES0' 0 []}';%treaty point for SXR XTES system
PC1S={'mo' 'PC1S' 0 []}';
GMD1S={'mo' 'GMD1S' 0 []}';
IM1S={'mo' 'IM1S' 0 []}';
MSL1S={'mo' 'MSL1S' 0 []}';
SFTDMPB={'mo' 'SFTDMPB' 0 []}';%front face of SXR safety dump (Z'=712-715 m per PRD)
VV38B={'mo' 'VV38B' 0 []}';%vac. valve in SXR safety dump line
VV1S={'mo' 'VV1S' 0 []}';%vac. valve in SXR safety dump line
VV2S={'mo' 'VV2S' 0 []}';%vac. valve in SXR safety dump line
MVV3S={'mo' 'MVV3S' 0 []}';%placeholder for vac. valve in SXR XTES line
BXPM1B_FULL=[BXPM1B1,BXPM1B2];
SFTDUMPB1=[BEGSFTS_1,DYDS,DS1S,DYD1,DSSA,DYD2,DSSB,DYD3,DSCSB1,VV38B,DSCSB2,PCPM1B,DPCBTM1,BTM1B,DXDCUB1,VV1S,DXDCUB2,SXTES0,DXDCUB3,XDCBA,XDCBB,XDCBC,YAGXRAYB,XDCBD,DXDCDB1,PC1S,DXDCDB2,VV2S,DXDCDB3,GMD1S,DXDCDB4,IM1S,DXDCDB5,BTM2B,PCPM2B,DPM1B,ENDSFTS_1];
SFTDUMPB2=[BEGSFTS_2,BXPM1B_FULL,DPM2BA,DPCPM3B,DPCBTM3B,MBTM3B,DPM2BB,MSL1S,DPM3BA,MVV3S,DPM3BB,SFTDMPB,DSFTDMPB,BTMSFTB,ENDSFTS_2];
SFTDUMPB=[SFTDUMPB1,SFTDUMPB2];

% *** OPTICS=AD_ACCEL-05DEC19 ***
% SXR XTES
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 20-JUN-2018, M. Woodley
%  * PCPM3B: keyw=ECOL, L=LPCPMW, XSIZE=0.0127, YSIZE=0.0127
% ------------------------------------------------------------------------------
% 09-JAN-2018, M. Woodley
%  * from: 2017-11-21__REF__XTES_BG_SXR__mo37504999_update2017-12-19.xlsx
% ------------------------------------------------------------------------------
% ==============================================================================
% mirrors
% ------------------------------------------------------------------------------
% NOTE: change mirrors from MULT to INST for Matlab model generator creation
A1X =  -0.024 ;
A1Y =   0.0;
A2X =  -0.028 ;
A2Y =   0.0;
A3X =   0.0   ;
A3Y =  -0.028;
A4X =   0.0   ;
A4Y =   0.042;
A5X =  -0.042 ;
A5Y =   0.0;
%M1K4 : MULT, TYPE="MIRROR",       K0L=a1x
%M2K4 : MULT, TYPE="KB1-H MIRROR", K0L=a2x
%M3K4 : MULT, TYPE="KB1-V MIRROR", K0L=a3y, T0
%M4K4 : MULT, TYPE="KB2-V MIRROR", K0L=a4y, T0
%M5K4 : MULT, TYPE="KB2-H MIRROR", K0L=a5x
M1K4={'mo' 'M1K4' 0 []}';
M2K4={'mo' 'M2K4' 0 []}';
M3K4={'mo' 'M3K4' 0 []}';
M4K4={'mo' 'M4K4' 0 []}';
M5K4={'mo' 'M5K4' 0 []}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
A12X =  A1X +A2X ;
A12Y =  A1Y +A2Y;
A13X =  A12X+A3X ;
A13Y =  A12Y+A3Y;
A14X =  A13X+A4X ;
A14Y =  A13Y+A4Y;
A15X =  A14X+A5X ;
A15Y =  A14Y+A5Y;
DSXTES01={'dr' '' 0.472 []}';
DSXTES02={'dr' '' 1.5 []}';
DSXTES03={'dr' '' 0.0 []}';
DSXTES04={'dr' '' 2.885211-LPCPMW/2 []}';
DSXTES05={'dr' '' 0.0 []}';
DSXTES06={'dr' '' 0.0 []}';
DSXTES07={'dr' '' 0.0 []}';
DSXTES08={'dr' '' 0.4147889-LPCPMW/2 []}';
DSXTES09={'dr' '' 0.04 []}';
DSXTES10={'dr' '' 0.2412357 []}';
DSXTES11={'dr' '' 7.9187643 []}';
DSXTES12={'dr' '' 0.0762 []}';
DSXTES13={'dr' '' 1.549568 []}';
DSXTES14={'dr' '' 9.5419013 []}';
DSXTES15={'dr' '' 1.0172561 []}';
DSXTES16={'dr' '' 1.10555 []}';
DSXTES17={'dr' '' 2.4382606 []}';
DSXTES18={'dr' '' 0.0 []}';
DSXTES19={'dr' '' 0.0 []}';
DSXTES20={'dr' '' 0.0 []}';
DSXTES21={'dr' '' 0.1423749 []}';
DSXTES22={'dr' '' 0.0 []}';
DSXTES23={'dr' '' 0.0 []}';
DSXTES24={'dr' '' 0.1300308 []}';
DSXTES25={'dr' '' 0.2823663 []}';
DSXTES26={'dr' '' 0.861249 []}';
DSXTES27={'dr' '' 0.12245 []}';
DSXTES28={'dr' '' 0.0527038 []}';
DSXTES29={'dr' '' 0.29367914 []}';
DSXTES30={'dr' '' 0.41068296 []}';
DSXTES31={'dr' '' 0.0 []}';
DSXTES32={'dr' '' 0.0 []}';
DSXTES33={'dr' '' 0.0 []}';
DSXTES34={'dr' '' 0.0 []}';
DSXTES35={'dr' '' 0.6053889 []}';
DSXTES36={'dr' '' 0.4026472 []}';
DSXTES37={'dr' '' 3.876691 []}';
DSXTES38={'dr' '' 2.937 []}';
DSXTES39={'dr' '' 2.937 []}';
DSXTES40={'dr' '' 1.9210907 []}';
DSXTES41={'dr' '' 0.0 []}';
DSXTES42={'dr' '' 0.0 []}';
DSXTES43={'dr' '' 0.5653502 []}';
DSXTES44={'dr' '' 0.4505591 []}';
% mirror #1 (M1K4; horizontal)
DSXTES45={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES46={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES47={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES48={'dr' '' 0.4505591/cos(A1X)/cos(A1Y) []}';
DSXTES49={'dr' '' 0.5414409/cos(A1X)/cos(A1Y) []}';
DSXTES50={'dr' '' 0.1174857/cos(A1X)/cos(A1Y) []}';
DSXTES51={'dr' '' 0.4205143/cos(A1X)/cos(A1Y) []}';
DSXTES52={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES53={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES54={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES55={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES56={'dr' '' 1.4194969/cos(A1X)/cos(A1Y) []}';
DSXTES57={'dr' '' 0.3660234/cos(A1X)/cos(A1Y) []}';
DSXTES58={'dr' '' 0.8367137/cos(A1X)/cos(A1Y) []}';
DSXTES59={'dr' '' 0.12245/cos(A1X)/cos(A1Y) []}';
DSXTES60={'dr' '' 0.0568367/cos(A1X)/cos(A1Y) []}';
DSXTES61={'dr' '' 0.2954817/cos(A1X)/cos(A1Y) []}';
DSXTES62={'dr' '' 2.5280924/cos(A1X)/cos(A1Y) []}';
DSXTES63={'dr' '' 0.4015629/cos(A1X)/cos(A1Y) []}';
DSXTES64={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES65={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES66={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES67={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES68={'dr' '' 0.7313423/cos(A1X)/cos(A1Y) []}';
DSXTES69={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES70={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES71={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES72={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES73={'dr' '' 0.460887/cos(A1X)/cos(A1Y) []}';
DSXTES74={'dr' '' 0.72537821/cos(A1X)/cos(A1Y) []}';
DSXTES75={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES76={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES77={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES78={'dr' '' 0.73037409/cos(A1X)/cos(A1Y) []}';
DSXTES79={'dr' '' 0.12245/cos(A1X)/cos(A1Y) []}';
DSXTES80={'dr' '' 0.0668367/cos(A1X)/cos(A1Y) []}';
DSXTES81={'dr' '' 0.246074/cos(A1X)/cos(A1Y) []}';
DSXTES82={'dr' '' 1.93/cos(A1X)/cos(A1Y) []}';
DSXTES83={'dr' '' 0.3219027/cos(A1X)/cos(A1Y) []}';
DSXTES84={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES85={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES86={'dr' '' 0.0/cos(A1X)/cos(A1Y) []}';
DSXTES87={'dr' '' 0.0380973/cos(A1X)/cos(A1Y) []}';
DSXTES88={'dr' '' 0.844/cos(A1X)/cos(A1Y) []}';
% mirror #2 (M2K4; horizontal)
DSXTES89={'dr' '' 0.649/cos(A12X)/cos(A12Y) []}';
% mirror #3 (M3K4; vertical)
DSXTES90={'dr' '' 0.457/cos(A13X)/cos(A13Y) []}';
DSXTES91={'dr' '' 5.582/cos(A13X)/cos(A13Y) []}';
% mirror #4 (M4K4; vertical)
DSXTES92={'dr' '' 0.0/cos(A14X)/cos(A14Y) []}';
DSXTES93={'dr' '' 0.0/cos(A14X)/cos(A14Y) []}';
DSXTES94={'dr' '' 0.0/cos(A14X)/cos(A14Y) []}';
DSXTES95={'dr' '' 0.0/cos(A14X)/cos(A14Y) []}';
DSXTES96={'dr' '' 0.6/cos(A14X)/cos(A14Y) []}';
% mirror #5 (M5K4; horizonal)
DSXTES97={'dr' '' 4.008001/cos(A15X)/cos(A15Y) []}';
% ==============================================================================
% instruments
% ------------------------------------------------------------------------------
MBXPM1B={'mo' 'MBXPM1B' 0 []}';
IP1S={'mo' 'IP1S' 0 []}';
SNSR1S={'mo' 'SNSR1S' 0 []}';
PCPM3B={'dr' 'PCPM3B' LPCPMW []}';
BTM3B={'mo' 'BTM3B' 0 []}';%Burn-Through-Monitor behind PCPM3b
SL1S={'mo' 'SL1S' 0 []}';
RO3S={'mo' 'RO3S' 0 []}';
CG3S={'mo' 'CG3S' 0 []}';
PG3S={'mo' 'PG3S' 0 []}';
VV3S={'mo' 'VV3S' 0 []}';
MSFTDMPB={'mo' 'MSFTDMPB' 0 []}';
MBTMSFTB={'mo' 'MBTMSFTB' 0 []}';
AT1S={'mo' 'AT1S' 0 []}';
VV4S={'mo' 'VV4S' 0 []}';
XGMD2S={'mo' 'XGMD2S' 0 []}';
VV5S={'mo' 'VV5S' 0 []}';
VV6S={'mo' 'VV6S' 0 []}';
RO4S={'mo' 'RO4S' 0 []}';
CG4S={'mo' 'CG4S' 0 []}';
PG4S={'mo' 'PG4S' 0 []}';
SPEC={'mo' 'SPEC' 0 []}';
RO6S={'mo' 'RO6S' 0 []}';
CG7S={'mo' 'CG7S' 0 []}';
PG7S={'mo' 'PG7S' 0 []}';
FV1S={'mo' 'FV1S' 0 []}';
PC2S={'mo' 'PC2S' 0 []}';
BTM2S={'mo' 'BTM2S' 0 []}';
PCB1S={'mo' 'PCB1S' 0 []}';
IM2S={'mo' 'IM2S' 0 []}';
SL2S={'mo' 'SL2S' 0 []}';
RGA1S={'mo' 'RGA1S' 0 []}';
RO8S={'mo' 'RO8S' 0 []}';
CG6S={'mo' 'CG6S' 0 []}';
PG6S={'mo' 'PG6S' 0 []}';
PA1S={'mo' 'PA1S' 0 []}';
VV7S={'mo' 'VV7S' 0 []}';
IP2S={'mo' 'IP2S' 0 []}';
IP3S={'mo' 'IP3S' 0 []}';
IP4S={'mo' 'IP4S' 0 []}';
RO5S={'mo' 'RO5S' 0 []}';
CG5S={'mo' 'CG5S' 0 []}';
PG5S={'mo' 'PG5S' 0 []}';
GP1S={'mo' 'GP1S' 0 []}';
CG9S={'mo' 'CG9S' 0 []}';
PG9S={'mo' 'PG9S' 0 []}';
IP5S={'mo' 'IP5S' 0 []}';
GP2S={'mo' 'GP2S' 0 []}';
SLIT1S={'mo' 'SLIT1S' 0 []}';
FV2S={'mo' 'FV2S' 0 []}';
ST1S={'mo' 'ST1S' 0 []}';
RO9S={'mo' 'RO9S' 0 []}';
CG10S={'mo' 'CG10S' 0 []}';
PG10S={'mo' 'PG10S' 0 []}';
IP6S={'mo' 'IP6S' 0 []}';
VV8S={'mo' 'VV8S' 0 []}';
SHLDG={'mo' 'SHLDG' 0 []}';
PC3S={'mo' 'PC3S' 0 []}';
BTM3S={'mo' 'BTM3S' 0 []}';
PCB2S={'mo' 'PCB2S' 0 []}';
IM3S={'mo' 'IM3S' 0 []}';
PC4S={'mo' 'PC4S' 0 []}';
ST2S={'mo' 'ST2S' 0 []}';
RO10S={'mo' 'RO10S' 0 []}';
CG11S={'mo' 'CG11S' 0 []}';
PG11S={'mo' 'PG11S' 0 []}';
IP7S={'mo' 'IP7S' 0 []}';
ST3S={'mo' 'ST3S' 0 []}';
RO11S={'mo' 'RO11S' 0 []}';
CG12S={'mo' 'CG12S' 0 []}';
PG12S={'mo' 'PG12S' 0 []}';
IP8S={'mo' 'IP8S' 0 []}';
VV9S={'mo' 'VV9S' 0 []}';
RO12S={'mo' 'RO12S' 0 []}';
CG13S={'mo' 'CG13S' 0 []}';
PG13S={'mo' 'PG13S' 0 []}';
IP9S={'mo' 'IP9S' 0 []}';
PC5S={'mo' 'PC5S' 0 []}';
BTM5S={'mo' 'BTM5S' 0 []}';
PCB3S={'mo' 'PCB3S' 0 []}';
WALL1SE={'mo' 'WALL1SE' 0 []}';
WALL1SW={'mo' 'WALL1SW' 0 []}';
VV10S={'mo' 'VV10S' 0 []}';
RO7S={'mo' 'RO7S' 0 []}';
CG8S={'mo' 'CG8S' 0 []}';
PG8S={'mo' 'PG8S' 0 []}';
RGA2S={'mo' 'RGA2S' 0 []}';
SNSR2S={'mo' 'SNSR2S' 0 []}';
RO13S={'mo' 'RO13S' 0 []}';
CG14S={'mo' 'CG14S' 0 []}';
PG14S={'mo' 'PG14S' 0 []}';
IP10S={'mo' 'IP10S' 0 []}';
HPD={'mo' 'HPD' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
SXTES=[BEGSXTES,DSXTES01,MBXPM1B,DSXTES02,IP1S,DSXTES03,SNSR1S,DSXTES04,PCPM3B,DSXTES05,BTM3B,DSXTES06,SL1S,DSXTES07,RO3S,DSXTES08,CG3S,DSXTES09,PG3S,DSXTES10,VV3S,DSXTES11,MSFTDMPB,DSXTES12,MBTMSFTB,DSXTES13,AT1S,DSXTES14,VV4S,DSXTES15,XGMD2S,DSXTES16,VV5S,DSXTES17,VV6S,DSXTES18,RO4S,DSXTES19,CG4S,DSXTES20,PG4S,DSXTES21,SPEC,DSXTES22,RO6S,DSXTES23,CG7S,DSXTES24,PG7S,DSXTES25,FV1S,DSXTES26,PC2S,DSXTES27,BTM2S,DSXTES28,PCB1S,DSXTES29,IM2S,DSXTES30,SL2S,DSXTES31,RGA1S,DSXTES32,RO8S,DSXTES33,CG6S,DSXTES34,PG6S,DSXTES35,PA1S,DSXTES36,VV7S,DSXTES37,IP2S,DSXTES38,IP3S,DSXTES39,IP4S,DSXTES40,RO5S,DSXTES41,CG5S,DSXTES42,PG5S,DSXTES43,GP1S,DSXTES44,M1K4,DSXTES45,CG9S,DSXTES46,PG9S,DSXTES47,IP5S,DSXTES48,GP2S,DSXTES49,SLIT1S,DSXTES50,FV2S,DSXTES51,ST1S,DSXTES52,RO9S,DSXTES53,CG10S,DSXTES54,PG10S,DSXTES55,IP6S,DSXTES56,VV8S,DSXTES57,SHLDG,DSXTES58,PC3S,DSXTES59,BTM3S,DSXTES60,PCB2S,DSXTES61,IM3S,DSXTES62,PC4S,DSXTES63,ST2S,DSXTES64,RO10S,DSXTES65,CG11S,DSXTES66,PG11S,DSXTES67,IP7S,DSXTES68,ST3S,DSXTES69,RO11S,DSXTES70,CG12S,DSXTES71,PG12S,DSXTES72,IP8S,DSXTES73,VV9S,DSXTES74,RO12S,DSXTES75,CG13S,DSXTES76,PG13S,DSXTES77,IP9S,DSXTES78,PC5S,DSXTES79,BTM5S,DSXTES80,PCB3S,DSXTES81,WALL1SE,DSXTES82,WALL1SW,DSXTES83,VV10S,DSXTES84,RO7S,DSXTES85,CG8S,DSXTES86,PG8S,DSXTES87,RGA2S,DSXTES88,M2K4,DSXTES89,M3K4,DSXTES90,SNSR2S,DSXTES91,M4K4,DSXTES92,RO13S,DSXTES93,CG14S,DSXTES94,PG14S,DSXTES95,IP10S,DSXTES96,M5K4,DSXTES97,HPD,ENDSXTES];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-05DEC19 ***
% LCLS2sc DASEL
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 25-NOV-2019, Y. Nosochkov
%  * update quad/corrector/BPM positions per L. Borzenets
%  * add two ACMs
% ------------------------------------------------------------------------------
% 23-AUG-2019, Y. Nosochkov
%  * split drift DDASBK3 in two halves DDASBK3h
% ------------------------------------------------------------------------------
% 31-OCT-2018, Y. Nosochkov
%  * move DASEL septum 3.685 m d/s to reduce each kicker BL to 25 Gm @ 8 GeV
%  * move BRDAS1 12.8 m u/s and increase septum angle to avoid interferences
%  * adjust other magnet positions, rematch geometry and optics
% ------------------------------------------------------------------------------
% 05-FEB-2018, Y. Nosochkov
%  * minor optics rematch
% 06-SEP-2017, Y. Nosochkov
%  * move BRDAS1 0.8 m downstream (K. Grouev), adjust positions of quads,
%    rematch optics
%  * update bore aperture of fast kickers to 20 mm (10 mm beam space +
%    10 mm pipe width)
% 22-AUG-2017, M. Woodley
%  * add WOODDOOR MARKer
% 19-JUL-2017, M. Woodley
%  * set ROLLRC = +1 by default (for MAD-to-BMAD); set to zero for Twiss in
%    MAD driver file
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * rename rolled BKYDAS1-6 to BKRDAS1-6 (per naming convention)
%  * move definitions of DDASA1, DDASA2 drifts to ALINE.xsif and rename
%  * add three quads QDAS1b, QDAS2b, QDAS18b for compatibility with 8 GeV 
% 23-NOV-2016, Y. Nosochkov
%  * reduce number of kickers from 7 to 6 (T. Beukers)
%  * correct minor error in kicker length formulas
%  * move PRDAS14 to center of the drift between quads QDAS14 and QDAS15
%  * move PRDAS17 to upstream side of QDAS17 to avoid interference with BXSP1H
% 02-NOV-2016, Y. Nosochkov
%  * match DASEL to new trajectory between BSY pulsed magnets and BXAM1
%  * increase x-offset of DASEL line between DC-bends from 35 to 40 cm
%  * add a note that BRDAS2 is a merge DC-bend which is turned ON for
%    DASEL beam to A-line or OFF for beam to A-line from BSY pulsed magnets 
% 21-SEP-2016, Y. Nosochkov
%  * add Y-corrector YCDAS1 (to compensate for missing trims on BYDAS1,2)
%  * move YCDAS15 downstream and rename to YCDAS17 (for better phase)
% 16-SEP-2016, Y. Nosochkov
%  * remove weak vertical bends BYDAS1, BYDAS2
%  * roll kicker/septum to compensate kicker vertical angle
%  * rematch geometry & optics to compensate kicker orbit & dispersion
% 26-AUG-2016, Y. Nosochkov
%  * change quad type from 2Q10 to 2Q4W
%  * rename QDAS1 -> QDAS1a, QDAS2 -> QDAS2a
% 17-AUG-2016, Y. Nosochkov
%  * add 3 BPMs (2 for MPS), 5 dipole correctors, 3 profile monitors
% 05-AUG-2016, Y. Nosochkov
%  * resolve interferences:
%    move QDAS1&2 and BYDAS2 0.815 m downstream
%    move QDAS19 0.6 m upstream --> this will move QDAS17 0.45 m upstream
%  * increase the number of kickers to 7 and move them 3 m upstream,
%    note: this will also require moving dumpline BPMSP1D 3 m upstream
% 30-APR-2016, Y. Nosochkov
%  * initial lattice
% ------------------------------------------------------------------------------
% NOTE: ABRDAS2 and TBRDAS2 are defined in common.xsif
% ------------------------------------------------------------------------------
% DASEL
% ------------------------------------------------------------------------------
% Six rolled vertical kickers aligned along the BSY dumpline axis
GBKRDAS =  0.02            ;%kicker bore gap (m)
ZBKRDAS =  1.0             ;%kicker straight length (m)
TBKRDAS =  -0.030150284271 ;%kicker tilt angle relative to y-axis (rad)
ABKRDAS0 =  -0.56211349418E-3;
ABKRDAS =  ABKRDAS0 *SETDA        ;%total kicker angle (rad)
ABKRDAS1 =  asin(1*sin(ABKRDAS)/6) ;%1st kicker angle (rad)
ABKRDAS12 =  asin(2*sin(ABKRDAS)/6) ;%1st+2nd kicker angle (rad)
ABKRDAS13 =  asin(3*sin(ABKRDAS)/6) ;%1+2+3 kicker angle (rad)
ABKRDAS14 =  asin(4*sin(ABKRDAS)/6) ;%1+2+3+4 kicker angle (rad)
ABKRDAS15 =  asin(5*sin(ABKRDAS)/6) ;%1+2+3+4+5 kicker angle (rad)
ABKRDAS2 =  ABKRDAS12-ABKRDAS1     ;%2nd kicker angle (rad)
ABKRDAS3 =  ABKRDAS13-ABKRDAS12    ;%3rd kicker angle (rad)
ABKRDAS4 =  ABKRDAS14-ABKRDAS13    ;%4th kicker angle (rad)
ABKRDAS5 =  ABKRDAS15-ABKRDAS14    ;%5th kicker angle (rad)
ABKRDAS6 =  ABKRDAS  -ABKRDAS15    ;%6th kicker angle (rad)
LBKRDAS1 =  1*ZBKRDAS/(1-ABKRDAS1 *ABKRDAS1 /6);
LBKRDAS12 =  2*ZBKRDAS/(1-ABKRDAS12*ABKRDAS12/6);
LBKRDAS13 =  3*ZBKRDAS/(1-ABKRDAS13*ABKRDAS13/6);
LBKRDAS14 =  4*ZBKRDAS/(1-ABKRDAS14*ABKRDAS14/6);
LBKRDAS15 =  5*ZBKRDAS/(1-ABKRDAS15*ABKRDAS15/6);
LBKRDAS =  6*ZBKRDAS/(1-ABKRDAS  *ABKRDAS  /6);
LBKRDAS2 =    LBKRDAS12-LBKRDAS1;
LBKRDAS3 =    LBKRDAS13-LBKRDAS12;
LBKRDAS4 =    LBKRDAS14-LBKRDAS13;
LBKRDAS5 =    LBKRDAS15-LBKRDAS14;
LBKRDAS6 =    LBKRDAS  -LBKRDAS15;
BKRDAS1A={'be' 'BKRDAS1' LBKRDAS1/2 [ABKRDAS1/2 GBKRDAS/2 0 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS1B={'be' 'BKRDAS1' LBKRDAS1/2 [ABKRDAS1/2 GBKRDAS/2 0 ABKRDAS1 0 0.5 PI/2+TBKRDAS]}';
BKRDAS2A={'be' 'BKRDAS2' LBKRDAS2/2 [ABKRDAS2/2 GBKRDAS/2 -ABKRDAS1 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS2B={'be' 'BKRDAS2' LBKRDAS2/2 [ABKRDAS2/2 GBKRDAS/2 0 ABKRDAS12 0 0.5 PI/2+TBKRDAS]}';
BKRDAS3A={'be' 'BKRDAS3' LBKRDAS3/2 [ABKRDAS3/2 GBKRDAS/2 -ABKRDAS12 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS3B={'be' 'BKRDAS3' LBKRDAS3/2 [ABKRDAS3/2 GBKRDAS/2 0 ABKRDAS13 0 0.5 PI/2+TBKRDAS]}';
BKRDAS4A={'be' 'BKRDAS4' LBKRDAS4/2 [ABKRDAS4/2 GBKRDAS/2 -ABKRDAS13 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS4B={'be' 'BKRDAS4' LBKRDAS4/2 [ABKRDAS4/2 GBKRDAS/2 0 ABKRDAS14 0 0.5 PI/2+TBKRDAS]}';
BKRDAS5A={'be' 'BKRDAS5' LBKRDAS5/2 [ABKRDAS5/2 GBKRDAS/2 -ABKRDAS14 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS5B={'be' 'BKRDAS5' LBKRDAS5/2 [ABKRDAS5/2 GBKRDAS/2 0 ABKRDAS15 0 0.5 PI/2+TBKRDAS]}';
BKRDAS6A={'be' 'BKRDAS6' LBKRDAS6/2 [ABKRDAS6/2 GBKRDAS/2 -ABKRDAS15 0 0.5 0 PI/2+TBKRDAS]}';
BKRDAS6B={'be' 'BKRDAS6' LBKRDAS6/2 [ABKRDAS6/2 GBKRDAS/2 0 ABKRDAS 0 0.5 PI/2+TBKRDAS]}';
% 2-hole rolled horizontal septum aligned along the BSY dumpline axis
GBLRDAS =  GBLSP ;%septum gap height (m)
ZBLRDAS =  LBLSP ;%septum straight length (m)
ABLRDAS0 =  -0.018635912887;
ABLRDAS =  ABLRDAS0 *SETDA      ;%septum bending angle (rad)
ABLRDASA =  asin(sin(ABLRDAS)/2) ;%angle per 1st half of the septum
ABLRDASB =  ABLRDAS-ABLRDASA     ;%angle per 2nd half of the septum
ABLRDAS_2 =  ABLRDAS   *ABLRDAS;
ABLRDAS_4 =  ABLRDAS_2 *ABLRDAS_2;
ABLRDASA_2 =  ABLRDASA  *ABLRDASA;
ABLRDASA_4 =  ABLRDASA_2*ABLRDASA_2;
LBLRDAS =  ZBLRDAS   /(1-ABLRDAS_2/6 +ABLRDAS_4/120 )/cos(ABKRDAS);
LBLRDASA =  ZBLRDAS/2 /(1-ABLRDASA_2/6+ABLRDASA_4/120)/cos(ABKRDAS);
LBLRDASB =  LBLRDAS-LBLRDASA;
BLRDASA={'be' 'BLRDAS' LBLRDASA [ABLRDASA GBLRDAS/2 0 0 0.5 0 TBKRDAS]}';
BLRDASB={'be' 'BLRDAS' LBLRDASB [ABLRDASB GBLRDAS/2 0 ABLRDAS 0 0.5 TBKRDAS]}';
% rolled DC-bends (BLmax of 1.0D38.37 = 7.35 kGm per J. Amann)
ABRDAS1 =  0.019101579697;
LBRDAS1 =  LBSP*ABRDAS1/(2*sin(ABRDAS1/2)) ;%BRDAS1 path length (m)
TBRDAS1 =  0.219255742276                  ;%BRDAS1 roll angle (rad)
BRDAS1A={'be' 'BRDAS1' LBRDAS1/2 [ABRDAS1/2 GBSP/2 ABRDAS1/2 0 0.5 0 TBRDAS1]}';
BRDAS1B={'be' 'BRDAS1' LBRDAS1/2 [ABRDAS1/2 GBSP/2 0 ABRDAS1/2 0 0.5 TBRDAS1]}';
% Note: BRDAS2 is a merge DC-bend which is either turned ON to operate
%       DASEL beam in A-line, or turned OFF to operate beam in A-line from
%       BSY pulsed magnets
LBRDAS2 =  LBSP*ABRDAS2/(2*sin(ABRDAS2/2)) ;%BRDAS2 path length (m)
BRDAS2A={'be' 'BRDAS2' LBRDAS2/2 [ABRDAS2/2 GBSP/2 ABRDAS2/2 0 0.5 0 TBRDAS2]}';
BRDAS2B={'be' 'BRDAS2' LBRDAS2/2 [ABRDAS2/2 GBSP/2 0 ABRDAS2/2 0 0.5 TBRDAS2]}';
% quads
KQDAS1 =  -0.453695580774;
KQDAS2 =   0.456501974891;
KQDAS11 =  -0.29960177747;
KQDAS12 =   0.324000602479;
KQDAS13 =  -0.68249002529;
KQDAS14 =   0.519096986888;
KQDAS17 =  -0.577539463501;
KQDAS18 =   0.540526371867;
KQDAS19 =  -0.314095531193;
KQDAS15 =  -KQDAS14;
KQDAS16 =   KQDAS14;
QDAS1A={'qu' 'QDAS1A' LQM/2 [KQDAS1 0]}';
QDAS1B={'qu' 'QDAS1B' LQM/2 [KQDAS1 0]}';
QDAS2A={'qu' 'QDAS2A' LQM/2 [KQDAS2 0]}';
QDAS2B={'qu' 'QDAS2B' LQM/2 [KQDAS2 0]}';
QDAS11={'qu' 'QDAS11' LQM/2 [KQDAS11 0]}';
QDAS12={'qu' 'QDAS12' LQM/2 [KQDAS12 0]}';
QDAS13={'qu' 'QDAS13' LQM/2 [KQDAS13 0]}';
QDAS14={'qu' 'QDAS14' LQM/2 [KQDAS14 0]}';
QDAS15={'qu' 'QDAS15' LQM/2 [KQDAS15 0]}';
QDAS16={'qu' 'QDAS16' LQM/2 [KQDAS16 0]}';
QDAS17={'qu' 'QDAS17' LQM/2 [KQDAS17 0]}';
QDAS18A={'qu' 'QDAS18A' LQM/2 [KQDAS18 0]}';
QDAS18B={'qu' 'QDAS18B' LQM/2 [KQDAS18 0]}';
QDAS19={'qu' 'QDAS19' LQM/2 [KQDAS19 0]}';
% drifts
ZDDASBK =  0.3      ;%Z-space between consecutive kickers
ZDDASBLX =  18.75 +3.685  ;%Z-space between the last kicker and the septum
ZDDASBLXA =  5.145    ;%set for y=5mm at BPM
ZDDASBLXB =  ZDDASBLX-ZDDASBLXA;
LDDASBK1 =  ZDDASBK  /cos(ABKRDAS1);
LDDASBK2 =  ZDDASBK  /cos(ABKRDAS12);
LDDASBK3 =  ZDDASBK  /cos(ABKRDAS13);
LDDASBK4 =  ZDDASBK  /cos(ABKRDAS14);
LDDASBK5 =  ZDDASBK  /cos(ABKRDAS15);
LDDASBLXA =  ZDDASBLXA/cos(ABKRDAS);
LDDASBLXB =  ZDDASBLXB/cos(ABKRDAS);
DDASBK1={'dr' '' LDDASBK1 []}';
DDASBK2={'dr' '' LDDASBK2 []}';
DDASBK3H={'dr' '' LDDASBK3/2 []}';
DDASBK4={'dr' '' LDDASBK4 []}';
DDASBK5={'dr' '' LDDASBK5 []}';
DDASBLXA={'dr' '' LDDASBLXA []}';
DDASBLXB={'dr' '' LDDASBLXB []}';
LDDASQQ =  0.1357;
LDDAS1 =  23.2085 -0.761426-0.000133;
LDDAS2A =  0.5;
LDDAS2B =  0.5 +0.761426-0.025296+0.000133-0.000004;
LDDAS3 =  0.5 +0.025296+0.000004;
DLDDAS4 =  0.0;
LDDAS4 =  1.9 +DLDDAS4;
DLDDAS5 =  0.765561526879E-2;
LDDAS5 =  56.315-(LBLSP+LBSP)/2-4*LQM-2*LDDASQQ -LDDAS1-LDDAS2A-LDDAS2B-LDDAS3-LDDAS4 +DLDDAS5;
LDDAS5B =  12.05*0.0254 ;%=0.30607 per C. Clarke
LDDAS5C =  1.0;
LDDAS5A =  LDDAS5-LDDAS5B-LDDAS5C;
DLDDAS11 =  0.0;
LDDAS11 =  5.5-(LBSP+LQM)/2 +DLDDAS11 -0.7;
LDDAS11A =  0.5 +0.300006+0.000003;
LDDAS11B =  LDDAS11-LDDAS11A;
DLDDAS12 =  0.0;
LDDAS12 =  14.1 +DLDDAS12 +0.7;
LDDAS13 =  18.128190337721 +0.5;
LDDAS13A =  2.97;
LDDAS13B =  LDDAS13-LDDAS13A;
LDDAS14 =  18.128190337721 -0.5+0.79997;
LDDAS14B =  0.5;
LDDAS14A =  LDDAS14-LDDAS14B;
LDDAS14AA =  14.473260664942 -0.5  ;%set Z=3050.512000 m at WOODDOOR
LDDAS14AB =  LDDAS14A-LDDAS14AA;
LDDAS17 =  18.128190337721 -0.79997;
LDDAS17B =  0.5;
LDDAS17C =  0.5;
LDDAS17A =  LDDAS17-LDDAS17B-LDDAS17C;
LDDAS18 =  15.540177251451;
DLDDAS19 =  0.0;
LDDAS19 =  9.24017725092-LDDASQQ-LQM +DLDDAS19;
DLDDAS20 =  0.0;
LDDAS20 =  22.55-(LBSP+LQM)/2 +DLDDAS20;
LDDAS20A =  0.5 -0.05163;
LDDAS20B =  LDDAS20-LDDAS20A;
DLDDAS =  0.0;
LDDAS =  (158.566506190974298-10*LQM-LBSP-LDDASQQ-LDDAS11-LDDAS12 -LDDAS13-LDDAS14-LDDAS17-LDDAS18-LDDAS19-LDDAS20)/2 +DLDDAS;
LDDAS15 =  LDDAS;
LDDAS15A =  LDDAS/2 -0.79997;
LDDAS15B =  LDDAS15-LDDAS15A;
LDDAS16 =  LDDAS;
DDASQQ={'dr' '' LDDASQQ []}';
DDAS1={'dr' '' LDDAS1 []}';
DDAS2A={'dr' '' LDDAS2A []}';
DDAS2B={'dr' '' LDDAS2B []}';
DDAS3={'dr' '' LDDAS3 []}';
DDAS4={'dr' '' LDDAS4 []}';
DDAS5A={'dr' '' LDDAS5A []}';
DDAS5B={'dr' '' LDDAS5B []}';
DDAS5C={'dr' '' LDDAS5C []}';
DDAS11A={'dr' '' LDDAS11A []}';
DDAS11B={'dr' '' LDDAS11B []}';
DDAS12={'dr' '' LDDAS12 []}';
DDAS13A={'dr' '' LDDAS13A []}';
DDAS13B={'dr' '' LDDAS13B []}';
DDAS14A={'dr' '' LDDAS14A []}';
DDAS14AA={'dr' '' LDDAS14AA []}';
DDAS14AB={'dr' '' LDDAS14AB []}';
DDAS14B={'dr' '' LDDAS14B []}';
DDAS15A={'dr' '' LDDAS15A []}';
DDAS15B={'dr' '' LDDAS15B []}';
DDAS16={'dr' '' LDDAS16 []}';
DDAS17A={'dr' '' LDDAS17A []}';
DDAS17B={'dr' '' LDDAS17B []}';
DDAS17C={'dr' '' LDDAS17C []}';
DDAS18={'dr' '' LDDAS18 []}';
DDAS19={'dr' '' LDDAS19 []}';
DDAS20A={'dr' '' LDDAS20A []}';
DDAS20B={'dr' '' LDDAS20B []}';
% roll angles
ARODAS1 =   0.523790078614E-5;
ARODAS2 =   0.387294376318E-4;
ARODAS3 =  -0.229813948141E-4;
RODAS1={'ro' 'RODAS1' 0 [-(ARODAS1)]}';
RODAS2={'ro' 'RODAS2' 0 [-(ARODAS2)]}';
RODAS3={'ro' 'RODAS3' 0 [-(ARODAS3)]}';
% monitors
BPMDAS={'mo' 'BPMDAS' 0 []}';%not rolled
BPMDAS1={'mo' 'BPMDAS1' 0 []}';%MPS BPM
BPMDAS19={'mo' 'BPMDAS19' 0 []}';%MPS BPM
% steering correctors
% Notes: trims on all bends are used as correctors as well,
%        rolled correctors are rolled 90 deg relative to rolled bends
XCDAS1={'mo' 'XCDAS1' 0 []}';
XCDAS14={'mo' 'XCDAS14' 0 []}';
YCDAS1={'mo' 'YCDAS1' 0 []}';
YCDAS17={'mo' 'YCDAS17' 0 []}';
RCDAS11={'mo' 'RCDAS11' 0 []}';
RCDAS19={'mo' 'RCDAS19' 0 []}';
ROLLRC =  +1 ;%+1 for survey to show RC roll angle, but zero for twiss
RODAS11P={'ro' 'RODAS11P' 0 [-((TBRDAS1-PI/2)*ROLLRC)]}';
RODAS11M={'ro' 'RODAS11M' 0 [-(-RODAS11P{4})]}';
RODAS19P={'ro' 'RODAS19P' 0 [-((TBRDAS2-PI/2)*ROLLRC)]}';
RODAS19M={'ro' 'RODAS19M' 0 [-(-RODAS19P{4})]}';
% profile monitors
PRDAS12={'mo' 'PRDAS12' 0 []}';
PRDAS14={'mo' 'PRDAS14' 0 []}';
PRDAS17={'mo' 'PRDAS17' 0 []}';
% ACMs
IMDAS1={'mo' 'IMDAS1' 0 []}';
IMDAS2={'mo' 'IMDAS2' 0 []}';
% markers
BEGDASEL={'mo' 'BEGDASEL' 0 []}';
ENDDASEL={'mo' 'ENDDASEL' 0 []}';
% ------------------------------------------------------------------------------
% A-line adjustments
% ------------------------------------------------------------------------------
% quad strengths (also copy to SETK2scDA subroutine)
% %causes redefinitions when using SETK2scDA
% KQ10 =   0.04034296448;
% KQ11 =  -0.03865438496;
% KQ19 =   0.030550055348;
% KQ20 =  -0.125475886882E-2;
% KQ27 =  -0.074785603391;
% KQ28 =   0.041188876983;
% KQ30 =  -0.029276530035;
% KQ38 =   0.034027229146;

% ------------------------------------------------------------------------------
% beamlines
DASEL=[BKRDAS1A,BKRDAS1B,DDASBK1 ,BKRDAS2A,BKRDAS2B,DDASBK2 ,BKRDAS3A,BKRDAS3B,DDASBK3H,DDASBK3H,BKRDAS4A,BKRDAS4B,DDASBK4 ,BKRDAS5A,BKRDAS5B,DDASBK5 ,BKRDAS6A,BKRDAS6B,DDASBLXA,BPMDAS  ,DDASBLXB,BLRDASA ,BLRDASB ,RODAS1  ,DDAS1   ,XCDAS1  ,DDAS2A  ,YCDAS1  ,DDAS2B  ,BPMDAS1 ,DDAS3   ,QDAS1B  ,QDAS1B  ,DDASQQ  ,QDAS1A  ,QDAS1A  ,DDAS4   ,QDAS2A  ,QDAS2A  ,DDASQQ  ,QDAS2B  ,QDAS2B  ,DDAS5A  ,IMDAS1  ,DDAS5B  ,IMDAS2 ,DDAS5C ,BRDAS1A ,BRDAS1B ,RODAS2  ,DDAS11A ,RODAS11P,RCDAS11 ,RODAS11M,DDAS11B,QDAS11  ,QDAS11  ,DDAS12  ,QDAS12  ,QDAS12  ,DDAS13A ,PRDAS12 ,DDAS13B ,QDAS13  ,QDAS13  ,DDAS14AA,WOODDOOR,DDAS14AB,XCDAS14,DDAS14B,QDAS14  ,QDAS14  ,DDAS15A ,PRDAS14 ,DDAS15B ,QDAS15  ,QDAS15  ,DDAS16  ,QDAS16  ,QDAS16  ,DDAS17A ,PRDAS17 ,DDAS17B ,YCDAS17,DDAS17C,QDAS17  ,QDAS17  ,DDAS18  ,QDAS18A ,QDAS18A ,DDASQQ  ,QDAS18B ,QDAS18B ,DDAS19  ,QDAS19  ,QDAS19  ,DDAS20A ,BPMDAS19,DDAS20B ,RODAS3 ,BRDAS2A ,BRDAS2B ];
DASELA=[BEGDASEL,DASEL,DA04B,RODAS19P,RCDAS19,RODAS19M,ENDDASEL,ALINEC];
SPDASELA=[SPRDKH,SPRDKS,SPRDDA,DASELA];
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% DASEL stage-A beamline with dump in S30
% ACMs and profile monitor per Tor
% 
% DDAS12A={'dr' '' 1.0+0.7 []}';
% DDAS12B={'dr' '' 8.677925-DDAS12A{3}+0.7 []}';
% DUMPS30XL={'mo' 'DUMPS30XL' 1.0/2 []}';%half-dump for S30XL stage-1
% %DUMPS30XL : MONI, TYPE="@3,400W-dump", L=1.0/2 half-dump for S30XL stage-1
% DASEL1S=[BEGDASEL,BKRDAS1A,BKRDAS1B,DDASBK1 ,BKRDAS2A,BKRDAS2B,DDASBK2 ,BKRDAS3A,BKRDAS3B,DDASBK3H,DDASBK3H,BKRDAS4A,BKRDAS4B,DDASBK4 ,BKRDAS5A,BKRDAS5B,DDASBK5 ,BKRDAS6A,BKRDAS6B,DDASBLXA,BPMDAS  ,DDASBLXB,BLRDASA ,BLRDASB ,RODAS1  ,DDAS1   ,XCDAS1  ,DDAS2A  ,YCDAS1  ,DDAS2B  ,BPMDAS1 ,DDAS3   ,QDAS1B  ,QDAS1B  ,DDASQQ  ,QDAS1A  ,QDAS1A  ,DDAS4   ,QDAS2A  ,QDAS2A  ,DDASQQ  ,QDAS2B  ,QDAS2B  ,DDAS5A  ,IMDAS1  ,DDAS5B  ,IMDAS2 ,DDAS5C ,BRDAS1A ,BRDAS1B ,RODAS2  ,DDAS11A ,RODAS11P,RCDAS11 ,RODAS11M,DDAS11B,QDAS11  ,QDAS11  ,DDAS12A ,PRDAS12 ,DDAS12B ,DUMPS30XL,DUMPS30XL];
% SPDASEL1S=[SPRDKH,SPRDKS,SPRDDA,DASEL1S];


% ------------------------------------------------------------------------------
% DASEL stage-A beamline with dump in BSY
% 
% DDAS14AB1={'dr' '' 2.188023 []}';
% DUMPS30XL={'mo' 'DUMPS30XL' 1.0/2 []}';%half-dump for S30XL stage-1
% %DUMPS30XL : MONI, TYPE="@3,400W-dump", L=1.0/2 half-dump for S30XL stage-1
% DASEL1B=[BEGDASEL,BKRDAS1A,BKRDAS1B,DDASBK1 ,BKRDAS2A,BKRDAS2B,DDASBK2 ,BKRDAS3A,BKRDAS3B,DDASBK3H,DDASBK3H,BKRDAS4A,BKRDAS4B,DDASBK4 ,BKRDAS5A,BKRDAS5B,DDASBK5 ,BKRDAS6A,BKRDAS6B,DDASBLXA,BPMDAS  ,DDASBLXB,BLRDASA ,BLRDASB ,RODAS1  ,DDAS1   ,XCDAS1  ,DDAS2A  ,YCDAS1  ,DDAS2B  ,BPMDAS1 ,DDAS3   ,QDAS1B  ,QDAS1B  ,DDASQQ  ,QDAS1A  ,QDAS1A  ,DDAS4   ,QDAS2A  ,QDAS2A  ,DDASQQ  ,QDAS2B  ,QDAS2B  ,DDAS5A  ,IMDAS1  ,DDAS5B  ,IMDAS2 ,DDAS5C ,BRDAS1A ,BRDAS1B ,RODAS2  ,DDAS11A ,RODAS11P,RCDAS11 ,RODAS11M,DDAS11B,QDAS11  ,QDAS11  ,DDAS12  ,QDAS12  ,QDAS12  ,DDAS13A ,PRDAS12 ,DDAS13B,QDAS13  ,QDAS13  ,DDAS14AA,WOODDOOR,DDAS14AB1,DUMPS30XL,DUMPS30XL];
% SPDASEL1B=[SPRDKH,SPRDKS,SPRDDA,DASEL1B];
% DASEL1S=[DASEL1B];%use name DASEL1S for printing twiss
% SPDASEL1S=[SPDASEL1B];%use name SPDASEL1S for printing twiss


LCLS2SCI=[BEAM0,DCM4B,QCM01_FULL,DCM5,CM01END,DCMCM1,HOMCM,DCAP0DA,ASTRA,DCAP0DB,FC1,DMSC0DA,BLF1,DMSC0DB,VG0H00,DMSC0DC,VP0H00,DMSC0DD,VV0H00,DMSC0DE,MSC0D,ENDL0B];
LCLS2SCC=[HTR,COL0,L1,BC1,COL1,L2,BC2,EMIT2,L3,EXT,DLBM];
% new BSY area definitions
% *** OPTICS=AD_ACCEL-05DEC19 ***
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-MAY-2018, M. Woodley
%  * add backup DC spreader lines (commented out)
% 21-FEB-2018, M. Woodley
%  * add BSYLTUSXTES and LCLS2scSXTES line definitions
% 25-JAN-2018, M. Woodley
%  * remove PCBSY2/BTMBSY2 per A. Ibrahimov
% ------------------------------------------------------------------------------
% 06-SEP-2017, Y. Nosochkov
%  * update definition of SPD1, SPD2 to include placeholders
%    for large aperture LCLS-II-HE kickers
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * pulsed correctors XCAPM2/YCAPM2 will be timed to affect the straight-ahead
%    LTUH beam, but not the A-line beam
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * update some drift names
% ------------------------------------------------------------------------------
% 23-NOV-2016, Y. Nosochkov
%  * update definition of SPD3 line for 6 DASEL kickers
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * redefine SPD3 line (DASEL kicker/septum system (off) + SPRDdb line)
% 02-NOV-2016, Y. Nosochkov
%  * split SPD2 into shorter SPD2 and SPD3 for DASEL
%  * add beamlines BSYLCLS2scDA and LCLS2scDA for DASEL
%  * update BSYH2 definition for use with A-line pulsed magnets
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * update beamline definitions to avoid duplication with other files
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% from superconducting linac
% ------------------------------------------------------------------------------
DBKYSP0HA={'dr' '' BKYSP0HA{3} []}';
DBKYSP0HB={'dr' '' BKYSP0HB{3} []}';
DBKYSP1HA={'dr' '' BKYSP1HA{3} []}';
DBKYSP1HB={'dr' '' BKYSP1HB{3} []}';
DBKYSP2HA={'dr' '' BKYSP2HA{3} []}';
DBKYSP2HB={'dr' '' BKYSP2HB{3} []}';
DBKYSP3HA={'dr' '' BKYSP3HA{3} []}';
DBKYSP3HB={'dr' '' BKYSP3HB{3} []}';
DBKYSP4HA={'dr' '' BKYSP4HA{3} []}';
DBKYSP4HB={'dr' '' BKYSP4HB{3} []}';
DBKYSP5HA={'dr' '' BKYSP5HA{3} []}';
DBKYSP5HB={'dr' '' BKYSP5HB{3} []}';
DBLXSPHA={'dr' '' BLXSPHA{3} []}';
DBLXSPHB={'dr' '' BLXSPHB{3} []}';
SPD1=[BEGSPD_1,DBKYSP0HA,DBKYSP0HB,DSPBK0H,DBKYSP1HA,DBKYSP1HB,DSPBK1H,DBKYSP2HA,DBKYSP2HB,DSPBK2H,DBKYSP3HA,DBKYSP3HB,DSPBK3H,DBKYSP4HA,DBKYSP4HB,DSPBK4H,DBKYSP5HA,DBKYSP5HB,DSPBK5HA,BPMSPH,DSPBK5HB,DBLXSPHA ,DBLXSPHB ,SPRDKSA  ,ENDSPD_1];
DBKYSP0SA={'dr' '' BKYSP0SA{3} []}';
DBKYSP0SB={'dr' '' BKYSP0SB{3} []}';
DBKYSP1SA={'dr' '' BKYSP1SA{3} []}';
DBKYSP1SB={'dr' '' BKYSP1SB{3} []}';
DBKYSP2SA={'dr' '' BKYSP2SA{3} []}';
DBKYSP2SB={'dr' '' BKYSP2SB{3} []}';
DBKYSP3SA={'dr' '' BKYSP3SA{3} []}';
DBKYSP3SB={'dr' '' BKYSP3SB{3} []}';
DBKYSP4SA={'dr' '' BKYSP4SA{3} []}';
DBKYSP4SB={'dr' '' BKYSP4SB{3} []}';
DBKYSP5SA={'dr' '' BKYSP5SA{3} []}';
DBKYSP5SB={'dr' '' BKYSP5SB{3} []}';
DBLXSPSA={'dr' '' BLXSPSA{3} []}';
DBLXSPSB={'dr' '' BLXSPSB{3} []}';
SPD2=[BEGSPD_2,DBKYSP0SA,DBKYSP0SB,DSPBK0S,DBKYSP1SA,DBKYSP1SB,DSPBK1S,DBKYSP2SA,DBKYSP2SB,DSPBK2S,DBKYSP3SA,DBKYSP3SB,DSPBK3S,DBKYSP4SA,DBKYSP4SB,DSPBK4S,DBKYSP5SA,DBKYSP5SB,DSPBK5SA,BPMSPS,DSPBK5SB,DBLXSPSA ,DBLXSPSB ,SPRDDA,ENDSPD_2];
DBKRDAS1A={'dr' '' BKRDAS1A{3} []}';
DBKRDAS1B={'dr' '' BKRDAS1B{3} []}';
DBKRDAS2A={'dr' '' BKRDAS2A{3} []}';
DBKRDAS2B={'dr' '' BKRDAS2B{3} []}';
DBKRDAS3A={'dr' '' BKRDAS3A{3} []}';
DBKRDAS3B={'dr' '' BKRDAS3B{3} []}';
DBKRDAS4A={'dr' '' BKRDAS4A{3} []}';
DBKRDAS4B={'dr' '' BKRDAS4B{3} []}';
DBKRDAS5A={'dr' '' BKRDAS5A{3} []}';
DBKRDAS5B={'dr' '' BKRDAS5B{3} []}';
DBKRDAS6A={'dr' '' BKRDAS6A{3} []}';
DBKRDAS6B={'dr' '' BKRDAS6B{3} []}';
DBLRDASA={'dr' '' BLRDASA{3} []}';
DBLRDASB={'dr' '' BLRDASB{3} []}';
SPD3=[BEGSPD_3,DBKRDAS1A,DBKRDAS1B,DDASBK1,DBKRDAS2A,DBKRDAS2B,DDASBK2,DBKRDAS3A,DBKRDAS3B,DDASBK3H,DDASBK3H,DBKRDAS4A,DBKRDAS4B,DDASBK4,DBKRDAS5A,DBKRDAS5B,DDASBK5,DBKRDAS6A,DBKRDAS6B,DDASBLXA,BPMDAS,DDASBLXB,DBLRDASA,DBLRDASB,SPRDDC,ENDSPD_3];
SLTD=[BEGSLTD,SPRDDD,ENDSLTD];
% ------------------------------------------------------------------------------			
SPS=[BEGSPS,SPRDKSB  ,SPRDSB,FODOLB,ENDSPS];
%SPS : LINE=(BEGSPS,SPRDksbDC,SPRDsb,FODOLb,ENDSPS) DC SXR spreader
DBRCUS1A={'dr' '' BRCUS1A{3} []}';
DBRCUS1B={'dr' '' BRCUS1B{3} []}';
SLTS=[BEGSLTS,FODOLC,BYPM1,DBRCUS1A,DBRCUS1B,MRGCUSXR,ENDSLTS];
BSYS=[BEGBSYS,BYPM2,MUWALLB,DWALLA,DUMPBSYS,DWALLB,BSYENDB,RWWAKE3S,ENDBSYS];
% ------------------------------------------------------------------------------
SPH=[BEGSPH,SPRDKH  ,SPRDHA,ENDSPH];
%SPH : LINE=(BEGSPH,SPRDkhDC,SPRDha,ENDSPH) DC HXR spreader
SLTH=[BEGSLTH,SPRDHB,ENDSLTH];
BSYH1=[BEGBSYH_1,SPHAL,ENDBSYH_1];
BSYH2=[BEGBSYH_2,DBKRAPM1A,DBKRAPM1B,DZAPM1,PCAPM1,DZAPM1,DBKRAPM2A,DBKRAPM2B,DZAPM2A,SCAPM2,DZAPM2B,PCAPM2,DZAPM2,DBKRAPM3A,DBKRAPM3B,DZAPM3,PCAPM3,DZAPM3,DBKRAPM4A,DBKRAPM4B,DZAPM4,PCAPM4,DZA01,DZA02,SPHBSYB,ENDBSYH_2];
% ------------------------------------------------------------------------------
BSYA=[ALINEA,ALINEB,ALINEC];
% ------------------------------------------------------------------------------
LTUS=[DBLDL21,LTUSC,RWWAKE4S,ENDLTUS,BEGUNDS,PREUNDS];
LTUH=[LTU];
% from SC linac (start at spreader)
BSYLCLS2SCS=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,DUMPLINEB];
BSYLCLS2SCSS=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB];
BSYLCLS2SCH=[SPH,SLTH,BSYH1,BSYH2,LTUH,HXRUND,DUMPLINE];
BSYLCLS2SCHS=[SPH,SLTH,BSYH1,BSYH2,LTUH,HXRUND,SFTDUMP];
BSYLCLS2SCD=[SPD1,SPD2,SPD3,SLTD];
BSYLCLS2SCA=[SPH,SLTH,BSYH1,BSYA];
BSYLCLS2SCDA=[SPD1,SPD2,DASELA];
BSYLCLS2SCSXTES=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB1,SXTES];
% from SC linac (start at end of dogleg)
LCLS2SCS=[FODOLA,BSYLCLS2SCS];
LCLS2SCSS=[FODOLA,BSYLCLS2SCSS];
LCLS2SCH=[FODOLA,BSYLCLS2SCH];
LCLS2SCHS=[FODOLA,BSYLCLS2SCHS];
LCLS2SCD=[FODOLA,BSYLCLS2SCD];
LCLS2SCA=[FODOLA,BSYLCLS2SCA];
LCLS2SCDA=[FODOLA,BSYLCLS2SCDA];
LCLS2SCSXTES=[FODOLA,BSYLCLS2SCSXTES];
% ------------------------------------------------------------------------------

% beam path definitions
%SC_SXR   : superconducting linac to e- SXR dump
%SC_SFTS  : superconducting linac to e- SXR safety dump
%SC_SXTES : superconducting linac to SXR XTES system
%SC_HXR   : superconducting linac to e- HXR dump
%SC_BSYD  : superconducting linac to BSY dump
%SC_DIAG0 : superconducting linac to DIAG0
%SC_DASEL : superconducting linac to End Station A (DASEL)
%SC_EIC   : superconducting linac Early Injector Commissioning
SC_SXR=[GUN,L0,LCLS2SCC,LCLS2SCS];
SC_SFTS=[GUN,L0,LCLS2SCC,LCLS2SCSS];
SC_SXTES=[GUN,L0,LCLS2SCC,LCLS2SCSXTES];
SC_HXR=[GUN,L0,LCLS2SCC,LCLS2SCH];
SC_BSYD=[GUN,L0,LCLS2SCC,LCLS2SCD];
SC_DIAG0=[GUN,L0,HTR,DIAG0];
SC_DASEL=[GUN,L0,LCLS2SCC,LCLS2SCDA];
SC_EIC=[EIC];
% for Twiss starting at BEAM0
SC_SXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCS];
SC_SFTSI=[LCLS2SCI,LCLS2SCC,LCLS2SCSS];
SC_SXTESI=[LCLS2SCI,LCLS2SCC,LCLS2SCSXTES];
SC_HXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCH];
SC_BSYDI=[LCLS2SCI,LCLS2SCC,LCLS2SCD];
SC_DIAG0I=[LCLS2SCI,HTR,DIAG0];
SC_DASELI=[LCLS2SCI,LCLS2SCC,LCLS2SCDA];
% ------------------------------------------------------------------------------
% initial BSY coordinates at BEGSP (LTUSPLIT)
% ------------------------------------------------------------------------------
XF =   XOFF;
YF =   1.899339708719 ;%1.897939159495 -0.3*SIN(2*AVB)
ZF =  -267.7180471432 ;%-267.4180504124 -0.3*COS(2*AVB)
THETAF =   0;
PHIF =   2*AVB;
PSIF =   0;
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% input beam definitions (at BEAM0)
% ------------------------------------------------------------------------------


% ------------------------------------------------------------------------------
% BETA0 block definitions
% ------------------------------------------------------------------------------
TWSS0=struct('ENERGY',E0,'BETX',BX0,'ALFX',AX0,'BETY',BY0,'ALFY',AY0);
TWSSA=struct('ENERGY',EI,'BETX',BXA,'ALFX',AXA,'BETY',BYA,'ALFY',AYA);
TWSSI=struct('ENERGY',EI,'BETX',BXI,'ALFX',AXI,'BETY',BYI,'ALFY',AYI);
TWSSMS=struct('ENERGY',EF,'BETX',MBETXS,'ALFX',MALFXS,'BETY',MBETYS,'ALFY',MALFYS);
TWSSMH=struct('ENERGY',EF,'BETX',MBETXH,'ALFX',MALFXH,'BETY',MBETYH,'ALFY',MALFYH);
TWSSP=struct('BETX',TBXSP,'BETY',TBYSP,'ALFX',TAXSP,'ALFY',TAYSP);
% temporary

% ==============================================================================
% SUBROUTINEs
% ------------------------------------------------------------------------------
% quad settings in A-line
% SETK2SCA : SUBROUTINE !for LCLS2scA
%   SET, KQ10, 0.04078118414
%   SET, KQ11, -0.035978491015
%   SET, KQ19, 0.0288935235
%   SET, KQ20, 0.011673337852
%   SET, KQ27, -0.069796542848
%   SET, KQ28, 0.029206357304
%   SET, KQ30, -0.029497355276
%   SET, KQ38, 0.034805766493

% quad settings in DASEL
% SETK2SCDA : SUBROUTINE !for LCLS2scDA
%   SET, KQ10, 0.04034296448
%   SET, KQ11, -0.03865438496
%   SET, KQ19, 0.030550055348
%   SET, KQ20, -0.125475886882E-2
%   SET, KQ27, -0.074785603391
%   SET, KQ28, 0.041188876983
%   SET, KQ30, -0.029276530035
%   SET, KQ38, 0.034027229146

% SETK2SCXL2 : SUBROUTINE !for XLEAP-II
%   SET, SETXLEAP2, 1
% ! UMXL1-4 undulator K=50
% ! self-seeding chicane R56=0.56 mm
% ! wiggler K=34
% ! maximum energy=6.25 GeV
%   SET, KQEM1B, 1.753498810647
%   SET, KQEM2B, -1.89151879979
%   SET, KQEM3B, 1.460130886376
%   SET, KQEM4B, -1.003271791653
%   SET, KQE31B, 0.259199272111
%   SET, KQE32B, -0.465309355382
%   SET, KQE33B, 0.709827895055
%   SET, KQE34B, -0.703993048304
%   SET, KQE35B, 0.74174515358
%   SET, KQE36B, -0.26747744113
%   SET, KQUM1B, 1.044383140731
%   SET, KQUM2B, -1.128507141132
%   SET, KQUM3B, 0.093454443485
%   SET, KQUM4B, 0.172049650009
%   SET, KQSX16, 1.489214343735
%   SET, KQSX19, -1.599319392703
%   SET, KQSX21, 1.728737247522
%   SET, KQSX24, -2.28070315173
%   SET, KQDSXM, -1.28484
%   SET, KQUE1B, -0.079627661951
%   SET, KQUE2B, 0.323427716703
%   SET, KQDMPB, -0.155766912296

% ------------------------------------------------------------------------------
% %for testing the online Matlab model
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %SETK2scXL2
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

% ==============================================================================
% COMMANDs
% ------------------------------------------------------------------------------



% ------------------------------------------------------------------------------
%CALL, FILENAME="LCLS2sc_beams.mad8" alternate beams & configurations
%CALL, FILENAME="LCLS2sc_match.mad8"
%CALL, FILENAME="RDB/LCLS2sc_makeSymbols.mad8"
%CALL, FILENAME="elegant/LCLS2sc_makeElegant.mad8"
%STOP
% ------------------------------------------------------------------------------
% SURVEY in linac coordinates
% ------------------------------------------------------------------------------
% EIC (Early Injector Commissioning)
% 
% 
% 
% 
% 
% 
% 
% 

% ------------------------------------------------------------------------------
% SXR
%COMMENT





%SAVELINE, NAME="SC_SXR", FILENAME="LCLS2scS.saveline"



%SETK2scXL2 turns on XLEAP2 components and optics


%, &
%  RTAPE="LCLS2scS_rmat.tape"



%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR safety dump
% 
% 
% 
% 
% 
% 
% %SAVELINE, NAME="SC_SFTS", FILENAME="LCLS2scSS.saveline"
% 
% 
% 
% 
% 
% %, &
% %  RTAPE="LCLS2scSS_rmat.tape"
% 
% 
% 

% ------------------------------------------------------------------------------
% HXR
%COMMENT





%SAVELINE, NAME="SC_HXR", FILENAME="LCLS2scH.saveline"





%, &
%  RTAPE="LCLS2scH_rmat.tape"



%ENDCOMMENT
% ------------------------------------------------------------------------------
% BSY dump
%COMMENT





%SAVELINE, NAME="SC_BSYD", FILENAME="LCLS2scD.saveline"





%, &
%  RTAPE="LCLS2scD_rmat.tape"



%ENDCOMMENT
% ------------------------------------------------------------------------------
% DIAG0
%COMMENT



%SAVELINE, NAME="SC_DIAG0", FILENAME="DIAG0.saveline"





%, &
%  RTAPE="DIAG0_rmat.tape"


%ENDCOMMENT
% ------------------------------------------------------------------------------
% DASEL (deferred)
%COMMENT







%SAVELINE, NAME="SC_DASEL", FILENAME="LCLS2scDA.saveline"






%, &
%  RTAPE="LCLS2scDA_rmat.tape"




%ENDCOMMENT
% ------------------------------------------------------------------------------
% SURVEY in BSY coordinates (from start of spreader)
% ------------------------------------------------------------------------------
% SXR
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR safety dump
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR XTES
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% BSY dump
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% DASEL (deferred)
%COMMENT









%ENDCOMMENT
% ==============================================================================
% Twiss plots
% 
% 
% % Cathode to BEAM0
% 
% 
% 
% 
% 
% 
% % BEAM0 to SXR Main Dump
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % SXR Safety Dump
% 
% 
% 
% 
% 
% 
% % Spreader to HXR Main Dump
% 
% 
% 
% 
% 
% 
% 
% % Spreader to BSY Dump
% 
% 
% 
% 
% 
% 
% % DIAG0
% 
% 
% 
% 
% % DASEL (deferred)
% 
% 
% 
% 
% 
% 
% 
% 
% 

% ------------------------------------------------------------------------------
%CALL "LCLS2sc_area_plots.mad8"
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% working stuff
% ------------------------------------------------------------------------------
% %match SXRSS chicane to dX= 17.0 mm
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
%SXRSS off




%bend angle (rad) for BL= 2.56 kG-m (9 A) @ 6 GeV




%bend angle (rad) for BL= 2.56 kG-m (9 A) @ 9 GeV





function b=SETK2SCA(b)
for n=find(strcmp('Q10',b(:,2)))',b{n,4}(1)=0.04078118414;end
for n=find(strcmp('Q11',b(:,2)))',b{n,4}(1)=-0.035978491015;end
for n=find(strcmp('Q19',b(:,2)))',b{n,4}(1)=0.0288935235;end
for n=find(strcmp('Q20',b(:,2)))',b{n,4}(1)=0.011673337852;end
for n=find(strcmp('Q27',b(:,2)))',b{n,4}(1)=-0.069796542848;end
for n=find(strcmp('Q28',b(:,2)))',b{n,4}(1)=0.029206357304;end
for n=find(strcmp('Q30',b(:,2)))',b{n,4}(1)=-0.029497355276;end
for n=find(strcmp('Q38',b(:,2)))',b{n,4}(1)=0.034805766493;end

function b=SETK2SCDA(b)
for n=find(strcmp('Q10',b(:,2)))',b{n,4}(1)=0.04034296448;end
for n=find(strcmp('Q11',b(:,2)))',b{n,4}(1)=-0.03865438496;end
for n=find(strcmp('Q19',b(:,2)))',b{n,4}(1)=0.030550055348;end
for n=find(strcmp('Q20',b(:,2)))',b{n,4}(1)=-0.125475886882E-2;end
for n=find(strcmp('Q27',b(:,2)))',b{n,4}(1)=-0.074785603391;end
for n=find(strcmp('Q28',b(:,2)))',b{n,4}(1)=0.041188876983;end
for n=find(strcmp('Q30',b(:,2)))',b{n,4}(1)=-0.029276530035;end
for n=find(strcmp('Q38',b(:,2)))',b{n,4}(1)=0.034027229146;end

function b=SETK2SCXL2(b)
for n=find(strcmp('QEM1B',b(:,2)))',b{n,4}(1)=1.753498810647;end
for n=find(strcmp('QEM2B',b(:,2)))',b{n,4}(1)=-1.89151879979;end
for n=find(strcmp('QEM3B',b(:,2)))',b{n,4}(1)=1.460130886376;end
for n=find(strcmp('QEM4B',b(:,2)))',b{n,4}(1)=-1.003271791653;end
for n=find(strcmp('QE31B',b(:,2)))',b{n,4}(1)=0.259199272111;end
for n=find(strcmp('QE32B',b(:,2)))',b{n,4}(1)=-0.465309355382;end
for n=find(strcmp('QE33B',b(:,2)))',b{n,4}(1)=0.709827895055;end
for n=find(strcmp('QE34B',b(:,2)))',b{n,4}(1)=-0.703993048304;end
for n=find(strcmp('QE35B',b(:,2)))',b{n,4}(1)=0.74174515358;end
for n=find(strcmp('QE36B',b(:,2)))',b{n,4}(1)=-0.26747744113;end
for n=find(strcmp('QUM1B',b(:,2)))',b{n,4}(1)=1.044383140731;end
for n=find(strcmp('QUM2B',b(:,2)))',b{n,4}(1)=-1.128507141132;end
for n=find(strcmp('QUM3B',b(:,2)))',b{n,4}(1)=0.093454443485;end
for n=find(strcmp('QUM4B',b(:,2)))',b{n,4}(1)=0.172049650009;end
for n=find(strcmp('QSX16',b(:,2)))',b{n,4}(1)=1.489214343735;end
for n=find(strcmp('QSX19',b(:,2)))',b{n,4}(1)=-1.599319392703;end
for n=find(strcmp('QSX21',b(:,2)))',b{n,4}(1)=1.728737247522;end
for n=find(strcmp('QSX24',b(:,2)))',b{n,4}(1)=-2.28070315173;end
for n=find(strcmp('QSX47',b(:,2)))',b{n,4}(1)=-1.28484;end
for n=find(strcmp('QUE1B',b(:,2)))',b{n,4}(1)=-0.079627661951;end
for n=find(strcmp('QUE2B',b(:,2)))',b{n,4}(1)=0.323427716703;end
for n=find(strcmp('QDMP1B',b(:,2)))',b{n,4}(1)=-0.155766912296;end
for n=find(strcmp('QDMP2B',b(:,2)))',b{n,4}(1)=-0.155766912296;end

