function beamLine=model_beamLineLCLS2sc()
%
% -----------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-06NOV2025s ***
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
%  beamLine.SC_DASEL = gunB to End Station A
%
% Additional beam lines used for comparison with MAD (starting at BEAM0, at 100 MeV):
%
%  beamLine.SC_DIAG0I = BEAM0 to DIAG0 FARC
%  beamLine.SC_SXRI   = BEAM0 to SXR beam dump
%  beamLine.SC_HXRI   = BEAM0 to HXR beam dump
%  beamLine.SC_BSYDI  = BEAM0 to BSY beam dump
%  beamLine.SC_DASELI = BEAM0 to End Station A
%
% -----------------------------------------------------------------------------
 
% check for mat-file version ... load and return beamLine if found
if (exist('model_beamLineLCLS2sc.mat')==2)
  load model_beamLineLCLS2sc.mat
  return
end

global SETSP SETDA

SETSP = 0;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_EIC=[EIC]';


SETSP = 1;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_SXR=[GUN,L0,LCLS2SCC,LCLS2SCS]';


SETSP = -1;SETDA =  0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_HXR=[GUN,L0,LCLS2SCC,LCLS2SCH]';


SETSP = 0;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_BSYD=[GUN,L0,LCLS2SCC,LCLS2SCD]';


SETSP = 0;SETDA = 1;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DIAG0=[GUN,L0,HTR,DIAG0]';


SETSP = 1;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DASEL=[GUN,L0,LCLS2SCC,LCLS2SCDA]';


SETSP = 1;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_SXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCS]';


SETSP = -1;SETDA =  0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_HXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCH]';


SETSP = 0;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_BSYDI=[LCLS2SCI,LCLS2SCC,LCLS2SCD]';


SETSP = 0;SETDA = 0;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DIAG0I=[LCLS2SCI,HTR,DIAG0]';


SETSP = 1;SETDA = 1;
[DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl();
beamLine.SC_DASELI=[LCLS2SCI,LCLS2SCC,LCLS2SCDA]';



function [DIAG0,EIC,GUN,HTR,L0,LCLS2SCC,LCLS2SCD,LCLS2SCDA,LCLS2SCH,LCLS2SCI,LCLS2SCS]=bl()

global SETSP SETDA


PI     = pi;
TWOPI  = 2*pi;
DEGRAD = 180/pi;
RADDEG = pi/180;
E      = exp(1);
EMASS  = 0.510998902e-3; % electron rest mass [GeV]
PMASS  = 0.938271998;    % proton rest mass [GeV]
CLIGHT = 2.99792458e8;   % speed of light [m/s]

% *** OPTICS=AD_ACCEL-06NOV2025s ***



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
% DASEL  : DASEL kickers to A-line merge
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
% switch definitions
% ------------------------------------------------------------------------------
% deflector switches

SETCUS =  0 ;%deflector switch for HXR/CUSXR

% other switches
SETHXRSS =  0 ;%ON/OFF switch for HXR self-seeding chicane
SETSXRSS =  0 ;%ON/OFF switch for SXR self-seeding chicane
SETPEPX =  0 ;%ON/OFF switch for PEPPEx chicane
SETCBXFEL =  0 ;%ON/OFF switch for CBXFEL chicane(s)
SETXL2WIG =  0 ;%ON/OFF switch for XLEAP-II wiggler
SETXL2SS =  0 ;%ON/OFF switch for XLEAP-II self-seeding chicane
% ------------------------------------------------------------------------------
% integrated gradients for undulator quadrupoles
% ------------------------------------------------------------------------------
INTGSX =  30.0 ;%kG
INTGHX =  30.0 ;%kG
% ------------------------------------------------------------------------------
% element and line definitions
% ------------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-06NOV2025s ***
% ==============================================================================
% Modification History (see also DeckMods.txt ... )
% ------------------------------------------------------------------------------
% 22-JAN-2025, M. Woodley
%  * redefine BEAM0 Twiss per C. Mayes; rematch GUNB Twiss
% ------------------------------------------------------------------------------
% 22-MAR-2024, M. Woodley
%  * rematch Twiss at gun ... SWAVE added to BUN1B
% ------------------------------------------------------------------------------
% 04-OCT-2023, M. Woodley
%  * lower Ei (energy after CM01) to 90 MeV per F. Zhou and Y. Ding
% ------------------------------------------------------------------------------
% 16-JAN-2021, M. Woodley
%  * new standard configuration per Y. Ding
% ------------------------------------------------------------------------------
% ==============================================================================
% constants and global parameters
% ------------------------------------------------------------------------------
% constants
CB=1.0E10/CLIGHT;%kG-m/GeV
MC2=0.51099906E-3;%GeV
QELEC=1.602176462E-19;%C
IN2M=0.0254;%m/inch
FT2M=0.3048;%m/foot
% energy profile
E0 =  MC2+0.750E-3 ;%NGLS/APEX gun energy (GeV) ... 750 kV gun
EI =   0.075       ;%energy at end of L0B (GeV)
E1 =   0.235       ;%BC1 energy (GeV)
E2 =   1.500       ;%BC2 energy (GeV)
EF =   4.000       ;%final beam energy (GeV)
EU =   4.000       ;%energy in undulator (GeV)
EMAX =  10.000       ;%maximum beam energy
BRHO0 =  CB*E0;
BRHOI =  CB*EI;
BRHO1 =  CB*E1;
BRHO2 =  CB*E2;
BRHOF =  CB*EF;
BRHOU =  CB*EU;
% compression
R56HTR =  0.003552 ;%DXmax = 75 cm
R56BC1 =  0.053;
R56BC2 =  0.045;
R56CCDLU =  9.99E-5;
R56CCDLD =  9.99E-5;
% ==============================================================================
% input beam definition: F. Zhou (100 pC)
% ------------------------------------------------------------------------------
% Twiss at gun
BX0 =  52.439198729027;
AX0 =  21.656499467383;
BY0 =  52.371634252331;
AY0 =  21.628730937285;
% Twiss at S= 15.0 m (ASTRA MARKER)
BXA =  13.325594260682;
AXA =  -2.125811087318;
BYA =  13.315541277698;
AYA =  -2.123153832086;
% Twiss at BEAM0 MARKER (from C. Mayes)
BXI =   9.3480;
AXI =  -1.6946;
BYI =   9.3429;
AYI =  -1.6925;
% ------------------------------------------------------------------------------
% beam parameters
QBNCH =  100.0E-12 ;%C
EMITXN =  0.35E-06  ;%m
EMITYN =  0.35E-06  ;%m
SIG_Z =  1.0E-03   ;%m
SIG_DP =  0.03E-02  ;%1
% ==============================================================================
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
% ==============================================================================
% survey (Z values are w.r.t. start of LI01 where Z=0)
% ------------------------------------------------------------------------------
XGUN =     0.28     ;%beam axis (w.r.t. original linac axis)
YGUN =    -0.99     ;%beam axis (w.r.t. original linac axis)
ZGUN =   -10.044667 ;%10.0 m d/s of location of CID gun
Z0BEG =    -7.992090 ;%start of L0 (12.0 m d/s of location of CID gun)
ZI =     3.914190 ;%BEAM0 point (~3.9 m into LI01)
ZA =    ZGUN+15.0 ;%ASTRA treaty point (~5.0 m into LI01)
Z0END =     7.880000 ;%end of L0 (~7.9 m into LI01)
ZHTR =    18.202600 ;%start of laser heater chicane (~18.2 m into LI01)
ZDG0 =    32.183970 ;%start of DIAG0 (~32.2 m into LI01)
Z1BEG =    75.906000 ;%start of L1 (~75.9 m into LI01)
Z1LOC =   104.194330 ;%center of CAVC011 (should be 104.0 m)
Z1END =   119.419000 ;%end of L1 (~17.8 m into LI02)
Z2BEG =   177.047000 ;%start of L2 (~75.4 m into LI02)
Z2END =   329.605000 ;%end of L2 (~24.8 m into LI04)
Z3BEG =   388.210000 ;%start of L3 (~83.4 m into LI04)
Z3END =   641.320000 ;%end of L3 (~31.7 m into LI07)
ZDOG =   664.310000 ;%entrance first dogleg bend, BRB1 (~43.1 m into LI10)
XBYP =    -0.650494 ;%QBP13 X is |Xbyp| to the south of linac axis
YBYP =     0.649478 ;%QBP13 Y is Ybyp above linac axis
ZBYP =  1254.531303 ;%QBP13 centerline (~35.3 m into LI13)
% ==============================================================================
% twiss parameter definitions (for matching, etc.)
% ------------------------------------------------------------------------------
% matched Twiss at start of coasting linac FODOs
% (see CM.xsif for CMfodo1, CMfodo2, and CMfodo3 definitions)
BXCMFODO1 =  47.734300019352 ;%L1: 45 degrees per cell
BYCMFODO1 =  21.362810104773 ;%L1: 45 degrees per cell
BXCMFODO2 =  61.483042301615 ;%L2: 30 degrees per cell
BYCMFODO2 =  36.259471142003 ;%L2: 30 degrees per cell
BXCMFODO3 =  61.483042301615 ;%L3: 30 degrees per cell
BYCMFODO3 =  36.259471142003 ;%L3: 30 degrees per cell
% matched Twiss at SXR LTU emittance diagnostic wire scanners
% (at elements WS31b, WS32b, WS33b, and WS34b)
BXEDS =  46.225914318019;
AXEDS =  -1.084608326468;
BYEDS =  46.225914318017;
AYEDS =   1.084608326468;
% match into HXR LTU emittance diagnostic section (at element WS31)
BXEDH =  46.225914290403;
AXEDH =  -1.084608326581;
BYEDH =  46.225914290403;
AYEDH =   1.084608326581;
% periodic Twiss in HXR dogleg cell (at element MM1)
% (found by setting ALFX=ALFY=0 at centers of HXR dogleg quadrupoles QDL31,32,33 and QT12,22,32)
% (NOTE: this is an inexact match ... see SUBROUTINE MDL2M2 in LCLS2cu_match.mad8)
MBETXH =  48.911502413804;
MALFXH =   3.14173605942 ;
MBETYH =  92.803659360411;
MALFYH =   3.51915855489 ;
% matched (COUPLE) Twiss at entrance to SXR DL2 (MM1B)
MBETXS =   6.841330859756;
MALFXS =  -0.284047412927;
MBETYS =  47.120432408;
MALFYS =   2.555848495121;
% ------------------------------------------------------------------------------
% load lattice definitions
% ------------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc common parameters
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 24-OCT-2022, M. Woodley
%  * define Qg-type quadrupole (3.37Q1.2)
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
% Qg : 3.37Q1.2 (CQ02B replacement "mini-quad")
LQK =  0.7142  ;
RQK =  1.625*IN2M/2 ;%GLmax=   ?   kG @   ? A
LQA =  0.32    ;
RQA =  0.016        ;%GLmax= 112   kG @ 120 A
LQU =  0.084   ;
RQU =  0.0055       ;%GLmax=  41.8 kG @   6 A
LQG =  0.0453  ;
RQG =  3.37*IN2M/2  ;%GLmax=  10    G @   6 A
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
% 1.92K41.2 single beam dumper vertical kicker (SA-380-330-02)
LKIK =  1.0601  ;%kicker coil length per magnet (m)
GKIK =  25.4E-3 ;%kicker half-gap (m)
% ==============================================================================
% kickers and septa
% ------------------------------------------------------------------------------
SETSPS =   1 ;%deflector switch for SXR
SETSPH =  -1 ;%deflector switch for HXR
SETSPD =   0 ;%deflector switch for dump
CUSON =   1 ;%deflector switch ON for pulsed Cu-linac to SXR
CUSONDC =  -1 ;%deflector switch ON for DC Cu-linac to SXR
CUSOFF =   0 ;%deflector switch OFF for Cu-linac to HXR
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
% Note: BRDAS2 is the DC-bend which merges the DASEL beam into the A-line
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
BEGSXTES_1={'mo' 'BEGSXTES_1' 0 []}';
ENDSXTES_1={'mo' 'ENDSXTES_1' 0 []}';
BEGSXTES_2={'mo' 'BEGSXTES_2' 0 []}';
ENDSXTES_2={'mo' 'ENDSXTES_2' 0 []}';
BEGSXTES_3={'mo' 'BEGSXTES_3' 0 []}';
ENDSXTES_3={'mo' 'ENDSXTES_3' 0 []}';
BEGSXTES_4={'mo' 'BEGSXTES_4' 0 []}';
ENDSXTES_4={'mo' 'ENDSXTES_4' 0 []}';
BEGSPA={'mo' 'BEGSPA' 0 []}';
ENDSPA={'mo' 'ENDSPA' 0 []}';
BEGSLTA={'mo' 'BEGSLTA' 0 []}';
ENDSLTA={'mo' 'ENDSLTA' 0 []}';
BEGBSYA={'mo' 'BEGBSYA' 0 []}';
ENDBSYA={'mo' 'ENDBSYA' 0 []}';
BEGESA={'mo' 'BEGESA' 0 []}';
ENDESA={'mo' 'ENDESA' 0 []}';
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
BEGBSYH={'mo' 'BEGBSYH' 0 []}';
ENDBSYH={'mo' 'ENDBSYH' 0 []}';
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
BEGBSYA_2={'mo' 'BEGBSYA_2' 0 []}';
ENDBSYA_2={'mo' 'ENDBSYA_2' 0 []}';
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc linacs: L0, L1, L2 L3
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-NOV-2024, M. Woodley
%  * adjust area boundary locations per vacuum drawing revisions
% ------------------------------------------------------------------------------
% 11-APR-2024, M. Woodley
%  * add SWAVE attribute to 1.3 GHz and 3.9 GHz cavities
% ------------------------------------------------------------------------------
% 29-SEP-2023, M. Woodley
%  * use relocated endpoints of L0B, L1B, L2B, L3B, and L4B, as MSC's and add
%    vacuum valves there per S. Saraf
%  * add VV (INST) at end of EXT ... move ENDEXT to VV
%  * add additional vacuum components (pumps and gauges) per D. White
% ------------------------------------------------------------------------------
% 01-SEP-2022, M. Woodley
%  * add MARKERs at locations of Vertical Transfer Lines (VTL) per S. Kaminski
% ------------------------------------------------------------------------------
% 15-JUL-2022, M. Woodley
%  * rematch around dead QCM34
% 11-MAY-2022, M. Woodley
%  * prepend "cryo " to TYPE attribute for cryomodule quadrupoles per K. Luchini
% ------------------------------------------------------------------------------
% 09-NOV-2021, M. Woodley
%  * set LCAV TYPE attributes to cryomodule designations
%  * set QUAD TYPE attributes to cryomodule magnet package designations
% 20-OCT-2021, M. Woodley
%  * create "_full" definitions for 1.3 GHz and 3.9 GHz cavities to allow Bmad
%    to use field maps (L= 1.3 m for 1.3 GHz; L= 1.3/3 m for 3.9 GHz)
% ------------------------------------------------------------------------------
% 03-MAR-2021, M. Woodley
%  * use cryomodule designations in TYPE definitions for LCAVs, QUADs, XCORs,
%    and YCORs (add as comments to BPMs)
% ------------------------------------------------------------------------------
% 16-JAN-2021, M. Woodley
%  * new standard configuration per Y. Ding
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
FRACL0 =  0.836061812062 ;%Ei=75 MeV
AMPLL1 =  231.0 ;%MV
FRACL1 =  1.047533331879 ;%E1=250 MeV
GRADL1 =  FRACL1*AMPLL1/(2*8*LCAVL) ;%MV/m (2 8-cavity CM's)
PHASL1 =  -24.9 ;%degrees
AHCAV =  60.0 ;%MV
GHCAV =  AHCAV/(2*8*CCAVL) ;%MV/m (2 8-cavity CM's)
PHCAV =  -172.5 ;%degrees
AMPLL2 =  1479.0 ;%MV
FRACL2 =  1.011884846424 ;%E2=1.500 GeV
GRADL2 =  FRACL2*AMPLL2/(12*8*LCAVL) ;%MV/m (12 8-cavity CM's)
PHASL2 =  -32.3 ;%degrees
AMPLL3 =  2500.0 ;%MV
FRACL3 =  1.0 ;%Ef=4.000 GeV
GRADL3 =  FRACL3*AMPLL3/(20*8*LCAVL) ;%MV/m (20 8-cavity CM's)
PHASL3 =  0.0;
%VALUE, 100*(1-FracL1),100*(1-FracL2),100*(1-FracL3)
% Cavity amplitudes (MV)
A011 =   6.5;
A012 =   0.0;
A013 =   9.7;
A014 =   5.0;
A015 =  13.0*FRACL0;
A016 =  16.6*FRACL0;
A017 =  16.6*FRACL0;
A018 =  16.6*FRACL0;
% Cavity phases (deg) ... all on-crest
P011 =  0;
P012 =  0 ;
P013 =  0;
P014 =  0;
P015 =  0;
P016 =  0;
P017 =  0;
P018 =  0;
CAVL011={'ls' 'CAVL011' LCAVL [1300 A011 P011/360*TWOPI]}';
CAVL012={'ls' 'CAVL012' LCAVL [1300 A012 P012/360*TWOPI]}';
CAVL013={'ls' 'CAVL013' LCAVL [1300 A013 P013/360*TWOPI]}';
CAVL014={'ls' 'CAVL014' LCAVL [1300 A014 P014/360*TWOPI]}';
CAVL015A={'ls' 'CAVL015A' LCAVLA [1300 A015*(LCAVLA/LCAVL) P015/360*TWOPI]}';
CAVL015B={'ls' 'CAVL015B' LCAVLB [1300 A015*(LCAVLB/LCAVL) P015/360*TWOPI]}';
CAVL016={'ls' 'CAVL016' LCAVL [1300 A016 P016/360*TWOPI]}';
CAVL017={'ls' 'CAVL017' LCAVL [1300 A017 P017/360*TWOPI]}';
CAVL018={'ls' 'CAVL018' LCAVL [1300 A018 P018/360*TWOPI]}';
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
CAVL021={'ls' 'CAVL021' LCAVL [1300 G021*LCAVL P021/360*TWOPI]}';
CAVL022={'ls' 'CAVL022' LCAVL [1300 G022*LCAVL P022/360*TWOPI]}';
CAVL023={'ls' 'CAVL023' LCAVL [1300 G023*LCAVL P023/360*TWOPI]}';
CAVL024={'ls' 'CAVL024' LCAVL [1300 G024*LCAVL P024/360*TWOPI]}';
CAVL025A={'ls' 'CAVL025A' LCAVLA [1300 G025*LCAVLA P025/360*TWOPI]}';
CAVL025B={'ls' 'CAVL025B' LCAVLB [1300 G025*LCAVLB P025/360*TWOPI]}';
CAVL026={'ls' 'CAVL026' LCAVL [1300 G026*LCAVL P026/360*TWOPI]}';
CAVL027={'ls' 'CAVL027' LCAVL [1300 G027*LCAVL P027/360*TWOPI]}';
CAVL028={'ls' 'CAVL028' LCAVL [1300 G028*LCAVL P028/360*TWOPI]}';
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
CAVL031={'ls' 'CAVL031' LCAVL [1300 G031*LCAVL P031/360*TWOPI]}';
CAVL032={'ls' 'CAVL032' LCAVL [1300 G032*LCAVL P032/360*TWOPI]}';
CAVL033={'ls' 'CAVL033' LCAVL [1300 G033*LCAVL P033/360*TWOPI]}';
CAVL034={'ls' 'CAVL034' LCAVL [1300 G034*LCAVL P034/360*TWOPI]}';
CAVL035A={'ls' 'CAVL035A' LCAVLA [1300 G035*LCAVLA P035/360*TWOPI]}';
CAVL035B={'ls' 'CAVL035B' LCAVLB [1300 G035*LCAVLB P035/360*TWOPI]}';
CAVL036={'ls' 'CAVL036' LCAVL [1300 G036*LCAVL P036/360*TWOPI]}';
CAVL037={'ls' 'CAVL037' LCAVL [1300 G037*LCAVL P037/360*TWOPI]}';
CAVL038={'ls' 'CAVL038' LCAVL [1300 G038*LCAVL P038/360*TWOPI]}';
% 3rd harmonic linearizer
CAVC011={'ls' 'CAVC011' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC012A={'ls' 'CAVC012A' CCAVLA [3900 GHCAV*CCAVLA PHCAV/360*TWOPI]}';
CAVC012B={'ls' 'CAVC012B' CCAVLB [3900 GHCAV*CCAVLB PHCAV/360*TWOPI]}';
CAVC013={'ls' 'CAVC013' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC014={'ls' 'CAVC014' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC015={'ls' 'CAVC015' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC016={'ls' 'CAVC016' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC017={'ls' 'CAVC017' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC018={'ls' 'CAVC018' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC021={'ls' 'CAVC021' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC022A={'ls' 'CAVC022A' CCAVLA [3900 GHCAV*CCAVLA PHCAV/360*TWOPI]}';
CAVC022B={'ls' 'CAVC022B' CCAVLB [3900 GHCAV*CCAVLB PHCAV/360*TWOPI]}';
CAVC023={'ls' 'CAVC023' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC024={'ls' 'CAVC024' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC025={'ls' 'CAVC025' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC026={'ls' 'CAVC026' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC027={'ls' 'CAVC027' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC028={'ls' 'CAVC028' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
% L2
CAVL041={'ls' 'CAVL041' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL042={'ls' 'CAVL042' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL043={'ls' 'CAVL043' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL044={'ls' 'CAVL044' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL045A={'ls' 'CAVL045A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL045B={'ls' 'CAVL045B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL046={'ls' 'CAVL046' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL047={'ls' 'CAVL047' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL048={'ls' 'CAVL048' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL051={'ls' 'CAVL051' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL052={'ls' 'CAVL052' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL053={'ls' 'CAVL053' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL054={'ls' 'CAVL054' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL055A={'ls' 'CAVL055A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL055B={'ls' 'CAVL055B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL056={'ls' 'CAVL056' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL057={'ls' 'CAVL057' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL058={'ls' 'CAVL058' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL061={'ls' 'CAVL061' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL062={'ls' 'CAVL062' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL063={'ls' 'CAVL063' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL064={'ls' 'CAVL064' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL065A={'ls' 'CAVL065A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL065B={'ls' 'CAVL065B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL066={'ls' 'CAVL066' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL067={'ls' 'CAVL067' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL068={'ls' 'CAVL068' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL071={'ls' 'CAVL071' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL072={'ls' 'CAVL072' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL073={'ls' 'CAVL073' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL074={'ls' 'CAVL074' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL075A={'ls' 'CAVL075A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL075B={'ls' 'CAVL075B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL076={'ls' 'CAVL076' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL077={'ls' 'CAVL077' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL078={'ls' 'CAVL078' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL081={'ls' 'CAVL081' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL082={'ls' 'CAVL082' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL083={'ls' 'CAVL083' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL084={'ls' 'CAVL084' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL085A={'ls' 'CAVL085A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL085B={'ls' 'CAVL085B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL086={'ls' 'CAVL086' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL087={'ls' 'CAVL087' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL088={'ls' 'CAVL088' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL091={'ls' 'CAVL091' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL092={'ls' 'CAVL092' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL093={'ls' 'CAVL093' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL094={'ls' 'CAVL094' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL095A={'ls' 'CAVL095A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL095B={'ls' 'CAVL095B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL096={'ls' 'CAVL096' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL097={'ls' 'CAVL097' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL098={'ls' 'CAVL098' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL101={'ls' 'CAVL101' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL102={'ls' 'CAVL102' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL103={'ls' 'CAVL103' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL104={'ls' 'CAVL104' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL105A={'ls' 'CAVL105A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL105B={'ls' 'CAVL105B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL106={'ls' 'CAVL106' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL107={'ls' 'CAVL107' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL108={'ls' 'CAVL108' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL111={'ls' 'CAVL111' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL112={'ls' 'CAVL112' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL113={'ls' 'CAVL113' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL114={'ls' 'CAVL114' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL115A={'ls' 'CAVL115A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL115B={'ls' 'CAVL115B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL116={'ls' 'CAVL116' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL117={'ls' 'CAVL117' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL118={'ls' 'CAVL118' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL121={'ls' 'CAVL121' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL122={'ls' 'CAVL122' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL123={'ls' 'CAVL123' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL124={'ls' 'CAVL124' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL125A={'ls' 'CAVL125A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL125B={'ls' 'CAVL125B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL126={'ls' 'CAVL126' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL127={'ls' 'CAVL127' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL128={'ls' 'CAVL128' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL131={'ls' 'CAVL131' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL132={'ls' 'CAVL132' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL133={'ls' 'CAVL133' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL134={'ls' 'CAVL134' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL135A={'ls' 'CAVL135A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL135B={'ls' 'CAVL135B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL136={'ls' 'CAVL136' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL137={'ls' 'CAVL137' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL138={'ls' 'CAVL138' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL141={'ls' 'CAVL141' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL142={'ls' 'CAVL142' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL143={'ls' 'CAVL143' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL144={'ls' 'CAVL144' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL145A={'ls' 'CAVL145A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL145B={'ls' 'CAVL145B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL146={'ls' 'CAVL146' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL147={'ls' 'CAVL147' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL148={'ls' 'CAVL148' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL151={'ls' 'CAVL151' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL152={'ls' 'CAVL152' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL153={'ls' 'CAVL153' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL154={'ls' 'CAVL154' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL155A={'ls' 'CAVL155A' LCAVLA [1300 GRADL2*LCAVLA PHASL2/360*TWOPI]}';
CAVL155B={'ls' 'CAVL155B' LCAVLB [1300 GRADL2*LCAVLB PHASL2/360*TWOPI]}';
CAVL156={'ls' 'CAVL156' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL157={'ls' 'CAVL157' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL158={'ls' 'CAVL158' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
% L3
CAVL161={'ls' 'CAVL161' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL162={'ls' 'CAVL162' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL163={'ls' 'CAVL163' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL164={'ls' 'CAVL164' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL165A={'ls' 'CAVL165A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL165B={'ls' 'CAVL165B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL166={'ls' 'CAVL166' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL167={'ls' 'CAVL167' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL168={'ls' 'CAVL168' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL171={'ls' 'CAVL171' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL172={'ls' 'CAVL172' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL173={'ls' 'CAVL173' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL174={'ls' 'CAVL174' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL175A={'ls' 'CAVL175A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL175B={'ls' 'CAVL175B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL176={'ls' 'CAVL176' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL177={'ls' 'CAVL177' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL178={'ls' 'CAVL178' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL181={'ls' 'CAVL181' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL182={'ls' 'CAVL182' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL183={'ls' 'CAVL183' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL184={'ls' 'CAVL184' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL185A={'ls' 'CAVL185A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL185B={'ls' 'CAVL185B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL186={'ls' 'CAVL186' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL187={'ls' 'CAVL187' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL188={'ls' 'CAVL188' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL191={'ls' 'CAVL191' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL192={'ls' 'CAVL192' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL193={'ls' 'CAVL193' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL194={'ls' 'CAVL194' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL195A={'ls' 'CAVL195A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL195B={'ls' 'CAVL195B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL196={'ls' 'CAVL196' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL197={'ls' 'CAVL197' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL198={'ls' 'CAVL198' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL201={'ls' 'CAVL201' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL202={'ls' 'CAVL202' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL203={'ls' 'CAVL203' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL204={'ls' 'CAVL204' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL205A={'ls' 'CAVL205A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL205B={'ls' 'CAVL205B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL206={'ls' 'CAVL206' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL207={'ls' 'CAVL207' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL208={'ls' 'CAVL208' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL211={'ls' 'CAVL211' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL212={'ls' 'CAVL212' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL213={'ls' 'CAVL213' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL214={'ls' 'CAVL214' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL215A={'ls' 'CAVL215A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL215B={'ls' 'CAVL215B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL216={'ls' 'CAVL216' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL217={'ls' 'CAVL217' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL218={'ls' 'CAVL218' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL221={'ls' 'CAVL221' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL222={'ls' 'CAVL222' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL223={'ls' 'CAVL223' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL224={'ls' 'CAVL224' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL225A={'ls' 'CAVL225A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL225B={'ls' 'CAVL225B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL226={'ls' 'CAVL226' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL227={'ls' 'CAVL227' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL228={'ls' 'CAVL228' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL231={'ls' 'CAVL231' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL232={'ls' 'CAVL232' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL233={'ls' 'CAVL233' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL234={'ls' 'CAVL234' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL235A={'ls' 'CAVL235A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL235B={'ls' 'CAVL235B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL236={'ls' 'CAVL236' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL237={'ls' 'CAVL237' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL238={'ls' 'CAVL238' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL241={'ls' 'CAVL241' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL242={'ls' 'CAVL242' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL243={'ls' 'CAVL243' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL244={'ls' 'CAVL244' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL245A={'ls' 'CAVL245A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL245B={'ls' 'CAVL245B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL246={'ls' 'CAVL246' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL247={'ls' 'CAVL247' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL248={'ls' 'CAVL248' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL251={'ls' 'CAVL251' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL252={'ls' 'CAVL252' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL253={'ls' 'CAVL253' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL254={'ls' 'CAVL254' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL255A={'ls' 'CAVL255A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL255B={'ls' 'CAVL255B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL256={'ls' 'CAVL256' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL257={'ls' 'CAVL257' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL258={'ls' 'CAVL258' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL261={'ls' 'CAVL261' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL262={'ls' 'CAVL262' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL263={'ls' 'CAVL263' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL264={'ls' 'CAVL264' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL265A={'ls' 'CAVL265A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL265B={'ls' 'CAVL265B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL266={'ls' 'CAVL266' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL267={'ls' 'CAVL267' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL268={'ls' 'CAVL268' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL271={'ls' 'CAVL271' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL272={'ls' 'CAVL272' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL273={'ls' 'CAVL273' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL274={'ls' 'CAVL274' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL275A={'ls' 'CAVL275A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL275B={'ls' 'CAVL275B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL276={'ls' 'CAVL276' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL277={'ls' 'CAVL277' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL278={'ls' 'CAVL278' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL281={'ls' 'CAVL281' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL282={'ls' 'CAVL282' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL283={'ls' 'CAVL283' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL284={'ls' 'CAVL284' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL285A={'ls' 'CAVL285A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL285B={'ls' 'CAVL285B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL286={'ls' 'CAVL286' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL287={'ls' 'CAVL287' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL288={'ls' 'CAVL288' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL291={'ls' 'CAVL291' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL292={'ls' 'CAVL292' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL293={'ls' 'CAVL293' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL294={'ls' 'CAVL294' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL295A={'ls' 'CAVL295A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL295B={'ls' 'CAVL295B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL296={'ls' 'CAVL296' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL297={'ls' 'CAVL297' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL298={'ls' 'CAVL298' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL301={'ls' 'CAVL301' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL302={'ls' 'CAVL302' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL303={'ls' 'CAVL303' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL304={'ls' 'CAVL304' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL305A={'ls' 'CAVL305A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL305B={'ls' 'CAVL305B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL306={'ls' 'CAVL306' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL307={'ls' 'CAVL307' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL308={'ls' 'CAVL308' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL311={'ls' 'CAVL311' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL312={'ls' 'CAVL312' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL313={'ls' 'CAVL313' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL314={'ls' 'CAVL314' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL315A={'ls' 'CAVL315A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL315B={'ls' 'CAVL315B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL316={'ls' 'CAVL316' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL317={'ls' 'CAVL317' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL318={'ls' 'CAVL318' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL321={'ls' 'CAVL321' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL322={'ls' 'CAVL322' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL323={'ls' 'CAVL323' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL324={'ls' 'CAVL324' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL325A={'ls' 'CAVL325A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL325B={'ls' 'CAVL325B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL326={'ls' 'CAVL326' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL327={'ls' 'CAVL327' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL328={'ls' 'CAVL328' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL331={'ls' 'CAVL331' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL332={'ls' 'CAVL332' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL333={'ls' 'CAVL333' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL334={'ls' 'CAVL334' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL335A={'ls' 'CAVL335A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL335B={'ls' 'CAVL335B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL336={'ls' 'CAVL336' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL337={'ls' 'CAVL337' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL338={'ls' 'CAVL338' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL341={'ls' 'CAVL341' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL342={'ls' 'CAVL342' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL343={'ls' 'CAVL343' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL344={'ls' 'CAVL344' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL345A={'ls' 'CAVL345A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL345B={'ls' 'CAVL345B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL346={'ls' 'CAVL346' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL347={'ls' 'CAVL347' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL348={'ls' 'CAVL348' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL351={'ls' 'CAVL351' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL352={'ls' 'CAVL352' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL353={'ls' 'CAVL353' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL354={'ls' 'CAVL354' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL355A={'ls' 'CAVL355A' LCAVLA [1300 GRADL3*LCAVLA PHASL3/360*TWOPI]}';
CAVL355B={'ls' 'CAVL355B' LCAVLB [1300 GRADL3*LCAVLB PHASL3/360*TWOPI]}';
CAVL356={'ls' 'CAVL356' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL357={'ls' 'CAVL357' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL358={'ls' 'CAVL358' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
% define unsplit LCAVs for BMAD ... not used by MAD
CAVL015={'ls' 'CAVL015' LCAVL [1300 A015 P015/360*TWOPI]}';
CAVL025={'ls' 'CAVL025' LCAVL [1300 G025*LCAVL P025/360*TWOPI]}';
CAVL035={'ls' 'CAVL035' LCAVL [1300 G035*LCAVL P035/360*TWOPI]}';
CAVC012={'ls' 'CAVC012' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVC022={'ls' 'CAVC022' CCAVL [3900 GHCAV*CCAVL PHCAV/360*TWOPI]}';
CAVL045={'ls' 'CAVL045' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL055={'ls' 'CAVL055' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL065={'ls' 'CAVL065' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL075={'ls' 'CAVL075' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL085={'ls' 'CAVL085' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL095={'ls' 'CAVL095' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL105={'ls' 'CAVL105' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL115={'ls' 'CAVL115' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL125={'ls' 'CAVL125' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL135={'ls' 'CAVL135' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL145={'ls' 'CAVL145' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL155={'ls' 'CAVL155' LCAVL [1300 GRADL2*LCAVL PHASL2/360*TWOPI]}';
CAVL165={'ls' 'CAVL165' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL175={'ls' 'CAVL175' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL185={'ls' 'CAVL185' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL195={'ls' 'CAVL195' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL205={'ls' 'CAVL205' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL215={'ls' 'CAVL215' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL225={'ls' 'CAVL225' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL235={'ls' 'CAVL235' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL245={'ls' 'CAVL245' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL255={'ls' 'CAVL255' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL265={'ls' 'CAVL265' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL275={'ls' 'CAVL275' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL285={'ls' 'CAVL285' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL295={'ls' 'CAVL295' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL305={'ls' 'CAVL305' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL315={'ls' 'CAVL315' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL325={'ls' 'CAVL325' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL335={'ls' 'CAVL335' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL345={'ls' 'CAVL345' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
CAVL355={'ls' 'CAVL355' LCAVL [1300 GRADL3*LCAVL PHASL3/360*TWOPI]}';
% ==============================================================================
% QUAD
% ------------------------------------------------------------------------------
LCMQ =  0.23     ;%cryomodule quadrupole length
RCMQ =  0.0762/2 ;%cryomodule quadrupole pole-tip radius
KQCMFODO1 =  0.274030631043 ;%L1: 45 degrees/cell
KQCMFODO2 =  0.185334132537 ;%L2: 30 degrees/cell
KQCMFODO3 =  0.185334132537 ;%L3: 30 degrees/cell
% L0
KQCM01 =  0;
QCM01={'qu' 'QCM01' LCMQ/2 [KQCM01 0]}';
% L1
QCM02={'qu' 'QCM02' LCMQ/2 [-0.217944649921 0]}';%-KQCMfodo1
QCM03={'qu' 'QCM03' LCMQ/2 [0.110942693737 0]}';% KQCMfodo1
% L2
QCM04={'qu' 'QCM04' LCMQ/2 [-0.326994275917 0]}';%-KQCMfodo2
QCM05={'qu' 'QCM05' LCMQ/2 [0.289428219886 0]}';% KQCMfodo2
QCM06={'qu' 'QCM06' LCMQ/2 [-0.189155354368 0]}';%-KQCMfodo2
QCM07={'qu' 'QCM07' LCMQ/2 [0.17118229764 0]}';% KQCMfodo2
QCM08={'qu' 'QCM08' LCMQ/2 [-0.167624498336 0]}';%-KQCMfodo2
QCM09={'qu' 'QCM09' LCMQ/2 [0.16898372787 0]}';% KQCMfodo2
QCM10={'qu' 'QCM10' LCMQ/2 [-0.16902001806 0]}';%-KQCMfodo2
QCM11={'qu' 'QCM11' LCMQ/2 [0.171135436608 0]}';% KQCMfodo2
QCM12={'qu' 'QCM12' LCMQ/2 [-0.179258980332 0]}';%-KQCMfodo2
QCM13={'qu' 'QCM13' LCMQ/2 [0.062955743583 0]}';% KQCMfodo2
QCM14={'qu' 'QCM14' LCMQ/2 [-0.176070484188 0]}';%-KQCMfodo2
QCM15={'qu' 'QCM15' LCMQ/2 [0.065519019875 0]}';% KQCMfodo2
% L3
QCM16={'qu' 'QCM16' LCMQ/2 [-0.371724722438 0]}';%-KQCMfodo3
QCM17={'qu' 'QCM17' LCMQ/2 [0.398004484966 0]}';% KQCMfodo3
QCM18={'qu' 'QCM18' LCMQ/2 [-0.249034603119 0]}';%-KQCMfodo3
QCM19={'qu' 'QCM19' LCMQ/2 [0.206631598014 0]}';% KQCMfodo3
QCM20={'qu' 'QCM20' LCMQ/2 [-0.190569322695 0]}';%-KQCMfodo3
QCM21={'qu' 'QCM21' LCMQ/2 [KQCMFODO3 0]}';
QCM22={'qu' 'QCM22' LCMQ/2 [-KQCMFODO3 0]}';
QCM23={'qu' 'QCM23' LCMQ/2 [KQCMFODO3 0]}';
QCM24={'qu' 'QCM24' LCMQ/2 [-0.19041403742 0]}';%-KQCMfodo3
QCM25={'qu' 'QCM25' LCMQ/2 [0.181297138778 0]}';% KQCMfodo3
QCM26={'qu' 'QCM26' LCMQ/2 [-0.180472277353 0]}';%-KQCMfodo3
QCM27={'qu' 'QCM27' LCMQ/2 [0.189426259433 0]}';% KQCMfodo3
QCM28={'qu' 'QCM28' LCMQ/2 [-KQCMFODO3 0]}';
QCM29={'qu' 'QCM29' LCMQ/2 [0.187338995668 0]}';% KQCMfodo3
QCM30={'qu' 'QCM30' LCMQ/2 [-0.193071006572 0]}';%-KQCMfodo3
QCM31={'qu' 'QCM31' LCMQ/2 [0.206570202429 0]}';% KQCMfodo3
QCM32={'qu' 'QCM32' LCMQ/2 [-0.243506227866 0]}';%-KQCMfodo3
QCM33={'qu' 'QCM33' LCMQ/2 [0.218845503379 0]}';% KQCMfodo3
QCM34={'qu' 'QCM34' LCMQ/2 [0.0 0]}';%-KQCMfodo3
QCM35={'qu' 'QCM35' LCMQ/2 [-0.255072220378 0]}';% KQCMfodo3
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
% for Bmad field maps (1.3 GHz field map length is 1.3 m per C. Mayes)
LCAVMAP =  (1.3-LCAVL)/2 ;%m
% cryomodule drifts
DCAVMAP={'dr' '' LCAVMAP []}';
DCM1={'dr' '' LGV2CAV-(LCAVMAP+LCAVL/2) []}';
DCM2={'dr' '' LCAV2CAV-(LCAVMAP+LCAVL+LCAVMAP) []}';
DCM3={'dr' '' LCAV2BPM-(LCAVL/2+LCAVMAP) []}';
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
% for Bmad field maps (3.9 GHz field map length is 0.44 m per C. Mayes)
LHCAVMAP =  (0.44-CCAVL)/2 ;%m 
% cryomodule drifts
DHCAVMAP={'dr' '' LHCAVMAP []}';
DCMH0={'dr' '' 1.14662-(LHCAVMAP+CCAVL/2) []}';
DCMH1={'dr' '' LGV2HCAV-(LHCAVMAP+CCAVL/2) []}';
DCMH2={'dr' '' LHCAV2HCAV-(LHCAVMAP+CCAVL+LHCAVMAP) []}';
DCMH3={'dr' '' LHCAV2BPM-(CCAVL/2+LHCAVMAP) []}';
DCMH4={'dr' '' LHBPM2GV []}';
DCMHCMH1={'dr' '' LHGV2HHOM []}';
DCMHCMH2={'dr' '' LHHOM2HGV []}';
% ------------------------------------------------------------------------------
% end caps, stay-clears, and L3 vacuum break
% ------------------------------------------------------------------------------
% use new endpoints of L0B, L1B, L2B, L3B, and EXT, as MSC's; add vacuum valves
% there per S. Saraf (dZ's are relative to 13MAR23 locations)
%dZMSC0d  = -0.250200 relocate MSC0d  (ENDL0B/BEGHTR_1)
%dZMSC1u  = -0.000590 relocate MSC1u  (ENDCOL0/BEGL1B)
%dZMSC1d  = -0.013570 relocate MSC1d  (ENDL1B/BEGBC1B)
%dZMSC2u  =  0.022998 relocate MSC2u  (ENDCOL1/BEGL2B
%dZMSC2d  = -0.039882 relocate MSC2d  (ENDL2B/BEGBC2B)
%dZMSC3u  =  0.039750 relocate MSC3u  (ENDEMIT2/BEGL3B)
%dZMSC3d  =  0.322740 relocate MSC3d  (ENDL3B/BEGEXT)
%dZENDEXT = -0.233300 relocate ENDEXT (ENDEXT/BEGDOG)
% end cap and feed cap dimensions, mechanical stay-clear, and differential
% vacuum pumping stay-clear (mostly from drawing SD-375-000-99-02)
DCAP0U={'dr' '' 0.49294 []}';%EC1 to CSP01   =  6.965000
DCAP0D={'dr' '' 1.89015 []}';%CSP01 to FC1   =  7.328290
DMSC0D={'dr' '' 1.5788 []}';%CSP01 to MSC0d =  8.907090
DMSC1U={'dr' '' 1.82959 []}';%MSC1u to CSP02 =  9.174590
DCAP1U={'dr' '' 0.87294 []}';%FC2 to CSP02   =  7.345000
DCAP1D={'dr' '' 1.75429 []}';%CSPH2 to FC3   =  6.333200
DMSC1D={'dr' '' 1.81543 []}';%CSPH2 to MSC1d =  8.148630
DMSC2U={'dr' '' 1.806002 []}';%MSC2u to CSP04 =  9.151002
DCAP2U={'dr' '' 0.87294 []}';%FC4 to CSP04   =  7.345000
DCAP2D={'dr' '' 1.58968 []}';%CSP15 to FC5   =  7.193590
DMSC2D={'dr' '' 1.789118 []}';%CSP15 to MSC2d =  8.982708
DMSC3U={'dr' '' 1.78725 []}';%MSC3u to CSP16 =  9.132250
DCAP3U={'dr' '' 0.87294 []}';%FC6 to CSP16   =  7.345000
DCAP3D={'dr' '' 1.72438 []}';%CSP35 to EC2   =  7.328290
DMSC3D={'dr' '' 1.91074 []}';%CSP35 to MSC3d =  9.239030
% standard vacuum break
DBREAK={'dr' '' 2.54931 []}';
% beamline flanges
LBLF =  0.0889 ;%beamline flange to cap face (m)
DMSC1UB={'dr' '' LBLF []}';
DMSC1UA={'dr' '' DMSC1U{3}-DMSC1UB{3} []}';
DMSC1DA={'dr' '' LBLF []}';
DMSC1DB={'dr' '' DMSC1D{3}-DMSC1DA{3} []}';
DMSC2UB={'dr' '' LBLF []}';
DMSC2UA={'dr' '' DMSC2U{3}-DMSC2UB{3} []}';
DMSC2DA={'dr' '' LBLF []}';
DMSC2DB={'dr' '' 0.764218 []}';
DMSC2DC={'dr' '' DMSC2D{3}-DMSC2DA{3}-DMSC2DB{3} []}';
DMSC3UA={'dr' '' 0.929 []}';
DMSC3UC={'dr' '' LBLF []}';
DMSC3UB={'dr' '' DMSC3U{3}-DMSC3UA{3}-DMSC3UC{3} []}';
DMSC3DA={'dr' '' LBLF []}';
DMSC3DB={'dr' '' 1.39184 []}';%1.25884
DMSC3DC={'dr' '' DMSC3D{3}-DMSC3DA{3}-DMSC3DB{3} []}';
% split L0 downstream endcap drift for ASTRA treaty point (15 m from cathode)
LASTRA =  0.378513;
DCAP0DA={'dr' '' LASTRA []}';
DCAP0DB={'dr' '' DCAP0D{3}-DCMCM1{3}-DCAP0DA{3} []}';
% vacuum components after L0 endcap
DMSC0DA={'dr' '' LBLF []}';
DMSC0DB={'dr' '' 1.231893 []}';
DMSC0DC={'dr' '' 0.1016 []}';
DMSC0DD={'dr' '' DMSC0D{3}-DMSC0DA{3}-DMSC0DB{3}-DMSC0DC{3} []}';
% miscellaneous definitions
LCRYOL =  DCM1{3}+8*(LCAVMAP+LCAVL+LCAVMAP)+7*DCM2{3}+DCM3{3}+DCM4{3}+LCMQ+DCM5{3};
LCRYOC =  DCMH1{3}+8*(LHCAVMAP+CCAVL+LHCAVMAP)+7*DCMH2{3}+DCMH3{3}+DCMH4{3};
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
RFB2C00={'dr' '' 0 []}';
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
% cryomodule higher-order mode absorbers
HOMCM01={'mo' 'HOMCM01' 0 []}';
HOMCM02={'mo' 'HOMCM02' 0 []}';
HOMCM03={'mo' 'HOMCM03' 0 []}';
HOMCMH1={'mo' 'HOMCMH1' 0 []}';
HOMCM04={'mo' 'HOMCM04' 0 []}';
HOMCM05={'mo' 'HOMCM05' 0 []}';
HOMCM06={'mo' 'HOMCM06' 0 []}';
HOMCM07={'mo' 'HOMCM07' 0 []}';
HOMCM08={'mo' 'HOMCM08' 0 []}';
HOMCM09={'mo' 'HOMCM09' 0 []}';
HOMCM10={'mo' 'HOMCM10' 0 []}';
HOMCM11={'mo' 'HOMCM11' 0 []}';
HOMCM12={'mo' 'HOMCM12' 0 []}';
HOMCM13={'mo' 'HOMCM13' 0 []}';
HOMCM14={'mo' 'HOMCM14' 0 []}';
HOMCM15={'mo' 'HOMCM15' 0 []}';
HOMCM16={'mo' 'HOMCM16' 0 []}';
HOMCM17={'mo' 'HOMCM17' 0 []}';
HOMCM18={'mo' 'HOMCM18' 0 []}';
HOMCM19={'mo' 'HOMCM19' 0 []}';
HOMCM20={'mo' 'HOMCM20' 0 []}';
HOMCM21={'mo' 'HOMCM21' 0 []}';
HOMCM22={'mo' 'HOMCM22' 0 []}';
HOMCM23={'mo' 'HOMCM23' 0 []}';
HOMCM24={'mo' 'HOMCM24' 0 []}';
HOMCM25={'mo' 'HOMCM25' 0 []}';
HOMCM26={'mo' 'HOMCM26' 0 []}';
HOMCM27={'mo' 'HOMCM27' 0 []}';
HOMCM28={'mo' 'HOMCM28' 0 []}';
HOMCM29={'mo' 'HOMCM29' 0 []}';
HOMCM30={'mo' 'HOMCM30' 0 []}';
HOMCM31={'mo' 'HOMCM31' 0 []}';
HOMCM32={'mo' 'HOMCM32' 0 []}';
HOMCM33={'mo' 'HOMCM33' 0 []}';
HOMCM34={'mo' 'HOMCM34' 0 []}';
HOMCM35={'mo' 'HOMCM35' 0 []}';
BEAM0={'mo' 'BEAM0' 0 []}';%initial beam specified here
ASTRA={'mo' 'ASTRA' 0 []}';%simulated Twiss from C. Papadopoulos here
EC1={'mo' 'EC1' 0 []}';%u/s flange face
FC1={'mo' 'FC1' 0 []}';%d/s flange face
BLF1={'mo' 'BLF1' 0 []}';%beamline flange
VGL0BD={'mo' 'VGL0BD' 0 []}';
VPL0BD={'mo' 'VPL0BD' 0 []}';
MSC0D={'mo' 'MSC0D' 0 []}';%u/s flange face
VVL0BD={'mo' 'VVL0BD' 0 []}';%VVPG:L0B:0199
VVL1BU={'mo' 'VVL1BU' 0 []}';%VVPG:L1B:0201
MSC1U={'mo' 'MSC1U' 0 []}';%u/s flange face
BLF2={'mo' 'BLF2' 0 []}';%beamline flange
FC2={'mo' 'FC2' 0 []}';%u/s flange face
FC3={'mo' 'FC3' 0 []}';%d/s flange face
BLF3={'mo' 'BLF3' 0 []}';%beamline flange
MSC1D={'mo' 'MSC1D' 0 []}';%d/s flange face
VVL1BD={'mo' 'VVL1BD' 0 []}';%VVPG:L1B:H295
VVL2BU={'mo' 'VVL2BU' 0 []}';%VVPG:L2B:0401
MSC2U={'mo' 'MSC2U' 0 []}';%u/s flange face
BLF4={'mo' 'BLF4' 0 []}';%beamline flange
FC4={'mo' 'FC4' 0 []}';%u/s flange face
FC5={'mo' 'FC5' 0 []}';%d/s flange face
BLF5={'mo' 'BLF5' 0 []}';%beamline flange
VTL1={'mo' 'VTL1' 0 []}';%Vertical Transfer Line
MSC2D={'mo' 'MSC2D' 0 []}';%d/s flange face
VVL2BD={'mo' 'VVL2BD' 0 []}';%VVPG:L2B:1593
VVL3BU={'mo' 'VVL3BU' 0 []}';%VVPG:L3B:1601
MSC3U={'mo' 'MSC3U' 0 []}';%u/s flange face
VTL2={'mo' 'VTL2' 0 []}';%Vertical Transfer Line
BLF6={'mo' 'BLF6' 0 []}';%beamline flange
FC6={'mo' 'FC6' 0 []}';%u/s flange face
EC2={'mo' 'EC2' 0 []}';%d/s flange face
BLF7={'mo' 'BLF7' 0 []}';%beamline flange
VGL3BD={'mo' 'VGL3BD' 0 []}';
MSC3D={'mo' 'MSC3D' 0 []}';%d/s flange face
VVL3BD={'mo' 'VVL3BD' 0 []}';%VVPG:L3B:3594
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
% L0
CAVL011_FULL=[DCAVMAP,CAVL011,DCAVMAP];
CAVL012_FULL=[DCAVMAP,CAVL012,DCAVMAP];
CAVL013_FULL=[DCAVMAP,CAVL013,DCAVMAP];
CAVL014_FULL=[DCAVMAP,CAVL014,DCAVMAP];
CAVL015_FULL=[DCAVMAP,CAVL015A,CSP01,CAVL015B,DCAVMAP];
CAVL016_FULL=[DCAVMAP,CAVL016,DCAVMAP];
CAVL017_FULL=[DCAVMAP,CAVL017,DCAVMAP];
CAVL018_FULL=[DCAVMAP,CAVL018,DCAVMAP];
% L1
CAVL021_FULL=[DCAVMAP,CAVL021,DCAVMAP];
CAVL022_FULL=[DCAVMAP,CAVL022,DCAVMAP];
CAVL023_FULL=[DCAVMAP,CAVL023,DCAVMAP];
CAVL024_FULL=[DCAVMAP,CAVL024,DCAVMAP];
CAVL025_FULL=[DCAVMAP,CAVL025A,CSP02,CAVL025B,DCAVMAP];
CAVL026_FULL=[DCAVMAP,CAVL026,DCAVMAP];
CAVL027_FULL=[DCAVMAP,CAVL027,DCAVMAP];
CAVL028_FULL=[DCAVMAP,CAVL028,DCAVMAP];
CAVL031_FULL=[DCAVMAP,CAVL031,DCAVMAP];
CAVL032_FULL=[DCAVMAP,CAVL032,DCAVMAP];
CAVL033_FULL=[DCAVMAP,CAVL033,DCAVMAP];
CAVL034_FULL=[DCAVMAP,CAVL034,DCAVMAP];
CAVL035_FULL=[DCAVMAP,CAVL035A,CSP03,CAVL035B,DCAVMAP];
CAVL036_FULL=[DCAVMAP,CAVL036,DCAVMAP];
CAVL037_FULL=[DCAVMAP,CAVL037,DCAVMAP];
CAVL038_FULL=[DCAVMAP,CAVL038,DCAVMAP];
CAVC011_FULL=[DHCAVMAP,CAVC011,DHCAVMAP];
CAVC012_FULL=[DHCAVMAP,CAVC012A,CSPH1,CAVC012B,DHCAVMAP];
CAVC013_FULL=[DHCAVMAP,CAVC013,DHCAVMAP];
CAVC014_FULL=[DHCAVMAP,CAVC014,DHCAVMAP];
CAVC015_FULL=[DHCAVMAP,CAVC015,DHCAVMAP];
CAVC016_FULL=[DHCAVMAP,CAVC016,DHCAVMAP];
CAVC017_FULL=[DHCAVMAP,CAVC017,DHCAVMAP];
CAVC018_FULL=[DHCAVMAP,CAVC018,DHCAVMAP];
CAVC021_FULL=[DHCAVMAP,CAVC021,DHCAVMAP];
CAVC022_FULL=[DHCAVMAP,CAVC022A,CSPH2,CAVC022B,DHCAVMAP];
CAVC023_FULL=[DHCAVMAP,CAVC023,DHCAVMAP];
CAVC024_FULL=[DHCAVMAP,CAVC024,DHCAVMAP];
CAVC025_FULL=[DHCAVMAP,CAVC025,DHCAVMAP];
CAVC026_FULL=[DHCAVMAP,CAVC026,DHCAVMAP];
CAVC027_FULL=[DHCAVMAP,CAVC027,DHCAVMAP];
CAVC028_FULL=[DHCAVMAP,CAVC028,DHCAVMAP];
% L2
CAVL041_FULL=[DCAVMAP,CAVL041,DCAVMAP];
CAVL042_FULL=[DCAVMAP,CAVL042,DCAVMAP];
CAVL043_FULL=[DCAVMAP,CAVL043,DCAVMAP];
CAVL044_FULL=[DCAVMAP,CAVL044,DCAVMAP];
CAVL045_FULL=[DCAVMAP,CAVL045A,CSP04,CAVL045B,DCAVMAP];
CAVL046_FULL=[DCAVMAP,CAVL046,DCAVMAP];
CAVL047_FULL=[DCAVMAP,CAVL047,DCAVMAP];
CAVL048_FULL=[DCAVMAP,CAVL048,DCAVMAP];
CAVL051_FULL=[DCAVMAP,CAVL051,DCAVMAP];
CAVL052_FULL=[DCAVMAP,CAVL052,DCAVMAP];
CAVL053_FULL=[DCAVMAP,CAVL053,DCAVMAP];
CAVL054_FULL=[DCAVMAP,CAVL054,DCAVMAP];
CAVL055_FULL=[DCAVMAP,CAVL055A,CSP05,CAVL055B,DCAVMAP];
CAVL056_FULL=[DCAVMAP,CAVL056,DCAVMAP];
CAVL057_FULL=[DCAVMAP,CAVL057,DCAVMAP];
CAVL058_FULL=[DCAVMAP,CAVL058,DCAVMAP];
CAVL061_FULL=[DCAVMAP,CAVL061,DCAVMAP];
CAVL062_FULL=[DCAVMAP,CAVL062,DCAVMAP];
CAVL063_FULL=[DCAVMAP,CAVL063,DCAVMAP];
CAVL064_FULL=[DCAVMAP,CAVL064,DCAVMAP];
CAVL065_FULL=[DCAVMAP,CAVL065A,CSP06,CAVL065B,DCAVMAP];
CAVL066_FULL=[DCAVMAP,CAVL066,DCAVMAP];
CAVL067_FULL=[DCAVMAP,CAVL067,DCAVMAP];
CAVL068_FULL=[DCAVMAP,CAVL068,DCAVMAP];
CAVL071_FULL=[DCAVMAP,CAVL071,DCAVMAP];
CAVL072_FULL=[DCAVMAP,CAVL072,DCAVMAP];
CAVL073_FULL=[DCAVMAP,CAVL073,DCAVMAP];
CAVL074_FULL=[DCAVMAP,CAVL074,DCAVMAP];
CAVL075_FULL=[DCAVMAP,CAVL075A,CSP07,CAVL075B,DCAVMAP];
CAVL076_FULL=[DCAVMAP,CAVL076,DCAVMAP];
CAVL077_FULL=[DCAVMAP,CAVL077,DCAVMAP];
CAVL078_FULL=[DCAVMAP,CAVL078,DCAVMAP];
CAVL081_FULL=[DCAVMAP,CAVL081,DCAVMAP];
CAVL082_FULL=[DCAVMAP,CAVL082,DCAVMAP];
CAVL083_FULL=[DCAVMAP,CAVL083,DCAVMAP];
CAVL084_FULL=[DCAVMAP,CAVL084,DCAVMAP];
CAVL085_FULL=[DCAVMAP,CAVL085A,CSP08,CAVL085B,DCAVMAP];
CAVL086_FULL=[DCAVMAP,CAVL086,DCAVMAP];
CAVL087_FULL=[DCAVMAP,CAVL087,DCAVMAP];
CAVL088_FULL=[DCAVMAP,CAVL088,DCAVMAP];
CAVL091_FULL=[DCAVMAP,CAVL091,DCAVMAP];
CAVL092_FULL=[DCAVMAP,CAVL092,DCAVMAP];
CAVL093_FULL=[DCAVMAP,CAVL093,DCAVMAP];
CAVL094_FULL=[DCAVMAP,CAVL094,DCAVMAP];
CAVL095_FULL=[DCAVMAP,CAVL095A,CSP09,CAVL095B,DCAVMAP];
CAVL096_FULL=[DCAVMAP,CAVL096,DCAVMAP];
CAVL097_FULL=[DCAVMAP,CAVL097,DCAVMAP];
CAVL098_FULL=[DCAVMAP,CAVL098,DCAVMAP];
CAVL101_FULL=[DCAVMAP,CAVL101,DCAVMAP];
CAVL102_FULL=[DCAVMAP,CAVL102,DCAVMAP];
CAVL103_FULL=[DCAVMAP,CAVL103,DCAVMAP];
CAVL104_FULL=[DCAVMAP,CAVL104,DCAVMAP];
CAVL105_FULL=[DCAVMAP,CAVL105A,CSP10,CAVL105B,DCAVMAP];
CAVL106_FULL=[DCAVMAP,CAVL106,DCAVMAP];
CAVL107_FULL=[DCAVMAP,CAVL107,DCAVMAP];
CAVL108_FULL=[DCAVMAP,CAVL108,DCAVMAP];
CAVL111_FULL=[DCAVMAP,CAVL111,DCAVMAP];
CAVL112_FULL=[DCAVMAP,CAVL112,DCAVMAP];
CAVL113_FULL=[DCAVMAP,CAVL113,DCAVMAP];
CAVL114_FULL=[DCAVMAP,CAVL114,DCAVMAP];
CAVL115_FULL=[DCAVMAP,CAVL115A,CSP11,CAVL115B,DCAVMAP];
CAVL116_FULL=[DCAVMAP,CAVL116,DCAVMAP];
CAVL117_FULL=[DCAVMAP,CAVL117,DCAVMAP];
CAVL118_FULL=[DCAVMAP,CAVL118,DCAVMAP];
CAVL121_FULL=[DCAVMAP,CAVL121,DCAVMAP];
CAVL122_FULL=[DCAVMAP,CAVL122,DCAVMAP];
CAVL123_FULL=[DCAVMAP,CAVL123,DCAVMAP];
CAVL124_FULL=[DCAVMAP,CAVL124,DCAVMAP];
CAVL125_FULL=[DCAVMAP,CAVL125A,CSP12,CAVL125B,DCAVMAP];
CAVL126_FULL=[DCAVMAP,CAVL126,DCAVMAP];
CAVL127_FULL=[DCAVMAP,CAVL127,DCAVMAP];
CAVL128_FULL=[DCAVMAP,CAVL128,DCAVMAP];
CAVL131_FULL=[DCAVMAP,CAVL131,DCAVMAP];
CAVL132_FULL=[DCAVMAP,CAVL132,DCAVMAP];
CAVL133_FULL=[DCAVMAP,CAVL133,DCAVMAP];
CAVL134_FULL=[DCAVMAP,CAVL134,DCAVMAP];
CAVL135_FULL=[DCAVMAP,CAVL135A,CSP13,CAVL135B,DCAVMAP];
CAVL136_FULL=[DCAVMAP,CAVL136,DCAVMAP];
CAVL137_FULL=[DCAVMAP,CAVL137,DCAVMAP];
CAVL138_FULL=[DCAVMAP,CAVL138,DCAVMAP];
CAVL141_FULL=[DCAVMAP,CAVL141,DCAVMAP];
CAVL142_FULL=[DCAVMAP,CAVL142,DCAVMAP];
CAVL143_FULL=[DCAVMAP,CAVL143,DCAVMAP];
CAVL144_FULL=[DCAVMAP,CAVL144,DCAVMAP];
CAVL145_FULL=[DCAVMAP,CAVL145A,CSP14,CAVL145B,DCAVMAP];
CAVL146_FULL=[DCAVMAP,CAVL146,DCAVMAP];
CAVL147_FULL=[DCAVMAP,CAVL147,DCAVMAP];
CAVL148_FULL=[DCAVMAP,CAVL148,DCAVMAP];
CAVL151_FULL=[DCAVMAP,CAVL151,DCAVMAP];
CAVL152_FULL=[DCAVMAP,CAVL152,DCAVMAP];
CAVL153_FULL=[DCAVMAP,CAVL153,DCAVMAP];
CAVL154_FULL=[DCAVMAP,CAVL154,DCAVMAP];
CAVL155_FULL=[DCAVMAP,CAVL155A,CSP15,CAVL155B,DCAVMAP];
CAVL156_FULL=[DCAVMAP,CAVL156,DCAVMAP];
CAVL157_FULL=[DCAVMAP,CAVL157,DCAVMAP];
CAVL158_FULL=[DCAVMAP,CAVL158,DCAVMAP];
% L3
CAVL161_FULL=[DCAVMAP,CAVL161,DCAVMAP];
CAVL162_FULL=[DCAVMAP,CAVL162,DCAVMAP];
CAVL163_FULL=[DCAVMAP,CAVL163,DCAVMAP];
CAVL164_FULL=[DCAVMAP,CAVL164,DCAVMAP];
CAVL165_FULL=[DCAVMAP,CAVL165A,CSP16,CAVL165B,DCAVMAP];
CAVL166_FULL=[DCAVMAP,CAVL166,DCAVMAP];
CAVL167_FULL=[DCAVMAP,CAVL167,DCAVMAP];
CAVL168_FULL=[DCAVMAP,CAVL168,DCAVMAP];
CAVL171_FULL=[DCAVMAP,CAVL171,DCAVMAP];
CAVL172_FULL=[DCAVMAP,CAVL172,DCAVMAP];
CAVL173_FULL=[DCAVMAP,CAVL173,DCAVMAP];
CAVL174_FULL=[DCAVMAP,CAVL174,DCAVMAP];
CAVL175_FULL=[DCAVMAP,CAVL175A,CSP17,CAVL175B,DCAVMAP];
CAVL176_FULL=[DCAVMAP,CAVL176,DCAVMAP];
CAVL177_FULL=[DCAVMAP,CAVL177,DCAVMAP];
CAVL178_FULL=[DCAVMAP,CAVL178,DCAVMAP];
CAVL181_FULL=[DCAVMAP,CAVL181,DCAVMAP];
CAVL182_FULL=[DCAVMAP,CAVL182,DCAVMAP];
CAVL183_FULL=[DCAVMAP,CAVL183,DCAVMAP];
CAVL184_FULL=[DCAVMAP,CAVL184,DCAVMAP];
CAVL185_FULL=[DCAVMAP,CAVL185A,CSP18,CAVL185B,DCAVMAP];
CAVL186_FULL=[DCAVMAP,CAVL186,DCAVMAP];
CAVL187_FULL=[DCAVMAP,CAVL187,DCAVMAP];
CAVL188_FULL=[DCAVMAP,CAVL188,DCAVMAP];
CAVL191_FULL=[DCAVMAP,CAVL191,DCAVMAP];
CAVL192_FULL=[DCAVMAP,CAVL192,DCAVMAP];
CAVL193_FULL=[DCAVMAP,CAVL193,DCAVMAP];
CAVL194_FULL=[DCAVMAP,CAVL194,DCAVMAP];
CAVL195_FULL=[DCAVMAP,CAVL195A,CSP19,CAVL195B,DCAVMAP];
CAVL196_FULL=[DCAVMAP,CAVL196,DCAVMAP];
CAVL197_FULL=[DCAVMAP,CAVL197,DCAVMAP];
CAVL198_FULL=[DCAVMAP,CAVL198,DCAVMAP];
CAVL201_FULL=[DCAVMAP,CAVL201,DCAVMAP];
CAVL202_FULL=[DCAVMAP,CAVL202,DCAVMAP];
CAVL203_FULL=[DCAVMAP,CAVL203,DCAVMAP];
CAVL204_FULL=[DCAVMAP,CAVL204,DCAVMAP];
CAVL205_FULL=[DCAVMAP,CAVL205A,CSP20,CAVL205B,DCAVMAP];
CAVL206_FULL=[DCAVMAP,CAVL206,DCAVMAP];
CAVL207_FULL=[DCAVMAP,CAVL207,DCAVMAP];
CAVL208_FULL=[DCAVMAP,CAVL208,DCAVMAP];
CAVL211_FULL=[DCAVMAP,CAVL211,DCAVMAP];
CAVL212_FULL=[DCAVMAP,CAVL212,DCAVMAP];
CAVL213_FULL=[DCAVMAP,CAVL213,DCAVMAP];
CAVL214_FULL=[DCAVMAP,CAVL214,DCAVMAP];
CAVL215_FULL=[DCAVMAP,CAVL215A,CSP21,CAVL215B,DCAVMAP];
CAVL216_FULL=[DCAVMAP,CAVL216,DCAVMAP];
CAVL217_FULL=[DCAVMAP,CAVL217,DCAVMAP];
CAVL218_FULL=[DCAVMAP,CAVL218,DCAVMAP];
CAVL221_FULL=[DCAVMAP,CAVL221,DCAVMAP];
CAVL222_FULL=[DCAVMAP,CAVL222,DCAVMAP];
CAVL223_FULL=[DCAVMAP,CAVL223,DCAVMAP];
CAVL224_FULL=[DCAVMAP,CAVL224,DCAVMAP];
CAVL225_FULL=[DCAVMAP,CAVL225A,CSP22,CAVL225B,DCAVMAP];
CAVL226_FULL=[DCAVMAP,CAVL226,DCAVMAP];
CAVL227_FULL=[DCAVMAP,CAVL227,DCAVMAP];
CAVL228_FULL=[DCAVMAP,CAVL228,DCAVMAP];
CAVL231_FULL=[DCAVMAP,CAVL231,DCAVMAP];
CAVL232_FULL=[DCAVMAP,CAVL232,DCAVMAP];
CAVL233_FULL=[DCAVMAP,CAVL233,DCAVMAP];
CAVL234_FULL=[DCAVMAP,CAVL234,DCAVMAP];
CAVL235_FULL=[DCAVMAP,CAVL235A,CSP23,CAVL235B,DCAVMAP];
CAVL236_FULL=[DCAVMAP,CAVL236,DCAVMAP];
CAVL237_FULL=[DCAVMAP,CAVL237,DCAVMAP];
CAVL238_FULL=[DCAVMAP,CAVL238,DCAVMAP];
CAVL241_FULL=[DCAVMAP,CAVL241,DCAVMAP];
CAVL242_FULL=[DCAVMAP,CAVL242,DCAVMAP];
CAVL243_FULL=[DCAVMAP,CAVL243,DCAVMAP];
CAVL244_FULL=[DCAVMAP,CAVL244,DCAVMAP];
CAVL245_FULL=[DCAVMAP,CAVL245A,CSP24,CAVL245B,DCAVMAP];
CAVL246_FULL=[DCAVMAP,CAVL246,DCAVMAP];
CAVL247_FULL=[DCAVMAP,CAVL247,DCAVMAP];
CAVL248_FULL=[DCAVMAP,CAVL248,DCAVMAP];
CAVL251_FULL=[DCAVMAP,CAVL251,DCAVMAP];
CAVL252_FULL=[DCAVMAP,CAVL252,DCAVMAP];
CAVL253_FULL=[DCAVMAP,CAVL253,DCAVMAP];
CAVL254_FULL=[DCAVMAP,CAVL254,DCAVMAP];
CAVL255_FULL=[DCAVMAP,CAVL255A,CSP25,CAVL255B,DCAVMAP];
CAVL256_FULL=[DCAVMAP,CAVL256,DCAVMAP];
CAVL257_FULL=[DCAVMAP,CAVL257,DCAVMAP];
CAVL258_FULL=[DCAVMAP,CAVL258,DCAVMAP];
CAVL261_FULL=[DCAVMAP,CAVL261,DCAVMAP];
CAVL262_FULL=[DCAVMAP,CAVL262,DCAVMAP];
CAVL263_FULL=[DCAVMAP,CAVL263,DCAVMAP];
CAVL264_FULL=[DCAVMAP,CAVL264,DCAVMAP];
CAVL265_FULL=[DCAVMAP,CAVL265A,CSP26,CAVL265B,DCAVMAP];
CAVL266_FULL=[DCAVMAP,CAVL266,DCAVMAP];
CAVL267_FULL=[DCAVMAP,CAVL267,DCAVMAP];
CAVL268_FULL=[DCAVMAP,CAVL268,DCAVMAP];
CAVL271_FULL=[DCAVMAP,CAVL271,DCAVMAP];
CAVL272_FULL=[DCAVMAP,CAVL272,DCAVMAP];
CAVL273_FULL=[DCAVMAP,CAVL273,DCAVMAP];
CAVL274_FULL=[DCAVMAP,CAVL274,DCAVMAP];
CAVL275_FULL=[DCAVMAP,CAVL275A,CSP27,CAVL275B,DCAVMAP];
CAVL276_FULL=[DCAVMAP,CAVL276,DCAVMAP];
CAVL277_FULL=[DCAVMAP,CAVL277,DCAVMAP];
CAVL278_FULL=[DCAVMAP,CAVL278,DCAVMAP];
CAVL281_FULL=[DCAVMAP,CAVL281,DCAVMAP];
CAVL282_FULL=[DCAVMAP,CAVL282,DCAVMAP];
CAVL283_FULL=[DCAVMAP,CAVL283,DCAVMAP];
CAVL284_FULL=[DCAVMAP,CAVL284,DCAVMAP];
CAVL285_FULL=[DCAVMAP,CAVL285A,CSP28,CAVL285B,DCAVMAP];
CAVL286_FULL=[DCAVMAP,CAVL286,DCAVMAP];
CAVL287_FULL=[DCAVMAP,CAVL287,DCAVMAP];
CAVL288_FULL=[DCAVMAP,CAVL288,DCAVMAP];
CAVL291_FULL=[DCAVMAP,CAVL291,DCAVMAP];
CAVL292_FULL=[DCAVMAP,CAVL292,DCAVMAP];
CAVL293_FULL=[DCAVMAP,CAVL293,DCAVMAP];
CAVL294_FULL=[DCAVMAP,CAVL294,DCAVMAP];
CAVL295_FULL=[DCAVMAP,CAVL295A,CSP29,CAVL295B,DCAVMAP];
CAVL296_FULL=[DCAVMAP,CAVL296,DCAVMAP];
CAVL297_FULL=[DCAVMAP,CAVL297,DCAVMAP];
CAVL298_FULL=[DCAVMAP,CAVL298,DCAVMAP];
CAVL301_FULL=[DCAVMAP,CAVL301,DCAVMAP];
CAVL302_FULL=[DCAVMAP,CAVL302,DCAVMAP];
CAVL303_FULL=[DCAVMAP,CAVL303,DCAVMAP];
CAVL304_FULL=[DCAVMAP,CAVL304,DCAVMAP];
CAVL305_FULL=[DCAVMAP,CAVL305A,CSP30,CAVL305B,DCAVMAP];
CAVL306_FULL=[DCAVMAP,CAVL306,DCAVMAP];
CAVL307_FULL=[DCAVMAP,CAVL307,DCAVMAP];
CAVL308_FULL=[DCAVMAP,CAVL308,DCAVMAP];
CAVL311_FULL=[DCAVMAP,CAVL311,DCAVMAP];
CAVL312_FULL=[DCAVMAP,CAVL312,DCAVMAP];
CAVL313_FULL=[DCAVMAP,CAVL313,DCAVMAP];
CAVL314_FULL=[DCAVMAP,CAVL314,DCAVMAP];
CAVL315_FULL=[DCAVMAP,CAVL315A,CSP31,CAVL315B,DCAVMAP];
CAVL316_FULL=[DCAVMAP,CAVL316,DCAVMAP];
CAVL317_FULL=[DCAVMAP,CAVL317,DCAVMAP];
CAVL318_FULL=[DCAVMAP,CAVL318,DCAVMAP];
CAVL321_FULL=[DCAVMAP,CAVL321,DCAVMAP];
CAVL322_FULL=[DCAVMAP,CAVL322,DCAVMAP];
CAVL323_FULL=[DCAVMAP,CAVL323,DCAVMAP];
CAVL324_FULL=[DCAVMAP,CAVL324,DCAVMAP];
CAVL325_FULL=[DCAVMAP,CAVL325A,CSP32,CAVL325B,DCAVMAP];
CAVL326_FULL=[DCAVMAP,CAVL326,DCAVMAP];
CAVL327_FULL=[DCAVMAP,CAVL327,DCAVMAP];
CAVL328_FULL=[DCAVMAP,CAVL328,DCAVMAP];
CAVL331_FULL=[DCAVMAP,CAVL331,DCAVMAP];
CAVL332_FULL=[DCAVMAP,CAVL332,DCAVMAP];
CAVL333_FULL=[DCAVMAP,CAVL333,DCAVMAP];
CAVL334_FULL=[DCAVMAP,CAVL334,DCAVMAP];
CAVL335_FULL=[DCAVMAP,CAVL335A,CSP33,CAVL335B,DCAVMAP];
CAVL336_FULL=[DCAVMAP,CAVL336,DCAVMAP];
CAVL337_FULL=[DCAVMAP,CAVL337,DCAVMAP];
CAVL338_FULL=[DCAVMAP,CAVL338,DCAVMAP];
CAVL341_FULL=[DCAVMAP,CAVL341,DCAVMAP];
CAVL342_FULL=[DCAVMAP,CAVL342,DCAVMAP];
CAVL343_FULL=[DCAVMAP,CAVL343,DCAVMAP];
CAVL344_FULL=[DCAVMAP,CAVL344,DCAVMAP];
CAVL345_FULL=[DCAVMAP,CAVL345A,CSP34,CAVL345B,DCAVMAP];
CAVL346_FULL=[DCAVMAP,CAVL346,DCAVMAP];
CAVL347_FULL=[DCAVMAP,CAVL347,DCAVMAP];
CAVL348_FULL=[DCAVMAP,CAVL348,DCAVMAP];
CAVL351_FULL=[DCAVMAP,CAVL351,DCAVMAP];
CAVL352_FULL=[DCAVMAP,CAVL352,DCAVMAP];
CAVL353_FULL=[DCAVMAP,CAVL353,DCAVMAP];
CAVL354_FULL=[DCAVMAP,CAVL354,DCAVMAP];
CAVL355_FULL=[DCAVMAP,CAVL355A,CSP35,CAVL355B,DCAVMAP];
CAVL356_FULL=[DCAVMAP,CAVL356,DCAVMAP];
CAVL357_FULL=[DCAVMAP,CAVL357,DCAVMAP];
CAVL358_FULL=[DCAVMAP,CAVL358,DCAVMAP];
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
CM01=[CM01BEG,DCM1,CAVL011_FULL,DCM2,CAVL012_FULL,DCM2,CAVL013_FULL,DCM2,CAVL014_FULL,DCM2,CAVL015_FULL,DCM2,CAVL016_FULL,DCM2,CAVL017_FULL,DCM2,CAVL018_FULL,DCM3,CMB01,DCM4A,BEAM0,DCM4B,QCM01_FULL,DCM5,CM01END];
% L1
CM02=[CM02BEG,DCM1,CAVL021_FULL,DCM2,CAVL022_FULL,DCM2,CAVL023_FULL,DCM2,CAVL024_FULL,DCM2,CAVL025_FULL,DCM2,CAVL026_FULL,DCM2,CAVL027_FULL,DCM2,CAVL028_FULL,DCM3,CMB02,DCM4,QCM02_FULL,DCM5,CM02END];
CM03=[CM03BEG,DCM1,CAVL031_FULL,DCM2,CAVL032_FULL,DCM2,CAVL033_FULL,DCM2,CAVL034_FULL,DCM2,CAVL035_FULL,DCM2,CAVL036_FULL,DCM2,CAVL037_FULL,DCM2,CAVL038_FULL,DCM3,CMB03,DCM4,QCM03_FULL,DCM5,CM03END];
CMH1=[CMH1BEG,DCMH0,CAVC011_FULL,DCMH2,CAVC012_FULL,DCMH2,CAVC013_FULL,DCMH2,CAVC014_FULL,DCMH2,CAVC015_FULL,DCMH2,CAVC016_FULL,DCMH2,CAVC017_FULL,DCMH2,CAVC018_FULL,DCMH3,CMBH1,DCMH4,CMH1END];
CMH2=[CMH2BEG,DCMH1,CAVC021_FULL,DCMH2,CAVC022_FULL,DCMH2,CAVC023_FULL,DCMH2,CAVC024_FULL,DCMH2,CAVC025_FULL,DCMH2,CAVC026_FULL,DCMH2,CAVC027_FULL,DCMH2,CAVC028_FULL,DCMH3,CMBH2,DCMH4,CMH2END];
% L2
CM04=[CM04BEG,DCM1,CAVL041_FULL,DCM2,CAVL042_FULL,DCM2,CAVL043_FULL,DCM2,CAVL044_FULL,DCM2,CAVL045_FULL,DCM2,CAVL046_FULL,DCM2,CAVL047_FULL,DCM2,CAVL048_FULL,DCM3,CMB04,DCM4,QCM04_FULL,DCM5,CM04END];
CM05=[CM05BEG,DCM1,CAVL051_FULL,DCM2,CAVL052_FULL,DCM2,CAVL053_FULL,DCM2,CAVL054_FULL,DCM2,CAVL055_FULL,DCM2,CAVL056_FULL,DCM2,CAVL057_FULL,DCM2,CAVL058_FULL,DCM3,CMB05,DCM4,QCM05_FULL,DCM5,CM05END];
CM06=[CM06BEG,DCM1,CAVL061_FULL,DCM2,CAVL062_FULL,DCM2,CAVL063_FULL,DCM2,CAVL064_FULL,DCM2,CAVL065_FULL,DCM2,CAVL066_FULL,DCM2,CAVL067_FULL,DCM2,CAVL068_FULL,DCM3,CMB06,DCM4,QCM06_FULL,DCM5,CM06END];
CM07=[CM07BEG,DCM1,CAVL071_FULL,DCM2,CAVL072_FULL,DCM2,CAVL073_FULL,DCM2,CAVL074_FULL,DCM2,CAVL075_FULL,DCM2,CAVL076_FULL,DCM2,CAVL077_FULL,DCM2,CAVL078_FULL,DCM3,CMB07,DCM4,QCM07_FULL,DCM5,CM07END];
CM08=[CM08BEG,DCM1,CAVL081_FULL,DCM2,CAVL082_FULL,DCM2,CAVL083_FULL,DCM2,CAVL084_FULL,DCM2,CAVL085_FULL,DCM2,CAVL086_FULL,DCM2,CAVL087_FULL,DCM2,CAVL088_FULL,DCM3,CMB08,DCM4,QCM08_FULL,DCM5,CM08END];
CM09=[CM09BEG,DCM1,CAVL091_FULL,DCM2,CAVL092_FULL,DCM2,CAVL093_FULL,DCM2,CAVL094_FULL,DCM2,CAVL095_FULL,DCM2,CAVL096_FULL,DCM2,CAVL097_FULL,DCM2,CAVL098_FULL,DCM3,CMB09,DCM4,QCM09_FULL,DCM5,CM09END];
CM10=[CM10BEG,DCM1,CAVL101_FULL,DCM2,CAVL102_FULL,DCM2,CAVL103_FULL,DCM2,CAVL104_FULL,DCM2,CAVL105_FULL,DCM2,CAVL106_FULL,DCM2,CAVL107_FULL,DCM2,CAVL108_FULL,DCM3,CMB10,DCM4,QCM10_FULL,DCM5,CM10END];
CM11=[CM11BEG,DCM1,CAVL111_FULL,DCM2,CAVL112_FULL,DCM2,CAVL113_FULL,DCM2,CAVL114_FULL,DCM2,CAVL115_FULL,DCM2,CAVL116_FULL,DCM2,CAVL117_FULL,DCM2,CAVL118_FULL,DCM3,CMB11,DCM4,QCM11_FULL,DCM5,CM11END];
CM12=[CM12BEG,DCM1,CAVL121_FULL,DCM2,CAVL122_FULL,DCM2,CAVL123_FULL,DCM2,CAVL124_FULL,DCM2,CAVL125_FULL,DCM2,CAVL126_FULL,DCM2,CAVL127_FULL,DCM2,CAVL128_FULL,DCM3,CMB12,DCM4,QCM12_FULL,DCM5,CM12END];
CM13=[CM13BEG,DCM1,CAVL131_FULL,DCM2,CAVL132_FULL,DCM2,CAVL133_FULL,DCM2,CAVL134_FULL,DCM2,CAVL135_FULL,DCM2,CAVL136_FULL,DCM2,CAVL137_FULL,DCM2,CAVL138_FULL,DCM3,CMB13,DCM4,QCM13_FULL,DCM5,CM13END];
CM14=[CM14BEG,DCM1,CAVL141_FULL,DCM2,CAVL142_FULL,DCM2,CAVL143_FULL,DCM2,CAVL144_FULL,DCM2,CAVL145_FULL,DCM2,CAVL146_FULL,DCM2,CAVL147_FULL,DCM2,CAVL148_FULL,DCM3,CMB14,DCM4,QCM14_FULL,DCM5,CM14END];
CM15=[CM15BEG,DCM1,CAVL151_FULL,DCM2,CAVL152_FULL,DCM2,CAVL153_FULL,DCM2,CAVL154_FULL,DCM2,CAVL155_FULL,DCM2,CAVL156_FULL,DCM2,CAVL157_FULL,DCM2,CAVL158_FULL,DCM3,CMB15,DCM4,QCM15_FULL,DCM5,CM15END];
% L3
CM16=[CM16BEG,DCM1,CAVL161_FULL,DCM2,CAVL162_FULL,DCM2,CAVL163_FULL,DCM2,CAVL164_FULL,DCM2,CAVL165_FULL,DCM2,CAVL166_FULL,DCM2,CAVL167_FULL,DCM2,CAVL168_FULL,DCM3,CMB16,DCM4,QCM16_FULL,DCM5,CM16END];
CM17=[CM17BEG,DCM1,CAVL171_FULL,DCM2,CAVL172_FULL,DCM2,CAVL173_FULL,DCM2,CAVL174_FULL,DCM2,CAVL175_FULL,DCM2,CAVL176_FULL,DCM2,CAVL177_FULL,DCM2,CAVL178_FULL,DCM3,CMB17,DCM4,QCM17_FULL,DCM5,CM17END];
CM18=[CM18BEG,DCM1,CAVL181_FULL,DCM2,CAVL182_FULL,DCM2,CAVL183_FULL,DCM2,CAVL184_FULL,DCM2,CAVL185_FULL,DCM2,CAVL186_FULL,DCM2,CAVL187_FULL,DCM2,CAVL188_FULL,DCM3,CMB18,DCM4,QCM18_FULL,DCM5,CM18END];
CM19=[CM19BEG,DCM1,CAVL191_FULL,DCM2,CAVL192_FULL,DCM2,CAVL193_FULL,DCM2,CAVL194_FULL,DCM2,CAVL195_FULL,DCM2,CAVL196_FULL,DCM2,CAVL197_FULL,DCM2,CAVL198_FULL,DCM3,CMB19,DCM4,QCM19_FULL,DCM5,CM19END];
CM20=[CM20BEG,DCM1,CAVL201_FULL,DCM2,CAVL202_FULL,DCM2,CAVL203_FULL,DCM2,CAVL204_FULL,DCM2,CAVL205_FULL,DCM2,CAVL206_FULL,DCM2,CAVL207_FULL,DCM2,CAVL208_FULL,DCM3,CMB20,DCM4,QCM20_FULL,DCM5,CM20END];
CM21=[CM21BEG,DCM1,CAVL211_FULL,DCM2,CAVL212_FULL,DCM2,CAVL213_FULL,DCM2,CAVL214_FULL,DCM2,CAVL215_FULL,DCM2,CAVL216_FULL,DCM2,CAVL217_FULL,DCM2,CAVL218_FULL,DCM3,CMB21,DCM4,QCM21_FULL,DCM5,CM21END];
CM22=[CM22BEG,DCM1,CAVL221_FULL,DCM2,CAVL222_FULL,DCM2,CAVL223_FULL,DCM2,CAVL224_FULL,DCM2,CAVL225_FULL,DCM2,CAVL226_FULL,DCM2,CAVL227_FULL,DCM2,CAVL228_FULL,DCM3,CMB22,DCM4,QCM22_FULL,DCM5,CM22END];
CM23=[CM23BEG,DCM1,CAVL231_FULL,DCM2,CAVL232_FULL,DCM2,CAVL233_FULL,DCM2,CAVL234_FULL,DCM2,CAVL235_FULL,DCM2,CAVL236_FULL,DCM2,CAVL237_FULL,DCM2,CAVL238_FULL,DCM3,CMB23,DCM4,QCM23_FULL,DCM5,CM23END];
CM24=[CM24BEG,DCM1,CAVL241_FULL,DCM2,CAVL242_FULL,DCM2,CAVL243_FULL,DCM2,CAVL244_FULL,DCM2,CAVL245_FULL,DCM2,CAVL246_FULL,DCM2,CAVL247_FULL,DCM2,CAVL248_FULL,DCM3,CMB24,DCM4,QCM24_FULL,DCM5,CM24END];
CM25=[CM25BEG,DCM1,CAVL251_FULL,DCM2,CAVL252_FULL,DCM2,CAVL253_FULL,DCM2,CAVL254_FULL,DCM2,CAVL255_FULL,DCM2,CAVL256_FULL,DCM2,CAVL257_FULL,DCM2,CAVL258_FULL,DCM3,CMB25,DCM4,QCM25_FULL,DCM5,CM25END];
CM26=[CM26BEG,DCM1,CAVL261_FULL,DCM2,CAVL262_FULL,DCM2,CAVL263_FULL,DCM2,CAVL264_FULL,DCM2,CAVL265_FULL,DCM2,CAVL266_FULL,DCM2,CAVL267_FULL,DCM2,CAVL268_FULL,DCM3,CMB26,DCM4,QCM26_FULL,DCM5,CM26END];
CM27=[CM27BEG,DCM1,CAVL271_FULL,DCM2,CAVL272_FULL,DCM2,CAVL273_FULL,DCM2,CAVL274_FULL,DCM2,CAVL275_FULL,DCM2,CAVL276_FULL,DCM2,CAVL277_FULL,DCM2,CAVL278_FULL,DCM3,CMB27,DCM4,QCM27_FULL,DCM5,CM27END];
CM28=[CM28BEG,DCM1,CAVL281_FULL,DCM2,CAVL282_FULL,DCM2,CAVL283_FULL,DCM2,CAVL284_FULL,DCM2,CAVL285_FULL,DCM2,CAVL286_FULL,DCM2,CAVL287_FULL,DCM2,CAVL288_FULL,DCM3,CMB28,DCM4,QCM28_FULL,DCM5,CM28END];
CM29=[CM29BEG,DCM1,CAVL291_FULL,DCM2,CAVL292_FULL,DCM2,CAVL293_FULL,DCM2,CAVL294_FULL,DCM2,CAVL295_FULL,DCM2,CAVL296_FULL,DCM2,CAVL297_FULL,DCM2,CAVL298_FULL,DCM3,CMB29,DCM4,QCM29_FULL,DCM5,CM29END];
CM30=[CM30BEG,DCM1,CAVL301_FULL,DCM2,CAVL302_FULL,DCM2,CAVL303_FULL,DCM2,CAVL304_FULL,DCM2,CAVL305_FULL,DCM2,CAVL306_FULL,DCM2,CAVL307_FULL,DCM2,CAVL308_FULL,DCM3,CMB30,DCM4,QCM30_FULL,DCM5,CM30END];
CM31=[CM31BEG,DCM1,CAVL311_FULL,DCM2,CAVL312_FULL,DCM2,CAVL313_FULL,DCM2,CAVL314_FULL,DCM2,CAVL315_FULL,DCM2,CAVL316_FULL,DCM2,CAVL317_FULL,DCM2,CAVL318_FULL,DCM3,CMB31,DCM4,QCM31_FULL,DCM5,CM31END];
CM32=[CM32BEG,DCM1,CAVL321_FULL,DCM2,CAVL322_FULL,DCM2,CAVL323_FULL,DCM2,CAVL324_FULL,DCM2,CAVL325_FULL,DCM2,CAVL326_FULL,DCM2,CAVL327_FULL,DCM2,CAVL328_FULL,DCM3,CMB32,DCM4,QCM32_FULL,DCM5,CM32END];
CM33=[CM33BEG,DCM1,CAVL331_FULL,DCM2,CAVL332_FULL,DCM2,CAVL333_FULL,DCM2,CAVL334_FULL,DCM2,CAVL335_FULL,DCM2,CAVL336_FULL,DCM2,CAVL337_FULL,DCM2,CAVL338_FULL,DCM3,CMB33,DCM4,QCM33_FULL,DCM5,CM33END];
CM34=[CM34BEG,DCM1,CAVL341_FULL,DCM2,CAVL342_FULL,DCM2,CAVL343_FULL,DCM2,CAVL344_FULL,DCM2,CAVL345_FULL,DCM2,CAVL346_FULL,DCM2,CAVL347_FULL,DCM2,CAVL348_FULL,DCM3,CMB34,DCM4,QCM34_FULL,DCM5,CM34END];
CM35=[CM35BEG,DCM1,CAVL351_FULL,DCM2,CAVL352_FULL,DCM2,CAVL353_FULL,DCM2,CAVL354_FULL,DCM2,CAVL355_FULL,DCM2,CAVL356_FULL,DCM2,CAVL357_FULL,DCM2,CAVL358_FULL,DCM3,CMB35,DCM4,QCM35_FULL,DCM5,CM35END];
% linacs
L0=[BEGL0B,EC1,DCAP0U,CM01,DCMCM1,HOMCM01,DCAP0DA,ASTRA,DCAP0DB,FC1,DMSC0DA,BLF1,DMSC0DB,VGL0BD,DMSC0DC,VPL0BD,DMSC0DD,MSC0D,VVL0BD,ENDL0B];
L1=[BEGL1B,VVL1BU,MSC1U,DMSC1UA,BLF2,DMSC1UB,FC2,DCAP1U,CM02,DCMCM1,HOMCM02,DCMCM2,CM03,DCMCMH1,HOMCM03,DCMCMH2,CMH1,DCMHCMH1,HOMCMH1,DCMHCMH2,CMH2,DCAP1D,FC3,DMSC1DA,BLF3,DMSC1DB,MSC1D,VVL1BD,ENDL1B];
L2=[BEGL2B,VVL2BU,MSC2U,DMSC2UA,BLF4,DMSC2UB,FC4,DCAP2U,CM04,DCMCM1,HOMCM04,DCMCM2,CM05,DCMCM1,HOMCM05,DCMCM2,CM06,DCMCM1,HOMCM06,DCMCM2,CM07,DCMCM1,HOMCM07,DCMCM2,CM08,DCMCM1,HOMCM08,DCMCM2,CM09,DCMCM1,HOMCM09,DCMCM2,CM10,DCMCM1,HOMCM10,DCMCM2,CM11,DCMCM1,HOMCM11,DCMCM2,CM12,DCMCM1,HOMCM12,DCMCM2,CM13,DCMCM1,HOMCM13,DCMCM2,CM14,DCMCM1,HOMCM14,DCMCM2,CM15,DCMCM1,HOMCM15,DCAP2D,FC5,DMSC2DA,BLF5,DMSC2DB,VTL1,DMSC2DC,MSC2D,VVL2BD,ENDL2B];
L3=[BEGL3B,VVL3BU,MSC3U,DMSC3UA,VTL2,DMSC3UB,BLF6,DMSC3UC,FC6,DCAP3U,CM16,DCMCM1,HOMCM16,DCMCM2,CM17,DCMCM1,HOMCM17,DCMCM2,CM18,DCMCM1,HOMCM18,DCMCM2,CM19,DCMCM1,HOMCM19,DCMCM2,CM20,DCMCM1,HOMCM20,DCMCM2,CM21,DCMCM1,HOMCM21,DCMCM2,CM22,DCMCM1,HOMCM22,DCMCM2,CM23,DCMCM1,HOMCM23,DCMCM2,CM24,DCMCM1,HOMCM24,DCMCM2,CM25,DCMCM1,HOMCM25,DCMCM2,DBREAK,CM26,DCMCM1,HOMCM26,DCMCM2,CM27,DCMCM1,HOMCM27,DCMCM2,CM28,DCMCM1,HOMCM28,DCMCM2,CM29,DCMCM1,HOMCM29,DCMCM2,CM30,DCMCM1,HOMCM30,DCMCM2,CM31,DCMCM1,HOMCM31,DCMCM2,CM32,DCMCM1,HOMCM32,DCMCM2,CM33,DCMCM1,HOMCM33,DCMCM2,CM34,DCMCM1,HOMCM34,DCMCM2,CM35,DCMCM1,HOMCM35,DCAP3D,EC2,DMSC3DA,BLF7,DMSC3DB,VGL3BD,DMSC3DC,MSC3D,VVL3BD,ENDL3B];
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

%CALL, FILENAME="CM_SWAVE2.xsif" with LCAVITY NCELL attribute
% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc post laser heater diagnostic beamline
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 27-NOV-2022, M. Woodley
%  * STCAV installation (replace TCXDG0 and TCYDG0)
%  * move QDG007 4.4 cm downstream (TCXDG0cl to QDG007cl = 31.309")
% ------------------------------------------------------------------------------
% 09-SEP-2022, M. Woodley
%  * redefine (deferred) OTRDG01 and OTRDG03
% ------------------------------------------------------------------------------
% 26-NOV-2019, M. Woodley
%  * undefer TCXDG0, XCDGTCX, and YCDGTCX per D. Yeremian
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
TCYDG0={'dr' '' 20*IN2M/2 []}';%Y-deflector (split)
TCXDG0={'tc' 'TCXDG0' 20*IN2M/2 [2856 0 0*TWOPI]}';%X-deflector (split)
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
KQDG004 =    8.771677621875;
KQDG005 =  -12.053189299491;
KQDG006 =    6.830639733104  ;
KQDG007 =   -4.543712509755;
KQDG008 =   11.377027435309;
KQDG009 =  -11.539229642587;
KQDG010 =   13.01665154881;
KQDG011 =  -10.983650981721;
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
DDG006={'dr' '' 2.536 []}';%2.492
DDG007={'dr' '' 0.548 []}';%0.592
DDG008={'dr' '' 0.592 []}';
DDG009={'dr' '' 2.962 []}';
DDG010={'dr' '' 0.592 []}';
DDG011={'dr' '' 1.4048 []}';
DDG012={'dr' '' 0.935296300379 []}';
DDG004A={'dr' '' DDG004{3}/2 []}';
DDG004B={'dr' '' DDG004{3}-DDG004A{3} []}';
DDG005A={'dr' '' DDG005{3}/2 []}';
DDG005B={'dr' '' DDG005{3}-DDG005A{3} []}';
DDG006A={'dr' '' 0.7327514 []}';%0.296
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
RFBDG001={'dr' '' 0 []}';
RFBDG002={'dr' '' 0 []}';
RFBDG003={'dr' '' 0 []}';
BPMDG012={'mo' 'BPMDG012' 0 []}';%RFBDG004 : MONI, TYPE="@2,CavityL-1"
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCDG001={'mo' 'XCDG001' 0 []}';
XCDG002={'mo' 'XCDG002' 0 []}';
XCDG003={'mo' 'XCDG003' 0 []}';
XCDG005={'mo' 'XCDG005' 0 []}';
XCDGTCY={'dr' '' 0 []}';
XCDGTCX={'mo' 'XCDGTCX' 0 []}';
XCDG008={'mo' 'XCDG008' 0 []}';
XCDG010={'mo' 'XCDG010' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCDG001={'mo' 'YCDG001' 0 []}';
YCDG002={'mo' 'YCDG002' 0 []}';
YCDG003={'mo' 'YCDG003' 0 []}';
YCDG005={'mo' 'YCDG005' 0 []}';
YCDGTCY={'dr' '' 0 []}';
YCDGTCX={'mo' 'YCDGTCX' 0 []}';
YCDG008={'mo' 'YCDG008' 0 []}';
YCDG010={'mo' 'YCDG010' 0 []}';
% ==============================================================================
% diagnostics, etc.
% ------------------------------------------------------------------------------
% profile monitors
OTRDG02={'mo' 'OTRDG02' 0 []}';
OTRDG04={'mo' 'OTRDG04' 0 []}';
% combination OTR/YAG PSI type
OTRDG01={'dr' '' 0 []}';
OTRDG01_YAG={'dr' '' 0 []}';
OTRDG01_FULL=[OTRDG01,OTRDG01_YAG];
OTRDG03={'dr' '' 0 []}';
OTRDG03_YAG={'dr' '' 0 []}';
OTRDG03_FULL=[OTRDG03,OTRDG03_YAG];
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
TCYDG0_FULL=[TCYDG0,XCDGTCY,MTCYDG0,YCDGTCY,TCYDG0];
TCXDG0_FULL=[TCXDG0,XCDGTCX,MTCXDG0,YCDGTCX,TCXDG0];
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
DIAG0=[BEGDIAG0,BKRDG0_FULL,RODG0K,DKV0A,BPMDG000,DKV0B,M1DG0,BLRDG0_FULL,RODG0L,DQB01A,RFBDG001,DQB01B,XCDG001,DQB01C,QDG001_FULL,DQB02A,YCDG001,DQB02B,QDG002_FULL,DQB03A,XCDG002,DQB03B,QDG003_FULL,DQB04A,YCDG002,DQB04B,BXDG0_FULL,CNTDG0,M2DG0,DDG003,QDG004_FULL,DDG004A,SCDG003,DDG004B,QDG005_FULL,DDG005A,SCDG005,DDG005B,QDG006_FULL,DDG006A,TCYDG0_FULL,DDG006B,BPMDG0RF,DDG006C,TCXDG0_FULL,DDG006D,QDG007_FULL,DDG007,QDG008_FULL,DDG008A,SCDG008,DDG008B,QDG009_FULL,DDG009A,OTRDG01_FULL,DDG009B,RFBDG002,DDG009C,OTRDG02,DDG009D,WSDG01,DDG009E,OTRDG03_FULL,DDG009F,QDG010_FULL,DDG010A,SCDG010,DDG010B,QDG011_FULL,DDG011A,RFBDG003,DDG011B,BYDG0_FULL,DDG012A,BPMDG012,DDG012B,OTRDG04,DDG012C,FCDG0DU,ENDDIAG0];
%ENDCOMMENT
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc injector: gun to start of L1 linac
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 22-MAR-2024, M. Woodley
%  * add SWAVE attribute to BUN1B per M. Ehrlichman
% ------------------------------------------------------------------------------
% 24-OCT-2022, M. Woodley
%  * replace CQ02B (SOL2B trim) with "mini-quad"
% ------------------------------------------------------------------------------
% 08-SEP-2022, M. Woodley
%  * redefine YAG01B, OTR0H04, and OTRC001
% 14-APR-2022, M. Woodley
%  * replace YAG01B_YAG1 and YAG01B_YAG2 with YAG01B
% ------------------------------------------------------------------------------
% 28-SEP-2021, M. Woodley
%  * replace YAG01B with combination YAG/COLL/FC device
% ------------------------------------------------------------------------------
% 16-JAN-2021, M. Woodley
%  * new buncher settings per Y. Ding
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
GBUN =  1.8     ;%MV/m
PBUN =  -85     ;%deg
BUN1B={'ls' 'BUN1B' LBUN/2 [1300 GBUN*LBUN/2 PBUN/360*TWOPI]}';
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
ABH =  0.022113602317 ;%DXmax=0.075
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
%CQ02B : MULT, TYPE="solenoid trim", APER=0.0475/2, K1L=0     shorted out
SQ02B={'mu' 'SQ02B' 0 [0 0 0 pi/4]}';
% replacement for original CQ02B (correction coil co-wound on SOL2B)
CQ02B={'qu' 'CQ02B' LQG/2 [0 0]}';
% L0 to WS/OTR (Q0H01-4 match to waists at WS0H04)
%              heater ON        heater OFF        chicane OFF	
%           ---------------   ---------------   ---------------   
KQ0H01 =  -6.537777564736 ;% -6.52550777024   -6.525507740091 
KQ0H02 =   6.17752713417  ;%  6.335021207148   6.335021170324 
KQ0H03 =   0.483905171963 ;% -0.947731202989  -0.947730849886 
KQ0H04 =  -3.971575402157 ;% -3.418410103407  -3.418410369207 
B0H04W =   7.710749594202 ;%  5.0              5.0            
Q0H01={'qu' 'Q0H01' LQM/2 [KQ0H01 0]}';
Q0H02={'qu' 'Q0H02' LQM/2 [KQ0H02 0]}';
Q0H03={'qu' 'Q0H03' LQM/2 [KQ0H03 0]}';
Q0H04={'qu' 'Q0H04' LQM/2 [KQ0H04 0]}';
% WS/OTR to laser heater (Q0H05-8 match to 10x10 m beta waists LHMID)
%              heater ON        heater OFF        chicane OFF	
%           ---------------   ---------------   ---------------  
KQ0H05 =  -2.32266979602  ;% -7.451315276972  -7.508072657056  
KQ0H06 =   0.0            ;%  1.835321381141   1.870908387696  
KQ0H07 =   5.84302489781  ;%  7.794364472964   7.804907479846  
KQ0H08 =  -5.210258454761 ;% -8.272684492892  -8.306722243051  
BLHUW =   7.5            ;% 10.0             10.0            
Q0H05={'qu' 'Q0H05' LQM/2 [KQ0H05 0]}';
Q0H06={'qu' 'Q0H06' LQM/2 [KQ0H06 0]}';
Q0H07={'qu' 'Q0H07' LQM/2 [KQ0H07 0]}';
Q0H08={'qu' 'Q0H08' LQM/2 [KQ0H08 0]}';
% laser heater to diagnostic line
%              heater ON         heater OFF        chicane OFF    
%           ----------------   ---------------   ---------------   
KQHD01 =  -13.178598580237 ;% -8.743988237466  -8.746794738551 
KQHD02 =    7.650668410884 ;%  6.400024228564   6.401620200768 
KQHD03 =   -7.978934972385 ;% -8.612136694917  -8.622952974048 
KQHD04 =    6.238682089532 ;%  6.860670498454   6.864937307631 
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
KQC001 =   5.135316216759 ;% 5.055115117203 
KQC002 =   0.0            ;% 0.157983739509 
KQC003 =  -5.295950232123 ;%-5.345027236641 
KQC004 =   2.772436085305 ;% 2.756594856447 
KQC005 =  -1.796082149685 ;%-KQColl0        
KQC006 =   KQCOLL0;
KQC007 =  -KQCOLL0;
KQC008 =   KQCOLL0;
KQC009 =  -KQCOLL0;
KQC010 =   0.346494139368;
KQC011 =  -1.054136562653;
KQC012 =   0.942153662284;
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
% - modeled as R-matrix to include natural vertical focusing
% - parameters from LCLS-II Phase 1 undulator
% - triple heater laser wavelength for 3rd harmonic operation
% lam   : laser-heater undulator period [m]
% lamr  : heater laser wavelength [m]
% gami  : Lorentz energy factor in laser-heater undulator [1]
% K_und : undulator K for laser heater undulator
% Lhun  : length of laser-heater undulator (10 periods) [m]
% Lhunh : half-length of laser-heater undulator [m]
% kqlh  : natural undulator focusing "k" in y-plane [1/m2]
LAM =  0.054;
LAMR =  3*1030E-9 ;%3rd harmonic
GAMI =  EI/EMASS;
K_UND =  sqrt(2*(LAMR*2*GAMI^2/LAM-1)) ;%gap= 30.6 mm
LHUN =  9*LAM;
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
DG012A={'dr' '' 0.08-LQG/2 []}';
DG012B={'dr' '' DG012{3}-LQG-DG012A{3} []}';
DG016B={'dr' '' 0.082968 []}';
DG016A={'dr' '' DG016{3}-DG016B{3} []}';
DGEIC={'dr' '' 3.0-2.052577 []}';
% L0 to laser heater
D0H00={'dr' '' 0.658175 []}';
D0H01={'dr' '' 0.427898 []}';
D0H02={'dr' '' 4.179215 []}';
D0H03={'dr' '' 0.409812 []}';
D0H04={'dr' '' 1.0979 []}';
D0H05={'dr' '' 0.409812 []}';
D0H06={'dr' '' 1.366076 []}';
D0H07={'dr' '' 0.409812 []}';
D0H08={'dr' '' 0.3687 []}';
D0H00A={'dr' '' 0.2502 []}';
D0H00B={'dr' '' 0.056 []}';
D0H00C={'dr' '' D0H00{3}-D0H00A{3}-LJAW-D0H00B{3} []}';
D0H01A={'dr' '' 0.213949 []}';
D0H01B={'dr' '' D0H01{3}-D0H01A{3} []}';
D0H02A={'dr' '' 0.204906 []}';
D0H02B={'dr' '' 0.911461 []}';
D0H02C={'dr' '' 0.485648 []}';
D0H02F={'dr' '' 0.204906 []}';
D0H02E={'dr' '' 0.5-D0H02F{3} []}';
D0H02D={'dr' '' D0H02{3}-D0H02A{3}-D0H02B{3}-D0H02C{3}-D0H02E{3}-D0H02F{3} []}';
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
DC012={'dr' '' 2.52236 []}';
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
RFB0H00={'dr' '' 0 []}';
RFB0H04={'dr' '' 0 []}';
RFB0H08={'dr' '' 0 []}';
RFBHD00={'dr' '' 0 []}';
RFBHD04={'dr' '' 0 []}';
RFBC006={'dr' '' 0 []}';
RFBC011={'dr' '' 0 []}';
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
% collimators, diagnostics, etc.
% ------------------------------------------------------------------------------
% halo/dark current collimator
PC0H00={'dr' 'PC0H00' LJAW []}';
% collimators
% (betatron X/Y half-gaps are 24/16 sigma for 1 um normalized emittance)
CEHTR={'dr' 'CEHTR' LJAW []}';%X momentum collimator
CYC01={'dr' 'CYC01' LJAW []}';%Y betatron collimator
CXC01={'dr' 'CXC01' LJAW []}';%X betatron collimator
CYC02={'dr' '' LJAW []}';%Y betatron collimator
CXC02={'dr' '' LJAW []}';%X betatron collimator
CYC03={'dr' 'CYC03' LJAW []}';%Y betatron collimator
CXC03={'dr' 'CXC03' LJAW []}';%X betatron collimator
% instruments
CATHODEB={'mo' 'CATHODEB' 0 []}';
VV01B={'mo' 'VV01B' 0 []}';
IM01B={'mo' 'IM01B' 0 []}';
VV02B={'mo' 'VV02B' 0 []}';
WS0H04={'mo' 'WS0H04' 0 []}';
BZ0H04={'mo' 'BZ0H04' 0 []}';
YAGH1={'mo' 'YAGH1' 0 []}';
YAGH2={'mo' 'YAGH2' 0 []}';
IMBCSI1={'mo' 'IMBCSI1' 0 []}';
IMBCSI2={'mo' 'IMBCSI2' 0 []}';
WSC006={'dr' '' 0 []}';
FC00EIC={'mo' 'FC00EIC' 0 []}';
% combination YAG/collimator/Faraday Cup
% - beam pipe ID = 47.6 mm
% - one standard YAG crystal
% - one YAG crystal with a 6 mm diameter hole in it (for measuring beam halo)
% - four circular collimator bores
% - Faraday Cup
YAG01B={'mo' 'YAG01B' 0 []}';%with or without hole
YAG01B_COLL={'dr' 'YAG01B_COLL' 0 []}';%bore: 12mm, 16mm, 20mm, or 24mm
YAG01B_FCUP={'mo' 'YAG01B_FCUP' 0 []}';
YAG01B_FULL=[YAG01B,YAG01B_COLL,YAG01B_FCUP];
% combination OTR/YAG PAL type
OTR0H04={'mo' 'OTR0H04' 0 []}';
OTR0H04_YAG={'mo' 'OTR0H04_YAG' 0 []}';
OTR0H04_FULL=[OTR0H04,OTR0H04_YAG];
OTRC006={'mo' 'OTRC006' 0 []}';
OTRC006_YAG={'mo' 'OTRC006_YAG' 0 []}';
OTRC006_FULL=[OTRC006,OTRC006_YAG];
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
CQ02B_FULL=[CQ02B,CQ02B];
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
SOL2B_FULL=[SOL2B,      SQ02B,SOL2B];
UMHTR_FULL=[UMHTR,HTRUNDB,UMHTR];
SC1B=[XC01B,YC01B];
SC2B=[XC02B,YC02B];
SC3B=[XC03B,YC03B];
SC4B=[XC04B,YC04B];
SC5B=[XC05B,YC05B];
SCC000=[XCC000,YCC000];
GUN=[BEGGUNB,DGBCA,SOL1BKB,DGBCB,CATHODEB,DGUN,DG001,SOL1B_FULL,DG002,VV01B,DG003,SC1B,DG004,BPM1B,DG005,IM01B,DG006,SC2B,DG007,BUN1B_FULL,DG008,SC3B,DG009,AM00B,DG010,SC4B,DG011,YAG01B_FULL,DG012A,CQ02B_FULL,DG012B,SOL2B_FULL,DG013,VV02B,DG014,BPM2B,DG015,SC5B,DG016A,BLFU,DG016B,ENDGUNB];
EIC=[BEGEIC,DGBCA,SOL1BKB,DGBCB,CATHODEB,DGUN,DG001,SOL1B_FULL,DG002,VV01B,DG003,SC1B,DG004,BPM1B,DG005,IM01B,DG006,SC2B,DG007,BUN1B_FULL,DG008,SC3B,DG009,AM00B,DG010,SC4B,DG011,YAG01B,DG012,SOL2B_FULL,DG013,VV02B,DG014,BPM2B,DG015,SC5B,DG016A,BLFU,DG016B,ECUEIC,DGEIC,FC00EIC,ENDEIC];
% %simplified
% LSRHTR=[LHBEGB,BCXH1_FULL,DH01A,DH01B,DH01C,BCXH2_FULL,DH02A,CEHTR,DH02B,DH02C,UMHTR_FULL,DH02D,DH02E,BCXH3_FULL,DH03A,DH03B,DH03C,BCXH4_FULL,LHENDB];

%COMMENT complete
LSRHTR=[LHBEGB,BCXH1_FULL,DH01A,BPMH1,DH01B,MIRLHU,DH01C,BCXH2_FULL,DH02A,CEHTR,DH02B,YAGH1,DH02C,UMHTR_FULL,DH02D,YAGH2,DH02E,BCXH3_FULL,DH03A,MIRLHD,DH03B,BPMH2,DH03C,BCXH4_FULL,CNTHTR,LHENDB];
%ENDCOMMENT
% %simplified
% HTR=[BEGHTR,D0H00,Q0H01,Q0H01,D0H01,Q0H02,Q0H02,D0H02,Q0H03,Q0H03,D0H03,Q0H04,Q0H04,D0H04,Q0H05,Q0H05,D0H05,Q0H06,Q0H06,D0H06,Q0H07,Q0H07,D0H07,Q0H08,Q0H08,D0H08,LSRHTR,DHD00,QHD01,QHD01,DHD01,QHD02,QHD02,DHD02,QHD03,QHD03,DHD03,QHD04,QHD04,DHD04,ENDHTR];

%COMMENT complete
HTR=[BEGHTR,D0H00A,RFB0H00,D0H00B,PC0H00,D0H00C,Q0H01_FULL,D0H01A,YC0H01,D0H01B,Q0H02_FULL,D0H02A,XC0H01,D0H02B,DP0H01,D0H02C,DP0H02,D0H02D,DP0H03,D0H02E,XC0H03,D0H02F,Q0H03_FULL,D0H03A,YC0H03,D0H03B,Q0H04_FULL,D0H04A,RFB0H04,D0H04B,OTR0H04_FULL,D0H04C,WS0H04,D0H04D,BZ0H04,D0H04E,Q0H05_FULL,D0H05A,YC0H05,D0H05B,Q0H06_FULL,D0H06A,XC0H05,D0H06B,XC0H07,D0H06C,Q0H07_FULL,D0H07A,YC0H07,D0H07B,Q0H08_FULL,D0H08A,RFB0H08,D0H08B,LSRHTR,DHD00A,RFBHD00,DHD00B,QHD01_FULL,DHD01A,YCHD01,DHD01B,XCHD01,DHD01C,QHD02_FULL,DHD02A1,IMBCSI1,DHD02A2,IMBCSI2,DHD02A3,YCHD03,DHD02B,QHD03_FULL,DHD03A,XCHD03,DHD03B,QHD04_FULL,DHD04A,RFBHD04,DHD04B,ENDHTR];
%ENDCOMMENT
% %simplified
% COL0=[BEGCOL0,DC000,QC001,QC001,DC001,QC002,QC002,DC002,QC003,QC003,DC003,QC004,QC004,DC004,QC005,QC005,DCOLL0,QC006,QC006,DCOLL0,QC007,QC007,DCOLL0,QC008,QC008,DCOLL0,QC009,QC009,DCOLL0,QC010,QC010,DCOLL0,QC011,QC011,DC011,QC012,QC012,DC012,ENDCOL0];

%COMMENT complete
COL0=[BEGCOL0,DBKRDG0A,DBKRDG0B,DC000AA,BPMDG000,DC000AB,DBLRDG0A,DBLRDG0B,DC000B,SCC000,DC000C,QC001_FULL,DC001,QC002_FULL,DC002,QC003_FULL,DC003A,YCC003,DC003B,QC004_FULL,DC004A,XCC004,DC004B,CYC01,DC004C,QC005_FULL,DCOLL0A,YCC005,DCOLL0B,CXC01,DCOLL0C,QC006_FULL,DCOLL0A,XCC006,DCOLL0B1,OTRC006_FULL,DCOLL0B2,WSC006,DCOLL0B3,RFBC006,DCOLL0B4,CYC02,DCOLL0C,QC007_FULL,DCOLL0A,YCC007,DCOLL0B5,CXC02,DCOLL0C,QC008_FULL,DCOLL0A,XCC008,DCOLL0B,CYC03,DCOLL0C,QC009_FULL,DCOLL0A,YCC009,DCOLL0B,CXC03,DCOLL0C,QC010_FULL,DC010A,XCC010,DC010B,RFBC011,DC010C,QC011_FULL,DC011A,YCC011,DC011B,XCC012,DC011C,QC012_FULL,DC012,ENDCOL0];
%ENDCOMMENT
C0FODO=[QFCOLL0,DCOLL0,QDCOLL0,QDCOLL0,DCOLL0,QFCOLL0];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc bunch compressor chicane #1
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-JUL-2025, M. Woodley
%  * relocate and undefer BZC1 per S. Kaminski
% ------------------------------------------------------------------------------
% 17-JAN-2021, M. Woodley
%  * new standard configuration per Y. Ding
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
AB1 =  -0.100916987733 ;%R56=0.053
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
KQ1C01 =  0.964583578003;
Q1C01={'qu' 'Q1C01' LQX/2 [KQ1C01 0]}';
% BC1 chicane
KCQ11 =  0;
KSQ13 =  0;
KCQ12 =  0;
CQ11B={'qu' 'CQ11B' LQC/2 [KCQ11 0]}';
SQ13B={'dr' '' LQSB/2 []}';
CQ12B={'qu' 'CQ12B' LQC/2 [KCQ12 0]}';
% collimation FODO
KQCOLL1 =  1.787850470726  ;%45 degree FODO
% BminColl1 := 6.996145818354
% BmaxColl1 := 15.616293369747
QFCOLL1={'qu' 'QFCOLL1' LQX/2 [KQCOLL1 0]}';
QDCOLL1={'qu' 'QDCOLL1' LQX/2 [-KQCOLL1 0]}';
% COL1 collimation section
KQC101 =  -0.253291436015;
KQC102 =   2.152128604228;
KQC103 =   0.0;
KQC104 =  -1.217269485938;
KQC105 =  -1.49025394442;
KQC106 =   KQCOLL1;
KQC107 =  -KQCOLL1;
KQC108 =   KQCOLL1;
KQC109 =  -KQCOLL1;
KQC110 =   1.391771237954 ;% KQColl1
KQC111 =  -1.792321987609;
KQC112 =   1.3045216513;
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
D1C00={'dr' '' 2.06962 []}';
D1C01={'dr' '' 0.478 []}';
D1C00A={'dr' '' 1.92562 []}';
D1C00B={'dr' '' D1C00{3}-D1C00A{3} []}';
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
% BC1 chicane to COL1
DC100={'dr' '' 0.637 []}';
DC100A={'dr' '' 0.3 []}';
DC100B={'dr' '' DC100{3}-DC100A{3} []}';
% collimation FODO
DCOLL1={'dr' '' 4.0-LQX []}';
% COL1 collimation section
DC101={'dr' '' 7.95 []}';
DC102={'dr' '' 0.8 []}';
DC103={'dr' '' 2.75 []}';
DC104={'dr' '' 4.316831888391 []}';
DC112={'dr' '' 2.545948 []}';%0.38415+2.161798
DC101A={'dr' '' 0.214288 []}';
DC101B={'dr' '' 0.169862 []}';
DC101C={'dr' '' 0.25 []}';
DC101D={'dr' '' 3.30563 []}';
DC101E={'dr' '' DC101{3}-DC101A{3}-DC101B{3}-DC101C{3}-DC101D{3} []}';
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
DC112B={'dr' '' DC112{3}-DC112A{3} []}';
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
RFB1C01={'dr' '' 0 []}';
BPM11B={'mo' 'BPM11B' 0 []}';%RFB11 : MONI, TYPE="@2,CavityL-1"
RFBC104={'dr' '' 0 []}';
RFBC106={'dr' '' 0 []}';
RFBC108={'dr' '' 0 []}';
RFBC110={'dr' '' 0 []}';
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
% collimators (betatron X/Y half-apertures are 27/18 sigma for 1 um normalized
% emittance; default out-of-plane half-aperture is 20 mm)
CE11B={'dr' 'CE11B' LJAW []}';%X momentum collimator
CYC11={'dr' 'CYC11' LJAW []}';%Y betatron collimator
CXC11={'dr' 'CXC11' LJAW []}';%X betatron collimator
CYC12={'dr' '' LJAW []}';%Y betatron collimator
CXC12={'dr' '' LJAW []}';%X betatron collimator
CYC13={'dr' 'CYC13' LJAW []}';%Y betatron collimator
CXC13={'dr' 'CXC13' LJAW []}';%X betatron collimator
% instruments
OTR11B={'mo' 'OTR11B' 0 []}';%BC1 energy spread
WS11B={'dr' '' 0 []}';%BC1 energy spread
BZ11B={'mo' 'BZ11B' 0 []}';%CSR-based relative bunch length monitor
IM11B={'mo' 'IM11B' 0 []}';%Beam Current Monitor
BZC1={'mo' 'BZC1' 0 []}';%relative bunch length monitor
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
BC1I0=[BEGBC1B,D1C00,Q1C01,Q1C01,D1C01];
BC1I=[BEGBC1B,D1C00A,SC1C00,D1C00B,Q1C01_FULL,D1C01A,RFB1C01,D1C01B];
BC1C0=[BC1BCBEG,BCX11A,BCX11B,DC1O,BCX12A,BCX12B,DC1IH,BC1BCMID,DC1IH,BCX13A,BCX13B,DC1O,BCX14A,BCX14B,BC1BCEND];
BC1C=[BC1BCBEG,BCX11_FULL,DC1OA,CQ11B_FULL,DC1OB,YCM12B,DC1OC,BCX12_FULL,DC1IA,BPM11B,DC1IB,CE11B,DC1IC,OTR11B,DC1ID,WS11B,DC1IE,BCX13_FULL,DC1OD,SQ13B_FULL,DC1OE,XCM12B,DC1OF,CQ12B_FULL,DC1OG,BCX14_FULL,CNTBC1,BC1BCEND];
BC1O0=[DC100,ENDBC1B];
BC1O=[DC100A,BZ11B,DC100B,ENDBC1B];
BC1=[BC1I,BC1C,BC1O];
% %simplified
% COL1=[BEGCOL1,QC101,QC101,DC101,QC102,QC102,DC102,QC103,QC103,DC103,QC104,QC104,DC104,QC105,QC105,DCOLL1,QC106,QC106,DCOLL1,QC107,QC107,DCOLL1,QC108,QC108,DCOLL1,QC109,QC109,DCOLL1,QC110,QC110,DCOLL1,QC111,QC111,DCOLL1,QC112,QC112,DC112,ENDCOL1];

%COMMENT complete
COL1=[BEGCOL1,QC101_FULL,DC101A,IM11B,DC101B,XCC101,DC101C,YCC101,DC101D,BZC1,DC101E,QC102_FULL,DC102,QC103_FULL,DC103,QC104_FULL,DC104A,XCC104,DC104B,RFBC104,DC104C,WSC104,DC104D,CYC11,DC104E,QC105_FULL,DC105A,YCC105,DC105B,CXC11,DC105C,QC106_FULL,DC106A,XCC106,DC106B,RFBC106,DC106C,WSC106,DC106D,CYC12,DC106E,QC107_FULL,DC107A,YCC107,DC107B,CXC12,DC107C,QC108_FULL,DC108A,XCC108,DC108B,RFBC108,DC108C,WSC108,DC108D,CYC13,DC108E,QC109_FULL,DC109A,YCC109,DC109B,CXC13,DC109C,QC110_FULL,DC110A,XCC110,DC110B,RFBC110,DC110C,WSC110,DC110D,QC111_FULL,DC111A,YCC111,DC111B,QC112_FULL,DC112A,XCC112,DC112B,ENDCOL1];
%ENDCOMMENT
C1FODO=[QFCOLL1,DCOLL1,QDCOLL1,QDCOLL1,DCOLL1,QFCOLL1];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc bunch compressor chicane #2
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-NOV-2024, M. Woodley
%  * adjust L3B area boundary location per vacuum drawing revision
% ------------------------------------------------------------------------------
% 17-JAN-2021, M. Woodley
%  * new standard configuration per Y. Ding
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
AB2 =  0.046846250848 ;%R56=0.045
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
KQ2C01 =  0.510742626723;
Q2C01={'qu' 'Q2C01' LQX/2 [KQ2C01 0]}';
% BC2 chicane
KCQ21 =  0;
KCQ22 =  0;
CQ21B={'qu' 'CQ21B' LQC/2 [KCQ21 0]}';
CQ22B={'qu' 'CQ22B' LQC/2 [KCQ22 0]}';
% match into L3
KQE201 =  -1.302578004949;
KQE202 =   1.990185768694;
KQE203 =  -2.035694933515;
KQE204 =   1.984107437335;
QE201={'qu' 'QE201' LQX/2 [KQE201 0]}';
QE202={'qu' 'QE202' LQX/2 [KQE202 0]}';
QE203={'qu' 'QE203' LQX/2 [KQE203 0]}';
QE204={'qu' 'QE204' LQX/2 [KQE204 0]}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% L2 to BC2 chicane
D2C00={'dr' '' 3.108252011609 []}';
D2C01={'dr' '' 0.5 []}';
D2C00A={'dr' '' 0.039882 []}';
D2C00C={'dr' '' 0.338951 []}';
D2C00D={'dr' '' 0.321049 []}';
D2C00B={'dr' '' D2C00{3}-D2C00A{3}-D2C00C{3}-D2C00D{3} []}';
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
% BC2 chicane to EMIT2
D2C02={'dr' '' 1.050338 []}';
D2C02A={'dr' '' 0.687372 []}';
D2C02B={'dr' '' D2C02{3}-D2C02A{3} []}';
% match into L3
LEMIT2 =  31.224348 ;%28.859648+2.3627
DE201={'dr' '' 4.906343360384 []}';
DE202A={'dr' '' 10.974020455558 []}';
DE203={'dr' '' 3.0 []}';
DE204={'dr' '' 3.035216558157 []}';%3.033216558157
DE202B={'dr' '' LEMIT2-4*LQX-D2C02{3}-DE201{3}-DE202A{3}-DE203{3}-DE204{3} []}';
DE202={'dr' '' DE202A{3}+DE202B{3} []}';
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
RFB2C01={'dr' '' 0 []}';
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
WS21B={'dr' '' 0 []}';%BC2 energy spread
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
BC2I0=[BEGBC2B,D2C00,Q2C01,Q2C01,D2C01];
BC2I=[BEGBC2B,D2C00A,RFB2C00,D2C00B,XC2C00,D2C00C,YC2C00,D2C00D,Q2C01_FULL,D2C01A,RFB2C01,D2C01B];
BC2C0=[BC2BCBEG,BCX21A,BCX21B,DC2O,BCX22A,BCX22B,DC2IH,BC2BCMID,DC2IH,BCX23A,BCX23B,DC2O,BCX24A,BCX24B,BC2BCEND];
BC2C=[BC2BCBEG,BCX21_FULL,DC2OA,CQ21B_FULL,DC2OB,BCX22_FULL,DC2IA,BPM21B,DC2IB,CE21B,DC2IC,OTR21B,DC2ID,WS21B,DC2IE,BCX23_FULL,DC2OC,CQ22B_FULL,DC2OD,BCX24_FULL,CNTBC2,BC2BCEND];
BC2O0=[D2C02,ENDBC2B];
BC2O=[D2C02A,BZ21B,D2C02B,ENDBC2B];
BC2=[BC2I,BC2C,BC2O];
EMIT2=[BEGEMIT2,QE201_FULL,DE201A,YCE201,DE201B,IM21B,DE201C,QE202_FULL,DE202A1,XCE202,DE202A2,WSEMIT2,DE202B,QE203_FULL,DE203A,YCE203,DE203B,QE204_FULL,DE204A,XCE204,DE204B,ENDEMIT2];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc linac extension: end of L3 to start of bypass dogleg
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 30-NOV-2024, M. Woodley
%  * adjust EXT area boundary locations per vacuum drawing revision
% ------------------------------------------------------------------------------
% 12-JAN-2024, M. Woodley
%  * move BEGEXT to Z=641.320 per S. Saraf
% ------------------------------------------------------------------------------
% 15-JUL-2022, M. Woodley
%  * rematch around dead QCM34
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
KQX01 =   1.086322764474 ;% 1.086585717518
KQX02 =  -0.973893330891 ;%-0.973239864775
QX01={'qu' 'QX01' LQE/2 [KQX01 0]}';
QX02={'qu' 'QX02' LQE/2 [KQX02 0]}';
% %GL < 106 kG for QEs
% 
% 

% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
LLDX =  23.2233-2*LQE ;%21 m particle-free before CCDLU 2.3473
DX00={'dr' '' 8.0233 []}';
DX02={'dr' '' 5.8 []}';
DX01={'dr' '' LLDX-DX00{3}-DX02{3} []}';
DX00A={'dr' '' 0.24 []}';%0.364
DX00B={'dr' '' 0.48 []}';
DX00C={'dr' '' 0.99 []}';%1.01
DX00D={'dr' '' DX00{3}-DX00A{3}-DX00B{3}-DX00C{3} []}';
DX01A={'dr' '' 0.4-LQE/2 []}';
DX01C={'dr' '' 0.2 []}';
DX01B={'dr' '' DX01{3}-DX01A{3}-DX01C{3} []}';
DX02A={'dr' '' 0.31-LQE/2 []}';
DX02B={'dr' '' 5.2101 []}';%DX02[L]-DX02a[L]-DX02c[L]
DX02C={'dr' '' 0.1 []}';
% ==============================================================================
% BPMs
% ------------------------------------------------------------------------------
BPMX01={'mo' 'BPMX01' 0 []}';
BPMX02={'mo' 'BPMX02' 0 []}';
RFBX02={'dr' '' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XCX01={'mo' 'XCX01' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YCX02={'mo' 'YCX02' 0 []}';
% ==============================================================================
% MARK, etc.
% ------------------------------------------------------------------------------
VPEXT1={'mo' 'VPEXT1' 0 []}';
VPEXT2={'mo' 'VPEXT2' 0 []}';
FSEXT={'mo' 'FSEXT' 0 []}';
VGEXTD={'mo' 'VGEXTD' 0 []}';
VVEXTD={'mo' 'VVEXTD' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
QX01_FULL=[QX01,BPMX01,QX01];
QX02_FULL=[QX02,BPMX02,QX02];
EXT0=[BEGEXT,DX00,QX01,QX01,DX01,QX02,QX02,DX02,ENDEXT];
EXT=[BEGEXT,DX00A,VPEXT1,DX00B,VPEXT2,DX00C,FSEXT,DX00D,QX01_FULL,DX01A,XCX01,DX01B,RFBX02,DX01C,QX02_FULL,DX02A,YCX02,DX02B,VGEXTD,DX02C,VVEXTD,ENDEXT];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc sector 7 dogleg plus match to bypass line
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 19-SEP-2023, M. Woodley
%  * add XCBP10 upstream of sector 10 shield wall per C. Yi and L. Alsberg
% ------------------------------------------------------------------------------
% 03-FEB-2023, M. Woodley
%  * relocate YCL2P per M. Gaydosh
% ------------------------------------------------------------------------------
% 09-SEP-2022, M. Woodley
%  * redefine (deferred) OTR31
% 20-JUN-2022, M. Woodley
%  * correct location and thickness of Sector 10 (FACET) wall (concrete only)
%    per L.Borzenets email of Thursday, February 24, 2022 11:50 AM
% ------------------------------------------------------------------------------
% 12-JUL-2021, M. Woodley
%  * move XCBP11 10" downstream per T. Fak
% ------------------------------------------------------------------------------
% 11-MAY-2021, M. Woodley
%  * correct spacing of 2Q4/BPM/XCOR/YCOR per ID drawings
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
% match into bypass dogleg FODO cell (at center of QDOG1)
% LINE=(QDOG1,DBD1,QDOG2,QDOG2,DBD1,QDOG1)
BXDLM =  13.103975995473;
AXDLM =  -1.328121315284;
BYDLM =  15.962707890974;
AYDLM =   1.529775364964;
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
SDOG1={'dr' '' LSB/2 []}';
SDOG2={'dr' '' LSB/2 []}';
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
DLDBD =  -0.12481688608E-4    ;%adjustment for dispersion correction
LDBDH =  LDBD/2+DLDBD         ;%FODO cell half length
DBDM0={'dr' '' 0.2333 []}';%drift between VVEXTD and CCDLU
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
LLTOT =  99.751028062384;
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
DL2PB={'dr' '' 1.245325 []}';%0.6368
DL2PC={'dr' '' LL2-DL2PA{3}-DL2PB{3} []}';
DL3PA={'dr' '' 0.4598 []}';
DL3PB={'dr' '' 0.7433 []}';
DL3PC={'dr' '' 5.9032251 []}';
DL3PD={'dr' '' LL3-DL3PA{3}-DL3PB{3}-DL3PC{3} []}';
DL4PA={'dr' '' 0.4598 []}';
DL4PB={'dr' '' 0.7433 []}';
DL4PC={'dr' '' LL4-DL4PA{3}-DL4PB{3} []}';
DBPA={'dr' '' 0.44518 []}';%0.4598
DBPB={'dr' '' 0.62865 []}';%0.7433
DBPC={'dr' '' DBP{3}-DBPA{3}-DBPB{3} []}';
DBPE={'dr' '' 0.1 []}';
DBPF={'dr' '' 1.0 []}';
DBPD={'dr' '' DBP{3}-DBPA{3}-DBPB{3}-DBPE{3}-DBPF{3} []}';
DBPB1={'dr' '' DBPB{3}+0.38327 []}';
DBPC1={'dr' '' DBPC{3}-0.38327 []}';
DBPD1={'dr' '' 21.516667 []}';
DBPD1A={'dr' '' 3.950667 []}';%30*in2m
DBPD1B={'dr' '' DBPD1{3}-DBPD1A{3} []}';
S10WALL={'dr' '' 1.848 []}';
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
RFBWSBP1={'dr' '' 0 []}';
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
XCBP10={'mo' 'XCBP10' 0 []}';
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
WSDOG={'dr' '' 0 []}';
WSBP1={'mo' 'WSBP1' 0 []}';
% combination OTR/YAG PSI type
OTR31={'dr' '' 0 []}';
OTR31_YAG={'dr' '' 0 []}';
OTR31_FULL=[OTR31,OTR31_YAG];
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
% MTCH1=[DLCCP,CCDLD,DL0P,QL1P,QL1P,DL1P,QL2P,QL2P,DL2P,QL3P,QL3P,DL3P,QL4P,QL4P,DL4P,QL5P,QL5P,DBP,DBP,QBP10,QBP10,DBPA,DBPB,DBPD,DBPE,WSBP1,DBPF,DBP,QBP11,QBP11,DBP,DBP,QBP12,QBP12,DBPA,DBPB,DBPD];

%COMMENT complete
MTCH1=[DLCCP,CCDLD,DL0PA,OTR31_FULL,DL0PB,QL1P_FULL,DL1PA,BPML1P,DL1PB,XCL1P,DL1PC,QL2P_FULL,DL2PA,BPML2P,DL2PB,YCL2P,DL2PC,QL3P_FULL,DL3PA,BPML3P,DL3PB,XCL3P,DL3PC,BPN09BEG,DL3PD,QL4P_FULL,DL4PA,BPML4P,DL4PB,YCL4P,DL4PC,QL5P_FULL,DBPA,BPML5P,DBPB,XCL5P,DBPC,DBPSA,BPN09END,BPN10BEG,DBPSB,QBP10_FULL,DBPA,BPMBP10,DBPB,YCBP10,DBPD1A,XCBP10,DBPD1B,S10WALL,DBPD2,RFBWSBP1,DBPE,WSBP1,DBPF,DBPSA,BPN10END,BPN11BEG,DBPSB,QBP11_FULL,DBPA,BPMBP11,DBPB1,XCBP11,DBPC1,DBPSA,BPN11END,BPN12BEG,DBPSB,QBP12_FULL,DBPA,BPMBP12,DBPB,YCBP12,DBPD];
%ENDCOMMENT
DLBM=[BEGDOG,DBDM0,CCDLU,DBDM1,DLBP,MTCH1,ENDDOG];
BFODO=[QBPF,DBP,DBP,QBPD,QBPD,DBP,DBP,QBPF];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc 3-way spreader system
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 19-APR-2025, M. Woodley
%  * relocate (deferred) IMBCSS1/2, IMBCSH1/2, and IMBCSD1/2 per N. Balakrishnan
% ------------------------------------------------------------------------------
% 05-FEB-2025, M. Woodley
%  * defer (level=4) YCSP0D and XCSP0D ... not installed
% ------------------------------------------------------------------------------
% 08-AUG-2024, M. Woodley
%  * add YCSP0D and XCSP0D ("Bypass#3") per T. Smith
% 25-JAN-2024, M. Woodley
%  * remove (deferred) rastering in BSY dump line
%    > rename BKXRASD to XCSP5D (already installed type-4)
%    > rename BKYRASD to YCSP6D (already installed type-4)
%    > remove deferred type-5 correctors XCSP5D and YCSP6D
%    > remove DC spreader option
% ------------------------------------------------------------------------------
% 12-SEP-2023, M. Woodley
%  * relocate some spreader BPMs per G. Gassner (|dZ| > 10 mm)
%    (Final Magnet Results Organzized per BeamlineR3.xlsx)
%  * don't relocate QSP11H (dZ=-10.088mm) or QSP8S (dZ=-13.672mm) ... symmetry
% ------------------------------------------------------------------------------
% 29-AUG-2022, M. Woodley
%  * defer (level 0) XCSP5d and YCSP6d ... these have not been installed
% 05-APR-2022, M. Woodley
%  * move OTRSPDMP 3 inches upstream per L. Borzenets
% ------------------------------------------------------------------------------
% 02-DEC-2021, M. Woodley
%  * relocate SPH and SPS sextupoles per L. Borzenets; rematch
%  * relocate four XCOR's and two BPM's due to sextupole relocations
% 06-OCT-2021, M. Woodley
%  * change TYPE for BKXRASd and BKYRASd to "class-4" per A. Ibrahimov
% ------------------------------------------------------------------------------
% 20-JUL-2021, M. Woodley
%  * quad strength changes for Yuri's "symmetric" SPRDs/SPRDh match
% ------------------------------------------------------------------------------
% 28-APR-2021, M. Woodley
%  * move YCSP4S 10" upstream per T. Fak
%  * move XCSP1D 18" upstream per T. Fak
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
%  * use measured FINT for 1.0D22.625's
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
TBXSP =  111.2796938491;
TAXSP =    2.930243793946;
TBYSP =   60.000000012297;
TAYSP =    0.853023050724;
% XYZ (linac system) at the end of HXR merge bend BXSP1h
XSPH =   0.0;
YSPH =   0.0;
ZSPH =   3110.961492;
THSPH =   0.0;
PHSPH =   0.0;
PSSPH =   0.0;
% HXR quads
KQSP1H =   0.492324446747;
KQSP2H =  -1.001967523398;
KQSP3H =   0.304769059951;
KQSP4H =  -0.300033974381;
KQSP5H =   0.179267068866;
KQSP6H =  -0.222726806069;
KQSP7H =   0.448434480039;
KQSP8H =   KQSP6H;
KQSP9H =   KQSP5H;
KQSP10H =   KQSP4H;
KQSP11H =   KQSP3H;
KQSP12H =  -1.001082746242;
KQSP13H =   KQSP1H;
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
KSSP1H =  -21.401561081554;
KSSP2H =   22.882390278955;
TSSP1H =   15.406381139353;
TSSP2H =   18.068719010023;
SSP1H={'dr' '' LSB/2 []}';
SSP2H={'dr' '' LSB/2 []}';
% 
% 
% 

% SXR & dumpline shared quads
KQSP1 =   0.527387331122 ;% 0.52687626083
KQSP2 =  -0.521830425335 ;%-0.521500809125
QSP1={'qu' 'QSP1' LQR/2 [KQSP1 0]}';
QSP2={'qu' 'QSP2' LQR/2 [KQSP2 0]}';
% SXR quads
KQSP1S =   0.633590523785 ;% 0.633592368552
KQSP2S =  -0.558567412631 ;%-0.558572403531
KQSP3S =   0.652093672384 ;% 0.652091326391
KQSP4S =  -0.497969054816 ;%-0.497963158567
KQSP5S =   0.184547704815 ;% 0.184546784571
KQSP6S =   KQSP4S;
KQSP7S =   KQSP3S;
KQSP8S =   KQSP2S;
KQSP9S =   KQSP1S;
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
SSP1S={'dr' '' LSB/2 []}';
SSP2S={'dr' '' LSB/2 []}';
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
BKYSP0HA={'dr' '' LBKYSP0H/2 []}';
BKYSP0HB={'dr' '' LBKYSP0H/2 []}';
BKYSP4HA={'dr' '' LBKYSP4H/2 []}';
BKYSP4HB={'dr' '' LBKYSP4H/2 []}';
GBKYSP5H =  0.035;
ZBKYSP5H =  1.0;
LBKYSP5H =  ZBKYSP5H/cos(ABKYSPH);
BKYSP5HA={'dr' '' LBKYSP5H/2 []}';
BKYSP5HB={'dr' '' LBKYSP5H/2 []}';
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
BKYSP0SA={'dr' '' LBKYSP0S/2 []}';
BKYSP0SB={'dr' '' LBKYSP0S/2 []}';
BKYSP4SA={'dr' '' LBKYSP4S/2 []}';
BKYSP4SB={'dr' '' LBKYSP4S/2 []}';
GBKYSP5S =  0.035;
ZBKYSP5S =  1.0;
LBKYSP5S =  ZBKYSP5S/cos(ABKYSPS);
BKYSP5SA={'dr' '' LBKYSP5S/2 []}';
BKYSP5SB={'dr' '' LBKYSP5S/2 []}';
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
BKYSP0H={'dr' '' LBKYSP0H []}';
BKYSP1H={'be' 'BKYSP1H' LBKYSP1H [ABKYSP1H GBKYSP/2 0 ABKYSP1H 0.5 0.5 pi/2]}';
BKYSP2H={'be' 'BKYSP2H' LBKYSP2H [ABKYSP2H GBKYSP/2 -ABKYSP1H ABKYSP12H 0.5 0.5 pi/2]}';
BKYSP3H={'be' 'BKYSP3H' LBKYSP3H [ABKYSP3H GBKYSP/2 -ABKYSP12H ABKYSPH 0.5 0.5 pi/2]}';
BKYSP4H={'dr' '' LBKYSP4H []}';
BKYSP5H={'dr' '' LBKYSP5H []}';
BLXSPH={'be' 'BLXSPH' LBLXSPH [ABLXSPH GBLXSP/2 0 ABLXSPH 0.5 0.5 0]}';
BYSP1H={'be' 'BYSP1H' LBCSP1H [ABCSP1H GBCSP/2 ABCSP1H/2 ABCSP1H/2 FBCSP FBCSP pi/2]}';
BYSP2H={'be' 'BYSP2H' LBCSP2H [ABCSP2H GBCSP/2 ABCSP2H/2 ABCSP2H/2 FBCSP FBCSP pi/2]}';
BRSP1H={'be' 'BRSP1H' LBRSPH [ABRSPH GBSP/2 ABRSPH/2 ABRSPH/2 FBSP FBSP TBRSPH]}';
BRSP2H={'be' 'BRSP2H' LBRSPH [-ABRSPH GBSP/2 -ABRSPH/2 -ABRSPH/2 FBSP FBSP TBRSPH]}';
BXSP1H={'be' 'BXSP1H' LBXSPH [ABXSPH GBSP/2 ABXSPH/2 ABXSPH/2 FBSP FBSP 0]}';
BKYSP0S={'dr' '' LBKYSP0S []}';
BKYSP1S={'be' 'BKYSP1S' LBKYSP1S [ABKYSP1S GBKYSP/2 0 ABKYSP1S 0.5 0.5 pi/2]}';
BKYSP2S={'be' 'BKYSP2S' LBKYSP2S [ABKYSP2S GBKYSP/2 -ABKYSP1S ABKYSP12S 0.5 0.5 pi/2]}';
BKYSP3S={'be' 'BKYSP3S' LBKYSP3S [ABKYSP3S GBKYSP/2 -ABKYSP12S ABKYSPS 0.5 0.5 pi/2]}';
BKYSP4S={'dr' '' LBKYSP4S []}';
BKYSP5S={'dr' '' LBKYSP5S []}';
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
LDSPBK1H =  LDSPBK   /cos(ABKYSP1H);
LDSPBK2H =  LDSPBK   /cos(ABKYSP12H);
LDSPBK3H =  LDSPBK   /cos(ABKYSPH);
LDSPBK4H =  LDSPBK   /cos(ABKYSPH);
LDSPBK5H =  15.1     /cos(ABKYSPH);
LDSPBK5HA =   2.204627/cos(ABKYSPH);
LDSPBK5HB =  LDSPBK5H-LDSPBK5HA;
DSPBK0H={'dr' '' LDSPBK0H []}';
DSPBK1H={'dr' '' LDSPBK1H []}';
DSPBK2H={'dr' '' LDSPBK2H []}';
DSPBK3H={'dr' '' LDSPBK3H []}';
DSPBK4H={'dr' '' LDSPBK4H []}';
DSPBK5HA={'dr' '' LDSPBK5HA []}';
DSPBK5HB={'dr' '' LDSPBK5HB []}';
DLMDW =  0;
DLDSP2H =  0.0;
LDSP2H =  43.284 +DLDSP2H;
LDSP2HB =  10.0;
LDSP2HC =  0.5285;
LDSP2HA =  LDSP2H-LDSP2HB-LDSP2HC-LBCSP1H-LBCSP2H;
DLDSP3H =  0.0;
LDSP3H =  4.6611 +DLDSP3H;
LDSP3HA =  0.701153024135 ;%LDSPBPM1
LDSP3HAA =  0.1443452812   ;%0.1
LDSP3HAB =  LDSP3HA-LDSP3HAA-LSB;
LDSP3HB =  0.636709727546 ;%0.6368
LDSP3HD =  0.1924;
LDSP3HC =  LDSP3H-LDSP3HA-LDSP3HB-LDSP3HD;
DLDSP4H =  0.012085492416;
LDSP4H =  9.5126 -DLDSP2H-DLDSP3H+DLDSP4H;
LDSP4HA =  0.4;
LDSP4HC =  0.3459992;
LDSP4HB =  LDSP4H-LDSP4HA-LDSP4HC;
DLDSP5H =  0.0 ;%adjust position of QSP3h,QSP11h
LDSP5H =  14.474 +(LQN-LQA)/2 +DLDSP5H;
LDSP5HA =  1.261892512166 ;%1.424131
LDSP5HC =  0.799538487834 ;%LDSPCOR2 +(LQN-LQA)/2
LDSP5HCB =  0.234535460174 ;%0.1 +(LQN-LQA)/2
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
LDSP14HA =  13.863119 +(LQN-LQA)/2 +DLMDW;
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
DSP10HC1={'dr' '' 0.727063518229 []}';
DSP10HC2={'dr' '' 0.306071799451 []}';
DSP10HC3={'dr' '' LDSP10HC-DSP10HC1{3}-DSP10HC2{3} []}';
DSP10HD={'dr' '' LDSP10HD []}';
DSP11HA={'dr' '' LDSP11HA []}';
DSP11HB={'dr' '' LDSP11HB []}';
DSP11HC={'dr' '' LDSP11HC []}';
DSP12HA={'dr' '' LDSP12HA []}';
DSP12HB={'dr' '' LDSP12HB []}';
DSP12HC={'dr' '' LDSP12HC []}';
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
LDSPQ1A =  22.923172 ;%23.0
LDSPQ1C =  LDSPCOR1;
LDSPQ1B =  LDSPQ1-LDSPQ1A-LDSPQ1C;
DLDSPQ2 =  0.0;
LDSPQ2 =  1.8 +DLDSPQ2;
LDSPQ2A =  0.5913;
LDSPQ2C =  0.511861 ;%0.4781
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
LDSPBK1S =  LDSPBK    /cos(ABKYSP1S);
LDSPBK2S =  LDSPBK    /cos(ABKYSP12S);
LDSPBK3S =  LDSPBK    /cos(ABKYSPS);
LDSPBK4S =  LDSPBK    /cos(ABKYSPS);
LDSPBK5S =  15.1      /cos(ABKYSPS);
LDSPBK5SA =   2.2261635/cos(ABKYSPS);
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
LDSP3SA =  0.7912067845   ;%LDSPBPM2 +(LQN-LQA)/2
LDSP3SAA =  0.234475817809 ;%0.1 +(LQN-LQA)/2
LDSP3SAB =  LDSP3SA-LDSP3SAA-LSB;
LDSP3SB =  0.600136674875 ;%0.6445
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
LDSP6SC =  LDSPCOR1+10*IN2M ;%move 10" u/s per T. Fak
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
LDSP12SC =  0.73889094850  ;%LDSPCOR2 +(LQN-LQA)/2
LDSP12SCA =  0.404427770474 ;%0.1 +(LQN-LQA)/2
LDSP12SCB =  LDSP12SC-LDSP12SCA-LSB;
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
DSP13SB1={'dr' '' 24.621217338532 []}';%9.337992506693
DSP13SB2={'dr' '' 0.30601870107 []}';%0.30541
DSP13SB3={'dr' '' DSP13SB{3}-DSP13SB1{3}-DSP13SB2{3} []}';%7.165028811982
LDSP2DA2 =  2.0;
LDSP2DA1 =  23.0-4.457-LDSP2DA2 ;%adjusted for DASEL
LDSP2DB =  1.657;
LDSP2DC1 =  27.25 +3.685 ;%adjustment for DASEL with 25G kickers
LDSP2DD =  LDSPCOR1+18*IN2M ;%move 18" u/s per T. Fak
DLDSP3D =  0.0;
LDSP3D =  3.317 +DLDSP3D;
LDSP3DA =  LDSPBPM1;
LDSP3DB =  0.6234;
LDSP3DD =  0.812098 ;%0.4781+0.3048 =0.7829
LDSP3DC =  LDSP3D-LDSP3DA-LDSP3DB-LDSP3DD;
LDSP4D =  4.5085 -DLDSP3D;
LDSP4DA =  0.4285;
LDSP4DB =  LDSP4D-LDSP4DA;
LDSP2DC2 =  76.149-LDSP2DA1-LDSP2DA2-LDSP2DB-LDSP2DC1-LDSP2DD-LDSP3D-LDSP4D;
LDSP5D =  73.0 ;%distance between two bends
LDSP5DA =  6.2732486;
LDSP5DB =  45.575+1.0-LDSP5DA-LBYSPD/2;
LDSP5DD =  0.790152 ;%0.2298134+0.609623481 =0.839436881
LDSP5DC =  LDSP5D-LDSP5DA-LDSP5DB-LDSP5DD;
DLDSP6D =  0.0 ;%adjust Z at muon wall
LDSP6D =  143.648999999997-0.4 +18.115253 -0.761425 +DLDSP6D;
LDSP6DA =  0.5;
LDSP6DB =  0.5;
LDSP6DC =  1.0;
LDSP6DD =  0.3048;
LDSP6DE =  1.1952;
LDSP6DG =  1.0;
LDSP6DH =  0.5;
LDSP6DI =  37.0 +18.0 -0.761425;
LDSP6DF =  LDSP6D-LDSP6DA-LDSP6DB-LDSP6DC-LDSP6DD-LDSP6DE-LDSP6DG-LDSP6DH -LDSP6DI;
LDSP6DFA =  4.287828;
LDSP6DFB =  LDSP6DF-LDSP6DFA;
LDSP7D =  3.931424942571;
LDSP7DA =  0.4238;
LDSP7DB =  LDSP7D-LDSP7DA;
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
DSP5DC1={'dr' '' 1.329434073671 []}';%0.694411378263
DSP5DC2={'dr' '' 0.306011786418 []}';%0.30541
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
DSP6DG={'dr' '' LDSP6DG []}';
DSP6DH={'dr' '' LDSP6DH []}';
DSP6DI={'dr' '' LDSP6DI []}';
DSP6DIA={'dr' '' 14.358367 []}';%14.23155
DSP6DIB={'dr' '' LDSP6DI-DSP6DIA{3} []}';
DSP7DA={'dr' '' LDSP7DA []}';
DSP7DB={'dr' '' LDSP7DB []}';
DWALLAD={'dr' '' 1.840975 []}';%distance from face of muon wall to BSY dump
DDUMPBSY={'dr' '' 61.120*IN2M []}';%length of BSY dump (per A. Ibrahimov)
LDSP2DA1A =  12.033697;
LDSP2DA1B =  0.2286;
LDSP2DA1C =  LDSP2DA1-LDSP2DA1A-LDSP2DA1B;
DSP2DA1A={'dr' '' LDSP2DA1A []}';
DSP2DA1B={'dr' '' LDSP2DA1B []}';
DSP2DA1C={'dr' '' LDSP2DA1C []}';
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
BPMSP3D={'mo' 'BPMSP3D' 0 []}';%has been already ordered (should have been Stripline-11)
BPMSP4D={'mo' 'BPMSP4D' 0 []}';
BPMSP5D={'mo' 'BPMSP5D' 0 []}';%large aperture BPM
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
XCSP0D={'dr' '' 0 []}';
YCSP0D={'dr' '' 0 []}';
XCSP1D={'mo' 'XCSP1D' 0 []}';
XCSP3D={'mo' 'XCSP3D' 0 []}';
XCSP5D={'mo' 'XCSP5D' 0 []}';
YCSP2D={'mo' 'YCSP2D' 0 []}';
YCSP4D={'mo' 'YCSP4D' 0 []}';
YCSP6D={'mo' 'YCSP6D' 0 []}';
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
IMBCSH1={'dr' '' 0 []}';%BCS ACM doublet in SPH
IMBCSH2={'dr' '' 0 []}';%BCS ACM doublet in SPH
IMBCSS1={'dr' '' 0 []}';%BCS ACM doublet in SPS
IMBCSS2={'dr' '' 0 []}';%BCS ACM doublet in SPS
IMBCSD1={'dr' '' 0 []}';%BCS ACM doublet in SPD
IMBCSD2={'dr' '' 0 []}';%BCS ACM doublet in SPD
BTMSPDMP={'mo' 'BTMSPDMP' 0 []}';%Burn-Through-Monitor behind BSY dump
WSSP1D={'mo' 'WSSP1D' 0 []}';%to measure beam size and energy before BSY dump
OTRSPDMP={'dr' '' 0 []}';%OTR screen before BSY dump
% BSY wooden door
WOODDOOR_SPH={'mo' 'WOODDOOR_SPH' 0 []}';
WOODDOOR_SPD={'mo' 'WOODDOOR_SPD' 0 []}';
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
SPRDHA=[ROSP1H,DSP2HA,BYSP1H_FULL,DSP2HB,BYSP2H_FULL,CNTSP1H,DSP2HC,QSP1H_FULL,DSP3HAA,SSP1H_FULL,DSP3HAB,BPMSP1H,DSP3HB,XCSP1H,DSP3HC,DSP3HD,QSP2H_FULL,DSP4HA,YCSP2H,DSP4HB,IMSP0H,DSP4HC,BRSP1H_FULL,ROSP2H,DSP5HA,DSP5HB,XCSP3H,DSP5HCA,SSP2H_FULL,DSP5HCB,QSP3H_FULL,DSP6HA,BPMSP3H,DSP6HB,YCSP4H,DSP6HC,QSP4H_FULL,DSP7HA,BPMSP4H,DSP7HB,XCSP5H,DSP7HC,QSP5H_FULL,DSP8HA,BPMSP5H,DSP8HB,YCSP6H,DSP8HC,QSP6H_FULL,DSP9HA,BPMSP6H,DSP9HB,DSP9HC,DSP9HD,DSP9HE,DSP9HF,DSP9HG,QSP7H_FULL,DSP10HA,XCSP7H,DSP10HB,DSP10HC1,IMBCSH1,DSP10HC2,IMBCSH2,DSP10HC3,YCSP8H,DSP10HD,QSP8H_FULL,DSP11HA,BPMSP8H,DSP11HB,DSP11HC,QSP9H_FULL,DSP12HA,BPMSP9H,DSP12HB,XCSP9H,DSP12HC,BPMSP10H,DSP12HD,YCSP10H,DSP12HE,QSP10H_FULL,DSP13HA,XCSP11H,DSP13HB,BPMSP11H,DSP13HC,QSP11H_FULL,DSP14HA,WOODDOOR_SPH];
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
SPRDDA=[DSP2DA1A,YCSP0D,DSP2DA1B,XCSP0D,DSP2DA1C,MRFBSP1D,DSP2DA2,BPMSP1D,DSP2DB];
SPRDDB=[DSP2DC1];
BYSP1D_FULL=[BYSP1DA,BYSP1DB];
BYSP2D_FULL=[BYSP2DA,BYSP2DB];
QSP1D_FULL=[QSP1D,QSP1D];
QSP2D_FULL=[QSP2D,QSP2D];
SPRDDC=[DSP2DC2,XCSP1D,DSP2DD,QSP1D_FULL,DSP3DA,DSP3DB,IMSP0D,DSP3DC,MRFBSP2D,BPMSP2D,DSP3DD,QSP2D_FULL,DSP4DA,YCSP2D,DSP4DB,BYSP1D_FULL,DSP5DA,DSP5DB,WSSP1D,DSP5DC1,IMBCSD1,DSP5DC2,IMBCSD2,DSP5DC3,BPMSP3D,DSP5DD,BYSP2D_FULL,CNTSP1D,DSP6DA,XCSP3D,DSP6DB,YCSP4D,DSP6DC,DSP6DD,DSP6DE,DSP6DFA,WOODDOOR_SPD];
SPRDDD=[DSP6DFB,BPMSP4D,DSP6DG,RWWAKE3D,XCSP5D,DSP6DH,YCSP6D,DSP6DI,BPMSP5D,DSP7DA,OTRSPDMP,DSP7DB,MUWALLD,DWALLAD,DUMPBSY,DDUMPBSY,BTMSPDMP];
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

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc transport from Cu-linac to SXR
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 12-JUL-2021, Y. Nosochkov
%  * rematch CLTS R56
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
%  * replace 1.0D22.625 dipoles (BYCUS1&2) with 3D8.8MK3 corrector magnets
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
TBXCUS1 =  28.810846867322 ;%28.807259440187
TBYCUS1 =  51.604349773019 ;%51.615288901731
TAXCUS1 =  -0.120228183168 ;%-0.120628607901
TAYCUS1 =   0.736207337439 ;% 0.736213115604
% ------------------------------------------------------------------------------
% quads (Cu-linac energy is limited to 10 GeV)
%              Mark rematch     Yuri rematch       22JAN21
%            ---------------  ---------------  ---------------
KQCUS1 =   0.492297092478 ;% 0.49228249942   0.491233972308
KQCUS2 =  -0.423724073005 ;%-0.423677593542 -0.414060432356
KQCUS3 =  -0.302266732345 ;%-0.302405141966 -0.314369385154
KQCUS4 =   2.37403264227  ;% 2.374750929844  2.369394892073
KQCUS5 =  -1.402669753585 ;%-1.40237462603  -1.396338070942
KQCUS9 =  -0.466050157544 ;%-0.465888938931 -0.456516817666
KQCUS10 =   0.49777137309  ;% 0.497735968906  0.496780961708
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
% NOTE: 1.0D22.625 dipoles replaced with 3D8.8MK3 correctors
GBYCUS =  GBRCUSDC       ;%full gap (m)
ZBYCUS =  ZBRCUSDC       ;%on-axis effective length (m)
FBYCUS =  0.5 ;%FBRCUSdc  FINT
DLD2C =  (0.6-ZBYCUS)/2 ;%1.0D22.625 -> 3D8.8MK3 
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

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc A-line
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 24-JUN-2025, M. Woodley
%  * replace ESA E158 components with T-474 components
%  * prepend "A" to names that begin with "3"
% ------------------------------------------------------------------------------
% 14-MAR-2025, M. Woodley
%  * remove BSYA_1 area components (decommissioned)
%  * rename BSYA_2 area to BSYA; BSYA area begins at entrance to BRAM1
%  * define ESA area
% ------------------------------------------------------------------------------
% 31-MAR-2024, M. Woodley
%  * change Aline bend gap from 60 mm to 46 mm
% ------------------------------------------------------------------------------
% 31-MAR-2024, M. Woodley
%  * remove SCAPM2 (XCAPM2,YCAPM2)
%  * add YCDAS19 0.397 m d/s of XCDAS19
%  * comment ALINEa and ALINEb LINE's as decommissioned (DASEL uses ALINEc)
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
GBA =  0.046 ;%50 GeV upgrade value
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
% the K-values below are for DASEL (the only connection to ALINE)
KQ10 =   0.040946131243;
KQ11 =  -0.038135136057;
KQ19 =   0.030837113549;
KQ20 =   0.146624351215E-2;
KQ27 =  -0.083919622056;
KQ28 =   0.03548040664;
KQ30 =  -0.028849559713;
KQ38 =   0.034487458519;
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
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
DAMQ10={'dr' '' 0.9875 []}';
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
D120={'dr' '' 1.744768 []}';
D121={'dr' '' 1.525 []}';
D122={'dr' '' 1.925 []}';
D123={'dr' '' 38.1116 []}';
D124={'dr' '' 21.4778 []}';
D125={'dr' '' 5.170149 []}';%drift to start of ESA wall
% drifts for diagnostic and correction devices
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
% ==============================================================================
% coordinate rolls ... bend plane rotated to remove linac slope
% ------------------------------------------------------------------------------
ROLLON =  1.0;
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
A28X={'mo' 'A28X' 0 []}';
A32X={'mo' 'A32X' 0 []}';
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
% ==============================================================================
% beamlines
% ------------------------------------------------------------------------------
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
Q10_FULL=[Q10,Q10];
Q11_FULL=[Q11,Q11];
Q19_FULL=[Q19,Q19];
Q20_FULL=[Q20,Q20];
Q27_FULL=[Q27,Q27];
SQ27P5_FULL=[SQ27P5,SQ27P5];
Q28_FULL=[Q28,Q28];
Q30_FULL=[Q30,Q30];
Q38_FULL=[Q38,Q38];
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
% A-line
BSYA=[BEGBSYA,BRAM1_FULL,ROLL2,DAMQ10,Q10_FULL,LD105,Q11_FULL,D106,BEGB,B11_FULL,D107,B12_FULL,LD108,B13_FULL,D109,B14_FULL,LD110,B15_FULL,D111,B16_FULL,LD112,Q19_FULL,LD113,Q20_FULL,LD114,B21_FULL,D115,B22_FULL,LD116,B23_FULL,D117,B24_FULL,LD118,B25_FULL,D119,B26_FULL,MARC,ROLL3,ENDB,LD120,Q27_FULL,D121,SQ27P5_FULL,D122,Q28_FULL,LD123,Q30_FULL,LD124,Q38_FULL,D125,ENDBSYA];
% ==============================================================================
% ILC-ESA Test Beam
% ------------------------------------------------------------------------------
% T-474 chicane
% - 3D37 dipoles ("10D37")
% - rule-of-thumb on-axis effective length
% - use series approximation for sinc(x)=sin(x)/x to allow AB7=0
GB7 =  3.0*IN2M ;%full gap
ZB7 =  IN2M*(37+3.0) ;%on-axis effective length
FB7 =  0.5 ;%not measured
AB7 =  0.125313303478E-2 ;%-5 mm center offset
BB7 =  BRHOF*sin(AB7)/ZB7;
AB7_2 =  AB7*AB7;
AB7_4 =  AB7_2*AB7_2;
AB7_6 =  AB7_4*AB7_2;
SINCAB7 =  1-AB7_2/6+AB7_4/120-AB7_6/5040 ;%~sinc(AB7)=sin(AB7)/AB7
LB7 =  ZB7/SINCAB7;
AB7S =  asin(sin(AB7)/2);
AB7S_2 =  AB7S*AB7S;
AB7S_4 =  AB7S_2*AB7S_2;
AB7S_6 =  AB7S_4*AB7S_2;
SINCAB7S =  1-AB7S_2/6+AB7S_4/120-AB7S_6/5040 ;%~sinc(AB7S)=sin(AB7S)/AB7S
LB7S =  ZB7/(2*SINCAB7S);
AB7L =  AB7-AB7S;
LB7L =  LB7-LB7S;
BCX3D1A={'be' 'BCX3D1' LB7S [+AB7S GB7/2 0 0 FB7 0 0]}';
BCX3D1B={'be' 'BCX3D1' LB7L [+AB7L GB7/2 0 +AB7 0 FB7 0]}';
BCX3D2A={'be' 'BCX3D2' LB7L [-AB7L GB7/2 -AB7 0 FB7 0 0]}';
BCX3D2B={'be' 'BCX3D2' LB7S [-AB7S GB7/2 0 0 0 FB7 0]}';
BCX3D3A={'be' 'BCX3D3' LB7S [-AB7S GB7/2 0 0 FB7 0 0]}';
BCX3D3B={'be' 'BCX3D3' LB7L [-AB7L GB7/2 0 -AB7 0 FB7 0]}';
BCX3D4A={'be' 'BCX3D4' LB7L [+AB7L GB7/2 +AB7 0 FB7 0 0]}';
BCX3D4B={'be' 'BCX3D4' LB7S [+AB7S GB7/2 0 0 0 FB7 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX3D1={'be' 'BCX3D' LB7 [+AB7 GB7/2 0 +AB7 FB7 FB7 0]}';
BCX3D2={'be' 'BCX3D' LB7 [-AB7 GB7/2 -AB7 0 FB7 FB7 0]}';
BCX3D3={'be' 'BCX3D3' LB7 [-AB7 GB7/2 0 -AB7 FB7 FB7 0]}';
BCX3D4={'be' 'BCX3D4' LB7 [+AB7 GB7/2 +AB7 0 FB7 FB7 0]}';
% ==============================================================================
% drifts
% ------------------------------------------------------------------------------
ALWALL={'dr' '' 8*FT2M []}';%ESA wall
DSMDW =  0;
D126={'dr' '' 0.683370252059 []}';%wall to IV40 in ESA alcove
D127={'dr' '' 0.468630 []}';
D127A={'dr' '' 0.0672 []}';
D128={'dr' '' 0.696722-D127A{3} []}';
D129={'dr' '' 1.918716 []}';
D130={'dr' '' 0.900938 []}';
D131={'dr' '' 0.823976 []}';
D201={'dr' '' 1.039368 []}';
D202={'dr' '' 0.389128 []}';
D203={'dr' '' 0.892302 []}';
D204={'dr' '' 0.832866 []}';
D204A={'dr' '' 0.72125 []}';
D204B={'dr' '' D204{3}-D204A{3} []}';
D205={'dr' '' 0.213868 []}';
D206={'dr' '' 0.627634-D205{3} []}';
D207={'dr' '' 0.709422 []}';
D208={'dr' '' 1.405927747941 []}';
D209={'dr' '' 2.784 []}';
D210={'dr' '' 4.115 []}';
D211={'dr' '' 3.708 []}';
D212={'dr' '' 2.163 []}';
D213={'dr' '' 0.515 []}';
D214={'dr' '' 0.515 []}';
D215={'dr' '' 0.927-ZB7/2 []}';
D216={'dr' '' 3.990-ZB7 []}';
D217={'dr' '' 7.929-(D215{3}+ZB7+D216{3}+ZB7) []}';
D218={'dr' '' 1.210-ZB7/2 []}';
D219={'dr' '' 1.982-ZB7/2 []}';
D220={'dr' '' 2.008-ZB7/2 []}';
D221={'dr' '' 6.472-(D218{3}+ZB7+D219{3}+D220{3}+ZB7) []}';
D222={'dr' '' 0.765 []}';
D223={'dr' '' 0.692 []}';
D224={'dr' '' 28.447399 []}';
D225={'dr' '' 96.290872 []}';
% ==============================================================================
% instruments (from T-474)
% ------------------------------------------------------------------------------
IV40={'mo' 'IV40' 0 []}';
A3C1A={'dr' 'A3C1A' 0 []}';
A3C1B={'dr' 'A3C1B' 0 []}';
A3I1={'mo' 'A3I1' 0 []}';
A3PR1={'mo' 'A3PR1' 0 []}';
A3PR2={'mo' 'A3PR2' 0 []}';
A3I2={'mo' 'A3I2' 0 []}';
A3BPM1={'mo' 'A3BPM1' 0 []}';
A3BPM2={'mo' 'A3BPM2' 0 []}';
A3I3={'mo' 'A3I3' 0 []}';
IV41={'mo' 'IV41' 0 []}';
A3T0={'mo' 'A3T0' 0 []}';
A3WA1={'mo' 'A3WA1' 0 []}';
A3WAKE1={'mo' 'A3WAKE1' 0 []}';
A3WS1={'mo' 'A3WS1' 0 []}';
A3C2={'dr' 'A3C2' 0 []}';
A3BPM3={'mo' 'A3BPM3' 0 []}';
A3BPM4={'mo' 'A3BPM4' 0 []}';
A3BPM5={'mo' 'A3BPM5' 0 []}';
A3WS2={'mo' 'A3WS2' 0 []}';
A3WIG2={'mo' 'A3WIG2' 0 []}';
A3BPM9={'mo' 'A3BPM9' 0 []}';
A3BPM10={'mo' 'A3BPM10' 0 []}';
A3BPM11={'mo' 'A3BPM11' 0 []}';
% ==============================================================================
% points of interest
% ------------------------------------------------------------------------------
NOTCHBEG={'mo' 'NOTCHBEG' 0 []}';
NOTCHEND={'mo' 'NOTCHEND' 0 []}';
ALCOVEBEG={'mo' 'ALCOVEBEG' 0 []}';
ALCOVEEND={'mo' 'ALCOVEEND' 0 []}';
PVOT={'mo' 'PVOT' 0 []}';
ESAE={'mo' 'ESAE' 0 []}';%east wall of ESA
BMDE={'mo' 'BMDE' 0 []}';%Beam Dump East
% ==============================================================================
% beamlines
% ------------------------------------------------------------------------------
BCX3D1_FULL=[BCX3D1A,BCX3D1B];
BCX3D2_FULL=[BCX3D2A,BCX3D2B];
BCX3D3_FULL=[BCX3D3A,BCX3D3B];
BCX3D4_FULL=[BCX3D4A,BCX3D4B];
ESACHICANE=[BCX3D1_FULL,D216,BCX3D2_FULL,D217,A3WS2,D218,BCX3D3_FULL,D219,A3WIG2,D220,BCX3D4_FULL];
ESAU=[BEGESA,ALWALL,NOTCHBEG,D126,IV40,D127,A3C1A,D127A,NOTCHEND,ALCOVEBEG,D128,A3C1B,D129,A3I1,D130,A3PR1,D131,A3PR2,D201,A3I2,D202,A3BPM1,D203,A3BPM2,D204A,ALCOVEEND,D204B,A3I3,D205,IV41,D206,A3T0,D207,A3WA1,D208,A3WAKE1,D209,A3WS1,D210,PVOT];
ESAD=[D211,A3C2,D212,A3BPM3,D213,A3BPM4,D214,A3BPM5,D215,ESACHICANE,D221,A3BPM9,D222,A3BPM10,D223,A3BPM11,D224,ESAE,D225,BMDE,ENDESA];
ESA=[ESAU,ESAD];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc bypass line, plus match to LTU
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 14-DEC-2021, M. Woodley
%  * add Sector 20 shield wall per A. Ibrahimov and G. Gassner
% 20-JUL-2021, M. Woodley
%  * quad strength changes for Yuri's "symmetric" SPRDs/SPRDh match
% ------------------------------------------------------------------------------
% 11-MAY-2021, M. Woodley
%  * correct spacing of 2Q4/BPM/XCOR/YCOR per ID drawings
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
% quadrupoles
% ------------------------------------------------------------------------------
KQY =   0.060580505638 ;%45 degree bypass FODO
QFY={'qu' 'QFY' LQM/2 [KQY 0]}';%dummy magnet
QDY={'qu' 'QDY' LQM/2 [-KQY 0]}';%dummy magnet
KQBP25 =   0.070273904791;
KQBP26 =  -0.10552161126;
KQBP27 =   0.11147451141;
KQBP35 =  -0.291127425582;
KQBP28 =   0.323836147473;
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQBP36 =   0.581885208949;
KQBP30 =  -0.589938332836;
KQBP31 =   0.614211022315;
KQBP32 =  -0.490251186947;
KQBP33 =  -0.37247651207  ;%-0.372476510794
KQBP34 =   0.54911803358  ;% 0.549118036482
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
% Sector 20 shield wall
DCYSA1={'dr' '' 4.976697 []}';
S20WALL={'dr' '' 2.0 []}';
DCYSA2={'dr' '' DCYSA{3}-DCYSA1{3}-S20WALL{3} []}';
% existing PEP-II HER Bypass Line (LI13-27)
D2Q4A0={'dr' '' 0.44518 []}';
D2Q4B0={'dr' '' 0.62865 []}';
D2Q4C0={'dr' '' 0.2286 []}';
D2Q4D0={'dr' '' DCY{3}-(D2Q4A0{3}+D2Q4B0{3}+D2Q4C0{3}) []}';
D2Q4J0={'dr' '' 1.0 []}';
D2Q4I0={'dr' '' D2Q4D0{3}-D2Q4J0{3} []}';
D2Q4I20={'dr' '' 0.1 []}';
D2Q4I10={'dr' '' D2Q4I0{3}-D2Q4I20{3} []}';
D2Q4E0={'dr' '' 1.83107 []}';
D2Q4F0={'dr' '' D2Q4D0{3}-(D2Q4E0{3}+LJAW) []}';
D2Q4S0={'dr' '' D2Q4D0{3}-LQM/2+ZQBP35 []}';
D2Q4SA0={'dr' '' 64.904067 []}';
D2Q4SB0={'dr' '' D2Q4S0{3}-D2Q4SA0{3} []}';
% LCLS-II (LI28 to muon wall)
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
RFBWSBP2={'dr' '' 0 []}';
RFBWSBP3={'dr' '' 0 []}';
RFBWSBP4={'dr' '' 0 []}';
RFBBP24={'dr' '' 0 []}';%4/23/14
RFBBP35={'dr' '' 0 []}';%4/23/14
RFBBP30={'dr' '' 0 []}';
RFBBP33={'dr' '' 0 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
% corrector types:
%   "Bypass"   = SA-344-116-01 (purple coil)
%   "Bypass#2" = SA-344-119-01 (blue coil)
%   "Bypass#3" = SA-344-117-01 (white coil)
%   "type-4"   = SA-238-040-86
%   "class-4"  = SA-238-040-86
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
% corrector types:
%   "Bypass"   = SA-344-116-01 (purple coil)
%   "Bypass#2" = SA-344-119-01 (blue coil)
%   "Bypass#3" = SA-344-117-01 (white coil)
%   "type-4"   = SA-238-040-86
%   "class-4"  = SA-238-040-86
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
% BSY wooden door
WOODDOOR_SPS={'mo' 'WOODDOOR_SPS' 0 []}';
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
FODOLA=[BEGBYP,RFBWSBP2,D2Q4I2,WSBP2,D2Q4J,DCYSA,BPN12END,BPN13BEG,DCYSB,QBP13_FULL,D2Q4A0,BPMBP13,D2Q4B0,XCBP13,D2Q4C0,YCBP13,D2Q4D0,DCYSA,BPN13END,BPN14BEG,DCYSB,QBP14_FULL,D2Q4A0,BPMBP14,D2Q4B0,XCBP14,D2Q4C0,YCBP14,D2Q4I10,RFBWSBP3,D2Q4I20,WSBP3,D2Q4J0,DCYSA,BPN14END,BPN15BEG,DCYSB,QBP15_FULL,D2Q4A0,BPMBP15,D2Q4B0,XCBP15,D2Q4C0,YCBP15,D2Q4D0,DCYSA,BPN15END,BPN16BEG,DCYSB,QBP16_FULL,D2Q4A0,BPMBP16,D2Q4B0,XCBP16,D2Q4C0,YCBP16,D2Q4I10,RFBWSBP4,D2Q4I20,WSBP4,D2Q4J0,DCYSA,BPN16END,BPN17BEG,DCYSB,QBP17_FULL,D2Q4A0,BPMBP17,D2Q4B0,XCBP17,D2Q4C0,YCBP17,D2Q4D0,DCYSA,BPN17END,BPN18BEG,DCYSB,QBP18_FULL,D2Q4A0,BPMBP18,D2Q4B0,XCBP18,D2Q4C0,YCBP18,D2Q4D0,DCYSA,BPN18END,BPN19BEG,DCYSB,QBP19_FULL,D2Q4A0,BPMBP19,D2Q4B0,XCBP19,D2Q4C0,YCBP19,D2Q4D0,DCYSA,BPN19END,BPN20BEG,DCYSB,QBP20_FULL,D2Q4A0,BPMBP20,D2Q4B0,XCBP20,D2Q4C0,YCBP20,D2Q4D0,DCYSA1,S20WALL,DCYSA2,BPN20END,BPN21BEG,DCYSB,QBP21_FULL,D2Q4A0,BPMBP21,D2Q4B0,XCBP21,D2Q4C0,YCBP21,D2Q4E0,CXBP21,D2Q4F0,DCYSA,BPN21END,BPN22BEG,DCYSB,QBP22_FULL,D2Q4A0,BPMBP22,D2Q4B0,XCBP22,D2Q4C0,YCBP22,D2Q4E0,CYBP22,D2Q4F0,DCYSA,BPN22END,BPN23BEG,DCYSB,QBP23_FULL,D2Q4A0,BPMBP23,D2Q4B0,XCBP23,D2Q4C0,YCBP23,D2Q4D0,DCYSA,BPN23END,BPN24BEG,DCYSB,QBP24_FULL,D2Q4A0,BPMBP24,RFBBP24,D2Q4B0,XCBP24,D2Q4C0,YCBP24,D2Q4D0,DCYSA,BPN24END,BPN25BEG,DCYSB,QBP25_FULL,D2Q4A0,BPMBP25,D2Q4B0,XCBP25,D2Q4C0,YCBP25,D2Q4E0,CXBP25,D2Q4F0,DCYSA,BPN25END,BPN26BEG,DCYSB,QBP26_FULL,D2Q4A0,BPMBP26,D2Q4B0,XCBP26,D2Q4C0,YCBP26,D2Q4E0,CYBP26,D2Q4F0,DCYSA,BPN26END,BPN27BEG,DCYSB,QBP27_FULL,D2Q4A0,BPMBP27,D2Q4B0,XCBP27,D2Q4C0,YCBP27,D2Q4SA0,BPN27END,D2Q4SB0,QBP35_FULL,D2Q4A,BPMBP35,RFBBP35,D2Q4B,XCBP35,D2Q4C,YCBP35,D2Q4T,QBP28_FULL,D2Q4A,BPMBP28,D2Q4B,XCBP28,D2Q4C,YCBP28,D2Q4Q,LTUSPLIT,RWWAKE2,ENDBYP];
FODOLB=[DCYFA,DCYFB,DCYFC,DCYFD,S100B,DCYFEA,WOODDOOR_SPS];
FODOLC=[DCYFEB,QBP36_FULL,D2Q4A,BPMBP36,D2Q4B,D2Q4C,DCYG,QBP30_FULL,D2Q4A,RFBBP30,D2Q4B,XCBP30,D2Q4C,YCBP30,DCYC];
FODOL=[FODOLA,SPRDS,FODOLB,FODOLC];
BYPM1=[DCYDA,CXBP30,DCYDB,QBP31_FULL,D2Q4A,BPMBP31,D2Q4B,XCBP31,D2Q4C,YCBP31,D2Q4LAA,PCSP1S,D2Q4LAB,BPMBP32,D2Q4LB,QBP32_FULL,D2Q4AB,D2Q4B,XCBP32,D2Q4C,YCBP32,D2Q4MA1,PCSP2S,D2Q4MA2];
BYPM2=[D2Q4MBA,PCBP33,D2Q4MBB,STBP34A,BTMBP34A,D2Q4MBC,STBP34B,BTMBP34B,D2Q4MBD,DBP2B,QBP33_FULL,D2Q4A,RFBBP33,D2Q4B,XCBP33,D2Q4C,YCBP33,DBP3AA,PCSP3S,DBP3AB,CXBP34,DBP3B,QBP34_FULL,D2Q4A,BPMBP34,D2Q4B,XCBP34,D2Q4C,YCBP34,D2Q4O,DCWLA,PCSP4S,DCWLB];
BYPM=[BYPM1,BRCUS1A,BRCUS1B,MRGCUSXR,BYPM2];
BYPASS=[FODOL,BYPM];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc LTU and dump
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 24-JUL-2025, M. Woodley
%  * add MARKER point "SWIVEL" at location of swivel point
% ------------------------------------------------------------------------------
% 10-MAR-2025, M. Woodley
%  * cleanup (remove BSY-to-Aline stuff)
% ------------------------------------------------------------------------------
% 04-DEC-2024, M. Woodley
%  * relocate RFBSX14 per X. Permanyer
% 18-SEP-2024, M. Woodley
%  * add RFBSX14 at end of LTUS (LCLS-II-HE location)
% ------------------------------------------------------------------------------
% 02-MAY-2024, M. Woodley
%  * fix negative drifts in CBXFEL chicanes
%  * rename BODCBX42 -> YAGCBX42
%  * add BODCBX40
% 31-MAR-2024, M. Woodley
%  * replace UMXL2h with WIGXLh
% ------------------------------------------------------------------------------
% 07-SEP-2022, M. Woodley
%  * redefine YAGDL18
% ------------------------------------------------------------------------------
% 30-NOV-2021, M. Woodley
%  * change TYPE of BPMQD and BPMQDB to "Stripline-11" (vertical orientation)
% 22-NOV-2021, M. Woodley
%  * undefer OTRDMPB per T. Maxwell
% ------------------------------------------------------------------------------
% 14-JAN-2021, M. Woodley
%  * move RFBHX12 9.373 mm u/s per G. Gassner
% ------------------------------------------------------------------------------
% 08-OCT-2020, M. Woodley
%  * rename OTRDL18 to YAGDL18 (TYPE="YAG-PAL") and undefer per B. Jacobson
% ------------------------------------------------------------------------------
% 05-OCT-2020, M. Woodley
%  * add XLEAP quadrupoles QFXL1 and QFXL2
% 06-AUG-2020, M. Woodley
%  * redefined XLEAP undulators
% ------------------------------------------------------------------------------
% 03-MAR-2020, M. Woodley
%  * move XLEAP wiggler to SXR cell #18
% 12-DEC-2019, M. Woodley
%  * move XLEAP wiggler to SXX (cell 17)
%  * add "h" to UMXL1-4 (-> UMLX1-4h)
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
BWGS =  0                       ;%wiggler bend field (kG)
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
WIG1S1={'dr' '' LWG1S []}';
WIG1S2={'dr' '' LWG2S []}';
WIG2S1={'dr' '' LWGS []}';
WIG2S2={'dr' '' LWGS []}';
WIG3S1={'dr' '' LWG2S []}';
WIG3S2={'dr' '' LWG1S []}';
% define unsplit SBENs for BMAD ... not used by MAD
WIG1S={'dr' '' LWGS []}';
WIG2S={'dr' '' 2*LWGS []}';
WIG3S={'dr' '' LWGS []}';
LDWGS =  ZDWG/cos(AWGS);
DWGS={'dr' '' LDWGS []}';
YCWIGS={'dr' '' 0 []}';
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
KQDBL1 =  -0.050357218829 ;%-0.050357323411
KQDBL2 =  -0.559361220066 ;%-0.559361105837
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
KQDL20 =  -0.487749576014;
KQDL21 =  -1.904149676641;
KQDL22 =   2.191524608573;
QDL20={'qu' 'QDL20' LQE/2 [KQDL20 0]}';
QDL21={'qu' 'QDL21' LQE/2 [KQDL21 0]}';
QDL22={'qu' 'QDL22' LQE/2 [KQDL22 0]}';
KSDL1 =   -8.734519131209;
KSDL2 =  -24.395452957066;
SDL1={'dr' '' LSB/2 []}';
SDL2={'dr' '' LSB/2 []}';
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
ABYKIKS =  0 ;%=0.889371410732E-3 when BYKIKS1,2 are turned on
BYKIK1S1={'be' 'BYKIK1S' LKIK/2 [ABYKIKS/4 GKIK ABYKIKS/4 0 0.5 0 pi/2]}';
BYKIK1S2={'be' 'BYKIK1S' LKIK/2 [ABYKIKS/4 GKIK 0 ABYKIKS/4 0 0.5 pi/2]}';
BYKIK2S1={'be' 'BYKIK2S' LKIK/2 [ABYKIKS/4 GKIK ABYKIKS/4 0 0.5 0 pi/2]}';
BYKIK2S2={'be' 'BYKIK2S' LKIK/2 [ABYKIKS/4 GKIK 0 ABYKIKS/4 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYKIK1S={'be' 'BYKIK1S' LKIK [ABYKIKS/2 GKIK ABYKIKS/4 ABYKIKS/4 0.5 0.5 pi/2]}';
BYKIK2S={'be' 'BYKIK2S' LKIK [ABYKIKS/2 GKIK ABYKIKS/4 ABYKIKS/4 0.5 0.5 pi/2]}';
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
DBYKS01={'dr' '' DDL10BA{3} []}';%QDL16 to CYDL16
DBYKS02={'dr' '' DDL10BB{3} []}';%CYDL16 to BPMDL16
DBYKS03={'dr' '' 1.145230 []}';%BPMDL16 to BTM04B (DDL11BA[L]+0.299779)
DBYKS05={'dr' '' 0.5893-LKIK/2 []}';%(BYKIK1S to BYKIK2S)/2 (0.609226)
DBYKS06={'dr' '' 4.360149 []}';%BYKIK2S to XCDL17      (4.340223)
DBYKS07={'dr' '' 0.634128 []}';%XCDL17 to BPMDL17
DBYKS08={'dr' '' 0.415873 []}';%BPMDL17 to QDL17
DBYKS04={'dr' '' LDBYKS-DBYKS01{3}-LJAW-DBYKS02{3}-DBYKS03{3}-LPLATE-2*(LKIK+DBYKS05{3})-DBYKS06{3}-DBYKS07{3}-DBYKS08{3} []}';%BTM04B to BYKIK1S
DBYKS11={'dr' '' 0.51 []}';%QDL17 to CEDL17
DBYKS12={'dr' '' 0.735832 []}';%CEDL17 to (removed) BTM05B
DBYKS13={'dr' '' 0.687668 []}';%(removed) BTM05B to SPOILERS
DBYKS14={'dr' '' 3.200208 []}';%SPOILERS to TDKIKS (3.220859)
DBYKS15={'dr' '' 0.257457 []}';%TDKIKS to PCTDKIKS1 (0.257426)
DBYKS16={'dr' '' 0.266697 []}';%PCTDKIKS to PCTDKIKS
DBYKS18={'dr' '' 0.4 []}';%YAGDL18 to YCDL18
DBYKS19={'dr' '' 0.4 []}';%YCDL18 to QDL18
DBYKS17={'dr' '' LDBYKS-DBYKS11{3}-LJAW-DBYKS12{3}-DBYKS13{3}-DBYKS14{3}-TDKIKS{3}-DBYKS15{3}-4*LPCTDKIK-3*DBYKS16{3}-DBYKS18{3}-DBYKS19{3} []}';%PCTDKIK4S to YAGDL18
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
PCTDKIK3S={'dr' '' LPCTDKIK []}';
PCTDKIK4S={'dr' '' LPCTDKIK []}';
% combination YAG/OTR PAL type
YAGDL18={'mo' 'YAGDL18' 0 []}';
YAGDL18_OTR={'mo' 'YAGDL18_OTR' 0 []}';
YAGDL18_FULL=[YAGDL18,YAGDL18_OTR];
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
DL2SC=[DBMARK34B,DDL20B,XCDL11,DDL6B,QDL11_FULL,DDL15BA,BPMDL11,DDL15BB,DDL15BC,CC31B,DDL16B,BX31B_FULL,DDL1BA,PC01B,BTM01B,DDL1BB,BPMDL12,DDL1BC,QDL12_FULL,DDL6B,YCDL12,DDL9B,XCDL13,DDL6BA,SDL1_FULL,DDL6BB,QDL13_FULL,DDL7BA,CEDL13,DDL7BB,BPMDL13,DDL8B,YCDL14,DDL6B,QDL14_FULL,DDL8CA,BPMDL14,DDL8CB,DWIGSA,PC03B,BTM03B,DWIGSB,DDL8D,XCDL15,DDL6BA,SDL2_FULL,DDL6BB,QDL15_FULL,DDL0BA,BPMDL15,DDL0BB,DDL0BC,YCDL16,DDL6B,QDL16_FULL,DBYKS01,CYDL16,DBYKS02,BPMDL16,DBYKS03,PC04B,BTM04B,DBYKS04,BYKIK1S_FULL,DBYKS05,DBYKS05,BYKIK2S_FULL,DBYKS06,XCDL17,DBYKS07,BPMDL17,DBYKS08,QDL17_FULL,DBYKS11,CEDL17,DBYKS12,DBYKS13,SPOILERS,DBYKS14,TDKIKS,DBYKS15,PCTDKIK1S,DBYKS16,PCTDKIK2S,DBYKS16,PCTDKIK3S,DBYKS16,PCTDKIK4S,DBYKS17,YAGDL18_FULL,DBYKS18,YCDL18,DBYKS19,QDL18_FULL,DDL19BA,BPMDL18,DDL19BB,PC06B,BTM06B,DDL19BC,XCDL19,DDL6B,QDL19_FULL,DDL2BA,BPMDL19,DDL2BB,BX32B_FULL,CNTLT1S,DDL14B,QDL20_FULL,DDL6B,YCDL20,DDL17B,CC32B,DDL18BA,PC07B,BTM07B,DDL18BB,YCDL21,DDL6B,QDL21_FULL,DDL4B,XCDL22,DDL6B,QDL22_FULL,DDL5B];
% %test line to find ABYKIKS angle for -14.2 mm offset at front face of TDKIKS
% 
% KYKIK1S={'mo' 'KYKIK1S' LKIK/2 []}';
% KYKIK2S={'mo' 'KYKIK2S' LKIK/2 []}';
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
DVBEM25CMB={'dr' '' 1.39092-0.076175 []}';
D25CMD={'dr' '' 0.25+0.076175 []}';
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
VBSYSB=[DYCVM1,DQVM1,DRQVM1,DRQVM1,DQVM2,DRQVM2BA,PC08B,BTM08B,DRQVM2BB,DXCVM2,DVB25CM,VBENDB,DVB25CMCB,XCVM3B,D25CM,QVM3B_FULL,DVBEM25CMB,YCVM4B,D25CMD,QVM4B_FULL,DVBEM15CMB,D10CMB,D25CMA];
% ------------------------------------------------------------------------------
% SXR emittance diagnostic
% ------------------------------------------------------------------------------
KQEM1B =   1.994731606958;
KQEM2B =  -1.809273842138;
KQEM3B =   1.263524123458;
KQEM3VB =   0.0;
KQEM4B =  -0.891608033545;
QEM1B={'qu' 'QEM1B' LQE/2 [KQEM1B 0]}';
QEM2B={'qu' 'QEM2B' LQE/2 [KQEM2B 0]}';
QEM3B={'qu' 'QEM3B' LQE/2 [KQEM3B 0]}';
QEM3VB={'qu' 'QEM3VB' LQX/2 [KQEM3VB 0]}';
QEM4B={'qu' 'QEM4B' LQE/2 [KQEM4B 0]}';
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
DMM3M80CM1={'dr' '' 5.677 []}';
DMM3M80CM2={'dr' '' DMM3M80CMX{3}-DMM3M80CM1{3} []}';
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
RFBEM4B={'dr' '' 0 []}';
BPME31B={'mo' 'BPME31B' 0 []}';
BPME32B={'mo' 'BPME32B' 0 []}';%type to be checked
RFBE32B={'dr' '' 0 []}';
BPME33B={'mo' 'BPME33B' 0 []}';
BPME34B={'mo' 'BPME34B' 0 []}';%type to be checked
RFBE34B={'dr' '' 0 []}';
BPME35B={'mo' 'BPME35B' 0 []}';
BPME36B={'mo' 'BPME36B' 0 []}';%type to be checked
RFBE36B={'dr' '' 0 []}';
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
% modified (recycled) LCLS undulators
% ------------------------------------------------------------------------------
KUND =  0          ;%undulator parameter (rms) [ ]
LAMU =  0.40       ;%undulator period [m]
LSEG =  3.400      ;%wiggler length [m]
LUE =  0.035      ;%wiggler termination length (approx) [m]
LUND =  LSEG-2*LUE ;%wiggler length without terminations [m]
LUNDH =  LUND/2     ;%wiggler half-length [m]
%comment special definition for Matlab model
GAMXL =  EU/MC2;
KQUND =  (KUND*2*PI/LAMU/sqrt(2)/GAMXL)^2;
ARGU =  LUNDH*sqrt(KQUND);
ARGU2 =  ARGU*ARGU;
ARGU4 =  ARGU2*ARGU2;
ARGU6 =  ARGU4*ARGU2;
SINCARGU =  1-ARGU2/6+ARGU4/120-ARGU6/5040 ;%~sinc(ARGu)=sin(ARGu)/ARGu
R34U =  LUNDH*SINCARGU;
UMXLH={'un' 'UMXLH' LUNDH [KQUND LAMU 2]}';%use this exact syntax
UMXL1H=UMXLH;UMXL1H{2}='UMXL1H';
UMXL3H=UMXLH;UMXL3H{2}='UMXL3H';
UMXL4H=UMXLH;UMXL4H{2}='UMXL4H';
%endcomment
% 
% % half-wiggler modeled as an R-matrix which includes vertical focusing
% % and horizontal defocusing per Ago Martinelli (see wigXL2.m);
% % define XLEAP-II wigglers (as DRIFTs)
% R11XL1 =  1.0;
% R12XL1 =  LUNDH;
% R21XL1 =  0.0;
% R22XL1 =  1.0;
% R33XL1 =  1.0;
% R34XL1 =  LUNDH;
% R43XL1 =  0.0;
% R44XL1 =  1.0;
% UMXL1H={'un' 'UMXL1H' LUNDH [R33XL1 R33XL1]}';
% R11XL3 =  1.0;
% R12XL3 =  LUNDH;
% R21XL3 =  0.0;
% R22XL3 =  1.0;
% R33XL3 =  1.0;
% R34XL3 =  LUNDH;
% R43XL3 =  0.0;
% R44XL3 =  1.0;
% UMXL3H={'un' 'UMXL3H' LUNDH [R33XL3 R33XL3]}';
% R11XL4 =  1.0;
% R12XL4 =  LUNDH;
% R21XL4 =  0.0;
% R22XL4 =  1.0;
% R33XL4 =  1.0;
% R34XL4 =  LUNDH;
% R43XL4 =  0.0;
% R44XL4 =  1.0;
% UMXL4H={'un' 'UMXL4H' LUNDH [R33XL4 R33XL4]}';

UMXL1_FULL=[UMXL1H,UMXL1H];
UMXL3_FULL=[UMXL3H,UMXL3H];
UMXL4_FULL=[UMXL4H,UMXL4H];
% ------------------------------------------------------------------------------
% original XLEAP wiggler
% ------------------------------------------------------------------------------
% wiggler is modeled as R-matrix to include natural vertical focusing;
% it is nominally OFF (opened to full gap, with Kwig~2); at minimum gap, Kwig=50
KWIG =  34                                        ;%wiggler parameter [m^-1]
LAMW =  0.34                                      ;%wiggler period [m]
LWIGH =  2.38/2                                    ;%wiggler half-length [m]
GAMW =  EU/MC2                                    ;%Lorentz energy factor in wiggler [ ]
KQWIG =  SETXL2WIG*(2*PI*KWIG/LAMW/sqrt(2)/GAMW)^2 ;%natural vertical focusing "k" [m^-2]
% handle Kwig->0 by expressing R34 as an approximate SINC function
ARGW =  LWIGH*sqrt(KQWIG);
ARGW2 =  ARGW*ARGW;
ARGW4 =  ARGW2*ARGW2;
ARGW6 =  ARGW4*ARGW2;
SINCARGW =  1-ARGW2/6+ARGW4/120-ARGW6/5040 ;%~sinc(ARGw)=sin(ARGw)/ARGw
R34W =  LWIGH*SINCARGW;
WIGXLH={'un' 'WIGXLH' LWIGH [KQWIG LAMW 1]}';
%VALUE, WIGXLh[RM(1,1)],WIGXLh[RM(1,2)],WIGXLh[RM(2,1)],WIGXLh[RM(2,2)]
%VALUE, WIGXLh[RM(3,3)],WIGXLh[RM(3,4)],WIGXLh[RM(4,3)],WIGXLh[RM(4,4)]
WIGXL_FULL=[WIGXLH,WIGXLH];
% ------------------------------------------------------------------------------
% new XLEAP-II quadrupoles (to mitigate focusing of wigglers)
% ------------------------------------------------------------------------------
KQFXL1 =  0;
KQFXL2 =  0;
QFXL1={'qu' 'QFXL1' LQE/2 [KQFXL1 0]}';
QFXL2={'qu' 'QFXL2' LQE/2 [KQFXL2 0]}';
QFXL1_FULL=[QFXL1,QFXL1];
QFXL2_FULL=[QFXL2,QFXL2];
% wiggler pairs
DUQXL1={'dr' '' 0.2166+0.1777551 []}';
DUQXL1W={'dr' '' 0.2166+0.475-0.1777551 []}';
DUQXL2={'dr' '' 0.2166 []}';
UMXLPAIR1=[UMXL1_FULL,DUQXL1,QFXL1_FULL,DUQXL1W,WIGXL_FULL];
UMXLPAIR2=[UMXL3_FULL,DUQXL2,QFXL2_FULL,DUQXL2,UMXL4_FULL];
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
ABXL =  ABXL0*SETXL2SS;
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
% drifts around undulator pairs and chicane
DXLUA1={'dr' '' 0.404978 []}';
DXLUA2={'dr' '' 0.395986 []}';
DUMXL12U={'dr' '' 0.566965333333 []}';
DUMXL12D={'dr' '' 1.422304333333+0.475 []}';
DXLUC={'dr' '' 3.5 []}';
DXLUD1={'dr' '' 0.323714 []}';
DXLUD2={'dr' '' 0.393700 []}';
DUMXL34U={'dr' '' 0.549586 []}';
DUMXL34D={'dr' '' 2.154753333333 []}';
MXL2A={'mo' 'MXL2A' 0 []}';
MXL2B={'mo' 'MXL2B' 0 []}';
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
% 
% EDMCHB=[D25CMB,D25CMC,DMM1M90CMBA,PC10B,BTM10B,DMM1M90CMBB,XCEM1B,DEM1A,QEM1B_FULL,DEM1BAB,DEM1BBB,QEM2B_FULL,DEM2B,YCEM2B,DMM3M80CM1,DMM3M80CM2,XCEM3B,DEM3A,QEM3B_FULL,DEM3BB,QEM3VB_FULL,DMM4M90CMBA,PC11B,BTM11B,DMM4M90CMBB,YCEM4B,DEM4A,QEM4B_FULL,DRFB,RFBEM4B,DMM5AB,DMM5BB];

EDMCHB=[D25CMB,D25CMC,DMM1M90CMBA,PC10B,BTM10B,DMM1M90CMBB,XCEM1B,DEM1A,QEM1B_FULL,DEM1BAB,DEM1BBB,QEM2B_FULL,DEM2B,YCEM2B,DMM3M80CMX,XCEM3B,DEM3A,QEM3B_FULL,DEM3BB,QEM3VB_FULL,DMM4M90CMBA,PC11B,BTM11B,DMM4M90CMBB,YCEM4B,DEM4A,QEM4B_FULL,DRFB,RFBEM4B,DMM5AB,DMM5BB];
EDSYSB=[DBMARK36B,WS31B,D40CM,DE3MAB,DE3MBB,XCE31B,DQEA,QE31B_FULL,DXLUA1,YCXL1,DXLUA2,XCXL1,DUMXL12U,UMXLPAIR1,MXL2A,DUMXL12D,PC12B,BTM12B,DBTM2YC,YCE32B,DQEAA,QE32B_FULL,DRFB,RFBE32B,DQEBY1,DCY32B,DQEBY2,WS32B,D40CM,DE3M80CMB,XCE33B,DQEAB,QE33B_FULL,DQEC,DE3M40CM,YCE34B,DQEA,QE34B_FULL,DRFB,RFBE34B,DQEC1,WS33B,D40CM,DE3M80CM,XCE35B,DQEAC,QE35B_FULL,DXLUC,BCXLSS,DXLUD1,YCXL2,DXLUD2,XCXL2,DUMXL34U,MXL2B,UMXLPAIR2,DUMXL34D,YCE36B,DQEA,QE36B_FULL,DRFB,RFBE36B,DQEBY1,DCY36B,DQEBY2,WS34B,D40CM];
ECELLB=[QE31B,DQEC,DQEC,QE32B,QE32B,DQEC,DQEC,QE31B];
% ------------------------------------------------------------------------------
% SXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
KQUM1B =   0.57267030746  ;% 0.562602614756
KQUM2B =  -0.797265679968 ;%-0.772168877627
KQUM3B =   1.163807988131 ;% 1.16642030076 
KQUM4B =  -1.143755513822 ;%-1.169509350693
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
DMUON1B={'dr' '' 0.154859+0.05-0.060429+0.117 []}';
DMUON3B={'dr' '' 0.310592-0.05-0.117 []}';
DW2TDUNDB1={'dr' '' 1.185 []}';%drift from BTH/UH wall-2 to RFBSX14
DW2TDUNDB2={'dr' '' DW2TDUNDB{3}-DW2TDUNDB1{3}-LRFBUB []}';%drift from RFBSX14 to TDUNDB u/s flange
BPMUM1B={'mo' 'BPMUM1B' 0 []}';
BPMUM2B={'mo' 'BPMUM2B' 0 []}';
BPMUM3B={'mo' 'BPMUM3B' 0 []}';
BPMUM4B={'mo' 'BPMUM4B' 0 []}';
RFBSX14={'mo' 'RFBSX14' LRFBUB []}';%for SXR undulator BBA
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
QUM1B_FULL=[QUM1B,BPMUM1B,QUM1B];
QUM2B_FULL=[QUM2B,BPMUM2B,QUM2B];
QUM3B_FULL=[QUM3B,BPMUM3B,QUM3B];
QUM4B_FULL=[QUM4B,BPMUM4B,QUM4B];
UNMCHB=[DU1M80CM,DCX37,D32CMCB,DUM1A,QUM1B_FULL,DUM1B,XCUM1B,D32CM,DU2M120CMB,DCY38,D32CMA,YCUM2B,DUM2A,QUM2B_FULL,DUM2B,DU3M80CMB,XCUM3B,DUM3A,QUM3B_FULL,DUM3B,D40CMA,DU4M120CMB,YCUM4B,DUM4A,QUM4B_FULL,DUM4B,DU5M80CMB,D40CMW,MUHWALL1B,DUHWALL1,DUHVEST,MUHWALL2B,DUHWALL2,DW2TDUNDB1,RFBSX14,DW2TDUNDB2,DTDUND1,TDUNDB,DTDUND2,DPCMUON,PCMUONB,DMUON1B,VV999B];
LTUSC=[MM1B,DL2SC,VBSYSB,MM2B,EDMCHB,EDSYSB,UNMCHB];
PREUNDS=[DMUON3B,MM3B,PFILT1B,DBMARK37B];
BSYLTUSC=[MUWALLB,DWALLA,DUMPBSYS,DWALLB,BSYENDB,ENDSPS,DBLDL21,LTUSC,PREUNDS];
% ------------------------------------------------------------------------------
% SXR dumpline
% ------------------------------------------------------------------------------
KQDMPB =  -0.154946553294 ;%Yuri (E=4.0, K=5.0)
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
PCEBDB={'dr' 'PCEBDB' 0 []}';
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
DWSDUMPA1={'dr' '' 0.07596510786 []}';
DWSDUMPA2={'dr' '' DWSDUMPA{3}-DWSDUMPA1{3} []}';
DWSDUMPB={'dr' '' 0.44156-DWSDUMPA{3} []}';
DWSDUMPC={'dr' '' 2.038949+DDWSDUMP []}';
DDUMP={'dr' '' 61.120*IN2M []}';%length of EBD dump (per A. Ibrahimov)
BPMQDB={'mo' 'BPMQDB' 0 []}';%RFBQDB : MONI, TYPE="@2,CavityL-1"
BPMDDB={'mo' 'BPMDDB' 0 []}';
RFBDDB={'dr' '' 0 []}';
XCDDB={'mo' 'XCDDB' 0 []}';
YCDDB={'mo' 'YCDDB' 0 []}';
OTRDMPB={'mo' 'OTRDMPB' 0 []}';%Dump screen
WSDUMPB={'dr' '' 0 []}';
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
DUMPLINEB=[BEGDMPS_2,RODMP1S,BYDSS_FULL,DS1,BYD1B_FULL,DS,BYD2B_FULL,DS,BYD3B_FULL,DD1BA,PCPM1LB,BTM1LB,DD1BB,DD1BC,MIMBCS4B,DD1BD,YCDDB,DD1BE,PCPM2LB,BTM2LB,DD1BF,QDMP1B_FULL,DD12A,BPMQDB,DD12B,MQDMPB,DD12C,QDMP2B_FULL,DD2A,XCDDB,DD2B,DD2C,DD3A,BPMDDB,DD3B,OTRDMPB,DWSDUMPA1,PCEBDB,DWSDUMPA2,RFBDDB,DWSDUMPB,WSDUMPB,DWSDUMPC,RODMP2S,DUMPFACEB,DDUMP,DMPENDB,BTMDUMPB,DBMARK38B,ENDDMPS_2];
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
BCX3111={'dr' '' LBX31S []}';
BCX3112={'dr' '' LBX31L []}';
BCX3121={'dr' '' LBX31L []}';
BCX3122={'dr' '' LBX31S []}';
BCX3131={'dr' '' LBX31S []}';
BCX3132={'dr' '' LBX31L []}';
BCX3141={'dr' '' LBX31L []}';
BCX3142={'dr' '' LBX31S []}';
% define unsplit SBENs for BMAD ... not used by MAD
BCX311={'dr' '' LBX31 []}';
BCX312={'dr' '' LBX31 []}';
BCX313={'dr' '' LBX31 []}';
BCX314={'dr' '' LBX31 []}';
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
% BSY upstream of the scH merge bend (BXSP1H)
% ------------------------------------------------------------------------------
KQ30701 =  -0.396181540351 ;%-0.396231018339
KQ30801 =   0.480061954868 ;% 0.480592172519
KQ50Q1 =  -0.231094130006 ;%-0.231522300458
KQ50Q2 =   0.101722563756 ;% 0.102074332053
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
DBSY52D={'dr' '' 0.5 []}';
DBSY52C={'dr' '' DBSY52{3}-DBSY52A{3}-DBSY52B{3}-LBRCUSDC1-DCKDC1{3}-LBKRCUS-DCKDC2{3}-LBRCUSDC2-DCUSBLRA{3}-DCUSBLRB{3}-LBLRCUS-LBXSPH-DBSY52D{3} []}';
DBSY52C1={'dr' '' 1.174422 []}';%to SWIVEL point
DBSY52C2={'dr' '' DBSY52C{3}-DBSY52C1{3} []}';
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
SWIVEL={'mo' 'SWIVEL' 0 []}';%"swivel point"
BSY1END={'mo' 'BSY1END' 0 []}';
% wooden BSY door (separates LI30 from BSY)
WOODDOOR={'mo' 'WOODDOOR' 0 []}';
Q50Q1_FULL=[Q50Q1,Q50Q1];
Q50Q2_FULL=[Q50Q2,Q50Q2];
BSYS100=[BSY1BEG,DBSY01A,IMBSY1,DBSY01B,IMBSY2,DBSY01C,IMBSY3,DBSY01D,IMBSY34,DBSY01E,IMBSY1B,DBSY01F,IMBSY2B,DBSY01G,IMBSY3B,DBSY01H,FFTBORGN,DBSY01I];
S100SXRA=[S100,ZLIN15,DBSY50A,YCBSYQ1,DBSY50B,Q50Q1_FULL,DBSY02A,WOODDOOR];
S100SXRB=[DBSY02B,BPMBSYQ1,DBSY51A,XCBSYQ2,DBSY51B,Q50Q2_FULL,DBSY52A,BPMBSYQ2,DBSY52B];
S100SXR=[S100SXRA,S100SXRB];
%BSYSXR : LINE=(BSYbeg,BSYS100,S100SXR)
%S100BSY1 : LINE=(S100SXR,KCUSXRa,DBSY52c1,SWIVEL,DBSY52c2,BXSP1Ha,BXSP1Hb)
%BSY1 : LINE=(BSYS100,S100BSY1)
%BSY : LINE=(BSYbeg,BSY1,BSY1END,SPhBSY)
% ------------------------------------------------------------------------------
% BSY downstream of scH merge bend (BXSP1H)
% ------------------------------------------------------------------------------
% note: the K-values below are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQ50Q3 =   0.426937957729 ;% 0.426937957729 
KQ4 =  -0.219608310315 ;%-0.219608310249
KQ5 =   0.110245649911 ;% 0.11024564993
KQ6 =  -0.109735122424 ;%-0.109735122471
KQA0 =   0.096565286277 ;% 0.096565286297
Q50Q3={'qu' 'Q50Q3' 0.143254 [KQ50Q3 0]}';
Q4={'qu' 'Q4' LQF/2 [KQ4 0]}';
Q5={'qu' 'Q5' LQF/2 [KQ5 0]}';
Q6={'qu' 'Q6' LQF/2 [KQ6 0]}';
QA0={'qu' 'QA0' LQF/2 [KQA0 0]}';
% PM projections onto BSY beamline
SBKRAPM =   1.055 ;%PM effective straight length (m)
ABKRAPM0 =  -0.276615046502E-2 ;%PM bend angle (PM's have been decommissioned)
ZBKRAPM1 =   SBKRAPM*cos(ABKRAPM0*1/2);
ZBKRAPM2 =   SBKRAPM*cos(ABKRAPM0*3/2);
ZBKRAPM3 =   SBKRAPM*cos(ABKRAPM0*5/2);
ZBKRAPM4 =   SBKRAPM*cos(ABKRAPM0*7/2);
% PM drifts projected onto BSY beamline
LDAPM =   0.5951 ;%space between two PMs along (decommissioned) A-line trajectory
LPCAPM =   0.1824 ;%length of PM collimator along BSY beamline
LDZAPM1 =  (LDAPM*cos(1*ABKRAPM0)-LPCAPM)/2;
LDZAPM2 =  (LDAPM*cos(2*ABKRAPM0)-LPCAPM)/2;
LDZAPM3 =  (LDAPM*cos(3*ABKRAPM0)-LPCAPM)/2;
LDZAPM4 =  (LDAPM*cos(4*ABKRAPM0)-LPCAPM)/2;
LDA01 =   0.1971765;
LDA02 =   4.371494-LDA01-1.35/cos(4*ABKRAPM0);
LDZA01 =   LDA01*cos(4*ABKRAPM0);
LDZA02 =   LDA02*cos(4*ABKRAPM0);
LPCBSYH =   0.45;
LPC90 =   0.453644;
LPC119 =   0.453644;
ZQ5 =  0.0 ;%adjust position of Q5
ZQ6 =  0.0 ;%adjust position of Q6
DBSY53A={'dr' '' 0.091696 []}';
DBSY53B={'dr' '' 0.610705 []}';
DBSY53C={'dr' '' 0.779945 []}';
DBSY53F={'dr' '' 0.5 []}';
DBSY53D={'dr' '' 4.0-DBSY53A{3}-DBSY53B{3}-DBSY53C{3}-DBSY53F{3} []}';
DBSY53G={'dr' '' 1.2 []}';
DBSY53GA={'dr' '' 0.91293 []}';
DBSY53GB={'dr' '' DBSY53G{3}-DBSY53GA{3}-LPLATE []}';
DBKRAPM1A={'dr' '' ZBKRAPM1/2 []}';
DBKRAPM1B={'dr' '' ZBKRAPM1/2 []}';
DZAPM1={'dr' '' LDZAPM1 []}';
DBKRAPM2A={'dr' '' ZBKRAPM2/2 []}';
DBKRAPM2B={'dr' '' ZBKRAPM2/2 []}';
DZAPM2A={'dr' '' LDZAPM2/2 []}';
DSCAPM2={'dr' '' 0.0 []}';
DZAPM2B={'dr' '' LDZAPM2/2 []}';
DZAPM2={'dr' '' LDZAPM2 []}';
DBKRAPM3A={'dr' '' ZBKRAPM3/2 []}';
DBKRAPM3B={'dr' '' ZBKRAPM3/2 []}';
DZAPM3={'dr' '' LDZAPM3 []}';
DBKRAPM4A={'dr' '' ZBKRAPM4/2 []}';
DBKRAPM4B={'dr' '' ZBKRAPM4/2 []}';
DZAPM4={'dr' '' LDZAPM4 []}';
DZA01={'dr' '' LDZA01 []}';
DZA02={'dr' '' LDZA02 []}';
DBSY53H={'dr' '' 34.45562-DBSY53G{3}-ZBKRAPM1-ZBKRAPM2-ZBKRAPM3-ZBKRAPM4-2*LDZAPM1-2*LDZAPM2-2*LDZAPM3-LDZAPM4-LDZA01-LDZA02-LPCBSYH-4*LPCAPM+ZQ5 []}';
DBSY54A={'dr' '' 0.5 []}';
DBSY54B={'dr' '' 3.22454-ZQ5 []}';
DBSY54C={'dr' '' 19.260056-DBSY54A{3}-DBSY54B{3}-ZQ5+ZQ6 []}';
DBSY55A={'dr' '' 0.5 []}';
DBSY55B={'dr' '' 4.226742 []}';
DBSY55C={'dr' '' 8.016028-ZQ6 []}';
DBSY55D={'dr' '' 6.466828 []}';
DBSY55E={'dr' '' 21.826764-DRFB{3}-DBSY55A{3}-DBSY55B{3}-LPC90-DBSY55C{3}-LPLATE-DBSY55D{3}-LPC119-ZQ6 []}';
DM3={'dr' '' 0.8438 []}';
DM4A={'dr' '' 0.441 []}';
DM4C={'dr' '' 0.331133-LJAW/2 []}';
DM4D={'dr' '' 1.168867-LJAW/2 []}';
DM4DA={'dr' '' 0.27685 []}';
DM4DB={'dr' '' DM4D{3}-DM4DA{3}-LPLATE []}';
DM4B={'dr' '' 8.851641-DM4A{3}-DM4C{3}-DM4D{3}-LJAW-1.717774 []}';
DXCA0={'dr' '' 0.31 []}';
DYCA0={'dr' '' 0.509021 []}';
DM5={'dr' '' 0.790979 []}';
DM6={'dr' '' 0.567588 []}';
DMONI={'dr' '' 0.009525 []}';
BPMBSYQ3={'mo' 'BPMBSYQ3' 0 []}';%per C. Iverson
RFBBSYQ3={'dr' '' 0 []}';
BPMBSYQ4={'mo' 'BPMBSYQ4' 0 []}';
BPMBSYQ5={'mo' 'BPMBSYQ5' 0 []}';%per C. Iverson
BPMBSYQ6={'mo' 'BPMBSYQ6' 0 []}';%per C. Iverson
RFBBSYQ6={'dr' '' 0 []}';
BPMBSYQA0={'mo' 'BPMBSYQA0' 0 []}';%per C. Iverson
XCBSYQ3={'mo' 'XCBSYQ3' 0 []}';%barcode=4602
XCBSYQ5={'mo' 'XCBSYQ5' 0 []}';%barcode=2100
XCA0={'mo' 'XCA0' 0 []}';%barcode=2195
YCBSYQ4={'mo' 'YCBSYQ4' 0 []}';%barcode=4603
YCBSYQ6={'mo' 'YCBSYQ6' 0 []}';%barcode=2107
YCA0={'mo' 'YCA0' 0 []}';%barcode=2195
PCBSY3={'mo' 'PCBSY3' LPLATE []}';%shielding plate
PCBSY4={'mo' 'PCBSY4' LPLATE []}';%shielding plate
D2={'mo' 'D2' 0.43 []}';%stopper
ST60={'mo' 'ST60' 0.76 []}';%backup stopper
DM60={'mo' 'DM60' 0 []}';%"disaster" BTM behind ST60
PCBSY5={'mo' 'PCBSY5' LPLATE []}';%shielding plate
ST61={'mo' 'ST61' 0.76 []}';%backup stopper
PCAPM1={'dr' 'PCAPM1' LPCAPM []}';
PCAPM2={'dr' 'PCAPM2' LPCAPM []}';
PCAPM3={'dr' 'PCAPM3' LPCAPM []}';
PCAPM4={'dr' 'PCAPM4' LPCAPM []}';
PCBSYH={'dr' '' 0.45 []}';%installed, then removed
PC90={'dr' 'PC90' LPC90 []}';%existing protection collimator in BSY
PC119={'dr' 'PC119' LPC119 []}';%existing protection collimator in BSY
CXQ6={'dr' 'CXQ6' LJAW []}';
MUWALL={'mo' 'MUWALL' 0 []}';%front face of muon wall for HXR beam
DUMPBSYH={'mo' 'DUMPBSYH' 0 []}';%front face of BSY dump for HXR beam
BSYEND={'mo' 'BSYEND' 0 []}';%LTUH side of muon plug wall: Z=3224.022426 (Z'=176.020508 m, X'=0.0 m, Y'=-0.821761 m)
RWWAKE3H={'mo' 'RWWAKE3H' 0 []}';%BSY/SPRDH beampipe wake applied here
Q50Q3_FULL=[Q50Q3,Q50Q3];
Q4_FULL=[Q4,BPMBSYQ4,Q4];
Q5_FULL=[Q5,BPMBSYQ5,Q5];
Q6_FULL=[Q6,BPMBSYQ6,Q6];
QA0_FULL=[QA0,BPMBSYQA0,QA0];
BSYH=[BEGBSYH,DBSY52D,Q50Q3_FULL,DBSY53A,BPMBSYQ3,RFBBSYQ3,DBSY53B,DBSY53C,XCBSYQ3,DBSY53D,YCBSYQ4,DBSY53F,Q4_FULL,DBSY53GA,PCBSY3,DBSY53GB,DBKRAPM1A,DBKRAPM1B,DZAPM1,PCAPM1,DZAPM1,DBKRAPM2A,DBKRAPM2B,DZAPM2A,DSCAPM2,DZAPM2B,PCAPM2,DZAPM2,DBKRAPM3A,DBKRAPM3B,DZAPM3,PCAPM3,DZAPM3,DBKRAPM4A,DBKRAPM4B,DZAPM4,PCAPM4,DZA01,DZA02,PCBSYH,DBSY53H,Q5_FULL,DBSY54A,XCBSYQ5,DBSY54B,DBSY54C,Q6_FULL,DRFB,RFBBSYQ6,DBSY55A,YCBSYQ6,DBSY55B,PC90,DBSY55C,PCBSY4,DBSY55D,PC119,DBSY55E,D2,DM3,ST60,DM4A,DM60,DM4B,CC31,DM4C,CXQ6,DM4DA,PCBSY5,DM4DB,XCA0,DXCA0,YCA0,DYCA0,ST61,DM5,QA0_FULL,DM6,DMONI,DMONI,MUWALL,DWALLA,DUMPBSYH,DWALLB,BSYEND,RWWAKE3H,ENDBSYH];
% ------------------------------------------------------------------------------
% HXR VBEND
% ------------------------------------------------------------------------------
KQVM1 =  -0.337437273245;
KQVM2 =   0.236577259392;
KQVM3 =   0.715150825176;
KQVM4 =  -0.681650171006;
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
ABYKIK =  0 ;%full angle (BYKIK1+BYKIK2) = 0.75E-3 when BYKIK1,2 are turned on
BYKIK11={'be' 'BYKIK1' LKIK/2 [ABYKIK/4 GKIK ABYKIK/4 0 0.5 0 pi/2]}';
BYKIK12={'be' 'BYKIK1' LKIK/2 [ABYKIK/4 GKIK 0 ABYKIK/4 0 0.5 pi/2]}';
BYKIK21={'be' 'BYKIK2' LKIK/2 [ABYKIK/4 GKIK ABYKIK/4 0 0.5 0 pi/2]}';
BYKIK22={'be' 'BYKIK2' LKIK/2 [ABYKIK/4 GKIK 0 ABYKIK/4 0 0.5 pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BYKIK1={'be' 'BYKIK' LKIK [ABYKIK/2 GKIK ABYKIK/4 ABYKIK/4 0.5 0.5 pi/2]}';
BYKIK2={'be' 'BYKIK' LKIK [ABYKIK/2 GKIK ABYKIK/4 ABYKIK/4 0.5 0.5 pi/2]}';
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
DMUON1={'dr' '' 0.186743984144 []}';%0.154859 +0.05
DMUON2={'dr' '' 0.018115015856 []}';%0.0
DMUON4={'dr' '' 0.093980765446-LRFBUB/2 []}';%0.059608016 +0.009373
DMUON3={'dr' '' 0.310592-0.05-DMUON4{3}-LRFBUB []}';
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
RFBDL1={'dr' '' 0 []}';
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
BWGH =  0                       ;%wiggler bend field (kG)
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
WIG1H1={'dr' '' LWG1H []}';
WIG1H2={'dr' '' LWG2H []}';
WIG2H1={'dr' '' LWGH []}';
WIG2H2={'dr' '' LWGH []}';
WIG3H1={'dr' '' LWG2H []}';
WIG3H2={'dr' '' LWG1H []}';
% define unsplit SBENs for BMAD ... not used by MAD
WIG1H={'dr' '' LWGH []}';
WIG2H={'dr' '' 2*LWGH []}';
WIG3H={'dr' '' LWGH []}';
LDWGH =  ZDWG/cos(AWGH);
DWGH={'dr' '' LDWGH []}';
YCWIGH={'dr' '' 0 []}';
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
KQEM1 =  -0.390827735988;
KQEM2 =   0.43221570814;
KQEM3 =  -0.593433950371;
KQEM4 =   0.420485259232;
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
RFBEM4={'dr' '' 0 []}';
BPME31={'mo' 'BPME31' 0 []}';
BPME32={'mo' 'BPME32' 0 []}';%existing LCLS device
RFBE32={'dr' '' 0 []}';
BPME33={'mo' 'BPME33' 0 []}';
BPME34={'mo' 'BPME34' 0 []}';%existing LCLS device
RFBE34={'dr' '' 0 []}';
BPME35={'mo' 'BPME35' 0 []}';
BPME36={'mo' 'BPME36' 0 []}';%existing LCLS device
RFBE36={'dr' '' 0 []}';
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
EDCEL=[WS31,D40CM,DE3MA,PC09,BTM09,DE3MB,XCE31,DQEA,QE31_FULL,DQEBX,DCX31,DQEBX2,DE3A,YCE32,DQEAA,QE32_FULL,DRFB,RFBE32,DQEBY1,DCY32,DQEBY2,WS32,D40CM,DE3M80CMB,XCE33,DQEAB,QE33_FULL,DQECA,YAGPSI,DQECB,OTR33,DE3M40CM,YCE34,DQEA,QE34_FULL,DRFB,RFBE34,DQEC1,WS33,D40CM,DE3M80CM,XCE35,DQEAC,QE35_FULL,DQEBX,DCX35,DQEBX2,DE3,YCE36,DQEA,QE36_FULL,DRFB,RFBE36,DQEBY1,DCY36,DQEBY2,WS34];
% ------------------------------------------------------------------------------
% HXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
% note: the below K-values come from Y. Nosochkov's UNDH_KQ4_USDS.xsif file,
%       for E= 4.0 GeV and KHXU= 2.0 (IntgHX= 30.0 kG)
KQUM1 =   0.217807105099;
KQUM2 =  -0.260867145661;
KQUM3 =   0.462571229525;
KQUM4 =  -0.415827146064;
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
UNMCH=[DU1M80CMA,DWS36,DU1M80CMB,DCX37,D32CMC,XCUM1,DUM1A,QUM1_FULL,DUM1B,D32CM,DU2M120CM,DCY38,D32CMA,YCUM2,DUM2A,QUM2_FULL,DUM2B,DU3M80CM,XCUM3,DUM3A,QUM3_FULL,DUM3B,D40CMA,EOBLM,DU4M120CM,YCUM4,DUM4A,QUM4_FULL,DUM4B,RFB07,DU5M80CM,IMUNDI,D40CMWA,BLTOF,D40CMWB,MUHWALL1,DUHWALL1,DUHVESTA,RFB08,DUHVESTB,MUHWALL2,DUHWALL2,DW2TDUND,DTDUND1,TDUND,DTDUND2,DPCMUON,PCMUON,DMUON1,VV999,DMUON2];
PREUNDH=[DMUON3,RFBHX12,DMUON4,MM3,PFILT1,DBMARK37];
LTU=[VBSYS,MM1,DOGLG2A,DOGLG2B,MM2,EDMCH,EDSYS,UNMCH,RWWAKE4H,ENDLTUH,BEGUNDH,PREUNDH];
LTUM=[MM1,DOGLG2A,DOGLG2B,MM2,EDMCH,EDSYS,UNMCH,RWWAKE4H,ENDLTUH,BEGUNDH,PREUNDH];
% ------------------------------------------------------------------------------
% HXR dumpline
% ------------------------------------------------------------------------------
KQDMP =  -0.155212710055 ;%Yuri (E=4.0, K=2.0)
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
PCEBD={'dr' 'PCEBD' 0 []}';
DD1A={'dr' '' 0.577681302427 []}';
DD1B={'dr' '' 1.000087502327 []}';
DD1C={'dr' '' 0.3048 []}';
DD1E={'dr' '' 0.249638105611 []}';
DD1F={'dr' '' 0.409240058046 []}';
DD1D={'dr' '' LDMP1-(DD1A{3}+PCPM1L{3}+DD1B{3}+DD1C{3}+DD1E{3}+PCPM2L{3}+DD1F{3}) []}';
BPMQD={'mo' 'BPMQD' 0 []}';%RFBQD : MONI, TYPE="@2,CavityL-1"
BPMDD={'mo' 'BPMDD' 0 []}';
RFBDD={'dr' '' 0 []}';
XCDD={'mo' 'XCDD' 0 []}';
YCDD={'mo' 'YCDD' 0 []}';
OTRDMP={'mo' 'OTRDMP' 0 []}';%Dump screen
WSDUMP={'dr' '' 0 []}';
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
DUMPLINE=[BEGDMPH_2,RODMP1H,BYDSH_FULL,DS1,BYD1_FULL,DS,BYD2_FULL,DS,BYD3_FULL,DD1A,PCPM1L,BTM1L,DD1B,MIMDUMP,DD1C,MIMBCS4,DD1D,YCDD,DD1E,PCPM2L,BTM2L,DD1F,QDMP1_FULL,DD12A,BPMQD,DD12B,MQDMP,DD12C,QDMP2_FULL,DD2A,XCDD,DD2B,DD2C,DD3A,BPMDD,DD3B,OTRDMP,DWSDUMPA1,PCEBD,DWSDUMPA2,RFBDD,DWSDUMPB,WSDUMP,DWSDUMPC,RODMP2H,DUMPFACE,DDUMP,DMPEND,BTMDUMP,DBMARK38,ENDDMPH_2];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc undulator
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 06-NOV-2025, M. Woodley
% * per H.-D. Nuhn:
%   - replace short-period undulator with long-period undulator in SXR cell 36
%   - replace short-period phase shifter with long-period phase shifter in SXR
%     cells 41, 42, 43, and 44
% ------------------------------------------------------------------------------
% 21-OCT-2025, M. Woodley
% * per H.-D. Nuhn:
%   - replace short-period undulator with long-period undulator in SXR cell 34
%   - replace short-period phase shifter with long-period phase shifter in SXR
%     cell 40
% ------------------------------------------------------------------------------
% 05-OCT-2025, M. Woodley
% * replace short-period phase shifters with long-period phase shifters
%   in SXR cells 38 and 39 per H.-D. Nuhn
% ------------------------------------------------------------------------------
% 10-SEP-2025, M. Woodley
% * replace short-period undulator and phase shifter with long-period undulator
%   and phase shifter in SXR cell 33
% * replace short-period phase shifter with long-period phase shifter in SXR
%   cells 34, 36, and 37
% ------------------------------------------------------------------------------
% 28-JUL-2025, M. Woodley (SDT 2025)
% * replace short-period undulator and phase shifter with long-period undulator
%   and phase shifter: SXR cellS 29, 30, 31, and 32
% * replace short-period phase shifter with long-period phase shifter in SXR
%   cell 33
% ------------------------------------------------------------------------------
% 11-MAY-2025, M. Woodley
%  * replace short-period undulator and phase shifter in SXR cell 28 with a
%    long-period undulator and phase shifter
%  * fix lengths of DU3S_ and DU4S_ to locate long-period phase shifters per
%    X. Permanyer email
% ------------------------------------------------------------------------------
% 24-APR-2025, M. Woodley
%  * replace short-period undulator and phase shifter in SXR cell 27 with a
%    long-period undulator and phase shifter
% ------------------------------------------------------------------------------
% 10-APR-2025, M. Woodley
%  * replace short-period undulator and phase shifter in SXR cell 26 with a
%    long-period undulator and phase shifter
% ------------------------------------------------------------------------------
% 07-FEB-2025, M. Woodley
%  * remove MBLMS MARKERs from all even-numbered SXR cells (16-46)
%  * remove MBLMH MARKERs from all odd-numbered HXR cells (15-47)
%  * add a long-period undulator plus phase shifter in SXR cell 21
%  * NOTE: replacement of undulator in SXR cell 47 put off until later
% 18-JAN-2025, M. Woodley
%  * fix lengths of DU3S_ and DU4S_ (long-period phase shifters)
% 17-JAN-2025, M. Woodley
%  * replace short-period undulator in SXR cell 47 with a long-period undulator
% ------------------------------------------------------------------------------
% 23-DEC-2024, M. Woodley
%  * per H.-D. Nuhn:
%    - use KSXU= 5.5, KSXU_= 4.5, PIPSSX=PIPSSX_= 1800
%    - restore QSXH16
%    - operational long-period undulators and phase shifters in SXR cells 22-25
% 19-DEC-2024, M. Woodley
%  * per X. Permanyer: move SXR long-period phase shifters ~10.99 mm upstream
% 10-DEC-2024, M. Woodley
%  * per H.-D. Nuhn: add long-period undulators, phase shifters, and BLMs in
%    SXR cells 22 and 23
% 05-DEC-2024, M. Woodley
%  * per H.-D. Nuhn: turn on long-period undulators in SXR cells 24 and 25;
%    add BLMs; add long-period phase shifters
% 04-DEC-2024, M. Woodley
%  * relocate RFBSX15 per X. Permanyer
% 18-SEP-2024, M. Woodley
%  * add SXR interspace quadrupoles and RFBPMs in cells 17, 18, 20, and 25
%  * turn ON all SXR quadrupoles in cells 17-25
%  * remove quadrupole SXR cell 16
%  * add RFBSX15 at end of LTUS (LCLS-II-HE location)
%  * add (inoperative) long-period undulators in SXR cells 24 and 25;
%    no phase shifters
% ------------------------------------------------------------------------------
% 01-SEP-2024, M. Woodley
%  * add quadrupole (not powered) and RFBPM to SXR cells 22 and 23
%  * VVs are in SXR cells 21, 28, 34, 35, 38, and 44 per X. Permanyer
%  * include long-period undulator definitions ... comment out short-period
%    definitions and uncomment long-period definitions as cells are upgraded
% ------------------------------------------------------------------------------
% 13-APR-2024, M. Woodley
%  * rename BODCBX42 -> YAGCBX42
%  * add BODCBX40
% ------------------------------------------------------------------------------
% 31-MAR-2024, M. Woodley
%  * remove WIGXLh from SXR cell 18 (move to LTUS)
% ------------------------------------------------------------------------------
% 12-JAN-2024, M. Woodley
%  * adjust complement and locations of CBXFEL components per SLAC-I-120-022-R2
% ------------------------------------------------------------------------------
% 02-MAR-2023, M. Woodley
%  * reomve FSPEPX1 and FSPEPX3 (PEPPEx Phase 2) per X. Permanyer
% 17-FEB-2023, M. Woodley
%  * change TYPE of SXR undulators to "VGHPU39"
% 07-FEB-2023, M. Woodley
%  * modified SXR undulator end area: single (1.5 m long) TCX01B per P. Krejcik
% 20-DEC-2022, M. Woodley
%  * relocate BCXHS1 and BCXHS4 to as-built locations per Metrology
% ------------------------------------------------------------------------------
% 15-JUL-2022, M. Woodley
%  * install CBXFEL chicanes in HXR cells 13 and 21 * per X. Permanyer
% 29-APR-2022, M. Woodley
%  * change names of CBXFEL chicane dipoles from BCXCB* to BCXCBX* per G. Marcus
% ------------------------------------------------------------------------------
% 11-OCT-2021, M. Woodley
%  * add CBXFEL chicane in HXR cell 21
%  * add phase shifter to HXR cell 46 per G. Kraft
%  * add HXU/BLM/QUAD/RFBPM to HXR cell 47 (no phase shifter, no VV) per G. Kraft
% ------------------------------------------------------------------------------
% 26-MAR-2021, M. Woodley
%  * add PEPPEx devices at end of SXR
%  * add VGCCPEPX1 and VGPRPEPX1 (INST) per S. Alverson
% ------------------------------------------------------------------------------
% 18-JAN-2021, M. Woodley
%  * install final nominal LCLS-II HXR cells (#13, #14, #15, #16, and #17)
% ------------------------------------------------------------------------------
% 28-OCT-2020, M. Woodley
%  * install nominal LCLS-II HXR cells #19 and #20
% ------------------------------------------------------------------------------
% 19-OCT-2020, M. Woodley
%  * install nominal LCLS-II HXR cells #22 and #23
% ------------------------------------------------------------------------------
% 02-OCT-2020, M. Woodley
%  * install nominal LCLS-II cell HXR #18
% 30-AUG-2020, M. Woodley
%  * replace BLMS* and BLMH* (INST) with MBLMS* and MBLMH* (MARK)
% ------------------------------------------------------------------------------
% 03-MAR-2020, M. Woodley
%  * move XLEAP wiggler to SXR cell #18
%  * change keyword for "type-V" correctors from HKIC/VKIC to INST
% 25-FEB-2020, M. Woodley
%  * replace HXR cells 13-20 and 22-23 with "empty" (no undulator) LCLS girders
%    > redefine QUADs and RFBPMs (different lengths)
% ------------------------------------------------------------------------------
% 12-DEC-2019, M. Woodley
%  * swap HXR cells 20 and 21 ... cell 21 is now the empty cell per H.-D. Nuhn
%  * add "h" to HXR and SXR undulators, quadrupoles, and phase shifters
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
%Eu   :  definition moved to LCLS2sc_master.xsif and LCLS2cu_master.xsif
GAMU =  EU/MC2 ;%Lorentz energy factor in undulator [ ]
% ------------------------------------------------------------------------------
% SXR definitions
% ------------------------------------------------------------------------------
% ##############################################################################
% SXR: short-period undulator and phase shifter definitions (LCLS-II)
% ##############################################################################
% ------------------------------------------------------------------------------
% undulator segment
% ------------------------------------------------------------------------------
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited Mar 03, 2014
% - 7.2 mm miminum Undulator Gap; only constant break length each
% - include natural vertical focusing over all but edge terminations
% ------------------------------------------------------------------------------
% - LDUSEGS = SXR Undulator segment length
% - luSXU   = SXR Undulator period
% - NpSXU   = SXR Undulator period count
% - LSXUCR  = SXR Undulator magnetic length
% - LSXUe   = SXR Undulator spacing between magnet array and strongback end
% - KSXU    = SXR Undulator parameter (rms); range 2-5.5
% - kQSX    = natural SXR undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LDUSEGS =  3.4;
LUSXU =  0.039                            ;%m
NPSXU =  87;
LSXUCR =  LUSXU*NPSXU                      ;%m
LSXUE =  (LDUSEGS-LSXUCR)/2               ;%m
LSXUH =  LSXUCR/2;
KSXU =  5.5 ;%5.0
KQSX =  (KSXU*2*PI/LUSXU/sqrt(2)/GAMU)^2 ;%m^-2
UMASXH={'un' 'UMASXH' LSXUH [KQSX LUSXU 1]}';
% ------------------------------------------------------------------------------
% PPM phase shifter
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
LPSSX =  0.0825                             ;%m
LUPSSX =  0.075                              ;%m
LPSSXH =  LPSSX/2;
PIPSSX =  1800 ;%3814                         T^2mm^3 (180-3814)
KPSSX =  1.E-9*CLIGHT/MC2*sqrt(2.E-9*PIPSSX/LUPSSX);
KQPSSX =  (KPSSX*2*PI/LUPSSX/sqrt(2)/GAMU)^2 ;%m^-2
PSSXH={'un' 'PSSXH' LPSSXH [KQPSSX LUPSSX 1]}';
% ------------------------------------------------------------------------------
% FODO cell drifts
% ------------------------------------------------------------------------------
% - DTSXU = SXU undulator segment small terminations modeled as drift
% ------------------------------------------------------------------------------
LDU1S =  0.1;
LDU2S =  0.03;
LDU3S =  0.25-LPSSXH -0.04 -0.005;
LDU4S =  (0.25-LPSSXH-0.5*LQU)/2 +0.04 +0.005;
LDU5S =  (0.25-LPSSXH-0.5*LQU)/2;
LDU6S =  0.12-LQU/2-LRFBUB/2 +0.01;
LDU7S =  0.25-LRFBUB/2 -0.01;
DLDU0S =  0.0 ;%fine tune Z in undulator
LDU0S =  2.1359-LDU6S-LDU7S-LQU +DLDU0S;
DTSXU={'dr' '' LSXUE []}';
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
DU0SA={'dr' '' 0.814408 []}';%0.7908811950945
DU0SB={'dr' '' DU0S{3}-DU0SA{3}-LRFBUB []}';
DU3SA={'dr' '' 0.114 []}';
DU3SB={'dr' '' DU3S{3}-DU3SA{3} []}';
DU4SA={'dr' '' 0.117258 []}';
DU4SB={'dr' '' DU4S{3}-DU4SA{3} []}';
% ##############################################################################
% SXR: long-period undulator and phase shifter definitions (LCLS-II-HE)
% ##############################################################################
% ------------------------------------------------------------------------------
% undulator segment
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited June 22, 2020 (LCLS-II-HE)
% - 7.2 mm miminum Undulator Gap; only constant break length each
% - include natural vertical focusing over all but edge terminations
% ------------------------------------------------------------------------------
% - LDUSEGS_ = SXR Undulator segment length
% - luSXU_   = SXR Undulator period
% - NpSXU_   = SXR Undulator period count
% - LSXUCR_  = SXR Undulator magnetic length
% - LSXUe_   = SXR Undulator spacing between magnet array and strongback end
% - KSXU_    = SXR Undulator parameter (rms); range 2-5.5
% - kQSX_    = natural SXR undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LDUSEGS_ =  3.4;
LUSXU_ =  0.056                              ;%m
NPSXU_ =  60;
LSXUCR_ =  LUSXU_*NPSXU_                      ;%m
LSXUE_ =  (LDUSEGS_-LSXUCR_)/2               ;%m
LSXUH_ =  LSXUCR_/2;
KSXU_ =  4.5 ;%8.3
KQSX_ =  (KSXU_*2*PI/LUSXU_/sqrt(2)/GAMU)^2 ;%m^-2
UMASXH_={'un' 'UMASXH_' LSXUH_ [KQSX_ LUSXU_ 1]}';
% ------------------------------------------------------------------------------
% PPM phase shifter
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Last edited September 06, 2017
% - 10.0 mm miminum Undulator Gap
% ------------------------------------------------------------------------------
% - LPSSX_  = SXR Phase Shifter length
% - luPSSX_ = SXR Phase Shifter period
% - PIPSSX_ = SXR Phase Shifter phase integral
% - KPSSX_  = SXR Phase Shifter Undulator parameter (rms); range 1.34-3.59
% - kQPSSX_ = natural SXR Phase Shifter undulator focusing "k" in y-plane
% ------------------------------------------------------------------------------
LPSSX_ =  0.1073                               ;%m
LUPSSX_ =  0.0975                               ;%m
LPSSXH_ =  LPSSX_/2;
PIPSSX_ =  1800 ;%5700                           T^2mm^3
KPSSX_ =  1.E-9*CLIGHT/MC2*sqrt(2.E-9*PIPSSX_/LUPSSX_);
KQPSSX_ =  (KPSSX_*2*PI/LUPSSX_/sqrt(2)/GAMU)^2 ;%m^-2
PSSXH_={'un' 'PSSXH_' LPSSXH_ [KQPSSX_ LUPSSX_ 1]}';
% ------------------------------------------------------------------------------
% FODO cell drifts
% ------------------------------------------------------------------------------
% - DTSXU_ = SXU undulator segment small terminations modeled as drift
% ------------------------------------------------------------------------------
LDU3S_ =  0.25-LPSSXH_-0.04-0.005-0.010996;
LDU4S_ =  (0.25-LPSSXH_-0.5*LQU)/2+0.04+0.005-0.0062+0.010996;
LDU5S_ =  (0.25-LPSSXH_-0.5*LQU)/2+0.0062;
DTSXU_={'dr' '' LSXUE_ []}';
DU3S_={'dr' '' LDU3S_ []}';
DU4S_={'dr' '' LDU4S_ []}';
DU5S_={'dr' '' LDU5S_ []}';
DU4SB_={'dr' '' DU4S_{3}-DU4SA{3} []}';
DU3SB_={'dr' '' DU3S_{3}-DU3SA{3} []}';
% ##############################################################################
% SXR: common definitions
% NOTE: not all definitions are used until SXR upgrade is complete
% ##############################################################################
% ------------------------------------------------------------------------------
% SXR undulator X-steering coils in undulator segments
% ------------------------------------------------------------------------------
XCSU21={'mo' 'XCSU21' 0 []}';
XCSU22={'mo' 'XCSU22' 0 []}';
XCSU23={'mo' 'XCSU23' 0 []}';
XCSU24={'mo' 'XCSU24' 0 []}';
XCSU25={'mo' 'XCSU25' 0 []}';
XCSU26={'mo' 'XCSU26' 0 []}';
XCSU27={'mo' 'XCSU27' 0 []}';
XCSU28={'mo' 'XCSU28' 0 []}';
XCSU29={'mo' 'XCSU29' 0 []}';
XCSU30={'mo' 'XCSU30' 0 []}';
XCSU31={'mo' 'XCSU31' 0 []}';
XCSU32={'mo' 'XCSU32' 0 []}';
XCSU33={'mo' 'XCSU33' 0 []}';
XCSU34={'mo' 'XCSU34' 0 []}';
% ----35
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
YCSU21={'mo' 'YCSU21' 0 []}';
YCSU22={'mo' 'YCSU22' 0 []}';
YCSU23={'mo' 'YCSU23' 0 []}';
YCSU24={'mo' 'YCSU24' 0 []}';
YCSU25={'mo' 'YCSU25' 0 []}';
YCSU26={'mo' 'YCSU26' 0 []}';
YCSU27={'mo' 'YCSU27' 0 []}';
YCSU28={'mo' 'YCSU28' 0 []}';
YCSU29={'mo' 'YCSU29' 0 []}';
YCSU30={'mo' 'YCSU30' 0 []}';
YCSU31={'mo' 'YCSU31' 0 []}';
YCSU32={'mo' 'YCSU32' 0 []}';
YCSU33={'mo' 'YCSU33' 0 []}';
YCSU34={'mo' 'YCSU34' 0 []}';
% ----35
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
% SXR undulator quadrupoles
% ------------------------------------------------------------------------------
% - IntgSX = integrated quadrupole gradient
% - GQFSX  = QF and QD gradients can be made different to compensate for
%            undulator focussing ...
% - GQDSX  = ... but since undulator focussing depends on gamma^2, compensation
%            will only work for one energy
% - kQFSX  = QF undulator quadrupole focusing "k"
% - kQDSX  = QD undulator quadrupole focusing "k"
% ------------------------------------------------------------------------------
%IntgSX :   definition moved to LCLS2sc_main.xsif and LCLS2cu_main.xsif
GQFSX =   INTGSX/LQU/10*1.0           ;%T/m
GQDSX =  -INTGSX/LQU/10*1.0           ;%T/m
KQFSX =   1.E-9*GQFSX*CLIGHT/GAMU/MC2 ;%m^-2
KQDSX =   1.E-9*GQDSX*CLIGHT/GAMU/MC2 ;%m^-2
KQSX16 =   1.28543316536               ;% 1.30061673442
KQSX47 =  -2.295714281502              ;%Yuri (E=4.0, K=5.0)
QSXH16={'qu' 'QSXH16' LQU/2 [KQSX16 0]}';
QSXH17={'qu' 'QSXH17' LQU/2 [KQDSX 0]}';
QSXH18={'qu' 'QSXH18' LQU/2 [KQFSX 0]}';
QSXH19={'qu' 'QSXH19' LQU/2 [KQDSX 0]}';
QSXH20={'qu' 'QSXH20' LQU/2 [KQFSX 0]}';
QSXH21={'qu' 'QSXH21' LQU/2 [KQDSX 0]}';
QSXH22={'qu' 'QSXH22' LQU/2 [KQFSX 0]}';
QSXH23={'qu' 'QSXH23' LQU/2 [KQDSX 0]}';
QSXH24={'qu' 'QSXH24' LQU/2 [KQFSX 0]}';
QSXH25={'qu' 'QSXH25' LQU/2 [KQDSX 0]}';
QSXH26={'qu' 'QSXH26' LQU/2 [KQFSX 0]}';
QSXH27={'qu' 'QSXH27' LQU/2 [KQDSX 0]}';
QSXH28={'qu' 'QSXH28' LQU/2 [KQFSX 0]}';
QSXH29={'qu' 'QSXH29' LQU/2 [KQDSX 0]}';
QSXH30={'qu' 'QSXH30' LQU/2 [KQFSX 0]}';
QSXH31={'qu' 'QSXH31' LQU/2 [KQDSX 0]}';
QSXH32={'qu' 'QSXH32' LQU/2 [KQFSX 0]}';
QSXH33={'qu' 'QSXH33' LQU/2 [KQDSX 0]}';
QSXH34={'qu' 'QSXH34' LQU/2 [KQFSX 0]}';
QSXH35={'qu' 'QSXH35' LQU/2 [KQDSX 0]}';
QSXH36={'qu' 'QSXH36' LQU/2 [KQFSX 0]}';
QSXH37={'qu' 'QSXH37' LQU/2 [KQDSX 0]}';
QSXH38={'qu' 'QSXH38' LQU/2 [KQFSX 0]}';
QSXH39={'qu' 'QSXH39' LQU/2 [KQDSX 0]}';
QSXH40={'qu' 'QSXH40' LQU/2 [KQFSX 0]}';
QSXH41={'qu' 'QSXH41' LQU/2 [KQDSX 0]}';
QSXH42={'qu' 'QSXH42' LQU/2 [KQFSX 0]}';
QSXH43={'qu' 'QSXH43' LQU/2 [KQDSX 0]}';
QSXH44={'qu' 'QSXH44' LQU/2 [KQFSX 0]}';
QSXH45={'qu' 'QSXH45' LQU/2 [KQDSX 0]}';
QSXH46={'qu' 'QSXH46' LQU/2 [KQFSX 0]}';
QSXH47={'qu' 'QSXH47' LQU/2 [KQSX47 0]}';
% ------------------------------------------------------------------------------
% SXR undulator X-steering coils in quads
% ------------------------------------------------------------------------------
XCSX16={'mo' 'XCSX16' 0 []}';
XCSX17={'mo' 'XCSX17' 0 []}';
XCSX18={'mo' 'XCSX18' 0 []}';
XCSX19={'mo' 'XCSX19' 0 []}';
XCSX20={'mo' 'XCSX20' 0 []}';
XCSX21={'mo' 'XCSX21' 0 []}';
XCSX22={'mo' 'XCSX22' 0 []}';
XCSX23={'mo' 'XCSX23' 0 []}';
XCSX24={'mo' 'XCSX24' 0 []}';
XCSX25={'mo' 'XCSX25' 0 []}';
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
YCSX16={'mo' 'YCSX16' 0 []}';
YCSX17={'mo' 'YCSX17' 0 []}';
YCSX18={'mo' 'YCSX18' 0 []}';
YCSX19={'mo' 'YCSX19' 0 []}';
YCSX20={'mo' 'YCSX20' 0 []}';
YCSX21={'mo' 'YCSX21' 0 []}';
YCSX22={'mo' 'YCSX22' 0 []}';
YCSX23={'mo' 'YCSX23' 0 []}';
YCSX24={'mo' 'YCSX24' 0 []}';
YCSX25={'mo' 'YCSX25' 0 []}';
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
% SXR undulator BPMs
% ------------------------------------------------------------------------------
RFBSX15={'mo' 'RFBSX15' LRFBUB []}';
RFBSX16={'mo' 'RFBSX16' LRFBUB []}';
RFBSX17={'mo' 'RFBSX17' LRFBUB []}';
RFBSX18={'mo' 'RFBSX18' LRFBUB []}';
RFBSX19={'mo' 'RFBSX19' LRFBUB []}';
RFBSX20={'mo' 'RFBSX20' LRFBUB []}';
RFBSX21={'mo' 'RFBSX21' LRFBUB []}';
RFBSX22={'mo' 'RFBSX22' LRFBUB []}';
RFBSX23={'mo' 'RFBSX23' LRFBUB []}';
RFBSX24={'mo' 'RFBSX24' LRFBUB []}';
RFBSX25={'mo' 'RFBSX25' LRFBUB []}';
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
% SXR undulator Beam Loss Monitors (placeholders)
% ------------------------------------------------------------------------------
MBLMS17={'mo' 'MBLMS17' 0 []}';
MBLMS19={'mo' 'MBLMS19' 0 []}';
MBLMS21={'mo' 'MBLMS21' 0 []}';
MBLMS23={'mo' 'MBLMS23' 0 []}';
MBLMS25={'mo' 'MBLMS25' 0 []}';
MBLMS27={'mo' 'MBLMS27' 0 []}';
MBLMS29={'mo' 'MBLMS29' 0 []}';
MBLMS31={'mo' 'MBLMS31' 0 []}';
MBLMS33={'mo' 'MBLMS33' 0 []}';
% -----35
MBLMS37={'mo' 'MBLMS37' 0 []}';
MBLMS39={'mo' 'MBLMS39' 0 []}';
MBLMS41={'mo' 'MBLMS41' 0 []}';
MBLMS43={'mo' 'MBLMS43' 0 []}';
MBLMS45={'mo' 'MBLMS45' 0 []}';
MBLMS47={'mo' 'MBLMS47' 0 []}';
% ------------------------------------------------------------------------------
% SXR undulator inline valves, VAT Series 48
% ------------------------------------------------------------------------------
% post-SDT 2025
VVSXU21={'mo' 'VVSXU21' 0 []}';
VVSXU28={'mo' 'VVSXU28' 0 []}';
VVSXU34={'mo' 'VVSXU34' 0 []}';
VVSXU35={'mo' 'VVSXU35' 0 []}';
VVSXU38={'mo' 'VVSXU38' 0 []}';
VVSXU44={'mo' 'VVSXU44' 0 []}';
% ------------------------------------------------------------------------------
% markers
% ------------------------------------------------------------------------------
SXRSTART={'mo' 'SXRSTART' 0 []}';%start of undulator system
RWWAKE5S={'mo' 'RWWAKE5S' 0 []}';%SXR beampipe wake applied here
SXRTERM={'mo' 'SXRTERM' 0 []}';%~end of undulator system
% SXR quadrupole centers
MUQS16={'mo' 'MUQS16' 0 []}';
MUQS17={'mo' 'MUQS17' 0 []}';
MUQS18={'mo' 'MUQS18' 0 []}';
MUQS19={'mo' 'MUQS19' 0 []}';
MUQS20={'mo' 'MUQS20' 0 []}';
MUQS21={'mo' 'MUQS21' 0 []}';
MUQS22={'mo' 'MUQS22' 0 []}';
MUQS23={'mo' 'MUQS23' 0 []}';
MUQS24={'mo' 'MUQS24' 0 []}';
MUQS25={'mo' 'MUQS25' 0 []}';
MUQS26={'mo' 'MUQS26' 0 []}';
MUQS27={'mo' 'MUQS27' 0 []}';
MUQS28={'mo' 'MUQS28' 0 []}';
MUQS29={'mo' 'MUQS29' 0 []}';
MUQS30={'mo' 'MUQS30' 0 []}';
MUQS31={'mo' 'MUQS31' 0 []}';
MUQS32={'mo' 'MUQS32' 0 []}';
MUQS33={'mo' 'MUQS33' 0 []}';
MUQS34={'mo' 'MUQS34' 0 []}';
MUQS35={'mo' 'MUQS35' 0 []}';
MUQS36={'mo' 'MUQS36' 0 []}';
MUQS37={'mo' 'MUQS37' 0 []}';
MUQS38={'mo' 'MUQS38' 0 []}';
MUQS39={'mo' 'MUQS39' 0 []}';
MUQS40={'mo' 'MUQS40' 0 []}';
MUQS41={'mo' 'MUQS41' 0 []}';
MUQS42={'mo' 'MUQS42' 0 []}';
MUQS43={'mo' 'MUQS43' 0 []}';
MUQS44={'mo' 'MUQS44' 0 []}';
MUQS45={'mo' 'MUQS45' 0 []}';
MUQS46={'mo' 'MUQS46' 0 []}';
MUQS47={'mo' 'MUQS47' 0 []}';
% SXR phase shifter centers
MPHS21={'mo' 'MPHS21' 0 []}';
MPHS22={'mo' 'MPHS22' 0 []}';
MPHS23={'mo' 'MPHS23' 0 []}';
MPHS24={'mo' 'MPHS24' 0 []}';
MPHS25={'mo' 'MPHS25' 0 []}';
MPHS26={'mo' 'MPHS26' 0 []}';
MPHS27={'mo' 'MPHS27' 0 []}';
MPHS28={'mo' 'MPHS28' 0 []}';
MPHS29={'mo' 'MPHS29' 0 []}';
MPHS30={'mo' 'MPHS30' 0 []}';
MPHS31={'mo' 'MPHS31' 0 []}';
MPHS32={'mo' 'MPHS32' 0 []}';
MPHS33={'mo' 'MPHS33' 0 []}';
MPHS34={'mo' 'MPHS34' 0 []}';
% ----35
MPHS36={'mo' 'MPHS36' 0 []}';
MPHS37={'mo' 'MPHS37' 0 []}';
MPHS38={'mo' 'MPHS38' 0 []}';
MPHS39={'mo' 'MPHS39' 0 []}';
MPHS40={'mo' 'MPHS40' 0 []}';
MPHS41={'mo' 'MPHS41' 0 []}';
MPHS42={'mo' 'MPHS42' 0 []}';
MPHS43={'mo' 'MPHS43' 0 []}';
MPHS44={'mo' 'MPHS44' 0 []}';
MPHS45={'mo' 'MPHS45' 0 []}';
MPHS46={'mo' 'MPHS46' 0 []}';
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
% complete SXR undulator segments
% ------------------------------------------------------------------------------
UMASXH19=UMASXH;UMASXH19{2}='UMASXH19';
UMASXH20=UMASXH;UMASXH20{2}='UMASXH20';
UMASXH21=UMASXH_;UMASXH21{2}='UMASXH21';
UMASXH22=UMASXH_;UMASXH22{2}='UMASXH22';
UMASXH23=UMASXH_;UMASXH23{2}='UMASXH23';
UMASXH24=UMASXH_;UMASXH24{2}='UMASXH24';
UMASXH25=UMASXH_;UMASXH25{2}='UMASXH25';
UMASXH26=UMASXH_;UMASXH26{2}='UMASXH26';
UMASXH27=UMASXH_;UMASXH27{2}='UMASXH27';
UMASXH28=UMASXH_;UMASXH28{2}='UMASXH28';
UMASXH29=UMASXH_;UMASXH29{2}='UMASXH29';
UMASXH30=UMASXH_;UMASXH30{2}='UMASXH30';
UMASXH31=UMASXH_;UMASXH31{2}='UMASXH31';
UMASXH32=UMASXH_;UMASXH32{2}='UMASXH32';
UMASXH33=UMASXH_;UMASXH33{2}='UMASXH33';
UMASXH34=UMASXH_;UMASXH34{2}='UMASXH34';
% ------35
UMASXH36=UMASXH_;UMASXH36{2}='UMASXH36';
UMASXH37=UMASXH;UMASXH37{2}='UMASXH37';
UMASXH38=UMASXH;UMASXH38{2}='UMASXH38';
UMASXH39=UMASXH;UMASXH39{2}='UMASXH39';
UMASXH40=UMASXH;UMASXH40{2}='UMASXH40';
UMASXH41=UMASXH;UMASXH41{2}='UMASXH41';
UMASXH42=UMASXH;UMASXH42{2}='UMASXH42';
UMASXH43=UMASXH;UMASXH43{2}='UMASXH43';
UMASXH44=UMASXH;UMASXH44{2}='UMASXH44';
UMASXH45=UMASXH;UMASXH45{2}='UMASXH45';
UMASXH46=UMASXH;UMASXH46{2}='UMASXH46';
UMASXH47=UMASXH;UMASXH47{2}='UMASXH47';
DUSEGS17={'dr' '' LDUSEGS []}';
DUSEGS18={'dr' '' LDUSEGS []}';
DUSEGS19={'dr' '' LDUSEGS []}';
DUSEGS20={'dr' '' LDUSEGS []}';
USEGSX21=[DTSXU_,UMASXH21,XCSU21,YCSU21,UMASXH21,DTSXU_];
USEGSX22=[DTSXU_,UMASXH22,XCSU22,YCSU22,UMASXH22,DTSXU_];
USEGSX23=[DTSXU_,UMASXH23,XCSU23,YCSU23,UMASXH23,DTSXU_];
USEGSX24=[DTSXU_,UMASXH24,XCSU24,YCSU24,UMASXH24,DTSXU_];
USEGSX25=[DTSXU_,UMASXH25,XCSU25,YCSU25,UMASXH25,DTSXU_];
USEGSX26=[DTSXU_,UMASXH26,XCSU26,YCSU26,UMASXH26,DTSXU_];
USEGSX27=[DTSXU_,UMASXH27,XCSU27,YCSU27,UMASXH27,DTSXU_];
USEGSX28=[DTSXU_,UMASXH28,XCSU28,YCSU28,UMASXH28,DTSXU_];
USEGSX29=[DTSXU_,UMASXH29,XCSU29,YCSU29,UMASXH29,DTSXU_];
USEGSX30=[DTSXU_,UMASXH30,XCSU30,YCSU30,UMASXH30,DTSXU_];
USEGSX31=[DTSXU_,UMASXH31,XCSU31,YCSU31,UMASXH31,DTSXU_];
USEGSX32=[DTSXU_,UMASXH32,XCSU32,YCSU32,UMASXH32,DTSXU_];
USEGSX33=[DTSXU_,UMASXH33,XCSU33,YCSU33,UMASXH33,DTSXU_];
USEGSX34=[DTSXU_,UMASXH34,XCSU34,YCSU34,UMASXH34,DTSXU_];
DUSEGS35=[SCHICANE];
USEGSX36=[DTSXU_,UMASXH36,XCSU36,YCSU36,UMASXH36,DTSXU_];
USEGSX37=[DTSXU,UMASXH37,XCSU37,YCSU37,UMASXH37,DTSXU];
USEGSX38=[DTSXU,UMASXH38,XCSU38,YCSU38,UMASXH38,DTSXU];
USEGSX39=[DTSXU,UMASXH39,XCSU39,YCSU39,UMASXH39,DTSXU];
USEGSX40=[DTSXU,UMASXH40,XCSU40,YCSU40,UMASXH40,DTSXU];
USEGSX41=[DTSXU,UMASXH41,XCSU41,YCSU41,UMASXH41,DTSXU];
USEGSX42=[DTSXU,UMASXH42,XCSU42,YCSU42,UMASXH42,DTSXU];
USEGSX43=[DTSXU,UMASXH43,XCSU43,YCSU43,UMASXH43,DTSXU];
USEGSX44=[DTSXU,UMASXH44,XCSU44,YCSU44,UMASXH44,DTSXU];
USEGSX45=[DTSXU,UMASXH45,XCSU45,YCSU45,UMASXH45,DTSXU];
USEGSX46=[DTSXU,UMASXH46,XCSU46,YCSU46,UMASXH46,DTSXU];
USEGSX47=[DTSXU,UMASXH47,XCSU47,YCSU47,UMASXH47,DTSXU];
DUSEGS48={'dr' '' LDUSEGS []}';
DUSEGS49={'dr' '' LDUSEGS []}';
DUSEGS50={'dr' '' LDUSEGS []}';
% ------------------------------------------------------------------------------
% complete SXR undulator phase shifters
% ------------------------------------------------------------------------------
DPSSX17={'dr' '' LPSSX []}';
DPSSX18={'dr' '' LPSSX []}';
DPSSX19={'dr' '' LPSSX []}';
DPSSX20={'dr' '' LPSSX []}';
PSSXH21=PSSXH_;PSSXH21{2}='PSSXH21';
PSSXH22=PSSXH_;PSSXH22{2}='PSSXH22';
PSSXH23=PSSXH_;PSSXH23{2}='PSSXH23';
PSSXH24=PSSXH_;PSSXH24{2}='PSSXH24';
PSSXH25=PSSXH_;PSSXH25{2}='PSSXH25';
PSSXH26=PSSXH_;PSSXH26{2}='PSSXH26';
PSSXH27=PSSXH_;PSSXH27{2}='PSSXH27';
PSSXH28=PSSXH_;PSSXH28{2}='PSSXH28';
PSSXH29=PSSXH_;PSSXH29{2}='PSSXH29';
PSSXH30=PSSXH_;PSSXH30{2}='PSSXH30';
PSSXH31=PSSXH_;PSSXH31{2}='PSSXH31';
PSSXH32=PSSXH_;PSSXH32{2}='PSSXH32';
PSSXH33=PSSXH_;PSSXH33{2}='PSSXH33';
PSSXH34=PSSXH_;PSSXH34{2}='PSSXH34';
DPSSX35={'dr' '' LPSSX []}';
PSSXH36=PSSXH_;PSSXH36{2}='PSSXH36';
PSSXH37=PSSXH_;PSSXH37{2}='PSSXH37';
PSSXH38=PSSXH_;PSSXH38{2}='PSSXH38';
PSSXH39=PSSXH_;PSSXH39{2}='PSSXH39';
PSSXH40=PSSXH_;PSSXH40{2}='PSSXH40';
PSSXH41=PSSXH_;PSSXH41{2}='PSSXH41';
PSSXH42=PSSXH_;PSSXH42{2}='PSSXH42';
PSSXH43=PSSXH_;PSSXH43{2}='PSSXH43';
PSSXH44=PSSXH_;PSSXH44{2}='PSSXH44';
PSSXH45=PSSXH;PSSXH45{2}='PSSXH45';
PSSXH46=PSSXH;PSSXH46{2}='PSSXH46';
DPSSX47={'dr' '' LPSSX []}';
DPSSX48={'dr' '' LPSSX []}';
DPSSX49={'dr' '' LPSSX []}';
DPSSX50={'dr' '' LPSSX []}';
PSSXH21_FULL=[PSSXH21,MPHS21,PSSXH21];
PSSXH22_FULL=[PSSXH22,MPHS22,PSSXH22];
PSSXH23_FULL=[PSSXH23,MPHS23,PSSXH23];
PSSXH24_FULL=[PSSXH24,MPHS24,PSSXH24];
PSSXH25_FULL=[PSSXH25,MPHS25,PSSXH25];
PSSXH26_FULL=[PSSXH26,MPHS26,PSSXH26];
PSSXH27_FULL=[PSSXH27,MPHS27,PSSXH27];
PSSXH28_FULL=[PSSXH28,MPHS28,PSSXH28];
PSSXH29_FULL=[PSSXH29,MPHS29,PSSXH29];
PSSXH30_FULL=[PSSXH30,MPHS30,PSSXH30];
PSSXH31_FULL=[PSSXH31,MPHS31,PSSXH31];
PSSXH32_FULL=[PSSXH32,MPHS32,PSSXH32];
PSSXH33_FULL=[PSSXH33,MPHS33,PSSXH33];
PSSXH34_FULL=[PSSXH34,MPHS34,PSSXH34];
% -----35
PSSXH36_FULL=[PSSXH36,MPHS36,PSSXH36];
PSSXH37_FULL=[PSSXH37,MPHS37,PSSXH37];
PSSXH38_FULL=[PSSXH38,MPHS38,PSSXH38];
PSSXH39_FULL=[PSSXH39,MPHS39,PSSXH39];
PSSXH40_FULL=[PSSXH40,MPHS40,PSSXH40];
PSSXH41_FULL=[PSSXH41,MPHS41,PSSXH41];
PSSXH42_FULL=[PSSXH42,MPHS42,PSSXH42];
PSSXH43_FULL=[PSSXH43,MPHS43,PSSXH43];
PSSXH44_FULL=[PSSXH44,MPHS44,PSSXH44];
PSSXH45_FULL=[PSSXH45,MPHS45,PSSXH45];
PSSXH46_FULL=[PSSXH46,MPHS46,PSSXH46];
% ------------------------------------------------------------------------------
% complete SXR undulator quadrupoles
% ------------------------------------------------------------------------------
QSXH16_FULL=[QSXH16,XCSX16,MUQS16,YCSX16,QSXH16];
QSXH17_FULL=[QSXH17,XCSX17,MUQS17,YCSX17,QSXH17];
QSXH18_FULL=[QSXH18,XCSX18,MUQS18,YCSX18,QSXH18];
QSXH19_FULL=[QSXH19,XCSX19,MUQS19,YCSX19,QSXH19];
QSXH20_FULL=[QSXH20,XCSX20,MUQS20,YCSX20,QSXH20];
QSXH21_FULL=[QSXH21,XCSX21,MUQS21,YCSX21,QSXH21];
QSXH22_FULL=[QSXH22,XCSX22,MUQS22,YCSX22,QSXH22];
QSXH23_FULL=[QSXH23,XCSX23,MUQS23,YCSX23,QSXH23];
QSXH24_FULL=[QSXH24,XCSX24,MUQS24,YCSX24,QSXH24];
QSXH25_FULL=[QSXH25,XCSX25,MUQS25,YCSX25,QSXH25];
QSXH26_FULL=[QSXH26,XCSX26,MUQS26,YCSX26,QSXH26];
QSXH27_FULL=[QSXH27,XCSX27,MUQS27,YCSX27,QSXH27];
QSXH28_FULL=[QSXH28,XCSX28,MUQS28,YCSX28,QSXH28];
QSXH29_FULL=[QSXH29,XCSX29,MUQS29,YCSX29,QSXH29];
QSXH30_FULL=[QSXH30,XCSX30,MUQS30,YCSX30,QSXH30];
QSXH31_FULL=[QSXH31,XCSX31,MUQS31,YCSX31,QSXH31];
QSXH32_FULL=[QSXH32,XCSX32,MUQS32,YCSX32,QSXH32];
QSXH33_FULL=[QSXH33,XCSX33,MUQS33,YCSX33,QSXH33];
QSXH34_FULL=[QSXH34,XCSX34,MUQS34,YCSX34,QSXH34];
QSXH35_FULL=[QSXH35,XCSX35,MUQS35,YCSX35,QSXH35];
QSXH36_FULL=[QSXH36,XCSX36,MUQS36,YCSX36,QSXH36];
QSXH37_FULL=[QSXH37,XCSX37,MUQS37,YCSX37,QSXH37];
QSXH38_FULL=[QSXH38,XCSX38,MUQS38,YCSX38,QSXH38];
QSXH39_FULL=[QSXH39,XCSX39,MUQS39,YCSX39,QSXH39];
QSXH40_FULL=[QSXH40,XCSX40,MUQS40,YCSX40,QSXH40];
QSXH41_FULL=[QSXH41,XCSX41,MUQS41,YCSX41,QSXH41];
QSXH42_FULL=[QSXH42,XCSX42,MUQS42,YCSX42,QSXH42];
QSXH43_FULL=[QSXH43,XCSX43,MUQS43,YCSX43,QSXH43];
QSXH44_FULL=[QSXH44,XCSX44,MUQS44,YCSX44,QSXH44];
QSXH45_FULL=[QSXH45,XCSX45,MUQS45,YCSX45,QSXH45];
QSXH46_FULL=[QSXH46,XCSX46,MUQS46,YCSX46,QSXH46];
QSXH47_FULL=[QSXH47,XCSX47,MUQS47,YCSX47,QSXH47];
DQSX48={'dr' '' LQU []}';
DQSX49={'dr' '' LQU []}';
DQSX50={'dr' '' LQU []}';
% ------------------------------------------------------------------------------
% miscellaneous SXR stuff
% ------------------------------------------------------------------------------
% SXRSS-II BOD's
BOD10={'mo' 'BOD10' 0 []}';%Beam Overlap Device
DU7SA={'dr' '' 0.078508 []}';
BOD12={'mo' 'BOD12' 0 []}';%Beam Overlap Device
DU7SB={'dr' '' DU7S{3}-DU7SA{3} []}';
% PEPPEx components
PEPXANG =  0.105263157895E-2 ;%offset beam toward aisle (south)
%DU7sc     : DRIF, L=0.184
%FSPEPX1   : INST, TYPE="fast shutter"
%DU7sd     : DRIF, L=DU7s[L]-DU7sc[L]
XCPEPX1={'mo' 'XCPEPX1' 0 []}';
DU7SE={'dr' '' 0.074 []}';
VGPEPX1={'mo' 'VGPEPX1' 0 []}';
VGCCPEPX1={'mo' 'VGCCPEPX1' 0 []}';
VGPRPEPX1={'mo' 'VGPRPEPX1' 0 []}';
DU7SF={'dr' '' DU7S{3}-DU7SE{3} []}';
DUSEGS50A={'dr' '' 0.064 []}';
XCPEPX2={'mo' 'XCPEPX2' 0 []}';
DUSEGS50B={'dr' '' 0.586 []}';
ZPPEPX={'mo' 'ZPPEPX' 0 []}';
DUSEGS50C={'dr' '' 0.29 []}';
VPPEPX1={'mo' 'VPPEPX1' 0 []}';
DUSEGS50D={'dr' '' 0.224 []}';
XCPEPX3={'mo' 'XCPEPX3' 0 []}';
DUSEGS50E={'dr' '' 0.95 []}';
XCPEPX4={'mo' 'XCPEPX4' 0 []}';
DUSEGS50F={'dr' '' 0.6 []}';
GJPEPX={'mo' 'GJPEPX' 0 []}';
DUSEGS50G={'dr' '' DUSEGS50{3}-DUSEGS50A{3}-DUSEGS50B{3}-DUSEGS50C{3}-DUSEGS50D{3}-DUSEGS50E{3}-DUSEGS50F{3} []}';
DUE1AB1={'dr' '' 0.121 []}';
VPPEPX2={'mo' 'VPPEPX2' 0 []}';
DUE1AB2={'dr' '' DUE1AB{3}-DUE1AB1{3} []}';
% ------------------------------------------------------------------------------
% SXR FODO cell interspace definitions
% ------------------------------------------------------------------------------
SXBRK17=[DU3S,DPSSX17,DU4S,DU5S,QSXH17_FULL,DU6S,RFBSX17,DU7S];
SXBRK18=[DU3S,DPSSX18,DU4S,DU5S,QSXH18_FULL,DU6S,RFBSX18,DU7S];
SXBRK19=[DU3S,DPSSX19,DU4S,DU5S,QSXH19_FULL,DU6S,RFBSX19,DU7S];
SXBRK20=[DU3S,DPSSX20,DU4S,DU5S,QSXH20_FULL,DU6S,RFBSX20,DU7S];
SXBRK21=[DU3S_,PSSXH21_FULL,DU4S_,VVSXU21,DU5S_,QSXH21_FULL,DU6S,RFBSX21,DU7S];
SXBRK22=[DU3S_,PSSXH22_FULL,DU4S_,DU5S_,QSXH22_FULL,DU6S,RFBSX22,DU7S];
SXBRK23=[DU3S_,PSSXH23_FULL,DU4S_,DU5S_,QSXH23_FULL,DU6S,RFBSX23,DU7S];
SXBRK24=[DU3S_,PSSXH24_FULL,DU4S_,DU5S_,QSXH24_FULL,DU6S,RFBSX24,DU7S];
SXBRK25=[DU3S_,PSSXH25_FULL,DU4S_,DU5S_,QSXH25_FULL,DU6S,RFBSX25,DU7S];
SXBRK26=[DU3S_,PSSXH26_FULL,DU4S_,DU5S_,QSXH26_FULL,DU6S,RFBSX26,DU7S];
SXBRK27=[DU3S_,PSSXH27_FULL,DU4S_,DU5S_,QSXH27_FULL,DU6S,RFBSX27,DU7S];
SXBRK28=[DU3S_,PSSXH28_FULL,DU4S_,VVSXU28,DU5S_,QSXH28_FULL,DU6S,RFBSX28,DU7S];
SXBRK29=[DU3S_,PSSXH29_FULL,DU4S_,DU5S_,QSXH29_FULL,DU6S,RFBSX29,DU7S];
SXBRK30=[DU3S_,PSSXH30_FULL,DU4S_,DU5S_,QSXH30_FULL,DU6S,RFBSX30,DU7S];
SXBRK31=[DU3S_,PSSXH31_FULL,DU4S_,DU5S_,QSXH31_FULL,DU6S,RFBSX31,DU7S];
SXBRK32=[DU3S_,PSSXH32_FULL,DU4S_,DU5S_,QSXH32_FULL,DU6S,RFBSX32,DU7S];
SXBRK33=[DU3S_,PSSXH33_FULL,DU4S_,DU5S_,QSXH33_FULL,DU6S,RFBSX33,DU7S];
SXBRK34=[DU3S_,PSSXH34_FULL,DU4S_,VVSXU34,DU5S_,QSXH34_FULL,DU6S,RFBSX34,DU7S];
SXBRK35=[DU3S,DPSSX35,DU4SA,BOD10,DU4SB,VVSXU35,DU5S,QSXH35_FULL,DU6S,RFBSX35,DU7S];
SXBRK36=[DU3S_,PSSXH36_FULL,DU4S_,DU5S_,QSXH36_FULL,DU6S,RFBSX36,DU7S];
SXBRK37=[DU3S_,PSSXH37_FULL,DU4S_,DU5S_,QSXH37_FULL,DU6S,RFBSX37,DU7SA,BOD12,DU7SB];
SXBRK38=[DU3S_,PSSXH38_FULL,DU4S_,VVSXU38,DU5S_,QSXH38_FULL,DU6S,RFBSX38,DU7S];
SXBRK39=[DU3S_,PSSXH39_FULL,DU4S_,DU5S_,QSXH39_FULL,DU6S,RFBSX39,DU7S];
SXBRK40=[DU3S_,PSSXH40_FULL,DU4S_,DU5S_,QSXH40_FULL,DU6S,RFBSX40,DU7S];
SXBRK41=[DU3S_,PSSXH41_FULL,DU4S_,DU5S_,QSXH41_FULL,DU6S,RFBSX41,DU7S];
SXBRK42=[DU3S_,PSSXH42_FULL,DU4S_,DU5S_,QSXH42_FULL,DU6S,RFBSX42,DU7S];
SXBRK43=[DU3S_,PSSXH43_FULL,DU4S_,DU5S_,QSXH43_FULL,DU6S,RFBSX43,DU7S];
SXBRK44=[DU3S_,PSSXH44_FULL,DU4S_,VVSXU44,DU5S_,QSXH44_FULL,DU6S,RFBSX44,DU7S];
SXBRK45=[DU3S,PSSXH45_FULL,DU4S,DU5S,QSXH45_FULL,DU6S,RFBSX45,DU7S];
SXBRK46=[DU3S,PSSXH46_FULL,DU4S,DU5S,QSXH46_FULL,DU6S,RFBSX46,DU7S];
SXBRK47=[DU3S,DPSSX47     ,DU4S,DU5S,QSXH47_FULL,DU6S,RFBSX47,DU7S];
SXBRK48=[DU3S,DPSSX48     ,DU4S,DU5S,DQSX48     ,DU6S,DRFBS48,DU7S];
SXBRK49=[DU3SA,XCPEPX1,DU3SB,DPSSX49,DU4S,DU5S,DQSX49,DU6S,DRFBS49,DU7SE,VGPEPX1,VGCCPEPX1,VGPRPEPX1,DU7SF];
SXBRK50=[DU3S,DPSSX50     ,DU4S,DU5S,DQSX50     ,DU6S,DRFBS50,DU7S];
% ------------------------------------------------------------------------------
% SXR cell boundary definitions
% ------------------------------------------------------------------------------
SXR17BEG={'mo' 'SXR17BEG' 0 []}';
SXR17END={'mo' 'SXR17END' 0 []}';
SXR18BEG={'mo' 'SXR18BEG' 0 []}';
SXR18END={'mo' 'SXR18END' 0 []}';
SXR19BEG={'mo' 'SXR19BEG' 0 []}';
SXR19END={'mo' 'SXR19END' 0 []}';
SXR20BEG={'mo' 'SXR20BEG' 0 []}';
SXR20END={'mo' 'SXR20END' 0 []}';
SXR21BEG={'mo' 'SXR21BEG' 0 []}';
SXR21END={'mo' 'SXR21END' 0 []}';
SXR22BEG={'mo' 'SXR22BEG' 0 []}';
SXR22END={'mo' 'SXR22END' 0 []}';
SXR23BEG={'mo' 'SXR23BEG' 0 []}';
SXR23END={'mo' 'SXR23END' 0 []}';
SXR24BEG={'mo' 'SXR24BEG' 0 []}';
SXR24END={'mo' 'SXR24END' 0 []}';
SXR25BEG={'mo' 'SXR25BEG' 0 []}';
SXR25END={'mo' 'SXR25END' 0 []}';
SXR26BEG={'mo' 'SXR26BEG' 0 []}';
SXR26END={'mo' 'SXR26END' 0 []}';
SXR27BEG={'mo' 'SXR27BEG' 0 []}';
SXR27END={'mo' 'SXR27END' 0 []}';
SXR28BEG={'mo' 'SXR28BEG' 0 []}';
SXR28END={'mo' 'SXR28END' 0 []}';
SXR29BEG={'mo' 'SXR29BEG' 0 []}';
SXR29END={'mo' 'SXR29END' 0 []}';
SXR30BEG={'mo' 'SXR30BEG' 0 []}';
SXR30END={'mo' 'SXR30END' 0 []}';
SXR31BEG={'mo' 'SXR31BEG' 0 []}';
SXR31END={'mo' 'SXR31END' 0 []}';
SXR32BEG={'mo' 'SXR32BEG' 0 []}';
SXR32END={'mo' 'SXR32END' 0 []}';
SXR33BEG={'mo' 'SXR33BEG' 0 []}';
SXR33END={'mo' 'SXR33END' 0 []}';
SXR34BEG={'mo' 'SXR34BEG' 0 []}';
SXR34END={'mo' 'SXR34END' 0 []}';
SXR35BEG={'mo' 'SXR35BEG' 0 []}';
SXR35END={'mo' 'SXR35END' 0 []}';
SXR36BEG={'mo' 'SXR36BEG' 0 []}';
SXR36END={'mo' 'SXR36END' 0 []}';
SXR37BEG={'mo' 'SXR37BEG' 0 []}';
SXR37END={'mo' 'SXR37END' 0 []}';
SXR38BEG={'mo' 'SXR38BEG' 0 []}';
SXR38END={'mo' 'SXR38END' 0 []}';
SXR39BEG={'mo' 'SXR39BEG' 0 []}';
SXR39END={'mo' 'SXR39END' 0 []}';
SXR40BEG={'mo' 'SXR40BEG' 0 []}';
SXR40END={'mo' 'SXR40END' 0 []}';
SXR41BEG={'mo' 'SXR41BEG' 0 []}';
SXR41END={'mo' 'SXR41END' 0 []}';
SXR42BEG={'mo' 'SXR42BEG' 0 []}';
SXR42END={'mo' 'SXR42END' 0 []}';
SXR43BEG={'mo' 'SXR43BEG' 0 []}';
SXR43END={'mo' 'SXR43END' 0 []}';
SXR44BEG={'mo' 'SXR44BEG' 0 []}';
SXR44END={'mo' 'SXR44END' 0 []}';
SXR45BEG={'mo' 'SXR45BEG' 0 []}';
SXR45END={'mo' 'SXR45END' 0 []}';
SXR46BEG={'mo' 'SXR46BEG' 0 []}';
SXR46END={'mo' 'SXR46END' 0 []}';
SXR47BEG={'mo' 'SXR47BEG' 0 []}';
SXR47END={'mo' 'SXR47END' 0 []}';
SXR48BEG={'mo' 'SXR48BEG' 0 []}';
SXR48END={'mo' 'SXR48END' 0 []}';
SXR49BEG={'mo' 'SXR49BEG' 0 []}';
SXR49END={'mo' 'SXR49END' 0 []}';
SXR50BEG={'mo' 'SXR50BEG' 0 []}';
SXR50END={'mo' 'SXR50END' 0 []}';
% ------------------------------------------------------------------------------
% SXR cell definitions
% ------------------------------------------------------------------------------
SXCEL17=[SXR17BEG,DU1S,        DU2S,DUSEGS17,SXBRK17,SXR17END];%Q+RFBPM
SXCEL18=[SXR18BEG,DU1S,        DU2S,DUSEGS18,SXBRK18,SXR18END];%Q+RFBPM
SXCEL19=[SXR19BEG,DU1S,MBLMS19,DU2S,DUSEGS19,SXBRK19,SXR19END];%short
SXCEL20=[SXR20BEG,DU1S,        DU2S,DUSEGS20,SXBRK20,SXR20END];%short
SXCEL21=[SXR21BEG,DU1S,MBLMS21,DU2S,USEGSX21,SXBRK21,SXR21END];%long
SXCEL22=[SXR22BEG,DU1S,        DU2S,USEGSX22,SXBRK22,SXR22END];%long
SXCEL23=[SXR23BEG,DU1S,MBLMS23,DU2S,USEGSX23,SXBRK23,SXR23END];%long
SXCEL24=[SXR24BEG,DU1S,        DU2S,USEGSX24,SXBRK24,SXR24END];%long
SXCEL25=[SXR25BEG,DU1S,MBLMS25,DU2S,USEGSX25,SXBRK25,SXR25END];%long
SXCEL26=[SXR26BEG,DU1S,        DU2S,USEGSX26,SXBRK26,SXR26END];%long
SXCEL27=[SXR27BEG,DU1S,MBLMS27,DU2S,USEGSX27,SXBRK27,SXR27END];%long
SXCEL28=[SXR28BEG,DU1S,        DU2S,USEGSX28,SXBRK28,SXR28END];%long
SXCEL29=[SXR29BEG,DU1S,MBLMS29,DU2S,USEGSX29,SXBRK29,SXR29END];%long
SXCEL30=[SXR30BEG,DU1S,        DU2S,USEGSX30,SXBRK30,SXR30END];%long
SXCEL31=[SXR31BEG,DU1S,MBLMS31,DU2S,USEGSX31,SXBRK31,SXR31END];%long
SXCEL32=[SXR32BEG,DU1S,        DU2S,USEGSX32,SXBRK32,SXR32END];%long
SXCEL33=[SXR33BEG,DU1S,MBLMS33,DU2S,USEGSX33,SXBRK33,SXR33END];%long
SXCEL34=[SXR34BEG,DU1S,        DU2S,USEGSX34,SXBRK34,SXR34END];%long
SXCEL35=[SXR35BEG,DU1S,        DU2S,DUSEGS35,SXBRK35,SXR35END];%SXRSS+Q+RFBPM
SXCEL36=[SXR36BEG,DU1S,        DU2S,USEGSX36,SXBRK36,SXR36END];%long
SXCEL37=[SXR37BEG,DU1S,MBLMS37,DU2S,USEGSX37,SXBRK37,SXR37END];%short/long
SXCEL38=[SXR38BEG,DU1S,        DU2S,USEGSX38,SXBRK38,SXR38END];%short/long
SXCEL39=[SXR39BEG,DU1S,MBLMS39,DU2S,USEGSX39,SXBRK39,SXR39END];%short/long
SXCEL40=[SXR40BEG,DU1S,        DU2S,USEGSX40,SXBRK40,SXR40END];%short/long
SXCEL41=[SXR41BEG,DU1S,MBLMS41,DU2S,USEGSX41,SXBRK41,SXR41END];%short/long
SXCEL42=[SXR42BEG,DU1S,        DU2S,USEGSX42,SXBRK42,SXR42END];%short/long
SXCEL43=[SXR43BEG,DU1S,MBLMS43,DU2S,USEGSX43,SXBRK43,SXR43END];%short/long
SXCEL44=[SXR44BEG,DU1S,        DU2S,USEGSX44,SXBRK44,SXR44END];%short/long
SXCEL45=[SXR45BEG,DU1S,MBLMS45,DU2S,USEGSX45,SXBRK45,SXR45END];%short
SXCEL46=[SXR46BEG,DU1S,        DU2S,USEGSX46,SXBRK46,SXR46END];%short
SXCEL47=[SXR47BEG,DU1S,MBLMS47,DU2S,USEGSX47,SXBRK47,SXR47END];%short
SXCEL48=[SXR48BEG,DU1S,        DU2S,DUSEGS48,SXBRK48,SXR48END];%empty
SXCEL49=[SXR49BEG,DU1S,        DU2S,DUSEGS49,SXBRK49,SXR49END];%empty
SXCEL50=[SXR50BEG,DU1S,DU2S,DUSEGS50A,XCPEPX2,DUSEGS50B,ZPPEPX,DUSEGS50C,VPPEPX1,DUSEGS50D,XCPEPX3,DUSEGS50E,XCPEPX4,DUSEGS50F,GJPEPX,DUSEGS50G,SXBRK50,SXR50END];%PEPPEx stuff
% ------------------------------------------------------------------------------
% SXR definitions
% ------------------------------------------------------------------------------
SXRCL=[SXCEL17,SXCEL18,SXCEL19,SXCEL20,SXCEL21,SXCEL22,SXCEL23,SXCEL24,SXCEL25,SXCEL26,SXCEL27,SXCEL28,SXCEL29,SXCEL30,SXCEL31,SXCEL32,SXCEL33,SXCEL34,SXCEL35,SXCEL36,SXCEL37,SXCEL38,SXCEL39,SXCEL40,SXCEL41,SXCEL42,SXCEL43,SXCEL44,SXCEL45,SXCEL46,SXCEL47,SXCEL48,SXCEL49,SXCEL50];
SXR=[DU0SA,RFBSX15,DU0SB,QSXH16_FULL,DU6S,RFBSX16,DU7S,SXRSTART,SXRCL,RWWAKE5S,SXRTERM,DUE1AB1,VPPEPX2,DUE1AB2,RFBSX51,DUE1E,ENDUNDS];
% ------------------------------------------------------------------------------
% SXR undulator exit section
% ------------------------------------------------------------------------------
TCX01B={'tc' 'TCX01B' 1.5/2 [XBANDF 0 0*TWOPI]}';%horiz. deflection
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQUE1B =   0.287963586617 ;% 0.28964739003    Yuri (E=4.0, K=5.0)
KQUE2B =   0.0            ;%-0.00606676202205 Yuri (E=4.0, K=5.0)
QUE1B={'qu' 'QUE1B' LQR/2 [KQUE1B 0]}';
QUE2B={'qu' 'QUE2B' LQR/2 [KQUE2B 0]}';
LBKXDMP =   1.0                ;%x-kicker length in dumpline
DZSXTES =   0.468389399848E-10 ;%set MDLWALLb at 685 m exactly to align with SXR XTES system
DDSB0E =  -0.403705866174E-3;
DUE1D={'dr' '' 0.1 []}';
DUE1B={'dr' '' 1.5 []}';
DUE1C={'dr' '' 0.5 []}';
DUE2A={'dr' '' 0.5 []}';
DUE2D={'dr' '' 0.188-0.012 []}';%phase cavity center-to-center spacing
DUE2B={'dr' '' 0.8-DUE2D{3}+0.005555 []}';
DUE2E={'dr' '' 1.740055-DUE2B{3}-3*DUE2D{3} []}';
DUE2CB={'dr' '' 0.615+(LQP-LQR)/2 []}';
DUE3AB={'dr' '' 0.375504+(LQP-LQR)/2-0.014955 []}';
DUE3BB={'dr' '' 1.2630495+0.014955 []}';
DUE3C={'dr' '' (1.7968755-LBKXDMP)/2 []}';
DBKXDMPS={'dr' '' LBKXDMP []}';%placeholder for x-kicker in SXR dumpline
DUE3D={'dr' '' 0.435884 []}';%0.320516
DFSPCB={'dr' '' 0.115368 []}';
DPCBVVB={'dr' '' 0.401785 []}';
DVVBTCXB={'dr' '' 0.314355 []}';
DTCXBSPB={'dr' '' 0.380565 []}';%0.381
DUE4B={'dr' '' 0.975911 []}';
DUE5AB={'dr' '' 0.477799+(LQP-LQR)/2-0.114162 []}';
DUE5BB={'dr' '' 0.264+0.114162-0.1016+0.1016 []}';
DUE5CB={'dr' '' 0.2674+0.1016-0.1016 []}';
DUE5F={'dr' '' 0.05 []}';
DUE5D={'dr' '' 0.137055-0.05 []}';
DUE5EB={'dr' '' 0.252825-DUE5D{3}-DUE5F{3}+DZSXTES []}';
DDLWALLB={'dr' '' 0.250825-DZSXTES []}';%length of dumpline thermal barrier wall
DSB0A={'dr' '' 0.260150 []}';
DSB0B={'dr' '' 0.344 []}';
DSB0C={'dr' '' 0.32646 []}';
DSB0D={'dr' '' 0.123366 []}';
DSB0E={'dr' '' 0.1059327+DDSB0E []}';
BPMUE1B={'mo' 'BPMUE1B' 0 []}';%RFBUE1B : MONI, TYPE="@2,CavityS-1"
BPMUE2B={'mo' 'BPMUE2B' 0 []}';%RFBUE2B : MONI, TYPE="@2,CavityS-1"
XCUE2B={'mo' 'XCUE2B' 0 []}';
XCD3B={'mo' 'XCD3B' 0 []}';
YCUE1B={'mo' 'YCUE1B' 0 []}';
YCD3B={'mo' 'YCD3B' 0 []}';
PCTCXB={'dr' 'PCTCXB' 0 []}';%XTCAV photon collimator (4 mm aperture)
PCPM0B={'dr' 'PCPM0B' LPCPM []}';
PH31B={'mo' 'PH31B' 0 []}';%post-undulator phase measurement RF cavity (low rate)
PH32B={'mo' 'PH32B' 0 []}';%post-undulator phase measurement RF cavity (low rate)
PH33B={'mo' 'PH33B' 0 []}';%post-undulator phase measurement RF cavity (high rate)
PH34B={'mo' 'PH34B' 0 []}';%post-undulator phase measurement RF cavity (high rate)
TRUE1B={'dr' '' 0 []}';%Be foil inserter (THz)
SPTCXB={'mo' 'SPTCXB' 0 []}';
BTMQUEB={'mo' 'BTMQUEB' 0 []}';%Burn-Through-Monitor
BTM0B={'mo' 'BTM0B' 0 []}';%Burn-Through-Monitor behind the PCPM0B
UEBEGB={'mo' 'UEBEGB' 0 []}';
VV36B={'mo' 'VV36B' 0 []}';%treaty-point vacuum valve just downbeam of undulator
MIMUNDOB={'mo' 'MIMUNDOB' 0 []}';%IMUNDOB : IMON, TYPE="@0,BCS ACM" BCS ACM
VVTCXB={'mo' 'VVTCXB' 0 []}';%XTCAV vacuum valve
MTCX01B={'mo' 'MTCX01B' 0 []}';%entrance to TCX01B (for ELEGANT WATCH point)
MTCXB={'mo' 'MTCXB' 0 []}';%center of TCX01B (for matching)
MDLWALLB={'mo' 'MDLWALLB' 0 []}';%front face of dumpline thermal barrier wall
UEENDB={'mo' 'UEENDB' 0 []}';
DLSTARTB={'mo' 'DLSTARTB' 0 []}';%start of dumpline
VV37B={'mo' 'VV37B' 0 []}';%vac. valve in dumpline
TCX01B_FULL=[TCX01B,MTCXB,TCX01B];
QUE1B_FULL=[QUE1B,QUE1B];
QUE2B_FULL=[QUE2B,QUE2B];
UNDEXITB=[BEGDMPS_1,UEBEGB,DUE1D,VV36B,DUE1B,MIMUNDOB,DUE1C,DUE2A,YCUE1B,DUE2B,PH31B,DUE2D,PH32B,DUE2D,PH33B,DUE2D,PH34B,DUE2E,XCUE2B,DUE2CB,QUE1B_FULL,DUE3AB,BPMUE1B,DUE3BB,TRUE1B,DUE3C,DBKXDMPS,DUE3C,DUE3D,PCTCXB,DPCBVVB,VVTCXB,DVVBTCXB,MTCX01B,TCX01B_FULL,DTCXBSPB,SPTCXB,DUE4B,QUE2B_FULL,DUE5AB,BPMUE2B,DUE5BB,BTMQUEB,DUE5CB,PCPM0B,DUE5F,BTM0B,DUE5D,DUE5EB,MDLWALLB,DDLWALLB,UEENDB,DLSTARTB,DSB0A,YCD3B,DSB0B,XCD3B,DSB0C,VV37B,DSB0D,DSB0E,ENDDMPS_1];
SXRUND=[SXR,UNDEXITB];
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
PSHXH={'un' 'PSHXH' LPSHXH [KQPSHX LUPSHX 1]}';
% -----13
PSHXH14=PSHXH;PSHXH14{2}='PSHXH14';
PSHXH15=PSHXH;PSHXH15{2}='PSHXH15';
PSHXH16=PSHXH;PSHXH16{2}='PSHXH16';
PSHXH17=PSHXH;PSHXH17{2}='PSHXH17';
PSHXH18=PSHXH;PSHXH18{2}='PSHXH18';
PSHXH19=PSHXH;PSHXH19{2}='PSHXH19';
PSHXH20=PSHXH;PSHXH20{2}='PSHXH20';
% -----21
PSHXH22=PSHXH;PSHXH22{2}='PSHXH22';
PSHXH23=PSHXH;PSHXH23{2}='PSHXH23';
PSHXH24=PSHXH;PSHXH24{2}='PSHXH24';
PSHXH25=PSHXH;PSHXH25{2}='PSHXH25';
PSHXH26=PSHXH;PSHXH26{2}='PSHXH26';
PSHXH27=PSHXH;PSHXH27{2}='PSHXH27';
% -----28
PSHXH29=PSHXH;PSHXH29{2}='PSHXH29';
PSHXH30=PSHXH;PSHXH30{2}='PSHXH30';
PSHXH31=PSHXH;PSHXH31{2}='PSHXH31';
PSHXH32=PSHXH;PSHXH32{2}='PSHXH32';
PSHXH33=PSHXH;PSHXH33{2}='PSHXH33';
PSHXH34=PSHXH;PSHXH34{2}='PSHXH34';
PSHXH35=PSHXH;PSHXH35{2}='PSHXH35';
PSHXH36=PSHXH;PSHXH36{2}='PSHXH36';
PSHXH37=PSHXH;PSHXH37{2}='PSHXH37';
PSHXH38=PSHXH;PSHXH38{2}='PSHXH38';
PSHXH39=PSHXH;PSHXH39{2}='PSHXH39';
PSHXH40=PSHXH;PSHXH40{2}='PSHXH40';
PSHXH41=PSHXH;PSHXH41{2}='PSHXH41';
PSHXH42=PSHXH;PSHXH42{2}='PSHXH42';
PSHXH43=PSHXH;PSHXH43{2}='PSHXH43';
PSHXH44=PSHXH;PSHXH44{2}='PSHXH44';
PSHXH45=PSHXH;PSHXH45{2}='PSHXH45';
PSHXH46=PSHXH;PSHXH46{2}='PSHXH46';
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
%IntgHX : definition moved to LCLS2sc_main.xsif and LCLS2cu_main.xsif
GQFHX =   INTGHX/LQU/10*1.0           ;%T/m
GQDHX =  -INTGHX/LQU/10*1.0           ;%T/m
KQFHX =   1.E-9*GQFHX*CLIGHT/GAMU/MC2 ;%m^-2
KQDHX =   1.E-9*GQDHX*CLIGHT/GAMU/MC2 ;%m^-2
KQHX46 =  -2.482122917065              ;%Yuri (E=4.0, K=2.0)
KQHX47 =   0.0;
QHXH13={'qu' 'QHXH13' LQU/2 [KQFHX 0]}';
QHXH14={'qu' 'QHXH14' LQU/2 [KQDHX 0]}';
QHXH15={'qu' 'QHXH15' LQU/2 [KQFHX 0]}';
QHXH16={'qu' 'QHXH16' LQU/2 [KQDHX 0]}';
QHXH17={'qu' 'QHXH17' LQU/2 [KQFHX 0]}';
QHXH18={'qu' 'QHXH18' LQU/2 [KQDHX 0]}';
QHXH19={'qu' 'QHXH19' LQU/2 [KQFHX 0]}';
QHXH20={'qu' 'QHXH20' LQU/2 [KQDHX 0]}';
QHXH21={'qu' 'QHXH21' LQU/2 [KQFHX 0]}';
QHXH22={'qu' 'QHXH22' LQU/2 [KQDHX 0]}';
QHXH23={'qu' 'QHXH23' LQU/2 [KQFHX 0]}';
QHXH24={'qu' 'QHXH24' LQU/2 [KQDHX 0]}';
QHXH25={'qu' 'QHXH25' LQU/2 [KQFHX 0]}';
QHXH26={'qu' 'QHXH26' LQU/2 [KQDHX 0]}';
QHXH27={'qu' 'QHXH27' LQU/2 [KQFHX 0]}';
QHXH28={'qu' 'QHXH28' LQU/2 [KQDHX 0]}';
QHXH29={'qu' 'QHXH29' LQU/2 [KQFHX 0]}';
QHXH30={'qu' 'QHXH30' LQU/2 [KQDHX 0]}';
QHXH31={'qu' 'QHXH31' LQU/2 [KQFHX 0]}';
QHXH32={'qu' 'QHXH32' LQU/2 [KQDHX 0]}';
QHXH33={'qu' 'QHXH33' LQU/2 [KQFHX 0]}';
QHXH34={'qu' 'QHXH34' LQU/2 [KQDHX 0]}';
QHXH35={'qu' 'QHXH35' LQU/2 [KQFHX 0]}';
QHXH36={'qu' 'QHXH36' LQU/2 [KQDHX 0]}';
QHXH37={'qu' 'QHXH37' LQU/2 [KQFHX 0]}';
QHXH38={'qu' 'QHXH38' LQU/2 [KQDHX 0]}';
QHXH39={'qu' 'QHXH39' LQU/2 [KQFHX 0]}';
QHXH40={'qu' 'QHXH40' LQU/2 [KQDHX 0]}';
QHXH41={'qu' 'QHXH41' LQU/2 [KQFHX 0]}';
QHXH42={'qu' 'QHXH42' LQU/2 [KQDHX 0]}';
QHXH43={'qu' 'QHXH43' LQU/2 [KQFHX 0]}';
QHXH44={'qu' 'QHXH44' LQU/2 [KQDHX 0]}';
QHXH45={'qu' 'QHXH45' LQU/2 [KQFHX 0]}';
QHXH46={'qu' 'QHXH46' LQU/2 [KQHX46 0]}';
QHXH47={'qu' 'QHXH47' LQU/2 [KQHX47 0]}';
LUHXU =  0.026                            ;%m
NPHXU =  129;
LHXUCR =  LUHXU*NPHXU                      ;%m
LHXUE =  (LDUSEGH-LHXUCR)/2               ;%m
LHXUH =  LHXUCR/2;
KHXU =  2.0;
KQHX =  (KHXU*2*PI/LUHXU/sqrt(2)/GAMU)^2 ;%m^-2
UMAHXH={'un' 'UMAHXH' LHXUH [KQHX LUHXU 0]}';
% ------13
UMAHXH14=UMAHXH;UMAHXH14{2}='UMAHXH14';
UMAHXH15=UMAHXH;UMAHXH15{2}='UMAHXH15';
UMAHXH16=UMAHXH;UMAHXH16{2}='UMAHXH16';
UMAHXH17=UMAHXH;UMAHXH17{2}='UMAHXH17';
UMAHXH18=UMAHXH;UMAHXH18{2}='UMAHXH18';
UMAHXH19=UMAHXH;UMAHXH19{2}='UMAHXH19';
UMAHXH20=UMAHXH;UMAHXH20{2}='UMAHXH20';
% ------21
UMAHXH22=UMAHXH;UMAHXH22{2}='UMAHXH22';
UMAHXH23=UMAHXH;UMAHXH23{2}='UMAHXH23';
UMAHXH24=UMAHXH;UMAHXH24{2}='UMAHXH24';
UMAHXH25=UMAHXH;UMAHXH25{2}='UMAHXH25';
UMAHXH26=UMAHXH;UMAHXH26{2}='UMAHXH26';
UMAHXH27=UMAHXH;UMAHXH27{2}='UMAHXH27';
% ------28
UMAHXH29=UMAHXH;UMAHXH29{2}='UMAHXH29';
UMAHXH30=UMAHXH;UMAHXH30{2}='UMAHXH30';
UMAHXH31=UMAHXH;UMAHXH31{2}='UMAHXH31';
UMAHXH32=UMAHXH;UMAHXH32{2}='UMAHXH32';
UMAHXH33=UMAHXH;UMAHXH33{2}='UMAHXH33';
UMAHXH34=UMAHXH;UMAHXH34{2}='UMAHXH34';
UMAHXH35=UMAHXH;UMAHXH35{2}='UMAHXH35';
UMAHXH36=UMAHXH;UMAHXH36{2}='UMAHXH36';
UMAHXH37=UMAHXH;UMAHXH37{2}='UMAHXH37';
UMAHXH38=UMAHXH;UMAHXH38{2}='UMAHXH38';
UMAHXH39=UMAHXH;UMAHXH39{2}='UMAHXH39';
UMAHXH40=UMAHXH;UMAHXH40{2}='UMAHXH40';
UMAHXH41=UMAHXH;UMAHXH41{2}='UMAHXH41';
UMAHXH42=UMAHXH;UMAHXH42{2}='UMAHXH42';
UMAHXH43=UMAHXH;UMAHXH43{2}='UMAHXH43';
UMAHXH44=UMAHXH;UMAHXH44{2}='UMAHXH44';
UMAHXH45=UMAHXH;UMAHXH45{2}='UMAHXH45';
UMAHXH46=UMAHXH;UMAHXH46{2}='UMAHXH46';
UMAHXH47=UMAHXH;UMAHXH47{2}='UMAHXH47';
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
XCHX47={'mo' 'XCHX47' 0 []}';
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
YCHX47={'mo' 'YCHX47' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator X-steering coils in undulator segments
% ------------------------------------------------------------------------------
% ----13
XCHU14={'mo' 'XCHU14' 0 []}';
XCHU15={'mo' 'XCHU15' 0 []}';
XCHU16={'mo' 'XCHU16' 0 []}';
XCHU17={'mo' 'XCHU17' 0 []}';
XCHU18={'mo' 'XCHU18' 0 []}';
XCHU19={'mo' 'XCHU19' 0 []}';
XCHU20={'mo' 'XCHU20' 0 []}';
% ----21
XCHU22={'mo' 'XCHU22' 0 []}';
XCHU23={'mo' 'XCHU23' 0 []}';
XCHU24={'mo' 'XCHU24' 0 []}';
XCHU25={'mo' 'XCHU25' 0 []}';
XCHU26={'mo' 'XCHU26' 0 []}';
XCHU27={'mo' 'XCHU27' 0 []}';
% ----28
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
XCHU47={'mo' 'XCHU47' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator Y-steering coils in undulator segments
% ------------------------------------------------------------------------------
% ----13
YCHU14={'mo' 'YCHU14' 0 []}';
YCHU15={'mo' 'YCHU15' 0 []}';
YCHU16={'mo' 'YCHU16' 0 []}';
YCHU17={'mo' 'YCHU17' 0 []}';
YCHU18={'mo' 'YCHU18' 0 []}';
YCHU19={'mo' 'YCHU19' 0 []}';
YCHU20={'mo' 'YCHU20' 0 []}';
% ----21
YCHU22={'mo' 'YCHU22' 0 []}';
YCHU23={'mo' 'YCHU23' 0 []}';
YCHU24={'mo' 'YCHU24' 0 []}';
YCHU25={'mo' 'YCHU25' 0 []}';
YCHU26={'mo' 'YCHU26' 0 []}';
YCHU27={'mo' 'YCHU27' 0 []}';
% ----28
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
YCHU47={'mo' 'YCHU47' 0 []}';
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
RFBHX47={'mo' 'RFBHX47' LRFBUB []}';
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
% HXR quadrupole centers
MUQH13={'mo' 'MUQH13' 0 []}';
MUQH14={'mo' 'MUQH14' 0 []}';
MUQH15={'mo' 'MUQH15' 0 []}';
MUQH16={'mo' 'MUQH16' 0 []}';
MUQH17={'mo' 'MUQH17' 0 []}';
MUQH18={'mo' 'MUQH18' 0 []}';
MUQH19={'mo' 'MUQH19' 0 []}';
MUQH20={'mo' 'MUQH20' 0 []}';
MUQH21={'mo' 'MUQH21' 0 []}';
MUQH22={'mo' 'MUQH22' 0 []}';
MUQH23={'mo' 'MUQH23' 0 []}';
MUQH24={'mo' 'MUQH24' 0 []}';
MUQH25={'mo' 'MUQH25' 0 []}';
MUQH26={'mo' 'MUQH26' 0 []}';
MUQH27={'mo' 'MUQH27' 0 []}';
MUQH28={'mo' 'MUQH28' 0 []}';
MUQH29={'mo' 'MUQH29' 0 []}';
MUQH30={'mo' 'MUQH30' 0 []}';
MUQH31={'mo' 'MUQH31' 0 []}';
MUQH32={'mo' 'MUQH32' 0 []}';
MUQH33={'mo' 'MUQH33' 0 []}';
MUQH34={'mo' 'MUQH34' 0 []}';
MUQH35={'mo' 'MUQH35' 0 []}';
MUQH36={'mo' 'MUQH36' 0 []}';
MUQH37={'mo' 'MUQH37' 0 []}';
MUQH38={'mo' 'MUQH38' 0 []}';
MUQH39={'mo' 'MUQH39' 0 []}';
MUQH40={'mo' 'MUQH40' 0 []}';
MUQH41={'mo' 'MUQH41' 0 []}';
MUQH42={'mo' 'MUQH42' 0 []}';
MUQH43={'mo' 'MUQH43' 0 []}';
MUQH44={'mo' 'MUQH44' 0 []}';
MUQH45={'mo' 'MUQH45' 0 []}';
MUQH46={'mo' 'MUQH46' 0 []}';
MUQH47={'mo' 'MUQH47' 0 []}';
% HXR phase shifter centers
% ----13
MPHH14={'mo' 'MPHH14' 0 []}';
MPHH15={'mo' 'MPHH15' 0 []}';
MPHH16={'mo' 'MPHH16' 0 []}';
MPHH17={'mo' 'MPHH17' 0 []}';
MPHH18={'mo' 'MPHH18' 0 []}';
MPHH19={'mo' 'MPHH19' 0 []}';
MPHH20={'mo' 'MPHH20' 0 []}';
% ----21
MPHH22={'mo' 'MPHH22' 0 []}';
MPHH23={'mo' 'MPHH23' 0 []}';
MPHH24={'mo' 'MPHH24' 0 []}';
MPHH25={'mo' 'MPHH25' 0 []}';
MPHH26={'mo' 'MPHH26' 0 []}';
MPHH27={'mo' 'MPHH27' 0 []}';
% ----28
MPHH29={'mo' 'MPHH29' 0 []}';
MPHH30={'mo' 'MPHH30' 0 []}';
MPHH31={'mo' 'MPHH31' 0 []}';
MPHH32={'mo' 'MPHH32' 0 []}';
MPHH33={'mo' 'MPHH33' 0 []}';
MPHH34={'mo' 'MPHH34' 0 []}';
MPHH35={'mo' 'MPHH35' 0 []}';
MPHH36={'mo' 'MPHH36' 0 []}';
MPHH37={'mo' 'MPHH37' 0 []}';
MPHH38={'mo' 'MPHH38' 0 []}';
MPHH39={'mo' 'MPHH39' 0 []}';
MPHH40={'mo' 'MPHH40' 0 []}';
MPHH41={'mo' 'MPHH41' 0 []}';
MPHH42={'mo' 'MPHH42' 0 []}';
MPHH43={'mo' 'MPHH43' 0 []}';
MPHH44={'mo' 'MPHH44' 0 []}';
MPHH45={'mo' 'MPHH45' 0 []}';
MPHH46={'mo' 'MPHH46' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator phase shifters
% ------------------------------------------------------------------------------
DPSHX13={'dr' '' LPSHX []}';
PSHXH14_FULL=[PSHXH14,MPHH14,PSHXH14];
PSHXH15_FULL=[PSHXH15,MPHH15,PSHXH15];
PSHXH16_FULL=[PSHXH16,MPHH16,PSHXH16];
PSHXH17_FULL=[PSHXH17,MPHH17,PSHXH17];
PSHXH18_FULL=[PSHXH18,MPHH18,PSHXH18];
PSHXH19_FULL=[PSHXH19,MPHH19,PSHXH19];
PSHXH20_FULL=[PSHXH20,MPHH20,PSHXH20];
DPSHX21={'dr' '' LPSHX []}';
PSHXH22_FULL=[PSHXH22,MPHH22,PSHXH22];
PSHXH23_FULL=[PSHXH23,MPHH23,PSHXH23];
PSHXH24_FULL=[PSHXH24,MPHH24,PSHXH24];
PSHXH25_FULL=[PSHXH25,MPHH25,PSHXH25];
PSHXH26_FULL=[PSHXH26,MPHH26,PSHXH26];
PSHXH27_FULL=[PSHXH27,MPHH27,PSHXH27];
DPSHX28={'dr' '' LPSHX []}';
PSHXH29_FULL=[PSHXH29,MPHH29,PSHXH29];
PSHXH30_FULL=[PSHXH30,MPHH30,PSHXH30];
PSHXH31_FULL=[PSHXH31,MPHH31,PSHXH31];
PSHXH32_FULL=[PSHXH32,MPHH32,PSHXH32];
PSHXH33_FULL=[PSHXH33,MPHH33,PSHXH33];
PSHXH34_FULL=[PSHXH34,MPHH34,PSHXH34];
PSHXH35_FULL=[PSHXH35,MPHH35,PSHXH35];
PSHXH36_FULL=[PSHXH36,MPHH36,PSHXH36];
PSHXH37_FULL=[PSHXH37,MPHH37,PSHXH37];
PSHXH38_FULL=[PSHXH38,MPHH38,PSHXH38];
PSHXH39_FULL=[PSHXH39,MPHH39,PSHXH39];
PSHXH40_FULL=[PSHXH40,MPHH40,PSHXH40];
PSHXH41_FULL=[PSHXH41,MPHH41,PSHXH41];
PSHXH42_FULL=[PSHXH42,MPHH42,PSHXH42];
PSHXH43_FULL=[PSHXH43,MPHH43,PSHXH43];
PSHXH44_FULL=[PSHXH44,MPHH44,PSHXH44];
PSHXH45_FULL=[PSHXH45,MPHH45,PSHXH45];
PSHXH46_FULL=[PSHXH46,MPHH46,PSHXH46];
DPSHX47={'dr' '' LPSHX []}';
DPSHX48={'dr' '' LPSHX []}';
DPSHX49={'dr' '' LPSHX []}';
DPSHX50={'dr' '' LPSHX []}';
% ------------------------------------------------------------------------------
% HXR undulator inline vacuum isolation valves (VAT Series 48?)
% ------------------------------------------------------------------------------
VVHXU14={'mo' 'VVHXU14' 0 []}';
VVHXU17={'mo' 'VVHXU17' 0 []}';
VVHXU20={'mo' 'VVHXU20' 0 []}';
VVHXU22={'mo' 'VVHXU22' 0 []}';
VVHXU24={'mo' 'VVHXU24' 0 []}';
VVHXU27={'mo' 'VVHXU27' 0 []}';
VVHXU29={'mo' 'VVHXU29' 0 []}';
VVHXU32={'mo' 'VVHXU32' 0 []}';
VVHXU35={'mo' 'VVHXU35' 0 []}';
VVHXU37={'mo' 'VVHXU37' 0 []}';
VVHXU40={'mo' 'VVHXU40' 0 []}';
VVHXU43={'mo' 'VVHXU43' 0 []}';
VVHXU45={'mo' 'VVHXU45' 0 []}';
DVVHXU={'dr' '' 0 []}';
% ------------------------------------------------------------------------------
% HXR undulator Beam Loss Monitors (placeholders)
% ------------------------------------------------------------------------------
MBLMH14={'mo' 'MBLMH14' 0 []}';
MBLMH16={'mo' 'MBLMH16' 0 []}';
MBLMH18={'mo' 'MBLMH18' 0 []}';
MBLMH20={'mo' 'MBLMH20' 0 []}';
MBLMH22={'mo' 'MBLMH22' 0 []}';
MBLMH24={'mo' 'MBLMH24' 0 []}';
MBLMH26={'mo' 'MBLMH26' 0 []}';
% -----28
MBLMH30={'mo' 'MBLMH30' 0 []}';
MBLMH32={'mo' 'MBLMH32' 0 []}';
MBLMH34={'mo' 'MBLMH34' 0 []}';
MBLMH36={'mo' 'MBLMH36' 0 []}';
MBLMH38={'mo' 'MBLMH38' 0 []}';
MBLMH40={'mo' 'MBLMH40' 0 []}';
MBLMH42={'mo' 'MBLMH42' 0 []}';
MBLMH44={'mo' 'MBLMH44' 0 []}';
MBLMH46={'mo' 'MBLMH46' 0 []}';
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
%LHssB2Bo := 0.939 outer bend center-to-center (PRD Table 3)
%LHssB2Bi := 0.936 inner bend center-to-center (PRD Table 3)
LHSSB2BO =  0.957   ;%outer bend center-to-center (PRD Table 3)
LHSSB2BI =  0.936   ;%inner bend center-to-center (PRD Table 3)
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
% CBXFEL chicanes (off-project)
% ------------------------------------------------------------------------------
% NOTEs:
% - Bmax = 3.5 kG-m @ 12 A (approximately)
% - Emax = 10.35 GeV for CBXFEL project (8.6 GeV for DBFEL project)
% - use series approximation for sinc(x)=sin(x)/x to allow AB6=0
% - deflects toward +X (to the left/north/aisle)
% - bends toward coil side of C-dipoles
% - use Everson Tesla (ETI) "0.276D14-C" dipoles (356 mm core, 7 mm gap)
ECMAX =  10.35        ;%6.3-10.35 GeV
BRHO6 =  CB*ECMAX     ;%beam rigidity at CBXFEL chicanes (kG-m)
BL6MAX =   3.5         ;%kG-m @ ~12 A (measured)
AB6MAX =  BL6MAX/BRHO6 ;%rad
GB6 =  0.007                             ;%full gap height [m]
ZB6 =  0.368                             ;%on-axis effective length (per ETI)
FB6 =  1.0408                            ;%measured
AB6 =  +AB6MAX*SETCBXFEL                 ;%bend angle (rad)
AB6_2 =  AB6*AB6;
AB6_4 =  AB6_2*AB6_2;
AB6_6 =  AB6_4*AB6_2;
SINCAB6 =  1-AB6_2/6+AB6_4/120-AB6_6/5040    ;%~sinc(AB6)=sin(AB6)/AB6
LB6 =  ZB6/SINCAB6                       ;%chicane bend path length (m)
AB6S =  asin(sin(AB6)/2)                  ;%"short" half chicane bend angle (rad)
AB6S_2 =  AB6S*AB6S;
AB6S_4 =  AB6S_2*AB6S_2;
AB6S_6 =  AB6S_4*AB6S_2;
SINCAB6S =  1-AB6S_2/6+AB6S_4/120-AB6S_6/5040 ;%~sinc(AB6s)=sin(AB6s)/AB6s
LB6S =  (ZB6/2)/SINCAB6S                  ;%"short" half chicane bend path length (m)
AB6L =  AB6-AB6S                          ;%"long" half chicane bend angle (rad)
LB6L =  LB6-LB6S                          ;%"long" half chicane bend path length (m)
BCXCBX11A={'be' 'BCXCBX11' LB6S [-AB6S GB6/2 0 0 FB6 0 0]}';
BCXCBX11B={'be' 'BCXCBX11' LB6L [-AB6L GB6/2 0 -AB6 0 FB6 0]}';
BCXCBX12A={'be' 'BCXCBX12' LB6L [+AB6L GB6/2 +AB6 0 FB6 0 0]}';
BCXCBX12B={'be' 'BCXCBX12' LB6S [+AB6S GB6/2 0 0 0 FB6 0]}';
BCXCBX13A={'be' 'BCXCBX13' LB6S [+AB6S GB6/2 0 0 FB6 0 0]}';
BCXCBX13B={'be' 'BCXCBX13' LB6L [+AB6L GB6/2 0 +AB6 0 FB6 0]}';
BCXCBX14A={'be' 'BCXCBX14' LB6L [-AB6L GB6/2 -AB6 0 FB6 0 0]}';
BCXCBX14B={'be' 'BCXCBX14' LB6S [-AB6S GB6/2 0 0 0 FB6 0]}';
BCXCBX21A={'be' 'BCXCBX21' LB6S [-AB6S GB6/2 0 0 FB6 0 0]}';
BCXCBX21B={'be' 'BCXCBX21' LB6L [-AB6L GB6/2 0 -AB6 0 FB6 0]}';
BCXCBX22A={'be' 'BCXCBX22' LB6L [+AB6L GB6/2 +AB6 0 FB6 0 0]}';
BCXCBX22B={'be' 'BCXCBX22' LB6S [+AB6S GB6/2 0 0 0 FB6 0]}';
BCXCBX23A={'be' 'BCXCBX23' LB6S [+AB6S GB6/2 0 0 FB6 0 0]}';
BCXCBX23B={'be' 'BCXCBX23' LB6L [+AB6L GB6/2 0 +AB6 0 FB6 0]}';
BCXCBX24A={'be' 'BCXCBX24' LB6L [-AB6L GB6/2 -AB6 0 FB6 0 0]}';
BCXCBX24B={'be' 'BCXCBX24' LB6S [-AB6S GB6/2 0 0 0 FB6 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BCXCBX11={'be' 'BCXCBX1' LB6 [-AB6 GB6/2 0 -AB6 FB6 FB6 0]}';
BCXCBX12={'be' 'BCXCBX1' LB6 [+AB6 GB6/2 +AB6 0 FB6 FB6 0]}';
BCXCBX13={'be' 'BCXCBX13' LB6 [+AB6 GB6/2 0 +AB6 FB6 FB6 0]}';
BCXCBX14={'be' 'BCXCBX14' LB6 [-AB6 GB6/2 -AB6 0 FB6 FB6 0]}';
BCXCBX21={'be' 'BCXCBX2' LB6 [-AB6 GB6/2 0 -AB6 FB6 FB6 0]}';
BCXCBX22={'be' 'BCXCBX2' LB6 [+AB6 GB6/2 +AB6 0 FB6 FB6 0]}';
BCXCBX23={'be' 'BCXCBX23' LB6 [+AB6 GB6/2 0 +AB6 FB6 FB6 0]}';
BCXCBX24={'be' 'BCXCBX24' LB6 [-AB6 GB6/2 -AB6 0 FB6 FB6 0]}';
%Ztotal  := 134.391*in2m  total system length
%Zuseg   := 3.372032      undulator segment length
ZB2BO =  1.23035       ;%outer bend center-to-center
ZB2BI =  0.535763      ;%inner bend center-to-center
ZCBXC1 =  3.504082 ;%0.1+(D0CB1[L]+ZB6/2+ZB2Bo+ZB2Bi+ZB2Bo+ZB6/2)
ZCBXC2 =  3.504089 ;%0.1+(D0CB2[L]+ZB6/2+ZB2Bo+ZB2Bi+ZB2Bo+ZB6/2)
D0CB1={'dr' '' 0.264603-(DU1H{3}+DU2H{3}+ZB6/2) []}';%0.26456
D1CB1={'dr' '' (ZB2BO-ZB6)/cos(AB6) []}';
D1CB1A={'dr' '' (0.656216-ZB6/2)/cos(AB6) []}';
D1CB1B={'dr' '' 0.1059/cos(AB6) []}';
D1CB1C={'dr' '' D1CB1{3}-D1CB1A{3}-D1CB1B{3} []}';
DCHCB1={'dr' '' (ZB2BI-ZB6)/2 []}';
D2CB={'dr' '' D1CB1{3} []}';
D2CBA={'dr' '' 0.568799 []}';
D2CBA2={'dr' '' 517.8785-517.8728101 []}';
D2CBA1={'dr' '' D2CBA{3}-D2CBA2{3} []}';
D2CBB={'dr' '' D2CB{3}-D2CBA{3} []}';
D3CB1={'dr' '' ZCBXC1-(D0CB1{3}+ZB6/2+ZB2BO+ZB2BI+ZB2BO+ZB6/2) []}';
DU3HCB1={'dr' '' 0.203362-D3CB1{3} []}';%2*DU3h[L]+0.133428  0.102780
DU4HCB1={'dr' '' DU4H{3}-0.000176 []}';%-0.025003
DU5HCB1={'dr' '' DU5H{3}+0.000741 []}';%-0.133252 -0.108382
D0CB2={'dr' '' 0.264610-(DU1H{3}+DU2H{3}+ZB6/2) []}';%0.26456
D1CB2={'dr' '' D1CB1{3} []}';
D1CB2A={'dr' '' (0.605122666708-ZB6/2)/cos(AB6) []}';
D1CB2B={'dr' '' 0.05019/cos(AB6) []}';
D1CB2C={'dr' '' D1CB2{3}-D1CB2A{3}-D1CB2B{3} []}';
DCHCB2={'dr' '' DCHCB1{3} []}';
D3CB2={'dr' '' ZCBXC2-(D0CB2{3}+ZB6/2+ZB2BO+ZB2BI+ZB2BO+ZB6/2) []}';
DU3HCB2={'dr' '' 0.203362-D3CB2{3} []}';%DU3h[L]+0.184427
DU4HCB2={'dr' '' DU4H{3}-0.000176 []}';%-0.025003
DU5HCB2={'dr' '' DU5H{3}+0.000734 []}';%-0.133259 -0.108382
HXRCB1BEG={'mo' 'HXRCB1BEG' 0 []}';
MCBX4={'mo' 'MCBX4' 0 []}';%X-ray diamond crystal mirror
YAGCBX42={'mo' 'YAGCBX42' 0 []}';
CENTER1={'mo' 'CENTER1' 0 []}';
PRCBX40={'mo' 'PRCBX40' 0 []}';%Diamond
BODCBX40={'mo' 'BODCBX40' 0 []}';%Beam Overlap Diagnostic
HXRCB1END={'mo' 'HXRCB1END' 0 []}';
HXRCB2BEG={'mo' 'HXRCB2BEG' 0 []}';
DSSCBX11={'mo' 'DSSCBX11' 0 []}';%Diamond scintillator screen
MCBX1={'mo' 'MCBX1' 0 []}';%X-ray diamond crystal mirror
CENTER2={'mo' 'CENTER2' 0 []}';
HXRCB2END={'mo' 'HXRCB2END' 0 []}';
BCXCBX11_FULL=[BCXCBX11A,BCXCBX11B];
BCXCBX12_FULL=[BCXCBX12A,BCXCBX12B];
BCXCBX13_FULL=[BCXCBX13A,BCXCBX13B];
BCXCBX14_FULL=[BCXCBX14A,BCXCBX14B];
BCXCBX21_FULL=[BCXCBX21A,BCXCBX21B];
BCXCBX22_FULL=[BCXCBX22A,BCXCBX22B];
BCXCBX23_FULL=[BCXCBX23A,BCXCBX23B];
BCXCBX24_FULL=[BCXCBX24A,BCXCBX24B];
CBCHICANE1=[HXRCB1BEG,D0CB1,BCXCBX11_FULL,D1CB1A,MCBX4,D1CB1B,YAGCBX42,D1CB1C,BCXCBX12_FULL,DCHCB1,CENTER1,DCHCB1,BCXCBX13_FULL,D2CBA1,PRCBX40,D2CBA2,BODCBX40,D2CBB,BCXCBX14_FULL,D3CB1,HXRCB1END];
CBCHICANE2=[HXRCB2BEG,D0CB2,BCXCBX21_FULL,D1CB2A,DSSCBX11,D1CB2B,MCBX1,D1CB2C,BCXCBX22_FULL,DCHCB2,CENTER2,DCHCB2,BCXCBX23_FULL,D2CB,BCXCBX24_FULL,D3CB2,HXRCB2END];
% ------------------------------------------------------------------------------
% DBFEL (install later)
%ZB3toC1 := 0.32356 3rd bend center to DBFEL crystal #1
%ZB3toC4 := 0.77365 3rd bend center to DBFEL crystal #4
%D2CBa : DRIF, L=(ZB3toC1-ZB6/2)/COS(AB6)
%D2CBb : DRIF, L=(ZB3toC4-ZB3toC1)/COS(AB6)
%D2CBd : DRIF, L=0.0 +dSmdw
%D2CBc : DRIF, L=D2CB[L]-D2CBa[L]-D2CBb[L]-D2CBd[L]
%CRYSTAL11 : INST 1.55 mm
%CRYSTAL12 : INST 1.55 mm
%CRYSTAL21 : INST 1.55 mm
%CRYSTAL22 : INST 1.55 mm
% ------------------------------------------------------------------------------
% HXR undulator cells
% ------------------------------------------------------------------------------
% ------13
UMAHXH14_FULL=[UMAHXH14,XCHU14,YCHU14,UMAHXH14];
UMAHXH15_FULL=[UMAHXH15,XCHU15,YCHU15,UMAHXH15];
UMAHXH16_FULL=[UMAHXH16,XCHU16,YCHU16,UMAHXH16];
UMAHXH17_FULL=[UMAHXH17,XCHU17,YCHU17,UMAHXH17];
UMAHXH18_FULL=[UMAHXH18,XCHU18,YCHU18,UMAHXH18];
UMAHXH19_FULL=[UMAHXH19,XCHU19,YCHU19,UMAHXH19];
UMAHXH20_FULL=[UMAHXH20,XCHU20,YCHU20,UMAHXH20];
% ------21
UMAHXH22_FULL=[UMAHXH22,XCHU22,YCHU22,UMAHXH22];
UMAHXH23_FULL=[UMAHXH23,XCHU23,YCHU23,UMAHXH23];
UMAHXH24_FULL=[UMAHXH24,XCHU24,YCHU24,UMAHXH24];
UMAHXH25_FULL=[UMAHXH25,XCHU25,YCHU25,UMAHXH25];
UMAHXH26_FULL=[UMAHXH26,XCHU26,YCHU26,UMAHXH26];
UMAHXH27_FULL=[UMAHXH27,XCHU27,YCHU27,UMAHXH27];
% ------28
UMAHXH29_FULL=[UMAHXH29,XCHU29,YCHU29,UMAHXH29];
UMAHXH30_FULL=[UMAHXH30,XCHU30,YCHU30,UMAHXH30];
UMAHXH31_FULL=[UMAHXH31,XCHU31,YCHU31,UMAHXH31];
UMAHXH32_FULL=[UMAHXH32,XCHU32,YCHU32,UMAHXH32];
UMAHXH33_FULL=[UMAHXH33,XCHU33,YCHU33,UMAHXH33];
UMAHXH34_FULL=[UMAHXH34,XCHU34,YCHU34,UMAHXH34];
UMAHXH35_FULL=[UMAHXH35,XCHU35,YCHU35,UMAHXH35];
UMAHXH36_FULL=[UMAHXH36,XCHU36,YCHU36,UMAHXH36];
UMAHXH37_FULL=[UMAHXH37,XCHU37,YCHU37,UMAHXH37];
UMAHXH38_FULL=[UMAHXH38,XCHU38,YCHU38,UMAHXH38];
UMAHXH39_FULL=[UMAHXH39,XCHU39,YCHU39,UMAHXH39];
UMAHXH40_FULL=[UMAHXH40,XCHU40,YCHU40,UMAHXH40];
UMAHXH41_FULL=[UMAHXH41,XCHU41,YCHU41,UMAHXH41];
UMAHXH42_FULL=[UMAHXH42,XCHU42,YCHU42,UMAHXH42];
UMAHXH43_FULL=[UMAHXH43,XCHU43,YCHU43,UMAHXH43];
UMAHXH44_FULL=[UMAHXH44,XCHU44,YCHU44,UMAHXH44];
UMAHXH45_FULL=[UMAHXH45,XCHU45,YCHU45,UMAHXH45];
UMAHXH46_FULL=[UMAHXH46,XCHU46,YCHU46,UMAHXH46];
UMAHXH47_FULL=[UMAHXH47,XCHU47,YCHU47,UMAHXH47];
DUSEGH13=[CBCHICANE1];
USEGHX14=[DTHXU,UMAHXH14_FULL,DTHXU];
USEGHX15=[DTHXU,UMAHXH15_FULL,DTHXU];
USEGHX16=[DTHXU,UMAHXH16_FULL,DTHXU];
USEGHX17=[DTHXU,UMAHXH17_FULL,DTHXU];
USEGHX18=[DTHXU,UMAHXH18_FULL,DTHXU];
USEGHX19=[DTHXU,UMAHXH19_FULL,DTHXU];
USEGHX20=[DTHXU,UMAHXH20_FULL,DTHXU];
DUSEGH21=[CBCHICANE2];
USEGHX22=[DTHXU,UMAHXH22_FULL,DTHXU];
USEGHX23=[DTHXU,UMAHXH23_FULL,DTHXU];
USEGHX24=[DTHXU,UMAHXH24_FULL,DTHXU];
USEGHX25=[DTHXU,UMAHXH25_FULL,DTHXU];
USEGHX26=[DTHXU,UMAHXH26_FULL,DTHXU];
USEGHX27=[DTHXU,UMAHXH27_FULL,DTHXU];
DUSEGH28=[HCHICANE];
USEGHX29=[DTHXU,UMAHXH29_FULL,DTHXU];
USEGHX30=[DTHXU,UMAHXH30_FULL,DTHXU];
USEGHX31=[DTHXU,UMAHXH31_FULL,DTHXU];
USEGHX32=[DTHXU,UMAHXH32_FULL,DTHXU];
USEGHX33=[DTHXU,UMAHXH33_FULL,DTHXU];
USEGHX34=[DTHXU,UMAHXH34_FULL,DTHXU];
USEGHX35=[DTHXU,UMAHXH35_FULL,DTHXU];
USEGHX36=[DTHXU,UMAHXH36_FULL,DTHXU];
USEGHX37=[DTHXU,UMAHXH37_FULL,DTHXU];
USEGHX38=[DTHXU,UMAHXH38_FULL,DTHXU];
USEGHX39=[DTHXU,UMAHXH39_FULL,DTHXU];
USEGHX40=[DTHXU,UMAHXH40_FULL,DTHXU];
USEGHX41=[DTHXU,UMAHXH41_FULL,DTHXU];
USEGHX42=[DTHXU,UMAHXH42_FULL,DTHXU];
USEGHX43=[DTHXU,UMAHXH43_FULL,DTHXU];
USEGHX44=[DTHXU,UMAHXH44_FULL,DTHXU];
USEGHX45=[DTHXU,UMAHXH45_FULL,DTHXU];
USEGHX46=[DTHXU,UMAHXH46_FULL,DTHXU];
USEGHX47=[DTHXU,UMAHXH47_FULL,DTHXU];
DUSEGH48={'dr' '' LDUSEGH []}';
DUSEGH49={'dr' '' LDUSEGH []}';
DUSEGH50={'dr' '' LDUSEGH []}';
QHXH13_FULL=[QHXH13,XCHX13,MUQH13,YCHX13,QHXH13];
QHXH14_FULL=[QHXH14,XCHX14,MUQH14,YCHX14,QHXH14];
QHXH15_FULL=[QHXH15,XCHX15,MUQH15,YCHX15,QHXH15];
QHXH16_FULL=[QHXH16,XCHX16,MUQH16,YCHX16,QHXH16];
QHXH17_FULL=[QHXH17,XCHX17,MUQH17,YCHX17,QHXH17];
QHXH18_FULL=[QHXH18,XCHX18,MUQH18,YCHX18,QHXH18];
QHXH19_FULL=[QHXH19,XCHX19,MUQH19,YCHX19,QHXH19];
QHXH20_FULL=[QHXH20,XCHX20,MUQH20,YCHX20,QHXH20];
QHXH21_FULL=[QHXH21,XCHX21,MUQH21,YCHX21,QHXH21];
QHXH22_FULL=[QHXH22,XCHX22,MUQH22,YCHX22,QHXH22];
QHXH23_FULL=[QHXH23,XCHX23,MUQH23,YCHX23,QHXH23];
QHXH24_FULL=[QHXH24,XCHX24,MUQH24,YCHX24,QHXH24];
QHXH25_FULL=[QHXH25,XCHX25,MUQH25,YCHX25,QHXH25];
QHXH26_FULL=[QHXH26,XCHX26,MUQH26,YCHX26,QHXH26];
QHXH27_FULL=[QHXH27,XCHX27,MUQH27,YCHX27,QHXH27];
QHXH28_FULL=[QHXH28,XCHX28,MUQH28,YCHX28,QHXH28];
QHXH29_FULL=[QHXH29,XCHX29,MUQH29,YCHX29,QHXH29];
QHXH30_FULL=[QHXH30,XCHX30,MUQH30,YCHX30,QHXH30];
QHXH31_FULL=[QHXH31,XCHX31,MUQH31,YCHX31,QHXH31];
QHXH32_FULL=[QHXH32,XCHX32,MUQH32,YCHX32,QHXH32];
QHXH33_FULL=[QHXH33,XCHX33,MUQH33,YCHX33,QHXH33];
QHXH34_FULL=[QHXH34,XCHX34,MUQH34,YCHX34,QHXH34];
QHXH35_FULL=[QHXH35,XCHX35,MUQH35,YCHX35,QHXH35];
QHXH36_FULL=[QHXH36,XCHX36,MUQH36,YCHX36,QHXH36];
QHXH37_FULL=[QHXH37,XCHX37,MUQH37,YCHX37,QHXH37];
QHXH38_FULL=[QHXH38,XCHX38,MUQH38,YCHX38,QHXH38];
QHXH39_FULL=[QHXH39,XCHX39,MUQH39,YCHX39,QHXH39];
QHXH40_FULL=[QHXH40,XCHX40,MUQH40,YCHX40,QHXH40];
QHXH41_FULL=[QHXH41,XCHX41,MUQH41,YCHX41,QHXH41];
QHXH42_FULL=[QHXH42,XCHX42,MUQH42,YCHX42,QHXH42];
QHXH43_FULL=[QHXH43,XCHX43,MUQH43,YCHX43,QHXH43];
QHXH44_FULL=[QHXH44,XCHX44,MUQH44,YCHX44,QHXH44];
QHXH45_FULL=[QHXH45,XCHX45,MUQH45,YCHX45,QHXH45];
QHXH46_FULL=[QHXH46,XCHX46,MUQH46,YCHX46,QHXH46];
QHXH47_FULL=[QHXH47,XCHX47,MUQH47,YCHX47,QHXH47];
DQHX48={'dr' '' LQU []}';
DQHX49={'dr' '' LQU []}';
DQHX50={'dr' '' LQU []}';
HXBRK13=[DU3HCB1,QHXH13_FULL,DU4HCB1,RFBHX13,DU5HCB1,DU7H];
HXBRK14=[DU3H,MBLMH14,DU3H,QHXH14_FULL,DU4H,RFBHX14,DU5H,PSHXH14_FULL,DU6H,VVHXU14,DU7H];
HXBRK15=[DU3H,        DU3H,QHXH15_FULL,DU4H,RFBHX15,DU5H,PSHXH15_FULL,DU6H,DVVHXU,DU7H];
HXBRK16=[DU3H,MBLMH16,DU3H,QHXH16_FULL,DU4H,RFBHX16,DU5H,PSHXH16_FULL,DU6H,DVVHXU,DU7H];
HXBRK17=[DU3H,        DU3H,QHXH17_FULL,DU4H,RFBHX17,DU5H,PSHXH17_FULL,DU6H,VVHXU17,DU7H];
HXBRK18=[DU3H,MBLMH18,DU3H,QHXH18_FULL,DU4H,RFBHX18,DU5H,PSHXH18_FULL,DU6H,DVVHXU,DU7H];
HXBRK19=[DU3H,        DU3H,QHXH19_FULL,DU4H,RFBHX19,DU5H,PSHXH19_FULL,DU6H,DVVHXU,DU7H];
HXBRK20=[DU3H,MBLMH20,DU3H,QHXH20_FULL,DU4H,RFBHX20,DU5H,PSHXH20_FULL,DU6H,VVHXU20,DU7H];
HXBRK21=[DU3HCB2,QHXH21_FULL,DU4HCB2,RFBHX21,DU5HCB2,DU7H];
HXBRK22=[DU3H,MBLMH22,DU3H,QHXH22_FULL,DU4H,RFBHX22,DU5H,PSHXH22_FULL,DU6H,VVHXU22,DU7H];
HXBRK23=[DU3H,        DU3H,QHXH23_FULL,DU4H,RFBHX23,DU5H,PSHXH23_FULL,DU6H,DVVHXU,DU7H];
HXBRK24=[DU3H,MBLMH24,DU3H,QHXH24_FULL,DU4H,RFBHX24,DU5H,PSHXH24_FULL,DU6H,VVHXU24,DU7H];
HXBRK25=[DU3H,        DU3H,QHXH25_FULL,DU4H,RFBHX25,DU5H,PSHXH25_FULL,DU6H,DVVHXU,DU7H];
HXBRK26=[DU3H,MBLMH26,DU3H,QHXH26_FULL,DU4H,RFBHX26,DU5H,PSHXH26_FULL,DU6H,DVVHXU,DU7H];
HXBRK27=[DU3H,        DU3H,QHXH27_FULL,DU4H,RFBHX27,DU5H,PSHXH27_FULL,DU6H,VVHXU27,DU7H];
HXBRK28=[DU3H,        DU3H,QHXH28_FULL,DU4H,RFBHX28,DU5H,DPSHX28     ,DU6H        ,DU7H];
HXBRK29=[DU3H,        DU3H,QHXH29_FULL,DU4H,RFBHX29,DU5H,PSHXH29_FULL,DU6H,VVHXU29,DU7H];
HXBRK30=[DU3H,MBLMH30,DU3H,QHXH30_FULL,DU4H,RFBHX30,DU5H,PSHXH30_FULL,DU6H,DVVHXU,DU7H];
HXBRK31=[DU3H,        DU3H,QHXH31_FULL,DU4H,RFBHX31,DU5H,PSHXH31_FULL,DU6H,DVVHXU,DU7H];
HXBRK32=[DU3H,MBLMH32,DU3H,QHXH32_FULL,DU4H,RFBHX32,DU5H,PSHXH32_FULL,DU6H,VVHXU32,DU7H];
HXBRK33=[DU3H,        DU3H,QHXH33_FULL,DU4H,RFBHX33,DU5H,PSHXH33_FULL,DU6H,DVVHXU,DU7H];
HXBRK34=[DU3H,MBLMH34,DU3H,QHXH34_FULL,DU4H,RFBHX34,DU5H,PSHXH34_FULL,DU6H,DVVHXU,DU7H];
HXBRK35=[DU3H,        DU3H,QHXH35_FULL,DU4H,RFBHX35,DU5H,PSHXH35_FULL,DU6H,VVHXU35,DU7H];
HXBRK36=[DU3H,MBLMH36,DU3H,QHXH36_FULL,DU4H,RFBHX36,DU5H,PSHXH36_FULL,DU6H,DVVHXU,DU7H];
HXBRK37=[DU3H,        DU3H,QHXH37_FULL,DU4H,RFBHX37,DU5H,PSHXH37_FULL,DU6H,VVHXU37,DU7H];
HXBRK38=[DU3H,MBLMH38,DU3H,QHXH38_FULL,DU4H,RFBHX38,DU5H,PSHXH38_FULL,DU6H,DVVHXU,DU7H];
HXBRK39=[DU3H,        DU3H,QHXH39_FULL,DU4H,RFBHX39,DU5H,PSHXH39_FULL,DU6H,DVVHXU,DU7H];
HXBRK40=[DU3H,MBLMH40,DU3H,QHXH40_FULL,DU4H,RFBHX40,DU5H,PSHXH40_FULL,DU6H,VVHXU40,DU7H];
HXBRK41=[DU3H,        DU3H,QHXH41_FULL,DU4H,RFBHX41,DU5H,PSHXH41_FULL,DU6H,DVVHXU,DU7H];
HXBRK42=[DU3H,MBLMH42,DU3H,QHXH42_FULL,DU4H,RFBHX42,DU5H,PSHXH42_FULL,DU6H,DVVHXU,DU7H];
HXBRK43=[DU3H,        DU3H,QHXH43_FULL,DU4H,RFBHX43,DU5H,PSHXH43_FULL,DU6H,VVHXU43,DU7H];
HXBRK44=[DU3H,MBLMH44,DU3H,QHXH44_FULL,DU4H,RFBHX44,DU5H,PSHXH44_FULL,DU6H,DVVHXU,DU7H];
HXBRK45=[DU3H,        DU3H,QHXH45_FULL,DU4H,RFBHX45,DU5H,PSHXH45_FULL,DU6H,VVHXU45,DU7H];
HXBRK46=[DU3H,MBLMH46,DU3H,QHXH46_FULL,DU4H,RFBHX46,DU5H,PSHXH46_FULL,DU6H,DVVHXU,DU7H];
HXBRK47=[DU3H,        DU3H,QHXH47_FULL,DU4H,RFBHX47,DU5H,DPSHX47     ,DU6H,DVVHXU,DU7H];
HXBRK48=[DU3H        ,DU3H,DQHX48     ,DU4H,DRFBH48,DU5H,DPSHX48     ,DU6H        ,DU7H];
HXBRK49=[DU3H        ,DU3H,DQHX49     ,DU4H,DRFBH49,DU5H,DPSHX49     ,DU6H        ,DU7H];
HXBRK50=[DU3H        ,DU3H,DQHX50     ,DU4H,DRFBH50,DU5H,DPSHX50     ,DU6H        ,DU7H];
% ------------------------------------------------------------------------------
% HXR cell definitions
% ------------------------------------------------------------------------------
HXR13BEG={'mo' 'HXR13BEG' 0 []}';
HXR13END={'mo' 'HXR13END' 0 []}';
HXR14BEG={'mo' 'HXR14BEG' 0 []}';
HXR14END={'mo' 'HXR14END' 0 []}';
HXR15BEG={'mo' 'HXR15BEG' 0 []}';
HXR15END={'mo' 'HXR15END' 0 []}';
HXR16BEG={'mo' 'HXR16BEG' 0 []}';
HXR16END={'mo' 'HXR16END' 0 []}';
HXR17BEG={'mo' 'HXR17BEG' 0 []}';
HXR17END={'mo' 'HXR17END' 0 []}';
HXR18BEG={'mo' 'HXR18BEG' 0 []}';
HXR18END={'mo' 'HXR18END' 0 []}';
HXR19BEG={'mo' 'HXR19BEG' 0 []}';
HXR19END={'mo' 'HXR19END' 0 []}';
HXR20BEG={'mo' 'HXR20BEG' 0 []}';
HXR20END={'mo' 'HXR20END' 0 []}';
HXR21BEG={'mo' 'HXR21BEG' 0 []}';
HXR21END={'mo' 'HXR21END' 0 []}';
HXR22BEG={'mo' 'HXR22BEG' 0 []}';
HXR22END={'mo' 'HXR22END' 0 []}';
HXR23BEG={'mo' 'HXR23BEG' 0 []}';
HXR23END={'mo' 'HXR23END' 0 []}';
HXR24BEG={'mo' 'HXR24BEG' 0 []}';
HXR24END={'mo' 'HXR24END' 0 []}';
HXR25BEG={'mo' 'HXR25BEG' 0 []}';
HXR25END={'mo' 'HXR25END' 0 []}';
HXR26BEG={'mo' 'HXR26BEG' 0 []}';
HXR26END={'mo' 'HXR26END' 0 []}';
HXR27BEG={'mo' 'HXR27BEG' 0 []}';
HXR27END={'mo' 'HXR27END' 0 []}';
HXR28BEG={'mo' 'HXR28BEG' 0 []}';
HXR28END={'mo' 'HXR28END' 0 []}';
HXR29BEG={'mo' 'HXR29BEG' 0 []}';
HXR29END={'mo' 'HXR29END' 0 []}';
HXR30BEG={'mo' 'HXR30BEG' 0 []}';
HXR30END={'mo' 'HXR30END' 0 []}';
HXR31BEG={'mo' 'HXR31BEG' 0 []}';
HXR31END={'mo' 'HXR31END' 0 []}';
HXR32BEG={'mo' 'HXR32BEG' 0 []}';
HXR32END={'mo' 'HXR32END' 0 []}';
HXR33BEG={'mo' 'HXR33BEG' 0 []}';
HXR33END={'mo' 'HXR33END' 0 []}';
HXR34BEG={'mo' 'HXR34BEG' 0 []}';
HXR34END={'mo' 'HXR34END' 0 []}';
HXR35BEG={'mo' 'HXR35BEG' 0 []}';
HXR35END={'mo' 'HXR35END' 0 []}';
HXR36BEG={'mo' 'HXR36BEG' 0 []}';
HXR36END={'mo' 'HXR36END' 0 []}';
HXR37BEG={'mo' 'HXR37BEG' 0 []}';
HXR37END={'mo' 'HXR37END' 0 []}';
HXR38BEG={'mo' 'HXR38BEG' 0 []}';
HXR38END={'mo' 'HXR38END' 0 []}';
HXR39BEG={'mo' 'HXR39BEG' 0 []}';
HXR39END={'mo' 'HXR39END' 0 []}';
HXR40BEG={'mo' 'HXR40BEG' 0 []}';
HXR40END={'mo' 'HXR40END' 0 []}';
HXR41BEG={'mo' 'HXR41BEG' 0 []}';
HXR41END={'mo' 'HXR41END' 0 []}';
HXR42BEG={'mo' 'HXR42BEG' 0 []}';
HXR42END={'mo' 'HXR42END' 0 []}';
HXR43BEG={'mo' 'HXR43BEG' 0 []}';
HXR43END={'mo' 'HXR43END' 0 []}';
HXR44BEG={'mo' 'HXR44BEG' 0 []}';
HXR44END={'mo' 'HXR44END' 0 []}';
HXR45BEG={'mo' 'HXR45BEG' 0 []}';
HXR45END={'mo' 'HXR45END' 0 []}';
HXR46BEG={'mo' 'HXR46BEG' 0 []}';
HXR46END={'mo' 'HXR46END' 0 []}';
HXR47BEG={'mo' 'HXR47BEG' 0 []}';
HXR47END={'mo' 'HXR47END' 0 []}';
HXR48BEG={'mo' 'HXR48BEG' 0 []}';
HXR48END={'mo' 'HXR48END' 0 []}';
HXR49BEG={'mo' 'HXR49BEG' 0 []}';
HXR49END={'mo' 'HXR49END' 0 []}';
HXR50BEG={'mo' 'HXR50BEG' 0 []}';
HXR50END={'mo' 'HXR50END' 0 []}';
HXCEL13=[HXR13BEG,DU1H,DU2H,DUSEGH13,HXBRK13,HXR13END];%CBCHICANE1+Q+RFBPM
HXCEL14=[HXR14BEG,DU1H,DU2H,USEGHX14,HXBRK14,HXR14END];
HXCEL15=[HXR15BEG,DU1H,DU2H,USEGHX15,HXBRK15,HXR15END];
HXCEL16=[HXR16BEG,DU1H,DU2H,USEGHX16,HXBRK16,HXR16END];
HXCEL17=[HXR17BEG,DU1H,DU2H,USEGHX17,HXBRK17,HXR17END];
HXCEL18=[HXR18BEG,DU1H,DU2H,USEGHX18,HXBRK18,HXR18END];
HXCEL19=[HXR19BEG,DU1H,DU2H,USEGHX19,HXBRK19,HXR19END];
HXCEL20=[HXR20BEG,DU1H,DU2H,USEGHX20,HXBRK20,HXR20END];
HXCEL21=[HXR21BEG,DU1H,DU2H,DUSEGH21,HXBRK21,HXR21END];%CBCHICANE2+Q+RFBPM
HXCEL22=[HXR22BEG,DU1H,DU2H,USEGHX22,HXBRK22,HXR22END];
HXCEL23=[HXR23BEG,DU1H,DU2H,USEGHX23,HXBRK23,HXR23END];
HXCEL24=[HXR24BEG,DU1H,DU2H,USEGHX24,HXBRK24,HXR24END];
HXCEL25=[HXR25BEG,DU1H,DU2H,USEGHX25,HXBRK25,HXR25END];
HXCEL26=[HXR26BEG,DU1H,DU2H,USEGHX26,HXBRK26,HXR26END];
HXCEL27=[HXR27BEG,DU1H,DU2H,USEGHX27,HXBRK27,HXR27END];
HXCEL28=[HXR28BEG,DU1H,DU2H,DUSEGH28,HXBRK28,HXR28END];%HXRSS+Q+RFBPM
HXCEL29=[HXR29BEG,DU1H,DU2H,USEGHX29,HXBRK29,HXR29END];
HXCEL30=[HXR30BEG,DU1H,DU2H,USEGHX30,HXBRK30,HXR30END];
HXCEL31=[HXR31BEG,DU1H,DU2H,USEGHX31,HXBRK31,HXR31END];
HXCEL32=[HXR32BEG,DU1H,DU2H,USEGHX32,HXBRK32,HXR32END];
HXCEL33=[HXR33BEG,DU1H,DU2H,USEGHX33,HXBRK33,HXR33END];
HXCEL34=[HXR34BEG,DU1H,DU2H,USEGHX34,HXBRK34,HXR34END];
HXCEL35=[HXR35BEG,DU1H,DU2H,USEGHX35,HXBRK35,HXR35END];
HXCEL36=[HXR36BEG,DU1H,DU2H,USEGHX36,HXBRK36,HXR36END];
HXCEL37=[HXR37BEG,DU1H,DU2H,USEGHX37,HXBRK37,HXR37END];
HXCEL38=[HXR38BEG,DU1H,DU2H,USEGHX38,HXBRK38,HXR38END];
HXCEL39=[HXR39BEG,DU1H,DU2H,USEGHX39,HXBRK39,HXR39END];
HXCEL40=[HXR40BEG,DU1H,DU2H,USEGHX40,HXBRK40,HXR40END];
HXCEL41=[HXR41BEG,DU1H,DU2H,USEGHX41,HXBRK41,HXR41END];
HXCEL42=[HXR42BEG,DU1H,DU2H,USEGHX42,HXBRK42,HXR42END];
HXCEL43=[HXR43BEG,DU1H,DU2H,USEGHX43,HXBRK43,HXR43END];
HXCEL44=[HXR44BEG,DU1H,DU2H,USEGHX44,HXBRK44,HXR44END];
HXCEL45=[HXR45BEG,DU1H,DU2H,USEGHX45,HXBRK45,HXR45END];
HXCEL46=[HXR46BEG,DU1H,DU2H,USEGHX46,HXBRK46,HXR46END];
HXCEL47=[HXR47BEG,DU1H,DU2H,USEGHX47,HXBRK47,HXR47END];%no phase shifter
HXCEL48=[HXR48BEG,DU1H,DU2H,DUSEGH48,HXBRK48,HXR48END];%empty
HXCEL49=[HXR49BEG,DU1H,DU2H,DUSEGH49,HXBRK49,HXR49END];%empty
HXCEL50=[HXR50BEG,DU1H,DU2H,DUSEGH50,HXBRK50,HXR50END];%empty
HXRCL=[HXCEL13,HXCEL14,HXCEL15,HXCEL16,HXCEL17,HXCEL18,HXCEL19,HXCEL20,HXCEL21,HXCEL22,HXCEL23,HXCEL24,HXCEL25,HXCEL26,HXCEL27,HXCEL28,HXCEL29,HXCEL30,HXCEL31,HXCEL32,HXCEL33,HXCEL34,HXCEL35,HXCEL36,HXCEL37,HXCEL38,HXCEL39,HXCEL40,HXCEL41,HXCEL42,HXCEL43,HXCEL44,HXCEL45,HXCEL46,HXCEL47,HXCEL48,HXCEL49,HXCEL50];
HXR=[DU0H,DU8H,HXRSTART,HXRCL,RWWAKE5H,HXRTERM,DUE1A,RFBHX51,DUE1E,ENDUNDH];
% ------------------------------------------------------------------------------
% HXR undulator exit section
% ------------------------------------------------------------------------------
TCX01={'tc' 'TCX01' 1.0/2 [XBANDF 0 0*TWOPI]}';%horizontal deflection
TCX02={'tc' 'TCX02' 1.0/2 [XBANDF 0 0*TWOPI]}';%horizontal deflection
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQUE1 =   0.178719376702 ;% 0.178908931125 Yuri (E=4.0, K=2.0)
KQUE2 =  -0.136231234699                  ;%Yuri (E=4.0, K=2.0)
QUE1={'qu' 'QUE1' LQD/2 [KQUE1 0]}';
QUE2={'qu' 'QUE2' LQD/2 [KQUE2 0]}';
DZHXTES =  0.749541186639E-6 ;%set MDLWALL at 685 m exactly to align with HXR XTES system
DUE2C={'dr' '' DUE2CB{3}+(LQR-LQD)/2 []}';%0.555
DUE3A={'dr' '' 0.375504+(LQP-LQD)/2+0.11496-0.063643 []}';
DUE3B={'dr' '' 1.2630495-0.11496+0.063643 []}';
DBKXDMPH={'dr' '' LBKXDMP []}';%placeholder for x-kicker in HXR dumpline
DPCVV={'dr' '' 0.397 []}';
DVVTCX={'dr' '' 0.32 []}';
DTCX12={'dr' '' 0.373/2 []}';
DTCXSP={'dr' '' 0.381 []}';
DUE4={'dr' '' 0.394 []}';%DUE4b[L] +(LQR-LQD)/2
DUE5A={'dr' '' 0.477799+(LQP-LQD)/2+0.012675-0.063653 []}';
DUE5B={'dr' '' 0.264-0.012675+0.063653 []}';
DUE5C={'dr' '' 0.2674 []}';
DUE5E={'dr' '' 0.252825-DUE5D{3}-DUE5F{3}-DZHXTES []}';
DDLWALL={'dr' '' 0.250825+DZHXTES []}';%length of dumpline thermal barrier wall
BPMUE1={'mo' 'BPMUE1' 0 []}';%RFBUE1 : MONI, TYPE="@2,CavityS-1"
BPMUE2={'mo' 'BPMUE2' 0 []}';%RFBUE2 : MONI, TYPE="@2,CavityS-1"
XCUE2={'mo' 'XCUE2' 0 []}';
XCD3={'mo' 'XCD3' 0 []}';
YCUE1={'mo' 'YCUE1' 0 []}';
YCD3={'mo' 'YCD3' 0 []}';
PCTCX={'dr' 'PCTCX' 0 []}';%XTCAV photon collimator (9 mm aperture)
PCPM0={'dr' 'PCPM0' LPCPM []}';
PH31={'mo' 'PH31' 0 []}';%post-undulator phase measurement RF cavity (existing LCLS device)
PH32={'mo' 'PH32' 0 []}';%post-undulator phase measurement RF cavity (existing LCLS device)
PH33={'mo' 'PH33' 0 []}';%post-undulator phase measurement RF cavity (high rate)
PH34={'mo' 'PH34' 0 []}';%post-undulator phase measurement RF cavity (high rate)
TRUE1={'dr' '' 0 []}';%Be foil inserter (THz) -- existing LCLS device
SPTCX={'mo' 'SPTCX' 0 []}';%XTCAV spoiler
BTMQUE={'mo' 'BTMQUE' 0 []}';%Burn-Through-Monitor
BTM0={'mo' 'BTM0' 0 []}';%Burn-Through-Monitor behind the PCPM0
UEBEG={'mo' 'UEBEG' 0 []}';
VV36={'mo' 'VV36' 0 []}';%treaty-point vacuum valve just downbeam of undulator
MIMUNDO={'mo' 'MIMUNDO' 0 []}';
VVTCX={'mo' 'VVTCX' 0 []}';%XTCAV vacuum valve
MTCX01={'mo' 'MTCX01' 0 []}';%entrance to TCX01 (for ELEGANT WATCH point)
MTCX={'mo' 'MTCX' 0 []}';%centerline between TCX01 and TCX02 (for matching)
MIMBCS3={'mo' 'MIMBCS3' 0 []}';
MDLWALL={'mo' 'MDLWALL' 0 []}';%front face of dumpline thermal barrier wall
UEEND={'mo' 'UEEND' 0 []}';
DLSTART={'mo' 'DLSTART' 0 []}';%start of dumpline
VV37={'mo' 'VV37' 0 []}';%vac. valve in dumpline
TCX01_FULL=[TCX01,TCX01];
TCX02_FULL=[TCX02,TCX02];
QUE1_FULL=[QUE1,QUE1];
QUE2_FULL=[QUE2,QUE2];
UNDEXIT=[BEGDMPH_1,UEBEG,DUE1D,VV36,DUE1B,MIMUNDO,DUE1C,DUE2A,YCUE1,DUE2B,PH31,DUE2D,PH32,DUE2D,PH33,DUE2D,PH34,DUE2E,XCUE2,DUE2C,QUE1_FULL,DUE3A,BPMUE1,DUE3B,TRUE1,DUE3C,DBKXDMPH,DUE3C,PCTCX,DPCVV,VVTCX,DVVTCX,MTCX01,TCX01_FULL,DTCX12,MTCX,DTCX12,TCX02_FULL,DTCXSP,SPTCX,DUE4,QUE2_FULL,DUE5A,BPMUE2,DUE5B,BTMQUE,DUE5C,PCPM0,DUE5F,BTM0,DUE5D,MIMBCS3,DUE5E,MDLWALL,DDLWALL,UEEND,DLSTART,DSB0A,YCD3,DSB0B,XCD3,DSB0C,VV37,DSB0D,DSB0E,ENDDMPH_1];
HXRUND=[HXR,UNDEXIT];

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc safety dump lines
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 22-JAN-2020, M. Woodley
%  * some device names, keywords, TYPEs, and Z-locations in SFTS_1 taken from
%    XTES_BG_SXR_1-13-2020.xlsx per P. Stephens
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
DXDCUB3={'dr' '' 0.878257 []}';
DXDCUB4={'dr' '' DXDCUB{3}-DXDCUB1{3}-DXDCUB2{3}-DXDCUB3{3} []}';
XDCBA={'dr' '' 0.312777 []}';%XDC chamber
XDCBB={'dr' '' 0.693 []}';%XDC chamber
XDCBC={'dr' '' 0.542 []}';%XDC chamber
XDCBC1={'dr' '' 0.0076773 []}';
XDCBC2={'dr' '' XDCBC{3}-XDCBC1{3} []}';
XDCBD={'dr' '' 0.255376 []}';%XDC chamber
DXDCDB={'dr' '' 7.266-DXDCUB{3}-XDCBA{3}-XDCBB{3}-XDCBC{3}-XDCBD{3} []}';
DXDCDB1={'dr' '' 0.262395 []}';
DXDCDB2={'dr' '' 0.380049 []}';%0.363747
DXDCDB3={'dr' '' 0.940451 []}';%0.966253
DXDCDB4={'dr' '' 1.18874 []}';%1.492023
DXDCDB5={'dr' '' 0.312783 []}';
DXDCDB6={'dr' '' DXDCDB{3}-DXDCDB1{3}-DXDCDB2{3}-DXDCDB3{3}-DXDCDB4{3}-DXDCDB5{3} []}';
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
TP_SXTES0={'mo' 'TP_SXTES0' 0 []}';%treaty point for SXR XTES system (SXTES0)
RTDSK0={'mo' 'RTDSK0' 0 []}';
RTDSK0_YAGXRAYB={'mo' 'RTDSK0_YAGXRAYB' 0 []}';%safety dump line X-ray screen (YAGXRAYB)
PC1K0_XTES={'mo' 'PC1K0_XTES' 0 []}';%PC1S
EM1K0_GMD={'mo' 'EM1K0_GMD' 0 []}';%GMD1S
IM1K0_XTES={'mo' 'IM1K0_XTES' 0 []}';%IM1S
MSL1S={'mo' 'MSL1S' 0 []}';
SFTDMPB={'mo' 'SFTDMPB' 0 []}';%front face of SXR safety dump (Z'=712-715 m per PRD)
VV38B={'mo' 'VV38B' 0 []}';%vac. valve in SXR safety dump line
RTDSK0_VGC_1={'mo' 'RTDSK0_VGC_1' 0 []}';%vac. valve in SXR safety dump line (VV1S)
RTDSK0_VRM_1={'mo' 'RTDSK0_VRM_1' 0 []}';
RTDSK0_GCC_1={'mo' 'RTDSK0_GCC_1' 0 []}';
RTDSK0_GPI_1={'mo' 'RTDSK0_GPI_1' 0 []}';
EM1K0_GMD_VGC_1={'mo' 'EM1K0_GMD_VGC_1' 0 []}';%vac. valve in SXR safety dump line (VV2S)
IM1K0_XTES_VRM_1={'mo' 'IM1K0_XTES_VRM_1' 0 []}';
IM1K0_XTES_GCC_1={'mo' 'IM1K0_XTES_GCC_1' 0 []}';
IM1K0_XTES_GPI_1={'mo' 'IM1K0_XTES_GPI_1' 0 []}';
MVV3S={'mo' 'MVV3S' 0 []}';%placeholder for vac. valve in SXR XTES line
BXPM1B_FULL=[BXPM1B1,BXPM1B2];
SFTDUMPB1=[BEGSFTS_1,DYDS,DS1S,DYD1,DSSA,DYD2,DSSB,DYD3,DSCSB1,VV38B,DSCSB2,PCPM1B,DPCBTM1,BTM1B,DXDCUB1,RTDSK0_VGC_1,DXDCUB2,TP_SXTES0,DXDCUB3,RTDSK0_VRM_1,RTDSK0_GCC_1,RTDSK0_GPI_1,DXDCUB4,XDCBA,XDCBB,XDCBC1,RTDSK0,XDCBC2,RTDSK0_YAGXRAYB,XDCBD,DXDCDB1,PC1K0_XTES,DXDCDB2,EM1K0_GMD_VGC_1,DXDCDB3,EM1K0_GMD,DXDCDB4,IM1K0_XTES_VRM_1,IM1K0_XTES_GCC_1,IM1K0_XTES_GPI_1,DXDCDB5,IM1K0_XTES,DXDCDB6,PCPM2B,BTM2B,DPM1B,ENDSFTS_1];
SFTDUMPB2=[BEGSFTS_2,BXPM1B_FULL,DPM2BA,DPCPM3B,DPCBTM3B,MBTM3B,DPM2BB,MSL1S,DPM3BA,MVV3S,DPM3BB,SFTDMPB,DSFTDMPB,BTMSFTB,ENDSFTS_2];
SFTDUMPB=[SFTDUMPB1,SFTDUMPB2];

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% SXR XTES
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 22-JAN-2020, M. Woodley
%  * from: XTES_BG_SXR_1-13-2020.xlsx per P. Stephens
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
A1Y =  -0.03662;
A2Y =  -0.101767726243 ;%calculated with atan2
A3Y =   0.016246118946 ;%fitted
A4X =   0.019693602;
A5X =   0.019693602;
A6X =  -0.024;
%MR1K1_BEND    : MULT, TYPE="MIRROR",        K0L=a1y, T0
%SP1K1_MONO    : MULT, TYPE="MONOCHROMATOR", K0L=a2y, T0
%MR3K1_GRATING : MULT, TYPE="GRATING",       K0L=a3y, T0
%MR1K3_TXI     : MULT, TYPE="MIRROR",        K0L=a4x
%MR2K3_TXI     : MULT, TYPE="MIRROR",        K0L=a5x
%MR1K4_SOMS    : MULT, TYPE="MIRROR",        K0L=a6x
MR1K1_BEND={'mo' 'MR1K1_BEND' 0 []}';
SP1K1_MONO={'mo' 'SP1K1_MONO' 0 []}';
MR3K1_GRATING={'mo' 'MR3K1_GRATING' 0 []}';
MR1K3_TXI={'mo' 'MR1K3_TXI' 0 []}';
MR2K3_TXI={'mo' 'MR2K3_TXI' 0 []}';
MR1K4_SOMS={'mo' 'MR1K4_SOMS' 0 []}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
% common line
DSXTES01={'dr' '' 0.472 []}';
DSXTES02={'dr' '' 1.5 []}';
DSXTES03={'dr' '' 2.903755-LPCPMW/2 []}';
DSXTES04={'dr' '' 0.4141213 []}';
DSXTES05={'dr' '' 0.0760569 []}';
DSXTES06={'dr' '' 0.253741 []}';
DSXTES07={'dr' '' 7.8123258 []}';
DSXTES08={'dr' '' 0.0762 []}';
DSXTES09={'dr' '' 1.549568 []}';
DSXTES10={'dr' '' 3.954232 []}';
DSXTES11={'dr' '' 2.34 []}';
DSXTES12={'dr' '' 3.1593754 []}';
DSXTES13={'dr' '' 1.10555 []}';
DSXTES14={'dr' '' 1.1211476 []}';
DSXTES15={'dr' '' 2.422663 []}';
DSXTES16={'dr' '' 0.1423749 []}';
DSXTES17={'dr' '' 0.1348125 []}';
DSXTES18={'dr' '' 0.4494214 []}';
DSXTES19={'dr' '' 0.6894122 []}';
DSXTES20={'dr' '' 0.125603 []}';
DSXTES21={'dr' '' 0.04953 []}';
DSXTES22={'dr' '' 0.2718348 []}';
DSXTES23={'dr' '' 0.3749014 []}';
DSXTES24={'dr' '' 0.078 []}';
DSXTES25={'dr' '' 0.2957019 []}';
DSXTES26={'dr' '' 0.477647 []}';
DSXTES27={'dr' '' 0.3994505 []}';
DSXTES28={'dr' '' 0.5545744 []}';
% "2.2" line
A12Y =  A1Y+A2Y;
A13Y =  A1Y+A2Y+A3Y;
DSXTES29={'dr' '' 0.6897237/cos(A1Y) []}';
DSXTES30={'dr' '' 0.0289889/cos(A1Y) []}';
DSXTES31={'dr' '' 3.5372036/cos(A1Y) []}';
DSXTES32={'dr' '' 0.3344515/cos(A1Y) []}';
DSXTES33={'dr' '' 1.2596323/cos(A1Y) []}';
DSXTES34={'dr' '' 0.138444/cos(A12Y) []}';
DSXTES35={'dr' '' 0.4793516/cos(A13Y) []}';
DSXTES36={'dr' '' 0.0411908/cos(A13Y) []}';
% TXI line
A45X =  A4X+A5X;
DSXTES37={'dr' '' 1.65 []}';
DSXTES38={'dr' '' 1.6/cos(A4X) []}';
DSXTES39={'dr' '' 0.6779536/cos(A45X) []}';
DSXTES40={'dr' '' 2.600075/cos(A45X) []}';
DSXTES41={'dr' '' 0.0359746/cos(A45X) []}';
DSXTES42={'dr' '' 0.1611878/cos(A45X) []}';
DSXTES43={'dr' '' 0.3068738/cos(A45X) []}';
DSXTES44={'dr' '' 0.5221997/cos(A45X) []}';
DSXTES45={'dr' '' 2.2088562/cos(A45X) []}';
DSXTES46={'dr' '' 0.4648793/cos(A45X) []}';
DSXTES47={'dr' '' 0.1269015/cos(A45X) []}';
DSXTES48={'dr' '' 0.0526591/cos(A45X) []}';
DSXTES49={'dr' '' 0.3978243/cos(A45X) []}';
DSXTES50={'dr' '' 0.1301076/cos(A45X) []}';
DSXTES51={'dr' '' 5.671144/cos(A45X) []}';
DSXTES52={'dr' '' 0.1243635/cos(A45X) []}';
DSXTES53={'dr' '' 0.0563443/cos(A45X) []}';
DSXTES54={'dr' '' 3.0113111/cos(A45X) []}';
DSXTES55={'dr' '' 1.1359052/cos(A45X) []}';
DSXTES56={'dr' '' 1.2134394/cos(A45X) []}';
DSXTES57={'dr' '' 0.1269015/cos(A45X) []}';
DSXTES58={'dr' '' 0.0526591/cos(A45X) []}';
% TMO line
DSXTES59={'dr' '' 3.9302483 []}';
DSXTES60={'dr' '' 2.7940192 []}';
DSXTES61={'dr' '' 1.1646045 []}';
DSXTES62={'dr' '' 1.8680321 []}';
DSXTES63={'dr' '' 1.0192086 []}';
DSXTES64={'dr' '' 1.1718873 []}';
DSXTES65={'dr' '' 0.9814383/cos(A6X) []}';
DSXTES66={'dr' '' 0.3792905/cos(A6X) []}';
DSXTES67={'dr' '' 0.0623195/cos(A6X) []}';
DSXTES68={'dr' '' 0.1385356/cos(A6X) []}';
DSXTES69={'dr' '' 0.1347981/cos(A6X) []}';
DSXTES70={'dr' '' 0.0831388/cos(A6X) []}';
DSXTES71={'dr' '' 0.5004792/cos(A6X) []}';
DSXTES72={'dr' '' 0.6694969/cos(A6X) []}';
DSXTES73={'dr' '' 1.2027371/cos(A6X) []}';
DSXTES74={'dr' '' 0.125603/cos(A6X) []}';
DSXTES75={'dr' '' 0.04953/cos(A6X) []}';
DSXTES76={'dr' '' 0.2996354/cos(A6X) []}';
DSXTES77={'dr' '' 0.4126311/cos(A6X) []}';
DSXTES78={'dr' '' 0.8949946/cos(A6X) []}';
DSXTES79={'dr' '' 0.1883719/cos(A6X) []}';
DSXTES80={'dr' '' 1.0320948/cos(A6X) []}';
DSXTES81={'dr' '' 0.4015629/cos(A6X) []}';
DSXTES82={'dr' '' 0.7313423/cos(A6X) []}';
DSXTES83={'dr' '' 0.460887/cos(A6X) []}';
DSXTES84={'dr' '' 0.4046217/cos(A6X) []}';
DSXTES85={'dr' '' 0.2274913/cos(A6X) []}';
DSXTES86={'dr' '' 0.2199633/cos(A6X) []}';
DSXTES87={'dr' '' 0.2770367/cos(A6X) []}';
DSXTES88={'dr' '' 0.3308656/cos(A6X) []}';
DSXTES89={'dr' '' 0.122407/cos(A6X) []}';
DSXTES90={'dr' '' 0.0526898/cos(A6X) []}';
DSXTES91={'dr' '' 0.2560376/cos(A6X) []}';
DSXTES92={'dr' '' 1.93/cos(A6X) []}';
% ==============================================================================
% instruments
% ------------------------------------------------------------------------------
% common line
MBXPM1B={'mo' 'MBXPM1B' 0 []}';
PCPM3B_PIP_1={'mo' 'PCPM3B_PIP_1' 0 []}';
PCPM3B_GFS_1={'mo' 'PCPM3B_GFS_1' 0 []}';
PCPM3B={'dr' 'PCPM3B' LPCPMW []}';
BTM3B={'mo' 'BTM3B' 0 []}';%Burn-Through-Monitor behind PCPM3b
SL1K0_POWER={'mo' 'SL1K0_POWER' 0 []}';
SL1K0_PWR_VRM_1={'mo' 'SL1K0_PWR_VRM_1' 0 []}';
SL1K0_PWR_GCC_1={'mo' 'SL1K0_PWR_GCC_1' 0 []}';
SL1K0_PWR_GPI_1={'mo' 'SL1K0_PWR_GPI_1' 0 []}';
AT1K0_GAS_VGC_1={'mo' 'AT1K0_GAS_VGC_1' 0 []}';
MSFTDMPB={'mo' 'MSFTDMPB' 0 []}';
MBTMSFTB={'mo' 'MBTMSFTB' 0 []}';
AT1K0_GAS={'mo' 'AT1K0_GAS' 0 []}';
TP_WALL1SE={'mo' 'TP_WALL1SE' 0 []}';
TP_WALL1SW={'mo' 'TP_WALL1SW' 0 []}';
EM2K0_XGMD_VGC_1={'mo' 'EM2K0_XGMD_VGC_1' 0 []}';
EM2K0_XGMD={'mo' 'EM2K0_XGMD' 0 []}';
EM2K0_XGMD_VGC_2={'mo' 'EM2K0_XGMD_VGC_2' 0 []}';
TV2K0_VGC_1={'mo' 'TV2K0_VGC_1' 0 []}';
TV2K0_VRM_1={'mo' 'TV2K0_VRM_1' 0 []}';
TV2K0_GCC_1={'mo' 'TV2K0_GCC_1' 0 []}';
TV2K0_GPI_1={'mo' 'TV2K0_GPI_1' 0 []}';
TV2K0_VRM_2={'mo' 'TV2K0_VRM_2' 0 []}';
TV2K0_GCC_2={'mo' 'TV2K0_GCC_2' 0 []}';
TV2K0_GPI_2={'mo' 'TV2K0_GPI_2' 0 []}';
TV2K0_VFS_1={'mo' 'TV2K0_VFS_1' 0 []}';
SP1K0={'dr' '' 0 []}';
PC2K0_XTES={'mo' 'PC2K0_XTES' 0 []}';
BT1K0_XTES={'mo' 'BT1K0_XTES' 0 []}';
BS1K0_XTES={'mo' 'BS1K0_XTES' 0 []}';
PF1K0_WFS={'mo' 'PF1K0_WFS' 0 []}';
SL2K0_POWER={'mo' 'SL2K0_POWER' 0 []}';
PA1K0_RGA_1={'mo' 'PA1K0_RGA_1' 0 []}';
PA1K0_VRM_1={'mo' 'PA1K0_VRM_1' 0 []}';
PA1K0_GCC_1={'mo' 'PA1K0_GCC_1' 0 []}';
PA1K0_GPI_1={'mo' 'PA1K0_GPI_1' 0 []}';
PA1K0_PIP_1={'mo' 'PA1K0_PIP_1' 0 []}';
IM2K0_XTES={'mo' 'IM2K0_XTES' 0 []}';
PA1K0={'mo' 'PA1K0' 0 []}';
MR1K1_VGC_1={'mo' 'MR1K1_VGC_1' 0 []}';
% "2.2" line
MR1K3_VGC_1={'mo' 'MR1K3_VGC_1' 0 []}';
ND1S={'mo' 'ND1S' 0 []}';
IM1K1_PPM={'mo' 'IM1K1_PPM' 0 []}';
SP1K1_MONO_VGC_1={'mo' 'SP1K1_MONO_VGC_1' 0 []}';
SP1K1_MONO_VGC_2={'mo' 'SP1K1_MONO_VGC_2' 0 []}';
TP_2_X={'mo' 'TP_2_X' 0 []}';
% TXI line
MR2K3_TXI_GBC_1={'mo' 'MR2K3_TXI_GBC_1' 0 []}';
BT2K0_PLEG_TXI={'mo' 'BT2K0_PLEG_TXI' 0 []}';
IM1K2_PPM_VGC_1={'mo' 'IM1K2_PPM_VGC_1' 0 []}';
TP_1_2SXR={'mo' 'TP_1_2SXR' 0 []}';
IM1K3_PPM_PGT_1={'mo' 'IM1K3_PPM_PGT_1' 0 []}';
IM1K3_PPM={'mo' 'IM1K3_PPM' 0 []}';
BT1K3_AIR={'mo' 'BT1K3_AIR' 0 []}';
PC1K3_L2SI_VRM_1={'mo' 'PC1K3_L2SI_VRM_1' 0 []}';
PC1K3_L2SI_GCC_1={'mo' 'PC1K3_L2SI_GCC_1' 0 []}';
PC1K3_L2SI_PIP_1={'mo' 'PC1K3_L2SI_PIP_1' 0 []}';
PC1K3_L2SI={'mo' 'PC1K3_L2SI' 0 []}';
BT2K3_XTES={'mo' 'BT2K3_XTES' 0 []}';
BS1K3_XTES={'mo' 'BS1K3_XTES' 0 []}';
PC1K3_L2SI_VRM_2={'mo' 'PC1K3_L2SI_VRM_2' 0 []}';
PC1K3_L2SI_GBC_1={'mo' 'PC1K3_L2SI_GBC_1' 0 []}';
PC1K3_L2SI_GCC_2={'mo' 'PC1K3_L2SI_GCC_2' 0 []}';
PC1K3_L2SI_PIP_2={'mo' 'PC1K3_L2SI_PIP_2' 0 []}';
PC1K3_L2SI_VGC_1={'mo' 'PC1K3_L2SI_VGC_1' 0 []}';
TV1K3_VRM_1={'mo' 'TV1K3_VRM_1' 0 []}';
TV1K3_GCC_1={'mo' 'TV1K3_GCC_1' 0 []}';
TV1K3_GPI_1={'mo' 'TV1K3_GPI_1' 0 []}';
TV1K3_PIP_1={'mo' 'TV1K3_PIP_1' 0 []}';
PC2K3_L2SI={'mo' 'PC2K3_L2SI' 0 []}';
BT3K3_L2SI={'mo' 'BT3K3_L2SI' 0 []}';
TV1K3_VGC_1={'mo' 'TV1K3_VGC_1' 0 []}';
ST1K3_PPS={'mo' 'ST1K3_PPS' 0 []}';
ST1K3_PPS_GBC_1={'mo' 'ST1K3_PPS_GBC_1' 0 []}';
PC3K3_L2SI={'mo' 'PC3K3_L2SI' 0 []}';
BT4K3_XTES={'mo' 'BT4K3_XTES' 0 []}';
BS2K3_XTES={'mo' 'BS2K3_XTES' 0 []}';
% TMO line
BT2K0_PLEG_TMO={'mo' 'BT2K0_PLEG_TMO' 0 []}';
TV3K0_VGC_1={'mo' 'TV3K0_VGC_1' 0 []}';
TV3K0_PGT_1={'mo' 'TV3K0_PGT_1' 0 []}';
TV3K0_VRM_1={'mo' 'TV3K0_VRM_1' 0 []}';
TV3K0_GCC_1={'mo' 'TV3K0_GCC_1' 0 []}';
TV3K0_GPI_1={'mo' 'TV3K0_GPI_1' 0 []}';
TV3K0_PIP_1={'mo' 'TV3K0_PIP_1' 0 []}';
MR1K4_VGC_1={'mo' 'MR1K4_VGC_1' 0 []}';
MR1K4_SOMS_GBC_1={'mo' 'MR1K4_SOMS_GBC_1' 0 []}';
PC1K4_SSA={'mo' 'PC1K4_SSA' 0 []}';
BT1K4_L2SI={'mo' 'BT1K4_L2SI' 0 []}';
TV1K4_VGC_1={'mo' 'TV1K4_VGC_1' 0 []}';
TV1K4_VFS_1={'mo' 'TV1K4_VFS_1' 0 []}';
TV1K4_VRM_1={'mo' 'TV1K4_VRM_1' 0 []}';
TV1K4_GCC_1={'mo' 'TV1K4_GCC_1' 0 []}';
TV1K4_GPI_1={'mo' 'TV1K4_GPI_1' 0 []}';
ND2S={'mo' 'ND2S' 0 []}';
AT1K4_SOLID={'dr' '' 0 []}';
TV1K4_VGC_2={'mo' 'TV1K4_VGC_2' 0 []}';
PC2K4_XTES={'mo' 'PC2K4_XTES' 0 []}';
BT2K4_XTES={'mo' 'BT2K4_XTES' 0 []}';
BS1K4_XTES={'mo' 'BS1K4_XTES' 0 []}';
IM1K4_XTES={'mo' 'IM1K4_XTES' 0 []}';
ST1K4_TEST={'mo' 'ST1K4_TEST' 0 []}';
SP1K4={'dr' '' 0 []}';
LUSI={'mo' 'LUSI' 0 []}';
PC3K4_XTES={'mo' 'PC3K4_XTES' 0 []}';
ST2K4_BCS={'mo' 'ST2K4_BCS' 0 []}';
ST3K4_PPS={'mo' 'ST3K4_PPS' 0 []}';
ST3K4_PPS_GBC_1={'mo' 'ST3K4_PPS_GBC_1' 0 []}';
ST3K4_PPS_VGC_1={'mo' 'ST3K4_PPS_VGC_1' 0 []}';
AL1K4_L2SI={'mo' 'AL1K4_L2SI' 0 []}';
SL1K4_SCATTER={'mo' 'SL1K4_SCATTER' 0 []}';
IM2K4_PPM={'mo' 'IM2K4_PPM' 0 []}';
IM2K4_XTES_VRM_1={'mo' 'IM2K4_XTES_VRM_1' 0 []}';
PC4K4_XTES_GCC_1={'mo' 'PC4K4_XTES_GCC_1' 0 []}';
PC4K4_XTES_GPI_1={'mo' 'PC4K4_XTES_GPI_1' 0 []}';
PC4K4_XTES_PIP_1={'mo' 'PC4K4_XTES_PIP_1' 0 []}';
PC4K4_XTES={'mo' 'PC4K4_XTES' 0 []}';
BT3K4_XTES={'mo' 'BT3K4_XTES' 0 []}';
BS2K4_XTES={'mo' 'BS2K4_XTES' 0 []}';
TP_WALL2E={'mo' 'TP_WALL2E' 0 []}';
TP_WALL2W={'mo' 'TP_WALL2W' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
% common line
SXTES1=[BEGSXTES_1,DSXTES01,MBXPM1B,DSXTES02,PCPM3B_PIP_1,PCPM3B_GFS_1,DSXTES03,PCPM3B,BTM3B,DSXTES04,SL1K0_POWER,DSXTES05,SL1K0_PWR_VRM_1,SL1K0_PWR_GCC_1,SL1K0_PWR_GPI_1,DSXTES06,AT1K0_GAS_VGC_1,DSXTES07,MSFTDMPB,DSXTES08,MBTMSFTB,DSXTES09,AT1K0_GAS,DSXTES10,TP_WALL1SE,DSXTES11,TP_WALL1SW,DSXTES12,EM2K0_XGMD_VGC_1,DSXTES13,EM2K0_XGMD,DSXTES14,EM2K0_XGMD_VGC_2,DSXTES15,TV2K0_VGC_1,TV2K0_VRM_1,TV2K0_GCC_1,TV2K0_GPI_1,DSXTES16,TV2K0_VRM_2,TV2K0_GCC_2,TV2K0_GPI_2,DSXTES17,TV2K0_VFS_1,DSXTES18,SP1K0,DSXTES19,PC2K0_XTES,DSXTES20,BT1K0_XTES,DSXTES21,BS1K0_XTES,DSXTES22,PF1K0_WFS,DSXTES23,SL2K0_POWER,DSXTES24,PA1K0_RGA_1,PA1K0_VRM_1,PA1K0_GCC_1,PA1K0_GPI_1,PA1K0_PIP_1,DSXTES25,IM2K0_XTES,DSXTES26,PA1K0,DSXTES27,MR1K1_VGC_1,DSXTES28,ENDSXTES_1];
% "2.2" line
SXTES2=[BEGSXTES_2,MR1K1_BEND,DSXTES29,MR1K3_VGC_1,DSXTES30,ND1S,DSXTES31,IM1K1_PPM,DSXTES32,SP1K1_MONO_VGC_1,DSXTES33,SP1K1_MONO,DSXTES34,MR3K1_GRATING,DSXTES35,SP1K1_MONO_VGC_2,DSXTES36,TP_2_X,ENDSXTES_2];
% TXI line
SXTES3=[BEGSXTES_3,DSXTES37,MR1K3_TXI,DSXTES38,MR2K3_TXI,MR2K3_TXI_GBC_1,DSXTES39,BT2K0_PLEG_TXI,DSXTES40,IM1K2_PPM_VGC_1,DSXTES41,TP_1_2SXR,DSXTES42,IM1K3_PPM_PGT_1,DSXTES43,IM1K3_PPM,DSXTES44,BT1K3_AIR,DSXTES45,PC1K3_L2SI_VRM_1,PC1K3_L2SI_GCC_1,PC1K3_L2SI_PIP_1,DSXTES46,PC1K3_L2SI,DSXTES47,BT2K3_XTES,DSXTES48,BS1K3_XTES,DSXTES49,PC1K3_L2SI_VRM_2,PC1K3_L2SI_GBC_1,PC1K3_L2SI_GCC_2,PC1K3_L2SI_PIP_2,DSXTES50,PC1K3_L2SI_VGC_1,DSXTES51,TV1K3_VRM_1,TV1K3_GCC_1,TV1K3_GPI_1,TV1K3_PIP_1,DSXTES52,PC2K3_L2SI,DSXTES53,BT3K3_L2SI,DSXTES54,TV1K3_VGC_1,DSXTES55,ST1K3_PPS,ST1K3_PPS_GBC_1,DSXTES56,PC3K3_L2SI,DSXTES57,BT4K3_XTES,DSXTES58,BS2K3_XTES,ENDSXTES_3];
% TMO line
SXTES4=[BEGSXTES_4,DSXTES59,BT2K0_PLEG_TMO,DSXTES60,TV3K0_VGC_1,DSXTES61,TV3K0_PGT_1,DSXTES62,TV3K0_VRM_1,TV3K0_GCC_1,TV3K0_GPI_1,TV3K0_PIP_1,DSXTES63,MR1K4_VGC_1,DSXTES64,MR1K4_SOMS,MR1K4_SOMS_GBC_1,DSXTES65,PC1K4_SSA,DSXTES66,BT1K4_L2SI,DSXTES67,TV1K4_VGC_1,DSXTES68,TV1K4_VFS_1,DSXTES69,TV1K4_VRM_1,TV1K4_GCC_1,TV1K4_GPI_1,DSXTES70,ND2S,DSXTES71,AT1K4_SOLID,DSXTES72,TV1K4_VGC_2,DSXTES73,PC2K4_XTES,DSXTES74,BT2K4_XTES,DSXTES75,BS1K4_XTES,DSXTES76,IM1K4_XTES,DSXTES77,ST1K4_TEST,DSXTES78,SP1K4,DSXTES79,LUSI,DSXTES80,PC3K4_XTES,DSXTES81,ST2K4_BCS,DSXTES82,ST3K4_PPS,ST3K4_PPS_GBC_1,DSXTES83,ST3K4_PPS_VGC_1,DSXTES84,AL1K4_L2SI,DSXTES85,SL1K4_SCATTER,DSXTES86,IM2K4_PPM,DSXTES87,IM2K4_XTES_VRM_1,PC4K4_XTES_GCC_1,PC4K4_XTES_GPI_1,PC4K4_XTES_PIP_1,DSXTES88,PC4K4_XTES,DSXTES89,BT3K4_XTES,DSXTES90,BS2K4_XTES,DSXTES91,TP_WALL2E,DSXTES92,TP_WALL2W,ENDSXTES_4];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-06NOV2025s ***
% LCLS2sc DASEL
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 25-JUL-2025, M. Woodley
%  * swap locations of XCDAS19 and YCDAS19 per A. Ibrahimov
% 12-JUL-2025, M. Woodley
%  * add wire scanner / Beam Halo Monitor (WSDAS14,WSDAS14_BHM) per
%    N. Balakrishnan, A. Fisher, and A. Ibrahimov
% ------------------------------------------------------------------------------
% 14-MAR-2025, M. Woodley
%  * split DASEL area into two areas: SPA and SLTA; SPA area ends at BSY wooden
%    door; SLTA area ends at entrance to BRAM1
% ------------------------------------------------------------------------------
% 27-MAR-2024, M. Woodley
%  * change RCDAS11 to XCDAS11; move 0.118 m d/s; remove R0DAS11P and R0DAS11M
%  * add YCDAS11 0.397 m d/s of XCDAS11
%  * change RCDAS19 to XCDAS19; remove RODAS19P and RODAS19M
% ------------------------------------------------------------------------------
% 07-JUN-2023, M. Woodley
%  * tweak LDDAS14ac/LDDAS17a to locate PRDAS14/PRDAS17 per A. Ibrahimov
%  * include Yuri's changes from FEB/MAR 2022
% ------------------------------------------------------------------------------
% 29-MAR-2022, Y. Nosochkov
%  * rematch quadrupoles with the QDAS17 constrained to the same strength
%    as in QDAS14-16
% 04-FEB-2022, Y. Nosochkov
%  * rematch S30XL and A-line quadrupoles in order to fit BSC within the
%    existing magnet aperture downstream of S30XL
%  * move PRDAS14 to location u/s of QDAS14 and PRDAS17 closer
%    to QDAS16 for better phase advance between S30XL profile monitors
%    and BPMs (PRDAS14 location is adjusted by L. Borzenets)
% ------------------------------------------------------------------------------
% 10-APR-2020, M. Woodley
%  * relocate PRDAS14 and PRDAS17 per A. Ibrahimov
% ------------------------------------------------------------------------------
% 26-MAR-2020, M. Woodley
%  * DASEL is being funded off-project ... undefer everything
% 31-JAN-2020, Y. Nosochkov
%  * add vertical collimator (jaw or shielding plate) in front of BLRDAS to
%    prevent errant electrons entering the S30XL septum aperture
%    when S30XL and SXR kickers are off
%  * move PRDAS12 to 1.5 m d/s of QDAS11
%  * add dump u/s of QDAS12 for S30XL stage-A (reuse PEP-II stopper per Alev)
%  * rename DUMPS30XL to DUMPDAS for similar naming with other DASEL elements
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
LBRDAS2 =  LBSP*ABRDAS2/(2*sin(ABRDAS2/2)) ;%BRDAS2 path length (m)
BRDAS2A={'be' 'BRDAS2' LBRDAS2/2 [ABRDAS2/2 GBSP/2 ABRDAS2/2 0 0.5 0 TBRDAS2]}';
BRDAS2B={'be' 'BRDAS2' LBRDAS2/2 [ABRDAS2/2 GBSP/2 0 ABRDAS2/2 0 0.5 TBRDAS2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKRDAS1={'be' 'BKRDAS' LBKRDAS1 [ABKRDAS1 GBKRDAS/2 0 ABKRDAS1 0.5 0.5 PI/2+TBKRDAS]}';
BKRDAS2={'be' 'BKRDAS' LBKRDAS2 [ABKRDAS2 GBKRDAS/2 -ABKRDAS1 ABKRDAS12 0.5 0.5 PI/2+TBKRDAS]}';
BKRDAS3={'be' 'BKRDAS3' LBKRDAS3 [ABKRDAS3 GBKRDAS/2 -ABKRDAS12 ABKRDAS13 0.5 0.5 PI/2+TBKRDAS]}';
BKRDAS4={'be' 'BKRDAS4' LBKRDAS4 [ABKRDAS4 GBKRDAS/2 -ABKRDAS13 ABKRDAS14 0.5 0.5 PI/2+TBKRDAS]}';
BKRDAS5={'be' 'BKRDAS5' LBKRDAS5 [ABKRDAS5 GBKRDAS/2 -ABKRDAS14 ABKRDAS15 0.5 0.5 PI/2+TBKRDAS]}';
BKRDAS6={'be' 'BKRDAS6' LBKRDAS6 [ABKRDAS6 GBKRDAS/2 -ABKRDAS15 ABKRDAS 0.5 0.5 PI/2+TBKRDAS]}';
BLRDAS={'be' 'BLRDAS' LBLRDAS [ABLRDAS GBLRDAS/2 0 ABLRDAS 0.5 0.5 TBKRDAS]}';
BRDAS1={'be' 'BRDAS' LBRDAS1 [ABRDAS1 GBSP/2 ABRDAS1/2 ABRDAS1/2 0.5 0.5 TBRDAS1]}';
BRDAS2={'be' 'BRDAS' LBRDAS2 [ABRDAS2 GBSP/2 ABRDAS2/2 ABRDAS2/2 0.5 0.5 TBRDAS2]}';
% quads
KQDAS1 =  -0.459243934125;
KQDAS2 =   0.458012606781;
KQDAS11 =  -0.259299027489;
KQDAS12 =   0.320954266045;
KQDAS13 =  -0.671883770242;
KQDAS14 =   0.557491671133;
KQDAS18 =   0.443755133992;
KQDAS19 =  -0.325825809844;
KQDAS15 =  -KQDAS14;
KQDAS16 =   KQDAS14;
KQDAS17 =  -KQDAS14;
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
LPCBLRDAS =  0.0 ;%thickness of PCBLRDAS -- to be determined 
ZDDASBK =  0.3         ;%Z-space between consecutive kickers
ZDDASBLX =  18.75+3.685 ;%Z-space between the last kicker and the septum
ZDDASBLXA =  5.145       ;%set for y=5mm at BPM
ZDDASBLXB =  ZDDASBLX-ZDDASBLXA;
ZDDASBLXB2 =  0.0         ;%distance from PCBLRDAS to BLRDAS to be determined 
ZDDASBLXB1 =  ZDDASBLXB-ZDDASBLXB2-LPCBLRDAS;
LDDASBK1 =  ZDDASBK   /cos(ABKRDAS1);
LDDASBK2 =  ZDDASBK   /cos(ABKRDAS12);
LDDASBK3 =  ZDDASBK   /cos(ABKRDAS13);
LDDASBK4 =  ZDDASBK   /cos(ABKRDAS14);
LDDASBK5 =  ZDDASBK   /cos(ABKRDAS15);
LDDASBLXA =  ZDDASBLXA /cos(ABKRDAS);
LDDASBLXB =  ZDDASBLXB /cos(ABKRDAS);
LDDASBLXB1 =  ZDDASBLXB1/cos(ABKRDAS);
LDDASBLXB2 =  ZDDASBLXB2/cos(ABKRDAS);
DDASBK1={'dr' '' LDDASBK1 []}';
DDASBK2={'dr' '' LDDASBK2 []}';
DDASBK3H={'dr' '' LDDASBK3/2 []}';
DDASBK4={'dr' '' LDDASBK4 []}';
DDASBK5={'dr' '' LDDASBK5 []}';
DDASBLXA={'dr' '' LDDASBLXA []}';
DDASBLXB={'dr' '' LDDASBLXB []}';
DDASBLXB1={'dr' '' LDDASBLXB1 []}';
DDASBLXB2={'dr' '' LDDASBLXB2 []}';
LDUMPDAS =  0.2032 ;%dump length = 8" = slug length of PEP2 inj. stoppper
LDDASQQ =  0.1357;
LDDAS1 =  23.2085-0.761426-0.000133;
LDDAS2A =  0.5;
LDDAS2B =  0.5+0.761426-0.025296+0.000133-0.000004;
LDDAS3 =  0.5+0.025296+0.000004;
DLDDAS4 =  0.0;
LDDAS4 =  1.9+DLDDAS4;
DLDDAS5 =  0.765561526879E-2;
LDDAS5 =  56.315-(LBLSP+LBSP)/2-4*LQM-2*LDDASQQ -LDDAS1-LDDAS2A-LDDAS2B-LDDAS3-LDDAS4+DLDDAS5;
LDDAS5B =  12.05*0.0254 ;%=0.30607 per C. Clarke
LDDAS5C =  1.0;
LDDAS5A =  LDDAS5-LDDAS5B-LDDAS5C;
%  * tweak LDDAS14ac/LDDAS17a to locate PRDAS14/PRDAS17 per A. Ibrahimov
DLDDAS11 =  0.0;
LDDAS11 =  5.5-(LBSP+LQM)/2+DLDDAS11-0.7;
LDDAS11A =  0.5+0.300006+0.000003+0.118;
LDDAS11B =  0.397;
LDDAS11C =  LDDAS11-LDDAS11A-LDDAS11B;
DLDDAS12 =  0.0;
LDDAS12 =  14.1+DLDDAS12+0.7;
LDDAS12A =  1.5;
LDDAS12B =  9.877925-LDDAS12A-LDUMPDAS/2;
LDDAS12C =  LDDAS12-LDDAS12A-LDDAS12B-LDUMPDAS;
LDDAS13 =  18.128190337721+0.5;
%LDDAS13a := 2.97
%LDDAS13b := LDDAS13-LDDAS13a
LDDAS14 =  18.128190337721-0.5+0.79997;
LDDAS14B =  0.5;
LDDAS14A =  LDDAS14-LDDAS14B;
LDDAS14AC =  8.0+2.982395+0.0007 ;%mdw adjustment
LDDAS14AA =  14.473260664942-0.5-LDDAS14AC ;%set Z=3050.512000 m at WOODDOOR
LDDAS14AB =  LDDAS14A-LDDAS14AA-LDDAS14AC;
LDDAS17 =  18.128190337721-0.79997;
LDDAS17A =  0.5-0.000121 ;%mdw adjustment
LDDAS17C =  0.5;
LDDAS17B =  LDDAS17-LDDAS17A-LDDAS17C;
LDDAS18 =  15.540177251451;
DLDDAS19 =  0.0;
LDDAS19 =  9.24017725092-LDDASQQ-LQM+DLDDAS19;
DLDDAS20 =  0.0;
LDDAS20 =  22.55-(LBSP+LQM)/2+DLDDAS20;
LDDAS20A =  0.5-0.05163;
LDDAS20B =  LDDAS20-LDDAS20A;
DLDDAS =  0.0;
LDDAS =  (158.566506190974298-10*LQM-LBSP-LDDASQQ-LDDAS11-LDDAS12 -LDDAS13-LDDAS14-LDDAS17-LDDAS18-LDDAS19-LDDAS20)/2+DLDDAS;
LDDAS15 =  LDDAS;
LDDAS16 =  LDDAS;
LDDAS21A =  0.5;
LDDAS21B =  0.434930223041  ;%0.397
LDDAS21C =  19.394243502993 ;%19.829173726034-0.397
LDDAS22 =  0.5;
LDDAS23 =  0.5;
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
DDAS11C={'dr' '' LDDAS11C []}';
DDAS12A={'dr' '' LDDAS12A []}';
DDAS12B={'dr' '' LDDAS12B []}';
DDAS12C={'dr' '' LDDAS12C []}';
DDAS13={'dr' '' LDDAS13 []}';
DDAS14A={'dr' '' LDDAS14A []}';
DDAS14AA={'dr' '' LDDAS14AA []}';
DDAS14AB={'dr' '' LDDAS14AB []}';
DDAS14AC={'dr' '' LDDAS14AC []}';
DDAS14AC1={'dr' '' 7.132062 []}';
DDAS14AC2={'dr' '' DDAS14AC{3}-DDAS14AC1{3} []}';
DDAS14B={'dr' '' LDDAS14B []}';
DDAS15={'dr' '' LDDAS15 []}';
DDAS16={'dr' '' LDDAS16 []}';
DDAS17A={'dr' '' LDDAS17A []}';
DDAS17B={'dr' '' LDDAS17B []}';
DDAS17C={'dr' '' LDDAS17C []}';
DDAS18={'dr' '' LDDAS18 []}';
DDAS19={'dr' '' LDDAS19 []}';
DDAS20A={'dr' '' LDDAS20A []}';
DDAS20B={'dr' '' LDDAS20B []}';
DDAS21A={'dr' '' LDDAS21A []}';
DDAS21B={'dr' '' LDDAS21B []}';
DDAS21C={'dr' '' LDDAS21C []}';
DDAS22={'dr' '' LDDAS22 []}';
DDAS23={'dr' '' LDDAS23 []}';
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
% Notes: trims on all bends are used as correctors as well
XCDAS1={'mo' 'XCDAS1' 0 []}';
XCDAS11={'mo' 'XCDAS11' 0 []}';
XCDAS14={'mo' 'XCDAS14' 0 []}';
XCDAS19={'mo' 'XCDAS19' 0 []}';
YCDAS1={'mo' 'YCDAS1' 0 []}';
YCDAS11={'mo' 'YCDAS11' 0 []}';
YCDAS17={'mo' 'YCDAS17' 0 []}';
YCDAS19={'mo' 'YCDAS19' 0 []}';
% profile monitors
PRDAS12={'mo' 'PRDAS12' 0 []}';%two YAG crystals 50 um thick and 1 mm thick)
PRDAS14={'mo' 'PRDAS14' 0 []}';
PRDAS17={'mo' 'PRDAS17' 0 []}';
PRBRAM1={'mo' 'PRBRAM1' 0 []}';%profile monitor, type to be determined
TGTBRAM1={'mo' 'TGTBRAM1' 0 []}';%secondary production Cu target
% ACMs
IMDAS1={'mo' 'IMDAS1' 0 []}';
IMDAS2={'mo' 'IMDAS2' 0 []}';
% combination wire/BHM
WSDAS14={'mo' 'WSDAS14' 0 []}';
WSDAS14_BHM={'mo' 'WSDAS14_BHM' 0 []}';%Beam Halo Monitor
% BSY wooden door
WOODDOOR_SPA={'mo' 'WOODDOOR_SPA' 0 []}';
% collimator in front of BLRDAS septum
% * this collimator should be attached to or be very close to the entrance
%   of the septum aperture with the non-zero field
% * the collimator length (thickness) is to be determined 
% * it protects against large amplitude errant electrons which may enter
%   the septum field aperture through turned off SXR and S30XL kickers
% * the collimator may look like a shielding plate or a jaw covering
%   the very bottom of the field aperture
% * only the bottom jaw is needed
% * it should not interfere with the no-field aperture
% * the collimator X,Y sizes are relative to the beam center in the septum
%   field aperture
% * the vertical size is determined by maximum Y-coordinate of errant electrons
%   at the septum entrance (=9.487mm measured from unkicked trajectory)
% * horizontal size is sufficient for the expected range of the
%   electron horizontal angles; a larger horizontal size is ok
PCBLRDAS={'dr' 'PCBLRDAS' LPCBLRDAS/cos(ABKRDAS) []}';
% stage-A dump (reused PEP2 inj. stopper with 8" slug length per Alev)
DUMPDAS={'mo' 'DUMPDAS' LDUMPDAS/2 []}';%half-dump
%DUMPDAS : MONI, TYPE="400W-dump", L=LDUMPDAS/2 half-dump
% ------------------------------------------------------------------------------
% beamlines
BKRDAS1_FULL=[BKRDAS1A,BKRDAS1B];
BKRDAS2_FULL=[BKRDAS2A,BKRDAS2B];
BKRDAS3_FULL=[BKRDAS3A,BKRDAS3B];
BKRDAS4_FULL=[BKRDAS4A,BKRDAS4B];
BKRDAS5_FULL=[BKRDAS5A,BKRDAS5B];
BKRDAS6_FULL=[BKRDAS6A,BKRDAS6B];
BLRDAS_FULL=[BLRDASA,BLRDASB];
BRDAS1_FULL=[BRDAS1A,BRDAS1B];
BRDAS2_FULL=[BRDAS2A,BRDAS2B];
QDAS1B_FULL=[QDAS1B,QDAS1B];
QDAS1A_FULL=[QDAS1A,QDAS1A];
QDAS2A_FULL=[QDAS2A,QDAS2A];
QDAS2B_FULL=[QDAS2B,QDAS2B];
QDAS11_FULL=[QDAS11,QDAS11];
QDAS12_FULL=[QDAS12,QDAS12];
QDAS13_FULL=[QDAS13,QDAS13];
QDAS14_FULL=[QDAS14,QDAS14];
QDAS15_FULL=[QDAS15,QDAS15];
QDAS16_FULL=[QDAS16,QDAS16];
QDAS17_FULL=[QDAS17,QDAS17];
QDAS18A_FULL=[QDAS18A,QDAS18A];
QDAS18B_FULL=[QDAS18B,QDAS18B];
QDAS19_FULL=[QDAS19,QDAS19];
WSDAS14_FULL=[WSDAS14,WSDAS14_BHM];
DUMPDAS_FULL=[DUMPDAS,DUMPDAS];
% stage-A and stage-B with dump in sector-30
SPA=[BEGSPA,BKRDAS1_FULL,DDASBK1 ,BKRDAS2_FULL,DDASBK2 ,BKRDAS3_FULL,DDASBK3H,DDASBK3H,BKRDAS4_FULL,DDASBK4 ,BKRDAS5_FULL,DDASBK5 ,BKRDAS6_FULL,DDASBLXA,BPMDAS  ,DDASBLXB1,PCBLRDAS,DDASBLXB2,BLRDAS_FULL ,RODAS1  ,DDAS1   ,XCDAS1  ,DDAS2A  ,YCDAS1  ,DDAS2B  ,BPMDAS1 ,DDAS3   ,QDAS1B_FULL,DDASQQ  ,QDAS1A_FULL,DDAS4   ,QDAS2A_FULL,DDASQQ  ,QDAS2B_FULL,DDAS5A  ,IMDAS1  ,DDAS5B  ,IMDAS2 ,DDAS5C  ,BRDAS1_FULL,RODAS2  ,DDAS11A ,XCDAS11 ,DDAS11B,YCDAS11 ,DDAS11C,QDAS11_FULL,DDAS12A ,PRDAS12 ,DDAS12B ,DUMPDAS_FULL    ,DDAS12C,QDAS12_FULL,DDAS13  ,QDAS13_FULL,DDAS14AA,PRDAS14,DDAS14AC1,WSDAS14_FULL,DDAS14AC2,WOODDOOR_SPA,ENDSPA];
SLTA=[BEGSLTA  ,DDAS14AB,XCDAS14,DDAS14B,QDAS14_FULL ,DDAS15 ,QDAS15_FULL ,DDAS16 ,QDAS16_FULL ,DDAS17A,PRDAS17 ,DDAS17B,YCDAS17,DDAS17C,QDAS17_FULL ,DDAS18 ,QDAS18A_FULL,DDASQQ ,QDAS18B_FULL,DDAS19 ,QDAS19_FULL ,DDAS20A,BPMDAS19,DDAS20B,RODAS3,BRDAS2_FULL ,DDAS21A,YCDAS19,DDAS21B,XCDAS19,DDAS21C,PRBRAM1,DDAS22,TGTBRAM1,DDAS23,ENDSLTA];
% ------------------------------------------------------------------------------

LCLS2SCI=[BEAM0,DCM4B,QCM01_FULL,DCM5,CM01END,DCMCM1,HOMCM01,DCAP0DA,ASTRA,DCAP0DB,FC1,DMSC0DA,BLF1,DMSC0DB,VGL0BD,DMSC0DC,VPL0BD,DMSC0DD,MSC0D,VVL0BD,ENDL0B];
LCLS2SCC=[HTR,COL0,L1,BC1,COL1,L2,BC2,EMIT2,L3,EXT,DLBM];
% FDN definitions
% *** OPTICS=AD_ACCEL-06NOV2025s ***
% SC_SXR  : BEGGUNB   /ENDDMPS_2
% SC_SFTS : BEGSFTS_1 /ENDSFTS_2
% SC_S2_X : BEGSXTES_1/ENDSXTES_2
% SC_STXI : BEGSXTES_3/ENDSXTES_3
% SC_STMO : BEGSXTES_4/ENDSXTES_4
% SC_HXR  : BEGSPH    /ENDSLTH
% SC_BSYD : BEGSPD_2  /ENDSLTD
% SC_DIAG0: BEGDIAG0  /ENDDIAG0
% SC_DASEL: BEGSPA    /ENDESA



























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































% new BSY area definitions
% *** OPTICS=AD_ACCEL-06NOV2025s ***
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 08-APR-2024, M. Woodley
%  * remove decommissioned LINEs: BSYA, BSYLCLS2scA, and LCLS2scA
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
SPS=[BEGSPS,SPRDKSB,SPRDSB,FODOLB,ENDSPS];
%SPS : LINE=(BEGSPS,SPRDksbDC,SPRDsb,FODOLb,ENDSPS) DC SXR spreader
DBRCUS1A={'dr' '' BRCUS1A{3} []}';
DBRCUS1B={'dr' '' BRCUS1B{3} []}';
SLTS=[BEGSLTS,FODOLC,BYPM1,DBRCUS1A,DBRCUS1B,MRGCUSXR,ENDSLTS];
BSYS=[BEGBSYS,BYPM2,MUWALLB,DWALLA,DUMPBSYS,DWALLB,BSYENDB,RWWAKE3S,ENDBSYS];
% ------------------------------------------------------------------------------
SPH=[BEGSPH,SPRDKH,SPRDHA,ENDSPH];
%SPH : LINE=(BEGSPH,SPRDkhDC,SPRDha,ENDSPH) DC HXR spreader
SLTH=[BEGSLTH,SPRDHB,ENDSLTH];
% ------------------------------------------------------------------------------
LTUS=[DBLDL21,LTUSC,RWWAKE4S,ENDLTUS,BEGUNDS,PREUNDS];
LTUH=[LTU];
% from SC linac (start at spreader)
BSYLCLS2SCS=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,DUMPLINEB];
BSYLCLS2SCSS=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB];
BSYLCLS2SCH=[SPH,SLTH,BSYH,LTUH,HXRUND,DUMPLINE];
BSYLCLS2SCHS=[SPH,SLTH,BSYH,LTUH,HXRUND,SFTDUMP];
BSYLCLS2SCD=[SPD1,SPD2,SPD3,SLTD];
BSYLCLS2SCDA=[SPD1,SPD2,SPA,SLTA,BSYA,ESA];
BSYLCLS2SCS2_X=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB1,SXTES1,SXTES2];
BSYLCLS2SCSTXI=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB1,SXTES1,SXTES3];
BSYLCLS2SCSTMO=[SPD1,SPS,SLTS,BSYS,LTUS,SXRUND,SFTDUMPB1,SXTES1,SXTES4];
% from SC linac (start at end of dogleg)
LCLS2SCS=[FODOLA,BSYLCLS2SCS];
LCLS2SCSS=[FODOLA,BSYLCLS2SCSS];
LCLS2SCH=[FODOLA,BSYLCLS2SCH];
LCLS2SCHS=[FODOLA,BSYLCLS2SCHS];
LCLS2SCD=[FODOLA,BSYLCLS2SCD];
LCLS2SCDA=[FODOLA,BSYLCLS2SCDA];
LCLS2SCS2_X=[FODOLA,BSYLCLS2SCS2_X];
LCLS2SCSTXI=[FODOLA,BSYLCLS2SCSTXI];
LCLS2SCSTMO=[FODOLA,BSYLCLS2SCSTMO];
% ------------------------------------------------------------------------------

% beam path definitions
%SC_DIAG0 : superconducting linac to DIAG0
%SC_HXR   : superconducting linac to e- HXR dump
%SC_SXR   : superconducting linac to e- SXR dump
%SC_SFTS  : superconducting linac to e- SXR safety dump
%SC_S2_X  : superconducting linac to SXR XTES "2.X" line
%SC_STXI  : superconducting linac to SXR XTES TXI line
%SC_STMO  : superconducting linac to SXR XTES TMO line
%SC_BSYD  : superconducting linac to BSY dump
%SC_DASEL : superconducting linac to End Station A (DASEL)
SC_DIAG0=[GUN,L0,HTR,DIAG0];
SC_HXR=[GUN,L0,LCLS2SCC,LCLS2SCH];
SC_SXR=[GUN,L0,LCLS2SCC,LCLS2SCS];
SC_SFTS=[GUN,L0,LCLS2SCC,LCLS2SCSS];
SC_S2_X=[GUN,L0,LCLS2SCC,LCLS2SCS2_X];
SC_STXI=[GUN,L0,LCLS2SCC,LCLS2SCSTXI];
SC_STMO=[GUN,L0,LCLS2SCC,LCLS2SCSTMO];
SC_BSYD=[GUN,L0,LCLS2SCC,LCLS2SCD];
SC_DASEL=[GUN,L0,LCLS2SCC,LCLS2SCDA];
% for Twiss starting at BEAM0
SC_DIAG0I=[LCLS2SCI,HTR,DIAG0];
SC_HXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCH];
SC_SXRI=[LCLS2SCI,LCLS2SCC,LCLS2SCS];
SC_SFTSI=[LCLS2SCI,LCLS2SCC,LCLS2SCSS];
SC_S2_XI=[LCLS2SCI,LCLS2SCC,LCLS2SCS2_X];
SC_STXII=[LCLS2SCI,LCLS2SCC,LCLS2SCSTXI];
SC_STMOI=[LCLS2SCI,LCLS2SCC,LCLS2SCSTMO];
SC_BSYDI=[LCLS2SCI,LCLS2SCC,LCLS2SCD];
SC_DASELI=[LCLS2SCI,LCLS2SCC,LCLS2SCDA];
% ------------------------------------------------------------------------------
% initial BSY coordinates at BEGSP (LTUSPLIT)
% ------------------------------------------------------------------------------
XF =   XOFF;
%Yf     :=  1.899339708765 1.897939159495 -0.3*SIN(2*AVB)
%Zf     := -267.7180471454 -267.4180504124 -0.3*COS(2*AVB)
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
TWSSMH=struct('ENERGY',EF,'BETX',MBETXH,'ALFX',MALFXH,'BETY',MBETYH,'ALFY',MALFYH);
TWSSMS=struct('ENERGY',EF,'BETX',MBETXS,'ALFX',MALFXS,'BETY',MBETYS,'ALFY',MALFYS);
TWSSP=struct('BETX',TBXSP,'BETY',TBYSP,'ALFX',TAXSP,'ALFY',TAYSP);
% temporary

% ==============================================================================
% SUBROUTINEs
% ------------------------------------------------------------------------------
% use QCM01
% SETQCM01ON : SUBROUTINE
%   SET, KQCM01, 0.378216482077
%   SET, KQ0H01, -6.391217650404
%   SET, KQ0H02, 5.905989161645
%   SET, KQ0H03, 2.403934435238
%   SET, KQ0H04, -6.042774733767

% use QC002 to match into COL0 FODO (set QC005[K1] to FODO value)
% SETQC002ON : SUBROUTINE
%   SET, KQC001, 5.055115117203
%   SET, KQC002, 0.157983739509
%   SET, KQC003, -5.345027236641
%   SET, KQC004, 2.756594856447
%   SET, KQC005, -KQCOLL0

% ==============================================================================
% for testing the online Matlab model
% ------------------------------------------------------------------------------
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
%CALL, FILENAME="LCLS2sc_makeSymbols.mad8"
%CALL, FILENAME="LCLS2sc_makeElegant.mad8"
%CALL, FILENAME="LCLS2sc_XLEAP.mad8" run by itself
%STOP
% ------------------------------------------------------------------------------
%CALL "LCLS2sc_color_plots.mad8" run by itself (ends with STOP)
%CALL "LCLS2sc_area_plots.mad8"  run by itself (ends with STOP)
% ------------------------------------------------------------------------------
% SURVEY in linac coordinates
% ------------------------------------------------------------------------------
% SXR
%COMMENT





%SAVELINE, NAME="SC_SXR", FILENAME="LCLS2scS.saveline"





%, &
%  RTAPE="LCLS2scS_rmat.tape"




%PLOT, TABLE=TWISS, HAXIS=S, VAXIS=BETX,BETY, &
%  STYLE=100, SPLINE, RANGE=BEAM0/ENDEXT, FILE="LCLS2scS", &
%  TITLE="UNDS (SC beam, 4 GeV, NCELL=9.0)"
% 
% 
% 
% 

%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR safety dump
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR "2.x"
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR TXI
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR TMO
%COMMENT







%ENDCOMMENT
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
% DASEL (a.k.a. S30XL, LESA ... funded off-project)
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
% SXR 2_X "2.X"
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR TXI
%COMMENT







%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR TMO
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
% DASEL (a.k.a. S30XL, LESA)
%COMMENT





%MAKESEQUENCE, LABEL="DASEL", REFER="CENTRE"
%SAVELINE, NAME="DASEL", FILENAME="DASEL.seq"


%ENDCOMMENT
% ==============================================================================

function b=SETQCM01ON(b)
for n=find(strcmp('QCM01',b(:,2)))',b{n,4}(1)=0.378216482077;end
for n=find(strcmp('Q0H01',b(:,2)))',b{n,4}(1)=-6.391217650404;end
for n=find(strcmp('Q0H02',b(:,2)))',b{n,4}(1)=5.905989161645;end
for n=find(strcmp('Q0H03',b(:,2)))',b{n,4}(1)=2.403934435238;end
for n=find(strcmp('Q0H04',b(:,2)))',b{n,4}(1)=-6.042774733767;end

function b=SETQC002ON(b)
for n=find(strcmp('QC001',b(:,2)))',b{n,4}(1)=5.055115117203;end
for n=find(strcmp('QC002',b(:,2)))',b{n,4}(1)=0.157983739509;end
for n=find(strcmp('QC003',b(:,2)))',b{n,4}(1)=-5.345027236641;end
for n=find(strcmp('QC004',b(:,2)))',b{n,4}(1)=2.756594856447;end
for n=find(strcmp('QC005',b(:,2)))',b{n,4}(1)=-KQCOLL0;end

