% clear all

%%% Initialization
% cam=webcam('Logitech HD Webcam C270');
% robot = RobotRaconteur.Connect('tcp://localhost:10001/dobotRR/dobotController');

[fx] =  [ 1430.688616176092000 ]; % (focal length) * (the number of pixels per world unit)
[fy] =  [ 1425.219974303089900 ]; % (focal length) * (the number of pixels per world unit)
[cx] = [ 663.064313279749970  ]; % the optical center (the principal point)
[cy] = [ 362.320509108192820 ]; % the optical center (the principal point)
s = 0; % the skew parameter 
K = [fx 0 cx; 0 fy cy; 0 0 1];
R_CO = [0 1 0;  1 0 0;  0 0 -1];
P_CO = [0, 0, 815]'; 
z_CA = 815; %mm %%%
inv_K_R = inv(K*R_CO);
% tic
 while (1)
img = snapshot(cam);
% toc

%%% Locate the Duckie
% tic
[XCenter, XRadii, Xsub,OriDuck] = LocateDuckie_v2(img,2);
% XRadii;
Z = 820-820*39.7/XRadii;
% toc
% figure(1);
% imshow(img);
% h = viscircles(XCenter,XRadii);

%%% Transform the Location it in World Frame
P_OA = inv_K_R*(z_CA*[XCenter(1), XCenter(2), 1]'-K*P_CO);
CoX = [   -1.8182   0.0069      4.9584];
CoY = [    0.0744   -1.7816 -356.7428];
Pw(1) = CoX(1)*P_OA(1)+CoX(2)*P_OA(2)+CoX(3);
Pw(2) = CoY(1)*P_OA(1)+CoY(2)*P_OA(2)+CoY(3);
Pw
 end
%  
% %%% Commed the Arm
% [ Q , error ] = ikdobot( Pw(1),Pw(2), 65);
% Theta_Duck = acos(OriDuck(1,1)/sqrt(OriDuck(2,1)^2+OriDuck(1,1)^2));
% q4 = real(180*(Theta_Duck-pi/2)/pi-Q(1));
% Q = int16(real(Q));
% robot.setJointPositions(Q(1), Q(2), Q(3), int16(q4) , int16(0) );
% pause(1);
% robot.getJointPositions()
% 
% % end
