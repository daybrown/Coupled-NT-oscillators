function Y= bvp_CNT(t,x,p,mode)
    phi1= p(1,:); 
    phi2= p(2,:);
    eps1= p(3,:); 
    eps2= p(4,:);
    kD= p(5,:); 
    kf= p(6,:);
    kL1= p(7,:);
    kL2= p(8,:);    % control light
    alpha1= p(9,:);
    alpha2= p(10,:);    % control coupling.
    LD_phase= p(11,:);  % control light phase.
    
    P1= x(1,:);
    M1= x(2,:);
    P2= x(3,:);
    M2= x(4,:);
    T= x(5,:);
    
    h= @(x) x./(0.1+x+2*x.^2);
    g= @(x) 1./(1+x.^4);
    f= @(t) heaviside(sin((t+LD_phase)*pi/12));
    
    switch mode
        case 'LL'
            k= 1;
        case 'DD'
            k= 0;
        case 'LD'
            k= f(t/T);
    end

    Y= [T*phi1*(M1 - kD*P1 - kf*h(P1) - kL1*k*P1);
        T*phi1*eps1*(g(P1)-M1) + phi1*eps1*(alpha2*M2).*g(P1);
        T*phi2*(M2 - kD*P2 - kf*h(P2) - kL2*k*P2);
        T*phi2*eps2*(g(P2)-M2) + phi2*eps2*(alpha1*M1).*g(P2);
        0];
end