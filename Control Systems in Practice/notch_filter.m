%% Notch Filter
%% Adding Low-Pass to High-Pass
% Define the Laplace variable, s
s = tf('s')

% Low pass filter with cutoff at 1rad/s
LP = 1/(s+1);

% High pass filter with cutoff at 100rad/s
HP = s/(s+100);

G = LP+HP

% Frequency response of G
bode(G)

% Low pass filter with cutoff at 5rad/s
LP = 5/(s+5);

% High pass filter with cutoff at 20rad/s
HP = s/(s+20);

H = LP+HP

% Freqeuncy response of H on G to compare
hold on, bode(H)
% Comment : So adding low pass and high pass filter is not a good idea for
% narrow band filters.

%% Let's look at standart 2nd order low pass filter
% Define the Laplace variable, s
s = tf('s');
Wn = 10; % natural frequency
zeta = 1; % damping ratio

G = Wn^2 / (s^2 + 2*zeta*Wn*s + Wn^2)

% Plot poles and zeros
clf
pzmap(G)
hold all
grid on

% Plot frequency response
figure
bode(G)
hold all
grid on

% Lower damping ratio to 0.5
zeta = 0.5;
G = Wn^2 / (s^2 + 2*zeta*Wn*s + Wn^2)

% Plot poles and zeros
pzmap(G)

% Plot frequency response
bode(G)

% Lower damping ratio to 0.1
zeta = 0.1;
G = Wn^2 / (s^2 + 2*zeta*Wn*s + Wn^2)

% Plot poles and zeros
pzmap(G)

% Plot frequency response
bode(G)

% Remove damping
zeta = 0;
G = Wn^2 / (s^2 + 2*zeta*Wn*s + Wn^2)

% Plot poles and zeros
pzmap(G)

% Plot frequency response
bode(G)

% Comment: No-damping scenarios are not preferrable for real systems.

% Flip the transfer function 
H = (s^2+100)/100

% Plotting
pzmap(H)
bode(H)

% Comment: Adding these two smiliar to notch filter but transfer function
% (H) is not realizable because numerator is greater than denominator.

% Adding two poles fixes the problem (poles should be complementary)
controlSystemDesigner(H)

% Ratio away from natural frequency
a     = 2;
zeta  = 0.05;
notch = (s^2 + 2*zeta*Wn*s + Wn^2) / Wn

% Add first pole
notch = notch * (a*Wn) / (s + a*Wn)

% Add second pole
notch = notch * (Wn/a) / (s + Wn/a)

% Plot the frequecny response
close all
bode(notch)

% A good example:
% https://www.mathworks.com/help/slcontrol/ug/tuning-of-a-digital-motion-control-system.html?s_eid=PSM_15028

%% end.