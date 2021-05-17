

function [pat, patt, h0kRso, pn] = fieldxx(obj_cent, Source_loc, radius, Rx_loc, nu, mmax)

%%
% obj_cent = [0 0];
% Location of 1-D line on which total field needs to be estimated 
% xl=100;
% ymax = 200;
% 
% % Number of points on 1D line where total field needs to be estimated
% % pmax = 256;
% % y = linspace(0,ymax,pmax);
% xl = repmat(100, [1,256]);%[50 100 100 100 100];
% y = linspace(0,ymax,256);%[100 0 50 100 200];
xl = Rx_loc(:,1)';
y = Rx_loc(:,2)';

pmax = length(y);
%%
% Object
% radius in wavelengths
% radius = 5;
% nu = 1.5;             % Any range?
% phi_obj = atan2(obj_cent(2),obj_cent(1));
% r_obj
object = [radius, nu];

% Source
% radius in wavelngths
% phi in radians
% Source_loc = [-50 0]; % location of point source in 2D plane
r_s = norm(Source_loc - obj_cent);
phi_s = atan2(Source_loc(2)-obj_cent(2),Source_loc(1)-obj_cent(1));
source=[r_s, phi_s];

% Number of modes to be summed for approximation 
% mmax =100;


% Coefficients of scattered field on 1D line due to object
bm = cyl_point(object,source,mmax);




%field = pattern(bm);

[pat h0kRso patt]= rpattern(bm,source,xl,y,pmax, obj_cent);
pn=abs(max(patt));
ph0n = abs(max(1i/4*h0kRso));



% figure(2)
% xlr = repmat(xl, [1, length(y)]);
% stem(obj_cent(1),obj_cent(2), '*', 'LineStyle','none'); hold on;
% stem(Source_loc(1),Source_loc(2), '*', 'LineStyle','none');
% stem(xlr, [y], '.'); 
% cylx = [-radius+obj_cent(1):0.5:radius+obj_cent(1)];
% stem(cylx , sqrt(radius^2 - (cylx-obj_cent(1)).^2) + obj_cent(2),'k.','LineStyle','none'); 
% stem(cylx , -sqrt(radius^2 - (cylx-obj_cent(1)).^2) + obj_cent(2),'k.','LineStyle','none');
% pbaspect('auto')

% hold off;