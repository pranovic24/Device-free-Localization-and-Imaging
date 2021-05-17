%	find coeffs of cylinder
%	dimensions are in wavelgths
%	object is vector = [radius nu]
%   location of point source vector = [r_s, phi_s]
%	mmax is maxnumber of modes
%
%	function b=cyl_point(object,source,mmax)
%
%
function b=cyl_point(object,source,mmax)

	m = 0:mmax;
	n = -mmax:-1;
	nm = -mmax:mmax;
	o = mmax+1;
    
    b = zeros(size(nm));

	ka = 2*pi*object(1);                             % (Ko)r , r is normalized by wavelength
	nu = object(2);
    
    kr_s = 2*pi*source(1);
    phi_s = source(2);

%
%       find bessel functions- first kind ka        (For scattered field outside object)
%
	jm = besselj(0:mmax+1,ka);  %%% nu is order, so we adding 0:102 orders for value of ka??
%
%       second kind ka                              (For scattered field outside object)
%
	ym = bessely(0:mmax+1,ka);
%
%       first kind ka*nu                            (For scattered field inside object)
%
	jmnu = besselj(0:mmax+1,ka*nu);
%
%       second kind ka*nu                           (For scattered field inside object)
%
	ymnu = bessely(0:mmax+1,ka*nu);
%
%       find bessel functions- first kind r_o       (For incident field from source: Green's function)
%
	jmrs = besselj(0:mmax,kr_s);
%
%       find bessel functions- second kind r_o      (For incident field from source: Green's function)
%
    ymrs = bessely(0:mmax,kr_s);    
%
%       calculate Hankel functions
%
	hm = jm -j*ym;                                 % (For scattered field outside object)
    hmrs = jmrs -j*ymrs;                           % (For incident field from source: Green's function)
%
%       calculate derivatives
%
      
	jdm = m /ka .* jm(m+1) - jm(m+2);              % Doubt?? m instead of m+1 for vectorization??
	jdmnu = m /ka/nu .* jmnu(m+1) - jmnu(m+2);     % Doubt?? ka*nu or ka/nu??
	hdm = m /ka .* hm(m+1) - hm(m+2);              % Doubt?? differentiation of bessel and hankel funct same??

%
%       calculate coefficients
%
% for m=0:mmax
% A(1,1) = jmnu(m+1);
% A(2,1) = -hm(m+1);
% b(1)= -1i/4*hm(m+1)*jmro*exp(-1i*m*phi_o);
% 
% A(2,1) = nu*jmdnu(m+1);
% A(2,2) = -hdm(m+1);
% b(1)= -1i/4*hdm(m+1)*jmro*exp(-1i*m*phi_o);
% x=A/b;
% Am(m+1)=x(1);
% Bm(m+1)=x(2);
% end
% 
% for m=-mmax:-1
% A(1,1) = jmnu(m+1);
% A(2,1) = -hm(m+1);
% b(1)= -1i/4*hm(m+1)*jmro*exp(-1i*m*phi_o);
% 
% A(2,1) = nu*jmdnu(m+1);
% A(2,2) = -hdm(m+1);
% b(1)= -1i/4*hdm(m+1)*jmro*exp(-1i*m*phi_o);
% x=A/b;
% Am(m+1)=x(1);
% Bm(m+1)=x(2);
% end

% e = (-1i).^m .* exp(-1i*m*phi_s);                %%%% Unused value of e????
e = -1i/4*hmrs(m+1) .* exp(-1i*m*phi_s);                %Power of source P
%e = e/(-1i/4)/exp(-1i*kr_s)/sqrt(2/(pi*kr_s)) /exp(1i*pi/4);
%e=exp(1i*m*pi/2) .* exp(-1i*m*phi_s);

b(o+m) = e.*jmnu(m+1).* jdm(m+1) - nu*e.* jm(m+1).* jdmnu(m+1);
b(o+m) = b(o+m)./(nu*hm(m+1).*jdmnu(m+1) - jmnu(m+1).*hdm(m+1));

% 
% f = (-1i).^n .* exp(-1i*n*phi_s);                %%%% Unused value of e????
f = -1i/4*hmrs(1-n).*(-1).^n .* exp(-1i*n*phi_s);   %%%% Power of source P, why -1^n??
%f = f/(-1i/4)/exp(-1i*kr_s)/sqrt(2/(pi*kr_s)) /exp(1i*pi/4);
%f=exp(1i*n*pi/2) .* exp(-1i*n*phi_s);

b(o+n) = f.*jmnu(1-n).*jdm(1-n)-nu*f.*jm(1-n).*jdmnu(1-n);
b(o+n) = b(o+n)./(nu*hm(1-n).*jdmnu(1-n)-jmnu(1-n).*hdm(1-n));
	

	
	if abs(b(1)) /abs(b(o)) > .001          %%%% How????
		error = 'error in b'
	elseif abs(b(2)) /abs(b(o)) > .001 
		error = 'error in b'
	elseif abs(b(3)) /abs(b(o)) > .001  
		error = 'error in b'
	end

%
%       verify forward scattering theorem
%
   
	check = sum( abs(b).^2 + real(j .^nm .*b .*exp(j*nm*phi_s)) );
	check = abs(check);

% 	if  check > 0.001  
% 		error = 'Difference in FST ='
% 		check
	end 



