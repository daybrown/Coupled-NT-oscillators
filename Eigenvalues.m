%% Calculate Jacobian and the eigenvalue near the fixed points.
function e = Eigenvalues(Pi,xs)
Pi1= Pi(:,:,1);
Pi2= Pi(:,:,2);
dt= 0.1;

inds= round(xs/dt + 1);
is= inds(1); js= inds(2);
Pi1x= (Pi1(is+1,js)-Pi1(is,js))/dt;
Pi1y= (Pi1(is,js+1)-Pi1(is,js))/dt;
Pi2x= (Pi2(is+1,js)-Pi2(is,js))/dt;
Pi2y= (Pi2(is,js+1)-Pi2(is,js))/dt;

Jac= [Pi1x Pi1y; Pi2x Pi2y];

e= eig(Jac)
end