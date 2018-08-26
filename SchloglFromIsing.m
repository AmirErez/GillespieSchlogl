function Schlogl = SchloglFromIsing(Ising)
Schlogl = struct;
Schlogl.s = 3*(Ising.nc-1);
Schlogl.K = sqrt(3*Ising.theta*Ising.nc^2 + 3*(Ising.nc-1)*(Ising.nc-2)+1);
Schlogl.a = ((3*Ising.theta+3*Ising.h+1)*Ising.nc^3 - 6*(Ising.nc-1))/(Schlogl.K^2);
Schlogl.g = Ising.g;