function W = Grow_manifold(Pi,fp,d_range,alpha_range,dalpha_range,mode) % Simplest version first.
% Pi: the first iterates of the map for e'space.
% fp: starting fixed point.
% d_range: estimate distance.
% alpha_range: min and max acceptable angle.
% dalpha_range: min and max acceptable d*angle.
xs= [10.2 10.2]; % The unstable manifold ends at.
xu= [17.2 3.73];  % The stable manifold ends at.
[e,eV]= Eigenvalues(Pi,fp);

switch mode
    case 0  % Ustable.
        eVu= eV(:,e>1);    % Find the e'vetor with e'value's modulus > 1.
        phi0= fp;
        %% grow + direction. for - direction change sign.
        phi1= phi0 - round(eVu,3)'; 
        W= [fp ; phi1];
        [phi_pre,phi_new]= Bisection_step(W,d_range,alpha_range,dalpha_range);
        W= [fp; phi_pre; phi_new];

        while (norm(mod(W(end,:),24)-xs) > 0.5) && (length(W(:,1))<60)
            [phi_pre,phi_new]= Bisection_step(W,d_range,alpha_range,dalpha_range);
        %         W(end,:)= phi_pre;
            W= [W ; phi_new];
        end

    case 1  % Stable.
        eVs= eV(:,e<1);    % Find the e'vetor with e'value's modulus < 1.
        phi0= fp;
        %% Grow + dircetion, change sign for - direction.
        phi1= phi0 - round(eVs,3)'; 
        W= [fp ; phi1];
        [phi_pre,phi_new]= SC_step(W,d_range,alpha_range,dalpha_range);  % Rewrite the SC method.
        W= [fp; phi_pre; phi_new];

        while (norm(mod(W(end,:),24)-xu) > 0.5) && (length(W(:,1))<60)
            [phi_pre,phi_new]= SC_step(W,d_range,alpha_range,dalpha_range);
        %         W(end,:)= phi_pre;
            W= [W ; phi_new];
        end
end

%% Plot it out.
W= mod(W,24);
dW= diff(W);    % get the difference.
ndW= sqrt(dW(:,1).^2+dW(:,2).^2);   % get the norm of the difference.
idx= find(ndW>15);  % Find the index of discontinuity.

if isempty(idx)
    figure;
    plot(W(:,1),W(:,2));
    title(['x=',num2str(fp(1)),', y=',num2str(fp(2))]);
    grid on;
    axis([0 24 0 24]);
    
    % fit curve to data.
    figure;
    f=fit(W(:,2),W(:,1),'poly5');
    plot(f(W(:,2)),W(:,2),W(:,1),W(:,2));
    axis([0 24 0 24]);
    
else
    figure;
    plot(W(1:idx,1),W(1:idx,2),'k',W(idx+1:end,1),W(idx+1:end,2),'k');
    hold on;
    
    % fit curve to data.
    f1= fit(W(1:idx,2),W(1:idx,1),'poly5');
    f2= fit(W(idx+1:end,2),W(idx+1:end,1),'poly5');
    plot(f1(W(1:idx,2)),W(1:idx,2),f2(W(idx+1:end,2)),W(idx+1:end,2));
    
    title(['x=',num2str(fp(1)),', y=',num2str(fp(2))]);
    grid on;
    axis([0 24 0 24]);  
end

end