clc
clear 
close all
%%
T = 24*3600; %[sec]
mu = 398600;
ecc = 1e-8;
n = 2*pi/T;
rp = 4.0127e4;
R0 = [0;100;0];

%% maneuver 1
%going from 100 to 40
%we go left 60
delYbar = -60;
[vy,~] = hop(n,-delYbar);
V0 = [0;vy;0];
initial = [R0;V0];
tspan = [0 T];
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[t,out1] = ode45(@Prop,tspan,initial,options,n) ;
%% manuever 3
%going from 40 to 1
%we go left 39 km
delYbar = -39;
[vy,~] = hop(n,-delYbar);
V0 = [0;vy;0];
R0 = out1(end,1:3)';
initial = [R0;V0];
[t,out3] = ode45(@Prop,tspan,initial,options,n) ;
%% manuever 4
%going from 1 to .3
delYbar = -.7;
[vy,~] = hop(n,-delYbar);
V0 = [0;vy;0];
R0 = out3(end,1:3)';
initial = [R0;V0];
[t,out4] = ode45(@Prop,tspan,initial,options,n) ;
%% manuever 5
%going from .3 to .02
delYbar = -.28;
[vy,~] = hop(n,-delYbar);
V0 = [0;vy;0];
R0 = out4(end,1:3)';
initial = [R0;V0];
[t,out5] = ode45(@Prop,tspan,initial,options,n) ;
%% LVLH plot
figure
% % plot(out1(:,2),out1(:,1))
% % hold on
% % plot(out3(:,2),out3(:,1))
% % plot(out4(:,2),out4(:,1))
plot(out5(:,2),out5(:,1))
hold on
%plot(out6(:,2),out6(:,1))

%% functions

function [out] = Prop(t,states,n)
x = states(1);
y = states(2);
z = states(3);

dx = states(4);
dy = states(5);
dz = states(6);

ddx = 3*n^2*x+2*n*dy;
ddy = -2*n*dx;
ddz = -n^2*dz;

out = [dx;dy;dz;ddx;ddy;ddz];
end

function [vy,h] = hop(n,dely)
vy = dely*n/6/pi;
h = 4*vy/n;
end