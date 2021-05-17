% 	Find the field along the y axis distance x away using coefficients b
%	All dimensions in wavelengths
%	mmax is dimension of calculated pattern
%	
%
%
%	function        f = xpattern(b,xl,ymax,mmax)
%
%
	function        [f h0kRso ft] = rpattern(b,source,xl,y,pmax, obj_cent)
	
	asize = pmax;
	bsize = length(b);
	mmax = floor(bsize/2);
	o = mmax+1;
	m = 0:mmax;
	n = -mmax:-1;
	nm = -mmax:mmax;
	p = 0:asize-1;
	hnm = zeros(asize,bsize);
	e  = meshgrid( (-1).^n,p);
	mb = meshgrid( b,p);                        % Repeat b (size=201) for pmax points/Rx (size =256)
    
    kr_s=2*pi*source(1);
    phi_s = source(2);

%
	phi_i = 0.0;

% 	y = p/(asize-1)*ymax;
	kR = 2*pi*sqrt((xl-obj_cent(1)).^2 + (y-obj_cent(2)).^2);
	phi_o = atan2(y-obj_cent(2),xl-obj_cent(1));                                        % Angles of Rx from origin and phi_i
    kRso = kr_s^2 + kR.*kR - 2 * kr_s * kR .* cos(phi_s-phi_o);            % ( k*|r-ro| )^2
    kRso = sqrt(kRso);
    
	[mnm mphi_o] = meshgrid(nm,phi_o);
    

    [xM,ykR] = meshgrid(m,kR);
%
%       first kind kR
%
	jm = besselj(xM,ykR);               %%%%% nu(rowwise) is order, so we adding 0:102 orders for one value of kR
%
%       second kind kR
%
	ym = bessely(xM,ykR);
%               
%       calculate Hankel functions
%    
	hnm(:,o+m) = jm - 1i*ym;
	hnm(:,o+n) = (jm(:,1-n) -1i*ym(:,1-n) ) .* e(:,o+n);
%
% caclulate Greens function
%
    j0kRso = besselj(0,kRso);                                           % Ho = sum(Hm)?
    y0kRso = bessely(0,kRso);
    h0kRso = j0kRso - 1i * y0kRso;

%       calculate field
% scatterd field
	f = sum( ( mb .*hnm .* exp(1i*mnm.*(mphi_o-phi_i)) ).' );% Sum 201 order bessel for each 256 points
%  add the incident field from Greens function
    ft = f  -1i/4 * h0kRso; 
