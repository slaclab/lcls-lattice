%% to interpolate the wake file: X-band, longitudinal
clear;
[Sx_z Sx_W Sx_t] =textread('Sz_20um_25mm_xband.sdds','%f %f %f','headerlines',7,'delimiter',' ');


Sx_z2 = Sx_z(1:501);
Sx_W2 = Sx_W(1:501);
Sx_t2 = Sx_t(1:501);

z = linspace(min(Sx_z2),max(Sx_z2),200001);
W = interp1(Sx_z2,Sx_W2,z,'spline');
t = interp1(Sx_z2,Sx_t2,z,'spline');

figure(31)
plot(Sx_z2,Sx_W2,'r.',z,W,'b--')
figure(32)
plot(Sx_t2,Sx_W2,'r.',t,W,'b--')

h1='SDDS1';
h2='&column name=z, units=m, type=double,  &end';
h3='&column name=W, units=V/C, type=double,  &end';
h4='&column name=t, units=s, type=double,  &end';
h5='&data mode=ascii, &end';
h6='! page number 1';
h7=[num2str(length(W))];
out =[z;W;t]; 
 
savefilename = ['Sz_p05um_10mm_xband.sdds'];
fid = fopen(savefilename,'wt');
fprintf(fid,'%s\n',h1);
fprintf(fid,'%s\n',h2);
fprintf(fid,'%s\n',h3);
fprintf(fid,'%s\n',h4);
fprintf(fid,'%s\n',h5);
fprintf(fid,'%s\n',h6);
fprintf(fid,'%s\n',h7);
fprintf(fid,'%14.8e %14.8e %14.8e\n',out);
fclose(fid)

%return;

%% to interpolate the wake file: S-band, transverse
clear


[Sx_z Sx_W Sx_t] =textread('Sx_50um_10mm_xband.sdds','%f %f %f','headerlines',7,'delimiter',' ');



z = linspace(min(Sx_z),max(Sx_z),200001);
W = interp1(Sx_z,Sx_W,z,'spline');
t = interp1(Sx_z,Sx_t,z,'spline');

figure(41)
plot(Sx_z,Sx_W,'r.',z,W,'b--')
figure(42)
plot(Sx_t,Sx_W,'r.',t,W,'b--')

h1='SDDS1';
h2='&column name=z, units=m, type=double,  &end';
h3='&column name=W, units=V/C/m, type=double,  &end';
h4='&column name=t, units=s, type=double,  &end';
h5='&data mode=ascii, &end';
h6='! page number 1';
h7=[num2str(length(W))];
out =[z;W;t]; 
 
savefilename = ['Sx_p05um_10mm_xband.sdds'];
fid = fopen(savefilename,'wt');
fprintf(fid,'%s\n',h1);
fprintf(fid,'%s\n',h2);
fprintf(fid,'%s\n',h3);
fprintf(fid,'%s\n',h4);
fprintf(fid,'%s\n',h5);
fprintf(fid,'%s\n',h6);
fprintf(fid,'%s\n',h7);
fprintf(fid,'%14.8e %14.8e %14.8e\n',out);
fclose(fid)
%return;



%% to interpolate the wake file: S-band, longitudinal
clear;

[Sx_z Sx_W Sx_t] =textread('Sz_p5um_10mm.sdds','%f %f %f','headerlines',7,'delimiter',' ');



z = linspace(min(Sx_z),max(Sx_z),200001);
W = interp1(Sx_z,Sx_W,z,'spline');
t = interp1(Sx_z,Sx_t,z,'spline');

figure(21)
plot(Sx_z,Sx_W,'r.',z,W,'b--')
figure(22)
plot(Sx_t,Sx_W,'r.',t,W,'b--')

h1='SDDS1';
h2='&column name=z, units=m, type=double,  &end';
h3='&column name=W, units=V/C, type=double,  &end';
h4='&column name=t, units=s, type=double,  &end';
h5='&data mode=ascii, &end';
h6='! page number 1';
h7=[num2str(length(W))];
out =[z;W;t]; 
 
savefilename = ['Sz_p05um_10mm.sdds'];
fid = fopen(savefilename,'wt');
fprintf(fid,'%s\n',h1);
fprintf(fid,'%s\n',h2);
fprintf(fid,'%s\n',h3);
fprintf(fid,'%s\n',h4);
fprintf(fid,'%s\n',h5);
fprintf(fid,'%s\n',h6);
fprintf(fid,'%s\n',h7);
fprintf(fid,'%14.8e %14.8e %14.8e\n',out);
fclose(fid)

%return;
%% to interpolate the wake file: S-band, transverse
clear;

[Sx_z Sx_W Sx_t] =textread('Sx_p5um_10mm.sdds','%f %f %f','headerlines',7,'delimiter',' ');



z = linspace(min(Sx_z),max(Sx_z),200001);
W = interp1(Sx_z,Sx_W,z,'spline');
t = interp1(Sx_z,Sx_t,z,'spline');

figure(11)
plot(Sx_z,Sx_W,'r.',z,W,'b--')
figure(12)
plot(Sx_t,Sx_W,'r.',t,W,'b--')

h1='SDDS1';
h2='&column name=z, units=m, type=double,  &end';
h3='&column name=W, units=V/C/m, type=double,  &end';
h4='&column name=t, units=s, type=double,  &end';
h5='&data mode=ascii, &end';
h6='! page number 1';
h7=[num2str(length(W))];
out =[z;W;t]; 
 
savefilename = ['Sx_p05um_10mm.sdds'];
fid = fopen(savefilename,'wt');
fprintf(fid,'%s\n',h1);
fprintf(fid,'%s\n',h2);
fprintf(fid,'%s\n',h3);
fprintf(fid,'%s\n',h4);
fprintf(fid,'%s\n',h5);
fprintf(fid,'%s\n',h6);
fprintf(fid,'%s\n',h7);
fprintf(fid,'%14.8e %14.8e %14.8e\n',out);
fclose(fid)

