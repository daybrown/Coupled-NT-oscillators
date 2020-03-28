function res = bc_CNT(ya,yb,p)

g = @(x) 1./(1+x.^4);
fj = (1+p(9)*ya(4)).*g(ya(1)) - ya(2);
res = [ya(1) - yb(1);ya(2) - yb(2);ya(3) - yb(3);ya(4) - yb(4);fj];

end