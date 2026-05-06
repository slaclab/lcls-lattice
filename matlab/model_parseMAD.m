function [lines,out]=model_parseMAD(MADrelease,fileDir, ...
  file,nOut,blList,simplify,opts)

% ------------------------------------------------------------------------------
% History
% 19-Nov-2024, M. Woodley
%   * 02SEP2024s, reduced L2 W
% 23-Sep-2024, M. Woodley
%   * release 02SEP2024s
% 10-Apr-2024, M. Woodley
%   * release 11APR24s
%   * create SC_DASEL and SC_DASELI beamPaths
%   * remove CU_ALINE and CU_ALINEI beamPaths
% 13-Jan-2022, M. Woodley
%   * release 12JAN22
%   * create LCLS2cu beamPaths that start at OTR2
% 17-Sep-2021, M. Woodley
%   * release 15SEP21
%   * special handling for deferred devices
% 21-Oct-2020, M. Woodley
%   * release 23OCT20
% 14-Oct-2020, M. Woodley
%   * release 15OCT20
% 04-Oct-2020, M. Woodley
%   * release 05OCT20
% 27-Mar-2020, M. Woodley
%   * release 01APR20
% 16-Dec-2019, M. Woodley
%   * release 05DEC19 update (revert to old names, etc.)
% 05-Dec-2019, M. Woodley
%   * release 05DEC19
% 12-Sep-2019, M. Woodley
%   * release 13JUN19a (with new GUNB solenoid effective lengths)
% 12-Aug-2019, M. Woodley
%   * update FACET2
% 13-Jun-2019, M. Woodley
%   * update to AD_ACCEL release 13JUN19
% 06-Jun-2019, M. Woodley
%   * allow SOLENOIDs to be 'so' type
%   * allow thin lens dipoles and quads (MULTIPOLEs)
% 03-May-2019, M. Woodley
%   * rewritten for AD_ACCEL (LCLS merged with LCLS-II)
% 30-Mar-2018, M. Woodley
%   * rewritten for LCLS-II and FACET-II
%   * include processing of MAD SUBROUTINE calls
% 13-Mar-2018, M. Woodley
%   * from: /afs/slac/u/xr/loos/controls/beamfits/model_parseMAD.m (16-Mar-2016)
% ------------------------------------------------------------------------------

opts.set={};
if (nargin<5),blList={};end
if (nargin<4),nOut=[];end
if ((nargin<3)||isempty(file)),file='LCLS2sc_main.mad8';end

switch file
  case 'LCLS2cu_main.mad8' % LCLS2cu
    if (isempty(blList))
      blList={ ...
        'CU_HXR'   {'GUNL0A' 'L0AL0B' 'LCLS2CUH'}; ...       % 1
        'CU_SXR'   {'GUNL0A' 'L0AL0B' 'LCLS2CUS'}; ...       % 2
        'CU_GSPEC' {'GUNBXG' 'GSPEC'}; ...                   % 3
        'CU_SPEC'  {'GUNL0A' 'L0AL0B' 'DL1_1' 'SPECBL'}; ... % 4
        'CU_HXRI'  {'LCLS2CUI' 'LCLS2CUCI' 'BSYLTUH'}; ...   % 5
        'CU_SXRI'  {'LCLS2CUI' 'LCLS2CUCI' 'BSYLTUS'}; ...   % 6
        'CU_SPECI' {'LCLS2CUI' 'SPECBL'}; ...                % 7
        };
      opts.set={ ...
        'SETCUS' {'0','1','0','0','0','1','0'}; ...
        };
      opts.sub={ ...
        'SETK2CUH', ... % 1
        'SETK2CUS', ... % 2
        '', ...         % 3
        '', ...         % 4
        'SETK2CUH', ... % 5
        'SETK2CUS', ... % 6
        '', ...         % 7
        };
      opts.sub2={'','','','','','',''};
    end
    if (isempty(nOut)),nOut='LCLS2cu';end
  case 'LCLS2sc_main.mad8' % LCLS2sc
    if (isempty(blList))
      blList={ ...
        'SC_DIAG0' {'GUN' 'L0' 'HTR' 'DIAG0'}; ...                  %  1
        'SC_HXR' {'GUN' 'L0' 'LCLS2SCC' 'LCLS2SCH'}; ...            %  2
        'SC_SXR' {'GUN' 'L0' 'LCLS2SCC' 'LCLS2SCS'}; ...            %  3
        'SC_BSYD' {'GUN' 'L0' 'LCLS2SCC' 'LCLS2SCD'}; ...           %  4
        'SC_DASEL' {'GUN' 'L0' 'LCLS2SCC' 'LCLS2SCDA'}; ...         %  5
        'SC_DIAG0I' {'LCLS2SCI' 'HTR' 'DIAG0'}; ...                 %  6
        'SC_HXRI' {'LCLS2SCI' 'LCLS2SCC' 'LCLS2SCH'}; ...           %  7
        'SC_SXRI' {'LCLS2SCI' 'LCLS2SCC' 'LCLS2SCS'}; ...           %  8
        'SC_BSYDI' {'LCLS2SCI' 'LCLS2SCC' 'LCLS2SCD'}; ...          %  9
        'SC_DASELI' {'LCLS2SCI' 'LCLS2SCC' 'LCLS2SCDA'}; ...        % 10
        'SC_DIAGIS' {'GUNLEI' 'L0LEI' 'LEI_1' 'DIAGIS'}; ...        % 11
        'SC_DIAG02' {'GUNLEI' 'L0LEI' 'LEI' 'HTR_2' 'DIAG0'}; ...   % 12
        'SC_HXR2' {'GUNLEI' 'L0LEI' 'LCLS2SCC2' 'LCLS2SCH'}; ...    % 13
        'SC_SXR2' {'GUNLEI' 'L0LEI' 'LCLS2SCC2' 'LCLS2SCS'}; ...    % 14
        'SC_BSYD2' {'GUNLEI' 'L0LEI' 'LCLS2SCC2' 'LCLS2SCD'}; ...   % 15
        'SC_DASEL2' {'GUNLEI' 'L0LEI' 'LCLS2SCC2' 'LCLS2SCDA'}; ... % 16
        'SC_DIAGISI' {'LCLS2SCI2' 'LEI_1' 'DIAGIS'}; ...            % 17
        'SC_DIAG02I' {'LCLS2SCI2' 'LEI' 'HTR_2' 'DIAG0'}; ...       % 18
        'SC_HXR2I' {'LCLS2SCI2' 'LCLS2SCC2' 'LCLS2SCH'}; ...        % 19
        'SC_SXR2I' {'LCLS2SCI2' 'LCLS2SCC2' 'LCLS2SCS'}; ...        % 20
        'SC_BSYD2I' {'LCLS2SCI2' 'LCLS2SCC2' 'LCLS2SCD'}; ...       % 21
        'SC_DASEL2I' {'LCLS2SCI2' 'LCLS2SCC2' 'LCLS2SCDA'}; ...     % 22
        };
      opts.set={ ...
        'SETSP' {' 0','-1',' 1',' 0',' 0',' 0','-1',' 1',' 0',' 0',' 0', ...
                 ' 0','-1',' 1',' 0',' 0',' 0',' 0','-1',' 1',' 0',' 0'}; ...
        'SETDA' {' 0',' 0',' 0',' 0',' 1',' 0',' 0',' 0',' 0',' 1',' 0', ...
                 ' 0',' 0',' 0',' 0',' 1',' 0',' 0',' 0',' 0',' 0',' 1'}; ...
        };
      opts.sub={ ...
        '', ...           %  1
        '', ...           %  2
        '', ...           %  3
        '', ...           %  4
        '', ...           %  5
        '', ...           %  6
        '', ...           %  7
        '', ...           %  8
        '', ...           %  9
        '', ...           % 10
        '', ...           % 11
        'SETK2SCLEI', ... % 12
        'SETK2SCLEI', ... % 13
        'SETK2SCLEI', ... % 14
        'SETK2SCLEI', ... % 15
        'SETK2SCLEI', ... % 16
        '', ...           % 17
        'SETK2SCLEI', ... % 18
        'SETK2SCLEI', ... % 19
        'SETK2SCLEI', ... % 20
        'SETK2SCLEI', ... % 21
        'SETK2SCLEI', ... % 22
        };
      opts.sub2={'','','','','','','','','','','', ...
                 '','','','','','','','','','',''};
    end
    if (isempty(nOut)),nOut='LCLS2sc';end
