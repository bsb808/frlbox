function [ePosition,Eresidual,Covx,iCount,debug] = lbl_ls_method(...
	ranges,beacons,poseInitial,Method,MaxI,EslopeT,debugFlag)

% Least Squares solution for spherical positioning
% uses Marquadt ('marq') or Newton ('newt') as specified by the 
% Method input (default: 'marq')
%
% Using the Marquardt (Levenberg-Marquardt) Method for solving 
% the least squares spherical localization problem. (see numerical recipies)
% This algorithm mixes newton's method and steepest decent
%
% The structure is taken from earlier implementations, but hopefully it is 
% cleaned up and some debugging stuff is added in to test things out.
%
% INPUT
% * ranges - vector of N ranges
% * beacons - matrix of Nx(2 or 3) containing beacon locatoins (x,y,and maybe z)
% * poseInitial - initial guess
% * Method (opt.) - string: either 'marq' or 'newt' - default = 'marq'
% * MaxI (opt.) - scalar max. number of interations - default = 25
% * EslopeT (opt.) - fractional change in chisquared error metric to determine convergence. default = 0.01
% * debugFlag (opt.) - defaults to 0.  value of 1 turns debugging on, does
% some reporting, and saves a history of the interations.
%
% OUTPUT
% Everything is set to -1 if the inversions are poorly conditioned.
% * ePosition - estimated position (length 2 or three depending on thedegrees of freedom)
% * Eresidual - residual RMS error.
% * Covx - estimated covariance of the estimate.
% * iCount - number of interations required for convergence.
% * debug - structure containing a history of the interation solutions.
%
%
% HISTORY
% bbing 18.09.02 Created
% bbing 27.06.04 Working on McDuff04 - added comments 
% bbing 15.11.04 Making things a little more robust - rejecting fixes when the geometry is very bad, etc.
% bbing 03.06.06 Cleaning up and documenting for J.Howland

% NARGIN Stuff - take care of arguments not specified
if nargin < 3
    poseInitial = [0 0 0]; 
end
if nargin < 4
	Method = 'marq';
end
if nargin < 5
	MaxI = 50;
end
if nargin < 6
    EslopeT = 0.01;  % fractional change in chisquared error metric
end
if nargin < 7
	debugFlag = 0;
end

% Determine the method
if strcmp(Method,'marq')
	marq = 1;
	newt = 0;
elseif strcmp(Method,'newt')
	marq = 0;
	newt = 1;
else
	disp('Error: method is not recognized!')
	return;
end


% Validate some of the inputs
N = size(beacons,1);
T = length(ranges);
if (N~=T)
    disp('WARNING: lbl_ls.m - number of ranges and number of beacons doesn''t match');
    return;
end
if (N < 3)
    %disp('Warning - less than 3 beacons!');
end

% Least Squares
% We assume that all the ranges have the same variance so we can drop 
% that from the linearization

% Initialization
iCount = 1;
EslopeNew = 1;
keepgoing = 1;
xI = poseInitial(:)';
% Pick modest lam
lam = 0.001;
% calculate the error residuals initially
for ii = 1:N
	dist(ii) = norm(beacons(ii,:)-xI);  % estimated range
	ErrorD(ii) = ranges(ii)-dist(ii);   % error between estimated and measured
end
Eold = norm(ErrorD)^2;  % squared sum of residuals in range approx.
	
% debugging
if (debugFlag)
	EEslope(1) = EslopeNew;
	EE(1) = Eold;
	XX(1,:) = xI;
end

