%% Non-Minimum Phase Systems
% There is no maximum phase system because, we can delay as much as we
% want.
%% Create Non-minimum Phase Systems
% Create a system
G = tf([1 2], [1 3 1])
bode(G)
% Comment: We can create same magnitude plot for many transfer function but
% phase shift will be always different.

hold all
% First way with delay
G_delay = tf([1 2],[1 3 1],'InputDelay',1)
bode(G_delay)

% Second way with right half plane zeros
G_RHP_zero = tf([-1 2],[1 3 1])
bode(G_RHP_zero)

%% Step Responses
figure
step(G, G_delay, G_RHP_zero)
% Comment: As seen RHP_zero response goes down firstly and it is seen real
% systems.
% Example: https://www.mathworks.com/help/slcontrol/ug/control-of-an-inverted-pendulum-on-a-cart.html?s_eid=PSM_15028
% But RHP zeros systems are hard to control, the easiest method to
% stabilize is lowering the controller gain.

%% end.