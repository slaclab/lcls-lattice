	function E = rw_wakefield(s,r,s0,tau,rf)

%	E = rw_wakefield(s,r,s0[,tau,rf]);
%
%	Function to calculate the resistive wall wakefield (Green's function)
%	for a bunch which is short or long compared to the characteristic
%	length for a cylindrical or parallel plate vacuum chamber.
%   Uses the Green's function from Karl Bane's 2004 AC-wake paper for the
%	case where "tau" is given (AC-wake) and uses the wake from Frank
%	Zimmermann's and Tor Raubenheimer's NLC-note for the tau=0 (DC) case.
%
%    Inputs:	s:		(vector) Axial position (s>=0) [m]
%             r:		Radius of beam chamber [m]
%             s0:		Characteristic length (2r^2/(Z0*sigC))^(1/3) [m]
%             tau:	(Optional, DEF=none) Relaxation time [sec] - if not given
%                   we default to DC-conductivity
%             rf:		(Optional, DEF=1) rf=0 is round pipe, and rf=1 is flat (parallel plates)
%    Outputs:	E:		Green's function [V/C/m]

%===============================================================================

if any(s<0)
  error('s should be >= 0')
end

s_s0 = s/s0;

Z0 = 120*pi;
c  = 2.99792458E8;
sig = 2*r^2/Z0/s0^3;

if ~exist('rf')
  rf = 0;
end
if exist('tau')
  Gamma = c*tau/s0;
  if Gamma<=2.5
	krs0c = [
	   1.81620118662482   1.29832152141677
	   0.29540336833708   0.18173822141741
	  -1.23728482888772  -0.62770698511448
	   1.05410903517018   0.47383850057072
	  -0.38606826800684  -0.15947258626548
	   0.05234403145974   0.02034464240245];	% 5th-order coefficients (0<=Gamma<=2.5), col-1 is cylindrical, col-2 is parallel plates - Dec. 3, 2004
	Qrc = [
	   1.09524274851589  1.02903443223445
	   2.40729067134909  1.33341005467949
	   0.06574992723432  -0.16585375059715
	  -0.04766884506469  0.00075548123372];		% 3rd-order coefficients (0<=Gamma<=2.5), col-1 is cylindrical, col-2 is parallel plates - Dec. 3, 2004
	krs0 = 0;
	Qr   = 0;
    A = [1 pi^2/16];
	for j = 1:length(krs0c(:,1))
	  krs0 = krs0 + krs0c(j,rf+1)*Gamma^(j-1);
	end
	for j = 1:length(Qrc(:,1))
	  Qr = Qr + Qrc(j,rf+1)*Gamma^(j-1);
	end
%	s0
%    Qr
%	krs0
	kr = krs0/s0;
	E = -A(rf+1)*Z0*c/pi*( exp(-kr*s/(2*Qr)).*cos(kr*s) )/r^2;  % this is the AC wake with round (rf=0) or flat (rf=1) pipe, with Gamma <=2.5, Fig14 of slac-pub-10107. 
  else
    wp = sqrt(Z0*c*sig/tau);
    E  = -Z0*c/pi*( exp(-s/(4*c*tau)).*cos(sqrt(2*wp/r/c)*s) )/r^2; % if Gamma > 2.5, eq(10) of slac-pub-10107, high Gamma case.
  end
else
  alf = 0.9;
  a   = 3/(4*sqrt(2*pi));
  E   = -Z0*c/(4*pi)*...
       ( (16/3)*exp(-s_s0).*cos(sqrt(3)*s_s0) - (sqrt(2*pi)*(a^alf+s_s0.^(3*alf/2)).^(1/alf)).^(-1) )/r^2;% this is the DC wake
end
