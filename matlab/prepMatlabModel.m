
% *** OPTICS=AD_ACCEL-11NOV2026s ***

% prepare files per makeMatlabModel.m comments:
% - uncomment SUBROUTINES in LCLS2cu_main.mad8 and LCLS2sc_main.mad8
% - replace CALLs to xsif files with SUBROUTINE references
% - remove "working stuff" from LCLS2cu_main.mad8 and LCLS2sc_main.mad8
% - use special definition of UMXLh in LTU.xsif
% - change mirrors from MULT to INST in SXTES.xsif and HXTES.xsif
% - check that L1.xsif (etc) is being CALLed, not L1e.xsif (etc)

optics='11NOV2026s';
d=['\\wsl.localhost\Ubuntu\home\mdw\AD_ACCEL\',optics,'\mad'];

fname='LCLS2sc_main.mad8';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
bang=false;
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  ic=strfind(s,'SETK2scLEI : SUBROUTINE');
  if (isempty(ic)),ic=strfind(s,'SETK2scDGI : SUBROUTINE');end
  if (~isempty(ic))
    nc=ic-1;
    bang=true;
  end
  if (bang),s(nc)=' ';end
  if (~isempty(strfind(s,'ENDSUBROUTINE')))
    bang=false;
  end
  s=strrep(s,'"LCLS2sc_master.xsif"','"MM_LCLS2sc_master.xsif"');
  s=strrep(s,'!CALL, FILENAME="SETK2scDGI.xsif"','!SETK2scDGI');
  s=strrep(s,' CALL, FILENAME="SETK2scDGI.xsif"',' SETK2scDGI');
  s=strrep(s,' CALL, FILENAME="SETK2scLEI.xsif"',' SETK2scLEI');
  fprintf(fido,'%s\n',s);
  if (strmatch('  STOP',s)==1),break,end
end
fclose(fidi);
fclose(fido);

fname='LCLS2cu_main.mad8';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
bang=false;
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  ic=strfind(s,'SETK2cuS : SUBROUTINE');
  if (isempty(ic)),ic=strfind(s,'SETK2cuH : SUBROUTINE');end
  if (~isempty(ic))
    nc=ic-1;
    bang=true;
  end
  if (bang),s(nc)=' ';end
  if (~isempty(strfind(s,'ENDSUBROUTINE')))
    bang=false;
  end
  s=strrep(s,'"LCLS2cu_master.xsif"','"MM_LCLS2cu_master.xsif"');
  s=strrep(s,' CALL, FILENAME="SETK2cuH.xsif"',' SETK2cuH');
  s=strrep(s,' CALL, FILENAME="SETK2cuS.xsif"',' SETK2cuS');
  fprintf(fido,'%s\n',s);
  if (strmatch('  STOP',s)==1),break,end
end
fclose(fidi);
fclose(fido);

fname='LTU.xsif';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  so=s;
  if (~isempty(strfind(s,' comment')))
    so=strrep(s,' comment','!comment');
  elseif (~isempty(strfind(s,' endcomment')))
    so=strrep(s,' endcomment','!endcomment');
  elseif (~isempty(strfind(s,'!comment')))
    so=strrep(s,'!comment',' comment');
  elseif (~isempty(strfind(s,'!endcomment')))
    so=strrep(s,'!endcomment',' endcomment');
  end
  fprintf(fido,'%s\n',so);
end
fclose(fidi);
fclose(fido);

fname='HXTES.xsif';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  so=s;
  if (~isempty(strfind(s,': MULT,')))
    so(2)='!';
  elseif (~isempty(strfind(s,': INST,')))
    so(2)=' ';
  end
  fprintf(fido,'%s\n',so);
end
fclose(fidi);
fclose(fido);

fname='SXTES.xsif';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  so=s;
  if (~isempty(strfind(s,': MULT,')))
    so(2)='!';
  elseif (~isempty(strfind(s,': INST,')))
    so(2)=' ';
  end
  fprintf(fido,'%s\n',so);
end
fclose(fidi);
fclose(fido);

fname='LCLS2sc_master.xsif';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  s=strrep(s,'"LTU.xsif"','"MM_LTU.xsif"');
  s=strrep(s,'"SXTES.xsif"','"MM_SXTES.xsif"');
  fprintf(fido,'%s\n',s);
end
fclose(fidi);
fclose(fido);

fname='LCLS2cu_master.xsif';
fidi=fopen(fullfile(d,fname),'r');
fido=fopen(fullfile(d,['MM_',fname]),'w');
while (1)
  s=fgetl(fidi);
  if (~ischar(s)),break,end
  s=strrep(s,'"LTU.xsif"','"MM_LTU.xsif"');
  s=strrep(s,'"HXTES.xsif"','"MM_HXTES.xsif"');
  fprintf(fido,'%s\n',s);
end
fclose(fidi);
fclose(fido);
