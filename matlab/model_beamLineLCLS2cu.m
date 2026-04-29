function beamLine=model_beamLineLCLS2cu()
%
% -----------------------------------------------------------------------------
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% -----------------------------------------------------------------------------
%
% Returns Matlab model beam lines that correspond to defined AD_ACCEL
% beampaths originating in the room temperature Cu linac:
%
%  beamLine.CU_GSPEC = gun to 6 MeV spectrometer FARC (was 'GS' in LCLS)
%  beamLine.CU_SPEC  = gun to 135 MeV spectrometer beam dump (was 'SP' in LCLS)
%  beamLine.CU_HXR   = gun to HXR beam dump (was 'FullMachine' in LCLS)
%  beamLine.CU_SXR   = gun to SXR beam dump
%
% Additional beam lines used for comparison with MAD (starting at OTR2, at 135 MeV):
%
%  beamLine.CU_SPECI  = OTR2 to 135 MeV spectrometer beam dump
%  beamLine.CU_HXRI   = OTR2 to HXR beam dump
%  beamLine.CU_SXRI   = OTR2 to SXR beam dump
%
% -----------------------------------------------------------------------------
 
% check for mat-file version ... load and return beamLine if found
if (exist('model_beamLineLCLS2cu.mat')==2)
  load model_beamLineLCLS2cu.mat
  return
end

global SETCUS

SETCUS = 0;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_HXR=[GUNL0A,L0AL0B,LCLS2CUH]';
beamLine.CU_HXR=SETK2CUH(beamLine.CU_HXR);

SETCUS = 1;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_SXR=[GUNL0A,L0AL0B,LCLS2CUS]';
beamLine.CU_SXR=SETK2CUS(beamLine.CU_SXR);

SETCUS = 0;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_GSPEC=[GUNBXG,GSPEC]';


SETCUS = 0;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_SPEC=[GUNL0A,L0AL0B,DL1_1,SPECBL]';


SETCUS = 0;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_HXRI=[LCLS2CUI,LCLS2CUCI,BSYLTUH]';
beamLine.CU_HXRI=SETK2CUH(beamLine.CU_HXRI);

SETCUS = 1;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_SXRI=[LCLS2CUI,LCLS2CUCI,BSYLTUS]';
beamLine.CU_SXRI=SETK2CUS(beamLine.CU_SXRI);

SETCUS = 0;
[BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl();
beamLine.CU_SPECI=[LCLS2CUI,SPECBL]';



function [BSYLTUH,BSYLTUS,DL1_1,GSPEC,GUNBXG,GUNL0A,L0AL0B,LCLS2CUCI,LCLS2CUH,LCLS2CUI,LCLS2CUS,SPECBL]=bl()

global SETCUS


PI     = pi;
TWOPI  = 2*pi;
DEGRAD = 180/pi;
RADDEG = pi/180;
E      = exp(1);
EMASS  = 0.510998902e-3; % electron rest mass [GeV]
PMASS  = 0.938271998;    % proton rest mass [GeV]
CLIGHT = 2.99792458e8;   % speed of light [m/s]

% *** OPTICS=AD_ACCEL-04MAY2026s ***



% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 07-AUG-2019, M. Woodley
%  * remove "h" from names of split elements
%  * create "_full" sub-LINEs for split elements
% ------------------------------------------------------------------------------
% 22-JAN-2016, M. Woodley
%  * start LCLS2cuS at CATHODE; EBC2=3.0, Ef=4.0 (Eu=4.0)
%  * add SETcu4GeV to rematch through lower energy linac
%  * modify color plots for LCLS2cuS
% ------------------------------------------------------------------------------
% 30-OCT-2018, M. Woodley
%  * set IntgSX= 20 kG (was 30 kG) for 4 GeV beam (cuS and scS optics identical
%    downstream of QDL11)
% ------------------------------------------------------------------------------
% 19-JUL-2017, M. Woodley
%  * structural changes in deck to accomodate MAD-to-BMAD
% ------------------------------------------------------------------------------
% 01-MAR-2017, M. Woodley
%  * WS24 is actually installed (per LCLS)
% ------------------------------------------------------------------------------
% 25-SEP-2015, Y. Nosochkov
%  * rename LCLS1AL to LCLS2cuAL
%  * load ALINE.xsif before LTU.xsif
%  * load SPRD.xsif
% 24-AUG-2015, Y. Nosochkov
%  * see list of changes in .xsif files
% ------------------------------------------------------------------------------
% 19-JUN-2015, Y. Nosochkov
%  * see list of changes in .xsif files and in file MADdeckChanges.pdf
% ------------------------------------------------------------------------------
% 12-MAR-2015, Y. Nosochkov
%  * remove PCTDKIK1-4 collimators in BSY1 (per S. Mao)
%  * use kicker/septum or pulsed magnets to connect BSY with the A-line
%  * add CUSXR beamline for transport from Cu-linac to SXR
% ------------------------------------------------------------------------------
% 09-DEC-2014, Y. Nosochkov
%  * update initial Twiss and survey coordinates at BSY1BEG
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * redefine DBMARK29 to be LI30 IV30-9 (Z=3042.005)
% ------------------------------------------------------------------------------
% 15-SEP-2014, Y. Nosochkov
%  * designate BSY1 line connecting the end of LCLS1 L3 with the beginning of
%    LCLS2 HXR merge bend BXSP1h
% 02-MAY-2014, Y. Nosochkov
%  * rematch HXR undulator for 13.64 GeV and 40 kG quad integral field
% 18-APR-2014, Y. Nosochkov
%  * combine upstream LCLS1 lattice with downstream LCLS2scH lattice
% ==============================================================================
% ==============================================================================
% Beamline area names (see LCLSII-HE-1.1-PR-0028)
% see: https://docs.slac.stanford.edu/sites/pub/Publications/
%      LCLS-II-HE Beamline Boundaries
% ------------------------------------------------------------------------------
% Cu linac common areas
% ------------------------------------------------------------------------------
% GUN     : cathode to BXG u/s face
% L0      : L0A and L0B
% DL1_1   : laser heater, diagnostics, matching
% DL1_2   : injection into main linac
% L1      : L1 linac (21-1b,c,d)
% BC1     : L1X and BC1 chicane
% L2      : L2 linac (21-3, LI22, LI23, LI24->24-6)
% BC2     : BC2 chicane
% L3      : L2 linac (LI25, LI26, LI27, LI28, LI29, LI30->30-8c)
% CLTH_0  : end of linac sector 30 to start of BSY (wooden door)
% CLTH_1  : start of BSY to CUSXR kicker
% ------------------------------------------------------------------------------
% Cu linac to HXR areas
% ------------------------------------------------------------------------------
% CLTH_2  : CUSXR kickers to Cu/SC linac merge (HXR line)
% BSYH_1  : Cu/SC linac merge to A-line kickers
% BSYH_2  : A-line kickers to end of BSY
% LTUH    : HXR LTU (from end of BSY)
% UNDH    : HXR undulator
% DMPH_1  : HXR post-undulator line
% DMPH_2  : HXR dump line
% SFTH_1  : BYDSH u/s face to BXPM1 u/s face
% SFTH_2  : BXPM1 u/s face to HXR safety dump
% HXTES_1 : BXPM1 u/s face to start of HXTES line (BSY coordinate SURVEY only)
% HXTES_2 : start of HXR XTES line to end (BSY coordinate SURVEY only)
% HXTES_3 : start of HXR TXI line to end (BSY coordinate SURVEY only)
% ------------------------------------------------------------------------------
% Cu linac to SXR areas
% ------------------------------------------------------------------------------
% CUSXR   : CUSXR kicker to Cu/SC linac merge
% BSYS    : Cu/SC merge to end of BSY
% LTUS    : SXR LTU (from end of BSY)
% UNDS    : SXR extension + SXR undulator
% DMPS_1  : SXR post-undulator line
% DMPS_2  : SXR dump line
% SFTS_1  : BYDSS u/s face to BXPM1B u/s face
% SFTS_2  : BXPM1B u/s face to SXR safety dump
% SXTES   : BXPM1B u/s face to SXR XTES (BSY coordinate SURVEY only)
% ------------------------------------------------------------------------------
% Cu linac to other areas
% ------------------------------------------------------------------------------
% GSPEC   : 6 MeV spectrometer
% SPEC    : 135 MeV spectrometer
% BSYA_2  : DASEL/A-line merge to End Station A
% ==============================================================================
% ------------------------------------------------------------------------------
% deflector switch definitions
% ------------------------------------------------------------------------------
SETSP =  0 ;%deflector switch for HXR/SXR/BSYD spreader

SETDA =  0 ;%deflector switch for BSYD/DASEL
SETHXRSS =  0 ;%ON/OFF switch for HXR self-seeding chicane
SETSXRSS =  0 ;%ON/OFF switch for SXR self-seeding chicane
SETPEPX =  0 ;%ON/OFF switch for PEPPEx chicane
SETCBXFEL =  0 ;%ON/OFF switch for CBXFEL chicanes
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
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% ------------------------------------------------------------------------------
% constants and global parameters
% ------------------------------------------------------------------------------
% constants
CB=1.0E10/CLIGHT;%energy to magnetic rigidity
GEV2MEV=1000.0;%GeV to MeV
IN2M=0.0254;%inches to meters
MC2=510.99906E-6;%e- rest mass [GeV]
% SURVEY stuff
INJDEG =  -35.0        ;%injector bend angle w.r.t. linac [degrees]
ZOFFINJ =    0.012100   ;%moves entire injector in main-linac z-direction by this amount (+12.100 mm Nov. 17, 2004)
XOFF =  -25.610*IN2M ;%x-offset of bypass line (old PEP-II 9-GeV) w.r.t. old linac axis (<0 is south)
YOFF =   25.570*IN2M ;%y-offset of bypass line (old PEP-II 9-GeV) w.r.t. old linac axis(>0 is up)
% initial conditions (exit of L0)
EMITXN =  1.00E-06 ;%normalized horizontal emittance (m)
EMITYN =  1.00E-06 ;%normalized vertical emittance (m)
BLENG =  0.83E-03 ;%bunch length (m)
ESPRD =  2.00E-05 ;%slice rms energy spread at 135 MeV (1)
% energy profile
E00 =   0.006 ;%beam energy after gun (GeV)
E0I =   0.064 ;%beam energy between L0a and L0b sections (GeV)
EI =   0.135 ;%initial beam energy (GeV) (150->135 MeV on July 9, 2003)
EBC1 =   0.220 ;%BC1 energy (GeV)
EBC2 =   5.000 ;%BC2 energy (GeV)
EF =   8.000 ;%final beam energy (GeV)
EU =   8.000 ;%energy in undulator (GeV)
BRHO00 =  CB*E00;
BRHO0I =  CB*E0I;
BRHOI =  CB*EI;
BRHO1 =  CB*EBC1;
BRHO2 =  CB*EBC2;
BRHOF =  CB*EF;
BRHOU =  CB*EU;
% compression
R56HTR =  0.0079 ;%dX= 0.035000 m
R56BC1 =  0.0455 ;%dX= 0.247383 m
R56BC2 =  0.028  ;%dX= 0.385010 m
% ------------------------------------------------------------------------------
% twiss parameter definitions
% ------------------------------------------------------------------------------
% twiss parameters at L0a-exit:
TBETX =   1.410  ;%twiss beta x (m)   back-tracked from measured/matched OTR2 through post Aug. 11, 2008 QA01-QE04 real BDES settings
TALFX =  -2.613  ;%twiss alpha x
TBETY =   6.706  ;%twiss beta y (m)
TALFY =   0.506  ;%twiss alpha y
% Dummy, fitted twiss parameters at cathode which yield the above twiss parameters at
% L0a-exit from TWISS, COUPLE (for plotting purposes only - assumes only drift between cathode and L0a-exit)
CBETX =   15.574222415628    ;% consistent with back-tracked from matched OTR2 through post Aug. 11, 2008 QA01-QE04 real BDES
CALFX =   -3.081460679784;
CBETY =    0.39093003939;
CALFY =    0.551431596242E-2;
% Twiss at WS02
%          uncoupled        coupled
%        --------------  --------------
BXI =  1.112974241083 ;%1.110117412898
AXI =  0.068237677519 ;%0.068770525274
BYI =  1.112508206187 ;%1.110117411152
AYI =  0.066916206364 ;%0.068770526037
% Twiss at the beginning of L3 linac
ENBEGL3 =   5.0;
BXBEGL3 =  11.063556098154;
AXBEGL3 =  -0.94968706938;
BYBEGL3 =  70.645797110343;
AYBEGL3 =   2.189962742982;
% Twiss at the end of L3 linac (L3END)
ENENDL3 =   8.0;
BXENDL3 =  33.223271647513;
AXENDL3 =   1.179788571596;
BYENDL3 =  62.179034958969;
AYENDL3 =  -1.656755986924;
% initial Twiss at BEGCLTS (see CUSXR.xsif)
% periodic Twiss in HXR dogleg cells (@MM1; copy from LCLS2sc_master.xsif)
MBETXH =  48.911502413792;
MALFXH =   3.141736059434;
MBETYH =  92.803659415654;
MALFYH =   3.519158552438;
% match into HXR LTU emittance diagnostic section
BXEDH =  46.225914290403;
AXEDH =  -1.084608326581;
BYEDH =  46.225914290403;
AYEDH =   1.084608326581;
% for matching ...
BET11 =  10.090395936353;
BET12 =  2.470673595371;
BET21 =  43.876719659503;
BET22 =  16.019619746515;
%BET31 := 53.481287866029
%BET32 := 35.468087644847
%BET33 := 29.55797372867
%BET34 := 63.601589300188
BET31 =  61.868125327071;
BET32 =  36.40742728964;
BET33 =  36.353377790534;
BET34 =  61.956709274457;
%BET31 := 69.818359882868   for WS28 45 deg/wire
%BET32 := 37.0062095289
%BET33 := 42.5680425597
%BET34 := 60.952049693321
% linac phase advances
MU_L1 =  75/360;
MU_L2 =  55.500/360;
MUX_L3 =  30.175/360 ;%July 13, 2008 - set for best WS28 45-deg mux phase advances
MUY_L3 =  30.130/360 ;%July 13, 2005 - set for 3*90 deg TCAV3[1] to OTR30 (TCAV3 -> 25-2d)
% ------------------------------------------------------------------------------
% beam definitions
% ------------------------------------------------------------------------------
% input beam definition (at L0a-exit)
EMITX =   EMITXN/(E0I/EMASS);
EMITY =   EMITYN/(E0I/EMASS);
TGAMX =   (1+TALFX*TALFX)/TBETX;
TGAMY =   (1+TALFY*TALFY)/TBETY;
SIG11 =   EMITX*TBETX;
SIG21 =  -EMITX*TALFX;
SIG22 =   EMITX*TGAMX;
SIG33 =   EMITY*TBETY;
SIG43 =  -EMITY*TALFY;
SIG44 =   EMITY*TGAMY;
C21 =   SIG21/sqrt(SIG11*SIG22);
C43 =   SIG43/sqrt(SIG33*SIG44);
% input beam definition (at cathode)
CGAMX =   (1+CALFX*CALFX)/CBETX;
CGAMY =   (1+CALFY*CALFY)/CBETY;
SIG11C =   EMITX*CBETX;
SIG21C =  -EMITX*CALFX;
SIG22C =   EMITX*CGAMX;
SIG33C =   EMITY*CBETY;
SIG43C =  -EMITY*CALFY;
SIG44C =   EMITY*CGAMY;
C21C =   SIG21C/sqrt(SIG11C*SIG22C);
C43C =   SIG43C/sqrt(SIG33C*SIG44C);
% ------------------------------------------------------------------------------
% Database MARKer point definitions
% ------------------------------------------------------------------------------
DBMARK80={'mo' 'DBMARK80' 0 []}';%(LCLS GUN) RF gun cathode
DBMARK81={'mo' 'DBMARK81' 0 []}';%(BXG_entr) entrance of BXG
DBMARK97={'mo' 'DBMARK97' 0 []}';%(GUNSPECT) 6 MeV gun spectrometer dump
DBMARK82={'mo' 'DBMARK82' 0 []}';%(BX01entr) entrance of BX01
DBMARK98={'mo' 'DBMARK98' 0 []}';%(135SPECT) 135-MeV spect. dump
DBMARK83={'mo' 'DBMARK83' 0 []}';%(BX02exit) exit of BX02 ... LCLS injection point
DBMARK28={'mo' 'DBMARK28' 0 []}';%(QM15exit) exit of QM15 ... just after TD11
DBMARK29={'mo' 'DBMARK29' 0 []}';%(IV30-9  ) LI30 isolation valve ... start of BSY
% ------------------------------------------------------------------------------
% load lattice definitions
% ------------------------------------------------------------------------------
% LCLS2scH and LCLS1 optics
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc common parameters
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 11-MAR-2023, M. Woodley
%  * "SLOT36" renamed "BR3B"
% 24-OCT-2022, M. Woodley
%  * define Qg-type quadrupole (3.37Q1.2)
% ------------------------------------------------------------------------------
% 20-APR-2021, M. Woodley
%  * add area BEG/END MARKers for LEI areas
% ------------------------------------------------------------------------------
% 10-JUN-2020, M. Woodley
%  * add area BEG/END MARKers for SLOT32 area
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
LKIK =  1.0601  ;%kicker coil length per magnet (m) [41.737"]
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
% beamline area delimiters (see PRD LCLSII-HE-1.3-PR-0028)
% ------------------------------------------------------------------------------
% areas "owned" by SC linac
BEGGUNB={'mo' 'BEGGUNB' 0 []}';
ENDGUNB={'mo' 'ENDGUNB' 0 []}';
BEGL0B={'mo' 'BEGL0B' 0 []}';
ENDL0B={'mo' 'ENDL0B' 0 []}';
BEGHTR_1={'mo' 'BEGHTR_1' 0 []}';
ENDHTR_1={'mo' 'ENDHTR_1' 0 []}';
BEGHTR_2={'mo' 'BEGHTR_2' 0 []}';
ENDHTR_2={'mo' 'ENDHTR_2' 0 []}';
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
BEGBR3B={'mo' 'BEGBR3B' 0 []}';
ENDBR3B={'mo' 'ENDBR3B' 0 []}';
BEGL4B={'mo' 'BEGL4B' 0 []}';
ENDL4B={'mo' 'ENDL4B' 0 []}';
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
% Low Emittance Injector
BEGGUNLEI={'mo' 'BEGGUNLEI' 0 []}';
ENDGUNLEI={'mo' 'ENDGUNLEI' 0 []}';
BEGL0LEI={'mo' 'BEGL0LEI' 0 []}';
ENDL0LEI={'mo' 'ENDL0LEI' 0 []}';
BEGLEI_1={'mo' 'BEGLEI_1' 0 []}';
ENDLEI_1={'mo' 'ENDLEI_1' 0 []}';
BEGLEI_2={'mo' 'BEGLEI_2' 0 []}';
ENDLEI_2={'mo' 'ENDLEI_2' 0 []}';
BEGDIAGI_1={'mo' 'BEGDIAGI_1' 0 []}';
ENDDIAGI_1={'mo' 'ENDDIAGI_1' 0 []}';
BEGDIAGI_2={'mo' 'BEGDIAGI_2' 0 []}';
ENDDIAGI_2={'mo' 'ENDDIAGI_2' 0 []}';
BEGDIAGI_3={'mo' 'BEGDIAGI_3' 0 []}';
ENDDIAGI_3={'mo' 'ENDDIAGI_3' 0 []}';
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

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc 3-way spreader system
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 25-JAN-2024, M. Woodley
%  * de-scope rastering in BSY dump line
%    > rename BKXRASD to XCSP5D (already installed type-4)
%    > rename BKYRASD to YCSP6D (already installed type-4)
%    > remove deferred type-5 correctors XCSP5D and YCSP6D
%    > remove DC spreader option
% ------------------------------------------------------------------------------
% 18-JAN-2024, M. Woodley
%  * sextupoles deferred (level 2)
% ------------------------------------------------------------------------------
% 11-OCT-2023, M. Woodley
%  * relocate spreader sextupoles per L. Borzenets
%  * relocate some spreader BPMs per G. Gassner (|dZ| > 10 mm)
%    (Final Magnet Results Organzized per BeamlineR3.xlsx)
%  * don't relocate QSP11H (dZ=-10.088mm) or QSP8S (dZ=-13.672mm) ... symmetry
% 03-AUG-2023, M. Woodley
%  * adjust locations of spreader ACMs per L. Borzenets
% ------------------------------------------------------------------------------
% 20-DEC-2022, M. Woodley
%  * adjust Z-locations of selected spreader devices per L. Borzenets
%    (SDOG1, YCDOG2, SDOG2, SSP1S, BPMSP1S, SSP2S, SSP2H)
% ------------------------------------------------------------------------------
% 29-AUG-2022, M. Woodley
%  * defer (level 0) XCSP5d and YCSP6d ... not installed
% 05-APR-2022, M. Woodley
%  * move OTRSPDMP 3 inches upstream per L. Borzenets
% ------------------------------------------------------------------------------
% 02-DEC-2021, M. Woodley
%  * relocate SPH and SPS sextupoles per L. Borzenets; rematch
%  * relocate four XCOR's and two BPM's due to sextupole relocations
% 06-OCT-2021, M. Woodley
%  * change TYPE for BKXRASd and BKYRASd to "class-4" per A. Ibrahimov
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
%  * use measured FINT for 1.0D22.265's
% 30-MAY-2018, M. Woodley
%  * add backup DC spreader definitions per J. Chan
% ------------------------------------------------------------------------------
% 05-FEB-2018, Y. Nosochkov
%  * activate six spreader kickers per HXR and SXR
%    update kicker definitions, minor geometry adjustment, rematch optics
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
% 29-AUG-2017, M. Woodley (HE only)
%  * separate SLTD into SLTD1 and SLTD2 at start of B-line
%  * add a DIAG0-style kicker (angle=0) at d/s end of HXR and SXR kicker groups
%  * remove STSP6hb,c,d/BTMSP6Hb (HXR) and STSP5s/BTMSP5s (SXR) per J. Blaha
% 09-AUG-2017, M. Woodley
%  * move TWSSP BETA0 definition to LCLS2sc_main.mad8 (for BMAD compatability)
%  * move SETKIKs and SETKIKh definitions here from common.xsif
% 07-JUL-2017, Y. Nosochkov (HE only)
%  * increase the number of spreader kickers to five for HXR and SXR (each)
%  * minor optics rematch
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
KQSP1H =   0.492292814445 ;% 0.49229321808   0.492284061187
KQSP2H =  -1.000981055059 ;%-1.000981547327 -1.000975933726
KQSP3H =   0.304619142836 ;% 0.304619176241  0.304631069714
KQSP4H =  -0.301462173752 ;%-0.301462173869 -0.301467337182
KQSP5H =   0.179797605135 ;% 0.179797579853  0.179797501925
KQSP6H =  -0.221918232696 ;%-0.221918228381 -0.221916295184
KQSP7H =   0.44717384813  ;% 0.447173802861  0.447153906987
KQSP10H =  -0.301515202649 ;%-0.301515200372 -0.301520272128
KQSP11H =   0.304786173104 ;% 0.304786198645  0.304797809076
KQSP12H =  -0.99191810032  ;%-0.991916211284 -0.991897597733
KQSP13H =   0.491365751861 ;% 0.49136556519   0.49135154631
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
KSSP1H =  -21.215952380359 ;%-21.282185980346 -21.213678321818
KSSP2H =   22.699323306512 ;% 22.886612812697  22.697173502505
TSSP1H =   15.17421962864  ;% 15.186978605075  15.174689147672
TSSP2H =   17.814486995202 ;% 17.810742596035  17.81442928042
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
% 
% KQSP1S =   0.633653576661 ;% 0.633653760115  0.633675409102
% KQSP2S =  -0.558885462267 ;%-0.55888565567  -0.558846970939
% KQSP3S =   0.651984725505 ;% 0.651984811604  0.652027344684
% KQSP4S =  -0.497614883856 ;%-0.497614999015 -0.497671571574
% KQSP5S =   0.184573897566 ;% 0.18457386941   0.184431117493
% KQSP8S =  -0.55912664167  ;%-0.55912608142  -0.559079941433
% KQSP9S =   0.633788997918 ;% 0.633788790869  0.633806671882
% KQSP6S =   KQSP4S;
% KQSP7S =   KQSP3S;

KQSP1S =   0.633449982793 ;% 0.633592368552
KQSP2S =  -0.558283402271 ;%-0.558572403531
KQSP3S =   0.652261510863 ;% 0.652091326391
KQSP4S =  -0.498336756843 ;%-0.497963158567
KQSP5S =   0.184708908949 ;% 0.184546784571
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
KSSP1S =  12.489478420178 ;%12.861579411778
KSSP2S =  13.252942923284 ;%12.859423277476
SSP1S={'dr' '' LSB/2 []}';
SSP2S={'dr' '' LSB/2 []}';
% 
% 
% 

% BSY dumpline quads
KQSP1D =  -0.258585459755 ;%-0.258027172416
KQSP2D =   0.233253472683 ;% 0.232777714022
QSP1D={'qu' 'QSP1D' LQR/2 [KQSP1D 0]}';
QSP2D={'qu' 'QSP2D' LQR/2 [KQSP2D 0]}';
% HXR vertical magnetic kickers
% Kickers are aligned along the z-axis (not yawed or pitched)
% Small vertical offset to handle wakefield is not included in this deck
% Assume the same z-length per kicker
% Assume the same field in the first 5 kickers, and 1.75 times lower field
% (angle) in the 6th large aperture kicker (per T. Beukers)
LBKYSP =  LBKSP ;%kicker straight length (m)
GBKYSP =  GBKSP ;%kicker gap (m) - round pipe (10 mm ID), square bore aperture
GBKYSP2 =  0.035 ;%kicker gap (m) - round pipe (25 mm ID), square bore aperture
SETKIKH =  0.5*SETSP*(SETSP-1)      ;%scale for HXR spreader kicker & septum
ABKYSPH0 =  -0.76530599E-3;
ABKYSPH =  ABKYSPH0 *SETKIKH        ;%total HXR kicker y-angle (rad)
ABKYSP5H =  ABKYSPH/(1+5*1.75)       ;%#6 kicker y-angle (rad)
ABKYSP04H =  ABKYSPH-ABKYSP5H         ;%#1+2+3+4+5 kicker y-angle (rad)
ABKYSP0H =  asin(1*sin(ABKYSP04H)/5) ;%#1 kicker y-angle (rad)
ABKYSP01H =  asin(2*sin(ABKYSP04H)/5) ;%#1+2 kicker y-angle (rad)
ABKYSP02H =  asin(3*sin(ABKYSP04H)/5) ;%#1+2+3 kicker y-angle (rad)
ABKYSP03H =  asin(4*sin(ABKYSP04H)/5) ;%#1+2+3+4 kicker y-angle (rad)
ABKYSP1H =  ABKYSP01H-ABKYSP0H       ;%#2 kicker y-angle (rad)
ABKYSP2H =  ABKYSP02H-ABKYSP01H      ;%#3 kicker y-angle (rad)
ABKYSP3H =  ABKYSP03H-ABKYSP02H      ;%#4 kicker y-angle (rad)
ABKYSP4H =  ABKYSP04H-ABKYSP03H      ;%#5 kicker y-angle (rad)
LBKYSP0H =  1*LBKYSP/(1-ABKYSP0H *ABKYSP0H /6);
LBKYSP01H =  2*LBKYSP/(1-ABKYSP01H*ABKYSP01H/6);
LBKYSP02H =  3*LBKYSP/(1-ABKYSP02H*ABKYSP02H/6);
LBKYSP03H =  4*LBKYSP/(1-ABKYSP03H*ABKYSP03H/6);
LBKYSP04H =  5*LBKYSP/(1-ABKYSP04H*ABKYSP04H/6);
LBKYSP1H =    LBKYSP01H-LBKYSP0H;
LBKYSP2H =    LBKYSP02H-LBKYSP01H;
LBKYSP3H =    LBKYSP03H-LBKYSP02H;
LBKYSP4H =    LBKYSP04H-LBKYSP03H;
LBKYSP5H =    LBKYSP/(1-ABKYSPH*ABKYSP04H/2-ABKYSP5H*ABKYSP5H/6);
BKYSP0HA={'be' 'BKYSP0H' LBKYSP0H/2 [ABKYSP0H/2 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP0HB={'be' 'BKYSP0H' LBKYSP0H/2 [ABKYSP0H/2 GBKYSP/2 0 ABKYSP0H 0 0.5 pi/2]}';
BKYSP1HA={'be' 'BKYSP1H' LBKYSP1H/2 [ABKYSP1H/2 GBKYSP/2 -ABKYSP0H 0 0.5 0 pi/2]}';
BKYSP1HB={'be' 'BKYSP1H' LBKYSP1H/2 [ABKYSP1H/2 GBKYSP/2 0 ABKYSP01H 0 0.5 pi/2]}';
BKYSP2HA={'be' 'BKYSP2H' LBKYSP2H/2 [ABKYSP2H/2 GBKYSP/2 -ABKYSP01H 0 0.5 0 pi/2]}';
BKYSP2HB={'be' 'BKYSP2H' LBKYSP2H/2 [ABKYSP2H/2 GBKYSP/2 0 ABKYSP02H 0 0.5 pi/2]}';
BKYSP3HA={'be' 'BKYSP3H' LBKYSP3H/2 [ABKYSP3H/2 GBKYSP/2 -ABKYSP02H 0 0.5 0 pi/2]}';
BKYSP3HB={'be' 'BKYSP3H' LBKYSP3H/2 [ABKYSP3H/2 GBKYSP/2 0 ABKYSP03H 0 0.5 pi/2]}';
BKYSP4HA={'be' 'BKYSP4H' LBKYSP4H/2 [ABKYSP4H/2 GBKYSP/2 -ABKYSP03H 0 0.5 0 pi/2]}';
BKYSP4HB={'be' 'BKYSP4H' LBKYSP4H/2 [ABKYSP4H/2 GBKYSP/2 0 ABKYSP04H 0 0.5 pi/2]}';
% additional DIAG0-style kicker
BKYSP5HA={'be' 'BKYSP5H' LBKYSP5H/2 [ABKYSP5H/2 GBKYSP2/2 -ABKYSP04H 0 0.5 0 pi/2]}';
BKYSP5HB={'be' 'BKYSP5H' LBKYSP5H/2 [ABKYSP5H/2 GBKYSP2/2 0 ABKYSPH 0 0.5 pi/2]}';
% SXR vertical magnetic kickers
% Kickers are aligned along the z-axis (not yawed or pitched)
% Vertical offset to handle wakefield is not included in this deck
% Assume the same z-length per kicker
% Assume the same field in the first 5 kickers, and 1.75 times lower field
% (angle) in the 6th large aperture kicker (per T. Beukers)
SETKIKS =  0.5*SETSP*(SETSP+1)      ;%scale for SXR spreader kicker & septum
ABKYSPS0 =  -0.76530599E-3;
ABKYSPS =  ABKYSPS0 *SETKIKS        ;%total SXR kicker y-angle (rad)
ABKYSP5S =  ABKYSPS/(1+5*1.75)       ;%#6 kicker y-angle (rad)
ABKYSP04S =  ABKYSPS-ABKYSP5S         ;%#1+2+3+4+5 kicker y-angle (rad)
ABKYSP0S =  asin(1*sin(ABKYSP04S)/5) ;%#1 kicker y-angle (rad)
ABKYSP01S =  asin(2*sin(ABKYSP04S)/5) ;%#1+2 kicker y-angle (rad)
ABKYSP02S =  asin(3*sin(ABKYSP04S)/5) ;%#1+2+3 kicker y-angle (rad)
ABKYSP03S =  asin(4*sin(ABKYSP04S)/5) ;%#1+2+3+4 kicker y-angle (rad)
ABKYSP1S =  ABKYSP01S-ABKYSP0S       ;%#2 kicker y-angle (rad)
ABKYSP2S =  ABKYSP02S-ABKYSP01S      ;%#3 kicker y-angle (rad)
ABKYSP3S =  ABKYSP03S-ABKYSP02S      ;%#4 kicker y-angle (rad)
ABKYSP4S =  ABKYSP04S-ABKYSP03S      ;%#5 kicker y-angle (rad)
LBKYSP0S =  1*LBKYSP/(1-ABKYSP0S *ABKYSP0S /6);
LBKYSP01S =  2*LBKYSP/(1-ABKYSP01S*ABKYSP01S/6);
LBKYSP02S =  3*LBKYSP/(1-ABKYSP02S*ABKYSP02S/6);
LBKYSP03S =  4*LBKYSP/(1-ABKYSP03S*ABKYSP03S/6);
LBKYSP04S =  5*LBKYSP/(1-ABKYSP04S*ABKYSP04S/6);
LBKYSP1S =    LBKYSP01S-LBKYSP0S;
LBKYSP2S =    LBKYSP02S-LBKYSP01S;
LBKYSP3S =    LBKYSP03S-LBKYSP02S;
LBKYSP4S =    LBKYSP04S-LBKYSP03S;
LBKYSP5S =    LBKYSP/(1-ABKYSPS*ABKYSP04S/2-ABKYSP5S*ABKYSP5S/6);
BKYSP0SA={'be' 'BKYSP0S' LBKYSP0S/2 [ABKYSP0S/2 GBKYSP/2 0 0 0.5 0 pi/2]}';
BKYSP0SB={'be' 'BKYSP0S' LBKYSP0S/2 [ABKYSP0S/2 GBKYSP/2 0 ABKYSP0S 0 0.5 pi/2]}';
BKYSP1SA={'be' 'BKYSP1S' LBKYSP1S/2 [ABKYSP1S/2 GBKYSP/2 -ABKYSP0S 0 0.5 0 pi/2]}';
BKYSP1SB={'be' 'BKYSP1S' LBKYSP1S/2 [ABKYSP1S/2 GBKYSP/2 0 ABKYSP01S 0 0.5 pi/2]}';
BKYSP2SA={'be' 'BKYSP2S' LBKYSP2S/2 [ABKYSP2S/2 GBKYSP/2 -ABKYSP01S 0 0.5 0 pi/2]}';
BKYSP2SB={'be' 'BKYSP2S' LBKYSP2S/2 [ABKYSP2S/2 GBKYSP/2 0 ABKYSP02S 0 0.5 pi/2]}';
BKYSP3SA={'be' 'BKYSP3S' LBKYSP3S/2 [ABKYSP3S/2 GBKYSP/2 -ABKYSP02S 0 0.5 0 pi/2]}';
BKYSP3SB={'be' 'BKYSP3S' LBKYSP3S/2 [ABKYSP3S/2 GBKYSP/2 0 ABKYSP03S 0 0.5 pi/2]}';
BKYSP4SA={'be' 'BKYSP4S' LBKYSP4S/2 [ABKYSP4S/2 GBKYSP/2 -ABKYSP03S 0 0.5 0 pi/2]}';
BKYSP4SB={'be' 'BKYSP4S' LBKYSP4S/2 [ABKYSP4S/2 GBKYSP/2 0 ABKYSP04S 0 0.5 pi/2]}';
% additional DIAG0-style kicker
BKYSP5SA={'be' 'BKYSP5S' LBKYSP5S/2 [ABKYSP5S/2 GBKYSP2/2 -ABKYSP04S 0 0.5 0 pi/2]}';
BKYSP5SB={'be' 'BKYSP5S' LBKYSP5S/2 [ABKYSP5S/2 GBKYSP2/2 0 ABKYSPS 0 0.5 pi/2]}';
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
ABLXSPS0 =  -2*ABLXSPH0 ;%0.011055447407
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
ABRSPH =  0.650488052414E-2 ;%0.650488048269E-2
LBRSPH =  LBSP*ABRSPH/(2*sin(ABRSPH/2))  ;%BRSPh path length (m)
TBRSPH =  0.555232521442 ;%0.555232529864 BRSPh roll angle (rad)
BRSP1HA={'be' 'BRSP1H' LBRSPH/2 [ABRSPH/2 GBSP/2 ABRSPH/2 0 FBSP 0 TBRSPH]}';
BRSP1HB={'be' 'BRSP1H' LBRSPH/2 [ABRSPH/2 GBSP/2 0 ABRSPH/2 0 FBSP TBRSPH]}';
BRSP2HA={'be' 'BRSP2H' LBRSPH/2 [-ABRSPH/2 GBSP/2 -ABRSPH/2 0 FBSP 0 TBRSPH]}';
BRSP2HB={'be' 'BRSP2H' LBRSPH/2 [-ABRSPH/2 GBSP/2 0 -ABRSPH/2 0 FBSP TBRSPH]}';
% HXR horizontal bend
% Note: BXSP1h is a merge DC-bend which is either turned ON to operate
%       SCRF beam in HXR, or turned OFF to operate CURF beam in HXR
DABXSPH =  0.161874267366E-8 ;%0.155464098791E-8
ABXSPH =  (-ABLXSPH0+DABXSPH) *SETKIKH;
ABXSPHH =  ABXSPH/2;
ABXSPHH_2 =  ABXSPHH   *ABXSPHH;
ABXSPHH_4 =  ABXSPHH_2 *ABXSPHH_2;
LBXSPH =  LBSP/(1-ABXSPHH_2/6 +ABXSPHH_4/120) ;%BXSP1h path length (m)
BXSP1HA={'be' 'BXSP1H' LBXSPH/2 [ABXSPH/2 GBSP/2 ABXSPH/2 0 FBSP 0 0]}';
BXSP1HB={'be' 'BXSP1H' LBXSPH/2 [ABXSPH/2 GBSP/2 0 ABXSPH/2 0 FBSP 0]}';
% SXR horizontal bends
DABXSPS =  0.323728750368E-8 ;%0.310901777441E-8
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
ABCSP1H =   0.451638594729E-2 ;%0.445436076072E-2
ABCSP2H =  -0.37510916495E-2  ;%-0.370437221909E-2
LBCSP1H =  LBCSP*ABCSP1H/(2*sin(ABCSP1H/2)) ;%BYSP1h path length (m)
LBCSP2H =  LBCSP*ABCSP2H/(2*sin(ABCSP2H/2)) ;%BYSP2h path length (m)
BYSP1HA={'be' 'BYSP1H' LBCSP1H/2 [ABCSP1H/2 GBCSP/2 ABCSP1H/2 0 FBCSP 0 pi/2]}';
BYSP1HB={'be' 'BYSP1H' LBCSP1H/2 [ABCSP1H/2 GBCSP/2 0 ABCSP1H/2 0 FBCSP pi/2]}';
BYSP2HA={'be' 'BYSP2H' LBCSP2H/2 [ABCSP2H/2 GBCSP/2 ABCSP2H/2 0 FBCSP 0 pi/2]}';
BYSP2HB={'be' 'BYSP2H' LBCSP2H/2 [ABCSP2H/2 GBCSP/2 0 ABCSP2H/2 0 FBCSP pi/2]}';
% SXR DC bend correctors to compensate kicker orbit and dispersion
ABCSP1S =   0.319435037281E-2 ;%0.315465742092E-2
ABCSP2S =  -0.242909115131E-2 ;%-0.240470325405E-2
LBCSP1S =  LBCSP*ABCSP1S/(2*sin(ABCSP1S/2)) ;%BYSP1s path length (m)
LBCSP2S =  LBCSP*ABCSP2S/(2*sin(ABCSP2S/2)) ;%BYSP2s path length (m)
BYSP1SA={'be' 'BYSP1S' LBCSP1S/2 [ABCSP1S/2 GBCSP/2 ABCSP1S/2 0 FBCSP 0 pi/2]}';
BYSP1SB={'be' 'BYSP1S' LBCSP1S/2 [ABCSP1S/2 GBCSP/2 0 ABCSP1S/2 0 FBCSP pi/2]}';
BYSP2SA={'be' 'BYSP2S' LBCSP2S/2 [ABCSP2S/2 GBCSP/2 ABCSP2S/2 0 FBCSP 0 pi/2]}';
BYSP2SB={'be' 'BYSP2S' LBCSP2S/2 [ABCSP2S/2 GBCSP/2 0 ABCSP2S/2 0 FBCSP pi/2]}';
% define unsplit SBENs for BMAD ... not used by MAD
BKYSP0H={'be' 'BKYSP0H' LBKYSP0H [ABKYSP0H GBKYSP/2 0 ABKYSP0H 0.5 0.5 pi/2]}';
BKYSP1H={'be' 'BKYSP1H' LBKYSP1H [ABKYSP1H GBKYSP/2 -ABKYSP0H ABKYSP01H 0.5 0.5 pi/2]}';
BKYSP2H={'be' 'BKYSP2H' LBKYSP2H [ABKYSP2H GBKYSP/2 -ABKYSP01H ABKYSP02H 0.5 0.5 pi/2]}';
BKYSP3H={'be' 'BKYSP3H' LBKYSP3H [ABKYSP3H GBKYSP/2 -ABKYSP02H ABKYSP03H 0.5 0.5 pi/2]}';
BKYSP4H={'be' 'BKYSP4H' LBKYSP4H [ABKYSP4H/2 GBKYSP/2 -ABKYSP03H ABKYSP04H 0.5 0.5 pi/2]}';
BKYSP5H={'be' 'BKYSP5H' LBKYSP5H [ABKYSP5H GBKYSP2/2 -ABKYSP04H ABKYSPH 0.5 0.5 pi/2]}';
BLXSPH={'be' 'BLXSPH' LBLXSPH [ABLXSPH GBLXSP/2 0 ABLXSPH 0.5 0.5 0]}';
BYSP1H={'be' 'BYSP1H' LBCSP1H [ABCSP1H GBCSP/2 ABCSP1H/2 ABCSP1H/2 FBCSP FBCSP pi/2]}';
BYSP2H={'be' 'BYSP2H' LBCSP2H [ABCSP2H GBCSP/2 ABCSP2H/2 ABCSP2H/2 FBCSP FBCSP pi/2]}';
BRSP1H={'be' 'BRSP1H' LBRSPH [ABRSPH GBSP/2 ABRSPH/2 ABRSPH/2 FBSP FBSP TBRSPH]}';
BRSP2H={'be' 'BRSP2H' LBRSPH [-ABRSPH GBSP/2 -ABRSPH/2 -ABRSPH/2 FBSP FBSP TBRSPH]}';
BXSP1H={'be' 'BXSP1H' LBXSPH [ABXSPH GBSP/2 ABXSPH/2 ABXSPH/2 FBSP FBSP 0]}';
BKYSP0S={'be' 'BKYSP0S' LBKYSP0S [ABKYSP0S GBKYSP/2 0 ABKYSP0S 0.5 0.5 pi/2]}';
BKYSP1S={'be' 'BKYSP1S' LBKYSP1S [ABKYSP1S GBKYSP/2 -ABKYSP0S ABKYSP01S 0.5 0.5 pi/2]}';
BKYSP2S={'be' 'BKYSP2S' LBKYSP2S [ABKYSP2S GBKYSP/2 -ABKYSP01S ABKYSP02S 0.5 0.5 pi/2]}';
BKYSP3S={'be' 'BKYSP3S' LBKYSP3S [ABKYSP3S GBKYSP/2 -ABKYSP02S ABKYSP03S 0.5 0.5 pi/2]}';
BKYSP4S={'be' 'BKYSP4S' LBKYSP4S [ABKYSP4S GBKYSP/2 -ABKYSP03S ABKYSP04S 0.5 0.5 pi/2]}';
BKYSP5S={'be' 'BKYSP5S' LBKYSP5S [ABKYSP5S GBKYSP2/2 -ABKYSP04S ABKYSPS 0.5 0.5 pi/2]}';
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
LDSPBK0H =  LDSPBK   /cos(ABKYSP0H);
LDSPBK1H =  LDSPBK   /cos(ABKYSP01H);
LDSPBK2H =  LDSPBK   /cos(ABKYSP02H);
LDSPBK3H =  LDSPBK   /cos(ABKYSP03H);
LDSPBK4H =  LDSPBK   /cos(ABKYSP04H);
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
DLDSP4H =  0.012086980331;
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
DLDSP9H =  0.682322406193E-6 ;%0.0 adjust length of dogleg
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
DLDSP17H =  -0.823260508662E-4 ;%-0.801500183647E-4
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
DSP10HC3={'dr' '' LDSP10HC-DSP10HC1{3}-DSP10HC2{3} []}';%4.65123101319
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
LDSPBK0S =  LDSPBK    /cos(ABKYSP0S);
LDSPBK1S =  LDSPBK    /cos(ABKYSP01S);
LDSPBK2S =  LDSPBK    /cos(ABKYSP02S);
LDSPBK3S =  LDSPBK    /cos(ABKYSP03S);
LDSPBK4S =  LDSPBK    /cos(ABKYSP04S);
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
DLHE1 =  0 ;%+6.E-7
DDSP34 =  0.5E-6;
DLDSP2S =  0.0;
DLDSP2SA =  -0.370596711919E-6 ;%-0.781886051378E-6
LDSP2S =  32.6265 +(LQN-LQA)/2 +DLDSP2S +DLDSP2SA +DLHE1;
LDSP2SB =  11.8;
LDSP2SC =  0.6676 +(LQN-LQA)/2;
LDSP2SA =  LDSP2S-LDSP2SB-LDSP2SC-LBCSP1S-LBCSP2S;
DLDSP3S =  0.0;
LDSP3S =  1.828000203381 +(LQN-LQA) +DLDSP3S;
LDSP3SA =  0.791207309086 ;%0.7912067845   LDSPBPM2 +(LQN-LQA)/2
LDSP3SAA =  0.234476342315 ;%0.234475817809 0.1 +(LQN-LQA)/2
LDSP3SAB =  LDSP3SA-LDSP3SAA-LSB;
LDSP3SB =  0.600136674875 ;%0.6445
LDSP3SC =  LDSP3S-LDSP3SA-LDSP3SB +DDSP34;
LDSP4S =  8.689 +(LQN-LQA)/2 -DLDSP2S -DLDSP3S;
LDSP4SA =  LDSPBPM2 +(LQN-LQA)/2 -DDSP34;
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
LDSP12SB =  0.6659090515;
LDSP12SC =  0.404427591627 ;%0.327723607524
LDSP12SD =  LDSP12S-LDSP12SA-LDSP12SB-LDSP12SC-LSB;
DLDSP13S =  -0.415633125413E-4 ;%-0.406195675138E-4
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
DSP12SD={'dr' '' LDSP12SD []}';
DSP13SA={'dr' '' LDSP13SA []}';
DSP13SB={'dr' '' LDSP13SB []}';
DSP13SB1={'dr' '' 24.621218338532 []}';%9.337992506693
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
DSP5DC3={'dr' '' DSP5DC{3}-DSP5DC1{3}-DSP5DC2{3} []}';%24.450118863768
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
XCSP0D={'dr' '' 0 []}';
YCSP0D={'dr' '' 0 []}';
XCSP1D={'mo' 'XCSP1D' 0 []}';
XCSP3D={'mo' 'XCSP3D' 0 []}';
XCSP5D={'mo' 'XCSP5D' 0 []}';
YCSP2D={'mo' 'YCSP2D' 0 []}';
YCSP4D={'mo' 'YCSP4D' 0 []}';
YCSP6D={'mo' 'YCSP6D' 0 []}';
% SROT to remove rotation angle
AROSP1H =   0.423037934339E-5 ;%0.414577244197E-5
AROSP2H =   0.947723874729E-5 ;%0.947723870567E-5
AROSP3H =  -AROSP2H;
AROSP1S =  -0.846062942472E-5 ;%-0.829141820709E-5
ROSP1H={'ro' 'ROSP1H' 0 [-(AROSP1H)]}';
ROSP2H={'ro' 'ROSP2H' 0 [-(AROSP2H)]}';
ROSP3H={'ro' 'ROSP3H' 0 [-(AROSP3H)]}';
ROSP1S={'ro' 'ROSP1S' 0 [-(AROSP1S)]}';
% other diagnostic
IMSP0H={'mo' 'IMSP0H' 0 []}';%diagnostic ACM in SPH
IMSP0S={'mo' 'IMSP0S' 0 []}';%diagnostic ACM in SPS
IMSP0D={'mo' 'IMSP0D' 0 []}';%diagnostic ACM in SPD
IMBCSH1={'mo' 'IMBCSH1' 0 []}';%BCS ACM triplet in SPH
IMBCSH2={'mo' 'IMBCSH2' 0 []}';%BCS ACM triplet in SPH
IMBCSS1={'mo' 'IMBCSS1' 0 []}';%BCS ACM triplet in SPS
IMBCSS2={'mo' 'IMBCSS2' 0 []}';%BCS ACM triplet in SPS
IMBCSD1={'mo' 'IMBCSD1' 0 []}';%BCS ACM triplet in SPD
IMBCSD2={'mo' 'IMBCSD2' 0 []}';%BCS ACM triplet in SPD
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
SPRDSB=[ROSP1S,DSP2SA,BYSP1S_FULL,DSP2SB,BYSP2S_FULL,CNTSP1S,DSP2SC,QSP1S_FULL,DSP3SAA,SSP1S_FULL,DSP3SAB,BPMSP1S,DSP3SB,XCSP1S,DSP3SC,QSP2S_FULL,DSP4SA,BPMSP2S,DSP4SB,YCSP2S,DSP4SC,IMSP0S,DSP4SD,BXSP1S_FULL,DSP5SA,XCSP3S,DSP5SB,QSP3S_FULL,DSP6SA,BPMSP3S,DSP6SB,YCSP4S,DSP6SC,QSP4S_FULL,DSP7SA,BPMSP4S,DSP7SB,DSP7SC,XCSP5S,DSP7SD,QSP5S_FULL,DSP8SA,BPMSP5S,DSP8SB,DSP8SC,DSP8SD,YCSP6S,DSP8SE,QSP6S_FULL,DSP9SA,BPMSP6S,DSP9SB,XCSP7S,DSP9SC,QSP7S_FULL,DSP10SA,BPMSP7S,DSP10SB,BXSP2S_FULL,DSP11SA,DSP11SB,DSP11SC,DSP11SD,YCSP8S,DSP11SE,QSP8S_FULL,DSP12SA,BPMSP8S,DSP12SB,XCSP9S,DSP12SC,SSP2S_FULL,DSP12SD,QSP9S_FULL,DSP13SA,BPMSP9S,DSP13SB1,IMBCSS1,DSP13SB2,IMBCSS2,DSP13SB3,BXSP3S_FULL,CNTSP2S];
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
ABSPDC =  ABKYSPH0     ;%total HXR spreader y-angle (rad)
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

% *** OPTICS=AD_ACCEL-04MAY2026s ***
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
TBXCUS1 =  28.807259440187 ;%28.807259440187
TAXCUS1 =  -0.120628607888 ;%-0.120628607901
TBYCUS1 =  51.615288901731 ;%51.615288901731
TAYCUS1 =   0.736213115576 ;% 0.736213115604
% ------------------------------------------------------------------------------
% quads (Cu-linac energy is limited to 10 GeV)
KQCUS1 =   0.492297092478 ;% 0.492297092521
KQCUS2 =  -0.423724073005 ;%-0.423724073492
KQCUS3 =  -0.302266732345 ;%-0.302266731726
KQCUS4 =   2.37403264227  ;% 2.374032642695
KQCUS5 =  -1.402669753585 ;%-1.402669754003
KQCUS9 =  -0.466050157544 ;%-0.466050158031
KQCUS10 =   0.49777137309  ;% 0.497771373142
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

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc bypass line, plus match to LTU
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 14-DEC-2021, M. Woodley
%  * add Sector 20 shield wall per A. Ibrahimov and G. Gassner
% 20-JUL-2021, M. Woodley
%  * quad strength changes for Yuri's "symmetric" SPRDs/SPRDh match
% 11-MAY-2021, M. Woodley
%  * correct spacing of 2Q4/BPM/XCOR/YCOR per ID drawings
% ------------------------------------------------------------------------------
% 22-APR-2021, M. Woodley
%  * rename BYP wire scanners (and deferred RFBPMs) per N. Lipkowitz
% 23-MAR-2021, M. Woodley
%  * tweak DCYfd[L] to get Z=3048.000000 at S100B;
%    tweak DCYfe[L] to get Z=3765.480536 at ENDDMPS_2
% ------------------------------------------------------------------------------
% 08-JUN-2020, M. Woodley
%  * add 4th NIT line wire scanner ... renumber other WIREs and RF BPM's
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
KQBP25 =   0.070273904791 ;% 0.070273904791
KQBP26 =  -0.105521611254 ;%-0.105521611251
KQBP27 =   0.111474511408 ;% 0.111474511407
KQBP35 =  -0.29112742557  ;%-0.291127425572
KQBP28 =   0.323836147473 ;% 0.323836147476
% note: the below K-values are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQBP36 =   0.581885208949 ;% 0.581885208949
KQBP30 =  -0.589938332836 ;%-0.589938332836
KQBP31 =   0.614211022315 ;% 0.614211022315
KQBP32 =  -0.490251186947 ;%-0.490251186947
KQBP33 =  -0.372473815777 ;%-0.372473586764 -0.372476510794
KQBP34 =   0.549116661002 ;% 0.54911674268   0.549118036482
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
DSTWEAK =  -0.8E-06 ;%make scSS Z's equal to 12FEB2024s
DDCYD =  0.0 ;%adjust Z at BSYEND
DCYD={'dr' '' 35.977199997076+DDCYD+ZQBP31 []}';
DCYDB={'dr' '' 1.0 []}';
DCYDA={'dr' '' DCYD{3}-DCYDB{3}-LJAW []}';
DCYFA={'dr' '' 1.0 []}';
DCYFB={'dr' '' 0.5 []}';
DCYFC={'dr' '' 1.0 []}';
DCYFD={'dr' '' 6.2525239 []}';%5.952523028144 +0.3
DCYFE={'dr' '' 12.4303464-DCYFA{3}-DCYFB{3}-DCYFC{3}-DCYFD{3}+ZQBP36 []}';%12.43034602883
DCYFEA={'dr' '' 2.512 []}';%3.0
DCYFEB={'dr' '' DCYFE{3}-DCYFEA{3}+DSTWEAK []}';
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
RFBWSBP5={'dr' '' 0 []}';
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
WSBP5={'mo' 'WSBP5' 0 []}';
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
FODOLA=[BEGBYP,RFBWSBP2,D2Q4I2,WSBP2,D2Q4J,DCYSA,BPN12END,BPN13BEG,DCYSB,QBP13_FULL,D2Q4A0,BPMBP13,D2Q4B0,XCBP13,D2Q4C0,YCBP13,D2Q4D0,DCYSA,BPN13END,BPN14BEG,DCYSB,QBP14_FULL,D2Q4A0,BPMBP14,D2Q4B0,XCBP14,D2Q4C0,YCBP14,D2Q4I10,RFBWSBP3,D2Q4I20,WSBP3,D2Q4J0,DCYSA,BPN14END,BPN15BEG,DCYSB,QBP15_FULL,D2Q4A0,BPMBP15,D2Q4B0,XCBP15,D2Q4C0,YCBP15,D2Q4D0,DCYSA,BPN15END,BPN16BEG,DCYSB,QBP16_FULL,D2Q4A0,BPMBP16,D2Q4B0,XCBP16,D2Q4C0,YCBP16,D2Q4I10,RFBWSBP4,D2Q4I20,WSBP4,D2Q4J0,DCYSA,BPN16END,BPN17BEG,DCYSB,QBP17_FULL,D2Q4A0,BPMBP17,D2Q4B0,XCBP17,D2Q4C0,YCBP17,D2Q4D0,DCYSA,BPN17END,BPN18BEG,DCYSB,QBP18_FULL,D2Q4A0,BPMBP18,D2Q4B0,XCBP18,D2Q4C0,YCBP18,D2Q4I10,RFBWSBP5,D2Q4I20,WSBP5,D2Q4J0,DCYSA,BPN18END,BPN19BEG,DCYSB,QBP19_FULL,D2Q4A0,BPMBP19,D2Q4B0,XCBP19,D2Q4C0,YCBP19,D2Q4D0,DCYSA,BPN19END,BPN20BEG,DCYSB,QBP20_FULL,D2Q4A0,BPMBP20,D2Q4B0,XCBP20,D2Q4C0,YCBP20,D2Q4D0,DCYSA1,S20WALL,DCYSA2,BPN20END,BPN21BEG,DCYSB,QBP21_FULL,D2Q4A0,BPMBP21,D2Q4B0,XCBP21,D2Q4C0,YCBP21,D2Q4E0,CXBP21,D2Q4F0,DCYSA,BPN21END,BPN22BEG,DCYSB,QBP22_FULL,D2Q4A0,BPMBP22,D2Q4B0,XCBP22,D2Q4C0,YCBP22,D2Q4E0,CYBP22,D2Q4F0,DCYSA,BPN22END,BPN23BEG,DCYSB,QBP23_FULL,D2Q4A0,BPMBP23,D2Q4B0,XCBP23,D2Q4C0,YCBP23,D2Q4D0,DCYSA,BPN23END,BPN24BEG,DCYSB,QBP24_FULL,D2Q4A0,BPMBP24,RFBBP24,D2Q4B0,XCBP24,D2Q4C0,YCBP24,D2Q4D0,DCYSA,BPN24END,BPN25BEG,DCYSB,QBP25_FULL,D2Q4A0,BPMBP25,D2Q4B0,XCBP25,D2Q4C0,YCBP25,D2Q4E0,CXBP25,D2Q4F0,DCYSA,BPN25END,BPN26BEG,DCYSB,QBP26_FULL,D2Q4A0,BPMBP26,D2Q4B0,XCBP26,D2Q4C0,YCBP26,D2Q4E0,CYBP26,D2Q4F0,DCYSA,BPN26END,BPN27BEG,DCYSB,QBP27_FULL,D2Q4A0,BPMBP27,D2Q4B0,XCBP27,D2Q4C0,YCBP27,D2Q4SA0,BPN27END,D2Q4SB0,QBP35_FULL,D2Q4A,BPMBP35,RFBBP35,D2Q4B,XCBP35,D2Q4C,YCBP35,D2Q4T,QBP28_FULL,D2Q4A,BPMBP28,D2Q4B,XCBP28,D2Q4C,YCBP28,D2Q4Q,LTUSPLIT,RWWAKE2,ENDBYP];
FODOLB=[DCYFA,DCYFB,DCYFC,DCYFD,S100B,DCYFEA,WOODDOOR_SPS];
FODOLC=[DCYFEB,QBP36_FULL,D2Q4A,BPMBP36,D2Q4B,D2Q4C,DCYG ,QBP30_FULL,D2Q4A,RFBBP30,D2Q4B,XCBP30,D2Q4C,YCBP30,DCYC];
FODOL=[FODOLA,SPRDS,FODOLB,FODOLC];
BYPM1=[DCYDA,CXBP30,DCYDB,QBP31_FULL,D2Q4A,BPMBP31,D2Q4B,XCBP31,D2Q4C,YCBP31,D2Q4LAA,PCSP1S,D2Q4LAB,BPMBP32,D2Q4LB,QBP32_FULL,D2Q4AB,D2Q4B,XCBP32,D2Q4C,YCBP32,D2Q4MA1,PCSP2S,D2Q4MA2];
BYPM2=[D2Q4MBA,PCBP33,D2Q4MBB,STBP34A,BTMBP34A,D2Q4MBC,STBP34B,BTMBP34B,D2Q4MBD,DBP2B,QBP33_FULL,D2Q4A,RFBBP33,D2Q4B,XCBP33,D2Q4C,YCBP33,DBP3AA,PCSP3S,DBP3AB,CXBP34,DBP3B,QBP34_FULL,D2Q4A,BPMBP34,D2Q4B,XCBP34,D2Q4C,YCBP34,D2Q4O,DCWLA,PCSP4S,DCWLB];
BYPM=[BYPM1,BRCUS1A,BRCUS1B,MRGCUSXR,BYPM2];
BYPASS=[FODOL,BYPM];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc LTU and dump
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 24-JUL-2025, M. Woodley
%  * add MARKER point "SWIVEL" at location of swivel point
% ------------------------------------------------------------------------------
% 06-MAY-2025, M. Woodley
%  * sync with LCLS-II (12MAY2025s)
% ------------------------------------------------------------------------------
% 04-DEC-2024, M. Woodley
%  * relocate RFBSX14 per X. Permanyer
% ------------------------------------------------------------------------------
% 20-APR-2024, M. Woodley
%  * replace UMXL2h with WIGXLh
%  * fix negative drifts in CBXFEL chicanes
%  * rename BODCBX42 -> YAGCBX42
%  * add BODCBX40
% ------------------------------------------------------------------------------
% 27-JAN-2024, M. Woodley
%  * QDMP1B,2B K1 from Y. Nosochkov (UNDS_BDES_DS_fit.xlsx, 8.0 GeV)
% 25-JAN-2024, M. Woodley
%  * remove de-scoped raster magnets
% 18-JAN-2024, M. Woodley
%  * sextupoles deferred (level 2)
% ------------------------------------------------------------------------------
% 07-SEP-2022, M. Woodley
%  * redefine YAGDL18
% 29-AUG-2022, M. Woodley
%  * defer (level 5) BKYRAS* and BKXRAS* per F. Garcia
% 24-AUG-2022, M. Woodley
%  * locate BKYRAS* upstream of BKXRAS*; move BKXRAS* 0.2 m downstream
%    per M. Kosovsky
% ------------------------------------------------------------------------------
% 30-NOV-2021, M. Woodley
%  * change TYPE of BPMQD and BPMQDB to "Stripline-11" (vertical orientation)
% 22-NOV-2021, M. Woodley
%  * undefer OTRDMPB per T. Maxwell
% 25-OCT-2021, M. Woodley
%  * dump line raster magnet layout per M. Kosovsky
% ------------------------------------------------------------------------------
% 13-FEB-2021, M. Woodley
%  * add PCEBD and PCEBDB per Y. Ding and T. Tan
% 27-JAN-2021, M. Woodley
%  * move RFBHX12 9.373 mm u/s per G. Gassner
% 08-OCT-2020, M. Woodley
%  * rename OTRDL18 to YAGDL18 (TYPE="YAG-PAL") and undefer per B. Jacobson
% ------------------------------------------------------------------------------
% 24-SEP-2020, M. Woodley
%  * add RFBSX14 per D. Cesar
% ------------------------------------------------------------------------------
% 26-JUN-2020, M. Woodley
%  * copy BSYD rastering setup to HXR and SXR dump lines
% 25-JUN-2020, M. Woodley
%  * remove XLEAP wiggler
% ------------------------------------------------------------------------------
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
WIGS_LINE=[WIG1S_FULL,DWGS,WIG2S_FULL,DWGS,WIG3S_FULL,CNTWIGS];
% replace deferred wiggler with a drift
DWIGS={'dr' '' ZWIG []}';
DWIGSA={'dr' '' 1.135414 []}';
DWIGSB={'dr' '' DWIGS{3}-DWIGSA{3}-LPLATE []}';
% ------------------------------------------------------------------------------
% SXR dogleg
% ------------------------------------------------------------------------------
% note: the K-values below are for SC beam; the settings for Cu beam are
% in the "LCLS2cu_main.mad8" file
KQDBL1 =  -0.050435325198 ;%-0.050440327137
KQDBL2 =  -0.559283770709 ;%-0.559278490815
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
KQDL20 =  -0.487928735548 ;%-0.487977031609
KQDL21 =  -1.904088026746 ;%-1.90405658267 
KQDL22 =   2.191370959478 ;% 2.191451571573
QDL20={'qu' 'QDL20' LQE/2 [KQDL20 0]}';
QDL21={'qu' 'QDL21' LQE/2 [KQDL21 0]}';
QDL22={'qu' 'QDL22' LQE/2 [KQDL22 0]}';
KSDL1 =   -8.734519131209 ;% -8.734519131209
KSDL2 =  -24.395452957072 ;%-24.395452957066
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
DL2BCELL=[QDL12,DDL6B,YCDL12,DDL9B,XCDL13,DDL6BA,SDL1_FULL,DDL6BB,QDL13_FULL,DDL7BA,CEDL13,DDL7BB,BPMDL13,DDL8B,YCDL14,DDL6B,QDL14];
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
KQVM4B =  -1.16254158193 ;
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
KQEM1B =   1.994807495497 ;% 1.994770111889
KQEM2B =  -1.80919428388  ;%-1.809227587678
KQEM3B =   1.263530793827 ;% 1.2636088218  
KQEM4B =  -0.891678288287 ;%-0.891714076473
KQEM3VB =   0.0;
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
% % undulators modeled as an R-matrix which includes vertical focusing
% % and horizontal defocusing per Ago Martinelli and Joe Duris
% % (see wigXL2.m, XLEAP-II.pptx, and LCLS2sc_XLEAP.mad8)
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
LWIG =  2.38                                      ;%wiggler effective length [m]
LWIGH =  LWIG/2                                    ;%wiggler half-length [m]
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
% new XLEAP-II quadrupoles (to mitigate focusing of wigglers; off for now)
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
EDMCHB=[D25CMB,D25CMC,DMM1M90CMBA,PC10B,BTM10B,DMM1M90CMBB,XCEM1B,DEM1A,QEM1B_FULL,DEM1BAB,DEM1BBB,QEM2B_FULL,DEM2B,YCEM2B,DMM3M80CMX,XCEM3B,DEM3A,QEM3B_FULL,DEM3BB,QEM3VB_FULL,DMM4M90CMBA,PC11B,BTM11B,DMM4M90CMBB,YCEM4B,DEM4A,QEM4B_FULL,DRFB,RFBEM4B,DMM5AB,DMM5BB];
EDSYSB=[DBMARK36B,WS31B,D40CM,DE3MAB,DE3MBB,XCE31B,DQEA,QE31B_FULL,DXLUA1,YCXL1,DXLUA2,XCXL1,DUMXL12U,UMXLPAIR1,MXL2A,DUMXL12D,PC12B,BTM12B,DBTM2YC,YCE32B,DQEAA,QE32B_FULL,DRFB,RFBE32B,DQEBY1,DCY32B,DQEBY2,WS32B,D40CM,DE3M80CMB,XCE33B,DQEAB,QE33B_FULL,DQEC,DE3M40CM,YCE34B,DQEA,QE34B_FULL,DRFB,RFBE34B,DQEC1,WS33B,D40CM,DE3M80CM,XCE35B,DQEAC,QE35B_FULL,DXLUC,BCXLSS,DXLUD1,YCXL2,DXLUD2,XCXL2,DUMXL34U,MXL2B,UMXLPAIR2,DUMXL34D,YCE36B,DQEA,QE36B_FULL,DRFB,RFBE36B,DQEBY1,DCY36B,DQEBY2,WS34B,D40CM];
ECELLB=[QE31B,DQEC,DQEC,QE32B,QE32B,DQEC,DQEC,QE31B];
% ------------------------------------------------------------------------------
% SXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values are for SC beam; the settings for Cu beam are
%       in the "LCLS2cu_main.mad8" file
KQUM1B =   0.868733464228 ;% 0.833300994164
KQUM2B =  -0.771825649189 ;%-0.826159041824
KQUM3B =   0.678116151436 ;% 0.586599530996
KQUM4B =  -0.747895559578 ;%-0.595708778132
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
KQDMPB =  -0.154946553294 ;%Yuri (E=8.0, K=5.48)
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
DD3AB={'dr' '' 0.3+0.049684+0.001583 []}';
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
YCDDB={'mo' 'YCDDB' 0 []}';
XCDDB={'mo' 'XCDDB' 0 []}';
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
DUMPLINEB=[BEGDMPS_2,RODMP1S,BYDSS_FULL,DS1,BYD1B_FULL,DS,BYD2B_FULL,DS,BYD3B_FULL,DD1BA,PCPM1LB,BTM1LB,DD1BB,DD1BC,MIMBCS4B,DD1BD,YCDDB,DD1BE,PCPM2LB,BTM2LB,DD1BF,QDMP1B_FULL,DD12A,BPMQDB,DD12B,MQDMPB,DD12C,QDMP2B_FULL,DD2A,XCDDB,DD2B,DD2C,DD3AB,BPMDDB,DD3B,OTRDMPB,DWSDUMPA1,PCEBDB,DWSDUMPA2,RFBDDB,DWSDUMPB,WSDUMPB,DWSDUMPC,RODMP2S,DUMPFACEB,DDUMP,DMPENDB,BTMDUMPB,DBMARK38B,ENDDMPS_2];
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
KQ30701 =  -0.396196066234 ;%-0.396231018339
KQ30801 =   0.480072263235 ;% 0.480592172519
KQ50Q1 =  -0.231032050114 ;%-0.231522300458
KQ50Q2 =   0.101648177453 ;% 0.102074332053
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
KQ50Q3 =   0.437511021141 ;% 0.426937957729 
KQ4 =  -0.218137495511 ;%-0.219608310249
KQ5 =   0.110648337873 ;% 0.11024564993
KQ6 =  -0.106093050264 ;%-0.109735122471
KQA0 =   0.096139190896 ;% 0.096565286297
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
KQVM1 =  -0.33743727324;
KQVM2 =   0.23657725939;
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
BWGH =  0                      ;%wiggler bend field (kG)
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
WIGH_LINE=[WIG1H_FULL,DWGH,WIG2H_FULL,DWGH,WIG3H_FULL,CNTWIGH];
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
DL21=[DBMARK34,BX31_FULL,DDL10WA,PC02,BTM02,DDL10WB,DWSDL31A,WSDL31,DWSDL31B,DDL10X,XCDL1,D31A,QDL31_FULL,DRFB,RFBDL1,D31B,YCDL1,D32CMB,CEDL1,D31C,WIGH_LINE,DDL10EM80CMA,PC22,DDL10EM80CMB,CYBX32,DCB32,BX32_FULL,CNTLT2H];
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
KQEM1 =  -0.390828157037 ;%-0.390828157035
KQEM2 =   0.432215882104 ;% 0.432215882102
KQEM3 =  -0.593433627421 ;%-0.593433627427
KQEM4 =   0.420485127988 ;% 0.420485127989
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
% ------------------------------------------------------------------------------
% HXR undulator match
% ------------------------------------------------------------------------------
% note: the below K-values come from Y. Nosochkov's UNDH_KQ4_USDS.xsif file,
%       for E= 8.0 GeV and KHXU= 2.0 (IntgHX= 30.0 kG)
% note: the below K-values are for both SC beam and Cu beam
% source: UNDH_KQ4_USDS.xsif (Eu=8.0, KHXU=2.0)
KQUM1 =   0.270162424021 ;% 0.270162424008
KQUM2 =  -0.2685706757   ;%-0.26857067573
KQUM3 =   0.279944439407 ;% 0.279944439441
KQUM4 =  -0.248916368758 ;%-0.248916368558
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
% ------------------------------------------------------------------------------
% HXR dumpline
% ------------------------------------------------------------------------------
KQDMP =  -0.155212710055 ;%Yuri (E=8.0, K=2.0)
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
DD1A={'dr' '' 0.573903672148 []}';%0.577681302427
DD1B={'dr' '' 1.003865132606 []}';%1.000087502327
DD1C={'dr' '' 0.3048 []}';
DD1E={'dr' '' 0.24964958152 []}';%0.249638105611
DD1F={'dr' '' 0.409228582137 []}';%0.409240058046
DD1D={'dr' '' LDMP1-(DD1A{3}+PCPM1L{3}+DD1B{3}+DD1C{3}+DD1E{3}+PCPM2L{3}+DD1F{3}) []}';
BPMQD={'mo' 'BPMQD' 0 []}';%RFBQD : MONI, TYPE="@2,CavityL-1"
BPMDD={'mo' 'BPMDD' 0 []}';
RFBDD={'dr' '' 0 []}';
YCDD={'mo' 'YCDD' 0 []}';
XCDD={'mo' 'XCDD' 0 []}';
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

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc undulator and undulator extension
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 06-APR-2026, M. Woodley
%  * replace short-period undulator with long-period undulator in SXR cells 39,
%    40, and 41 per H.-D. Nuhn and G. Gassner
% 15-FEB-2026, M. Woodley
%  * merge AD_ACCEL with AD_ACCEL_HE (replace AD_ACCEL_HE SXR definitions with
%    AD_ACCEL)
% ------------------------------------------------------------------------------
% 19-DEC-2024, M. Woodley
%  * per X. Permanyer: move SXR phase shifters ~10.99 mm upstream
% 04-DEC-2024, M. Woodley
%  * relocate RFBSX15 per X. Permanyer
% 05-NOV-2024, M. Woodley
%  * remove QSXh16 per H.-D. Nuhn
% ------------------------------------------------------------------------------
% 21-APR-2024, M. Woodley
%  * remove WIGXL from SXR cell 18 (move to LTUS)
% 06-MAR-2024, M. Woodley
%  * change BODCBX42 to YAGCBX42 per A. Halavanau
%  * add BODCBX40 per A. Halavanau
% ------------------------------------------------------------------------------
% 27-JAN-2024, M. Woodley
%  * rematch DMPS (note: QUE1 becomes QD; QUE2 becomes QF)
% 17-JAN-2024, M. Woodley
%  * adjust complement and locations of CBXFEL components per SLAC-I-120-022-R2
% ------------------------------------------------------------------------------
% 02-MAR-2023, M. Woodley
%  * reomve FSPEPX1 and FSPEPX3 (PEPPEx Phase 2) per X. Permanyer
% 17-FEB-2023, M. Woodley
%  * change TYPE of SXR undulators to "VGHPU56"
% 08-FEB-2023, M. Woodley
%  * modified SXR undulator end area: single (1.5 m long) TCX01B per P. Krejcik
%  * add LCLS-II PEPPEx devices
% 20-DEC-2022, M. Woodley
%  * relocate BCXHS1 and BCXHS4 to as-built locations per Metrology
%  * relocate BCXHS2 and BCXHS3 per H.-D. Nuhn and T. Montaign
%  * remove second HXRSS chicane (HXR cell 21)
%  * install CBXFEL chicanes in HXR cells 13 and 21 (LCLS-II)
% ------------------------------------------------------------------------------
% 14-DEC-2021, M. Woodley
%  * add phase shifter to HXR cell 46 per G. Kraft
%  * add HXU/BLM/QUAD/RFBPM to HXR cell 47 (no phase shifter, no VV) per G. Kraft
%  * use correct complement of VV's in HXR undulator
%  * move BOD10 to SXR cell 30; move BOD12 to SXR cell 32 (same locations
%    relative to SXRSS, which is in SXR cell 30 for LCLS-II-HE)
% ------------------------------------------------------------------------------
% 27-JAN-2021, M. Woodley
%  * change BOD30 and BOD32 to keyword=PROF, TYPE="YAG" per J. Mock
% ------------------------------------------------------------------------------
% 26-SEP-2020, M. Woodley
%  * move SXRSS to cell 30 (from cell 35)
%  * add RFBSX15 per D. Cesar
%  * new undulator parameters (56 mm period length, 60 poles/periods, K=8.3)
%  * new phase shifter parameters (0.1073 overall length, 0.0975 period length,
%    5700 T^2mm^3 phase integral)
% 30-AUG-2020, M. Woodley
%  * add BLMS17-25, 35; add BLMH 21 and 28
%  * replace BLMS* and BLMH* with MBLMS* and MBLMH*
% ------------------------------------------------------------------------------
% 22-JUN-2020, M. Woodley
%  * remove XLEAP-II wiggler (WIGXLh) from SXCEL18
%  * populate empty SXR cells #17-25 as standard cells, including undulators
%  * change keyword of BLM's to MARK ... will be non-MAD per K. Luchini
% 03-MAR-2020, M. Woodley
%  * move XLEAP wiggler to SXR cell #18
%  * change keyword for "type-V" correctors from HKIC/VKIC to INST
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
%Eu   :         definition moved to LCLS2sc_master.xsif and LCLS2cu_master.xsif
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
KQSX16 =   1.328820114475              ;%1.294142541171
KQSX47 =  -1.49400915478               ;%-1.843482712046 Yuri (E=8.0, K=5.48)
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
UMASXH37=UMASXH_;UMASXH37{2}='UMASXH37';
UMASXH38=UMASXH_;UMASXH38{2}='UMASXH38';
UMASXH39=UMASXH_;UMASXH39{2}='UMASXH39';
UMASXH40=UMASXH_;UMASXH40{2}='UMASXH40';
UMASXH41=UMASXH_;UMASXH41{2}='UMASXH41';
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
USEGSX37=[DTSXU_,UMASXH37,XCSU37,YCSU37,UMASXH37,DTSXU_];
USEGSX38=[DTSXU_,UMASXH38,XCSU38,YCSU38,UMASXH38,DTSXU_];
USEGSX39=[DTSXU_,UMASXH39,XCSU39,YCSU39,UMASXH39,DTSXU_];
USEGSX40=[DTSXU_,UMASXH40,XCSU40,YCSU40,UMASXH40,DTSXU_];
USEGSX41=[DTSXU_,UMASXH41,XCSU41,YCSU41,UMASXH41,DTSXU_];
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
PSSXH45=PSSXH_;PSSXH45{2}='PSSXH45';
PSSXH46=PSSXH_;PSSXH46{2}='PSSXH46';
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
SXBRK45=[DU3S_,PSSXH45_FULL,DU4S_,DU5S_,QSXH45_FULL,DU6S,RFBSX45,DU7S];
SXBRK46=[DU3S_,PSSXH46_FULL,DU4S_,DU5S_,QSXH46_FULL,DU6S,RFBSX46,DU7S];
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
SXCEL37=[SXR37BEG,DU1S,MBLMS37,DU2S,USEGSX37,SXBRK37,SXR37END];%long
SXCEL38=[SXR38BEG,DU1S,        DU2S,USEGSX38,SXBRK38,SXR38END];%long
SXCEL39=[SXR39BEG,DU1S,MBLMS39,DU2S,USEGSX39,SXBRK39,SXR39END];%long
SXCEL40=[SXR40BEG,DU1S,        DU2S,USEGSX40,SXBRK40,SXR40END];%long
SXCEL41=[SXR41BEG,DU1S,MBLMS41,DU2S,USEGSX41,SXBRK41,SXR41END];%long
SXCEL42=[SXR42BEG,DU1S,        DU2S,USEGSX42,SXBRK42,SXR42END];%short/long
SXCEL43=[SXR43BEG,DU1S,MBLMS43,DU2S,USEGSX43,SXBRK43,SXR43END];%short/long
SXCEL44=[SXR44BEG,DU1S,        DU2S,USEGSX44,SXBRK44,SXR44END];%short/long
SXCEL45=[SXR45BEG,DU1S,MBLMS45,DU2S,USEGSX45,SXBRK45,SXR45END];%short/long
SXCEL46=[SXR46BEG,DU1S,        DU2S,USEGSX46,SXBRK46,SXR46END];%short/long
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
KQUE1B =   0.321052033772 ;% 0.325725075565 Yuri (E=8.0, K=5.48)
KQUE2B =  -0.144356640751 ;%Yuri (E=8.0, K=5.48)
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
DUE5DB={'dr' '' 0.137055-0.05 []}';%-0.1751E-3
DUE5EB={'dr' '' 0.252825-DUE5DB{3}-DUE5F{3}+DZSXTES []}';
DDLWALLB={'dr' '' 0.250825-DZSXTES []}';%length of dumpline thermal barrier wall
DSB0AB={'dr' '' 0.260150 []}';
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
UNDEXITB=[BEGDMPS_1,UEBEGB,DUE1D,VV36B,DUE1B,MIMUNDOB,DUE1C,DUE2A,YCUE1B,DUE2B,PH31B,DUE2D,PH32B,DUE2D,PH33B,DUE2D,PH34B,DUE2E,XCUE2B,DUE2CB,QUE1B_FULL,DUE3AB,BPMUE1B,DUE3BB,TRUE1B,DUE3C,DBKXDMPS,DUE3C,DUE3D,PCTCXB,DPCBVVB,VVTCXB,DVVBTCXB,MTCX01B,TCX01B_FULL,DTCXBSPB,SPTCXB,DUE4B,QUE2B_FULL,DUE5AB,BPMUE2B,DUE5BB,BTMQUEB,DUE5CB,PCPM0B,DUE5F,BTM0B,DUE5DB,DUE5EB,MDLWALLB,DDLWALLB,UEENDB,DLSTARTB,DSB0AB,YCD3B,DSB0B,XCD3B,DSB0C,VV37B,DSB0D,DSB0E,ENDDMPS_1];
SXRUND=[SXR,UNDEXITB];
% ==============================================================================
% HXR HGVPU undulator (south)
% ==============================================================================
% ------------------------------------------------------------------------------
% undulator segment
% - Author: Heinz-Dieter Nuhn, Stanford Linear Accelerator Center
% - Edited Mar 03, 2014
% - Updated Dec 02, 2015 for HGVPU (Y. Nosochkov, D. Bruch)
% - 7.2 mm miminum Undulator Gap; only constant break length each
% - include natural horizontal focusing over all but edge terminations
% ------------------------------------------------------------------------------
% - LDUSEGH = HXR Undulator segment length
% - luHXU   = HXR Undulator period
% - NpHXU   = HXR Undulator period count
% - LHXUCR  = HXR Undulator magnetic length
% - LHXUe   = HXR Undulator spacing between magnet array and strongback end
% - KHXU    = HXR Undulator parameter (rms); range 0.54-2.45
% - kQHX    = natural HXR undulator focusing "k" in x-plane
% ------------------------------------------------------------------------------
LDUSEGH =  3.372032;
LUHXU =  0.026                            ;%m
NPHXU =  129;
LHXUCR =  LUHXU*NPHXU                      ;%m
LHXUE =  (LDUSEGH-LHXUCR)/2               ;%m
LHXUH =  LHXUCR/2;
KHXU =  2.0;
KQHX =  (KHXU*2*PI/LUHXU/sqrt(2)/GAMU)^2 ;%m^-2
UMAHXH={'un' 'UMAHXH' LHXUH [KQHX LUHXU 0]}';
% ------------------------------------------------------------------------------
% PPM phase shifter
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
% ------------------------------------------------------------------------------
% FODO cell drifts
% ------------------------------------------------------------------------------
% DTHXU = HXU undulator segment small terminations modeled as drift
% ------------------------------------------------------------------------------
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
DTHXU={'dr' '' LHXUE []}';
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
% HXR undulator quadrupoles
% ------------------------------------------------------------------------------
% - IntgHX  = integrated quadrupole gradient
% - GQFHX   = QF and QD gradients can be made different to compensate for
%             undulator focussing ...
% - GQDHX   = ... but since undulator focussing depends on gamma^2, compensation
%             will only work for one energy
% - kQFHX   = QF undulator quadrupole focusing "k"
% - kQDHX   = QD undulator quadrupole focusing "k"
% ------------------------------------------------------------------------------
%IntgHX :   definition moved to LCLS2sc_main.xsif and LCLS2cu_main.xsif
GQFHX =   INTGHX/LQU/10*1.0           ;%T/m
GQDHX =  -INTGHX/LQU/10*1.0           ;%T/m
KQFHX =   1.E-9*GQFHX*CLIGHT/GAMU/MC2 ;%m^-2
KQDHX =   1.E-9*GQDHX*CLIGHT/GAMU/MC2 ;%m^-2
KQHX46 =  -1.734624260269              ;%Yuri (E=8.0, K=2.0)
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
% HXR undulator RF BPMs
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
% HXR undulator Beam Loss Monitors
% ------------------------------------------------------------------------------
MBLMH14={'mo' 'MBLMH14' 0 []}';
MBLMH16={'mo' 'MBLMH16' 0 []}';
MBLMH18={'mo' 'MBLMH18' 0 []}';
MBLMH20={'mo' 'MBLMH20' 0 []}';
MBLMH22={'mo' 'MBLMH22' 0 []}';
MBLMH24={'mo' 'MBLMH24' 0 []}';
MBLMH26={'mo' 'MBLMH26' 0 []}';
MBLMH28={'mo' 'MBLMH28' 0 []}';
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
% HXR undulator inline valves (VAT Series 48?)
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
% -----13
MPHH14={'mo' 'MPHH14' 0 []}';
MPHH15={'mo' 'MPHH15' 0 []}';
MPHH16={'mo' 'MPHH16' 0 []}';
MPHH17={'mo' 'MPHH17' 0 []}';
MPHH18={'mo' 'MPHH18' 0 []}';
MPHH19={'mo' 'MPHH19' 0 []}';
MPHH20={'mo' 'MPHH20' 0 []}';
% -----21
MPHH22={'mo' 'MPHH22' 0 []}';
MPHH23={'mo' 'MPHH23' 0 []}';
MPHH24={'mo' 'MPHH24' 0 []}';
MPHH25={'mo' 'MPHH25' 0 []}';
MPHH26={'mo' 'MPHH26' 0 []}';
MPHH27={'mo' 'MPHH27' 0 []}';
% -----28
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
% HXRSS self-seeding chicane (LCLSII-3.2-PR-0102-R1)
% ------------------------------------------------------------------------------
% NOTEs:
% - in LCLS: BXHS1-4
% - Bmax = 1.93 kG-m @ 6 A
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
%LHssB2Bo := 0.95 outer bend center-to-center (PRD Table 3)
%LHssB2Bi := 0.936 inner bend center-to-center (PRD Table 3)
LHSSB2BO =  0.85519 ;%outer bend center-to-center (PRD Table 3)
LHSSB2BI =  1.13962 ;%inner bend center-to-center (PRD Table 3)
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
% CBXFEL chicanes
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
% complete HXR undulator segments
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
% complete HXR undulator phase shifters
% ------------------------------------------------------------------------------
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
DPSHX28={'dr' '' LPSHX []}';
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
DPSHX47={'dr' '' LPSHX []}';
DPSHX48={'dr' '' LPSHX []}';
DPSHX49={'dr' '' LPSHX []}';
DPSHX50={'dr' '' LPSHX []}';
% -----13
PSHXH14_FULL=[PSHXH14,MPHH14,PSHXH14];
PSHXH15_FULL=[PSHXH15,MPHH15,PSHXH15];
PSHXH16_FULL=[PSHXH16,MPHH16,PSHXH16];
PSHXH17_FULL=[PSHXH17,MPHH17,PSHXH17];
PSHXH18_FULL=[PSHXH18,MPHH18,PSHXH18];
PSHXH19_FULL=[PSHXH19,MPHH19,PSHXH19];
PSHXH20_FULL=[PSHXH20,MPHH20,PSHXH20];
% -----21
PSHXH22_FULL=[PSHXH22,MPHH22,PSHXH22];
PSHXH23_FULL=[PSHXH23,MPHH23,PSHXH23];
PSHXH24_FULL=[PSHXH24,MPHH24,PSHXH24];
PSHXH25_FULL=[PSHXH25,MPHH25,PSHXH25];
PSHXH26_FULL=[PSHXH26,MPHH26,PSHXH26];
PSHXH27_FULL=[PSHXH27,MPHH27,PSHXH27];
% -----28
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
% ------------------------------------------------------------------------------
% complete HXR undulator quadrupoles
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
% HXR FODO cell interspace definitions
% ------------------------------------------------------------------------------
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
HXBRK28=[DU3H,MBLMH28,DU3H,QHXH28_FULL,DU4H,RFBHX28,DU5H,DPSHX28     ,DU6H        ,DU7H];
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
% HXR cell boundary definitions
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
% ------------------------------------------------------------------------------
% HXR cell definitions
% ------------------------------------------------------------------------------
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
KQUE1 =   0.168949125094 ;% 0.169109252491 Yuri (E=8.0, K=2.0)
KQUE2 =  -0.137840816238 ;%Yuri (E=8.0, K=2.0)
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
DUE5B={'dr' '' 0.3152023 []}';%0.264 -0.012675 +0.063653
DUE5C={'dr' '' 0.267 []}';%0.2671757 0.2674
DUE5D={'dr' '' 0.0872307 []}';%0.137055-0.05
DUE5E={'dr' '' 0.1157693 []}';%0.252825-DUE5d[L]-DUE5f[L]-dzHXTES
DSB0A={'dr' '' 0.260149950459 []}';%0.260150
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
UNDEXIT=[BEGDMPH_1,UEBEG,DUE1D,VV36,DUE1B,MIMUNDO,DUE1C,DUE2A,YCUE1,DUE2B,PH31,DUE2D,PH32,DUE2D,PH33,DUE2D,PH34,DUE2E,XCUE2,DUE2C,QUE1_FULL,DUE3A,BPMUE1,DUE3B,TRUE1,DUE3C,DBKXDMPH,DUE3C,PCTCX,DPCVV,VVTCX,DVVTCX,MTCX01,TCX01_FULL,DTCX12,MTCX,DTCX12,TCX02_FULL,DTCXSP,SPTCX,DUE4,QUE2_FULL,DUE5A,BPMUE2,DUE5B,BTMQUE,DUE5C,PCPM0,BTM0,DUE5F,DUE5D,MIMBCS3,DUE5E,MDLWALL,DDLWALL,UEEND,DLSTART,DSB0A,YCD3,DSB0B,XCD3,DSB0C,VV37,DSB0D,DSB0E,ENDDMPH_1];
HXRUND=[HXR,UNDEXIT];

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2sc safety dump lines
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 20-AUG-2025, M. Woodley
%  * some device locations taken from RP note RP-14-15-R6, Table 4 per S. Xiao
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
LDSC =  0.573816158885 ;%0.433816171073
DS1S={'dr' '' LDS1*cos(ABYDS) []}';
DSSA={'dr' '' LDS*cos(ABYDS+ABDM) []}';
DSSB={'dr' '' LDS*cos(ABYDS+2*ABDM) []}';
DSCS={'dr' '' LDSC*cos(ABYDS+3*ABDM) []}';
LDPM3 =  8.784;
LDPM31 =  8.2704483799;
LDPM32 =  LDPM3-LDPM31;
ZSFTDMP =  0.0762 ;%safety dump Z-length
DPCBTM1={'dr' '' 0.15-0.135 []}';
DPCBTM2={'dr' '' 0.15 []}';
DPM1={'dr' '' 0.535 []}';%0.5350338-0.08-0.01 0.298
DPM11={'dr' '' 0.1886103 []}';%0.188644-0.08-0.01
DPM12={'dr' '' DPM1{3}-DPM11{3} []}';
DPM2={'dr' '' 0.30/cos(ABXPM1) []}';
DPM3={'dr' '' LDPM3/cos(ABXPM1+ABXPM2) []}';
DPM31={'dr' '' LDPM31/cos(ABXPM1+ABXPM2) []}';
DPM32={'dr' '' LDPM32/cos(ABXPM1+ABXPM2) []}';
DPCBTM3={'dr' '' 0 []}';%BTM3 is attached to d/s face of PCPM3
DPM4={'dr' '' 2.42/cos(ABXPM1+ABXPM2) []}';
DSFTDMP={'dr' '' ZSFTDMP/cos(ABXPM1+ABXPM2) []}';
DXDCU={'dr' '' 1.092223+0.75 []}';
DXDCU1={'dr' '' 0.8933 []}';%0.8783
DXDCU1A={'dr' '' 0.8557991 []}';%0.840799
DXDCU1B={'dr' '' DXDCU1{3}-DXDCU1A{3} []}';
DXDCU2={'dr' '' DXDCU{3}-DXDCU1{3} []}';
DXDCU2A={'dr' '' 0.878201 []}';
DXDCU2B={'dr' '' DXDCU2{3}-DXDCU2A{3}+0.015 []}';
XDCA={'dr' '' 0.312777 []}';%XDC chamber
XDCB={'dr' '' 0.693 []}';%XDC chamber
XDCC={'dr' '' 0.542 []}';%XDC chamber
XDCD={'dr' '' 0.255376 []}';%XDC chamber
DXDCD={'dr' '' 7.1789662-DXDCU{3}-XDCA{3}-XDCB{3}-XDCC{3}-XDCD{3} []}';%7.266
DXDCD1={'dr' '' 2.661321 []}';
DXDCD2={'dr' '' 0.512986 []}';
DXDCD2A={'dr' '' 0.142402 []}';
DXDCD2B={'dr' '' DXDCD2{3}-DXDCD2A{3} []}';
DXDCD3={'dr' '' 0.374317-0.015 []}';%DXDCD[L]-DXDCD1[L]-DXDCD2[L]+0.08+0.01
PCPM1={'dr' 'PCPM1' LPCPM []}';%per LCLSII-3.5-PR-0111-R1
PCPM2={'dr' 'PCPM2' LPCPM []}';
DPCPM3={'dr' '' LPCPMW/cos(ABXPM1+ABXPM2) []}';%placeholder for PCPM3
BTM1={'mo' 'BTM1' 0 []}';%Burn-Through-Monitor behind PCPM1
BTM2={'mo' 'BTM2' 0 []}';%Burn-Through-Monitor behind PCPM2
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
MVV10={'mo' 'MVV10' 0 []}';%placeholder for vac. valve in HXR XTES line
BXPM1_FULL=[BXPM11,BXPM12];
BXPM2_FULL=[BXPM21,BXPM22];
SFTDUMP1=[BEGSFTH_1,DYDS,DS1S,DYD1,DSSA,DYD2,DSSB,DYD3,DSCS,PCPM1,BTM1,DXDCU1A,TV1L0_VGC_1,DXDCU1B,TP_HXTES0,DXDCU2A,TV1L0_VRM_1,TV1L0_GCC_1,TV1L0_GPI_1,DXDCU2B,XDCA,RTDSL0,XDCB,XDCC,RTDSL0_YAGXRAY,XDCD,DXDCD1,IM1L0_XTES_VGC_1,DXDCD2A,IM1L0_XTES_VRM_1,DXDCD2B,IM1L0_XTES,DXDCD3,PCPM2,BTM2,DPM11,MBXPM1_PIP_1,DPM12,ENDSFTH_1];
SFTDUMP2=[BEGSFTH_2,BXPM1_FULL,DPM2,BXPM2_FULL,DPM31,MVV10,DPM32,DPCPM3,DPM4,SFTDMP,DSFTDMP,BTMSFT,ENDSFTH_2];
SFTDUMP=[SFTDUMP1,SFTDUMP2];
% ------------------------------------------------------------------------------
% SXR safety dump
% ------------------------------------------------------------------------------
% note that BXPM1b bend axis is aligned with the SXR undulator axis without
% any offset
BBXPMB =  BBXPM;
RBXPMB =  BRHOF/BBXPMB ;%bending radius (m) in permanent magnet
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
DSCSB={'dr' '' 0.572499707805 []}';%0.572498407804-0.13
DPCBTM1B={'dr' '' 0.014998699999 []}';%0.15-0.135+0.13
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
DXDCDB6={'dr' '' 0.536207300001 []}';
%DXDCDB[L]-DXDCDB1[L]-DXDCDB2[L]-DXDCDB3[L]-DXDCDB4[L]&
%-DXDCDB5[L]
DPM1B={'dr' '' 0.447998699999 []}';%0.448
DPM2B={'dr' '' 3.953456653466 []}';
DPM3B={'dr' '' 8.5747889/cos(ABXPM1BS+ABXPM1BL) []}';%2.272
DPM3BA={'dr' '' 0.6560246/cos(ABXPM1BS+ABXPM1BL) []}';
DPM3BB={'dr' '' DPM3B{3}-DPM3BA{3} []}';
DSFTDMPB={'dr' '' ZSFTDMP/cos(ABXPM1BS+ABXPM1BL) []}';
PCPM1B={'dr' 'PCPM1B' LPCPM []}';%per LCLSII-3.5-PR-0111-R1
PCPM2B={'dr' 'PCPM2B' LPCPM []}';
%PCPM3B  : ECOL, L=LPCPM/COS(ABXPM1BS+ABXPM1BL), XSIZE=0.0100, YSIZE=0.0100
BTM1B={'mo' 'BTM1B' 0 []}';%Burn-Through-Monitor behind PCPM1B
BTM2B={'mo' 'BTM2B' 0 []}';%Burn-Through-Monitor behind PCPM2B
%BTM3B   : INST Burn-Through-Monitor behind PCPM3B
BTMSFTB={'mo' 'BTMSFTB' 0 []}';%Burn-Through-Monitor behind SXR safety dump
TP_SXTES0={'mo' 'TP_SXTES0' 0 []}';%treaty point for SXR XTES system (SXTES0)
RTDSK0={'mo' 'RTDSK0' 0 []}';
RTDSK0_YAGXRAYB={'mo' 'RTDSK0_YAGXRAYB' 0 []}';%safety dump line X-ray screen (YAGXRAYB)
PC1K0_XTES={'mo' 'PC1K0_XTES' 0 []}';%PC1S
EM1K0_GMD={'mo' 'EM1K0_GMD' 0 []}';%GMD1S
IM1K0_XTES={'mo' 'IM1K0_XTES' 0 []}';%IM1S
MSL1S={'mo' 'MSL1S' 0 []}';
SFTDMPB={'mo' 'SFTDMPB' 0 []}';%front face of SXR safety dump (Z'=712-715 m per PRD)
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
SFTDUMPB1=[BEGSFTS_1,DYDS,DS1S,DYD1,DSSA,DYD2,DSSB,DYD3,DSCSB,PCPM1B,BTM1B,DPCBTM1B,DXDCUB1,RTDSK0_VGC_1,DXDCUB2,TP_SXTES0,DXDCUB3,RTDSK0_VRM_1,RTDSK0_GCC_1,RTDSK0_GPI_1,DXDCUB4,XDCBA,XDCBB,XDCBC1,RTDSK0,XDCBC2,RTDSK0_YAGXRAYB,XDCBD,DXDCDB1,PC1K0_XTES,DXDCDB2,EM1K0_GMD_VGC_1,DXDCDB3,EM1K0_GMD,DXDCDB4,IM1K0_XTES_VRM_1,IM1K0_XTES_GCC_1,IM1K0_XTES_GPI_1,DXDCDB5,IM1K0_XTES,DXDCDB6,PCPM2B,BTM2B,DPM1B,ENDSFTS_1];
SFTDUMPB2=[BEGSFTS_2,BXPM1B_FULL,DPM2B,MSL1S,DPM3BA,MVV3S,DPM3BB,SFTDMPB,DSFTDMPB,BTMSFTB,ENDSFTS_2];
SFTDUMPB=[SFTDUMPB1,SFTDUMPB2];

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% HXR XTES
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 19-NOV-2019, M. Woodley
%  * from: L2SI_HXR_Backgroud_Cube_Farm_10-22-19_MAD.xlsx per P. Stephens
% ------------------------------------------------------------------------------
% 20-JUN-2018, M. Woodley
%  * PCPM3: keyw=ECOL, L=LPCPMW, XSIZE=0.008, YSIZE=0.008
% ------------------------------------------------------------------------------
% 09-JAN-2018, M. Woodley
%  * from: 2017-11-21__REF__XTES_BG_HXR__mo37504899_update2017-12-19.xlsx
% ------------------------------------------------------------------------------
% ==============================================================================
% mirrors
% ------------------------------------------------------------------------------
% NOTE: change mirrors from MULT to INST for Matlab model generator creation
A1X_XTES =  -0.0042 ;
A1Y_XTES =  0.0;
A2X =  +0.0042 ;
A2Y =  0.0;
A1X_TXI =  -0.014  ;
A1Y_TXI =  0.0;
A3X =  -0.014  ;
A3Y =  0.0;
%MR1L0_HOMS_XTES : MULT, TYPE="MIRROR", K0L=a1x_XTES
%MR2L0_HOMS      : MULT, TYPE="MIRROR", K0L=a2x
%MR1L0_HOMS_TXI  : MULT, TYPE="MIRROR", K0L=a1x_TXI
%MR1L1_TXI       : MULT, TYPE="MIRROR", K0L=a3x
MR1L0_HOMS_XTES={'mo' 'MR1L0_HOMS_XTES' 0 []}';
MR2L0_HOMS={'mo' 'MR2L0_HOMS' 0 []}';
MR1L0_HOMS_TXI={'mo' 'MR1L0_HOMS_TXI' 0 []}';
MR1L1_TXI={'mo' 'MR1L1_TXI' 0 []}';
% ==============================================================================
% DRIF
% ------------------------------------------------------------------------------
A12X =  A1X_XTES+A2X ;
A12Y =  A1Y_XTES+A2Y;
A13X =  A1X_TXI+A3X  ;
A13Y =  A1Y_TXI+A3Y;
% common line
DHXTES01={'dr' '' 0.472-0.000001 []}';
DHXTES02={'dr' '' 1.244 []}';
DHXTES03={'dr' '' 3.686 []}';
DHXTES04={'dr' '' 1.410208 []}';
DHXTES05={'dr' '' 3.64624038 []}';
DHXTES06={'dr' '' 0.14227482 []}';
DHXTES07={'dr' '' 0.4112773-LPCPMW/2 []}';%0.4112768
DHXTES08={'dr' '' 0.2968493-LPCPMW/2 []}';%0.2968498
DHXTES09={'dr' '' 2.1631502 []}';
DHXTES10={'dr' '' 0.0762 []}';
DHXTES11={'dr' '' 0.2199794 []}';
DHXTES12={'dr' '' 5.2838206 []}';
DHXTES13={'dr' '' 2.34 []}';
DHXTES14={'dr' '' 0.2151282 []}';
DHXTES15={'dr' '' 0.1422756 []}';
DHXTES16={'dr' '' 2.15445619 []}';
DHXTES17={'dr' '' 0.07800001 []}';
DHXTES18={'dr' '' 1.68814 []}';
DHXTES19={'dr' '' 3.097995 []}';
DHXTES20={'dr' '' 3.098005 []}';
DHXTES21={'dr' '' 1.620701 []}';
DHXTES22={'dr' '' 0.508 []}';
DHXTES23={'dr' '' 0.4156609 []}';
DHXTES24={'dr' '' 0.2727363 []}';
DHXTES25={'dr' '' 0.1224422-0.000001 []}';
DHXTES26={'dr' '' 0.0526908+0.000001 []}';
DHXTES27={'dr' '' 0.2955101 []}';
DHXTES28={'dr' '' 0.4108887 []}';
DHXTES29={'dr' '' 0.41585 []}';
DHXTES30={'dr' '' 0.8086996 []}';
DHXTES31={'dr' '' 0.5290269-0.000001 []}';
DHXTES32={'dr' '' 0.484378 []}';
DHXTES33={'dr' '' 0.4380026+0.000001 []}';
DHXTES34={'dr' '' 0.1317409 []}';
DHXTES35={'dr' '' 0.003095 []}';
DHXTES36={'dr' '' 0.1423749 []}';
DHXTES37={'dr' '' 0.9542021 []}';
% XTES line
% mirror #1 (MR1L0_HOMS_XTES; horizontal)
DHXTES38={'dr' '' 2.4427654/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES39={'dr' '' 0.2327422/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES40={'dr' '' 0.3767582/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES41={'dr' '' 1.5698633/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES42={'dr' '' 1.3778876/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES43={'dr' '' 0.2721126/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES44={'dr' '' 0.0518361/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES45={'dr' '' 0.2679489/cos(A1X_XTES)/cos(A1Y_XTES) []}';
DHXTES46={'dr' '' 0.6940857/cos(A1X_XTES)/cos(A1Y_XTES) []}';
% mirror #2 (MR2L0_HOMS; horizontal)
DHXTES47={'dr' '' 0.8009988/cos(A12X)/cos(A12Y) []}';
DHXTES48={'dr' '' 0.7124812/cos(A12X)/cos(A12Y) []}';
DHXTES49={'dr' '' 0.2441429/cos(A12X)/cos(A12Y) []}';
DHXTES50={'dr' '' 2.6832515/cos(A12X)/cos(A12Y)-0.000001 []}';
DHXTES51={'dr' '' 0.0518302/cos(A12X)/cos(A12Y)+0.000001 []}';
DHXTES52={'dr' '' 0.0642954/cos(A12X)/cos(A12Y) []}';
DHXTES53={'dr' '' 0.0959278/cos(A12X)/cos(A12Y) []}';
DHXTES54={'dr' '' 1.2249323/cos(A12X)/cos(A12Y) []}';
DHXTES55={'dr' '' 0.1607535/cos(A12X)/cos(A12Y) []}';
DHXTES56={'dr' '' 0.234128/cos(A12X)/cos(A12Y) []}';
DHXTES57={'dr' '' 1.7016744/cos(A12X)/cos(A12Y) []}';
DHXTES58={'dr' '' 0.487615/cos(A12X)/cos(A12Y) []}';
DHXTES59={'dr' '' 0.0518302/cos(A12X)/cos(A12Y) []}';
DHXTES60={'dr' '' 0.1602232/cos(A12X)/cos(A12Y) []}';
DHXTES61={'dr' '' 0.3999156/cos(A12X)/cos(A12Y) []}';
DHXTES62={'dr' '' 1.93/cos(A12X)/cos(A12Y) []}';
DHXTES63={'dr' '' 0.77193/cos(A12X)/cos(A12Y) []}';
% TXI line
DHXTES64={'dr' '' 1.6/cos(A1X_TXI)/cos(A1Y_TXI) []}';
% mirror #3 (MR1L1_TXI; horizontal)
DHXTES65={'dr' '' 1.4522658/cos(A13X)/cos(A13Y) []}';
DHXTES66={'dr' '' 0.4818903/cos(A13X)/cos(A13Y) []}';
DHXTES67={'dr' '' 1.3579709/cos(A13X)/cos(A13Y) []}';
DHXTES68={'dr' '' 0.512498/cos(A13X)/cos(A13Y) []}';
DHXTES69={'dr' '' 0.2170849/cos(A13X)/cos(A13Y) []}';
DHXTES70={'dr' '' 0.0563659/cos(A13X)/cos(A13Y) []}';
DHXTES71={'dr' '' 0.0456042/cos(A13X)/cos(A13Y) []}';
DHXTES72={'dr' '' 0.7945129/cos(A13X)/cos(A13Y) []}';
DHXTES73={'dr' '' 2.7996882/cos(A13X)/cos(A13Y) []}';
DHXTES74={'dr' '' 0.1422198/cos(A13X)/cos(A13Y) []}';
DHXTES75={'dr' '' 0.1567835/cos(A13X)/cos(A13Y) []}';
DHXTES76={'dr' '' 0.0563659/cos(A13X)/cos(A13Y) []}';
DHXTES77={'dr' '' 4.6310069/cos(A13X)/cos(A13Y) []}';
DHXTES78={'dr' '' 1.3951915/cos(A13X)/cos(A13Y) []}';
DHXTES79={'dr' '' 0.0563659/cos(A13X)/cos(A13Y) []}';
DHXTES80={'dr' '' 0.1601604/cos(A13X)/cos(A13Y) []}';
DHXTES81={'dr' '' 0.2765417/cos(A13X)/cos(A13Y) []}';
DHXTES82={'dr' '' 2.1683533/cos(A13X)/cos(A13Y) []}';
% ==============================================================================
% instruments
% ------------------------------------------------------------------------------
% common line
MBXPM1={'mo' 'MBXPM1' 0 []}';
MBXPM2={'mo' 'MBXPM2' 0 []}';
TV2L0_PIP_1={'mo' 'TV2L0_PIP_1' 0 []}';
TV2L0_VRM_1={'mo' 'TV2L0_VRM_1' 0 []}';
TV2L0_GCC_1={'mo' 'TV2L0_GCC_1' 0 []}';
TV2L0_GPI_1={'mo' 'TV2L0_GPI_1' 0 []}';
TV2L0_VGC_1={'mo' 'TV2L0_VGC_1' 0 []}';
TV2L0_PIP_2={'mo' 'TV2L0_PIP_2' 0 []}';
TV2L0_VRM_2={'mo' 'TV2L0_VRM_2' 0 []}';
PCPM3={'dr' 'PCPM3' LPCPMW []}';
BTM3={'mo' 'BTM3' 0 []}';
TV2L0_GFS_1={'mo' 'TV2L0_GFS_1' 0 []}';
TV2L0_GCC_2={'mo' 'TV2L0_GCC_2' 0 []}';
TV2L0_GPI_2={'mo' 'TV2L0_GPI_2' 0 []}';
MSFTDMP={'mo' 'MSFTDMP' 0 []}';
MBTMSFT={'mo' 'MBTMSFT' 0 []}';
TV2L0_PIP_3={'mo' 'TV2L0_PIP_3' 0 []}';
TP_WALL1HE={'mo' 'TP_WALL1HE' 0 []}';
TP_WALL1HW={'mo' 'TP_WALL1HW' 0 []}';
TV2L0_VGC_2={'mo' 'TV2L0_VGC_2' 0 []}';
SL1L0_PWR_VRM_1={'mo' 'SL1L0_PWR_VRM_1' 0 []}';
SL1L0_PWR_GCC_1={'mo' 'SL1L0_PWR_GCC_1' 0 []}';
SL1L0_PWR_GPI_1={'mo' 'SL1L0_PWR_GPI_1' 0 []}';
SL1L0_PWR={'mo' 'SL1L0_PWR' 0 []}';
SL1L0_PWR_PIP_1={'mo' 'SL1L0_PWR_PIP_1' 0 []}';
EM1L0_GEM={'mo' 'EM1L0_GEM' 0 []}';
AT1L0_GAS={'mo' 'AT1L0_GAS' 0 []}';
EM2L0_GEM={'mo' 'EM2L0_GEM' 0 []}';
AT2L0_SOL_PIP_1={'mo' 'AT2L0_SOL_PIP_1' 0 []}';
AT2L0_SOL_VRM_1={'mo' 'AT2L0_SOL_VRM_1' 0 []}';
AT2L0_SOL_GCC_1={'mo' 'AT2L0_SOL_GCC_1' 0 []}';
AT2L0_SOL_GPI_1={'mo' 'AT2L0_SOL_GPI_1' 0 []}';
AT2L0_SOL={'mo' 'AT2L0_SOL' 0 []}';
PC1L0_XTES_VGC_1={'mo' 'PC1L0_XTES_VGC_1' 0 []}';
PC1L0_XTES={'mo' 'PC1L0_XTES' 0 []}';
BT1L0_XTES={'mo' 'BT1L0_XTES' 0 []}';
BS1L0_XTES={'mo' 'BS1L0_XTES' 0 []}';
PF1L0_WFS={'mo' 'PF1L0_WFS' 0 []}';
SL2L0_PWR={'mo' 'SL2L0_PWR' 0 []}';
IM2L0_XTES={'mo' 'IM2L0_XTES' 0 []}';
SP1L0_KMONO={'mo' 'SP1L0_KMONO' 0 []}';
PA1L0_RGA_1={'mo' 'PA1L0_RGA_1' 0 []}';
PA1L0={'mo' 'PA1L0' 0 []}';
PA1L0_VFS_1={'mo' 'PA1L0_VFS_1' 0 []}';
ND1H={'mo' 'ND1H' 0 []}';
PA1L0_VRM_1={'mo' 'PA1L0_VRM_1' 0 []}';
PA1L0_GCC_1={'mo' 'PA1L0_GCC_1' 0 []}';
PA1L0_GCC_2={'mo' 'PA1L0_GCC_2' 0 []}';
PA1L0_GPI_1={'mo' 'PA1L0_GPI_1' 0 []}';
MR1L0_HOMS_VGC_1={'mo' 'MR1L0_HOMS_VGC_1' 0 []}';
% XTES line
BT2L0_PLEG_VGC_1={'mo' 'BT2L0_PLEG_VGC_1' 0 []}';
BT2L0_PLEG_PIP_1={'mo' 'BT2L0_PLEG_PIP_1' 0 []}';
BT2L0_PLEG_VRM_1={'mo' 'BT2L0_PLEG_VRM_1' 0 []}';
BT2L0_PLEG_GCC_1={'mo' 'BT2L0_PLEG_GCC_1' 0 []}';
BT2L0_PLEG_GPI_1={'mo' 'BT2L0_PLEG_GPI_1' 0 []}';
BT2L0_PLEG_XTES={'mo' 'BT2L0_PLEG_XTES' 0 []}';
IM3L0_PPM_PGT_1={'mo' 'IM3L0_PPM_PGT_1' 0 []}';
IM3L0_PPM_VRM_1={'mo' 'IM3L0_PPM_VRM_1' 0 []}';
IM3L0_PPM={'mo' 'IM3L0_PPM' 0 []}';
PC2L0_XTES={'mo' 'PC2L0_XTES' 0 []}';
BT3L0_L2SI={'mo' 'BT3L0_L2SI' 0 []}';
MR2L0_HOMS_VGC_1={'mo' 'MR2L0_HOMS_VGC_1' 0 []}';
MR2L0_HOMS_GBC_1={'mo' 'MR2L0_HOMS_GBC_1' 0 []}';
MR2L0_HOMS_VGC_2={'mo' 'MR2L0_HOMS_VGC_2' 0 []}';
TV3L0_VFS_1={'mo' 'TV3L0_VFS_1' 0 []}';
TV3L0_PIP_1={'mo' 'TV3L0_PIP_1' 0 []}';
PC3L0_XTES={'mo' 'PC3L0_XTES' 0 []}';
BT4L0_COMBO={'mo' 'BT4L0_COMBO' 0 []}';
TP_LUSI={'mo' 'TP_LUSI' 0 []}';
BS3L0_LUSI={'mo' 'BS3L0_LUSI' 0 []}';
SL3L0_PWR_FUT={'mo' 'SL3L0_PWR_FUT' 0 []}';
EM3L0_IPM_FUT={'mo' 'EM3L0_IPM_FUT' 0 []}';
IM4L0_XTES={'mo' 'IM4L0_XTES' 0 []}';
ST1L0_PPS={'mo' 'ST1L0_PPS' 0 []}';
ST1L0_PPS_GBC_1={'mo' 'ST1L0_PPS_GBC_1' 0 []}';
PC4L0_XTES={'mo' 'PC4L0_XTES' 0 []}';
BT5L0_COMBO={'mo' 'BT5L0_COMBO' 0 []}';
BS4L0_LUSI={'mo' 'BS4L0_LUSI' 0 []}';
TP_WALL2HE={'mo' 'TP_WALL2HE' 0 []}';
TP_WALL2HW={'mo' 'TP_WALL2HW' 0 []}';
TP_XPP={'mo' 'TP_XPP' 0 []}';
% TXI line
MR1L1_TXI_GBC_1={'mo' 'MR1L1_TXI_GBC_1' 0 []}';
BT2L0_PLEG_TXI={'mo' 'BT2L0_PLEG_TXI' 0 []}';
TP_TXI_FEE={'mo' 'TP_TXI_FEE' 0 []}';
IM1L1_PPM_PGT_1={'mo' 'IM1L1_PPM_PGT_1' 0 []}';
IM1L1_PPM_VRM_1={'mo' 'IM1L1_PPM_VRM_1' 0 []}';
IM1L1_PPM={'mo' 'IM1L1_PPM' 0 []}';
PC1L1_L2SI={'mo' 'PC1L1_L2SI' 0 []}';
BT1L1_COMBO={'mo' 'BT1L1_COMBO' 0 []}';
BS1L1_MINI={'mo' 'BS1L1_MINI' 0 []}';
TV1L1_VGC_1={'mo' 'TV1L1_VGC_1' 0 []}';
PC2L1_L2SI_VGC_1={'mo' 'PC2L1_L2SI_VGC_1' 0 []}';
PC2L1_L2SI_PIP_1={'mo' 'PC2L1_L2SI_PIP_1' 0 []}';
PC2L1_L2SI={'mo' 'PC2L1_L2SI' 0 []}';
BT2L1_L2SI={'mo' 'BT2L1_L2SI' 0 []}';
ST1L1_PPS={'mo' 'ST1L1_PPS' 0 []}';
ST1L1_PPS_GBC_1={'mo' 'ST1L1_PPS_GBC_1' 0 []}';
PC3L1_L2SI={'mo' 'PC3L1_L2SI' 0 []}';
BT3L1_COMBO={'mo' 'BT3L1_COMBO' 0 []}';
BS2L1_LUSI={'mo' 'BS2L1_LUSI' 0 []}';
BS2L1_LUSI_VRM_1={'mo' 'BS2L1_LUSI_VRM_1' 0 []}';
TP_TXI={'mo' 'TP_TXI' 0 []}';
% ==============================================================================
% BEAMLINE
% ------------------------------------------------------------------------------
% common line
HXTES_1=[BEGHXTES_1,DHXTES01,MBXPM1,DHXTES02,MBXPM2,DHXTES03,TV2L0_PIP_1,DHXTES04,TV2L0_VRM_1,TV2L0_GCC_1,TV2L0_GPI_1,DHXTES05,TV2L0_VGC_1,DHXTES06,TV2L0_PIP_2,TV2L0_VRM_2,DHXTES07,PCPM3,BTM3,DHXTES08,TV2L0_GFS_1,TV2L0_GCC_2,TV2L0_GPI_2,DHXTES09,MSFTDMP,DHXTES10,MBTMSFT,DHXTES11,TV2L0_PIP_3,DHXTES12,TP_WALL1HE,DHXTES13,TP_WALL1HW,DHXTES14,TV2L0_VGC_2,DHXTES15,SL1L0_PWR_VRM_1,SL1L0_PWR_GCC_1,SL1L0_PWR_GPI_1,DHXTES16,SL1L0_PWR,DHXTES17,SL1L0_PWR_PIP_1,DHXTES18,EM1L0_GEM,DHXTES19,AT1L0_GAS,DHXTES20,EM2L0_GEM,DHXTES21,AT2L0_SOL_PIP_1,AT2L0_SOL_VRM_1,AT2L0_SOL_GCC_1,AT2L0_SOL_GPI_1,DHXTES22,AT2L0_SOL,DHXTES23,PC1L0_XTES_VGC_1,DHXTES24,PC1L0_XTES,DHXTES25,BT1L0_XTES,DHXTES26,BS1L0_XTES,DHXTES27,PF1L0_WFS,DHXTES28,SL2L0_PWR,DHXTES29,IM2L0_XTES,DHXTES30,SP1L0_KMONO,DHXTES31,PA1L0_RGA_1,DHXTES32,PA1L0,DHXTES33,PA1L0_VFS_1,DHXTES34,ND1H,DHXTES35,PA1L0_VRM_1,PA1L0_GCC_1,PA1L0_GCC_2,PA1L0_GPI_1,DHXTES36,MR1L0_HOMS_VGC_1,DHXTES37,ENDHXTES_1];
% XTES line
HXTES_2=[BEGHXTES_2,MR1L0_HOMS_XTES,DHXTES38,BT2L0_PLEG_VGC_1,DHXTES39,BT2L0_PLEG_PIP_1,BT2L0_PLEG_VRM_1,BT2L0_PLEG_GCC_1,BT2L0_PLEG_GPI_1,DHXTES40,BT2L0_PLEG_XTES,DHXTES41,IM3L0_PPM_PGT_1,IM3L0_PPM_VRM_1,DHXTES42,IM3L0_PPM,DHXTES43,PC2L0_XTES,DHXTES44,BT3L0_L2SI,DHXTES45,MR2L0_HOMS_VGC_1,DHXTES46,MR2L0_HOMS,MR2L0_HOMS_GBC_1,DHXTES47,MR2L0_HOMS_VGC_2,DHXTES48,TV3L0_VFS_1,DHXTES49,TV3L0_PIP_1,DHXTES50,PC3L0_XTES,DHXTES51,BT4L0_COMBO,DHXTES52,TP_LUSI,DHXTES53,BS3L0_LUSI,DHXTES54,SL3L0_PWR_FUT,DHXTES55,EM3L0_IPM_FUT,DHXTES56,IM4L0_XTES,DHXTES57,ST1L0_PPS,ST1L0_PPS_GBC_1,DHXTES58,PC4L0_XTES,DHXTES59,BT5L0_COMBO,DHXTES60,BS4L0_LUSI,DHXTES61,TP_WALL2HE,DHXTES62,TP_WALL2HW,DHXTES63,TP_XPP,ENDHXTES_2];
% TXI line
HXTES_3=[BEGHXTES_3,MR1L0_HOMS_TXI,DHXTES64,MR1L1_TXI,MR1L1_TXI_GBC_1,DHXTES65,BT2L0_PLEG_TXI,DHXTES66,TP_TXI_FEE,DHXTES67,IM1L1_PPM_PGT_1,IM1L1_PPM_VRM_1,DHXTES68,IM1L1_PPM,DHXTES69,PC1L1_L2SI,DHXTES70,BT1L1_COMBO,DHXTES71,BS1L1_MINI,DHXTES72,TV1L1_VGC_1,DHXTES73,PC2L1_L2SI_VGC_1,DHXTES74,PC2L1_L2SI_PIP_1,DHXTES75,PC2L1_L2SI,DHXTES76,BT2L1_L2SI,DHXTES77,ST1L1_PPS,ST1L1_PPS_GBC_1,DHXTES78,PC3L1_L2SI,DHXTES79,BT3L1_COMBO,DHXTES80,BS2L1_LUSI,DHXTES81,BS2L1_LUSI_VRM_1,DHXTES82,TP_TXI,ENDHXTES_3];
% ------------------------------------------------------------------------------

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% LCLS2cu various parts upstream of BSY
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 17-NOV-2024, M. Woodley
%  * use reduced-W LI22/LI23 lattice
% 06-SEP-2024, M. Woodley
%  * set phase advance between pairs of ultra-fast kickers to 270 degrees
% ------------------------------------------------------------------------------
% 05-APR-2022, M. Woodley
%  * change TYPE of BX01 and BX02 to "1.182D6.82T"; change TYPE of BC1 dipoles
%    to "1.69D6.28T"
% ------------------------------------------------------------------------------
% 08-NOV-2021, M. Woodley
%  * defer BXKIK (decommissioned) at level 9 for Matlab model
% ------------------------------------------------------------------------------
% 04-MAR-2021, M. Woodley
%  * set FREQ=2856 for TCAV0 and TCAV3
% ------------------------------------------------------------------------------
% 31-AUG-2020, M. Woodley
%  * set TYPE="type-4al" for YC21174, XC21175, XC21302, and YC21303
% ------------------------------------------------------------------------------
% 26-JUL-2019, M. Woodley
%  * set L1 and L2 phases, and L1 X-band amplitude, per Y. Ding
% ------------------------------------------------------------------------------
% 30-JAN-2019, M. Woodley
%  * move area BEG/END MARKERs to common.xsif
%  * DL1 becomes two areas (DL1_1 and DL1_2)
%  * rename MRK/FIN MARKERs at BC1 and BC2 to proper area boundary names
% ------------------------------------------------------------------------------
% 07-JAN-2019, M. Woodley
%  * rename some LI21 correctors to avoid name conflicts with LCLS-II
%    per T. Maxwell
%  * define BC1 and BC2 bend angles (rather than B-fields) to allow constant
%    R56 when energy changes
%  * remove "52-line stuff"
% ------------------------------------------------------------------------------
% 08-MAY-2017, M. Woodley
%  * add 0.000001 m to DM19 to force Z=2059.732900 m at ZLIN04 and to line up
%    sector boundaries; reduce DAQ17 by the same amount to compensate
% 01-MAR-2017, M. Woodley
%  * WS24 is actually installed (per LCLS)
% ------------------------------------------------------------------------------
% 23-NOV-2016, Y. Nosochkov
%  * update KQ30801 value
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%  * change "1.259Q3.5" to "1.26Q3.5"
%  * change Everson-Tesla 2.362Q3.5 (r=30mm) to SigmaPhi 1.69Q3.4 (bore=43mm)
%  * remove definition of DRIFT "DAQ6A"
% ------------------------------------------------------------------------------
% 28-OCT-2014, M. Woodley
%  * redefine drift DAQ17 to end at LI30 IV30-9 (Z=3042.005)
% ==============================================================================
LSOL1 =  0.200 ;%needed for DL01a definition
% ==============================================================================
% Longitudinal misalignments observed after installation and difficult to fix:
% Added to MAD file (but not drawings) so that optics comes out right (1/11/07).
% ------------------------------------------------------------------------------
DZ_QA11 =  3.42E-3 ;%quad is too far downstream when dz>0
DZ_Q21201 = -2.39E-3 ;%quad is too far downstream when dz>0
DZ_Q21301 =  5.73E-3 ;%quad is too far downstream when dz>0
DZ_QM14 =  2.17E-3 ;%quad is too far downstream when dz>0
DZ_QM15 =  2.48E-3 ;%quad is too far downstream when dz>0
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% global LCAV parameters
DLWLX =  0.5948  ;%X-band structure length from input-coupler center to output-coupler center, each with tooling balls (m)
DLWL10 =  3.0441  ;%"10  ft" (29 Sband wavelengths; 87 DLWG cavities)
DLWL9 =  2.8692  ;%"9.41 ft" (27 1/3 Sband wavelengths; 82 DLWG cavities)
DLWL7 =  2.1694  ;%"7   ft" (20 2/3 Sband wavelengths; 62 DLWG cavities)
P25 =  1       ;%25% power factor
P50 =  sqrt(2) ;%50% power factor
% L0 energy profile (model the one 3-m L0b section only)
L0PHASE =  -1.1              ;%L0b S-band rf phase (deg)
DEL0A =  GEV2MEV*(E0I-E00) ;%total L0a energy gain (MeV)
DEL0B =  GEV2MEV*(EI-E0I)  ;%total L0b energy gain (MeV)
PHIL0 =  L0PHASE/360       ;%radians/2pi
%gfac0   := 3.130139          flange-to-flange length of dual-feed L0-a and L0-b RF structures [m]
GFAC0 =  3.095244          ;%flange-to-flange length (121.86" Oct. 18, '05) of dual-feed L0-a and L0-b RF structures [m]
GRADL0A =  DEL0A/(GFAC0*cos(PHIL0*TWOPI));
GRADL0B =  DEL0B/(GFAC0*cos(PHIL0*TWOPI));
% L1 energy profile
L1PHASE =  -21.5             ;%L1 S-band rf phase (deg)
L1XPHASE = -160.0             ;%L1 X-band rf phase (deg)
DEL1 =  GEV2MEV*(EBC1-EI) ;%total L1 energy gain (MeV)
DEL1X =  20.0              ;%L1 X-band amplitude (MeV)
PHIL1 =  L1PHASE/360       ;%radians/2pi
PHIL1X =  L1XPHASE/360      ;%radians/2pi
GFAC1 =  P50*DLWL9+P25*DLWL9+P25*DLWL10;
GRADL1 =  (DEL1-DEL1X*cos(PHIL1X*TWOPI))/(GFAC1*cos(PHIL1*TWOPI));
%VALUE, gradL1
% L2 energy profile
L2PHASE =  -33.5               ;%L2 rf phase (deg)
DEL2 =  GEV2MEV*(EBC2-EBC1) ;%total L2 energy gain (MeV)
PHIL2 =  L2PHASE/360         ;%radians/2pi
GFAC2 =  110*P25*DLWL10+1*P50*DLWL10;
GRADL2 =  DEL2/(GFAC2*cos(PHIL2*TWOPI));
%VALUE, gradL2
% L3 energy profile
L3PHASE =  0.0               ;%L3 rf phase (deg)
DEL3 =  GEV2MEV*(EF-EBC2) ;%total L3 energy gain (MeV)
PHIL3 =  L3PHASE/360       ;%radians/2pi
GFAC3 =  161*P25*DLWL10+12*P50*DLWL10+3*P25*DLWL9+4*P25*DLWL7;
GRADL3 =  15.833405341033 ;%16.7 LI25_LI26
%VALUE, gradL3
L1X___1={'lc' 'L1X' DLWLX/2 [XBANDF DEL1X/2 PHIL1X*TWOPI]}';
L1X___2={'lc' 'L1X' DLWLX/2 [XBANDF DEL1X/2 PHIL1X*TWOPI]}';
% L0 sections
L0A___1={'lc' 'L0A' 0.0586460 [SBANDF GRADL0A*0.0586460 PHIL0*TWOPI]}';
L0A___2={'lc' 'L0A' 0.1993540 [SBANDF GRADL0A*0.1993540 PHIL0*TWOPI]}';
L0A___3={'lc' 'L0A' 0.6493198 [SBANDF GRADL0A*0.6493198 PHIL0*TWOPI]}';
L0A___4={'lc' 'L0A' 0.6403022 [SBANDF GRADL0A*0.6403022 PHIL0*TWOPI]}';
L0A___5={'lc' 'L0A' 1.1518464 [SBANDF GRADL0A*1.1518464 PHIL0*TWOPI]}';
L0A___6={'lc' 'L0A' 0.3348566 [SBANDF GRADL0A*0.3348566 PHIL0*TWOPI]}';
L0A___7={'lc' 'L0A' 0.0609190 [SBANDF GRADL0A*0.0609190 PHIL0*TWOPI]}';
L0B___1={'lc' 'L0B' 0.0586460 [SBANDF GRADL0B*0.0586460 PHIL0*TWOPI]}';
L0B___2={'lc' 'L0B' 0.3371281 [SBANDF GRADL0B*0.3371281 PHIL0*TWOPI]}';
L0B___3={'lc' 'L0B' 1.1518479 [SBANDF GRADL0B*1.1518479 PHIL0*TWOPI]}';
L0B___4={'lc' 'L0B' 1.1515630 [SBANDF GRADL0B*1.1515630 PHIL0*TWOPI]}';
L0B___5={'lc' 'L0B' 0.3351400 [SBANDF GRADL0B*0.3351400 PHIL0*TWOPI]}';
L0B___6={'lc' 'L0B' 0.0609190 [SBANDF GRADL0B*0.0609190 PHIL0*TWOPI]}';
FLNGA1={'mo' 'FLNGA1' 0 []}';%upstream   face of L0a entrance flange
FLNGA2={'mo' 'FLNGA2' 0 []}';%downstream face of L0a exit flange
FLNGB1={'mo' 'FLNGB1' 0 []}';%upstream   face of L0b entrance flange
FLNGB2={'mo' 'FLNGB2' 0 []}';%downstream face of L0b exit flange
% transverse deflecting cavities
TCAV0={'tc' 'TCAV0' 0.6680236/2 [2856 0 0*TWOPI]}';%flange-to-flange (then split in two)
TCAV3={'tc' 'TCAV3' 2.438/2 [2856 0 0*TWOPI]}';
% decommissioned kicker magnet
BXKIKA={'dr' '' LKIK/2 []}';
BXKIKB={'dr' '' LKIK/2 []}';
% define unsplit SBENs for BMAD ... not used by MAD
BXKIK={'dr' '' LKIK []}';
% ==============================================================================
% BENDs
% ------------------------------------------------------------------------------
% global BEND parameters
DLBH =  0.0144     ;%increase to lengthen BXH1-4 eff. length (m)
LBH =  0.110+DLBH ;%5D3.9 "Z" length (m)   laser-heater chicane bends approx. effective length (R. Carr, 01-AUG-05 -PE)
GBH =  30E-3      ;%5D3.9 gap height (m)
LB0 =  0.2032     ;%1.182D6.82T "Z" length (m)
GB0 =  30E-3      ;%1.182D6.82T gap height (m)
LB1 =  0.2032     ;%1.69D6.28T "Z" length (m)
GB1 =  43.28E-3   ;%1.69D6.28T gap height (m)
LB2 =  0.5490     ;%1D19.7 "Z" length (m)      changed from 0.540 m to 0.549 on Sep. 28, '07 based on magnetic measurements - PE
GB2 =  33.35E-3   ;%1D19.7 gap height (m)
%LB3  := 2.623      4D102.36T effective length (m)
%GB3  := 0.023      4D102.36T gap height (m)
%LVB  := 1.025      3D39 vertical bend effective length (m)
%GVB  := 0.034925   vertical bend gap width (m)
% GTL gun spectrometer from BXG to Faraday cup and dump
% ===
RBXG =  0.1963       ;%BXG bend radius (measured) [m]
ABXG =  85.0*RADDEG  ;%bend angle of BXG dipole [deg*RADDEG = rad]
EBXG =  24.25*RADDEG ;%BXG pole-face rot. edge angle of BXG dipole [deg*RADDEG = rad]
GBXG =  0.043        ;%BXG magnet full gap height (m)
LBXG =  RBXG*ABXG    ;%path length of BXG dipole when ON (= R*theta) [m]
%VALUE, LBXG
BXGA={'be' 'BXG' LBXG/2 [ABXG/2 GBXG/2 EBXG 0 0.492 0 0]}';%1st-half of gun spectrometer bend
BXGB={'be' 'BXG' LBXG/2 [ABXG/2 GBXG/2 0 EBXG 0 0.492 0]}';%2nd-half of gun spectrometer bend
% define unsplit SBENs for BMAD ... not used by MAD
BXG={'be' 'BXG' LBXG [ABXG GBXG/2 EBXG EBXG 0.492 0.492 0]}';
DXG0={'dr' '' RBXG*sin(ABXG/2) []}';%drift, w/BXG off, from BXG entrance face to its z-projected center
%DXGA : SBEN, L=1E-9/2, ANGLE=0/2 1st-half of gun-spec bend (set to ~zero length and strength, with longitudinal position as bend's center)
%DXGB : SBEN, L=1E-9/2, ANGLE=0/2 2nd-half of gun-spec bend (set to ~zero length and strength, with longitudinal position as bend's center)
DBXG={'dr' '' 0.132618358755-1E-9 []}';%replaces DXG0/DXGA/DXGB
RQGX =  0.020 ;%QG quadrupole pole-tip radius [m]
LQGX =  0.076 ;%QG quadrupole effective length [m]
CQ01={'mu' 'CQ01' 0 [0 0 0 0]}';%correction quad in 1st solenoid at gun (nominally set to 0)
SQ01={'mu' 'SQ01' 0 [0 0 0 pi/4]}';%correction skew-quad in 1st solenoid at gun (nominally set to 0)
QG02={'qu' 'QG02' LQGX/2 [-35.485404325427 0]}';
QG03={'qu' 'QG03' LQGX/2 [80.16050904389 0]}';
DGS1={'dr' '' 0.1900-LQGX/2-20E-6-0.0155757 []}';
DGS2={'dr' '' (0.2300-LQGX)/2+20E-6 []}';
DGS3={'dr' '' (0.2300-LQGX)/2-20E-6 []}';
DGS4={'dr' '' 0.1680-LQGX/2-0.00283 []}';
DGS5={'dr' '' 0.0300-0.02271 []}';
DGS6={'dr' '' 0.0240-0.00402 []}';
DGS7={'dr' '' 0.05 []}';
XCG1={'mo' 'XCG1' 0 []}';
XCG2={'mo' 'XCG2' 0 []}';
YCG1={'mo' 'YCG1' 0 []}';
YCG2={'mo' 'YCG2' 0 []}';
BPMG1={'mo' 'BPMG1' 0 []}';
CRG1={'mo' 'CRG1' 0 []}';%Cerenkov radiator bunch length monitor
YAGG1={'mo' 'YAGG1' 0 []}';%6-MeV spectrometer screen
FCG1={'mo' 'FCG1' 0 []}';%gun-spec. Faraday cup w/screen
BXG_FULL=[BXGA,BXGB];
QG02_FULL=[QG02,XCG1,YCG1,QG02];
QG03_FULL=[QG03,XCG2,YCG2,QG03];
GSPEC=[BEGGSPEC,BXG_FULL,DGS1,QG02_FULL,DGS2,BPMG1,DGS3,QG03_FULL,DGS4,YAGG1,DGS5,CRG1,DGS6,FCG1,DGS7,DBMARK97,ENDGSPEC];
% 135-MeV Spectrometer
% ====================
DX01A={'be' 'DX01' LB0/2 [1E-9 0 0 0 0 0 0]}';%1st half of BX01 magnet switched off here
DX01B={'be' 'DX01' LB0/2 [1E-9 0 0 0 0 0 0]}';%2nd half of BX01 magnet switched off here
DBX01A={'dr' '' 0.1016 []}';%replaces DX01A
DBX01B={'dr' '' 0.1016 []}';%replaces DX01B
LBS =  0.5435        ;%measured effective length along curved trajectory (m)
GBS =  34E-3         ;%gap height (m)
ABS =  INJDEG*RADDEG ;%injection line angle (rad)
BXSEJ =  -7.29*RADDEG;
BXSA={'be' 'BXS' LBS/2 [ABS/2 GBS/2 BXSEJ 0 0.391 0 0]}';
BXSB={'be' 'BXS' LBS/2 [ABS/2 GBS/2 0 BXSEJ 0 0.391 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BXS={'be' 'BXS' LBS [ABS GBS/2 BXSEJ BXSEJ 0.391 0.391 0]}';
KQS01 =   9.682244191676;
KQS02 =  -5.648980372134;
QS01={'qu' 'QS01' LQX/2 [KQS01 0]}';
QS02={'qu' 'QS02' LQX/2 [KQS02 0]}';
DS0={'dr' '' 0.5583996 []}';
DS0A={'dr' '' 0.1691504 []}';
DS0B={'dr' '' 0.4615/2 []}';
DS1A={'dr' '' 0.0890085 []}';
DS1B={'dr' '' 0.1451215 []}';
DS1C={'dr' '' 0.171796 []}';
DS1D={'dr' '' 0.251824 []}';
DS2={'dr' '' 0.478250 []}';
DS3A={'dr' '' 0.199626 []}';
DS3B={'dr' '' 0.200374 []}';
DS4={'dr' '' 0.287275 []}';
DS6A={'dr' '' 0.2575952 []}';
DS6B={'dr' '' 0.2273298-0.008205 []}';
DS7={'dr' '' 0.3801874+0.008205-0.02 []}';
DS8={'dr' '' 0.1976126+0.02 []}';
DS9={'dr' '' 0.3378194 []}';
BPMS1={'mo' 'BPMS1' 0 []}';
BPMS2={'mo' 'BPMS2' 0 []}';
BPMS3={'mo' 'BPMS3' 0 []}';
VVS1={'mo' 'VVS1' 0 []}';%135-MeV spectrometer vacuum valve
YAGS1={'mo' 'YAGS1' 0 []}';%1st 135-MeV spectrometer YAG-screen - center of device in MAD is defined as center of YAG crystal, not mirror
IMS1={'mo' 'IMS1' 0 []}';%135-MeV spectrometer toroid
YAGS2={'mo' 'YAGS2' 0 []}';%2nd 135-MeV spectrometer YAG-screen - center of device in MAD is defined as center of YAG crystal, not mirror
OTRS1={'mo' 'OTRS1' 0 []}';%135-MeV spectrometer OTR-screen
SDMP={'mo' 'SDMP' 0 []}';% gun-spec. dump (exact location? - 11/09/05)
XCS1={'mo' 'XCS1' 0 []}';
YCS1={'mo' 'YCS1' 0 []}';
XCS2={'mo' 'XCS2' 0 []}';
YCS2={'mo' 'YCS2' 0 []}';
BXS_FULL=[BXSA,BXSB];
QS01_FULL=[QS01,BPMS2,QS01];
QS02_FULL=[QS02,QS02];
SCS1=[XCS1,YCS1];
SCS2=[XCS2,YCS2];
SPECBL=[BEGSPEC,DBX01A,DBX01B,DS0,SCS1,DS0A,DS0B,DS1A,VVS1,DS1B,YAGS1,DS1C,BPMS1,DS1D,BXS_FULL,DS2,QS01_FULL,DS3A,SCS2,DS3B,QS02_FULL,DS4,IMS1,DS6A,BPMS3,DS6B,YAGS2,DS7,OTRS1,DS8,DS9,SDMP,DBMARK98,ENDSPEC];
% DL1
% ===
ADL1 =  INJDEG*RADDEG            ;%injection line angle (rad)
AB0 =  ADL1/2                 ;%full bend angle (rad)
LEFFB0 =  LB0*AB0/(2*sin(AB0/2)) ;%full bend path length (m)
AEB0 =  AB0/2                  ;%edge angles
BX01A={'be' 'BX01' LEFFB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX01B={'be' 'BX01' LEFFB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
BX02A={'be' 'BX02' LEFFB0/2 [AB0/2 GB0/2 AEB0 0 0.45 0 0]}';
BX02B={'be' 'BX02' LEFFB0/2 [AB0/2 GB0/2 0 AEB0 0 0.45 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BX01={'be' 'BX0' LEFFB0 [AB0 GB0/2 AEB0 AEB0 0.45 0.45 0]}';
BX02={'be' 'BX0' LEFFB0 [AB0 GB0/2 AEB0 AEB0 0.45 0.45 0]}';
% BC1
% ===
AB11 =  -0.093575352547    ;%full chicane bend angle (rad) (-0.086753564890323)
RB11 =  LB1/sin(AB11)      ;%bend radius (m)
LB11 =  RB11*AB11          ;%full chicane bend path length (m)
BB11 =  BRHO1/RB11         ;%bend field (kG) (-3.83496008105)
AB11S =  asin((LB1/2)/RB11) ;%"short" half chicane bend angle (rad)
LB11S =  RB11*AB11S         ;%"short" half chicane bend path length (m)
AB11L =  AB11-AB11S         ;%"long" half chicane bend angle (rad)
LB11L =  RB11*AB11L         ;%"long" half chicane bend path length (m)
FB11 =  0.387              ;%fringe field integral
% BX11 gets an offset of 2.2 mm (theta*L/8) towards the wall
% BX12 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% BX13 gets an offset of 2.2 mm (theta*L/8) towards the aisle
% BX14 gets an offset of 2.2 mm (theta*L/8) towards the wall
BX11A={'be' 'BX11' LB11S [+AB11S GB1/2 0 0 FB11 0 0]}';
BX11B={'be' 'BX11' LB11L [+AB11L GB1/2 0 +AB11 0 FB11 0]}';
BX12A={'be' 'BX12' LB11L [-AB11L GB1/2 -AB11 0 FB11 0 0]}';
BX12B={'be' 'BX12' LB11S [-AB11S GB1/2 0 0 0 FB11 0]}';
BX13A={'be' 'BX13' LB11S [-AB11S GB1/2 0 0 FB11 0 0]}';
BX13B={'be' 'BX13' LB11L [-AB11L GB1/2 0 -AB11 0 FB11 0]}';
BX14A={'be' 'BX14' LB11L [+AB11L GB1/2 +AB11 0 FB11 0 0]}';
BX14B={'be' 'BX14' LB11S [+AB11S GB1/2 0 0 0 FB11 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BX11={'be' 'BX1' LB11 [+AB11 GB1/2 0 +AB11 FB11 FB11 0]}';
BX12={'be' 'BX1' LB11 [-AB11 GB1/2 -AB11 0 FB11 FB11 0]}';
BX13={'be' 'BX13' LB11 [-AB11 GB1/2 0 -AB11 FB11 FB11 0]}';
BX14={'be' 'BX14' LB11 [+AB11 GB1/2 +AB11 0 FB11 FB11 0]}';
% magnet-to-magnet path lengths
LD11 =  2.434900                  ;%outer bend-to-bend "Z" distance (m)
LD11O =  LD11/cos(AB11)            ;%outer bend-to-bend path length (m) (minus ~0.15 m 9/21/04)
LD11A =  0.261301                  ;%"Z" distance upstream of SQ13 (m)
LD11B =  LD11-LD11A-0.16*cos(AB11) ;%"Z" distance downstream of SQ13 (m)
LD11OA =  LD11A/cos(AB11)           ;%path length upstream of SQ13
LD11OB =  LD11B/cos(AB11)           ;%path length downstream of SQ13
% BC2
% ===
AB21 =  -0.036971323962    ;%full chicane bend angle (rad)
RB21 =  LB2/sin(AB21)      ;%bend radius (m)
LB21 =  RB21*AB21          ;%full chicane bend path length (m)
BB21 =  BRHO2/RB21         ;%bend field (kG) (-11.229050051323)
AB21S =  asin((LB2/2)/RB21) ;%"short" half chicane bend angle (rad)
LB21S =  RB21*AB21S         ;%"short" half chicane bend path length (m)
AB21L =  AB21-AB21S         ;%"long" half chicane bend angle (rad)
LB21L =  RB21*AB21L         ;%"long" half chicane bend path length (m)
FB21 =  0.633              ;%fringe field integral
% BX21 gets an offset of ~2.3 mm (theta*L/8) towards the wall
% BX22 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% BX23 gets an offset of ~2.3 mm (theta*L/8) towards the aisle
% BX24 gets an offset of ~2.3 mm (theta*L/8) towards the wall
BX21A={'be' 'BX21' LB21S [+AB21S GB2/2 0 0 FB21 0 0]}';
BX21B={'be' 'BX21' LB21L [+AB21L GB2/2 0 +AB21 0 FB21 0]}';
BX22A={'be' 'BX22' LB21L [-AB21L GB2/2 -AB21 0 FB21 0 0]}';
BX22B={'be' 'BX22' LB21S [-AB21S GB2/2 0 0 0 FB21 0]}';
BX23A={'be' 'BX23' LB21S [-AB21S GB2/2 0 0 FB21 0 0]}';
BX23B={'be' 'BX23' LB21L [-AB21L GB2/2 0 -AB21 0 FB21 0]}';
BX24A={'be' 'BX24' LB21L [+AB21L GB2/2 +AB21 0 FB21 0 0]}';
BX24B={'be' 'BX24' LB21S [+AB21S GB2/2 0 0 0 FB21 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BX21={'be' 'BX2' LB21 [+AB21 GB2/2 0 +AB21 FB21 FB21 0]}';
BX22={'be' 'BX2' LB21 [-AB21 GB2/2 -AB21 0 FB21 FB21 0]}';
BX23={'be' 'BX23' LB21 [-AB21 GB2/2 0 -AB21 FB21 FB21 0]}';
BX24={'be' 'BX24' LB21 [+AB21 GB2/2 +AB21 0 FB21 FB21 0]}';
% magnet-to-magnet path lengths
LD21I =  1.0-2*0.1               ;%inner bend-to-bend "Z" distance (m)
LD1 =  2.00-0.04-0.0045        ;%outer bend-to-bend "Z" distance (m)
LD2 =  8.00-0.04-0.0508-0.0045 ;%outer bend-to-bend "Z" distance (m)
LD3 =  8.00-0.04-0.0508-0.0045 ;%outer bend-to-bend "Z" distance (m)
LD4 =  2.00-0.04-0.0045        ;%outer bend-to-bend "Z" distance (m)
LDO1 =  LD1/cos(AB21)           ;%outer bend-to-bend path length (m)
LDO2 =  LD2/cos(AB21)-LQC       ;%outer bend-to-bend path length (m)
LDO3 =  LD3/cos(AB21)-LQC       ;%outer bend-to-bend path length (m)
LDO4 =  LD4/cos(AB21)           ;%outer bend-to-bend path length (m)
% DL1
%  KQA01 :=  -7.474220813631 OLD - no lsr-htr (for commissioning in Dec. '06 through July '07) & on-measured TWSS0
%  KQA02 :=   8.137641193725
%  KQE01 :=  -2.215639104385
%  KQE02 :=  -0.241173314721
%  KQE03 :=   7.613440306134
%  KQE04 :=  -6.985386854286
%  KQA01 := -12.492179751016 OLD - with 5.4-cm lamu lsr-htr and "MATRIX" focusing, but non-measured TWSS0
%  KQA02 :=  11.022504569397
%  KQE01 :=  -3.089332618348
%  KQE02 :=   0.090132722014
%  KQE03 :=   6.822078966488
%  KQE04 :=  -5.731166555613
%  KQA01 := -6.1200 post Aug. 11, 2008 matching based on real measurements with heater/chicane not yet installed (64 & 135 MeV)
%  KQA02 := 12.6808
%  KQE01 := -1.4046
%  KQE02 := -2.4546
%  KQE03 :=  9.6624
%  KQE04 := -7.4610
%  KQA01 := -12.317411498864 new design with laser-heater ON (chicane and und, w/Betx=Bety=12 m), based on measured (back-tracked) TWSS0
%  KQA02 :=  13.706906173749
%  KQE01 :=  -6.538179321052
%  KQE02 :=   5.354060093454
%  KQE03 :=   6.054674881291
%  KQE04 :=  -5.235476556481
% rematched with laser-heater ON (chicane dX= 35 mm)
KQA01 =  -12.315067380182;
KQA02 =   13.705554947598;
KQE01 =   -6.532677301494;
KQE02 =    5.351055993902;
KQE03 =    6.053732882313;
KQE04 =   -5.234073678944;
KQM01 =   15.082997416875;
KQM02 =  -11.969358129236;
KQM03 =   -8.29494541292;
KQM04 =   13.33787357734;
KQB =   22.169715923062;
QA01={'qu' 'QA01' LQX/2 [KQA01 0]}';
QA02={'qu' 'QA02' LQX/2 [KQA02 0]}';
QE01={'qu' 'QE01' LQX/2 [KQE01 0]}';
QE02={'qu' 'QE02' LQX/2 [KQE02 0]}';
QE03={'qu' 'QE03' LQX/2 [KQE03 0]}';
QE04={'qu' 'QE04' LQX/2 [KQE04 0]}';
QM01={'qu' 'QM01' LQX/2 [KQM01 0]}';
QM02={'qu' 'QM02' LQX/2 [KQM02 0]}';
QB={'qu' 'QB' LQE/2 [KQB 0]}';
QM03={'qu' 'QM03' LQX/2 [KQM03 0]}';
QM04={'qu' 'QM04' LQX/2 [KQM04 0]}';
% L1
KQL1 =  3.789198342593;
QFL1={'qu' 'QFL1' LQE/2 [+KQL1 0]}';
QDL1={'qu' 'QDL1' LQE/2 [-KQL1 0]}';
KQA11 =  -KQL1;
KQA12 =   1.831403533749;
QA11={'qu' 'QA11' LQX/2 [KQA11 0]}';
QA12={'qu' 'QA12' LQX/2 [KQA12 0]}';
% BC1
KQ21201 =  -9.394155388085;
KQM11 =   8.000790178508;
KQM12 =  -8.326568628912;
KQM13 =   9.937676628969;
KCQ11 =   0;
KSQ13 =   0;
KCQ12 =   0;
KQ21301 =  -0.1347         ;%turn this quad OFF for LCLS operations (this is meas'd remnant field of Gdl = 0.12 kG)
KQM14 =   7.054168937435;
KQM15 =  -6.723000446327;
Q21201={'qu' 'Q21201' LQE/2 [KQ21201 0]}';%QE-072 after Aug 2006; gets moved downstream of pre-LCLS location by 1.101312 m (measured parallel to main linac axis)
QM11={'qu' 'QM11' LQX/2 [KQM11 0]}';
CQ11={'qu' 'CQ11' LQC/2 [KCQ11 0]}';%now ETB tweaker quad
SQ13={'qu' 'SQ13' 0.16/2 [KSQ13 pi/4]}';%per Kirk Bertsche
CQ12={'qu' 'CQ12' LQC/2 [KCQ12 0]}';%now ETB tweaker quad
QM12={'qu' 'QM12' LQX/2 [KQM12 0]}';
QM13={'qu' 'QM13' LQX/2 [KQM13 0]}';
Q21301={'qu' 'Q21301' LQE/2 [KQ21301 0]}';%QE-004 after Aug 2006; gets moved downstream of pre-LCLS location by 1.247066 m (measured parallel to main linac axis), and turned off for LCLS
QM14={'qu' 'QM14' LQX/2 [KQM14 0]}';
QM15={'qu' 'QM15' LQX/2 [KQM15 0]}';
% L2
KQL2 =  0.708388522907;
QFL2={'qu' 'QFL2' LQE/2 [+KQL2 0]}';
QDL2={'qu' 'QDL2' LQE/2 [-KQL2 0]}';
KQ21401 =   1.030123463078 ;%QE-002 after Aug 2006
KQ21501 =  -0.820757556128 ;%use pre-Aug-2006 Q21201 magnet
KQ21601 =   KQL2                            ;%use pre-Aug-2006 Q21301 magnet
KQ21701 =  -KQL2;
KQ21801 =   0.726696191485;
KQ21901 =  -0.721528926061;
%             reduced W        02SEP2024s       11APR24s       
%           -------------    ---------------  ---------------  
KQ22201 =   0.687187910907 ;% 0.729478096138  0.714603191911 
KQ22301 =  -0.770298864132 ;%-0.792424277218 -0.762188913757 
KQ22401 =   0.754070736025 ;% 0.762744529599  KQL2	       
KQ22501 =  -0.811548538731 ;%-0.783702329103 -KQL2	       
KQ22601 =   0.897539366379 ;% 0.802891109212  KQL2	       
KQ22701 =  -0.870415266281 ;%-0.868130170114 -KQL2	       
KQ22801 =   0.889540338922 ;% 0.953428413209  0.747560469838 
KQ22901 =  -0.748921496431 ;%-0.868765565852 -0.709980930665 
KQ23201 =   0.655708901644 ;% 0.862986236421  0.720791509747 
KQ23301 =  -0.655118539759 ;%-0.807023880128 -0.741851024289 
KQ23401 =   0.567373723115 ;% 0.704995381943  KQL2	       
KQ23501 =  -0.601854348049 ;%-0.682060190951 -KQL2	       
KQ23601 =   0.609161231398 ;% 0.686014709285  KQL2	       
KQ23701 =  -0.646986691345 ;%-0.69035396412  -KQL2	       
KQ23801 =   0.713440057261 ;% 0.759858365272  0.770666348011 
KQ23901 =  -0.716761832821 ;%-0.72048817012  -0.726851638763 
KQ24201 =   0.779293384791;
KQ24301 =  -0.856497177248;
KQ24401 =   1.024817869713;
KQ24501 =  -0.954003584585;
KQ24601 =   0.608135546584;
Q21401={'qu' 'Q21401' LQE/2 [KQ21401 0]}';
Q21501={'qu' 'Q21501' LQE/2 [KQ21501 0]}';
Q21601={'qu' 'Q21601' LQE/2 [KQ21601 0]}';
Q21701={'qu' 'Q21701' LQE/2 [KQ21701 0]}';
Q21801={'qu' 'Q21801' LQE/2 [KQ21801 0]}';
Q21901={'qu' 'Q21901' LQE/2 [KQ21901 0]}';
Q22201={'qu' 'Q22201' LQE/2 [KQ22201 0]}';
Q22301={'qu' 'Q22301' LQE/2 [KQ22301 0]}';
Q22401={'qu' 'Q22401' LQE/2 [KQ22401 0]}';
Q22501={'qu' 'Q22501' LQE/2 [KQ22501 0]}';
Q22601={'qu' 'Q22601' LQE/2 [KQ22601 0]}';
Q22701={'qu' 'Q22701' LQE/2 [KQ22701 0]}';
Q22801={'qu' 'Q22801' LQE/2 [KQ22801 0]}';
Q22901={'qu' 'Q22901' LQE/2 [KQ22901 0]}';
Q23201={'qu' 'Q23201' LQE/2 [KQ23201 0]}';
Q23301={'qu' 'Q23301' LQE/2 [KQ23301 0]}';
Q23401={'qu' 'Q23401' LQE/2 [KQ23401 0]}';
Q23501={'qu' 'Q23501' LQE/2 [KQ23501 0]}';
Q23601={'qu' 'Q23601' LQE/2 [KQ23601 0]}';
Q23701={'qu' 'Q23701' LQE/2 [KQ23701 0]}';
Q23801={'qu' 'Q23801' LQE/2 [KQ23801 0]}';
Q23901={'qu' 'Q23901' LQE/2 [KQ23901 0]}';
Q24201={'qu' 'Q24201' LQE/2 [KQ24201 0]}';
Q24301={'qu' 'Q24301' LQE/2 [KQ24301 0]}';
Q24401={'qu' 'Q24401' LQE/2 [KQ24401 0]}';
Q24501={'qu' 'Q24501' LQE/2 [KQ24501 0]}';
Q24601={'qu' 'Q24601' LQE/2 [KQ24601 0]}';
% BC2
KQ24701 =  -1.307122793026;
KQM21 =   0.511895916574;
KCQ21 =   0;
KCQ22 =   0;
KQM22 =  -0.589455717616;
KQ24901 =   1.081452709118;
Q24701A={'qu' 'Q24701A' LQE/2 [KQ24701 0]}';%in same location as pre-LCLS (with its BPM)
Q24701B={'qu' 'Q24701B' LQE/2 [KQ24701 0]}';%10 cm between Q24701A & B
QM21={'qu' 'QM21' LQF/2 [KQM21 0]}';
CQ21={'qu' 'CQ21' LQC/2 [KCQ21 0]}';
CQ22={'qu' 'CQ22' LQC/2 [KCQ22 0]}';
QM22={'qu' 'QM22' LQF/2 [KQM22 0]}';
Q24901A={'qu' 'Q24901A' LQE/2 [KQ24901 0]}';%moved 2.397400 m downstream of original Q24901 position
Q24901B={'qu' 'Q24901B' LQE/2 [KQ24901 0]}';%10 cm between Q24901A & B (BPM in this 2nd quad)
% L3
%  KQFL3 :=  0.446670469684 was used for 12*2*pi MUX from BX24 to BX31
%  KQDL3 := -0.424793498653 was used for 12*2*pi MUX from BX24 to BX31
KQFL3 =   0.395798933782  ;%gives psix = 50.76 deg, 44.64 deg, 45.00 deg between four LI28 wires
KQDL3 =  -0.395649286346  ;%gives TCAV3 -> OTR30 right + WS28 psiy: 48.96 deg, 45.72 deg, 43.92 deg
QFL3={'qu' 'QFL3' LQE/2 [KQFL3 0]}';
QDL3={'qu' 'QDL3' LQE/2 [KQDL3 0]}';
KQ25201 =   0.69835390233;
KQ25301 =  -0.479854531304;
KQ25401 =   0.429832166012;
KQ25501 =  -0.400216279825;
KQ25601 =   KQFL3;
KQ25701 =   KQDL3;
KQ25801 =   0.407524461523;
KQ25901 =  -0.38867870418;
KQ26201 =   0.388844133085;
KQ26301 =  -0.405381176356;
KQ26401 =   KQFL3;
KQ26501 =   KQDL3;
KQ26601 =   KQFL3;
KQ26701 =   KQDL3;
KQ26801 =   0.406007960598;
KQ26901 =  -0.388769548432;
KQ27201 =   0.391071563294;
KQ27301 =  -0.407171874797;
KQ27401 =   KQFL3;
KQ27501 =   KQDL3;
KQ27601 =   KQFL3;
KQ27701 =   KQDL3;
KQ27801 =   0.40682165023;
KQ27901 =  -0.389505138741;
KQ28201 =   0.390810721273;
KQ28301 =  -0.406510005482;
KQ28401 =   KQFL3;
KQ28501 =   KQDL3;
KQ28601 =   KQFL3;
KQ28701 =   KQDL3;
KQ28801 =   0.406821689691;
KQ28901 =  -0.389505198882;
KQ29201 =   0.390810639876;
KQ29301 =  -0.40650981716;
KQ29401 =   KQFL3;
KQ29501 =   KQDL3;
KQ29601 =   KQFL3;
KQ29701 =   KQDL3;
KQ29801 =   0.406747754958;
KQ29901 =  -0.389374252182;
KQ30201 =   0.390540048432;
KQ30301 =  -0.406220459812;
KQ30401 =   KQFL3;
KQ30501 =   KQDL3;
KQ30601 =   KQFL3;
%KQ30701 :=  see LTU.xsif
%KQ30801 :=  see LTU.xsif
Q25201={'qu' 'Q25201' LQE/2 [KQ25201 0]}';
Q25301={'qu' 'Q25301' LQE/2 [KQ25301 0]}';
Q25401={'qu' 'Q25401' LQE/2 [KQ25401 0]}';
Q25501={'qu' 'Q25501' LQE/2 [KQ25501 0]}';
Q25601={'qu' 'Q25601' LQE/2 [KQ25601 0]}';
Q25701={'qu' 'Q25701' LQE/2 [KQ25701 0]}';
Q25801={'qu' 'Q25801' LQE/2 [KQ25801 0]}';
Q25901={'qu' 'Q25901' LQE/2 [KQ25901 0]}';
Q26201={'qu' 'Q26201' LQE/2 [KQ26201 0]}';
Q26301={'qu' 'Q26301' LQE/2 [KQ26301 0]}';
Q26401={'qu' 'Q26401' LQE/2 [KQ26401 0]}';
Q26501={'qu' 'Q26501' LQE/2 [KQ26501 0]}';
Q26601={'qu' 'Q26601' LQE/2 [KQ26601 0]}';
Q26701={'qu' 'Q26701' LQE/2 [KQ26701 0]}';
Q26801={'qu' 'Q26801' LQE/2 [KQ26801 0]}';
Q26901={'qu' 'Q26901' LQE/2 [KQ26901 0]}';
Q27201={'qu' 'Q27201' LQE/2 [KQ27201 0]}';
Q27301={'qu' 'Q27301' LQE/2 [KQ27301 0]}';
Q27401={'qu' 'Q27401' LQE/2 [KQ27401 0]}';
Q27501={'qu' 'Q27501' LQE/2 [KQ27501 0]}';
Q27601={'qu' 'Q27601' LQE/2 [KQ27601 0]}';
Q27701={'qu' 'Q27701' LQE/2 [KQ27701 0]}';
Q27801={'qu' 'Q27801' LQE/2 [KQ27801 0]}';
Q27901={'qu' 'Q27901' LQE/2 [KQ27901 0]}';
Q28201={'qu' 'Q28201' LQE/2 [KQ28201 0]}';
Q28301={'qu' 'Q28301' LQE/2 [KQ28301 0]}';
Q28401={'qu' 'Q28401' LQE/2 [KQ28401 0]}';
Q28501={'qu' 'Q28501' LQE/2 [KQ28501 0]}';
Q28601={'qu' 'Q28601' LQE/2 [KQ28601 0]}';
Q28701={'qu' 'Q28701' LQE/2 [KQ28701 0]}';
Q28801={'qu' 'Q28801' LQE/2 [KQ28801 0]}';
Q28901={'qu' 'Q28901' LQE/2 [KQ28901 0]}';
Q29201={'qu' 'Q29201' LQE/2 [KQ29201 0]}';
Q29301={'qu' 'Q29301' LQE/2 [KQ29301 0]}';
Q29401={'qu' 'Q29401' LQE/2 [KQ29401 0]}';
Q29501={'qu' 'Q29501' LQE/2 [KQ29501 0]}';
Q29601={'qu' 'Q29601' LQE/2 [KQ29601 0]}';
Q29701={'qu' 'Q29701' LQE/2 [KQ29701 0]}';
Q29801={'qu' 'Q29801' LQE/2 [KQ29801 0]}';
Q29901={'qu' 'Q29901' LQE/2 [KQ29901 0]}';
Q30201={'qu' 'Q30201' LQE/2 [KQ30201 0]}';
Q30301={'qu' 'Q30301' LQE/2 [KQ30301 0]}';
Q30401={'qu' 'Q30401' LQE/2 [KQ30401 0]}';
Q30501={'qu' 'Q30501' LQE/2 [KQ30501 0]}';
Q30601={'qu' 'Q30601' LQE/2 [KQ30601 0]}';
Q30615A={'mo' 'Q30615A' 0 []}';%power supply decommissioned
Q30615B={'mo' 'Q30615B' 0 []}';%power supply decommissioned
Q30615C={'mo' 'Q30615C' 0 []}';%power supply decommissioned
Q30701={'qu' 'Q30701' LQE/2 [KQ30701 0]}';
Q30715A={'mo' 'Q30715A' 0 []}';%power supply decommissioned
Q30715B={'mo' 'Q30715B' 0 []}';%power supply decommissioned
Q30715C={'mo' 'Q30715C' 0 []}';%power supply decommissioned
Q30801={'qu' 'Q30801' LQE/2 [KQ30801 0]}';
% ==============================================================================
% DRIFTs
% ------------------------------------------------------------------------------
% L1/2/3 FODO cells
D9={'dr' '' DLWL9 []}';
D10={'dr' '' DLWL10 []}';
DAQ1={'dr' '' 0.0342 []}';
DAQ2={'dr' '' 0.027 []}';
% injector geometry
LGGUN =  7.51*0.3048;
LGL0 =  2*3.0441+1.0;
LGBEND =  0.95 + 2*0.3048     ;% add 12" to either side of QB for more room (22JAN04 - PE)
LGEMIT =  9.000328707307;
LGMATCH =  1.5134597681;
DGGUN={'dr' '' LGGUN []}';
DGL0={'dr' '' LGL0 []}';
% L0
LOADLOCK={'dr' '' LGGUN-1.42 []}';
DL00={'dr' '' -LOADLOCK{3} []}';%from cathode back to u/s end of loadlock
DL01A={'dr' '' 0.19601-LSOL1/2 []}';
DL01A1={'dr' '' 0.07851 []}';
DL01A2={'dr' '' 0.11609 []}';
DL01A3={'dr' '' 0.10461 []}';
DL01A4={'dr' '' 0.0170+0.0014 []}';
DL01A5={'dr' '' 0.0132-0.00223 []}';
DL01B={'dr' '' 0.0825 []}';
DL01C={'dr' '' 0.1340-0.00353-0.003175 []}';
DL01D={'dr' '' 0.1008464-0.0155757 []}';
DL01H={'dr' '' 0.0581886 []}';
DL01E={'dr' '' 0.2286-DXG0{3}-0.00536+0.0155757 []}';
DL01F={'dr' '' 0.1353+0.00708 []}';
DL01F2={'dr' '' 0.0277+0.00167 []}';
DL01G={'dr' '' 0.0740-0.00341 []}';
DL02A1={'dr' '' 0.060294605 []}';%0.066356+0.0021436-0.008205
DL02A2={'dr' '' 0.104580+0.008205 []}';
DL02A3={'dr' '' 0.098776-LQX/2+0.028834 []}';
DL02B1={'dr' '' 0.169672-LQX/2-0.028834+0.007646 []}';
DL02B2={'dr' '' 0.185928-LQX/2-0.007646+0.001610 []}';
DL02C={'dr' '' 0.121498-LQX/2-0.001610 []}';
% Heater-Chicane:
LSRHTR_ON =  1 ;%set to 0 for laser heater bends & undulator OFF and 1 for ON (nominal)
ABH1 =  -0.131709391614*LSRHTR_ON ;%heater-chicane bend angle (rad)
BBH1 =  BRHOI*sin(ABH1)/LBH ;%heater-chicane bend field for 35-mm etaX_pk (kG) (-4.75393301417)
RBH1 =  BRHOI/BBH1          ;%heater-chicane bend radius (m)
LBH1 =  RBH1*ABH1           ;%heater-chicane bend path length (m)
ABH1S =  asin((LBH/2)/RBH1)  ;%"short" half heater-chicane bend angle (rad)
LBH1S =  RBH1*ABH1S          ;%"short" half heater-chicane bend path length (m)
ABH1L =  ABH1-ABH1S          ;%"long" half heater-chicane bend angle (rad)
LBH1L =  RBH1*ABH1L          ;%"long" half heater-chicane bend path length (m)
DH00={'dr' '' 0.13453045-DLBH/2 []}';
DH01={'dr' '' (0.155-DLBH)/cos(ABH1) []}';
DH02A={'dr' '' 0.06717020-DLBH/2 []}';
DH03A={'dr' '' 0.09290825 []}';
DH03B={'dr' '' 0.08401830 []}';
DH02B={'dr' '' 0.09503020-DLBH/2 []}';
DH06={'dr' '' 0.13010070-DLBH/2 []}';
HTRUND={'mo' 'HTRUND' 0 []}';
BXH1A={'be' 'BXH1' LBH1S [+ABH1S GBH/2 0 0 0.400 0 0]}';
BXH1B={'be' 'BXH1' LBH1L [+ABH1L GBH/2 0 +ABH1 0 0.400 0]}';
BXH2A={'be' 'BXH2' LBH1L [-ABH1L GBH/2 -ABH1 0 0.400 0 0]}';
BXH2B={'be' 'BXH2' LBH1S [-ABH1S GBH/2 0 0 0 0.400 0]}';
BXH3A={'be' 'BXH3' LBH1S [-ABH1S GBH/2 0 0 0.400 0 0]}';
BXH3B={'be' 'BXH3' LBH1L [-ABH1L GBH/2 0 -ABH1 0 0.400 0]}';
BXH4A={'be' 'BXH4' LBH1L [+ABH1L GBH/2 +ABH1 0 0.400 0 0]}';
BXH4B={'be' 'BXH4' LBH1S [+ABH1S GBH/2 0 0 0 0.400 0]}';
% define unsplit SBENs for BMAD ... not used by MAD
BXH1={'be' 'BXH' LBH1 [+ABH1 GBH/2 0 +ABH1 0.400 0.400 0]}';
BXH2={'be' 'BXH' LBH1 [-ABH1 GBH/2 -ABH1 0 0.400 0.400 0]}';
BXH3={'be' 'BXH3' LBH1 [-ABH1 GBH/2 0 -ABH1 0.400 0.400 0]}';
BXH4={'be' 'BXH4' LBH1 [+ABH1 GBH/2 +ABH1 0 0.400 0.400 0]}';
% Laser-Heater Undulator Model:
LAM =  0.054                            ;%laser-heater undulator period [m]
LAMR =  758E-9                           ;%heater laser wavelength [m]
GAMI =  EI/MC2                           ;%Lorentz energy factor in laser-heater undulator [ ]
K_UND =  LSRHTR_ON*sqrt(2*(LAMR*2*GAMI^2/LAM - 1)) ;%undulator K for laser heater und.
LHUN =  0.506263                         ;%length of laser-heater undulator
LHUNH =  LHUN/2;
KQLH =  (K_UND*2*PI/LAM/sqrt(2)/GAMI)^2  ;%natural undulator focusing "k" in y-plane [m^-2]
% handle K_und->0 by expressing R34 as an approximate SINC function
ARGH =  LHUNH*sqrt(KQLH);
ARGH2 =  ARGH*ARGH;
ARGH4 =  ARGH2*ARGH2;
ARGH6 =  ARGH4*ARGH2;
SINCARGH =  1-ARGH2/6+ARGH4/120-ARGH6/5040 ;%~sinc(ARGh)=sin(ARGh)/ARGh
R34H =  LHUNH*SINCARGH;
% laser-heater undulator modeled as R-matrix to include vertical natural focusing:
LH_UND={'un' 'LH_UND' LHUNH [KQLH LAM 1]}';%,          &
%RM(5,6) =  Lhunh/(gami^2)*(1+(K_und^2)/2)
%VALUE, gami,kqlh,K_und
%VALUE, LH_UND[RM(1,2)],Lhun/2
%VALUE, LH_UND[RM(3,3)],cos(Lhun/2*sqrt(kqlh))
%VALUE, LH_UND[RM(3,4)],sin(Lhun/2*sqrt(kqlh))/sqrt(kqlh)
%VALUE, LH_UND[RM(4,3)],-sin(Lhun/2*sqrt(kqlh))*sqrt(kqlh)
%VALUE, LH_UND[RM(4,4)],cos(Lhun/2*sqrt(kqlh))
%VALUE, LH_UND[RM(5,6)],Lhun/2/(gami^2)*(1+(K_und^2)/2)
LHBEG={'mo' 'LHBEG' 0 []}';
LHEND={'mo' 'LHEND' 0 []}';
% DL1
LWS01_03 =   3.827458          ;%distance from WS01 to WS03 wire centers [m] (changed 06MAY05 -PE)
BMIN0 =  LWS01_03/sqrt(3)/2 ;%betaX=betaY at WS02 where waist is located (12NOV03 -PE)
%VALUE, BMIN0
MRK0={'mo' 'MRK0' 0 []}';
DE00={'dr' '' 0.024994 []}';
DE00A={'dr' '' 0.070613-LQX/2 []}';
DE01A={'dr' '' 0.130373-LQX/2 []}';
DE01B={'dr' '' 0.176359-LQX/2 []}';
DE01C={'dr' '' 0.094781 []}';
DE02={'dr' '' 0.0897395-LQX/2 []}';
DE03A={'dr' '' 0.16832-LQX/2 []}';
DE03B={'dr' '' 0.047581 []}';
DE03C={'dr' '' 0.190499-LQX/2 []}';
DE04={'dr' '' 0.197688-LQX/2 []}';
DE05={'dr' '' 0.151968 []}';
DE05A={'dr' '' DE05{3}/2 []}';
DE05C={'dr' '' 0.104470 []}';
DE06B={'dr' '' 0.2478024 []}';
DE06A={'dr' '' LWS01_03/2-DE05{3}-DE05C{3}-DE06B{3} []}';
DE06D={'dr' '' 0.1638307 []}';
DE06E={'dr' '' LWS01_03/2-DE05{3}-DE06D{3} []}';
DE07={'dr' '' 0.2045007-LQX/2+0.305E-3 []}';
DE08={'dr' '' 0.2318721-LQX/2-0.03 []}';
DE08A={'dr' '' 0.153330+0.03 []}';
DE08B={'dr' '' 0.170620-LQX/2 []}';
DE09={'dr' '' 0.27745-LQX/2 []}';
DLDB00 =  -0.54842233769E-6;
DB00A={'dr' '' 0.3997+DLDB00 []}';
DB00B={'dr' '' 0.161 []}';
DB00C={'dr' '' 0.2191-LQE/2 []}';
DB00D={'dr' '' 0.342-LQE/2 []}';
DB00E={'dr' '' 0.4378+DLDB00 []}';
DLDM00 =  2*abs(DLDB00)*cos(ADL1/2);
DM00={'dr' '' 0.203400-ZOFFINJ+0.03+DLDM00 []}';% move entire injector ~12 mm dntr. (Nov. 17, 2004 - PE)
DM00A={'dr' '' 0.224683-LQX/2-0.03 []}';
DM01={'dr' '' 0.142367-LQX/2 []}';
DM01A={'dr' '' 0.262800-LQX/2 []}';
DM02={'dr' '' 0.194200-LQX/2 []}';
DM02A={'dr' '' 0.157448 []}';
% L1
DAQA1={'dr' '' 0.033450+DZ_QA11 []}';
DAQA2={'dr' '' 0.033450-DZ_QA11 []}';
DAQA3={'dr' '' 0.033450 []}';
DAQA4={'dr' '' 0.033450 []}';
% BC1
LWW1 =  1.656196     ;% WS11-12 drift length and therefore ~ beam size
BMIN1 =  LWW1/sqrt(3) ;% betaX,Y at WS12
DL1XA={'dr' '' 0.093369 []}';
DL1XB={'dr' '' 0.2 []}';
DM10A={'dr' '' 0.227400-0.022322 []}';
DM10C={'dr' '' 0.122322+DZ_Q21201 []}';
DM10X={'dr' '' 0.083617-DZ_Q21201 []}';
DM11={'dr' '' 0.272500+0.006383 []}';
DM12={'dr' '' 0.127801 []}';
DBQ1={'dr' '' (0.400381-LB1/2-LQC/2)/cos(AB11) []}';
D11O={'dr' '' LD11O-(DBQ1{3}+LQC)-2E-7 []}';
D11OA={'dr' '' LD11OA []}';
D11OB={'dr' '' LD11OB-(DBQ1{3}+LQC)-2E-7 []}';
DDG0={'dr' '' 0.1698-0.084915+0.0508-0.0045 []}';%additional drift in BC2 center prior to diag. package
DDGA={'dr' '' 0.084915+0.0508-0.0045 []}';%additional drift in BC2 center prior to diag. package
DDG1={'dr' '' 0.2891-0.04046 []}';%BC1 and BC2 diag. package drifts (BX*2B to BPM)
DDG2={'dr' '' 0.1240+0.04046 []}';%BC1 and BC2 diag. package drifts (BPM to CE)
DDG3={'dr' '' 0.1460+0.036606 []}';%BC1 and BC2 diag. package drifts (CE to OTR)
DDG4={'dr' '' 0.2711-0.036606 []}';%BC1 and BC2 diag. package drifts (OTR to BX*3A)
DM13A={'dr' '' 0.323450/2 []}';
DM13B={'dr' '' 0.323450/2 []}';
DM14A={'dr' '' 0.25-0.07615 []}';
DM14B={'dr' '' 0.15638875-0.0254+0.07615 []}';
DM14C={'dr' '' 0.15638875+0.0254 []}';
DM15A={'dr' '' 0.252872-0.1524 []}';
DM15B={'dr' '' 0.2836740-0.0826 []}';
DM15C={'dr' '' 0.1524+0.0826 []}';
DWW1A={'dr' '' LWW1 []}';
DWW1B={'dr' '' 0.295 []}';
DWW1C1={'dr' '' 0.812030-0.295-0.1017 []}';
DWW1C2={'dr' '' LWW1-1.427096+0.1017-0.0142-0.014199 []}';
DWW1D={'dr' '' 0.346099 []}';
DWW1E={'dr' '' 0.297366 []}';
DM16={'dr' '' 0.25+DZ_Q21301 []}';
DM17A={'dr' '' 0.2658341-DZ_Q21301 []}';
DM16A={'dr' '' 0.0 []}';
DM16B={'dr' '' 0.0 []}';
DM17B={'dr' '' 0.4008829 []}';
DM17C={'dr' '' 0.385417+DZ_QM14 []}';
DM18A={'dr' '' 0.228300-DZ_QM14 []}';
DM18B={'dr' '' 0.228200+DZ_QM15 []}';
DM19={'dr' '' 0.099400-DZ_QM15+0.000001 []}';%force Z=2059.732900 m at ZLIN04
% L2 and L3
DAQ3={'dr' '' 0.3533 []}';
DAQ4={'dr' '' 2.5527 []}';
DAQ5={'dr' '' 2.841-0.3048-1.2192 []}';
DAQ6={'dr' '' 0.2373 []}';
DAQ7={'dr' '' 0.2748 []}';
DAQ8={'dr' '' 2.6312 []}';
DAQ8A={'dr' '' 0.5+0.003200 []}';
DAQ8B={'dr' '' 2.1312-0.003200 []}';
DAQ12={'dr' '' 0.2286 []}';
DAQ13={'dr' '' 0.0231 []}';
DAQ14={'dr' '' 0.2130 []}';
DAQ15={'dr' '' 0.0087 []}';
DAQ16={'dr' '' 0.2274 []}';
DAQ17={'dr' '' 0.061900 []}';%30-8c exit to IV30-9
D255A={'dr' '' 0.06621-0.001510 []}';
D255B={'dr' '' 0.11184+0.001510 []}';
D255C={'dr' '' 0.17805-0.275500+0.25 []}';
D255D={'dr' '' 0.03420+0.275500 []}';
D256A={'dr' '' 2.350-1.1919-0.559100 []}';
D256B={'dr' '' 0.559100 []}';
D256C={'dr' '' 0.61475 []}';%0.540500-0.40505
D256D={'dr' '' 0.21115 []}';
% BC2
DM21Z={'dr' '' 0.0828006-0.027 []}';
DM21A={'dr' '' 0.3199994 []}';
DM21H={'dr' '' 0.193 []}';
DM21B={'dr' '' 0.6340002 []}';
DM21C={'dr' '' 0.3202404 []}';
DM21D={'dr' '' 0.139536 []}';
DM21E={'dr' '' 0.1996034-0.0045 []}';
DM20={'dr' '' 0.034200 []}';
DBQ2A={'dr' '' LDO1 []}';
D21OA={'dr' '' LDO2 []}';
D21I={'dr' '' LD21I/2 []}';
D21OB={'dr' '' LDO3 []}';
DBQ2B={'dr' '' LDO4 []}';
D21W={'dr' '' 0.311000-0.0045 []}';
D21X={'dr' '' 0.208700 []}';
D21Y={'dr' '' 0.114235 []}';
DM23B={'dr' '' 0.050405 []}';
DM24A={'dr' '' 0.129440 []}';
DM24B={'dr' '' 0.178000 []}';
DM24D={'dr' '' 0.070700 []}';
DM24C={'dr' '' 0.106300 []}';
DM25={'dr' '' 0.160400 []}';
% ==============================================================================
% MARKERs
% ------------------------------------------------------------------------------
% wire scanners
WS01={'mo' 'WS01' 0 []}';%DL1- emittance
WS02={'mo' 'WS02' 0 []}';%DL1- emittance
WS03={'mo' 'WS03' 0 []}';%DL1- emittance
WS04={'mo' 'WS04' 0 []}';%DL1- energy spread
WS11={'mo' 'WS11' 0 []}';%BC1+ emittance
WS12={'mo' 'WS12' 0 []}';%BC1+ emittance
WS13={'mo' 'WS13' 0 []}';%BC1+ emittance
%WS21    : WIRE, TYPE="slow" LI24 emittance
%WS22    : WIRE, TYPE="slow" LI24 emittance
%WS23    : WIRE, TYPE="slow" LI24 emittance
WS24={'mo' 'WS24' 0 []}';%BC2- emittance
DWS21={'mo' 'DWS21' 0 []}';%someday will be a wire-scanner again?
DWS22={'mo' 'DWS22' 0 []}';%someday will be a wire-scanner again?
DWS23={'mo' 'DWS23' 0 []}';%someday will be a wire-scanner again?
%DWS24   : MARK              someday will be a wire-scanner again?
WS27644={'mo' 'WS27644' 0 []}';%LI27 emittance (existing; moved)
WS28144={'mo' 'WS28144' 0 []}';%LI28 emittance
WS28444={'mo' 'WS28444' 0 []}';%LI28 emittance
WS28744={'mo' 'WS28744' 0 []}';%LI28 emittance (existing; moved)
% profile monitors
YAG01={'mo' 'YAG01' 0 []}';%gun (15.5 in from cathode, per J. Schmerge, June 17, 2003; -PE)
YAG02={'mo' 'YAG02' 0 []}';%gun (need proper positions still - June 10, 2003)
YAG03={'mo' 'YAG03' 0 []}';%after L0-a (~ 60 MeV) - center of device in MAD is defined as center of YAG crystal, not mirror
YAG04={'mo' 'YAG04' 0 []}';%temporarily (Dec. '06 - July '07) placed in laser-heater region (135 MeV) - center of device in MAD is defined as center of YAG crystal, not mirror
PH01={'mo' 'PH01' 0 []}';%phase measurement RF cavity between L0-a and L0-b
PH02={'mo' 'PH02' 0 []}';%phase measurement RF cavity after BC1
PH03={'mo' 'PH03' 0 []}';%phase measurement RF cavity after BC2
VV01={'mo' 'VV01' 0 []}';%vacuum valve near gun
VV02={'mo' 'VV02' 0 []}';%vacuum valve in injector
VV03={'mo' 'VV03' 0 []}';%vacuum valve in injector
VV04={'mo' 'VV04' 0 []}';%vacuum valve in injector
VVX1={'mo' 'VVX1' 0 []}';%vacuum valve before X-band structure
VVX2={'mo' 'VVX2' 0 []}';%vacuum valve after X-band structure
VV21={'mo' 'VV21' 0 []}';%vacuum valve in front of BC2
VV22={'mo' 'VV22' 0 []}';%vacuum valve after BC2
RST1={'mo' 'RST1' 0 []}';%radiation stopper near WS02 in injector
OTRH1={'mo' 'OTRH1' 0 []}';%Laser-heater OTR screen just upbeam of heater-undulator (12NOV03 - PE)
OTRH2={'mo' 'OTRH2' 0 []}';%Laser-heater OTR screen just dnbeam of heater-undulator (12NOV03 - PE)
%DOTRH1   : MARK             Laser-heater OTR screen PLACE-HOLDER just upbeam of heater-undulator (not installed until summer 2008)
%DOTRH2   : MARK             Laser-heater OTR screen PLACE-HOLDER just dnbeam of heater-undulator (not installed until summer 2008)
OTR1={'mo' 'OTR1' 0 []}';%DL1-emit
OTR2={'mo' 'OTR2' 0 []}';%DL1-emit
OTR3={'mo' 'OTR3' 0 []}';%DL1-emit
OTR4={'mo' 'OTR4' 0 []}';%DL1 slice and proj. energy spread
OTR11={'mo' 'OTR11' 0 []}';%BC1 energy spread
OTR12={'mo' 'OTR12' 0 []}';%BC1 emittance
OTR21={'mo' 'OTR21' 0 []}';%BC2 energy spread
%OTR22    : PROF, TYPE="OTR" moved to XLEAP (February 2017)
OTR_TCAV={'mo' 'OTR_TCAV' 0 []}';%LI25 longitudinal diagnostics
% bunch length monitors
BL11={'mo' 'BL11' 0 []}';%BC1+ (CSR-based relative bunch length monitor)
BL12={'mo' 'BL12' 0 []}';%BC1+ (ceramic gap-based relative bunch length monitor)
BL21={'mo' 'BL21' 0 []}';%BC2+ (CSR-based relative bunch length monitor)
BL22={'mo' 'BL22' 0 []}';%BC2+ (ceramic gap-based relative bunch length monitor)
% bunch charge monitors (toroids)
IM01={'mo' 'IM01' 0 []}';%L0
IM02={'mo' 'IM02' 0 []}';%L0
IM03={'mo' 'IM03' 0 []}';%DL1-
IMBC1I={'mo' 'IMBC1I' 0 []}';%BC1 input toriod (comparator with IMBC1O)
IMBC1O={'mo' 'IMBC1O' 0 []}';%BC1 output toroid (comparator with IMBC1I)
IMBC2I={'mo' 'IMBC2I' 0 []}';%BC2 input toroid (comparator with IMBC2O)
IMBC2O={'mo' 'IMBC2O' 0 []}';%BC2 output toroid (comparator with IMBC2I)
% other diagnostics
FC01={'mo' 'FC01' 0 []}';%L0 Faraday cup w/screen
AM00={'mo' 'AM00' 0 []}';%gun laser normal incidence mirror
AM01={'mo' 'AM01' 0 []}';%alignment mirror
CR01={'mo' 'CR01' 0 []}';%Cerenkov radiator bunch length monitor
% collimators
CE11={'dr' 'CE11' 0 []}';%adjustable energy (x) collimator in middle of BC1 chicane
CE21={'dr' 'CE21' 0 []}';%adjustable energy (x) collimator in middle of BC2 chicane
% dumps
TD11={'mo' 'TD11' 0 []}';%BC1+ insertable block
% miscellany
SOL1BK={'so' 'SOL1BK' 0 [0]}';%gun-bucking-solenoid (set to zero length and strength, with longitudinal unknown for now)
CATHODE={'mo' 'CATHODE' 0 []}';
SOL1={'so' 'SOL1' LSOL1/2 [0]}';%gun-solenoid (set to zero strength)
SOL2={'so' 'SOL2' 0 [0]}';%2nd-solenoid (set to zero length and strength, with longitudinal position as the actual solenoid's center)
L0AWAKE={'mo' 'L0AWAKE' 0 []}';
EMAT={'mo' 'EMAT' 0 []}';%for Elegant only to remove energy error in DL1 bends
DLFDA={'mo' 'DLFDA' 0 []}';%dual-feed input coupler location at start of L0-a RF structure
L0AMID={'mo' 'L0AMID' 0 []}';
OUTCPA={'mo' 'OUTCPA' 0 []}';%output coupler location at end of L0-a RF structure
L0BBEG={'mo' 'L0BBEG' 0 []}';
DLFDB={'mo' 'DLFDB' 0 []}';%dual-feed input coupler location at start of L0-b RF structure
L0BMID={'mo' 'L0BMID' 0 []}';
OUTCPB={'mo' 'OUTCPB' 0 []}';%output coupler location at end of L0-b RF structure
CNT0={'mo' 'CNT0' 0 []}';
XBEG={'mo' 'XBEG' 0 []}';%before X-band RF, but after L1
XEND={'mo' 'XEND' 0 []}';%after X-band RF, but before BC1
BC1CBEG={'mo' 'BC1CBEG' 0 []}';%start of BC1 chicane
CNT1={'mo' 'CNT1' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC1CEND={'mo' 'BC1CEND' 0 []}';%end of BC1 chicane
LI21BEG={'mo' 'LI21BEG' 0 []}';
LI21END={'mo' 'LI21END' 0 []}';
LI22BEG={'mo' 'LI22BEG' 0 []}';
LI22END={'mo' 'LI22END' 0 []}';
LI23BEG={'mo' 'LI23BEG' 0 []}';
LI23END={'mo' 'LI23END' 0 []}';
LI24BEG={'mo' 'LI24BEG' 0 []}';
LI24TERM={'mo' 'LI24TERM' 0 []}';%LI24 stops here ... the rest is BC2
BC2CBEG={'mo' 'BC2CBEG' 0 []}';%start of BC2 chicane
CNT2={'mo' 'CNT2' 0 []}';%ELEGANT will correct the orbit here for CSR-steering
BC2CEND={'mo' 'BC2CEND' 0 []}';%end of BC2 chicane
LI25BEG={'mo' 'LI25BEG' 0 []}';
LI25END={'mo' 'LI25END' 0 []}';
LI26BEG={'mo' 'LI26BEG' 0 []}';
LI26END={'mo' 'LI26END' 0 []}';
LI27BEG={'mo' 'LI27BEG' 0 []}';
LI27END={'mo' 'LI27END' 0 []}';
LI28BEG={'mo' 'LI28BEG' 0 []}';
LI28END={'mo' 'LI28END' 0 []}';
LI29BEG={'mo' 'LI29BEG' 0 []}';
LI29END={'mo' 'LI29END' 0 []}';
LI30BEG={'mo' 'LI30BEG' 0 []}';
LI30TERM={'mo' 'LI30TERM' 0 []}';%LI30 stops here ... the rest is part of the BSY reconfiguration
% Permanent reference points in the linac (and LTU: Z') Z-coordinate system (in meters)
% (NOTE: Z' is measured parallel to the undulator axis which is at an angle of
% 2*AVB [=4.668514 mrad on May 4, 2004] w.r.t. the linac axis):
% (Note Q20-901 is at 2029.4060 m in drawing ID-380-802-00 pg. 2 - this does not agree
%  with Woodley/Seeman database at 2029.3939 m.  We assume drawing is right -PE, June 11, 2004)
% ============================================================================================
ZLIN00={'mo' 'ZLIN00' 0 []}';%face of L0-a entrance flange : Z=2019.106625 (= 1.459000 m from cathode parallel to injector line, X = 9.612087)
% DBMARK98 : MARK (135SPECT)135-MeV spect. dump: Z=2036.774471
ZLIN01={'mo' 'ZLIN01' 0 []}';%entrance to 21-1b            : Z=2035.035130 (= 20*101.600 m + 3.0441 m - 0.00897 m: 8/1/05)
ZLIN02={'mo' 'ZLIN02' 0 []}';%center of QUAD LI21 201      : (not used anymore since Q21201 is a few mm off) [was Z=2045.436400 pre 1/11/07]
ZLIN03={'mo' 'ZLIN03' 0 []}';%center of QUAD LI21 301      : (not used anymore since Q21301 is a few mm off) [was Z=2057.855466 pre 1/11/07]
ZLIN04={'mo' 'ZLIN04' 0 []}';%entrance to 21-3b            : Z=2059.732900
ZLIN05={'mo' 'ZLIN05' 0 []}';%start of LI22                : Z=2133.600000
ZLIN06={'mo' 'ZLIN06' 0 []}';%start of LI23                : Z=2235.200000
ZLIN07={'mo' 'ZLIN07' 0 []}';%start of LI24                : Z=2336.800000
ZLIN08={'mo' 'ZLIN08' 0 []}';%center of QUAD LI24 701 (A)  : Z=2410.786000 (not moved)
ZLIN09={'mo' 'ZLIN09' 0 []}';%start of LI25                : Z=2438.400000
ZLIN10={'mo' 'ZLIN10' 0 []}';%start of LI26                : Z=2540.000000
ZLIN11={'mo' 'ZLIN11' 0 []}';%start of LI27                : Z=2641.600000
ZLIN12={'mo' 'ZLIN12' 0 []}';%start of LI28                : Z=2743.200000
ZLIN13={'mo' 'ZLIN13' 0 []}';%start of LI29                : Z=2844.800000
ZLIN14={'mo' 'ZLIN14' 0 []}';%start of LI30                : Z=2946.400000
% DBMARK29 : MARK end of linac                 : Z=3042.005000
% WOODDOOR : MARK start of BSY                 : Z=3050.512000
% S100     : MARK Station 100                  : Z=3048.000000
% ==============================================================================
% existing XCORs
% ------------------------------------------------------------------------------
%XC460009T : HKIC
%XC460026T : HKIC
%XC460034T : HKIC do not use to steer ... bad results in Elegant
%XC460036T : HKIC do not use to steer ... bad results in Elegant
%XC920020T : HKIC
%XC921010T : HKIC do not use to steer ... bad results in Elegant
%XCBSY09   : HKIC names changed from above to these (Sep. 2008)
%XCBSY26   : HKIC
%XCBSY36   : HKIC do not use to steer ... bad results in Elegant
%XCBSYQ2   : HKIC, TYPE="class-4" was XCBSY09 (Mar. 2016)
XCBSY34={'mo' 'XCBSY34' 0 []}';%do not use to steer ... bad results in Elegant
%XCBSYQ3   : HKIC, TYPE="class-4" was XCBSY09 (Mar. 2016)
XCBSY60={'mo' 'XCBSY60' 0 []}';
XCBSY81={'mo' 'XCBSY81' 0 []}';%do not use to steer ... bad results in Elegant
% ==============================================================================
% new XCORs
% ------------------------------------------------------------------------------
XC00={'mo' 'XC00' 0 []}';
XC01={'mo' 'XC01' 0 []}';
XC02={'mo' 'XC02' 0 []}';
XC03={'mo' 'XC03' 0 []}';
XC04={'mo' 'XC04' 0 []}';%fast-feedback (loop-1)
XC05={'mo' 'XC05' 0 []}';%calibrated to <1%
XC06={'mo' 'XC06' 0 []}';
XC07={'mo' 'XC07' 0 []}';%fast-feedback (loop-1)
XC08={'mo' 'XC08' 0 []}';
XC09={'mo' 'XC09' 0 []}';
XC10={'mo' 'XC10' 0 []}';
XC21101={'mo' 'XC21101' 0 []}';
XC21135={'mo' 'XC21135' 0 []}';
XC21165={'mo' 'XC21165' 0 []}';%calibrated to <1%
XC21175={'mo' 'XC21175' 0 []}';
XC21302={'mo' 'XC21302' 0 []}';
XC21191={'mo' 'XC21191' 0 []}';
XC21275={'mo' 'XC21275' 0 []}';
XC21325={'mo' 'XC21325' 0 []}';
% ==============================================================================
% existing YCORs
% ------------------------------------------------------------------------------
%YC460010T : VKIC
%YC460027T : VKIC do not use to steer ... bad results in Elegant
%YC460035T : VKIC do not use to steer ... bad results in Elegant
%YC460037T : VKIC
%YC920020T : VKIC
%YC921010T : VKIC do not use to steer ... bad results in Elegant
%YCBSY10   : VKIC  names changed from above to these (Sep. 2008)
%YCBSYQ1   : VKIC, TYPE="class-4" was YCBSY10 (Mar. 2016)
YCBSY27={'mo' 'YCBSY27' 0 []}';%do not use to steer ... bad results in Elegant
%YCBSY35   : VKIC do not use to steer ... bad results in Elegant
YCBSY37={'mo' 'YCBSY37' 0 []}';
%YCBSY62   : VKIC
YCBSY82={'mo' 'YCBSY82' 0 []}';%do not use to steer ... bad results in Elegant
% ==============================================================================
% new YCORs
% ------------------------------------------------------------------------------
YC00={'mo' 'YC00' 0 []}';
YC01={'mo' 'YC01' 0 []}';
YC02={'mo' 'YC02' 0 []}';
YC03={'mo' 'YC03' 0 []}';
YC04={'mo' 'YC04' 0 []}';%fast-feedback (loop-1)
YC05={'mo' 'YC05' 0 []}';%calibrated to <1%
YC06={'mo' 'YC06' 0 []}';
YC07={'mo' 'YC07' 0 []}';%fast-feedback (loop-1)
YC08={'mo' 'YC08' 0 []}';
YC09={'mo' 'YC09' 0 []}';
YC10={'mo' 'YC10' 0 []}';
YC21102={'mo' 'YC21102' 0 []}';
YC21136={'mo' 'YC21136' 0 []}';%calibrated to <1%
YC21166={'mo' 'YC21166' 0 []}';
YC21174={'mo' 'YC21174' 0 []}';
YC21303={'mo' 'YC21303' 0 []}';
YC21192={'mo' 'YC21192' 0 []}';
YC21276={'mo' 'YC21276' 0 []}';
YC21325={'mo' 'YC21325' 0 []}';
YC5={'mo' 'YC5' 0 []}';
% ==============================================================================
% existing BPMs
% ------------------------------------------------------------------------------
BPM21201={'mo' 'BPM21201' 0 []}';
BPM21301={'mo' 'BPM21301' 0 []}';
BPM21401={'mo' 'BPM21401' 0 []}';
BPM21501={'mo' 'BPM21501' 0 []}';
BPM21601={'mo' 'BPM21601' 0 []}';
BPM21701={'mo' 'BPM21701' 0 []}';
BPM21801={'mo' 'BPM21801' 0 []}';
BPM21901={'mo' 'BPM21901' 0 []}';
BPM22201={'mo' 'BPM22201' 0 []}';
BPM22301={'mo' 'BPM22301' 0 []}';
BPM22401={'mo' 'BPM22401' 0 []}';
BPM22501={'mo' 'BPM22501' 0 []}';
BPM22601={'mo' 'BPM22601' 0 []}';
BPM22701={'mo' 'BPM22701' 0 []}';
BPM22801={'mo' 'BPM22801' 0 []}';
BPM22901={'mo' 'BPM22901' 0 []}';
BPM23201={'mo' 'BPM23201' 0 []}';
BPM23301={'mo' 'BPM23301' 0 []}';
BPM23401={'mo' 'BPM23401' 0 []}';
BPM23501={'mo' 'BPM23501' 0 []}';
BPM23601={'mo' 'BPM23601' 0 []}';
BPM23701={'mo' 'BPM23701' 0 []}';
BPM23801={'mo' 'BPM23801' 0 []}';
BPM23901={'mo' 'BPM23901' 0 []}';
BPM24201={'mo' 'BPM24201' 0 []}';
BPM24301={'mo' 'BPM24301' 0 []}';
BPM24401={'mo' 'BPM24401' 0 []}';
BPM24501={'mo' 'BPM24501' 0 []}';
BPM24601={'mo' 'BPM24601' 0 []}';
BPM24701={'mo' 'BPM24701' 0 []}';
BPM24901={'mo' 'BPM24901' 0 []}';
BPM25201={'mo' 'BPM25201' 0 []}';
BPM25301={'mo' 'BPM25301' 0 []}';
BPM25401={'mo' 'BPM25401' 0 []}';
BPM25501={'mo' 'BPM25501' 0 []}';
BPM25601={'mo' 'BPM25601' 0 []}';
BPM25701={'mo' 'BPM25701' 0 []}';
BPM25801={'mo' 'BPM25801' 0 []}';
BPM25901={'mo' 'BPM25901' 0 []}';
BPM26201={'mo' 'BPM26201' 0 []}';
BPM26301={'mo' 'BPM26301' 0 []}';
BPM26401={'mo' 'BPM26401' 0 []}';
BPM26501={'mo' 'BPM26501' 0 []}';
BPM26601={'mo' 'BPM26601' 0 []}';
BPM26701={'mo' 'BPM26701' 0 []}';
BPM26801={'mo' 'BPM26801' 0 []}';
BPM26901={'mo' 'BPM26901' 0 []}';
BPM27201={'mo' 'BPM27201' 0 []}';
BPM27301={'mo' 'BPM27301' 0 []}';
BPM27401={'mo' 'BPM27401' 0 []}';
BPM27501={'mo' 'BPM27501' 0 []}';
BPM27601={'mo' 'BPM27601' 0 []}';
BPM27701={'mo' 'BPM27701' 0 []}';
BPM27801={'mo' 'BPM27801' 0 []}';
BPM27901={'mo' 'BPM27901' 0 []}';
BPM28201={'mo' 'BPM28201' 0 []}';
BPM28301={'mo' 'BPM28301' 0 []}';
BPM28401={'mo' 'BPM28401' 0 []}';
BPM28501={'mo' 'BPM28501' 0 []}';
BPM28601={'mo' 'BPM28601' 0 []}';
BPM28701={'mo' 'BPM28701' 0 []}';
BPM28801={'mo' 'BPM28801' 0 []}';
BPM28901={'mo' 'BPM28901' 0 []}';
BPM29201={'mo' 'BPM29201' 0 []}';
BPM29301={'mo' 'BPM29301' 0 []}';
BPM29401={'mo' 'BPM29401' 0 []}';
BPM29501={'mo' 'BPM29501' 0 []}';
BPM29601={'mo' 'BPM29601' 0 []}';
BPM29701={'mo' 'BPM29701' 0 []}';
BPM29801={'mo' 'BPM29801' 0 []}';
BPM29901={'mo' 'BPM29901' 0 []}';
BPM30201={'mo' 'BPM30201' 0 []}';
BPM30301={'mo' 'BPM30301' 0 []}';
BPM30401={'mo' 'BPM30401' 0 []}';
BPM30501={'mo' 'BPM30501' 0 []}';
BPM30601={'mo' 'BPM30601' 0 []}';
BPM30701={'mo' 'BPM30701' 0 []}';
BPM30801={'mo' 'BPM30801' 0 []}';
% ==============================================================================
% new BPMs
% ------------------------------------------------------------------------------
BPM2={'mo' 'BPM2' 0 []}';
BPM3={'mo' 'BPM3' 0 []}';
BPM5={'mo' 'BPM5' 0 []}';
BPM6={'mo' 'BPM6' 0 []}';
BPM8={'mo' 'BPM8' 0 []}';
BPM9={'mo' 'BPM9' 0 []}';
BPM10={'mo' 'BPM10' 0 []}';
BPM11={'mo' 'BPM11' 0 []}';
BPM12={'mo' 'BPM12' 0 []}';
BPM13={'mo' 'BPM13' 0 []}';
BPM14={'mo' 'BPM14' 0 []}';
BPM15={'mo' 'BPM15' 0 []}';
BPMA11={'mo' 'BPMA11' 0 []}';
BPMA12={'mo' 'BPMA12' 0 []}';
BPMS11={'mo' 'BPMS11' 0 []}';
BPMM12={'mo' 'BPMM12' 0 []}';
BPMM14={'mo' 'BPMM14' 0 []}';
BPMS21={'mo' 'BPMS21' 0 []}';
% ==============================================================================
% miscellaneous
% ------------------------------------------------------------------------------
D10CMA={'dr' '' 0.127 []}';
% ==============================================================================
% LINE definitions
% ------------------------------------------------------------------------------
L1C=[D9,DAQ1,QFL1,QFL1,DAQ1,D9,DAQ1,QDL1,QDL1,DAQ1];
L2C=[D10,D10,D10,D10,DAQ1,QFL2,QFL2,DAQ2,D10,D10,D10,D10,DAQ1,QDL2,QDL2,DAQ2];
L3C=[D10,D10,D10,D10,DAQ1,QFL3,QFL3,DAQ2,D10,D10,D10,D10,DAQ1,QDL3,QDL3,DAQ2];
SC1=[XC01,YC01];
%SC2   : LINE=(XC02,YC02)
%SC3   : LINE=(XC03,YC03)
%SC4   : LINE=(XC04,YC04)
%SC5   : LINE=(XC05,YC05)
SC7=[XC07,YC07];
SC8=[XC08,YC08];
SC9=[XC09,YC09];
SC10=[XC10,YC10];
%SC11  : LINE=(XC21101,YC21102)
%SCA11 : LINE=(XC21135,YC21136)
%SCA12 : LINE=(XC21165,YC21166)
%SCM11 : LINE=(XC21191,YC21192)
SCM13=[XC21275,YC21276];
SCM15=[XC21325,YC21325];
L0A_FULL=[FLNGA1,L0A___1,DLFDA,L0A___2,SOL2,L0A___3,XC02,YC02,L0A___4,L0AMID,L0A___5,XC03,YC03,L0A___6,OUTCPA,L0A___7,FLNGA2];
L0B_FULL=[FLNGB1,L0B___1,DLFDB,L0B___2,XC04,YC04,L0B___3,L0BMID,L0B___4,XC05,YC05,L0B___5,OUTCPB,L0B___6,FLNGB2];
TCAV0_FULL=[TCAV0,XC06,YC06,TCAV0];
L1X_FULL=[XBEG,L1X___1,XC21191,YC21192,L1X___2,XEND];
BXH1_FULL=[BXH1A,BXH1B];
BXH2_FULL=[BXH2A,BXH2B];
BXH3_FULL=[BXH3A,BXH3B];
BXH4_FULL=[BXH4A,BXH4B];
BX01_FULL=[BX01A,BX01B];
BX02_FULL=[BX02A,BX02B];
BX11_FULL=[BX11A,BX11B];
BX12_FULL=[BX12A,BX12B];
BX13_FULL=[BX13A,BX13B];
BX14_FULL=[BX14A,BX14B];
BX21_FULL=[BX21A,BX21B];
BX22_FULL=[BX22A,BX22B];
BX23_FULL=[BX23A,BX23B];
BX24_FULL=[BX24A,BX24B];
QA01_FULL=[QA01,QA01];
QA02_FULL=[QA02,BPM5,QA02];
QE01_FULL=[QE01,BPM6,QE01];
QE02_FULL=[QE02,QE02];
QE03_FULL=[QE03,BPM8,QE03];
QE04_FULL=[QE04,BPM9,QE04];
QM01_FULL=[QM01,BPM11,QM01];
QM02_FULL=[QM02,BPM12,QM02];
QB_FULL=[QB,BPM13,QB];
QM03_FULL=[QM03,BPM14,QM03];
QM04_FULL=[QM04,BPM15,QM04];
Q21201_FULL=[Q21201,BPM21201,ZLIN02,Q21201];
QM11_FULL=[QM11,QM11];
CQ11_FULL=[CQ11,CQ11];
SQ13_FULL=[SQ13,SQ13];
CQ12_FULL=[CQ12,CQ12];
QM12_FULL=[QM12,QM12];
QM13_FULL=[QM13,BPMM12,QM13];
Q21301_FULL=[Q21301,BPM21301,ZLIN03,Q21301];
QM14_FULL=[QM14,BPMM14,QM14];
QM15_FULL=[QM15,QM15];
Q24701A_FULL=[Q24701A,ZLIN08,Q24701A];
Q24701B_FULL=[Q24701B,BPM24701,Q24701B];
QM21_FULL=[QM21,QM21];
CQ21_FULL=[CQ21,CQ21];
CQ22_FULL=[CQ22,CQ22];
QM22_FULL=[QM22,QM22];
Q24901A_FULL=[Q24901A,BPM24901,Q24901A];
Q24901B_FULL=[Q24901B,Q24901B];
SOL1_FULL=[SOL1,CQ01,XC00,YC00,SQ01,SOL1];
LH_UND_FULL=[LH_UND,HTRUND,LH_UND];
GUNBXG=[DL00,LOADLOCK,BEGGUN,SOL1BK,DBMARK80,CATHODE,DL01A,SOL1_FULL,DL01A1,VV01,DL01A2,AM00,DL01A3,AM01,DL01A4,YAG01,DL01A5,FC01,DL01B,IM01,DL01C,SC1,DL01H,BPM2,DL01D,DBMARK81,ENDGUN];
BXGL0A=[BEGL0,DBXG,DL01E,BPM3,DL01F,CR01,DL01F2,YAG02,DL01G,ZLIN00,L0A_FULL,L0AWAKE];
GUNL0A=[GUNBXG,BXGL0A];
L0AL0B=[L0BBEG,DL02A1,YAG03,DL02A2,DL02A3,QA01_FULL,DL02B1,PH01,DL02B2,QA02_FULL,DL02C,L0B_FULL,ENDL0];
LSRHTR=[LHBEG,BXH1_FULL,DH01,BXH2_FULL,DH02A,OTRH1,DH03A,LH_UND_FULL,DH03B,OTRH2,DH02B,BXH3_FULL,DH01,BXH4_FULL,LHEND];
DL1_1=[BEGDL1_1,EMAT,DE00,DE00A,QE01_FULL,DE01A,IM02,DE01B,VV02,DE01C,QE02_FULL,DH00,LSRHTR,DH06,TCAV0_FULL,DE02,QE03_FULL,DE03A,DE03B,SC7,DE03C,QE04_FULL,DE04,WS01,DE05,OTR1,DE05C,VV03,DE06A,RST1,DE06B,WS02,DE05A,MRK0,DE05A,OTR2,DE06D,BPM10,DE06E,WS03,DE05,OTR3,DE07,QM01_FULL,DE08,SC8,DE08A,VV04,DE08B,QM02_FULL,DE09,DBMARK82,ENDDL1_1];
DL1_2=[BEGDL1_2,BX01_FULL,DB00A,OTR4,DB00B,SC9,DB00C,QB_FULL,DB00D,WS04,DB00E,BX02_FULL,CNT0,DBMARK83,DM00,SC10,DM00A,QM03_FULL,DM01,DM01A,QM04_FULL,DM02,IM03,DM02A,ENDDL1_2];
DL1=[DL1_1,DL1_2];%nominal LCLS DL1 layout with BX01/BX02 bends on
DIAG1=[DDG1,BPMS11,DDG2,CE11,DDG3,OTR11,DDG4];
BC1C=[BC1CBEG,BX11_FULL,DBQ1,CQ11_FULL,D11O,BX12_FULL,DIAG1,BX13_FULL,D11OA,SQ13_FULL,D11OB,CQ12_FULL,DBQ1,BX14_FULL,CNT1,BC1CEND];
BC1I=[DL1XA,VVX1,DL1XB,L1X_FULL,DM10A,VVX2,DM10C,Q21201_FULL,DM10X,IMBC1I,DM11,QM11_FULL,DM12];
BC1E=[DM13A,BL11,DM13B,QM12_FULL,DM14A,DM14B,IMBC1O,DM14C,QM13_FULL,DM15A,BL12,DM15B,SCM13,DM15C,WS11,DWW1A,WS12,DWW1B,OTR12,DWW1C1,PH02,DWW1C2,XC21302,DWW1D,YC21303,DWW1E,WS13,DM16,Q21301_FULL,DM17A,DM17B,TD11,DM17C,QM14_FULL,DM18A,SCM15,DM18B,QM15_FULL,DBMARK28,DM19];
BC1=[BEGBC1,BC1I,BC1C,BC1E,ENDBC1];
DIAG2=[DDG1,BPMS21,DDG2,CE21,DDG3,OTR21,DDG4];
BC2C1=[BC2CBEG,BX21_FULL,DBQ2A,CQ21_FULL,D21OA,BX22_FULL,DDG0,DIAG2,DDGA,BX23_FULL,D21OB,CQ22_FULL,DBQ2B,BX24_FULL,CNT2,BC2CEND];
BC2=[BEGBC2,DM20,Q24701A_FULL,D10CMA,Q24701B_FULL,DM21Z,DM21A,WS24,DM21H,IMBC2I,DM21B,VV21,DM21C,QM21_FULL,DM21D,DM21E,BC2C1,D21W,D21X,BL21,D21Y,DM23B,QM22_FULL,DM24A,VV22,DM24B,DM24D,Q24901A_FULL,DM24C,Q24901B_FULL,DM25,ENDBC2];
ECELL=[QE31,DQEC,DQEC,QE32,QE32,DQEC,DQEC,QE31];
% ------------------------------------------------------------------------------

% design L1, L2, and L3 lattices ...
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% ==============================================================================
% 07-JAN-2019, M. Woodley
%  * rename some LI21 correctors to avoid name conflicts with LCLS-II per
%    T. Maxwell
% ------------------------------------------------------------------------------
% 11-JAN-2007, P. Emma
%    Move QA11 a few mm as observed by alignment.
% 09-MAR-2006, P. Emma
%    Move SC11, SCA11, SCA12, and XC21202 and YC21203 per P. Stephens.
% 01-DEC-2005, P. Emma
%    Move XC21202 and YC21203 onto end of 21-1d.
% 29-NOV-2005, P. Emma
%    Add types for LCAV's.
% 09-NOV-2005, P. Emma
%    Use type-1 x/y corrector packages in L1-linac and relocate.
% 25-SEP-2005, P. Emma
%    Break L1 structure up to insert correctors at proper locations.
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L1 linac consists of:   1 9.4  ft S-band sections @ 50% power
%                             1 9.4  ft S-band sections @ 25% power
%                             1 10   ft S-band sections @ 25% power
% ------------------------------------------------------------------------------
DLB1 =  0.200+0.253432;
DLB2 =  DLWL9-DLB1;
K21_1B1={'lc' 'K21_1B' DLB1 [SBANDF P50*GRADL1*DLB1 PHIL1*TWOPI]}';
K21_1B2={'lc' 'K21_1B' DLB2 [SBANDF P50*GRADL1*DLB2 PHIL1*TWOPI]}';
DLC1 =  0.200+0.2534458;
DLC2 =  DLWL9-DLC1;
K21_1C1={'lc' 'K21_1C' DLC1 [SBANDF P25*GRADL1*DLC1 PHIL1*TWOPI]}';
K21_1C2={'lc' 'K21_1C' DLC2 [SBANDF P25*GRADL1*DLC2 PHIL1*TWOPI]}';
DLD1 =  0.200+0.1693348;
DLD3 =  0.300+0.167527-0.1799554;
DLD4 =  0.200+0.1799554;
DLD2 =  DLWL10-DLD1-DLD3-DLD4;
K21_1D1={'lc' 'K21_1D' DLD1 [SBANDF P25*GRADL1*DLD1 PHIL1*TWOPI]}';
K21_1D2={'lc' 'K21_1D' DLD2 [SBANDF P25*GRADL1*DLD2 PHIL1*TWOPI]}';
K21_1D3={'lc' 'K21_1D' DLD3 [SBANDF P25*GRADL1*DLD3 PHIL1*TWOPI]}';
K21_1D4={'lc' 'K21_1D' DLD4 [SBANDF P25*GRADL1*DLD4 PHIL1*TWOPI]}';
% define unsplit LCAVs for BMAD ... not used by MAD
K21_1B={'lc' 'K21_1B' DLWL9 [SBANDF P50*GRADL1*DLWL9 PHIL1*TWOPI]}';
K21_1C={'lc' 'K21_1C' DLWL9 [SBANDF P25*GRADL1*DLWL9 PHIL1*TWOPI]}';
K21_1D={'lc' 'K21_1D' DLWL10 [SBANDF P25*GRADL1*DLWL10 PHIL1*TWOPI]}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K21_1B_FULL=[K21_1B1,XC21101,YC21102,K21_1B2];
K21_1C_FULL=[K21_1C1,XC21135,YC21136,K21_1C2];
K21_1D_FULL=[K21_1D1,XC21165,YC21166,K21_1D2,YC21174,K21_1D3,XC21175,K21_1D4];
QA11_FULL=[QA11,BPMA11,QA11];
QA12_FULL=[QA12,BPMA12,QA12];
L1=[BEGL1,ZLIN01,K21_1B_FULL,DAQA1,QA11_FULL,DAQA2,K21_1C_FULL,DAQA3,QA12_FULL,DAQA4,K21_1D_FULL,ENDL1];
% ==============================================================================

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% ==============================================================================
% 30-JAN-2023, M. Woodley
%  * add ultra-fast stripline kickers at 22-9 per A. Halavanau
%    (change keyword from INST to BEND in makeExcel.m)
% ------------------------------------------------------------------------------
% 21-OCT-2021, M. Woodley
%  * add ultra-fast stripline kickers at 21-9 per A. Halavanau
%    (change keyword from INST to BEND in makeExcel.m)
% ------------------------------------------------------------------------------
% 23-FEB-2017, M. Woodley
%    Change TYPE of LI21 XCORs and YCORs to "type-4al" for consistency with LCLS
% ------------------------------------------------------------------------------
% 01-JUL-2010, M. Woodley
%    Per H. Loos: fix DELTAE arithmetic for the following LCAV elements:
%      K24_2a1, K24_2a2, K24_2a3
%      K24_4a2, K24_4a3
%      K24_5a2, K24_5a3
%      K24_6a2, K24_6a3
%      K24_6d1, K24_6d2
% 11-SEP-2007, P. Emma
%    Replace WS21,22,23 with MARKer points DWS21-23 (no longer in baseline);
%    add back 25-3d, 4d, and 5d sections (now 110 10-ft P25% sections & 1 P50%)
% 15-DEC-2006, P. Emma
%    Move WS21,22,23 upbeam by 4 feet each to reduce possible quad-reflected
%    dark charge
% 13-DEC-2006, P. Emma
%    Per T. Osier: move (~6") XC24202, YC24203, YC24403, YC24503, YC24603,
%    and XC24702
% 15-OCT-2006, P. Emma
%    Move WS21,22,23 for Jose Chan (DAQ6 becomes DAQ6A).
% 20-MAR-2006, P. Emma
%    Remove YCM15 from this file as should have been done back in Nov. 9, 2005.
% 29-NOV-2005, P. Emma
%    Add types for LCAV's, HKIC's, and VKIC's.
% 09-NOV-2005, P. Emma
%    Move YCM15 back into main LCLS file.
% 02-JUN-2005, P. Emma
%    Add comments adjacent to fast-feedback correctors
% 18-JAN-2005, P. Emma
%    Added the two 1%-calibrated correctors.
% 01-DEC-2004, P. Emma
%    Move YCM15 into this file from the main LCLS file (moved dnstr. by 0.401 m
%    and jumped over QM15 onto the L2 linac as a wrap-around corrector)
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L2 linac consists of: 110 10   ft S-band sections @ 25% power
%                             1 10   ft S-band sections @ 50% power
% ------------------------------------------------------------------------------
K21_3B1={'lc' 'K21_3B' 0.2672 [SBANDF P50*GRADL2*0.2672 PHIL2*TWOPI]}';
K21_3B2={'lc' 'K21_3B' 2.7769 [SBANDF P50*GRADL2*2.7769 PHIL2*TWOPI]}';
K21_3C={'lc' 'K21_3C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_3D={'lc' 'K21_3D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_4A1={'lc' 'K21_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K21_4A2={'lc' 'K21_4A' 0.3707 [SBANDF P25*GRADL2*0.3707 PHIL2*TWOPI]}';
K21_4A3={'lc' 'K21_4A' 2.3466 [SBANDF P25*GRADL2*2.3466 PHIL2*TWOPI]}';
K21_4B={'lc' 'K21_4B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_4C={'lc' 'K21_4C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_4D={'lc' 'K21_4D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_5A1={'lc' 'K21_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K21_5A2={'lc' 'K21_5A' 0.3778 [SBANDF P25*GRADL2*0.3778 PHIL2*TWOPI]}';
K21_5A3={'lc' 'K21_5A' 2.3339 [SBANDF P25*GRADL2*2.3339 PHIL2*TWOPI]}';
K21_5B={'lc' 'K21_5B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_5C={'lc' 'K21_5C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_5D={'lc' 'K21_5D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_6A1={'lc' 'K21_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K21_6A2={'lc' 'K21_6A' 0.3885 [SBANDF P25*GRADL2*0.3885 PHIL2*TWOPI]}';
K21_6A3={'lc' 'K21_6A' 2.3276 [SBANDF P25*GRADL2*2.3276 PHIL2*TWOPI]}';
K21_6B={'lc' 'K21_6B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_6C={'lc' 'K21_6C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_6D={'lc' 'K21_6D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_7A1={'lc' 'K21_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K21_7A2={'lc' 'K21_7A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_7A3={'lc' 'K21_7A' 2.4605 [SBANDF P25*GRADL2*2.4605 PHIL2*TWOPI]}';
K21_7B={'lc' 'K21_7B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_7C={'lc' 'K21_7C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_7D={'lc' 'K21_7D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_8A1={'lc' 'K21_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K21_8A2={'lc' 'K21_8A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_8A3={'lc' 'K21_8A' 2.4649 [SBANDF P25*GRADL2*2.4649 PHIL2*TWOPI]}';
K21_8B={'lc' 'K21_8B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_8C={'lc' 'K21_8C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_8D1={'lc' 'K21_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K21_8D2={'lc' 'K21_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K21_8D3={'lc' 'K21_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K22_1A={'lc' 'K22_1A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_1B={'lc' 'K22_1B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_1C={'lc' 'K22_1C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_1D={'lc' 'K22_1D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_2A1={'lc' 'K22_2A' 0.3256 [SBANDF P25*GRADL2*0.3256 PHIL2*TWOPI]}';
K22_2A2={'lc' 'K22_2A' 0.3782 [SBANDF P25*GRADL2*0.3782 PHIL2*TWOPI]}';
K22_2A3={'lc' 'K22_2A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K22_2B={'lc' 'K22_2B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_2C={'lc' 'K22_2C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_2D={'lc' 'K22_2D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_3A1={'lc' 'K22_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K22_3A2={'lc' 'K22_3A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_3A3={'lc' 'K22_3A' 2.4629 [SBANDF P25*GRADL2*2.4629 PHIL2*TWOPI]}';
K22_3B={'lc' 'K22_3B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_3C={'lc' 'K22_3C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_3D={'lc' 'K22_3D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_4A1={'lc' 'K22_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K22_4A2={'lc' 'K22_4A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_4A3={'lc' 'K22_4A' 2.4673 [SBANDF P25*GRADL2*2.4673 PHIL2*TWOPI]}';
K22_4B={'lc' 'K22_4B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_4C={'lc' 'K22_4C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_4D={'lc' 'K22_4D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_5A1={'lc' 'K22_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K22_5A2={'lc' 'K22_5A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_5A3={'lc' 'K22_5A' 2.4617 [SBANDF P25*GRADL2*2.4617 PHIL2*TWOPI]}';
K22_5B={'lc' 'K22_5B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_5C={'lc' 'K22_5C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_5D={'lc' 'K22_5D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_6A1={'lc' 'K22_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K22_6A2={'lc' 'K22_6A' 0.3790 [SBANDF P25*GRADL2*0.3790 PHIL2*TWOPI]}';
K22_6A3={'lc' 'K22_6A' 2.3371 [SBANDF P25*GRADL2*2.3371 PHIL2*TWOPI]}';
K22_6B={'lc' 'K22_6B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_6C={'lc' 'K22_6C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_6D={'lc' 'K22_6D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_7A1={'lc' 'K22_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K22_7A2={'lc' 'K22_7A' 0.3829 [SBANDF P25*GRADL2*0.3829 PHIL2*TWOPI]}';
K22_7A3={'lc' 'K22_7A' 2.3276 [SBANDF P25*GRADL2*2.3276 PHIL2*TWOPI]}';
K22_7B={'lc' 'K22_7B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_7C={'lc' 'K22_7C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_7D={'lc' 'K22_7D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_8A1={'lc' 'K22_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K22_8A2={'lc' 'K22_8A' 0.3969 [SBANDF P25*GRADL2*0.3969 PHIL2*TWOPI]}';
K22_8A3={'lc' 'K22_8A' 2.3180 [SBANDF P25*GRADL2*2.3180 PHIL2*TWOPI]}';
K22_8B={'lc' 'K22_8B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_8C={'lc' 'K22_8C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_8D1={'lc' 'K22_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K22_8D2={'lc' 'K22_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K22_8D3={'lc' 'K22_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K23_1A={'lc' 'K23_1A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_1B={'lc' 'K23_1B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_1C={'lc' 'K23_1C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_1D={'lc' 'K23_1D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_2A1={'lc' 'K23_2A' 0.3256 [SBANDF P25*GRADL2*0.3256 PHIL2*TWOPI]}';
K23_2A2={'lc' 'K23_2A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_2A3={'lc' 'K23_2A' 2.4685 [SBANDF P25*GRADL2*2.4685 PHIL2*TWOPI]}';
K23_2B={'lc' 'K23_2B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_2C={'lc' 'K23_2C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_2D={'lc' 'K23_2D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_3A1={'lc' 'K23_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K23_3A2={'lc' 'K23_3A' 0.3726 [SBANDF P25*GRADL2*0.3726 PHIL2*TWOPI]}';
K23_3A3={'lc' 'K23_3A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K23_3B={'lc' 'K23_3B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_3C={'lc' 'K23_3C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_3D={'lc' 'K23_3D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_4A1={'lc' 'K23_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K23_4A2={'lc' 'K23_4A' 0.3770 [SBANDF P25*GRADL2*0.3770 PHIL2*TWOPI]}';
K23_4A3={'lc' 'K23_4A' 2.3403 [SBANDF P25*GRADL2*2.3403 PHIL2*TWOPI]}';
K23_4B={'lc' 'K23_4B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_4C={'lc' 'K23_4C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_4D={'lc' 'K23_4D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_5A1={'lc' 'K23_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K23_5A2={'lc' 'K23_5A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_5A3={'lc' 'K23_5A' 2.4617 [SBANDF P25*GRADL2*2.4617 PHIL2*TWOPI]}';
K23_5B={'lc' 'K23_5B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_5C={'lc' 'K23_5C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_5D={'lc' 'K23_5D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_6A1={'lc' 'K23_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K23_6A2={'lc' 'K23_6A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_6A3={'lc' 'K23_6A' 2.4661 [SBANDF P25*GRADL2*2.4661 PHIL2*TWOPI]}';
K23_6B={'lc' 'K23_6B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_6C={'lc' 'K23_6C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_6D={'lc' 'K23_6D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_7A1={'lc' 'K23_7A' 0.3336 [SBANDF P25*GRADL2*0.3336 PHIL2*TWOPI]}';
K23_7A2={'lc' 'K23_7A' 0.3671 [SBANDF P25*GRADL2*0.3671 PHIL2*TWOPI]}';
K23_7A3={'lc' 'K23_7A' 2.3434 [SBANDF P25*GRADL2*2.3434 PHIL2*TWOPI]}';
K23_7B={'lc' 'K23_7B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_7C={'lc' 'K23_7C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_7D={'lc' 'K23_7D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_8A1={'lc' 'K23_8A' 0.3292 [SBANDF P25*GRADL2*0.3292 PHIL2*TWOPI]}';
K23_8A2={'lc' 'K23_8A' 0.4064 [SBANDF P25*GRADL2*0.4064 PHIL2*TWOPI]}';
K23_8A3={'lc' 'K23_8A' 2.3085 [SBANDF P25*GRADL2*2.3085 PHIL2*TWOPI]}';
K23_8B={'lc' 'K23_8B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_8C={'lc' 'K23_8C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_8D1={'lc' 'K23_8D' 2.3869 [SBANDF P25*GRADL2*2.3869 PHIL2*TWOPI]}';
K23_8D2={'lc' 'K23_8D' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K23_8D3={'lc' 'K23_8D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
K24_1A={'lc' 'K24_1A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_1B={'lc' 'K24_1B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_1C={'lc' 'K24_1C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_1D={'lc' 'K24_1D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_2A1={'lc' 'K24_2A' 0.3716 [SBANDF P25*GRADL2*0.3716 PHIL2*TWOPI]}';
K24_2A2={'lc' 'K24_2A' 0.2810 [SBANDF P25*GRADL2*0.2810 PHIL2*TWOPI]}';
K24_2A3={'lc' 'K24_2A' 2.3915 [SBANDF P25*GRADL2*2.3915 PHIL2*TWOPI]}';
K24_2B={'lc' 'K24_2B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_2C={'lc' 'K24_2C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_2D={'lc' 'K24_2D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_3A1={'lc' 'K24_3A' 0.3312 [SBANDF P25*GRADL2*0.3312 PHIL2*TWOPI]}';
K24_3A2={'lc' 'K24_3A' 0.2500 [SBANDF P25*GRADL2*0.2500 PHIL2*TWOPI]}';
K24_3A3={'lc' 'K24_3A' 2.4629 [SBANDF P25*GRADL2*2.4629 PHIL2*TWOPI]}';
K24_3B={'lc' 'K24_3B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_3C={'lc' 'K24_3C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_3D={'lc' 'K24_3D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_4A1={'lc' 'K24_4A' 0.3268 [SBANDF P25*GRADL2*0.3268 PHIL2*TWOPI]}';
K24_4A2={'lc' 'K24_4A' 0.3048 [SBANDF P25*GRADL2*0.3048 PHIL2*TWOPI]}';
K24_4A3={'lc' 'K24_4A' 2.4125 [SBANDF P25*GRADL2*2.4125 PHIL2*TWOPI]}';
K24_4B={'lc' 'K24_4B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_4C={'lc' 'K24_4C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_4D={'lc' 'K24_4D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_5A1={'lc' 'K24_5A' 0.3324 [SBANDF P25*GRADL2*0.3324 PHIL2*TWOPI]}';
K24_5A2={'lc' 'K24_5A' 0.3048 [SBANDF P25*GRADL2*0.3048 PHIL2*TWOPI]}';
K24_5A3={'lc' 'K24_5A' 2.4069 [SBANDF P25*GRADL2*2.4069 PHIL2*TWOPI]}';
K24_5B={'lc' 'K24_5B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_5C={'lc' 'K24_5C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_5D={'lc' 'K24_5D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_6A1={'lc' 'K24_6A' 0.3280 [SBANDF P25*GRADL2*0.3280 PHIL2*TWOPI]}';
K24_6A2={'lc' 'K24_6A' 0.3048 [SBANDF P25*GRADL2*0.3048 PHIL2*TWOPI]}';
K24_6A3={'lc' 'K24_6A' 2.4113 [SBANDF P25*GRADL2*2.4113 PHIL2*TWOPI]}';
K24_6B={'lc' 'K24_6B' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_6C={'lc' 'K24_6C' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_6D1={'lc' 'K24_6D' 2.3321 [SBANDF P25*GRADL2*2.3321 PHIL2*TWOPI]}';
K24_6D2={'lc' 'K24_6D' 0.3048 [SBANDF P25*GRADL2*0.3048 PHIL2*TWOPI]}';
K24_6D3={'lc' 'K24_6D' 0.4072 [SBANDF P25*GRADL2*0.4072 PHIL2*TWOPI]}';
% define unsplit LCAVs for BMAD ... not used by MAD
K21_3B={'lc' 'K21_3B' DLWL10 [SBANDF P50*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_4A={'lc' 'K21_4A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_5A={'lc' 'K21_5A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_6A={'lc' 'K21_6A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_7A={'lc' 'K21_7A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_8A={'lc' 'K21_8A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K21_8D={'lc' 'K21_8D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_2A={'lc' 'K22_2A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_3A={'lc' 'K22_3A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_4A={'lc' 'K22_4A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_5A={'lc' 'K22_5A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_6A={'lc' 'K22_6A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_7A={'lc' 'K22_7A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_8A={'lc' 'K22_8A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K22_8D={'lc' 'K22_8D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_2A={'lc' 'K23_2A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_3A={'lc' 'K23_3A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_4A={'lc' 'K23_4A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_5A={'lc' 'K23_5A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_6A={'lc' 'K23_6A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_7A={'lc' 'K23_7A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_8A={'lc' 'K23_8A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K23_8D={'lc' 'K23_8D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_2A={'lc' 'K24_2A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_3A={'lc' 'K24_3A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_4A={'lc' 'K24_4A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_5A={'lc' 'K24_5A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_6A={'lc' 'K24_6A' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
K24_6D={'lc' 'K24_6D' DLWL10 [SBANDF P25*GRADL2*DLWL10 PHIL2*TWOPI]}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC21402={'mo' 'XC21402' 0 []}';%fast-feedback (loop-2)
XC21502={'mo' 'XC21502' 0 []}';
XC21602={'mo' 'XC21602' 0 []}';
XC21702={'mo' 'XC21702' 0 []}';
XC21802={'mo' 'XC21802' 0 []}';%fast-feedback (loop-2)
XC21900={'mo' 'XC21900' 0 []}';
XC22202={'mo' 'XC22202' 0 []}';
XC22302={'mo' 'XC22302' 0 []}';
XC22402={'mo' 'XC22402' 0 []}';
XC22502={'mo' 'XC22502' 0 []}';
XC22602={'mo' 'XC22602' 0 []}';
XC22702={'mo' 'XC22702' 0 []}';
XC22802={'mo' 'XC22802' 0 []}';
XC22900={'mo' 'XC22900' 0 []}';
XC23202={'mo' 'XC23202' 0 []}';
XC23302={'mo' 'XC23302' 0 []}';
XC23402={'mo' 'XC23402' 0 []}';
XC23502={'mo' 'XC23502' 0 []}';
XC23602={'mo' 'XC23602' 0 []}';
XC23702={'mo' 'XC23702' 0 []}';
XC23802={'mo' 'XC23802' 0 []}';
XC23900={'mo' 'XC23900' 0 []}';
XC24202={'mo' 'XC24202' 0 []}';
XC24302={'mo' 'XC24302' 0 []}';
XC24402={'mo' 'XC24402' 0 []}';
XC24502={'mo' 'XC24502' 0 []}';
XC24602={'mo' 'XC24602' 0 []}';
XC24702={'mo' 'XC24702' 0 []}';%calibrated to <1%
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC21403={'mo' 'YC21403' 0 []}';
YC21503={'mo' 'YC21503' 0 []}';%fast-feedback (loop-2)
YC21603={'mo' 'YC21603' 0 []}';
YC21703={'mo' 'YC21703' 0 []}';
YC21803={'mo' 'YC21803' 0 []}';
YC21900={'mo' 'YC21900' 0 []}';%fast-feedback (loop-2)
YC22203={'mo' 'YC22203' 0 []}';
YC22303={'mo' 'YC22303' 0 []}';
YC22403={'mo' 'YC22403' 0 []}';
YC22503={'mo' 'YC22503' 0 []}';
YC22603={'mo' 'YC22603' 0 []}';
YC22703={'mo' 'YC22703' 0 []}';
YC22803={'mo' 'YC22803' 0 []}';
YC22900={'mo' 'YC22900' 0 []}';
YC23203={'mo' 'YC23203' 0 []}';
YC23303={'mo' 'YC23303' 0 []}';
YC23403={'mo' 'YC23403' 0 []}';
YC23503={'mo' 'YC23503' 0 []}';
YC23603={'mo' 'YC23603' 0 []}';
YC23703={'mo' 'YC23703' 0 []}';
YC23803={'mo' 'YC23803' 0 []}';
YC23900={'mo' 'YC23900' 0 []}';
YC24203={'mo' 'YC24203' 0 []}';
YC24303={'mo' 'YC24303' 0 []}';
YC24403={'mo' 'YC24403' 0 []}';
YC24503={'mo' 'YC24503' 0 []}';
YC24603={'mo' 'YC24603' 0 []}';
YC24703={'mo' 'YC24703' 0 []}';%calibrated to <1%
% ==============================================================================
% ultrafast stripline kickers for LCLS Multibunch project
% ------------------------------------------------------------------------------
LUFKICK =  0.300 ;%electrical length (m)
BKY21929={'mo' 'BKY21929' LUFKICK []}';
BKX21957={'mo' 'BKX21957' LUFKICK []}';
BKY22929={'mo' 'BKY22929' LUFKICK []}';
BKX22957={'mo' 'BKX22957' LUFKICK []}';
D219A={'dr' '' 0.4609-LUFKICK/2 []}';
D219B={'dr' '' 0.5439-LUFKICK []}';
D219C={'dr' '' DAQ4{3}-D219A{3}-LUFKICK-D219B{3}-LUFKICK []}';
D229A={'dr' '' D219A{3} []}';
D229B={'dr' '' D219B{3} []}';
D229C={'dr' '' D219C{3} []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K21_3B_FULL=[K21_3B1,K21_3B2];
K21_3C_FULL=[K21_3C];
K21_3D_FULL=[K21_3D];
K21_4A_FULL=[K21_4A1,XC21402,K21_4A2,YC21403,K21_4A3];
K21_4B_FULL=[K21_4B];
K21_4C_FULL=[K21_4C];
K21_4D_FULL=[K21_4D];
K21_5A_FULL=[K21_5A1,XC21502,K21_5A2,YC21503,K21_5A3];
K21_5B_FULL=[K21_5B];
K21_5C_FULL=[K21_5C];
K21_5D_FULL=[K21_5D];
K21_6A_FULL=[K21_6A1,XC21602,K21_6A2,YC21603,K21_6A3];
K21_6B_FULL=[K21_6B];
K21_6C_FULL=[K21_6C];
K21_6D_FULL=[K21_6D];
K21_7A_FULL=[K21_7A1,XC21702,K21_7A2,YC21703,K21_7A3];
K21_7B_FULL=[K21_7B];
K21_7C_FULL=[K21_7C];
K21_7D_FULL=[K21_7D];
K21_8A_FULL=[K21_8A1,XC21802,K21_8A2,YC21803,K21_8A3];
K21_8B_FULL=[K21_8B];
K21_8C_FULL=[K21_8C];
K21_8D_FULL=[K21_8D1,XC21900,K21_8D2,YC21900,K21_8D3];
Q21401_FULL=[Q21401,BPM21401,Q21401];
Q21501_FULL=[Q21501,BPM21501,Q21501];
Q21601_FULL=[Q21601,BPM21601,Q21601];
Q21701_FULL=[Q21701,BPM21701,Q21701];
Q21801_FULL=[Q21801,BPM21801,Q21801];
Q21901_FULL=[Q21901,BPM21901,Q21901];
LI21=[LI21BEG,ZLIN04,K21_3B_FULL,K21_3C_FULL,K21_3D_FULL,DAQ1,Q21401_FULL,DAQ2,K21_4A_FULL,K21_4B_FULL,K21_4C_FULL,K21_4D_FULL,DAQ1,Q21501_FULL,DAQ2,K21_5A_FULL,K21_5B_FULL,K21_5C_FULL,K21_5D_FULL,DAQ1,Q21601_FULL,DAQ2,K21_6A_FULL,K21_6B_FULL,K21_6C_FULL,K21_6D_FULL,DAQ1,Q21701_FULL,DAQ2,K21_7A_FULL,K21_7B_FULL,K21_7C_FULL,K21_7D_FULL,DAQ1,Q21801_FULL,DAQ2,K21_8A_FULL,K21_8B_FULL,K21_8C_FULL,K21_8D_FULL,DAQ3,Q21901_FULL,D219A,BKY21929,D219B,BKX21957,D219C,LI21END];
% ------------------------------------------------------------------------------
K22_1A_FULL=[K22_1A];
K22_1B_FULL=[K22_1B];
K22_1C_FULL=[K22_1C];
K22_1D_FULL=[K22_1D];
K22_2A_FULL=[K22_2A1,XC22202,K22_2A2,YC22203,K22_2A3];
K22_2B_FULL=[K22_2B];
K22_2C_FULL=[K22_2C];
K22_2D_FULL=[K22_2D];
K22_3A_FULL=[K22_3A1,XC22302,K22_3A2,YC22303,K22_3A3];
K22_3B_FULL=[K22_3B];
K22_3C_FULL=[K22_3C];
K22_3D_FULL=[K22_3D];
K22_4A_FULL=[K22_4A1,XC22402,K22_4A2,YC22403,K22_4A3];
K22_4B_FULL=[K22_4B];
K22_4C_FULL=[K22_4C];
K22_4D_FULL=[K22_4D];
K22_5A_FULL=[K22_5A1,XC22502,K22_5A2,YC22503,K22_5A3];
K22_5B_FULL=[K22_5B];
K22_5C_FULL=[K22_5C];
K22_5D_FULL=[K22_5D];
K22_6A_FULL=[K22_6A1,XC22602,K22_6A2,YC22603,K22_6A3];
K22_6B_FULL=[K22_6B];
K22_6C_FULL=[K22_6C];
K22_6D_FULL=[K22_6D];
K22_7A_FULL=[K22_7A1,XC22702,K22_7A2,YC22703,K22_7A3];
K22_7B_FULL=[K22_7B];
K22_7C_FULL=[K22_7C];
K22_7D_FULL=[K22_7D];
K22_8A_FULL=[K22_8A1,XC22802,K22_8A2,YC22803,K22_8A3];
K22_8B_FULL=[K22_8B];
K22_8C_FULL=[K22_8C];
K22_8D_FULL=[K22_8D1,XC22900,K22_8D2,YC22900,K22_8D3];
Q22201_FULL=[Q22201,BPM22201,Q22201];
Q22301_FULL=[Q22301,BPM22301,Q22301];
Q22401_FULL=[Q22401,BPM22401,Q22401];
Q22501_FULL=[Q22501,BPM22501,Q22501];
Q22601_FULL=[Q22601,BPM22601,Q22601];
Q22701_FULL=[Q22701,BPM22701,Q22701];
Q22801_FULL=[Q22801,BPM22801,Q22801];
Q22901_FULL=[Q22901,BPM22901,Q22901];
LI22=[LI22BEG,ZLIN05,K22_1A_FULL,K22_1B_FULL,K22_1C_FULL,K22_1D_FULL,DAQ1,Q22201_FULL,DAQ2,K22_2A_FULL,K22_2B_FULL,K22_2C_FULL,K22_2D_FULL,DAQ1,Q22301_FULL,DAQ2,K22_3A_FULL,K22_3B_FULL,K22_3C_FULL,K22_3D_FULL,DAQ1,Q22401_FULL,DAQ2,K22_4A_FULL,K22_4B_FULL,K22_4C_FULL,K22_4D_FULL,DAQ1,Q22501_FULL,DAQ2,K22_5A_FULL,K22_5B_FULL,K22_5C_FULL,K22_5D_FULL,DAQ1,Q22601_FULL,DAQ2,K22_6A_FULL,K22_6B_FULL,K22_6C_FULL,K22_6D_FULL,DAQ1,Q22701_FULL,DAQ2,K22_7A_FULL,K22_7B_FULL,K22_7C_FULL,K22_7D_FULL,DAQ1,Q22801_FULL,DAQ2,K22_8A_FULL,K22_8B_FULL,K22_8C_FULL,K22_8D_FULL,DAQ3,Q22901_FULL,D229A,BKY22929,D229B,BKX22957,D229C,LI22END];
% ------------------------------------------------------------------------------
K23_1A_FULL=[K23_1A];
K23_1B_FULL=[K23_1B];
K23_1C_FULL=[K23_1C];
K23_1D_FULL=[K23_1D];
K23_2A_FULL=[K23_2A1,XC23202,K23_2A2,YC23203,K23_2A3];
K23_2B_FULL=[K23_2B];
K23_2C_FULL=[K23_2C];
K23_2D_FULL=[K23_2D];
K23_3A_FULL=[K23_3A1,XC23302,K23_3A2,YC23303,K23_3A3];
K23_3B_FULL=[K23_3B];
K23_3C_FULL=[K23_3C];
K23_3D_FULL=[K23_3D];
K23_4A_FULL=[K23_4A1,XC23402,K23_4A2,YC23403,K23_4A3];
K23_4B_FULL=[K23_4B];
K23_4C_FULL=[K23_4C];
K23_4D_FULL=[K23_4D];
K23_5A_FULL=[K23_5A1,XC23502,K23_5A2,YC23503,K23_5A3];
K23_5B_FULL=[K23_5B];
K23_5C_FULL=[K23_5C];
K23_5D_FULL=[K23_5D];
K23_6A_FULL=[K23_6A1,XC23602,K23_6A2,YC23603,K23_6A3];
K23_6B_FULL=[K23_6B];
K23_6C_FULL=[K23_6C];
K23_6D_FULL=[K23_6D];
K23_7A_FULL=[K23_7A1,XC23702,K23_7A2,YC23703,K23_7A3];
K23_7B_FULL=[K23_7B];
K23_7C_FULL=[K23_7C];
K23_7D_FULL=[K23_7D];
K23_8A_FULL=[K23_8A1,XC23802,K23_8A2,YC23803,K23_8A3];
K23_8B_FULL=[K23_8B];
K23_8C_FULL=[K23_8C];
K23_8D_FULL=[K23_8D1,XC23900,K23_8D2,YC23900,K23_8D3];
Q23201_FULL=[Q23201,BPM23201,Q23201];
Q23301_FULL=[Q23301,BPM23301,Q23301];
Q23401_FULL=[Q23401,BPM23401,Q23401];
Q23501_FULL=[Q23501,BPM23501,Q23501];
Q23601_FULL=[Q23601,BPM23601,Q23601];
Q23701_FULL=[Q23701,BPM23701,Q23701];
Q23801_FULL=[Q23801,BPM23801,Q23801];
Q23901_FULL=[Q23901,BPM23901,Q23901];
LI23=[LI23BEG,ZLIN06,K23_1A_FULL,K23_1B_FULL,K23_1C_FULL,K23_1D_FULL,DAQ1,Q23201_FULL,DAQ2,K23_2A_FULL,K23_2B_FULL,K23_2C_FULL,K23_2D_FULL,DAQ1,Q23301_FULL,DAQ2,K23_3A_FULL,K23_3B_FULL,K23_3C_FULL,K23_3D_FULL,DAQ1,Q23401_FULL,DAQ2,K23_4A_FULL,K23_4B_FULL,K23_4C_FULL,K23_4D_FULL,DAQ1,Q23501_FULL,DAQ2,K23_5A_FULL,K23_5B_FULL,K23_5C_FULL,K23_5D_FULL,DAQ1,Q23601_FULL,DAQ2,K23_6A_FULL,K23_6B_FULL,K23_6C_FULL,K23_6D_FULL,DAQ1,Q23701_FULL,DAQ2,K23_7A_FULL,K23_7B_FULL,K23_7C_FULL,K23_7D_FULL,DAQ1,Q23801_FULL,DAQ2,K23_8A_FULL,K23_8B_FULL,K23_8C_FULL,K23_8D_FULL,DAQ3,Q23901_FULL,DAQ4,LI23END];
% ------------------------------------------------------------------------------
K24_1A_FULL=[K24_1A];
K24_1B_FULL=[K24_1B];
K24_1C_FULL=[K24_1C];
K24_1D_FULL=[K24_1D];
K24_2A_FULL=[K24_2A1,XC24202,K24_2A2,YC24203,K24_2A3];
K24_2B_FULL=[K24_2B];
K24_2C_FULL=[K24_2C];
K24_2D_FULL=[K24_2D];
K24_3A_FULL=[K24_3A1,XC24302,K24_3A2,YC24303,K24_3A3];
K24_3B_FULL=[K24_3B];
K24_3C_FULL=[K24_3C];
K24_3D_FULL=[K24_3D];
K24_4A_FULL=[K24_4A1,XC24402,K24_4A2,YC24403,K24_4A3];
K24_4B_FULL=[K24_4B];
K24_4C_FULL=[K24_4C];
K24_4D_FULL=[K24_4D];
K24_5A_FULL=[K24_5A1,XC24502,K24_5A2,YC24503,K24_5A3];
K24_5B_FULL=[K24_5B];
K24_5C_FULL=[K24_5C];
K24_5D_FULL=[K24_5D];
K24_6A_FULL=[K24_6A1,XC24602,K24_6A2,YC24603,K24_6A3];
K24_6B_FULL=[K24_6B];
K24_6C_FULL=[K24_6C];
K24_6D_FULL=[K24_6D1,XC24702,K24_6D2,YC24703,K24_6D3];
Q24201_FULL=[Q24201,BPM24201,Q24201];
Q24301_FULL=[Q24301,BPM24301,Q24301];
Q24401_FULL=[Q24401,BPM24401,Q24401];
Q24501_FULL=[Q24501,BPM24501,Q24501];
Q24601_FULL=[Q24601,BPM24601,Q24601];
LI24=[LI24BEG,ZLIN07,K24_1A_FULL,K24_1B_FULL,K24_1C_FULL,K24_1D_FULL,DAQ1,Q24201_FULL,DAQ2,K24_2A_FULL,K24_2B_FULL,K24_2C_FULL,K24_2D_FULL,DAQ1,Q24301_FULL,DAQ2,K24_3A_FULL,K24_3B_FULL,K24_3C_FULL,K24_3D_FULL,DAQ1,Q24401_FULL,DAQ2,K24_4A_FULL,K24_4B_FULL,K24_4C_FULL,K24_4D_FULL,DAQ1,Q24501_FULL,DAQ2,K24_5A_FULL,K24_5B_FULL,K24_5C_FULL,K24_5D_FULL,DAQ1,Q24601_FULL,DAQ2,K24_6A_FULL,K24_6B_FULL,K24_6C_FULL,K24_6D_FULL,LI24TERM];
% ------------------------------------------------------------------------------
L2=[BEGL2,LI21,LI22,LI23,LI24,ENDL2];
% ==============================================================================

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% ==============================================================================
% 05-MAY-2017, M. Woodley
%    Remove OTR22; change name: C30096 -> C29956
% ------------------------------------------------------------------------------
% 23-FEB-2017, M. Woodley
%    Swap locations of XC30900 and YC30900 per J. Sheppard
% ------------------------------------------------------------------------------
% 04-NOV-2016, M. Woodley
%    Make definitions of drifts around LI27/LI28 wire scanners consistent
% ------------------------------------------------------------------------------
% 15-NOV-2011, M. Woodley
%    Change LI30 wraparound quads (QUAD LI30 615 and QUAD LI30 715) to MARKERs
% 24-OCT-2008, M. Woodley
%    Change XC29092, YC29092, XC29095, and YC29095 to MARK ... the physical
%    devices are still there, but they won't be used
% 18-SEP-2008, M. Woodley
%    Fixed structure counts in header comments
% 17-AUG-2008, P. Emma
%    K25_1d was changed back to LCAVITY (from D25_1d) and uses P50 (should since Jan. 2008)
%    K25_3c LCAVITY was changed to use P50 (should since Jan. 2008)
%    K28_5c LCAVITY was changed to use P50 (should since Jan. 2008)
% 02-JAN-2008, P. Emma
%    Rename sec-28 wires (WS044 -> WS27644, WS144 -> WS28144,
%    WS444 -> WS28444, WS544 -> WS28744).
% 04-NOV-2007, P. Emma
%    Move XC25502 & YC25503 to downstream of Q25501, as they should be (were upstream).
%    Remove XC29090, YC29090, XC29096, and YC29096 correctors (not installed).
% 04-OCT-2007, P. Emma
%    Remove D25cm from upbeam of TCAV3 and replace with 25-cm longer D255c, which
%    was negative
% 11-SEP-2007, P. Emma
%    Move BL22 from near BX24 to just upbeam of OTR22 & remove 25_1c, 1d, and
%    28-5d (these no longer re-installed into linac due to money limits).
% 10-DEC-2006, P. Emma
%    Move BXKIK to 25-3d where it will fit after removing the 25-3d RF acc.
%    structure.  Also add OTR22 near BXKIK.
% 03-DEC-2006, P. Emma
%    Move IMBC2O toroid to upbeam of BXKIK (from QM22 area).
% 02-AUG-2006, M. Woodley
%    Reinstate LI30 wraparound quads (QUAD LI30 615 and QUAD LI30 715) as
%    quadrupoles (NOTE: uses negative drifts)
% 29-NOV-2005, P. Emma
%    Add types for LCAV's, HKIC's, and VKIC's.
% 13-JUL-2005, P. Emma
%    Move TCAV3 to 25-2d for better sigZ resolution (was 25-5a).  Restored 25-5a
%    and removed 25-2d.
% 06-JUL-2005, P. Emma
%    Rename TCAVH to TCAV3.
% 02-JUN-2005, P. Emma
%    Add comments adjacent to fast-feedback correctors.
% ==============================================================================
% LCAVs
% ------------------------------------------------------------------------------
% the L3 linac consists of: 161 10   ft S-band sections @ 25% power
%                            12 10   ft S-band sections @ 50% power
%                             3  9.4 ft S-band sections @ 25% power
%                             4  7   ft S-band sections @ 25% power
% ------------------------------------------------------------------------------
% klystron ON/OFF switches
A25_1 =  1 ;
A25_2 =  1 ;
A25_3 =  1 ;
A25_4 =  1;
A25_5 =  1 ;
A25_6 =  1 ;
A25_7 =  1 ;
A25_8 =  1;
A26_1 =  1 ;
A26_2 =  1 ;
A26_3 =  1 ;
A26_4 =  1;
A26_5 =  1 ;
A26_6 =  1 ;
A26_7 =  1 ;
A26_8 =  1;
A27_1 =  0 ;
A27_2 =  0 ;
A27_3 =  0 ;
A27_4 =  0;
A27_5 =  0 ;
A27_6 =  0 ;
A27_7 =  0 ;
A27_8 =  0;
A28_1 =  0 ;
A28_2 =  0 ;
A28_3 =  0 ;
A28_4 =  0;
A28_5 =  0 ;
A28_6 =  0 ;
A28_7 =  0 ;
A28_8 =  0;
A29_1 =  0 ;
A29_2 =  0 ;
A29_3 =  0 ;
A29_4 =  0;
A29_5 =  0 ;
A29_6 =  0 ;
A29_7 =  0 ;
A29_8 =  0;
A30_1 =  0 ;
A30_2 =  0 ;
A30_3 =  0 ;
A30_4 =  0;
A30_5 =  0 ;
A30_6 =  0 ;
A30_7 =  0 ;
A30_8 =  0;
% structures
K25_1A1={'lc' 'K25_1A' 0.3250 [SBANDF A25_1*P25*GRADL3*0.3250 PHIL3*TWOPI]}';
K25_1A2={'lc' 'K25_1A' 0.3250 [SBANDF A25_1*P25*GRADL3*0.3250 PHIL3*TWOPI]}';
K25_1A3={'lc' 'K25_1A' 2.3941 [SBANDF A25_1*P25*GRADL3*2.3941 PHIL3*TWOPI]}';
K25_1B={'lc' 'K25_1B' DLWL10 [SBANDF A25_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
D25_1C={'dr' '' DLWL10 []}';
K25_1D={'lc' 'K25_1D' DLWL10 [SBANDF A25_1*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_2A1={'lc' 'K25_2A' 0.4530 [SBANDF A25_2*P25*GRADL3*0.4530 PHIL3*TWOPI]}';
K25_2A2={'lc' 'K25_2A' 0.3175 [SBANDF A25_2*P25*GRADL3*0.3175 PHIL3*TWOPI]}';
K25_2A3={'lc' 'K25_2A' 2.2736 [SBANDF A25_2*P25*GRADL3*2.2736 PHIL3*TWOPI]}';
K25_2B={'lc' 'K25_2B' DLWL10 [SBANDF A25_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_2C={'lc' 'K25_2C' DLWL10 [SBANDF A25_2*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_3A1={'lc' 'K25_3A' 0.3312 [SBANDF A25_3*P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K25_3A2={'lc' 'K25_3A' 0.3504 [SBANDF A25_3*P25*GRADL3*0.3504 PHIL3*TWOPI]}';
K25_3A3={'lc' 'K25_3A' 2.3625 [SBANDF A25_3*P25*GRADL3*2.3625 PHIL3*TWOPI]}';
K25_3B={'lc' 'K25_3B' DLWL10 [SBANDF A25_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_3C={'lc' 'K25_3C' DLWL10 [SBANDF A25_3*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_4A1={'lc' 'K25_4A' 0.3268 [SBANDF A25_4*P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K25_4A2={'lc' 'K25_4A' 0.2500 [SBANDF A25_4*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_4A3={'lc' 'K25_4A' 2.4673 [SBANDF A25_4*P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K25_4B={'lc' 'K25_4B' DLWL10 [SBANDF A25_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_4C={'lc' 'K25_4C' DLWL10 [SBANDF A25_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_4D={'lc' 'K25_4D' DLWL10 [SBANDF A25_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_5A1={'lc' 'K25_5A' 0.3268 [SBANDF A25_5*P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K25_5A2={'lc' 'K25_5A' 0.2500 [SBANDF A25_5*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_5A3={'lc' 'K25_5A' 2.4673 [SBANDF A25_5*P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K25_5B={'lc' 'K25_5B' DLWL10 [SBANDF A25_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_5C={'lc' 'K25_5C' DLWL10 [SBANDF A25_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_5D={'lc' 'K25_5D' DLWL10 [SBANDF A25_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_6A1={'lc' 'K25_6A' 0.3280 [SBANDF A25_6*P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K25_6A2={'lc' 'K25_6A' 0.3822 [SBANDF A25_6*P25*GRADL3*0.3822 PHIL3*TWOPI]}';
K25_6A3={'lc' 'K25_6A' 2.3339 [SBANDF A25_6*P25*GRADL3*2.3339 PHIL3*TWOPI]}';
K25_6B={'lc' 'K25_6B' DLWL10 [SBANDF A25_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_6C={'lc' 'K25_6C' DLWL10 [SBANDF A25_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_6D={'lc' 'K25_6D' DLWL10 [SBANDF A25_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_7A1={'lc' 'K25_7A' 0.3336 [SBANDF A25_7*P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K25_7A2={'lc' 'K25_7A' 0.2500 [SBANDF A25_7*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_7A3={'lc' 'K25_7A' 2.4605 [SBANDF A25_7*P25*GRADL3*2.4605 PHIL3*TWOPI]}';
K25_7B={'lc' 'K25_7B' DLWL10 [SBANDF A25_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_7C={'lc' 'K25_7C' DLWL10 [SBANDF A25_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_7D={'lc' 'K25_7D' DLWL10 [SBANDF A25_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_8A1={'lc' 'K25_8A' 0.3292 [SBANDF A25_8*P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K25_8A2={'lc' 'K25_8A' 0.2500 [SBANDF A25_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_8A3={'lc' 'K25_8A' 2.4649 [SBANDF A25_8*P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K25_8B={'lc' 'K25_8B' DLWL10 [SBANDF A25_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_8C={'lc' 'K25_8C' DLWL10 [SBANDF A25_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_8D1={'lc' 'K25_8D' 2.3869 [SBANDF A25_8*P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K25_8D2={'lc' 'K25_8D' 0.2500 [SBANDF A25_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K25_8D3={'lc' 'K25_8D' 0.4072 [SBANDF A25_8*P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K26_1A={'lc' 'K26_1A' DLWL10 [SBANDF A26_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_1B={'lc' 'K26_1B' DLWL10 [SBANDF A26_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_1C={'lc' 'K26_1C' DLWL10 [SBANDF A26_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_1D={'lc' 'K26_1D' DLWL10 [SBANDF A26_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_2A1={'lc' 'K26_2A' 0.3256 [SBANDF A26_2*P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K26_2A2={'lc' 'K26_2A' 0.3719 [SBANDF A26_2*P25*GRADL3*0.3719 PHIL3*TWOPI]}';
K26_2A3={'lc' 'K26_2A' 2.3466 [SBANDF A26_2*P25*GRADL3*2.3466 PHIL3*TWOPI]}';
K26_2B={'lc' 'K26_2B' DLWL10 [SBANDF A26_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_2C={'lc' 'K26_2C' DLWL10 [SBANDF A26_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_2D={'lc' 'K26_2D' DLWL10 [SBANDF A26_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_3A1={'lc' 'K26_3A' 0.3312 [SBANDF A26_3*P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K26_3A2={'lc' 'K26_3A' 0.2500 [SBANDF A26_3*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_3A3={'lc' 'K26_3A' 2.4629 [SBANDF A26_3*P25*GRADL3*2.4629 PHIL3*TWOPI]}';
K26_3B={'lc' 'K26_3B' DLWL10 [SBANDF A26_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_3C={'lc' 'K26_3C' DLWL10 [SBANDF A26_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_3D={'lc' 'K26_3D' DLWL10 [SBANDF A26_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_4A1={'lc' 'K26_4A' 0.3268 [SBANDF A26_4*P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K26_4A2={'lc' 'K26_4A' 0.2500 [SBANDF A26_4*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_4A3={'lc' 'K26_4A' 2.4673 [SBANDF A26_4*P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K26_4B={'lc' 'K26_4B' DLWL10 [SBANDF A26_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_4C={'lc' 'K26_4C' DLWL10 [SBANDF A26_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_4D={'lc' 'K26_4D' DLWL10 [SBANDF A26_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_5A1={'lc' 'K26_5A' 0.3324 [SBANDF A26_5*P25*GRADL3*0.3324 PHIL3*TWOPI]}';
K26_5A2={'lc' 'K26_5A' 0.2500 [SBANDF A26_5*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_5A3={'lc' 'K26_5A' 2.4617 [SBANDF A26_5*P25*GRADL3*2.4617 PHIL3*TWOPI]}';
K26_5B={'lc' 'K26_5B' DLWL10 [SBANDF A26_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_5C={'lc' 'K26_5C' DLWL10 [SBANDF A26_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_5D={'lc' 'K26_5D' DLWL10 [SBANDF A26_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_6A1={'lc' 'K26_6A' 0.3280 [SBANDF A26_6*P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K26_6A2={'lc' 'K26_6A' 0.4108 [SBANDF A26_6*P25*GRADL3*0.4108 PHIL3*TWOPI]}';
K26_6A3={'lc' 'K26_6A' 2.3053 [SBANDF A26_6*P25*GRADL3*2.3053 PHIL3*TWOPI]}';
K26_6B={'lc' 'K26_6B' DLWL10 [SBANDF A26_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_6C={'lc' 'K26_6C' DLWL10 [SBANDF A26_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_6D={'lc' 'K26_6D' DLWL10 [SBANDF A26_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_7A1={'lc' 'K26_7A' 0.3336 [SBANDF A26_7*P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K26_7A2={'lc' 'K26_7A' 0.2500 [SBANDF A26_7*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_7A3={'lc' 'K26_7A' 2.4605 [SBANDF A26_7*P25*GRADL3*2.4605 PHIL3*TWOPI]}';
K26_7B={'lc' 'K26_7B' DLWL10 [SBANDF A26_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_7C={'lc' 'K26_7C' DLWL10 [SBANDF A26_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_7D={'lc' 'K26_7D' DLWL10 [SBANDF A26_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_8A1={'lc' 'K26_8A' 0.3292 [SBANDF A26_8*P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K26_8A2={'lc' 'K26_8A' 0.3810 [SBANDF A26_8*P25*GRADL3*0.3810 PHIL3*TWOPI]}';
K26_8A3={'lc' 'K26_8A' 2.3339 [SBANDF A26_8*P25*GRADL3*2.3339 PHIL3*TWOPI]}';
K26_8B={'lc' 'K26_8B' DLWL10 [SBANDF A26_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_8C={'lc' 'K26_8C' DLWL10 [SBANDF A26_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_8D1={'lc' 'K26_8D' 2.3869 [SBANDF A26_8*P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K26_8D2={'lc' 'K26_8D' 0.2500 [SBANDF A26_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K26_8D3={'lc' 'K26_8D' 0.4072 [SBANDF A26_8*P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K27_1A={'lc' 'K27_1A' DLWL10 [SBANDF A27_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_1B={'lc' 'K27_1B' DLWL10 [SBANDF A27_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_1C={'lc' 'K27_1C' DLWL10 [SBANDF A27_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_1D={'lc' 'K27_1D' DLWL10 [SBANDF A27_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_2A1={'lc' 'K27_2A' 0.3256 [SBANDF A27_2*P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K27_2A2={'lc' 'K27_2A' 0.2500 [SBANDF A27_2*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_2A3={'lc' 'K27_2A' 2.4685 [SBANDF A27_2*P25*GRADL3*2.4685 PHIL3*TWOPI]}';
K27_2B={'lc' 'K27_2B' DLWL10 [SBANDF A27_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_2C={'lc' 'K27_2C' DLWL10 [SBANDF A27_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_2D={'lc' 'K27_2D' DLWL10 [SBANDF A27_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_3A1={'lc' 'K27_3A' 0.3312 [SBANDF A27_3*P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K27_3A2={'lc' 'K27_3A' 0.3695 [SBANDF A27_3*P25*GRADL3*0.3695 PHIL3*TWOPI]}';
K27_3A3={'lc' 'K27_3A' 2.3434 [SBANDF A27_3*P25*GRADL3*2.3434 PHIL3*TWOPI]}';
K27_3B={'lc' 'K27_3B' DLWL10 [SBANDF A27_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_3C={'lc' 'K27_3C' DLWL10 [SBANDF A27_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_3D={'lc' 'K27_3D' DLWL10 [SBANDF A27_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_4A1={'lc' 'K27_4A' 0.3268 [SBANDF A27_4*P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K27_4A2={'lc' 'K27_4A' 0.2500 [SBANDF A27_4*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_4A3={'lc' 'K27_4A' 2.4673 [SBANDF A27_4*P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K27_4B={'lc' 'K27_4B' DLWL10 [SBANDF A27_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_4C={'lc' 'K27_4C' DLWL10 [SBANDF A27_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_4D={'lc' 'K27_4D' DLWL10 [SBANDF A27_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_5A1={'lc' 'K27_5A' 0.3324 [SBANDF A27_5*P25*GRADL3*0.3324 PHIL3*TWOPI]}';
K27_5A2={'lc' 'K27_5A' 0.3683 [SBANDF A27_5*P25*GRADL3*0.3683 PHIL3*TWOPI]}';
K27_5A3={'lc' 'K27_5A' 2.3434 [SBANDF A27_5*P25*GRADL3*2.3434 PHIL3*TWOPI]}';
K27_5B={'lc' 'K27_5B' DLWL10 [SBANDF A27_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_5C={'lc' 'K27_5C' DLWL10 [SBANDF A27_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_5D={'lc' 'K27_5D' DLWL10 [SBANDF A27_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_6A1={'lc' 'K27_6A' 0.3280 [SBANDF A27_6*P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K27_6A2={'lc' 'K27_6A' 0.2500 [SBANDF A27_6*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_6A3={'lc' 'K27_6A' 2.4661 [SBANDF A27_6*P25*GRADL3*2.4661 PHIL3*TWOPI]}';
K27_6B={'lc' 'K27_6B' DLWL10 [SBANDF A27_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_6C={'lc' 'K27_6C' DLWL10 [SBANDF A27_6*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_7A1={'lc' 'K27_7A' 0.3336 [SBANDF A27_7*P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K27_7A2={'lc' 'K27_7A' 0.3512 [SBANDF A27_7*P25*GRADL3*0.3512 PHIL3*TWOPI]}';
K27_7A3={'lc' 'K27_7A' 2.3593 [SBANDF A27_7*P25*GRADL3*2.3593 PHIL3*TWOPI]}';
K27_7B={'lc' 'K27_7B' DLWL10 [SBANDF A27_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_7C={'lc' 'K27_7C' DLWL10 [SBANDF A27_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_7D={'lc' 'K27_7D' DLWL10 [SBANDF A27_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_8A1={'lc' 'K27_8A' 0.3292 [SBANDF A27_8*P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K27_8A2={'lc' 'K27_8A' 0.2500 [SBANDF A27_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K27_8A3={'lc' 'K27_8A' 2.4649 [SBANDF A27_8*P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K27_8B={'lc' 'K27_8B' DLWL10 [SBANDF A27_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_8C={'lc' 'K27_8C' DLWL10 [SBANDF A27_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_8D1={'lc' 'K27_8D' 2.2411 [SBANDF A27_8*P25*GRADL3*2.2411 PHIL3*TWOPI]}';
K27_8D2={'lc' 'K27_8D' 0.3958 [SBANDF A27_8*P25*GRADL3*0.3958 PHIL3*TWOPI]}';
K27_8D3={'lc' 'K27_8D' 0.4072 [SBANDF A27_8*P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K28_1A={'lc' 'K28_1A' DLWL10 [SBANDF A28_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_1B={'lc' 'K28_1B' DLWL10 [SBANDF A28_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_1C={'lc' 'K28_1C' DLWL10 [SBANDF A28_1*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_2A1={'lc' 'K28_2A' 0.3256 [SBANDF A28_2*P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K28_2A2={'lc' 'K28_2A' 0.2500 [SBANDF A28_2*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_2A3={'lc' 'K28_2A' 2.4685 [SBANDF A28_2*P25*GRADL3*2.4685 PHIL3*TWOPI]}';
K28_2B={'lc' 'K28_2B' DLWL10 [SBANDF A28_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_2C={'lc' 'K28_2C' DLWL10 [SBANDF A28_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_2D={'lc' 'K28_2D' DLWL10 [SBANDF A28_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_3A1={'lc' 'K28_3A' 0.3312 [SBANDF A28_3*P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K28_3A2={'lc' 'K28_3A' 0.2500 [SBANDF A28_3*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_3A3={'lc' 'K28_3A' 2.4629 [SBANDF A28_3*P25*GRADL3*2.4629 PHIL3*TWOPI]}';
K28_3B={'lc' 'K28_3B' DLWL10 [SBANDF A28_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_3C={'lc' 'K28_3C' DLWL10 [SBANDF A28_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_3D={'lc' 'K28_3D' DLWL10 [SBANDF A28_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_4A1={'lc' 'K28_4A' 0.3800 [SBANDF A28_4*P25*GRADL3*0.3800 PHIL3*TWOPI]}';
K28_4A2={'lc' 'K28_4A' 0.2921 [SBANDF A28_4*P25*GRADL3*0.2921 PHIL3*TWOPI]}';
K28_4A3={'lc' 'K28_4A' 2.3720 [SBANDF A28_4*P25*GRADL3*2.3720 PHIL3*TWOPI]}';
K28_4B={'lc' 'K28_4B' DLWL10 [SBANDF A28_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_4C={'lc' 'K28_4C' DLWL10 [SBANDF A28_4*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_5A1={'lc' 'K28_5A' 0.3959 [SBANDF A28_5*P25*GRADL3*0.3959 PHIL3*TWOPI]}';
K28_5A2={'lc' 'K28_5A' 0.3111 [SBANDF A28_5*P25*GRADL3*0.3111 PHIL3*TWOPI]}';
K28_5A3={'lc' 'K28_5A' 2.3371 [SBANDF A28_5*P25*GRADL3*2.3371 PHIL3*TWOPI]}';
K28_5B={'lc' 'K28_5B' DLWL10 [SBANDF A28_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_5C={'lc' 'K28_5C' DLWL10 [SBANDF A28_5*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
D28_5D={'dr' '' DLWL10 []}';
K28_6A1={'lc' 'K28_6A' 0.3280 [SBANDF A28_6*P25*GRADL3*0.3280 PHIL3*TWOPI]}';
K28_6A2={'lc' 'K28_6A' 0.3600 [SBANDF A28_6*P25*GRADL3*0.3600 PHIL3*TWOPI]}';
K28_6A3={'lc' 'K28_6A' 2.3561 [SBANDF A28_6*P25*GRADL3*2.3561 PHIL3*TWOPI]}';
K28_6B={'lc' 'K28_6B' DLWL10 [SBANDF A28_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_6C={'lc' 'K28_6C' DLWL10 [SBANDF A28_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_6D={'lc' 'K28_6D' DLWL10 [SBANDF A28_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_7A1={'lc' 'K28_7A' 0.3336 [SBANDF A28_7*P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K28_7A2={'lc' 'K28_7A' 0.4052 [SBANDF A28_7*P25*GRADL3*0.4052 PHIL3*TWOPI]}';
K28_7A3={'lc' 'K28_7A' 2.3053 [SBANDF A28_7*P25*GRADL3*2.3053 PHIL3*TWOPI]}';
K28_7B={'lc' 'K28_7B' DLWL10 [SBANDF A28_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_7C={'lc' 'K28_7C' DLWL10 [SBANDF A28_7*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_8A1={'lc' 'K28_8A' 0.3292 [SBANDF A28_8*P25*GRADL3*0.3292 PHIL3*TWOPI]}';
K28_8A2={'lc' 'K28_8A' 0.2500 [SBANDF A28_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_8A3={'lc' 'K28_8A' 2.4649 [SBANDF A28_8*P25*GRADL3*2.4649 PHIL3*TWOPI]}';
K28_8B={'lc' 'K28_8B' DLWL10 [SBANDF A28_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_8C={'lc' 'K28_8C' DLWL10 [SBANDF A28_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_8D1={'lc' 'K28_8D' 2.3869 [SBANDF A28_8*P25*GRADL3*2.3869 PHIL3*TWOPI]}';
K28_8D2={'lc' 'K28_8D' 0.2500 [SBANDF A28_8*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K28_8D3={'lc' 'K28_8D' 0.4072 [SBANDF A28_8*P25*GRADL3*0.4072 PHIL3*TWOPI]}';
K29_1A={'lc' 'K29_1A' DLWL10 [SBANDF A29_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_1B={'lc' 'K29_1B' DLWL10 [SBANDF A29_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_1C={'lc' 'K29_1C' DLWL10 [SBANDF A29_1*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_2A1={'lc' 'K29_2A' 0.3256 [SBANDF A29_2*P25*GRADL3*0.3256 PHIL3*TWOPI]}';
K29_2A2={'lc' 'K29_2A' 0.3528 [SBANDF A29_2*P25*GRADL3*0.3528 PHIL3*TWOPI]}';
K29_2A3={'lc' 'K29_2A' 2.3657 [SBANDF A29_2*P25*GRADL3*2.3657 PHIL3*TWOPI]}';
K29_2B={'lc' 'K29_2B' DLWL10 [SBANDF A29_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_2C={'lc' 'K29_2C' DLWL10 [SBANDF A29_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_2D={'lc' 'K29_2D' DLWL10 [SBANDF A29_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_3A1={'lc' 'K29_3A' 0.3312 [SBANDF A29_3*P25*GRADL3*0.3312 PHIL3*TWOPI]}';
K29_3A2={'lc' 'K29_3A' 0.3599 [SBANDF A29_3*P25*GRADL3*0.3599 PHIL3*TWOPI]}';
K29_3A3={'lc' 'K29_3A' 2.3530 [SBANDF A29_3*P25*GRADL3*2.3530 PHIL3*TWOPI]}';
K29_3B={'lc' 'K29_3B' DLWL10 [SBANDF A29_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_3C={'lc' 'K29_3C' DLWL10 [SBANDF A29_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_3D={'lc' 'K29_3D' DLWL10 [SBANDF A29_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_4A1={'lc' 'K29_4A' 0.3268 [SBANDF A29_4*P25*GRADL3*0.3268 PHIL3*TWOPI]}';
K29_4A2={'lc' 'K29_4A' 0.2500 [SBANDF A29_4*P25*GRADL3*0.2500 PHIL3*TWOPI]}';
K29_4A3={'lc' 'K29_4A' 2.4673 [SBANDF A29_4*P25*GRADL3*2.4673 PHIL3*TWOPI]}';
K29_4B={'lc' 'K29_4B' DLWL10 [SBANDF A29_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_4C={'lc' 'K29_4C' DLWL10 [SBANDF A29_4*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_5A1={'lc' 'K29_5A' 0.3800 [SBANDF A29_5*P25*GRADL3*0.3800 PHIL3*TWOPI]}';
K29_5A2={'lc' 'K29_5A' 0.2762 [SBANDF A29_5*P25*GRADL3*0.2762 PHIL3*TWOPI]}';
K29_5A3={'lc' 'K29_5A' 2.3879 [SBANDF A29_5*P25*GRADL3*2.3879 PHIL3*TWOPI]}';
K29_5B={'lc' 'K29_5B' DLWL10 [SBANDF A29_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_5C={'lc' 'K29_5C' DLWL10 [SBANDF A29_5*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_6A1={'lc' 'K29_6A' 0.4498 [SBANDF A29_6*P25*GRADL3*0.4498 PHIL3*TWOPI]}';
K29_6A2={'lc' 'K29_6A' 0.3715 [SBANDF A29_6*P25*GRADL3*0.3715 PHIL3*TWOPI]}';
K29_6A3={'lc' 'K29_6A' 2.2228 [SBANDF A29_6*P25*GRADL3*2.2228 PHIL3*TWOPI]}';
K29_6B={'lc' 'K29_6B' DLWL10 [SBANDF A29_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_6C={'lc' 'K29_6C' DLWL10 [SBANDF A29_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_6D={'lc' 'K29_6D' DLWL10 [SBANDF A29_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_7A1={'lc' 'K29_7A' 0.3336 [SBANDF A29_7*P25*GRADL3*0.3336 PHIL3*TWOPI]}';
K29_7A2={'lc' 'K29_7A' 0.3988 [SBANDF A29_7*P25*GRADL3*0.3988 PHIL3*TWOPI]}';
K29_7A3={'lc' 'K29_7A' 2.3117 [SBANDF A29_7*P25*GRADL3*2.3117 PHIL3*TWOPI]}';
K29_7B={'lc' 'K29_7B' DLWL10 [SBANDF A29_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_7C={'lc' 'K29_7C' DLWL10 [SBANDF A29_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_7D={'lc' 'K29_7D' 2.8692 [SBANDF A29_7*P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K29_8A1={'lc' 'K29_8A' 0.3896 [SBANDF A29_8*P25*GRADL3*0.3896 PHIL3*TWOPI]}';
K29_8A2={'lc' 'K29_8A' 0.2790 [SBANDF A29_8*P25*GRADL3*0.2790 PHIL3*TWOPI]}';
K29_8A3={'lc' 'K29_8A' 2.3755 [SBANDF A29_8*P25*GRADL3*2.3755 PHIL3*TWOPI]}';
K29_8B={'lc' 'K29_8B' DLWL10 [SBANDF A29_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_8C={'lc' 'K29_8C' DLWL10 [SBANDF A29_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_8D1={'lc' 'K29_8D' 2.4558 [SBANDF A29_8*P25*GRADL3*2.4558 PHIL3*TWOPI]}';
K29_8D2={'lc' 'K29_8D' 0.2800 [SBANDF A29_8*P25*GRADL3*0.2800 PHIL3*TWOPI]}';
K29_8D3={'lc' 'K29_8D' 0.3083 [SBANDF A29_8*P25*GRADL3*0.3083 PHIL3*TWOPI]}';
K30_1A={'lc' 'K30_1A' DLWL10 [SBANDF A30_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_1B={'lc' 'K30_1B' DLWL10 [SBANDF A30_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_1C={'lc' 'K30_1C' DLWL10 [SBANDF A30_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_1D={'lc' 'K30_1D' 2.1694 [SBANDF A30_1*P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_2A1={'lc' 'K30_2A' 0.5006 [SBANDF A30_2*P25*GRADL3*0.5006 PHIL3*TWOPI]}';
K30_2A2={'lc' 'K30_2A' 0.3302 [SBANDF A30_2*P25*GRADL3*0.3302 PHIL3*TWOPI]}';
K30_2A3={'lc' 'K30_2A' 2.2133 [SBANDF A30_2*P25*GRADL3*2.2133 PHIL3*TWOPI]}';
K30_2B={'lc' 'K30_2B' DLWL10 [SBANDF A30_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_2C={'lc' 'K30_2C' DLWL10 [SBANDF A30_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_2D={'lc' 'K30_2D' DLWL10 [SBANDF A30_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_3A1={'lc' 'K30_3A' 0.3986 [SBANDF A30_3*P25*GRADL3*0.3986 PHIL3*TWOPI]}';
K30_3A2={'lc' 'K30_3A' 0.3300 [SBANDF A30_3*P25*GRADL3*0.3300 PHIL3*TWOPI]}';
K30_3A3={'lc' 'K30_3A' 2.3155 [SBANDF A30_3*P25*GRADL3*2.3155 PHIL3*TWOPI]}';
K30_3B={'lc' 'K30_3B' DLWL10 [SBANDF A30_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_3C={'lc' 'K30_3C' DLWL10 [SBANDF A30_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_3D={'lc' 'K30_3D' 2.1694 [SBANDF A30_3*P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_4A1={'lc' 'K30_4A' 0.3856 [SBANDF A30_4*P25*GRADL3*0.3856 PHIL3*TWOPI]}';
K30_4A2={'lc' 'K30_4A' 0.2790 [SBANDF A30_4*P25*GRADL3*0.2790 PHIL3*TWOPI]}';
K30_4A3={'lc' 'K30_4A' 2.3795 [SBANDF A30_4*P25*GRADL3*2.3795 PHIL3*TWOPI]}';
K30_4B={'lc' 'K30_4B' DLWL10 [SBANDF A30_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_4C={'lc' 'K30_4C' DLWL10 [SBANDF A30_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_4D={'lc' 'K30_4D' 2.1694 [SBANDF A30_4*P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_5A1={'lc' 'K30_5A' 0.3726 [SBANDF A30_5*P25*GRADL3*0.3726 PHIL3*TWOPI]}';
K30_5A2={'lc' 'K30_5A' 0.2920 [SBANDF A30_5*P25*GRADL3*0.2920 PHIL3*TWOPI]}';
K30_5A3={'lc' 'K30_5A' 2.3795 [SBANDF A30_5*P25*GRADL3*2.3795 PHIL3*TWOPI]}';
K30_5B={'lc' 'K30_5B' DLWL10 [SBANDF A30_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_5C={'lc' 'K30_5C' DLWL10 [SBANDF A30_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_5D={'lc' 'K30_5D' 2.1694 [SBANDF A30_5*P25*GRADL3*2.1694 PHIL3*TWOPI]}';
K30_6A1={'lc' 'K30_6A' 0.3940 [SBANDF A30_6*P25*GRADL3*0.3940 PHIL3*TWOPI]}';
K30_6A2={'lc' 'K30_6A' 0.3930 [SBANDF A30_6*P25*GRADL3*0.3930 PHIL3*TWOPI]}';
K30_6A3={'lc' 'K30_6A' 0.4070 [SBANDF A30_6*P25*GRADL3*0.4070 PHIL3*TWOPI]}';
K30_6A4={'lc' 'K30_6A' 0.9810 [SBANDF A30_6*P25*GRADL3*0.9810 PHIL3*TWOPI]}';
K30_6A5={'lc' 'K30_6A' 0.3550 [SBANDF A30_6*P25*GRADL3*0.3550 PHIL3*TWOPI]}';
K30_6A6={'lc' 'K30_6A' 0.5141 [SBANDF A30_6*P25*GRADL3*0.5141 PHIL3*TWOPI]}';
K30_6B={'lc' 'K30_6B' DLWL10 [SBANDF A30_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_6C={'lc' 'K30_6C' DLWL10 [SBANDF A30_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_6D={'lc' 'K30_6D' 2.8692 [SBANDF A30_6*P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K30_7A1={'lc' 'K30_7A' 0.3813 [SBANDF A30_7*P25*GRADL3*0.3813 PHIL3*TWOPI]}';
K30_7A2={'lc' 'K30_7A' 0.4317 [SBANDF A30_7*P25*GRADL3*0.4317 PHIL3*TWOPI]}';
K30_7A3={'lc' 'K30_7A' 0.3740 [SBANDF A30_7*P25*GRADL3*0.3740 PHIL3*TWOPI]}';
K30_7A4={'lc' 'K30_7A' 0.9910 [SBANDF A30_7*P25*GRADL3*0.9910 PHIL3*TWOPI]}';
K30_7A5={'lc' 'K30_7A' 0.3590 [SBANDF A30_7*P25*GRADL3*0.3590 PHIL3*TWOPI]}';
K30_7A6={'lc' 'K30_7A' 0.5071 [SBANDF A30_7*P25*GRADL3*0.5071 PHIL3*TWOPI]}';
K30_7B={'lc' 'K30_7B' DLWL10 [SBANDF A30_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_7C={'lc' 'K30_7C' DLWL10 [SBANDF A30_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_7D={'lc' 'K30_7D' 2.8692 [SBANDF A30_7*P25*GRADL3*2.8692 PHIL3*TWOPI]}';
K30_8A1={'lc' 'K30_8A' 0.3859 [SBANDF A30_8*P25*GRADL3*0.3859 PHIL3*TWOPI]}';
K30_8A2={'lc' 'K30_8A' 0.3810 [SBANDF A30_8*P25*GRADL3*0.3810 PHIL3*TWOPI]}';
K30_8A3={'lc' 'K30_8A' 2.2772 [SBANDF A30_8*P25*GRADL3*2.2772 PHIL3*TWOPI]}';
K30_8B={'lc' 'K30_8B' DLWL10 [SBANDF A30_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_8C1={'lc' 'K30_8C' 0.7620 [SBANDF A30_8*P50*GRADL3*0.7620 PHIL3*TWOPI]}';
K30_8C2={'lc' 'K30_8C' 1.4669 [SBANDF A30_8*P50*GRADL3*1.4669 PHIL3*TWOPI]}';
K30_8C3={'lc' 'K30_8C' 0.8152 [SBANDF A30_8*P50*GRADL3*0.8152 PHIL3*TWOPI]}';
% define unsplit LCAVs for BMAD ... not used by MAD
K25_1A={'lc' 'K25_1A' DLWL10 [SBANDF A25_1*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_2A={'lc' 'K25_2A' DLWL10 [SBANDF A25_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_3A={'lc' 'K25_3A' DLWL10 [SBANDF A25_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_4A={'lc' 'K25_4A' DLWL10 [SBANDF A25_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_5A={'lc' 'K25_5A' DLWL10 [SBANDF A25_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_6A={'lc' 'K25_6A' DLWL10 [SBANDF A25_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_7A={'lc' 'K25_7A' DLWL10 [SBANDF A25_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_8A={'lc' 'K25_8A' DLWL10 [SBANDF A25_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K25_8D={'lc' 'K25_8D' DLWL10 [SBANDF A25_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_2A={'lc' 'K26_2A' DLWL10 [SBANDF A26_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_3A={'lc' 'K26_3A' DLWL10 [SBANDF A26_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_4A={'lc' 'K26_4A' DLWL10 [SBANDF A26_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_5A={'lc' 'K26_5A' DLWL10 [SBANDF A26_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_6A={'lc' 'K26_6A' DLWL10 [SBANDF A26_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_7A={'lc' 'K26_7A' DLWL10 [SBANDF A26_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_8A={'lc' 'K26_8A' DLWL10 [SBANDF A26_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K26_8D={'lc' 'K26_8D' DLWL10 [SBANDF A26_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_2A={'lc' 'K27_2A' DLWL10 [SBANDF A27_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_3A={'lc' 'K27_3A' DLWL10 [SBANDF A27_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_4A={'lc' 'K27_4A' DLWL10 [SBANDF A27_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_5A={'lc' 'K27_5A' DLWL10 [SBANDF A27_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_6A={'lc' 'K27_6A' DLWL10 [SBANDF A27_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_7A={'lc' 'K27_7A' DLWL10 [SBANDF A27_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_8A={'lc' 'K27_8A' DLWL10 [SBANDF A27_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K27_8D={'lc' 'K27_8D' DLWL10 [SBANDF A27_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_2A={'lc' 'K28_2A' DLWL10 [SBANDF A28_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_3A={'lc' 'K28_3A' DLWL10 [SBANDF A28_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_4A={'lc' 'K28_4A' DLWL10 [SBANDF A28_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_5A={'lc' 'K28_5A' DLWL10 [SBANDF A28_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_6A={'lc' 'K28_6A' DLWL10 [SBANDF A28_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_7A={'lc' 'K28_7A' DLWL10 [SBANDF A28_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_8A={'lc' 'K28_8A' DLWL10 [SBANDF A28_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K28_8D={'lc' 'K28_8D' DLWL10 [SBANDF A28_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_2A={'lc' 'K29_2A' DLWL10 [SBANDF A29_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_3A={'lc' 'K29_3A' DLWL10 [SBANDF A29_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_4A={'lc' 'K29_4A' DLWL10 [SBANDF A29_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_5A={'lc' 'K29_5A' DLWL10 [SBANDF A29_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_6A={'lc' 'K29_6A' DLWL10 [SBANDF A29_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_7A={'lc' 'K29_7A' DLWL10 [SBANDF A29_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_8A={'lc' 'K29_8A' DLWL10 [SBANDF A29_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K29_8D={'lc' 'K29_8D' DLWL10 [SBANDF A29_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_2A={'lc' 'K30_2A' DLWL10 [SBANDF A30_2*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_3A={'lc' 'K30_3A' DLWL10 [SBANDF A30_3*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_4A={'lc' 'K30_4A' DLWL10 [SBANDF A30_4*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_5A={'lc' 'K30_5A' DLWL10 [SBANDF A30_5*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_6A={'lc' 'K30_6A' DLWL10 [SBANDF A30_6*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_7A={'lc' 'K30_7A' DLWL10 [SBANDF A30_7*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_8A={'lc' 'K30_8A' DLWL10 [SBANDF A30_8*P25*GRADL3*DLWL10 PHIL3*TWOPI]}';
K30_8C={'lc' 'K30_8C' DLWL10 [SBANDF A30_8*P50*GRADL3*DLWL10 PHIL3*TWOPI]}';
% ==============================================================================
% DRIFs
% ------------------------------------------------------------------------------
DAQ4A={'dr' '' 0.2527 []}';
DAQ4B={'dr' '' 0.203 []}';
DAQ4C={'dr' '' 0.915 []}';
DAQ4D={'dr' '' 0.272 []}';
DAQ4E={'dr' '' 0.91 []}';
DAQ5A={'dr' '' 2.3435 []}';
DAQ6A={'dr' '' 0.7348 []}';
DAQ5B={'dr' '' 2.841 []}';
DAQ6B={'dr' '' 0.2373 []}';
DAQ5C={'dr' '' 2.841 []}';
DAQ6C={'dr' '' 0.2373 []}';
DAQ5D={'dr' '' 2.344 []}';
DAQ6D={'dr' '' 0.7343 []}';
DAQ5B1={'dr' '' 2.0907 []}';
DAQ5B2={'dr' '' 0.296 []}';
DAQ5B3={'dr' '' 0.4543 []}';
DAQ5C1={'dr' '' 2.0807 []}';
DAQ5C2={'dr' '' 0.286 []}';
DAQ5C3={'dr' '' 0.4743 []}';
DAQ8C={'dr' '' 0.3352 []}';
DAQ8D={'dr' '' 2.296 []}';
DAQ9A={'dr' '' 0.0811 []}';
DAQ9B={'dr' '' 0.128 []}';
DAQ10A={'dr' '' 0.1333 []}';
DAQ10B={'dr' '' 0.203 []}';
DAQ10C={'dr' '' 0.215 []}';
DAQ10D={'dr' '' 0.3576 []}';
DAQ10E={'dr' '' 0.7765 []}';
DAQ10F={'dr' '' 0.1324 []}';
DAQ10G={'dr' '' 0.1301 []}';
DAQ10H={'dr' '' 0.203 []}';
DAQ10I={'dr' '' 0.206 []}';
DAQ10J={'dr' '' 0.237 []}';
DAQ10K={'dr' '' 0.1328 []}';
DAQ11A={'dr' '' 0.1317 []}';
DAQ11B={'dr' '' 0.211 []}';
DAQ11C={'dr' '' 0.211 []}';
DAQ11D={'dr' '' 0.1536 []}';
D10CA={'dr' '' 2.8157 []}';
D10CB={'dr' '' 0.2284 []}';
D10CC={'dr' '' 2.8159 []}';
D10CD={'dr' '' 0.2282 []}';
D10CE={'dr' '' 2.8161 []}';
D10CF={'dr' '' 0.228 []}';
% ==============================================================================
% XCORs
% ------------------------------------------------------------------------------
XC24900={'mo' 'XC24900' 0 []}';
XC25202={'mo' 'XC25202' 0 []}';%fast-feedback (loop-3)
XC25302={'mo' 'XC25302' 0 []}';
XC25402={'mo' 'XC25402' 0 []}';
XC25502={'mo' 'XC25502' 0 []}';
XC25602={'mo' 'XC25602' 0 []}';%fast-feedback (loop-3)
XC25702={'mo' 'XC25702' 0 []}';
XC25802={'mo' 'XC25802' 0 []}';
XC25900={'mo' 'XC25900' 0 []}';
XC26202={'mo' 'XC26202' 0 []}';
XC26302={'mo' 'XC26302' 0 []}';
XC26402={'mo' 'XC26402' 0 []}';
XC26502={'mo' 'XC26502' 0 []}';
XC26602={'mo' 'XC26602' 0 []}';
XC26702={'mo' 'XC26702' 0 []}';
XC26802={'mo' 'XC26802' 0 []}';
XC26900={'mo' 'XC26900' 0 []}';
XC27202={'mo' 'XC27202' 0 []}';
XC27302={'mo' 'XC27302' 0 []}';
XC27402={'mo' 'XC27402' 0 []}';
XC27502={'mo' 'XC27502' 0 []}';
XC27602={'mo' 'XC27602' 0 []}';
XC27702={'mo' 'XC27702' 0 []}';
XC27802={'mo' 'XC27802' 0 []}';
XC27900={'mo' 'XC27900' 0 []}';
XC29092={'mo' 'XC29092' 0 []}';
XC28202={'mo' 'XC28202' 0 []}';
XC28302={'mo' 'XC28302' 0 []}';
XC28402={'mo' 'XC28402' 0 []}';
XC29095={'mo' 'XC29095' 0 []}';
XC28502={'mo' 'XC28502' 0 []}';
XC28602={'mo' 'XC28602' 0 []}';
XC28702={'mo' 'XC28702' 0 []}';
XC28802={'mo' 'XC28802' 0 []}';
XC28900={'mo' 'XC28900' 0 []}';
XC29202={'mo' 'XC29202' 0 []}';
XC29302={'mo' 'XC29302' 0 []}';
XC29402={'mo' 'XC29402' 0 []}';
XC29502={'mo' 'XC29502' 0 []}';
XC29602={'mo' 'XC29602' 0 []}';
XC29702={'mo' 'XC29702' 0 []}';
XC29802={'mo' 'XC29802' 0 []}';
XC29900={'mo' 'XC29900' 0 []}';
XC30202={'mo' 'XC30202' 0 []}';
XC30302={'mo' 'XC30302' 0 []}';
XC30402={'mo' 'XC30402' 0 []}';
XC30502={'mo' 'XC30502' 0 []}';
XC30602={'mo' 'XC30602' 0 []}';
XC30702={'mo' 'XC30702' 0 []}';
XC30802={'mo' 'XC30802' 0 []}';
XC30900={'mo' 'XC30900' 0 []}';
% ==============================================================================
% YCORs
% ------------------------------------------------------------------------------
YC24900={'mo' 'YC24900' 0 []}';%fast-feedback (loop-3)
YC25203={'mo' 'YC25203' 0 []}';
YC25303={'mo' 'YC25303' 0 []}';
YC25403={'mo' 'YC25403' 0 []}';
YC25503={'mo' 'YC25503' 0 []}';%fast-feedback (loop-3)
YC25603={'mo' 'YC25603' 0 []}';
YC25703={'mo' 'YC25703' 0 []}';
YC25803={'mo' 'YC25803' 0 []}';
YC25900={'mo' 'YC25900' 0 []}';
YC26203={'mo' 'YC26203' 0 []}';
YC26303={'mo' 'YC26303' 0 []}';
YC26403={'mo' 'YC26403' 0 []}';
YC26503={'mo' 'YC26503' 0 []}';
YC26603={'mo' 'YC26603' 0 []}';
YC26703={'mo' 'YC26703' 0 []}';
YC26803={'mo' 'YC26803' 0 []}';
YC26900={'mo' 'YC26900' 0 []}';
YC27203={'mo' 'YC27203' 0 []}';
YC27303={'mo' 'YC27303' 0 []}';
YC27403={'mo' 'YC27403' 0 []}';
YC27503={'mo' 'YC27503' 0 []}';
YC27603={'mo' 'YC27603' 0 []}';
YC27703={'mo' 'YC27703' 0 []}';
YC27803={'mo' 'YC27803' 0 []}';
YC27900={'mo' 'YC27900' 0 []}';
YC29092={'mo' 'YC29092' 0 []}';
YC28203={'mo' 'YC28203' 0 []}';
YC28303={'mo' 'YC28303' 0 []}';
YC28403={'mo' 'YC28403' 0 []}';
YC29095={'mo' 'YC29095' 0 []}';
YC28503={'mo' 'YC28503' 0 []}';
YC28603={'mo' 'YC28603' 0 []}';
YC28703={'mo' 'YC28703' 0 []}';
YC28803={'mo' 'YC28803' 0 []}';
YC28900={'mo' 'YC28900' 0 []}';
YC29203={'mo' 'YC29203' 0 []}';
YC29303={'mo' 'YC29303' 0 []}';
YC29403={'mo' 'YC29403' 0 []}';
YC29503={'mo' 'YC29503' 0 []}';
YC29603={'mo' 'YC29603' 0 []}';
YC29703={'mo' 'YC29703' 0 []}';
YC29803={'mo' 'YC29803' 0 []}';
YC29900={'mo' 'YC29900' 0 []}';
YC30203={'mo' 'YC30203' 0 []}';
YC30303={'mo' 'YC30303' 0 []}';
YC30403={'mo' 'YC30403' 0 []}';
YC30503={'mo' 'YC30503' 0 []}';
YC30603={'mo' 'YC30603' 0 []}';
YC30703={'mo' 'YC30703' 0 []}';
YC30803={'mo' 'YC30803' 0 []}';
YC30900={'mo' 'YC30900' 0 []}';
% ==============================================================================
% MARKERs
% ------------------------------------------------------------------------------
% profile monitors ("Decker screens")
P30013={'mo' 'P30013' 0 []}';
P30014={'mo' 'P30014' 0 []}';
P30143={'mo' 'P30143' 0 []}';
P30144={'mo' 'P30144' 0 []}';
P30443={'mo' 'P30443' 0 []}';
P30444={'mo' 'P30444' 0 []}';
P30543={'mo' 'P30543' 0 []}';
P30544={'mo' 'P30544' 0 []}';
% collimators
C29096={'dr' 'C29096' 0 []}';
C29146={'dr' 'C29146' 0 []}';
C29446={'dr' 'C29446' 0 []}';
C29546={'dr' 'C29546' 0 []}';
C29956={'dr' 'C29956' 0 []}';
C30146={'dr' 'C30146' 0 []}';
C30446={'dr' 'C30446' 0 []}';
C30546={'dr' 'C30546' 0 []}';
% miscellany
ST28950={'mo' 'ST28950' 8*IN2M []}';%copper/BTM/tungsten
ST28960={'mo' 'ST28960' 8*IN2M []}';%copper/BTM/tungsten
DAQ8D1={'dr' '' 0.845-ST28950{3}/2 []}';
DAQ8D2={'dr' '' 0.419-ST28950{3}/2-ST28960{3}/2 []}';
DAQ8D3={'dr' '' DAQ8D{3}-DAQ8D1{3}-ST28950{3}-DAQ8D2{3}-ST28960{3} []}';
PK297={'mo' 'PK297' 0 []}';
PK299={'mo' 'PK299' 0 []}';
PK303={'mo' 'PK303' 0 []}';
PK304={'mo' 'PK304' 0 []}';
% ==============================================================================
% BEAMLINEs
% ------------------------------------------------------------------------------
K25_1A_FULL=[K25_1A1,XC24900,K25_1A2,YC24900,K25_1A3];
K25_1B_FULL=[K25_1B];
K25_1D_FULL=[K25_1D];
K25_2A_FULL=[K25_2A1,XC25202,K25_2A2,YC25203,K25_2A3];
K25_2B_FULL=[K25_2B];
K25_2C_FULL=[K25_2C];
K25_3A_FULL=[K25_3A1,XC25302,K25_3A2,YC25303,K25_3A3];
K25_3B_FULL=[K25_3B];
K25_3C_FULL=[K25_3C];
K25_4A_FULL=[K25_4A1,XC25402,K25_4A2,YC25403,K25_4A3];
K25_4B_FULL=[K25_4B];
K25_4C_FULL=[K25_4C];
K25_4D_FULL=[K25_4D];
K25_5A_FULL=[K25_5A1,XC25502,K25_5A2,YC25503,K25_5A3];
K25_5B_FULL=[K25_5B];
K25_5C_FULL=[K25_5C];
K25_5D_FULL=[K25_5D];
K25_6A_FULL=[K25_6A1,XC25602,K25_6A2,YC25603,K25_6A3];
K25_6B_FULL=[K25_6B];
K25_6C_FULL=[K25_6C];
K25_6D_FULL=[K25_6D];
K25_7A_FULL=[K25_7A1,XC25702,K25_7A2,YC25703,K25_7A3];
K25_7B_FULL=[K25_7B];
K25_7C_FULL=[K25_7C];
K25_7D_FULL=[K25_7D];
K25_8A_FULL=[K25_8A1,XC25802,K25_8A2,YC25803,K25_8A3];
K25_8B_FULL=[K25_8B];
K25_8C_FULL=[K25_8C];
K25_8D_FULL=[K25_8D1,XC25900,K25_8D2,YC25900,K25_8D3];
TCAV3_FULL=[TCAV3,TCAV3];
BXKIK_FULL=[BXKIKA,BXKIKB];
Q25201_FULL=[Q25201,BPM25201,Q25201];
Q25301_FULL=[Q25301,BPM25301,Q25301];
Q25401_FULL=[Q25401,BPM25401,Q25401];
Q25501_FULL=[Q25501,BPM25501,Q25501];
Q25601_FULL=[Q25601,BPM25601,Q25601];
Q25701_FULL=[Q25701,BPM25701,Q25701];
Q25801_FULL=[Q25801,BPM25801,Q25801];
Q25901_FULL=[Q25901,BPM25901,Q25901];
LI25=[LI25BEG,ZLIN09,K25_1A_FULL,K25_1B_FULL,D25_1C,K25_1D_FULL,DAQ1,Q25201_FULL,DAQ2,K25_2A_FULL,K25_2B_FULL,K25_2C_FULL,D255A,IMBC2O,D255B,D255C,TCAV3_FULL,D255D,Q25301_FULL,DAQ2,K25_3A_FULL,K25_3B_FULL,K25_3C_FULL,D256A,PH03,D256B,BL22,D256C,BXKIK_FULL,D256D,DAQ1,Q25401_FULL,DAQ2,K25_4A_FULL,K25_4B_FULL,K25_4C_FULL,K25_4D_FULL,DAQ1,Q25501_FULL,DAQ2,K25_5A_FULL,K25_5B_FULL,K25_5C_FULL,K25_5D_FULL,DAQ1,Q25601_FULL,DAQ2,K25_6A_FULL,K25_6B_FULL,K25_6C_FULL,K25_6D_FULL,DAQ1,Q25701_FULL,DAQ2,K25_7A_FULL,K25_7B_FULL,K25_7C_FULL,K25_7D_FULL,DAQ1,Q25801_FULL,DAQ2,K25_8A_FULL,K25_8B_FULL,K25_8C_FULL,K25_8D_FULL,DAQ7,Q25901_FULL,DAQ8A,OTR_TCAV,DAQ8B,LI25END];
% ------------------------------------------------------------------------------
K26_1A_FULL=[K26_1A];
K26_1B_FULL=[K26_1B];
K26_1C_FULL=[K26_1C];
K26_1D_FULL=[K26_1D];
K26_2A_FULL=[K26_2A1,XC26202,K26_2A2,YC26203,K26_2A3];
K26_2B_FULL=[K26_2B];
K26_2C_FULL=[K26_2C];
K26_2D_FULL=[K26_2D];
K26_3A_FULL=[K26_3A1,XC26302,K26_3A2,YC26303,K26_3A3];
K26_3B_FULL=[K26_3B];
K26_3C_FULL=[K26_3C];
K26_3D_FULL=[K26_3D];
K26_4A_FULL=[K26_4A1,XC26402,K26_4A2,YC26403,K26_4A3];
K26_4B_FULL=[K26_4B];
K26_4C_FULL=[K26_4C];
K26_4D_FULL=[K26_4D];
K26_5A_FULL=[K26_5A1,XC26502,K26_5A2,YC26503,K26_5A3];
K26_5B_FULL=[K26_5B];
K26_5C_FULL=[K26_5C];
K26_5D_FULL=[K26_5D];
K26_6A_FULL=[K26_6A1,XC26602,K26_6A2,YC26603,K26_6A3];
K26_6B_FULL=[K26_6B];
K26_6C_FULL=[K26_6C];
K26_6D_FULL=[K26_6D];
K26_7A_FULL=[K26_7A1,XC26702,K26_7A2,YC26703,K26_7A3];
K26_7B_FULL=[K26_7B];
K26_7C_FULL=[K26_7C];
K26_7D_FULL=[K26_7D];
K26_8A_FULL=[K26_8A1,XC26802,K26_8A2,YC26803,K26_8A3];
K26_8B_FULL=[K26_8B];
K26_8C_FULL=[K26_8C];
K26_8D_FULL=[K26_8D1,XC26900,K26_8D2,YC26900,K26_8D3];
Q26201_FULL=[Q26201,BPM26201,Q26201];
Q26301_FULL=[Q26301,BPM26301,Q26301];
Q26401_FULL=[Q26401,BPM26401,Q26401];
Q26501_FULL=[Q26501,BPM26501,Q26501];
Q26601_FULL=[Q26601,BPM26601,Q26601];
Q26701_FULL=[Q26701,BPM26701,Q26701];
Q26801_FULL=[Q26801,BPM26801,Q26801];
Q26901_FULL=[Q26901,BPM26901,Q26901];
LI26=[LI26BEG,ZLIN10,K26_1A_FULL,K26_1B_FULL,K26_1C_FULL,K26_1D_FULL,DAQ1,Q26201_FULL,DAQ2,K26_2A_FULL,K26_2B_FULL,K26_2C_FULL,K26_2D_FULL,DAQ1,Q26301_FULL,DAQ2,K26_3A_FULL,K26_3B_FULL,K26_3C_FULL,K26_3D_FULL,DAQ1,Q26401_FULL,DAQ2,K26_4A_FULL,K26_4B_FULL,K26_4C_FULL,K26_4D_FULL,DAQ1,Q26501_FULL,DAQ2,K26_5A_FULL,K26_5B_FULL,K26_5C_FULL,K26_5D_FULL,DAQ1,Q26601_FULL,DAQ2,K26_6A_FULL,K26_6B_FULL,K26_6C_FULL,K26_6D_FULL,DAQ1,Q26701_FULL,DAQ2,K26_7A_FULL,K26_7B_FULL,K26_7C_FULL,K26_7D_FULL,DAQ1,Q26801_FULL,DAQ2,K26_8A_FULL,K26_8B_FULL,K26_8C_FULL,K26_8D_FULL,DAQ7,Q26901_FULL,DAQ8,LI26END];
% ------------------------------------------------------------------------------
K27_1A_FULL=[K27_1A];
K27_1B_FULL=[K27_1B];
K27_1C_FULL=[K27_1C];
K27_1D_FULL=[K27_1D];
K27_2A_FULL=[K27_2A1,XC27202,K27_2A2,YC27203,K27_2A3];
K27_2B_FULL=[K27_2B];
K27_2C_FULL=[K27_2C];
K27_2D_FULL=[K27_2D];
K27_3A_FULL=[K27_3A1,XC27302,K27_3A2,YC27303,K27_3A3];
K27_3B_FULL=[K27_3B];
K27_3C_FULL=[K27_3C];
K27_3D_FULL=[K27_3D];
K27_4A_FULL=[K27_4A1,XC27402,K27_4A2,YC27403,K27_4A3];
K27_4B_FULL=[K27_4B];
K27_4C_FULL=[K27_4C];
K27_4D_FULL=[K27_4D];
K27_5A_FULL=[K27_5A1,XC27502,K27_5A2,YC27503,K27_5A3];
K27_5B_FULL=[K27_5B];
K27_5C_FULL=[K27_5C];
K27_5D_FULL=[K27_5D];
K27_6A_FULL=[K27_6A1,XC27602,K27_6A2,YC27603,K27_6A3];
K27_6B_FULL=[K27_6B];
K27_6C_FULL=[K27_6C];
K27_7A_FULL=[K27_7A1,XC27702,K27_7A2,YC27703,K27_7A3];
K27_7B_FULL=[K27_7B];
K27_7C_FULL=[K27_7C];
K27_7D_FULL=[K27_7D];
K27_8A_FULL=[K27_8A1,XC27802,K27_8A2,YC27803,K27_8A3];
K27_8B_FULL=[K27_8B];
K27_8C_FULL=[K27_8C];
K27_8D_FULL=[K27_8D1,XC27900,K27_8D2,YC27900,K27_8D3];
Q27201_FULL=[Q27201,BPM27201,Q27201];
Q27301_FULL=[Q27301,BPM27301,Q27301];
Q27401_FULL=[Q27401,BPM27401,Q27401];
Q27501_FULL=[Q27501,BPM27501,Q27501];
Q27601_FULL=[Q27601,BPM27601,Q27601];
Q27701_FULL=[Q27701,BPM27701,Q27701];
Q27801_FULL=[Q27801,BPM27801,Q27801];
Q27901_FULL=[Q27901,BPM27901,Q27901];
LI27=[LI27BEG,ZLIN11,K27_1A_FULL,K27_1B_FULL,K27_1C_FULL,K27_1D_FULL,DAQ1,Q27201_FULL,DAQ2,K27_2A_FULL,K27_2B_FULL,K27_2C_FULL,K27_2D_FULL,DAQ1,Q27301_FULL,DAQ2,K27_3A_FULL,K27_3B_FULL,K27_3C_FULL,K27_3D_FULL,DAQ1,Q27401_FULL,DAQ2,K27_4A_FULL,K27_4B_FULL,K27_4C_FULL,K27_4D_FULL,DAQ1,Q27501_FULL,DAQ2,K27_5A_FULL,K27_5B_FULL,K27_5C_FULL,K27_5D_FULL,DAQ1,Q27601_FULL,DAQ2,K27_6A_FULL,K27_6B_FULL,K27_6C_FULL,DAQ5A,WS27644,DAQ6A,Q27701_FULL,DAQ2,K27_7A_FULL,K27_7B_FULL,K27_7C_FULL,K27_7D_FULL,DAQ1,Q27801_FULL,DAQ2,K27_8A_FULL,K27_8B_FULL,K27_8C_FULL,K27_8D_FULL,DAQ7,Q27901_FULL,DAQ8,LI27END];
% ------------------------------------------------------------------------------
K28_1A_FULL=[K28_1A];
K28_1B_FULL=[K28_1B];
K28_1C_FULL=[K28_1C];
K28_2A_FULL=[K28_2A1,XC28202,K28_2A2,YC28203,K28_2A3];
K28_2B_FULL=[K28_2B];
K28_2C_FULL=[K28_2C];
K28_2D_FULL=[K28_2D];
K28_3A_FULL=[K28_3A1,XC28302,K28_3A2,YC28303,K28_3A3];
K28_3B_FULL=[K28_3B];
K28_3C_FULL=[K28_3C];
K28_3D_FULL=[K28_3D];
K28_4A_FULL=[K28_4A1,XC28402,K28_4A2,YC28403,K28_4A3];
K28_4B_FULL=[K28_4B];
K28_4C_FULL=[K28_4C];
K28_5A_FULL=[K28_5A1,XC28502,K28_5A2,YC28503,K28_5A3];
K28_5B_FULL=[K28_5B];
K28_5C_FULL=[K28_5C];
K28_6A_FULL=[K28_6A1,XC28602,K28_6A2,YC28603,K28_6A3];
K28_6B_FULL=[K28_6B];
K28_6C_FULL=[K28_6C];
K28_6D_FULL=[K28_6D];
K28_7A_FULL=[K28_7A1,XC28702,K28_7A2,YC28703,K28_7A3];
K28_7B_FULL=[K28_7B];
K28_7C_FULL=[K28_7C];
K28_8A_FULL=[K28_8A1,XC28802,K28_8A2,YC28803,K28_8A3];
K28_8B_FULL=[K28_8B];
K28_8C_FULL=[K28_8C];
K28_8D_FULL=[K28_8D1,XC28900,K28_8D2,YC28900,K28_8D3];
Q28201_FULL=[Q28201,BPM28201,Q28201];
Q28301_FULL=[Q28301,BPM28301,Q28301];
Q28401_FULL=[Q28401,BPM28401,Q28401];
Q28501_FULL=[Q28501,BPM28501,Q28501];
Q28601_FULL=[Q28601,BPM28601,Q28601];
Q28701_FULL=[Q28701,BPM28701,Q28701];
Q28801_FULL=[Q28801,BPM28801,Q28801];
Q28901_FULL=[Q28901,BPM28901,Q28901];
LI28=[LI28BEG,ZLIN12,K28_1A_FULL,K28_1B_FULL,K28_1C_FULL,DAQ5B1,XC29092,DAQ5B2,YC29092,DAQ5B3,WS28144,DAQ6B,Q28201_FULL,DAQ2,K28_2A_FULL,K28_2B_FULL,K28_2C_FULL,K28_2D_FULL,DAQ1,Q28301_FULL,DAQ2,K28_3A_FULL,K28_3B_FULL,K28_3C_FULL,K28_3D_FULL,DAQ1,Q28401_FULL,DAQ2,K28_4A_FULL,K28_4B_FULL,K28_4C_FULL,DAQ5C1,XC29095,DAQ5C2,YC29095,DAQ5C3,WS28444,DAQ6C,Q28501_FULL,DAQ2,K28_5A_FULL,K28_5B_FULL,K28_5C_FULL,D28_5D,DAQ1,Q28601_FULL,DAQ2,K28_6A_FULL,K28_6B_FULL,K28_6C_FULL,K28_6D_FULL,DAQ1,Q28701_FULL,DAQ2,K28_7A_FULL,K28_7B_FULL,K28_7C_FULL,DAQ5D,WS28744,DAQ6D,Q28801_FULL,DAQ2,K28_8A_FULL,K28_8B_FULL,K28_8C_FULL,K28_8D_FULL,DAQ7,Q28901_FULL,DAQ8C,C29096,DAQ8D1,ST28950,DAQ8D2,ST28960,DAQ8D3,LI28END];
% ------------------------------------------------------------------------------
K29_1A_FULL=[K29_1A];
K29_1B_FULL=[K29_1B];
K29_1C_FULL=[K29_1C];
K29_2A_FULL=[K29_2A1,XC29202,K29_2A2,YC29203,K29_2A3];
K29_2B_FULL=[K29_2B];
K29_2C_FULL=[K29_2C];
K29_2D_FULL=[K29_2D];
K29_3A_FULL=[K29_3A1,XC29302,K29_3A2,YC29303,K29_3A3];
K29_3B_FULL=[K29_3B];
K29_3C_FULL=[K29_3C];
K29_3D_FULL=[K29_3D];
K29_4A_FULL=[K29_4A1,XC29402,K29_4A2,YC29403,K29_4A3];
K29_4B_FULL=[K29_4B];
K29_4C_FULL=[K29_4C];
K29_5A_FULL=[K29_5A1,XC29502,K29_5A2,YC29503,K29_5A3];
K29_5B_FULL=[K29_5B];
K29_5C_FULL=[K29_5C];
K29_6A_FULL=[K29_6A1,XC29602,K29_6A2,YC29603,K29_6A3];
K29_6B_FULL=[K29_6B];
K29_6C_FULL=[K29_6C];
K29_6D_FULL=[K29_6D];
K29_7A_FULL=[K29_7A1,XC29702,K29_7A2,YC29703,K29_7A3];
K29_7B_FULL=[K29_7B];
K29_7C_FULL=[K29_7C];
K29_7D_FULL=[K29_7D];
K29_8A_FULL=[K29_8A1,XC29802,K29_8A2,YC29803,K29_8A3];
K29_8B_FULL=[K29_8B];
K29_8C_FULL=[K29_8C];
K29_8D_FULL=[K29_8D1,XC29900,K29_8D2,YC29900,K29_8D3];
Q29201_FULL=[Q29201,BPM29201,Q29201];
Q29301_FULL=[Q29301,BPM29301,Q29301];
Q29401_FULL=[Q29401,BPM29401,Q29401];
Q29501_FULL=[Q29501,BPM29501,Q29501];
Q29601_FULL=[Q29601,BPM29601,Q29601];
Q29701_FULL=[Q29701,BPM29701,Q29701];
Q29801_FULL=[Q29801,BPM29801,Q29801];
Q29901_FULL=[Q29901,BPM29901,Q29901];
LI29=[LI29BEG,ZLIN13,K29_1A_FULL,K29_1B_FULL,K29_1C_FULL,D10CA,C29146,D10CB,DAQ1,Q29201_FULL,DAQ2,K29_2A_FULL,K29_2B_FULL,K29_2C_FULL,K29_2D_FULL,DAQ1,Q29301_FULL,DAQ2,K29_3A_FULL,K29_3B_FULL,K29_3C_FULL,K29_3D_FULL,DAQ1,Q29401_FULL,DAQ2,K29_4A_FULL,K29_4B_FULL,K29_4C_FULL,D10CC,C29446,D10CD,DAQ1,Q29501_FULL,DAQ2,K29_5A_FULL,K29_5B_FULL,K29_5C_FULL,D10CE,C29546,D10CF,DAQ1,Q29601_FULL,DAQ2,K29_6A_FULL,K29_6B_FULL,K29_6C_FULL,K29_6D_FULL,DAQ1,Q29701_FULL,DAQ2,K29_7A_FULL,K29_7B_FULL,K29_7C_FULL,K29_7D_FULL,DAQ9A,PK297,DAQ9B,Q29801_FULL,DAQ2,K29_8A_FULL,K29_8B_FULL,K29_8C_FULL,K29_8D_FULL,DAQ3,Q29901_FULL,DAQ4A,P30013,DAQ4B,P30014,DAQ4C,C29956,DAQ4D,PK299,DAQ4E,LI29END];
% ------------------------------------------------------------------------------
K30_1A_FULL=[K30_1A];
K30_1B_FULL=[K30_1B];
K30_1C_FULL=[K30_1C];
K30_1D_FULL=[K30_1D];
K30_2A_FULL=[K30_2A1,XC30202,K30_2A2,YC30203,K30_2A3];
K30_2B_FULL=[K30_2B];
K30_2C_FULL=[K30_2C];
K30_2D_FULL=[K30_2D];
K30_3A_FULL=[K30_3A1,XC30302,K30_3A2,YC30303,K30_3A3];
K30_3B_FULL=[K30_3B];
K30_3C_FULL=[K30_3C];
K30_3D_FULL=[K30_3D];
K30_4A_FULL=[K30_4A1,XC30402,K30_4A2,YC30403,K30_4A3];
K30_4B_FULL=[K30_4B];
K30_4C_FULL=[K30_4C];
K30_4D_FULL=[K30_4D];
K30_5A_FULL=[K30_5A1,XC30502,K30_5A2,YC30503,K30_5A3];
K30_5B_FULL=[K30_5B];
K30_5C_FULL=[K30_5C];
K30_5D_FULL=[K30_5D];
K30_6A_FULL=[K30_6A1,XC30602,K30_6A2,Q30615A,K30_6A3,YC30603,K30_6A4,Q30615B,K30_6A5,Q30615C,K30_6A6];
K30_6B_FULL=[K30_6B];
K30_6C_FULL=[K30_6C];
K30_6D_FULL=[K30_6D];
K30_7A_FULL=[K30_7A1,XC30702,K30_7A2,Q30715A,K30_7A3,YC30703,K30_7A4,Q30715B,K30_7A5,Q30715C,K30_7A6];
K30_7B_FULL=[K30_7B];
K30_7C_FULL=[K30_7C];
K30_7D_FULL=[K30_7D];
K30_8A_FULL=[K30_8A1,XC30802,K30_8A2,YC30803,K30_8A3];
K30_8B_FULL=[K30_8B];
K30_8C_FULL=[K30_8C1,YC30900,K30_8C2,XC30900,K30_8C3];
Q30201_FULL=[Q30201,BPM30201,Q30201];
Q30301_FULL=[Q30301,BPM30301,Q30301];
Q30401_FULL=[Q30401,BPM30401,Q30401];
Q30501_FULL=[Q30501,BPM30501,Q30501];
Q30601_FULL=[Q30601,BPM30601,Q30601];
Q30701_FULL=[Q30701,BPM30701,Q30701];
Q30801_FULL=[Q30801,BPM30801,Q30801];
LI30=[LI30BEG,ZLIN14,K30_1A_FULL,K30_1B_FULL,K30_1C_FULL,K30_1D_FULL,DAQ10A,P30143,DAQ10B,P30144,DAQ10C,C30146,DAQ10D,Q30201_FULL,DAQ2,K30_2A_FULL,K30_2B_FULL,K30_2C_FULL,K30_2D_FULL,DAQ1,Q30301_FULL,DAQ2,K30_3A_FULL,K30_3B_FULL,K30_3C_FULL,K30_3D_FULL,DAQ10E,PK303,DAQ10F,Q30401_FULL,DAQ2,K30_4A_FULL,K30_4B_FULL,K30_4C_FULL,K30_4D_FULL,DAQ10G,P30443,DAQ10H,P30444,DAQ10I,C30446,DAQ10J,PK304,DAQ10K,Q30501_FULL,DAQ2,K30_5A_FULL,K30_5B_FULL,K30_5C_FULL,K30_5D_FULL,DAQ11A,P30543,DAQ11B,P30544,DAQ11C,C30546,DAQ11D,Q30601_FULL,DAQ12,K30_6A_FULL,K30_6B_FULL,K30_6C_FULL,K30_6D_FULL,DAQ13,Q30701_FULL,DAQ14,K30_7A_FULL,K30_7B_FULL,K30_7C_FULL,K30_7D_FULL,DAQ15,Q30801_FULL,DAQ16,K30_8A_FULL,K30_8B_FULL,K30_8C_FULL,DAQ17,LI30TERM];
% ------------------------------------------------------------------------------
L3=[BEGL3,LI25,LI26,LI27,LI28,LI29,LI30,DBMARK29,ENDL3];
% ==============================================================================

% *** OPTICS=AD_ACCEL-04MAY2026s ***
% CU_HXR   : BEGGUN    /ENDDMPH_2
% CU_SFTH  : BEGSFTH_1 /ENDSFTH_2
% CU_HXTES : BEGHXTES_1/ENDHXTES_2
% CU_HTXI  : BEGHXTES_3/ENDHXTES_3
% CU_SXR   : BEGCLTS   /ENDCLTS
% CU_GSPEC : BEGGSPEC  /ENDGSPEC
% CU_SPEC  : BEGSPEC   /ENDSPEC












































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































% ... or simplified L1, L2, and L3 lattices (for ELEGANT)
%CALL, FILENAME="LCLS_L1e.xsif"
%CALL, FILENAME="LCLS_L2e.xsif"
%CALL, FILENAME="LCLS_L3e.xsif"
%CALL, FILENAME="Cu_FDNe.xsif"
% new BSY area definitions
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% ==============================================================================
% Modification History
% ------------------------------------------------------------------------------
% 19-APR-2024, M. Woodley
%  * remove decommissioned BSYALINE and LCLS2cuA LINE's
% ------------------------------------------------------------------------------
% 04-OCT-2018, M. Woodley
%  * include alternative DC extraction into CUSXR:
%    - define new drifts DBRCUSdc1A,B and DBRCUSdc2A,B (3D8.8MK3's)
%    - change definition of beamline CLTH2 (gets 0.40745 m longer)
% ------------------------------------------------------------------------------
% 21-FEB-2018, M. Woodley
%  * add BSYLTUHXTES and LCLS2cuHXTES line definitions
% 25-JAN-2018, M. Woodley
%  * remove PCBSY2/BTMBSY2 per A. Ibrahimov
% ------------------------------------------------------------------------------
% 05-MAY-2017, M. Woodley
%  * pulsed correctors XCAPM2/YCAPM2 will be timed to affect the straight-ahead
%    LTUH beam, but not the A-line beam
% ------------------------------------------------------------------------------
% 24-FEB-2017, Y. Nosochkov
%  * update some drift names
% ------------------------------------------------------------------------------
% 02-NOV-2016, Y. Nosochkov
%  * update BSYH2 definition for use with A-line pulsed magnets
% ------------------------------------------------------------------------------
% 24-JUN-2016, Y. Nosochkov
%  * update beamline definitions to avoid duplication with other files
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% from copper linac
% ------------------------------------------------------------------------------
CLTH0=[BEGCLTH_0,BSYBEG,BSYS100,S100SXRA,ENDCLTH_0];
CLTH1=[BEGCLTH_1,S100SXRB,ENDCLTH_1];
DBRCUSDC1A={'dr' '' ZBRCUSDC/2 []}';
DBRCUSDC1B={'dr' '' ZBRCUSDC/2 []}';
DBKRCUSA={'dr' '' BKRCUSA{3} []}';
DBKRCUSB={'dr' '' BKRCUSB{3} []}';
DBRCUSDC2A={'dr' '' ZBRCUSDC/2 []}';
DBRCUSDC2B={'dr' '' ZBRCUSDC/2 []}';
DBLRCUSA={'dr' '' BLRCUSA{3} []}';
DBLRCUSB={'dr' '' BLRCUSB{3} []}';
DBXSP1HA={'dr' '' BXSP1HA{3} []}';
DBXSP1HB={'dr' '' BXSP1HB{3} []}';
CLTH2=[BEGCLTH_2,DBRCUSDC1A,DBRCUSDC1B,DCKDC1,DBKRCUSA,DBKRCUSB,DCKDC2,DBRCUSDC2A,DBRCUSDC2B,DCUSBLRA,BPMCUS,DCUSBLRB,DBLRCUSA,DBLRCUSB,DBSY52C1,SWIVEL,DBSY52C2,DBXSP1HA,DBXSP1HB,BSY1END,ENDCLTH_2];
% ------------------------------------------------------------------------------
CLTS=[BEGCLTS,KCUSXR,DLCUSXR,ENDCLTS];
BSYS=[BEGBSYS,BYPM2,MUWALLB,DWALLA,DUMPBSYS,DWALLB,BSYENDB,RWWAKE3S,ENDBSYS];
% ------------------------------------------------------------------------------
LTUS=[DBLDL21,LTUSC,RWWAKE4S,ENDLTUS,BEGUNDS,PREUNDS];
LTUH=[LTU];
BSYLTUH=[CLTH0,CLTH1,CLTH2,BSYH,LTUH,HXRUND,DUMPLINE];
BSYLTUHS=[CLTH0,CLTH1,CLTH2,BSYH,LTUH,HXRUND,SFTDUMP];
BSYLTUS=[CLTH0,CLTH1,CLTS,BSYS,LTUS,SXRUND,DUMPLINEB];
BSYLTUSS=[CLTH0,CLTH1,CLTS,BSYS,LTUS,SXRUND,SFTDUMPB];
BSYLTUHXTES=[CLTH0,CLTH1,CLTH2,BSYH,LTUH,HXRUND,SFTDUMP1,HXTES_1,HXTES_2];
BSYLTUHTXI=[CLTH0,CLTH1,CLTH2,BSYH,LTUH,HXRUND,SFTDUMP1,HXTES_1,HXTES_3];
LCLS2CUC=[DL1,L1,BC1,L2,BC2,L3];%common
LCLS2CUH=[LCLS2CUC,BSYLTUH];%to HXR
LCLS2CUHS=[LCLS2CUC,BSYLTUHS];%to HXR safety dump
LCLS2CUS=[LCLS2CUC,BSYLTUS];%to SXR
LCLS2CUSS=[LCLS2CUC,BSYLTUSS];%to SXR safety dump
LCLS2CUHXTES=[LCLS2CUC,BSYLTUHXTES];%to HXR XTES system
LCLS2CUHTXI=[LCLS2CUC,BSYLTUHTXI];%to HXR XTES-TXI system
% ------------------------------------------------------------------------------

% beam paths
%CU_GSPEC : copper linac to gun spectrometer
%CU_SPEC  : copper linac to 135 MeV spectrometer
%CU_SXR   : copper linac to e- SXR dump
%CU_HXR   : copper linac to e- HXR dump
%CU_SFTH  : copper linac to e- HXR safety dump
%CU_HXTES : copper linac to HXR XTES system (photon)
%CU_HTXI  : copper linac to HXR TXI system (photon)
CU_GSPEC=[GUNBXG,GSPEC];
CU_SPEC=[GUNL0A,L0AL0B,DL1_1,SPECBL];
CU_SXR=[GUNL0A,L0AL0B,LCLS2CUS];
CU_HXR=[GUNL0A,L0AL0B,LCLS2CUH];
CU_SFTH=[GUNL0A,L0AL0B,LCLS2CUHS];
CU_HXTES=[GUNL0A,L0AL0B,LCLS2CUHXTES];
CU_HTXI=[GUNL0A,L0AL0B,LCLS2CUHTXI];
% for Twiss starting at WS02
LCLS2CUI=[WS02,DE05A,MRK0,DE05A,OTR2,DE06D,BPM10,DE06E,WS03,DE05,OTR3,DE07,QM01_FULL,DE08,SC8,DE08A,VV04,DE08B,QM02_FULL,DE09,DBMARK82,ENDDL1_1];
LCLS2CUCI=[DL1_2,L1,BC1,L2,BC2,L3];
CU_SPECI=[LCLS2CUI,SPECBL];
CU_SXRI=[LCLS2CUI,LCLS2CUCI,BSYLTUS];
CU_HXRI=[LCLS2CUI,LCLS2CUCI,BSYLTUH];
CU_SFTHI=[LCLS2CUI,LCLS2CUCI,BSYLTUHS];
CU_HXTESI=[LCLS2CUI,LCLS2CUCI,BSYLTUHXTES];
CU_HTXII=[LCLS2CUI,LCLS2CUCI,BSYLTUHTXI];
% ------------------------------------------------------------------------------
% initial SURVEY coordinates
% ------------------------------------------------------------------------------
% set initial linac survey coordinates
% (NOTE: pitch is not included here for simplicity - for linac coordinates,
%        read in pitched plane of linac)
XLL =  10.9474                   ;%X at loadlock start [m]
ZLL =  2032.0-14.8125+ZOFFINJ    ;%Z at loadlock start (move injector ~12 mm dnstr. - Nov. 17, 2004, -PE) [m]
XI =  XLL+LOADLOCK{3}*sin(ADL1) ;%subtract from upbeam side of loadlock to get to cathode [m]
ZI =  ZLL+LOADLOCK{3}*cos(ADL1) ;%subtract from upbeam side of loadlock to get to cathode [m]
%VALUE, ADL1,Xi,Zi
% set initial linac survey coordinates at WS02
% (NOTE: start beamline at WS02 because ELEGANT input beam is defined there)
% (NOTE: pitch is not included here for simplicity - for linac coordinates,
%        read in pitched plane of linac)
XWS02 =  2.370017058026   ;%X [m]
ZWS02 =  2.029449371971E3 ;%Z [m]
% initial BSY survey coordinates at BSYbeg
XF =   0           ;%hor. position is on linac axis, which is zero here [m]
YF =   0.027987637 ;%at BSYbeg (~6 m upbeam S100) in undulator coordinates (for LTU engineers)
ZF =  -5.99493367  ;%at BSYbeg (~6 m upbeam S100) in undulator coordinates (for LTU engineers)
THETAF =   0           ;%no yaw at S100
PSIF =   0           ;%no roll at S100
PHIF =  2*AVB        ;%S100 pitch in undulator coordinates (for LTU engineers)
%VALUE, Xf,Yf,Zf,THETAf,PHIf,PSIf,AVB
% linac survey coordinates at BSY1BEG (not used)
%XBSY1  := -3.309620550E-07
%ZBSY1  :=  3042.005
%THBSY1 := -2.000049721E-12
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% input beam definitions
% ------------------------------------------------------------------------------



% ------------------------------------------------------------------------------
% BETA0 block definitions
% ------------------------------------------------------------------------------
% twiss parameters at L0a-exit:
TWSS0=struct('ENERGY',E0I,'BETX',TBETX,'ALFX',TALFX,'BETY',TBETY,'ALFY',TALFY);
% Dummy, fitted twiss parameters at cathode which yield the above twiss parameters at
% L0a-exit (for plotting purposes only - assumes only drift between cathode and L0a-exit)
TWSSC=struct('ENERGY',E00,'BETX',CBETX,'ALFX',CALFX,'BETY',CBETY,'ALFY',CALFY);
% Twiss at WS02
TWSSI=struct('ENERGY',EI,'BETX',BXI,'ALFX',AXI,'BETY',BYI,'ALFY',AYI);
% Twiss at the beginning of L3 linac
TWBEGL3=struct('BETX',BXBEGL3,'ALFX',AXBEGL3,'BETY',BYBEGL3,'ALFY',AYBEGL3,'ENERGY',ENBEGL3);
% Twiss at the end of L3 linac
TWENDL3=struct('BETX',BXENDL3,'ALFX',AXENDL3,'BETY',BYENDL3,'ALFY',AYENDL3,'ENERGY',ENENDL3);
% Twiss at BEGCLTS
TWSCUS1=struct('BETX',TBXCUS1,'ALFX',TAXCUS1,'BETY',TBYCUS1,'ALFY',TAYCUS1);
% periodic Twiss in HXR dogleg cells
TWSSMH=struct('ENERGY',EF,'BETX',MBETXH,'ALFX',MALFXH,'BETY',MBETYH,'ALFY',MALFYH);
% ==============================================================================
% SUBROUTINEs (only used by makeMatlabModel)
% ------------------------------------------------------------------------------
%COMMENT
% SETK2CUH : SUBROUTINE !for LCLS2cuH
% ! set quad strengths for 8 GeV Cu-linac beam to DMPH
%   SET, KQ50Q3, 0.384840836193
%   SET, KQ4, -0.219396715005
%   SET, KQ5, 0.165708852387
%   SET, KQ6, -0.11356910147
%   SET, KQA0, 0.109210100871

% SETK2CUS : SUBROUTINE !for LCLS2cuS
% ! set quad strengths for 8 GeV Cu-linac beam to DMPS
%   SET, KQBP33, -0.644538157053
%   SET, KQBP34, 0.597475524331
%   SET, KQDBL1, -1.080108740787
%   SET, KQDBL2, 0.639673976657
%   SET, KQDL11, 0.359471462077

%ENDCOMMENT
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
% %pulsed
% %suppress "redefinition" warnings
% % *** OPTICS=AD_ACCEL-04MAY2026s ***
% % special redefinitions for Cu-linac beam (LCLS2cuS) passing through lattice
% % defined for SC-linac beam (LCLS2scS)
% KQBP33=-0.644538157053;
% KQBP34=0.597475524331;
% KQDBL1=-1.080108740787;
% KQDBL2=0.639673976657;
% KQDL11=0.359471462077;
% %re-enable warnings
% 
% 
% 
% 
% 
% 
% 
% 
% %suppress "redefinition" warnings
% % *** OPTICS=AD_ACCEL-04MAY2026s ***
% % special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% % defined for SC-linac beam (LCLS2scH)
% KQ50Q3=0.384840836193;
% KQ4=-0.219396715005;
% KQ5=0.165708852387;
% KQ6=-0.11356910147;
% KQA0=0.109210100871;
% %re-enable warnings
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
%CALL, FILENAME="LCLS2cu_match.mad8"
%CALL, FILENAME="LCLS2cu_makeSymbols.mad8"
%CALL, FILENAME="LCLS2cu_makeElegant.mad8" use LCLS_L*e.xsif
%CALL, FILENAME="LCLS2cu_XLEAP.mad8" run by itself
%STOP
% ------------------------------------------------------------------------------
%CALL "LCLS2cu_color_plots.mad8" run by itself (ends with STOP)
%CALL "LCLS2cu_area_plots.mad8"  run by itself (ends with STOP)
% ==============================================================================
% Beam from LCLS gun (SURVEY in linac coordinates)
% ------------------------------------------------------------------------------
% HXR
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings


%SAVELINE, NAME="CU_HXR", FILENAME="LCLS2cuH.saveline"


%, &
%  RTAPE="LCLS2cuH_rmat.tape"




%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR safety dump
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings




%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR
%COMMENT


%pulsed
%SET, SETCUS, CUSONDC DC
%VALUE, PULSED,DCMODE
%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuS) passing through lattice
% defined for SC-linac beam (LCLS2scS)
KQBP33=-0.644538157053;
KQBP34=0.597475524331;
KQDBL1=-1.080108740787;
KQDBL2=0.639673976657;
KQDL11=0.359471462077;
%re-enable warnings


%SAVELINE, NAME="CU_SXR", FILENAME="LCLS2cuS.saveline"


%, &
%  RTAPE="LCLS2cuS_rmat.tape"




%ENDCOMMENT
% ------------------------------------------------------------------------------
% 6 MeV gun spectrometer
%COMMENT



%SAVELINE, NAME="CU_GSPEC", FILENAME="LCLS2cuGSPEC.saveline"


%, &
%  RTAPE="LCLS2cuGSPEC_rmat.tape"

%ENDCOMMENT
% ------------------------------------------------------------------------------
% 135 MeV spectrometer
%COMMENT



%SAVELINE, NAME="CU_SPEC", FILENAME="LCLS2cuSPEC.saveline"


%, &
%  RTAPE="LCLS2cuSPEC_rmat.tape"

%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR XTES
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings




%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR TXI
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings




%ENDCOMMENT
% ==============================================================================
% SURVEY in BSY coordinates (from end of L3)
% ------------------------------------------------------------------------------
% HXR
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings




%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR safety dump (nominal energy: 8 GeV; energy range: 2-20 GeV)
%COMMENT



%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuH) passing through lattice
% defined for SC-linac beam (LCLS2scH)
KQ50Q3=0.384840836193;
KQ4=-0.219396715005;
KQ5=0.165708852387;
KQ6=-0.11356910147;
KQA0=0.109210100871;
%re-enable warnings




%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR XTES
%COMMENT






%ENDCOMMENT
% ------------------------------------------------------------------------------
% HXR TXI
%COMMENT






%ENDCOMMENT
% ------------------------------------------------------------------------------
% SXR
%COMMENT


%pulsed
%SET, SETCUS, CUSONDC DC
%VALUE, PULSED,DCMODE
%suppress "redefinition" warnings
% *** OPTICS=AD_ACCEL-04MAY2026s ***
% special redefinitions for Cu-linac beam (LCLS2cuS) passing through lattice
% defined for SC-linac beam (LCLS2scS)
KQBP33=-0.644538157053;
KQBP34=0.597475524331;
KQDBL1=-1.080108740787;
KQDBL2=0.639673976657;
KQDL11=0.359471462077;
%re-enable warnings




%ENDCOMMENT
% ==============================================================================

function b=SETK2CUH(b)
for n=find(strcmp('Q50Q3',b(:,2)))',b{n,4}(1)=0.384840836193;end
for n=find(strcmp('Q4',b(:,2)))',b{n,4}(1)=-0.219396715005;end
for n=find(strcmp('Q5',b(:,2)))',b{n,4}(1)=0.165708852387;end
for n=find(strcmp('Q6',b(:,2)))',b{n,4}(1)=-0.11356910147;end
for n=find(strcmp('QA0',b(:,2)))',b{n,4}(1)=0.109210100871;end

function b=SETK2CUS(b)
for n=find(strcmp('QBP33',b(:,2)))',b{n,4}(1)=-0.644538157053;end
for n=find(strcmp('QBP34',b(:,2)))',b{n,4}(1)=0.597475524331;end
for n=find(strcmp('QDBL1',b(:,2)))',b{n,4}(1)=-1.080108740787;end
for n=find(strcmp('QDBL2',b(:,2)))',b{n,4}(1)=0.639673976657;end
for n=find(strcmp('QDL11',b(:,2)))',b{n,4}(1)=0.359471462077;end

