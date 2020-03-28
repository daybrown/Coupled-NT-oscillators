function [phik,phik1] = SC_step(W,d_range,alpha_range,dalpha_range)

% Parameters have same meaning as Grow_manifold.

N= length(W(:,1));
phik= []; phik1= [];

% Find the start and end of the section of the circle.
theta_s= -alpha_range;
theta_e= alpha_range;

p_bar= (W(end,:)-W(end-1,:))/norm(W(end,:)-W(end-1,:))*d_range(2); % Vector on the circle with angle 0.
Rota= @(x) [cos(x) -sin(x); sin(x) cos(x)]; % Rotate the vector with angle you want.
p_start= p_bar*Rota(theta_s)' + W(end,:);
p_end= p_bar*Rota(theta_e)' + W(end,:);

fp_start= map(p_start) - 24;
fp_end= map(p_end) - 24;

for i= N:-1:2
     tao= 2;
     p_left= W(i-1,:);
     p_right= W(i,:);
     
     V_start= fp_start - p_left;
     V_end= fp_end - p_right;
     V_n= (p_left-p_right)*Rota(pi/2)';

     if (dot(V_start,V_n)*dot(V_end,V_n) > 0)  % n the same side, continue.
         continue
     end

     % Use bisection.
     while 1
         theta_try= (theta_s+theta_e)/2;
         p_try= p_bar*Rota(theta_try)' + W(end,:);
         p_try(1)= round(p_try(1),3);   % The accuracy is limited by the acc. of the limit cycle.
         fp_try= map(p_try) - 24;
         V= fp_try - p_right;
         if((V_start*V_n')*(V*V_n')>0)
             theta_s= theta_try;
         else
             theta_e= theta_try;
         end
         
         if (V*V_n' < 1e-2) || (abs(theta_s-theta_e) < 1e-2)
             phik= fp_try;
             phik1= p_try; 
             tao= norm(fp_try-p_left)/norm(p_right-p_left);
             break
         end
     end
     
     if (tao>0) && (tao<1)
         phi_bar= W(end,:) + (W(end,:)-p_try)/norm(W(end,:)-W(end-1,:));
         alpha= norm(phi_bar-W(end-1,:))/norm(W(end,:)-W(end-1,:));
         dk= norm(W(end,:)-p_try);
         if (alpha<alpha_range) && (dk*alpha<dalpha_range)
            return  % Find the new point, free to go!
         end
     end

end

if isempty(phik) || isempty(phik1)
    phik1= p_bar + W(end,:);
    phik1(1)= round(phik1(1),3);
    phik= map(phik1) - 24;
end

end
