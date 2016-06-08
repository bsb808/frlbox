% Example script for making a call to lbl_ls_method()
%
% 02.06.05 bbing For Seabed LBL development
%

% LBL LS Algorithm Setup
% Beacons setup - each row is  a location in X, Y, Z (units)
beacons = [ 0 0 0
	10 0 0
	10 10 1
	-10 0 -1];

% make sure the initial guess is not at a beacon position
poseInitial = [2 3 20];


% Generate some data from a 'true' location
Pose_True = [0 0 10];

for ii = 1:size(beacons,1)
	ranges(ii) = norm(beacons(ii,:)-Pose_True);
end

% maybe add some noise?
rStdDev = 0;
ranges = ranges + randn(1,size(beacons,1))*rStdDev;

% Algorithm Call
[ePosition,Eresidual,Covx,iCount,debug] = lbl_ls_method(...
	ranges,beacons,poseInitial)


% Plotting Diagnostics
figure(1); clf;
plot(poseInitial(1),poseInitial(2),'g*');
hold on;
plot(ePosition(1),ePosition(2),'r+');
plot(Pose_True(1),Pose_True(2),'kx')
% error ellipse
[xx,yy,xxMaj,yyMaj,xxMin,yyMin] = err_ellipse(Covx(1:2,1:2),ePosition(1:2),25);
plot(xx,yy);
legend('poseInit','ePose','PoseTrue','Covx');


