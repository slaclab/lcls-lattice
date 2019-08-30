%	rw_wake
%
%	A script (not a function) to calculate the resistive-wall wakefield over a selected bunch profile.

da      = prompt('DC or AC conductivity','da','d');
if da=='a'
  tau   = nprompt('Relaxation time (sec)',2.7E-14,1E-20,1);
end
sig     = nprompt('Conductivity (ohm-1*m-1)',5.8E7,1,1E20);
rfs     = prompt('Cylindrical or Rectangular chamber','cr','c');
if rfs == 'c'
  rf = 0;
  r     = nprompt('Beam pipe radius (mm)',2.5,1E-6,1E6);
else
  rf = 1;
  r     = nprompt('Beam pipe half-height (mm)',2.5,1E-6,1E6);
end
Ne      = nprompt('Bunch population',6.25E9);
L       = nprompt('Length of section of radius r (m)',130);
E0      = nprompt('Energy of beam [GeV]',13.64);
fgu     = prompt('Use distribution File, Gaussian or Uniform dist.','fgu','u');

Q  = 1.6022E-19;
c  = 2.99792458E8;
Z0 = 120*pi;

if fgu == 'f'
  fn = input('ELE2MAT bunch distribution file name (e.g. LCLS10JUN03_spoiled.DAT): ','s');	% col5=Z/m
  str = ['load ' fn];
  eval(str)
  i = find(fn=='.');
  fn(i(1):length(fn))=[];
  str = ['A = ' fn ';'];
  eval(str);
  zj = A(:,5);
  [N,z] = hist(zj,200);
  if length(N) < 200
    [zs,Ns] = plot_spline(z,N,'.',1,200);
  else
     zs = z;
     Ns = N;
  end
  Ipk = Ns*Q*Ne*c/mean(diff(zs))/sum(Ns);
elseif fgu == 'g'
  sigz = nprompt('rms bunch length [um]',24,0.01,1E4)*1E-6;
  zs = 0:(sigz/100):(sigz*10);
  Ns = gauss(zs,5*sigz,sigz);
  Ipk = Ns*Q*Ne*c/mean(diff(zs));
elseif fgu == 'u'
  sigz = nprompt('rms bunch length [um]',24,0.01,1E4)*1E-6;
  zs = 0:(sigz/131):(1.1*sigz*sqrt(12));
  Ns = ones(size(zs));
  nn = length(zs);
  n  = round(0.05*nn);
  Ns(1:n)  = 0*Ns(1:n);
  [dum,n]  = min(abs(zs-zs(n)-sigz*sqrt(12)));
  Ns((n+1):nn) = 0*Ns((n+1):nn);
  Ipk = Ns*Q*Ne*c/(sigz*sqrt(12));
end

r  = r*1E-3;
E0 = E0*1E9;
s0 = (2*r^2/(Z0*sig))^(1/3);

f = Ns/integrate(zs,Ns);

s = zs - zs(1);
if da=='d'
  w = rw_wakefield(s,r,s0);
else
  w = rw_wakefield(s,r,s0,tau,rf);
end
if fgu == 'f'
  zs_mean = integrate(zs,f.*zs);
  sigz    = sqrt(integrate(zs,f.*(zs-zs_mean).^2));
end

n = length(s);
E = zeros(n,n);
for j = 1:n
  for i = 1:n
    if i==j
      break
    else
      E(i,j) = w(j-i)*f(i);
    end
  end
end

dz = mean(diff(zs));

Ez = 100*Q*Ne*L*sum(E)*dz/E0;
Ez_mean = integrate(zs,f.*Ez);
Ez_rms  = sqrt(integrate(zs,f.*(Ez-Ez_mean).^2));
Ez_rmsg = 100*rw_esprd(E0/1E9,Ne/1E10,L,r,sigz*1E6,sig);

% Piwinski:
% ========
%  disp('Reverting to Piwinski approximation for sig_Z >> s0')
%  u     = s_sigz;
%  i     = find(u==0);
%  u(i)  = 1E-3;
%  uu    = (u.^2)/4;
%  a     = 1/4;
%  I_p14 = besseli(a,uu);
%  I_m34 = 2*a*I_p14./uu + besseli(a+1,uu);
%
%  a     = 3/4;
%  I_p34 = besseli(a,uu);
%  I_m14 = 2*a*I_p34./uu + besseli(a+1,uu);
%
%  Ez = abs(u).^(3/2).*exp(-(uu)).*(I_p14 - I_m34 + ...
%                                   sign(u).*I_m14 - sign(u).*I_p34)/4;

if da=='a'
  tstr = ['AC Resistive-Wall Wake ({\it\tau} = ' sprintf('%4.1f',tau*1E15) ' fs, {\it\sigma_c} = ' sprintf('%4.2f',sig/1E7) '\times10^7' ...
         ' /\Omega/m, {\itr} = ' sprintf('%4.1f',r*1E3) ' mm, {\itL} = ' sprintf('%5.1f',L) ' m)'];
else
  tstr = ['DC Resistive-Wall Wake ({\it\sigma_c} = ' sprintf('%4.2f',sig/1E7) '\times10^7' ...
         ' /\Omega/m, {\itr} = ' sprintf('%4.1f',r*1E3) ' mm, {\itL} = ' sprintf('%5.1f',L) ' m)'];
end

H = plotyy_labels(zs*1E6,Ez,zs*1E6,Ipk/1E3,'{\itz} (\mum)','\Delta{\itE}/{\itE}_0 (%)','{\itI_{pk}} (kA)',tstr,0);
Hc=get(H(2),'Children');		% get handle to I_pk trace
set(Hc,'LineWidth',2);			% set I_pk trace to linewidth of 2
%set(H(1),'Ylim',[-0.3 0.1])
%set(H(1),'Xlim',[-25 20])
%set(H(2),'Ylim',[0 6])
%set(H(2),'Xlim',[-25 20])

%%plot(zs*1E6,Ez,'-m')
%%v = axis;
%%hold on
%%plot(zs*1E6,f*(v(4)-v(3))/max(f),'--b')
%%xlabel('{\itz}/\mum')
%%ylabel('\Delta{\itE}/{\itE}_0 /%   &   {\itf}({\itz})')
%%title(['Resistive-Wall Wake ({\it\sigma_c} = ' sprintf('%3.1e',sig) ...
%%       ' /\Omega/m, {\itr} = ' sprintf('%4.1f',r*1E3) ' mm, {\itL} = ' sprintf('%4.3f',L) ' m)'])

%text(scx(0.65),scy(0.89),['\langle{\Delta\itE}/{\itE}_0\rangle  = ' sprintf('%6.4f',Ez_mean) '%'])
%text(scx(0.65),scy(0.85),['{\it\sigma_{\delta}}           = ' sprintf('%6.4f',Ez_rms) '%'])
%text(scx(0.65),scy(0.82),['{\itN}            = ' sprintf('%5.2f',Ne/1E9) '\times10^9'])
%text(scx(0.65),scy(0.77),['{\itE}_0           = ' sprintf('%6.2f',E0/1E9) ' GeV'])
%text(scx(0.65),scy(0.74),['{\its}_0            = ' sprintf('%6.1f',s0*1E6) ' \mum'])
%text(scx(0.65),scy(0.70),['{\it\sigma_z}            = ' sprintf('%6.1f',sigz*1E6) ' \mum'])

%%text(scx(0.65),scy(0.67),['{\it\sigma_{\delta}}(gauss) = ' sprintf('%6.4f',Ez_rmsg) '%'])
hor_line(0,':k')
enhance_plot('times',18,3,1)
%%hold off
