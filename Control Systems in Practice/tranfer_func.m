%% Transfer Function Implementation
%% The s-domain Transfer Function
% Define transfer function G
s = tf('s');
G = (s + 2) / (s^2 + s + 2);

% Step Response
[x, t] = step(G);

plot(t,x,'LineWidth',2)
grid
legend('s-domain function')
hold all

%% Method 1: Numerically solve the differential equation
% Build time vector
dt = 0.01; % important parameter
t  = 0:dt:14;

% Build step input
u    = ones(size(t));
u(1) = 0;

% Initial conditions
y0  = 0;
yd0 = 0;
ud0 = 0;

% Predefine the size of the input/output vectors
ud  = zeros(size(t));
y   = zeros(size(t));
yd  = zeros(size(t));
ydd = zeros(size(t));

% Step through time and solve the differential equation
for i=1:length(t)
    if i==1
        ud(i) = ud0;
        yd(i) = yd0;
        y(i)  = y0;
        ydd(i)= ud(i) + 2*u(i) - yd(i) - 2*y(i);
    else
        ud(i) = (u(i) - u(i-1)) / dt; % ud=du/dt
        yd(i) = yd(i-1) + dt*ydd(i-1); % yd=int(ydd*dt)
        y(i)  = y(i-1) + dt*yd(i-1); % y=int(yd*dt)
        ydd(i)= ud(i) + 2*u(i) - yd(i) - 2*y(i); % diff equ.
    end
end

scatter(t,y,3);
legend('s-domain function','Differential equation approach')

%% Method 2: State-space model
% Build time vector
dt = 0.01; % important parameter
t  = 0:dt:14;

% Build step input
u    = ones(size(t));
u(1) = 0;

% State space model
A = [-1, -2; 1, 0];
B = [2; 0];
C = [0.5, 1];
D = 0;

% Initial conditions
x0  = [0; 0];
xd0 = [0; 0];

% Predefine the size of the state/output vectors
x  = zeros(2,length(t));
xd = zeros(2,length(t));
y  = zeros(size(t));

% Step through time and solve the model
for i=1:length(t)
    if i==1
        x(:,i)  = x0;
        xd(:,i) = A*x0 + B*u(i);
        y(i)    = C*x0 + D*u(i);
    else
        x(:,i)  = x(:,i-1) + dt*xd(:,i-1); % x=int(xd*dt)
        xd(:,i) = A*x(:,i) + B*u(i); % State equation
        y(i)    = C*x(:,i) + D*u(i); % Output equation
    end
end

scatter(t,y,3);
legend('s-domain function','Differential equation approach',...
    'State space approach')

%% Method 3: Z-domain
% Build time vector
dt = 0.01; % important parameter
t  = 0:dt:14;

% Build step input
u    = ones(size(t));
u(1) = 0;

% Initial variables
yk_1 = 0;
yk_2 = 0;
uk_1 = 0;
uk_2 = 0;

% Step through time and solve the difference equation
for i=1:length(t)
    if i==1
        uterms = 0.005025*u(i) + 9.95e-5*uk_1 - 0.004925*uk_2;
        yterms = 1.9899*yk_1 - 0.9901*yk_2;
        y(i)    = uterms + yterms;
    elseif i==2
        uterms = 0.005025*u(i) + 9.95e-5*u(i-1) - 0.004925*uk_1;
        yterms = 1.9899*y(i-1) - 0.9901*yk_1;
        y(i)    = uterms + yterms;
    else
        uterms = 0.005025*u(i) + 9.95e-5*u(i-1) - 0.004925*u(i-2);
        yterms = 1.9899*y(i-1) - 0.9901*y(i-2);
        y(i)    = uterms + yterms;
    end
end

scatter(t,y,3);
legend('s-domain function','Differential equation approach',...
    'State space approach','z-domain approach')

%% end.