% Iterative Numerical Loop
while ( keepgoing & (iCount<MaxI))
    % Linearize
    % make a matrix where each row is the initial position
    initMat = ones(size(beacons,1),1)*xI;
    predR = sqrt(sum(((initMat-beacons).^2)'));
    
    % Linear measurement equations (Ax=b)
    % check for divide by zero
    if (any(predR==0))
        fprintf('LBL_LS: Error - predicted range is zero!  Divide by zero error.\n')
        ePosition = -1; Eresidual = -1; Covx = -1; iCount = -1; debug = -1;
        return;
    end
    A = (initMat-beacons)./(predR'*ones(1,length(xI)));
    b = ranges-predR;
    
% Below is equivalent to the above block, but above is vectorized!
%     % make sure the original guess is not at a beacon position
% 	for ii = 1:N
%         xB = beacons(ii,:); 
%         ri = ranges(ii);
%         ro = sqrt(sum((xI-xB).^2));
% 		
%         A(ii,:) = (xI-xB)/ro;
%         b(ii) = ri-ro;
% 	end
	
	alpha = A'*A;
	if marq
		% Marquardt Method - adjust A (alpha)
		for ii = 1:size(alpha,1)
			alpha(ii,ii) = alpha(ii,ii) * (1+lam);
		end
	end
	
	% solve the linear equations for the increment
	if (rank(alpha) < size(A,2))
	  fprintf('LBL_LS: Poorly conditioned system matrix\n');
      ePosition = -1; Eresidual = -1; Covx = -1; iCount = -1; debug = -1;
	  return;
	end
	
	Covx = inv(alpha);
	dX = Covx*(A'*b(:));
	xNew = xI+dX';
  
	% Calculate chi-squared (without variances) for xNew
	for ii = 1:N
        dist = norm(beacons(ii,:)-xNew);  % estimated range
        ErrorD(ii) = ranges(ii)-dist;   % error between estimated and measured
    end
    Elam = norm(ErrorD)^2;  % squared-sum of range residuals
	
	% here is the crux of the marq. method
	% if the error increased we increase lam which 
	% moves us towards a steepest decent iteration
	% and throw away the last iteration
	% if the error decreased we continue with the newton's method
	if marq
		if Elam >= Eold
			lam = lam*10;  
		else
			lam = lam/10;
			xI = xNew;
		end
	elseif newt
		lam = 0;
		xI = xNew;
	end
	
	% Convergence Test
    % Error metrics
	% Calculate the squared-sum of range residuals
	% we could normalize this by the variances in the ranges
	% assuming they are all the SAME
    
	Enew = Elam;  % squared-sum of range residuals
    
	% Also calculate the normalized slope of this metric
	% we can set a criteria by setting a tolerence on this 
	% change in the error - say 0.01.
	% make sure that the error is decreasing - Eslope is positive
	EslopeOld = EslopeNew;
    % avoid divide by zero
	if Enew > 1e-12
		EslopeNew = (Eold-Enew)/Enew;
	else
		EslopeNew = (Eold-Enew)/1e-12;
	end
	
	% We can make this more robust by making sure that 
	% the error change has been positive and small twice
	if ((EslopeOld < EslopeT) & ...
			(EslopeOld > 0) & ...
			(EslopeNew < EslopeT) & ...
			(EslopeNew > 0))
    elseif (EslopeNew < EslopeT/10 || EslopeOld < EslopeT/10)
		keepgoing = 0;
	else
		keepgoing = 1;
	end
	
	% Iterate
	Eold = Enew;
    iCount = iCount+1;
	
	% debugging
	if debugFlag
		EE(iCount) = Enew;
		EEslope(iCount) = EslopeNew;
		XX(iCount,:) = xI(:)';
		Lam(iCount)=lam;
	end

end

% Here we have either converged or exceeded the max number of iterations
% if iCount >= MaxI
%     disp('Warning - lbl_iterative exceeded max. iteration count')
% end

% Outputs
% [ePosition,Eresidual,Covx,iCount,debug]
ePosition = xI;
Eresidual = sqrt(Enew);
% 
if (rank(A'*A) < size(A,2))
  fprintf('LBL_LS: Poorly conditioned system matrix\n');
  ePosition = -1; Eresidual = -1; Covx = -1; iCount = -1; debug = -1;
  return;
end

Covx  = inv(A'*A);

if (debugFlag)
	debug.Eresiduals = EE;
	debug.Eslopes = EEslope;
	debug.X = XX;
	debug.Lam = Lam;
	debug.Method = Method;
else
	debug = [];
end

return;