end
if (isempty(nOut)),nOut=strtok(file,'.');end

% MAD predefined values.
predef={ ...
  ''; ...
  'PI     = pi;'; ...
  'TWOPI  = 2*pi;'; ...
  'DEGRAD = 180/pi;'; ...
  'RADDEG = pi/180;'; ...
  'E      = exp(1);'; ...
  'EMASS  = 0.510998902e-3; % electron rest mass [GeV]'; ...
  'PMASS  = 0.938271998;    % proton rest mass [GeV]'; ...
  'CLIGHT = 2.99792458e8;   % speed of light [m/s]'; ...
  };

% Initialize HEADER.
header1={['function beamLine=model_beamLine',nOut,'()'];''};

if (true)
  header=cell(0);
else
  header={ ...
    %    'LBR1  = 0.0696   ;%m'
    %    'LBR4  = 0.058577 ;%m'
    %    'LBRWM = 0.036881 ;%m'
    %    'LPHS  = 0.260    ;%m'
    ''; ...
    ''; ...
    'clight = 2.99792458e8;  % speed of light [m/s]'; ...
    'LQGX   = 0.076;                  % QG quadrupole effective length [m]'; ...
    'IMS1={''mo'' ''IMS1'' 0 []}'';%135-MeV spectrometer'; ...
    'LBRL = 0.52974;'; ...
    'UNDSTART={''mo'' ''UNDSTART'' 0 []}'';'; ...
    'UNDTERM={''mo'' ''UNDTERM'' 0 []}'';'; ...
    'LSTPR  = 0.3046;'; ...
    'LSOL1    = 0.200;'; ...
    'DLD3    = 0.300+0.167527-0.1799554;'; ...
    'DLD4    = 0.200+0.1799554;'; ...
    'XC11={''mo'' ''XC11'' 0 []}'';'; ...
    'YC11={''mo'' ''YC11'' 0 []}'';'; ...
    'XCA11={''mo'' ''XCA11'' 0 []}'';'; ...
    'YCA11={''mo'' ''YCA11'' 0 []}'';'; ...
    'XCA12={''mo'' ''XCA12'' 0 []}'';'; ...
    'YCA12={''mo'' ''YCA12'' 0 []}'';'; ...
    'SC11=[XC11,YC11];'; ...
    'SCA11=[XCA11,YCA11];'; ...
    'SCA12=[XCA12,YCA12];'; ...
    ''; ...
    'KSIGN = 1;  % FACET for e-'; ...
    ''; ...
    'MPHH={''mo'' ''MPHH'' 0 []}'';'; ...
    'LDDL4S =  0.55;'; ...
    ''; ...
    'LQ05=0;'; ...
    'KQ05=0;'; ...
    'DEL1X=92.0     ;% MeV '; ...
    'PHIL1X = 0.0            		;% On crest  '; ...
    'OTR2={''mo'' ''OTR2'' 0 []}'';'
    'DNMARK42={''mo'' ''DNMARK42'' 0 []}'';% YAG03'; ...
    'FLAG1=0;'; ...
    'FLAG2=0;'; ...
    % LCLS2sc
    'LBR =  1.0             ;%1.0D38.37 gap height (m)'; ...
    'NQBD =  8                    ;%number of dogleg quads'; ...
    'LTOTA =  76.02294776001       ;%path length from BRB1-exit to BRB2-entrance'; ...
    'LDBD =  (LTOTA+LBR)/(NQBD/2) ;%FODO cell half length'; ...
    'DLDBD =  -0.124816874499E-4   ;%adjustment for dispersion correction'; ...
    'LDBDH =  LDBD/2+DLDBD         ;%FODO cell half length'; ...
    'LSX =  0.1;'; ...
    'LQR =  0.263  ;'; ...
    'DBD2={''dr'' '''' LDBDH-LQR []}'';'; ...
    'DBD2SA={''dr'' '''' (DBD2{3}-LSX)/2 []}'';'; ...
    'ZWHP =  0.244         ;%half-pole Z length'; ...
    'ZDWG =  0.126525      ;%pole-to-pole Z spacing'; ...
    'ZWIG =  4*ZWHP+2*ZDWG ;%total wiggler Z length'; ...
    'XBANDF=11424;' ; ...
    'DBXK={''dr'' '''' 0.079176 []}'';'; ...
    'LPCBSY =  0.3 ;%TBD'; ...
    };
end

% Read and parse MAD file.
out=file2out(fileDir,file);

% Compile sequences.
jS=0;
for j=1:numel(out)
  if (~isempty(out(j).items))
    if (strcmp(out(j).items{1},'SEQUENCE'))
      jS=j;
      continue
    end
    if (strcmp(out(j).items{1},'ENDSEQUENCE'))
      jS=0;
    end
    if (jS)
      out(jS).items=[out(jS).items(:,:);out(j).items];
      out(j).items={};
    end
  end
end

% Generate MATLAB instructions.
lines=cell(numel(out),1);
cF=0;
sF=0;nsub=0;
for j=1:numel(out)
  [lAdd,cFc,sFc,out(j)]=makeLine(out(j));
  cF=cF+cFc;
  sF=sF+sFc;
  if (cF)
    lAdd=['% ' lAdd(1:end)];
    out(j).comment=lAdd;
    out(j).assign={'' ''};
    out(j).name='';
    out(j).items={};
  end
  if (sF)
    if (isempty(out(j).items))
      lAdd=['% ! ' lAdd(3:end)];
    else
      if (strcmp(out(j).items{1},'SUBROUTINE'))
        nsub=nsub+1;
        sub(nsub).name=out(j).name;
        sub(nsub).set=cell(0);
        lAdd=['% ' out(j).name ' : SUBROUTINE'];
        if (~isempty(out(j).comment))
          lAdd=[lAdd ' !' out(j).comment];
        end
      else
        sub(nsub).set=[sub(nsub).set;out(j).items(2,1),out(j).items(3,1)];
        lAdd=['%   ' out(j).items{1} ', ' out(j).items{2} ', ' out(j).items{3}];
      end
    end
  end
  lines{j}=lAdd;
end
disp(['Convert MAD file ',file,' done.']);

% Sort lines.
test=false;
if (test)
  lines=sortLines(out,lines);
  disp(['Sorting lines for ',file,' done.']);
end

% Fix undulator mess.
% NOTE: UND.xsif has definitions for BOTH the SXR short-period (4 GeV)
%       undulator and phase shifter, and the long-period (8 GeV) undulator
%       and phase shifter; long-period undulator and phase shifter element
%       and attribute names have '_' appended

idU=find(~cellfun('isempty',strfind(lines,'''un''')) & ...
  ~strncmp(lines,'%',1));

Uname={'UMHTR','UMXL','WIGXL','PSSX_','UMASX_','PSSX','UMASX','PSHX','UMAHX','LH_UND','UM10466'};
Upar1={'KQLH','KQUND','KQWIG','KQPSSX_','KQSX_','KQPSSX','KQSX','KQPSHX','KQHX','KQLH','KQLH'};
Upar2={'LAM','LAMU','LAMW','LUPSSX_','LUSXU_','LUPSSX','LUSXU','LUPSHX','LUHXU','LAM','LAM'};
Upar3={'1','2','1','1','1','1','1','1','0','1','1'};
for j=1:numel(Uname)
  id=strmatch(Uname{j},lines(idU));
  if (isempty(id)),continue,end
  for jj=1:length(id)
    ic=cell2mat(strfind(lines(idU(id(jj))),'='));
    ic1=cell2mat(strfind(lines(idU(id(jj))),'['));
    ic2=cell2mat(strfind(lines(idU(id(jj))),']'));
    s1=lines{idU(id(jj))}(ic1:ic2);
    if (strcmp(lines{idU(id(jj))}(ic-1),'_'))
      s2=['[' strcat(Upar1{j},'_') ' ' strcat(Upar2{j},'_') ' ' Upar3{j} ']'];
    else
      s2=['[' Upar1{j} ' ' Upar2{j} ' ' Upar3{j} ']'];
    end
    lines(idU(id(jj)))=strrep(lines(idU(id(jj))),s1,s2);
  end
 %ic2=strfind(lines{idU(id)},']');
 %s1=lines{idU(id)}(ic1:ic2);
 %s2=['[' Upar1{j} ' ' Upar2{j} ' ' Upar3{j} ']'];
 %lines(idU(id))=strrep(lines(idU(id)),s1,s2);
 %disp(lines{idU(id)})
end

% a=regexp(lines(idU),'(?<=\[)\w*','match');
% for j=1:numel(a)
%   assign=vertcat(out.assign);
%   id=find(strcmpi(assign(:,1),a{j}),1);
%   if isempty(id)
%     continue
%   end
%   tag=regexp(assign{id,2},'(?<=2*(PI|pi)/)\w*(?=/sqrt)','match');
%   lines(idU(j))= ...
%     strrep(lines(idU(j)),[a{j}{1},' ',a{j}{1}],[a{j}{1},' ',tag{1}]);
% end

% Change type for TCAVs.
isT=~cellfun('isempty',strfind(lines,'''lc''')) & ...
   (~cellfun('isempty',strfind(lines,'''TC'  )) | ...
    ~cellfun('isempty',strfind(lines,'''XT'  )));
lines(isT)=regexprep(lines(isT),'''lc''','''tc''');

disp('Miscellaneous done.');

% Modify lines for SET commands.
sets=[];
for sCmd=opts.set'
  if (isempty(sets))
    sets=cell(numel(sCmd{2}),1);
  end
  isCmd=strncmp(lines,[sCmd{1},' '],length(sCmd{1})+1);
  lines(isCmd)=cellstr('');
  for j=1:numel(sCmd{2})
    sets{j}=[sets{j},sCmd{1},' = ',sCmd{2}{j},';'];
  end
end

% Add beamline output.
lines=[header;predef;lines];
if (isvector(blList))
  lines=[lines; ...
    strcat('beamLine.',blList(:),'=model_parseList(',blList(:),')'';')];
else
  defs=[];
  subCall=opts.sub';
  subCall2=opts.sub2';
  for j=1:size(blList,1)
    defs=[defs(1:end); ...
      {['beamLine.',blList{j,1},'=[',sprintf('%s,',blList{j,2}{1:end-1}), ...
      blList{j,2}{end},']'';']}];
    if (~isempty(subCall{j}))
      subCall{j}=sprintf('beamLine.%s=%s(beamLine.%s);', ...
        blList{j,1},opts.sub{j},blList{j,1});
    end
    if (~isempty(subCall2{j}))
      subCall2{j}=sprintf('beamLine.%s=%s(beamLine.%s);', ...
        blList{j,1},opts.sub2{j},blList{j,1});
    end
  end
  blAll=unique([blList{:,2}]);
  funCore=['[',sprintf('%s,',blAll{1:end-1}),blAll{end},']=bl()'];
  funs={'';['function ',funCore];''};
  funCall=repmat({[funCore,';']},size(blList,1),1);
  glob=[];
  if (~isempty(opts.set))
    glob={['global',sprintf(' %s',opts.set{:,1})];''};
  end
  lines=[glob;reshape([sets,funCall,defs,subCall,subCall2]',[],1);funs;glob;lines];
end
lines=[header1;lines];

% Insert script help
if (strcmp(nOut,'LCLS2sc'))
  htxt={ ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    sprintf('%% *** OPTICS=AD_ACCEL-%s ***',MADrelease); ...
    '% -----------------------------------------------------------------------------'; ...
    '%'; ...
    '% beamLine=model_beamLineLCLS2sc();'; ...
    '%'; ...
    '% Returns Matlab model beam lines that correspond to defined AD_ACCEL'; ...
    '% beampaths originating in the SC linac:'; ...
    '%'; ...
    '%  beamLine.SC_DIAG0 = gunB to DIAG0 FARC'; ...
    '%  beamLine.SC_HXR   = gunB to HXR beam dump'; ...
    '%  beamLine.SC_SXR   = gunB to SXR beam dump'; ...
    '%  beamLine.SC_BSYD  = gunB to BSY beam dump'; ...
    '%  beamLine.SC_DASEL = gunB to End Station A'; ...
    '%'; ...
    '% Additional beam lines used for comparison with MAD (starting at BEAM0, at 75 MeV):'; ...
    '%'; ...
    '%  beamLine.SC_DIAG0I = BEAM0 to DIAG0 FARC'; ...
    '%  beamLine.SC_HXRI   = BEAM0 to HXR beam dump'; ...
    '%  beamLine.SC_SXRI   = BEAM0 to SXR beam dump'; ...
    '%  beamLine.SC_BSYDI  = BEAM0 to BSY beam dump'; ...
    '%  beamLine.SC_DASELI = BEAM0 to End Station A'; ...
    '%'; ...
    '% Additional beam lines that correspond to planned AD_ACCEL_HE'; ...
    '% beampaths originating in the new Low Emittance Injector (LEI):'; ...
    '%'; ...
    '%  beamLine.SC_DIAG02 = gunLEI to DIAG0 FARC'; ...
    '%  beamLine.SC_HXR2   = gunLEI to HXR beam dump'; ...
    '%  beamLine.SC_SXR2   = gunLEI to SXR beam dump'; ...
    '%  beamLine.SC_BSYD2  = gunLEI to BSY beam dump'; ...
    '%  beamLine.SC_DASEL2 = gunLEI to End Station A'; ...
    '%'; ...
    '% Additional beam lines used for comparison with MAD (starting at BEAM0LEI, at 75 MeV):'; ...
    '%'; ...
    '%  beamLine.SC_DIAG02I = BEAM0LEI to DIAG0 FARC'; ...
    '%  beamLine.SC_HXR2I   = BEAM0LEI to HXR beam dump'; ...
    '%  beamLine.SC_SXR2I   = BEAM0LEI to SXR beam dump'; ...
    '%  beamLine.SC_BSYD2I  = BEAM0LEI to BSY beam dump'; ...
    '%  beamLine.SC_DASEL2I = BEAM0LEI to End Station A'; ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    ' '; ...
    '% check for mat-file version ... load and return beamLine if found'; ...
    'if (exist(''model_beamLineLCLS2sc.mat'')==2)'; ...
    '  load model_beamLineLCLS2sc.mat'; ...
    '  return'; ...
    'end'};
elseif (strcmp(nOut,'LCLS2cu'))
  htxt={ ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    sprintf('%% *** OPTICS=AD_ACCEL-%s ***',MADrelease); ...
    '% -----------------------------------------------------------------------------'; ...
    '%'; ...
    '% Returns Matlab model beam lines that correspond to defined AD_ACCEL'; ...
    '% beampaths originating in the room temperature Cu linac:'; ...
    '%'; ...
    '%  beamLine.CU_GSPEC = gun to 6 MeV spectrometer FARC (was ''GS'' in LCLS)'; ...
    '%  beamLine.CU_SPEC  = gun to 135 MeV spectrometer beam dump (was ''SP'' in LCLS)'; ...
    '%  beamLine.CU_HXR   = gun to HXR beam dump (was ''FullMachine'' in LCLS)'; ...
    '%  beamLine.CU_SXR   = gun to SXR beam dump'; ...
    '%'; ...
    '% Additional beam lines used for comparison with MAD (starting at OTR2, at 135 MeV):'; ...
    '%'; ...
    '%  beamLine.CU_SPECI  = OTR2 to 135 MeV spectrometer beam dump'; ...
    '%  beamLine.CU_HXRI   = OTR2 to HXR beam dump'; ...
    '%  beamLine.CU_SXRI   = OTR2 to SXR beam dump'; ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    ' '; ...
    '% check for mat-file version ... load and return beamLine if found'; ...
    'if (exist(''model_beamLineLCLS2cu.mat'')==2)'; ...
    '  load model_beamLineLCLS2cu.mat'; ...
    '  return'; ...
    'end'};
elseif (strcmp(nOut,'FACET2e'))
  htxt={ ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    sprintf('%% *** OPTICS=FACET2-%s ***',MADrelease); ...
    '% -----------------------------------------------------------------------------'; ...
    '%'; ...
    '% Returns Matlab model beam lines that correspond to defined FACET-II'; ...
    '% electron beampaths:'; ...
    '%'; ...
    '%  beamLine.F2_S10AIP = gun to (temporary) 6 MeV FARC'; ...
    '%  beamLine.F2_ELEC   = gun to main electron beam dump'; ...
    '%  beamLine.F2_SCAV   = gun to positron production target'; ...
    '%'; ...
    '% Additional beam lines used for comparison with MAD (the start point is at'; ...
    '% element BEGDL10, at 135 MeV):'; ...
    '%'; ...
    '%  beamLine.F2_ELECI  = BEGDL10 to main electron beam dump'; ...
    '%  beamLine.F2_SCAVI  = BEGDL10 to positron production target'; ...
    '%'; ...
    '% -----------------------------------------------------------------------------'; ...
    ' '; ...
    '% check for mat-file version ... load and return beamLine if found'; ...
    'if (exist(''model_beamLineFACET2e.mat'')==2)'; ...
    '  load model_beamLineFACET2e.mat'; ...
    '  return'; ...
    'end'};
end
lines=[lines(1);htxt;lines(2:end)];

% Write Matlab script.
fid=fopen(['model_beamLine',nOut,'.m'],'w');
fprintf(fid,'%s\n',lines{:});

% Write Matlab subfunctions.
fmt='for n=find(strcmp(''%s'',b(:,2)))'',b{n,4}(1)=%s;end\n';
for nf=1:nsub
  fprintf(fid,'function b=%s(b)\n',sub(nf).name);
  for ns=1:size(sub(nf).set,1)
    pname=[sub(nf).set{ns,1} ' '];
    pval=sub(nf).set{ns,2};
    id=find(contains(lines,pname)&contains(lines,'''qu'''));
    for nl=1:length(id)
      jd=strfind(lines{id(nl)},'=');
      qname=lines{id(nl)}(1:jd(1)-1);
      fprintf(fid,fmt,qname,pval);
    end
  end
  fprintf(fid,'\n');
end
fclose(fid);
disp(['Write Matlab file ',['model_beamLine',nOut,'.m'],' done.']);

if ((nargin>5)&&simplify)
  rehash;
  model_parseMatlab(['model_beamLine',nOut]);
end

%-------------------------------------------------------------------------------

function out=file2out(fileDir,file)

% Read MAD file.
str=textread(fullfile(fileDir,file),'%s','whitespace','\b');
disp(['Read MAD file ',file,' done.']);

% Parse MAD file.
out=struct('comment',{},'assign',{},'name',{},'items',{});
while (~isempty(str))
  [tag,str]=getTag(str);
  outLast=parseTag(tag);
  if (~isempty(outLast.items)&&strcmp(outLast.items{1},'CALL'))
    incFile=outLast.items{2,2};
    if (isempty(incFile))
      incFile=outLast.items{2,1};
    end
    incFile=incFile(2:end-1);
    ext='';
    if (~exist(incFile,'file'))
      [d,incFile,ext]=fileparts(incFile);
    end
    outLast=file2out(fileDir,[incFile,ext]);
  end
  out=[out(1:end);outLast];
end
disp(['Parse MAD file ',file,' done.']);

%-------------------------------------------------------------------------------

function lines=sortLines(out,lines)

assign=vertcat(out.assign);
isTag=~cellfun('isempty',assign(:,1));
isName=~cellfun('isempty',{out.name}');

names=cell(numel(out),1);
names(isTag)=assign(isTag,1);
names(isName)={out(isName).name}';

lineNoCom=regexp(strcat(lines,'%'),'%','split','once');
lineNoCom=strrep(vertcat(lineNoCom{:}),'''','_');
lineNoCom(:,2)=[];

use=((isTag|isName)&~cellfun('isempty',lineNoCom));

iMat=logical(sparse(numel(out),numel(lines)));
for j=find(use)'
  iMatch=regexp(lineNoCom,['\<',names{j},'\>']);
  iM=~cellfun('isempty',iMatch);
  iM(iM)=~strcmp(names(iM),names{j});
  iMat(j,:)=iM;
end
iMat=logical(iMat+speye(size(iMat)));
I=(1:numel(names))';
while (nnz(tril(iMat(I,I),-1)))
  [a,In]=sortrows(-iMat(I,I));
  I=I(In);
end
lines=lines(I);

%-------------------------------------------------------------------------------

function [tag,lines]=getTag(lines)

% Find continuation lines.
tag=regexp(lines{1},'!','split');
tcom=[tag{2:end}];
tag=tag{1};
if (~isempty(tcom))
  tcom=['!',tcom];
end
lines(1)=[];
comment={};
while (any(strtok(tag,'!')=='&')) % Check for concatenation ampersand
  if (strncmp(lines(1),'!',1))
    comment=[comment(1:end);lines(1)];
  else
    l=regexp(lines{1},'!','split');
    rem=[l{2:end}];
    l=l{1};
    if (~isempty(rem))
      rem=['!',rem(1:end)];
    end
    id=find(tag=='&',1);
    tag=[tag(1:id-1),l,tag(id+1:end),tcom,rem];
  end
  lines(1)=[];
end
while (~isempty(lines)&&~isempty(strtrim(lines{1}))&&( ...
  any(lines{1}(find(lines{1}~=' ',1))=='+-,0123456789')|| ...
  ~isempty(regexp(tag,'\,\s*$','once'))))
  tag=[tag(1:end),lines{1},tcom];
  lines(1)=[];
end
% Find command separators.
tags=regexp(tag,';','split','once');
tag=tags{1};
if (numel(tags)==1)
  tag=[tag,tcom];
else
  tags{2}=[tags{2},tcom];
end
lines=[tags{2:end};comment;lines];

%-------------------------------------------------------------------------------

function tag=repTag(tag)

tag=strrep(tag,'SQRT(','sqrt(');
tag=strrep(tag,'LOG(','log(');
tag=strrep(tag,'EXP(','exp(');
tag=strrep(tag,'ASIN(','asin(');
tag=strrep(tag,'ACOS(','acos(');
tag=strrep(tag,'ATAN(','atan(');
tag=strrep(tag,'ATAN2(','atan2(');
tag=strrep(tag,'SIN(','sin(');
tag=strrep(tag,'COS(','cos(');
tag=strrep(tag,'TAN(','tan(');
tag=strrep(tag,'ABS(','abs(');
tag=strrep(tag,'MAX(','max(');
tag=strrep(tag,'MIN(','min(');
tag=strrep(tag,'[L]','{3}');
tag=strrep(tag,'[ANGLE]','{4}'); % SROT elements
tag=strrep(tag,'[K1]','{4}(1)'); % QUAD elements

if (strfind(tag,'->L'))
  tag=strrep(tag,'->L','{3}');
end
if (strfind(tag,'[('))
  tag=regexprep(tag,'\[(\w*)\]','.$1');
end
if (strfind(tag,'GBpm0'))
  tag=strrep(tag,'GBpm0','GBpm'); % Special for LCLS
end
if (strfind(tag,'GBPM0'))
  tag=strrep(tag,'GBPM0','GBPM'); % Special for LCLS
end
if (strfind(tag,';'))
  tag=strrep(tag,';',''); % Typo in LCLS-II
end

%-------------------------------------------------------------------------------

function out=parseTag(tag)

tag=[regexp(tag,'!','split'),{''}];
out=struct('comment',tag{2},'assign',{{'' ''}},'name','','items',{{}});

% Make non-quotes uppercase
tags=regexp(tag{1},'"','split');
tags(1:2:end)=upper(tags(1:2:end));
tags=[tags;[repmat({'"'},1,numel(tags)-1),{''}]];
tag{1}=[tags{:}];

% Replace strings
tag=repTag(tag{1});

% Comment
if isempty(tag),return,end

% Parameter assignment
pos=[strfind(tag,':='),strfind(tag,': =')];
if (any(pos)&&(min(pos)<=min(strfind(tag,':'))))
  pC=strfind(tag,',');
  if (~isempty(pC)&&(min(pos)>=min(pC)))
    1;
  end
  if (isempty(pC)||(~isempty(pC)&&(min(pos)<min(pC))))
    out.assign=regexp(tag,':=|: =','split');
    out.assign(1)=strtrim(out.assign(1));
    return
  end
end

% Label definition
if (any(strfind(tag,':')))
  tag=strrep(tag,':=','=');
  tag1=regexp(tag,':','split');
  if ((sum(tag1{1}=='"')~=1)&&(numel(tag1)>1))
    out.name=strtrim(tag1{1});
    tag=tag1{2};
  end
end

% Make name Matlab compliant
out.name=strrep(strrep(out.name,'"',''),'.','_');

% Command
out.items=regexp(tag,'(?<!(^[^"]*"([^"]*"[^"]*")*[^"]*|\([^\)]*)),','split');
if ((numel(out.items)==1)&&~any(out.items{1}=='='))
  out.items=regexp(strtrim(out.items{1}),' ','split','once');
end
out.items=regexp(out.items,'=','split','once');
out.items=makeArray(out);

id=find(strcmp('TYPE',out.items(:,1)));
if (strncmp(out.items(id,2),'"@',2))
  out=fixDeferred(out);
end
%-------------------------------------------------------------------------------

function items=makeArray(out)

use=(cellfun('length',out.items)==1);
items(use,:)=[reshape(vertcat(out.items{use}),[],1),repmat({''},sum(use),1)];
items(~use,:)=reshape(vertcat(out.items{~use}),[],2);
items=strtrim(items);

%-------------------------------------------------------------------------------

function [line,comFlag,subFlag,out]=makeLine(out)

% Assignment
line='';
comFlag=0;
subFlag=0;
if (~isempty(out.assign{1}))
  line=sprintf('%s = %s;',out.assign{:});
end

% Definition
if (~isempty(out.items))
  t='';
  switch out.items{1}
    case 'CONSTANT'
      line=[out.name,'=',out.items{2},';'];
    case {'MARK','MARKER'}
      line=[out.name,'={''mo'' ''',out.name,''' 0 []}'';'];
    case {'DRIF','DRIFT'}
      vals=findTags(out.items,{'L'});
      line=[out.name,'={''dr'' '''' ',vals{1},' []}'';'];
    case {'SBEN','SBEND','RBEN','RBEND'}
      vals=findTags(out.items,{'L','ANGLE','HGAP','E1','E2','FINT','FINTX','TILT','K1'});
      if (isempty(vals{8}))
        vals{8}='pi/2';
      end
      name=out.name;
      if (ismember(name(end),{'A','B','1','2'}))
        name(end)=[];
      end
     %if (isempty(vals{9})) % non-gradient bend
      if (strcmp(vals{9},num2str(0))) % non-gradient bend
        line=[out.name,'={''be'' ''',name,''' ',vals{1},' [',vals{2},' ', ...
          vals{3},' ',vals{4},' ',vals{5},' ',vals{6},' ',vals{7},' ',vals{8},']}'';'];
      else % gradient bend
        line=[out.name,'={''bg'' ''',name,''' ',vals{1},' [',vals{2},' ', ...
          vals{3},' ',vals{4},' ',vals{5},' ',vals{6},' ',vals{7},' ', ...
          vals{8},' ',vals{9},']}'';'];
      end
    case {'QUAD','QUADRUPOLE'}
      vals=findTags(out.items,{'L','K1','TILT'});
      if (isempty(vals{3}))
        vals{3}='pi/4';
      end
      line=[out.name,'={''qu'' ''',out.name,''' ',vals{1},' [',vals{2},' ', ...
        vals{3},']}'';'];
    case {'SEXT','SEXTUPOLE'}
      vals=findTags(out.items,{'L','K2','TILT'});
      if (isempty(vals{3}))
        vals{3}='pi/6';
      end
      line=[out.name,'={''dr'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'OCTU','OCTUPOLE'}
      vals=findTags(out.items,{'L','K3','TILT'});
      if (isempty(vals{3}))
        vals{3}='pi/8';
      end
      line=[out.name,'={''dr'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'MULT','MULTIPOLE'}
     %line=[out.name,'={''mo'' ''',out.name,''' 0 []}'';'];
      vals=findTags(out.items,{'K0L','T0','K1L','T1'});
      if ~strcmp(vals{1},'0')&&~strcmp(vals{3},'0')
        error('%s: combined function MULTs not allowed',out.name)
      else % thin-lens dipole or thin-lens quad
        if (isempty(vals{2})),vals{2}='pi/2';end
        if (isempty(vals{4})),vals{4}='pi/4';end
        line=[out.name,'={''mu'' ''',out.name,''' 0 [',vals{1},' ', ...
          vals{2},' ',vals{3},' ',vals{4},']}'';'];
      end
    case {'SOLE','SOLENOID'}
      vals=findTags(out.items,{'L','KS'});
     %line=[out.name,'={''dr'' ''',out.name,''' ',vals{1},' []}'';'];
      line=[out.name,'={''so'' ''',out.name,''' ',vals{1},' [',vals{2},']}'';'];
    case { ...
        'HMON','HMONITOR', ...
        'VMON','VMONITOR', ...
        'INST','INSTRUMENT', ...
        'HKIC','HKICK','HKICKER', ...
        'VKIC','VKICK','VKICKER', ...
        'PROF','PROFILE', ...
        'WIRE', ...
        'IMON','IMONITOR', ...
        'BLMO','BLMONITOR'}
      vals=findTags(out.items,{'L'});
     %line=[out.name,'={''mo'' ''',out.name,t,''' ',vals{1},' []}'';'];
      line=[out.name,'={''mo'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'MONI','MONITOR'}
      vals=findTags(out.items,{'L'});
     %line=[out.name,'={''mo'' ''',out.name,t,''' ',vals{1},' ' '[]' '}'';'];
      line=[out.name,'={''mo'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'RFCA','RFCAVITY'}
      vals=findTags(out.items,{'L','FREQ','VOLT','LAG'});
      vals(2)=findTags(out.items,{'FREQ'},'2856');
     %line=[out.name,'={''lc'' ''',out.name,t,''' ',vals{1}, ...
     %  ' [',vals{2},' ',vals{3},' ',vals{4},'*TWOPI]}'';'];
      line=[out.name,'={''lc'' ''',out.name,''' ',vals{1}, ...
        ' [',vals{2},' ',vals{3},' ',vals{4},'*TWOPI]}'';'];
    case {'LCAV','LCAVITY'}
      s=char(out.items(:,1));
      twave=isempty(strmatch('SWAVE',s)); % traveling wave LCAV (not standing wave)
      vals=findTags(out.items,{'L','FREQ','DELTAE','PHI0'});
      name=regexprep(out.name,'___.','');
      name=regexprep(name,'__.','');
      name=regexprep(name,'(_..).','$1');
     %line=[out.name,'={''lc'' ''',name,t,''' ',vals{1}, ...
     %  ' [',vals{2},' ',vals{3},' ',vals{4},'*TWOPI]}'';'];
      if (twave)
        line=[out.name,'={''lc'' ''',name,''' ',vals{1}, ...
          ' [',vals{2},' ',vals{3},' ',vals{4},'*TWOPI]}'';'];
      else
        line=[out.name,'={''ls'' ''',name,''' ',vals{1}, ...
          ' [',vals{2},' ',vals{3},' ',vals{4},'*TWOPI]}'';'];
      end
    case {'ELSE','ELSEPARATOR'}
      vals=findTags(out.items,{'L'});
      line=[out.name,'={''mo'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'ECOL','ECOLLIMATOR','RCOL','RCOLLIMATOR'}
      vals=findTags(out.items,{'L'});
      line=[out.name,'={''dr'' ''',out.name,''' ',vals{1},' []}'';'];
    case {'SROT','SROTATION'}
    % NOTE: present (April, 2018) Matlab model scripts use -ANGLE for SROTs
      vals=findTags(out.items,{'ANGLE'});
      line=[out.name,'={''ro'' ''',out.name,''' 0 [-(',vals{1},')]}'';'];
    case {'YROT','YROTATION'}
      line=[out.name,'={''mo'' ''' ''' 0 []}'';'];
    case {'MATR','MATRIX'}
      vals=findTags(out.items,{'L','RM(3,3)','RM33'});
      val2=regexp(vals(2:3),'(?<=sqrt\()\w*(?=\))','match');
      if (~isempty(val2{1}))
        vals(2)=val2{1};
      elseif (~isempty(val2{2}))
        vals(2)=val2{2};
      end
      line=[out.name,'={''un'' ''',out.name,''' ',vals{1}, ...
        ' [',vals{2},' ',vals{2},']}'';'];
    case 'LINE'
      out.items{1,2}=regexprep(out.items{1,2},'(\d*)\*(\w*)','${repmat([$2 '',''],1,str2num($1)-1)}$2');
      line=[out.name,'=',strrep(strrep(out.items{1,2},'(','['),')',']'),';'];
      line=strrep(strrep(line,'"',''),'.','_');
    case 'LIST'
      out.items{1,2}=regexprep(out.items{1,2},'(\d*)\*(\w*)','${repmat([$2 '',''],1,str2num($1)-1)}$2');
      str=strrep(strrep(out.items{1,2},'(','['),')',']');
      line=[out.name,'={''list'' ''',out.name,''' 0 ',str,'}'';'];
    case 'SEQUENCE'
      vals=findTags(out.items,{'L'});
      str=[out.items(3:2:end,1),out.items(4:2:end,2)];
      line=[out.name,'={''sequence'' ''',out.name,''' ',vals{1},' ',str,'}'';'];
    case 'BETA0'
      vals=[strcat('''',out.items(2:end,1)','''');out.items(2:end,2)'];
      if (~isempty(vals))
        line=[out.name,'=struct(',sprintf('%s,%s,',vals{1:end-1}),vals{end},');'];
      end
    case {'USE','COGUESS','BEAM','RESBEAM','PRINT','SELECT', ...
          'SPLIT','SURVEY','TWISS','SAVEBETA','IBS','OPTICS','PLOT', ...
          'TABLE','STRING','SIGMA0','BEAMBEAM','LUMP', ...
          'COMMENT','ENDCOMMENT','SUBROUTINE','ENDSUBROUTINE'}
    otherwise
      if (isempty(out.items{1,2}))
        if (isempty(out.name))
          out.name=out.items{1,1};
          line='';
        else
          name=out.name;
%{
          if (ismember(name(8:end),{'1','2'}))
            name(8:end)=[]; % why? ... commented out
          end
%}
          line=[out.name,'=',out.items{1},';',out.name,'{2}=''',name,''';'];
        end
        vals=findTags(out.items,{'L'},[]);
        if (~isempty(vals{1}))
          if (isempty(line))
            line=[out.name,'=',out.items{1},';'];
          end
          line=[line,out.name,'{3}=',vals{1},';'];
        end
        vals=findTags(out.items,{'K1'},[]);
        if (~isempty(vals{1}))
          if (isempty(line))
            line=[out.name,'=',out.items{1},';'];
          end
          line=[line,out.name,'{4}(1)=',vals{1},';'];
        end
        vals=findTags(out.items,{'DELTAE'},[]);
        if (~isempty(vals{1}))
          if (isempty(line))
            line=[out.name,'=',out.items{1},';'];
          end
          line=[line,out.name,'{4}(2)=',vals{1},';'];
        end
        vals=findTags(out.items,{'PHI0'},[]);
        if (~isempty(vals{1}))
          if (isempty(line))
            line=[out.name,'=',out.items{1},';'];
          end
          line=[line,out.name,'{4}(3)=',vals{1},'*TWOPI;'];
        end
      elseif (isempty(out.name)&&(~any(out.items{1}==' ')))
        line=[line,out.items{1},'=',out.items{2},';'];
      end
  end
end

if (~isempty(out.items))
  switch out.items{1}
    case 'COMMENT'
      comFlag=1;
    case 'ENDCOMMENT'
      comFlag=-1;
    case 'SUBROUTINE'
      subFlag=1;
    case 'ENDSUBROUTINE'
      subFlag=-1;
  end
end

% Add comment.
if (~isempty(out.comment))
  line=[line,'%',out.comment];
end

%-------------------------------------------------------------------------------

function tagVals=findTags(items,tags,def)

if (nargin<3)
  def='0';
end
tagVals=repmat({def},numel(tags),1);
for j=1:numel(tags)
  id=find(strcmp(items(:,1),tags{j}),1,'last');
  if (any(id))
    tagVals{j}=strrep(items{id,2},' ','');
  end
end

%-------------------------------------------------------------------------------

function out=fixDeferred(out)
keyw=out.items{1,1};
% id=find(strcmp('L',out.items(:,1)));
% if (isempty(id))
%   out.items(1,:)=[{'MARK'},{''}];
% else
%   out.items(1,:)=[{'DRIF'},{''}];
% end
out.items(1,:)=[{'DRIF'},{''}];
id=[];
for n=2:length(out.items)
  attr=out.items{n,1};
  if (~strcmp(attr,'L')&~strcmp(attr,'TYPE'))
    id=[id;n];
  end
end
out.items(id,:)=[];
if (true)
  name=out.name;
  fprintf('Deferred item %s keyword (%s) changed to %s\n',name,keyw,out.items{1,1})
end
