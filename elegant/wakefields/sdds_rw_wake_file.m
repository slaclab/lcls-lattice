function sdds_rw_wake_file();

sigC    = nprompt('Conductivity (ohm-1*m-1)',3.5E7,1,1E20);
r       = nprompt('Beam pipe radius (mm)',2.5,1E-6,1E6);
ds      = nprompt('Delta-z increments along wake (microns)',0.1,0.001,1E6);
sf      = nprompt('Full range of wake file (microns)',1000,1,75E3);

rf=1;      % rectangle shape
tau=8e-15; % Al relaxation time 

if sf <= ds
  error('Increments are larger than full range - try again.')
end

rm      = r*1e-3;
dsm     = ds*1e-6;
sfm     = sf*1e-6;
s       = 0:dsm:sfm;
N       = length(s);
c       = 2.99792458e8;
Z0      = 120*pi;
s0      = (2*rm^2/(Z0*sigC))^(1/3);

%W  = rw_wakefield(s,rm,s0);
W  = rw_wakefield(s,rm,s0,tau,rf);
um = sprintf('%2.2f',ds);
mm = sprintf('%2.2f',sf/1e3);
fn = ['SzRW_' um 'um_' mm 'mm.sdds'];
fid = fopen(fn,'w');

fprintf(fid,'SDDS1\n');
fprintf(fid,'&column name=z, units=m, type=double,  &end\n');
fprintf(fid,'&column name=W, units=V/C, type=double,  &end\n');	% should be "V/C/m" units but WAKE elemant expects "V/C/cell" ("factor" is then in meters)
fprintf(fid,'&column name=t, units=s, type=double,  &end\n');
fprintf(fid,'&data mode=ascii, &end\n');
fprintf(fid,'! page number 1\n');
fprintf(fid,'               %5.0f\n',N);
for j = 1:N
  fprintf(fid,'%12.8e  %12.8e  %12.8e \n',s(j),-W(j),s(j)/c);
end
fclose(fid);
disp(' ')
disp(['Resistive-Wall point-charge wake file written to: ' fn])
disp('Wakefield is in units of V/C/m')
