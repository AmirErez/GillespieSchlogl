function Schlogl = SchloglFromIsingOldMapping(Ising)
   Schlogl = struct;
   x = 2*Ising.nc - 3;
   
   Schlogl.s = (3*Ising.nc^3*(Ising.theta+Ising.h)+Ising.nc*x^2+x^3)/...
       (3*Ising.nc^2*Ising.theta+x^2);
   Schlogl.K2 = (3*x^2+1)/4;
   Schlogl.K = sqrt(Schlogl.K2);
   Schlogl.a = ((3*x^2+1)*(3*Ising.nc^3*(Ising.theta+Ising.h)+Ising.nc*x^2+x^3)-4*x^5)/...
        ((3*x^2+1)*(3*Ising.nc^2*Ising.theta+x^2));
   Schlogl.N = Ising.nc*10;
end
