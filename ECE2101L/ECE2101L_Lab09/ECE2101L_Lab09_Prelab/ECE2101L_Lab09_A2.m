clc
clear
%#ok<*NOPTS>
Z=35*cosd(-27)+35*sind(-27)*1j;
I=52*cosd(43)+52*sind(43)*1j;
Irms=abs(I)./sqrt(2);
S=(Irms)^2*Z
P=real(S)
Q=imag(S)
Smag=abs(S)