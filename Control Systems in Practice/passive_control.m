%% Passivity-Based Control to Guarantee Stability
%% Beam model - First 2 modes -
z     = 0.05; % damping
alpha = [0.099 -0.31]; % gain
w     = [1 4]; % natural freq.

% Create transfer function
G2 = tf(alpha(1)^2 * [1 0], [1 2*z*w(1), w(1)^2]) + ...
    tf(alpha(2)^2 * [1 0], [1 2*z*w(2), w(2)^2]);

G2.InputName = 'uG'; G2.OutputName = 'y';

%% Solve for LQG Controller
% Convert to state-space form
[a,b,c,d] = ssdata(G2);

M = [c d; zeros(1,4) 1];
QWV = blkdiag(b*b', 1e-3);
QXU = M' * diag([1 1e-3]) * M;
CLQG = lqg(ss(G2),QXU,QWV);

%% Check Closed Loop System Performance
T_LQG = feedback(G2, CLQG, +1);

impulse(T_LQG, G2)
legend('LQG', 'Uncontrolled')

% Check stability marging 
diskmargin(G2*-CLQG)

%% 4-state LQG Controller with 6 mode Model
alpha = [0.099 -0.31 -0.89 0.59 0.7 -0.81]; % gain
w     = [1 4 9 16 25 36]; % natural freq.

% Create transfer function
G6 = tf(alpha(1)^2 * [1 0], [1 2*z*w(1), w(1)^2]) + ...
    tf(alpha(2)^2 * [1 0], [1 2*z*w(2), w(2)^2]) + ...
    tf(alpha(3)^2 * [1 0], [1 2*z*w(3), w(3)^2]) + ...
    tf(alpha(4)^2 * [1 0], [1 2*z*w(4), w(4)^2]) + ...
    tf(alpha(5)^2 * [1 0], [1 2*z*w(5), w(5)^2]) + ...
    tf(alpha(6)^2 * [1 0], [1 2*z*w(6), w(6)^2]);

G6.InputName = 'uG'; G2.OutputName = 'y';

%% Check System Performance
T_LQG = feedback(G6, CLQG, +1);

impulse(T_LQG, G6)
legend('LQG', 'Uncontrolled')

% Check stability marging 
diskmargin(G6*-CLQG)

%% Passive Beam Model
nyquist(G2,G6)

isPassive(G2)

isPassive(G6)

isPassive(-CLQG)

nyquist(-CLQG)

%% Design a Passive Controller
C = ltiblock.ss('C',4,1,1); % 4 state controller

C.InputName = 'yn'; C.OutputName = 'u';
S1 = sumblk('yn = y + n');
S2 = sumblk('uG = u + d');
CL0 = connect(G2,C,S1,S2,{'d','n'},{'y','u'},{'yn','u'});

% LQG Cost function tuning goal
R1 = TuningGoal.LQG({'d','n'},{'y','u'},diag([1,1e-3]),diag([1 1e-3]));

% Make controller passive
R2 = TuningGoal.WeightedPassivity({'yn'},{'u'},-1,1);
R2.Openings = 'u';

[CL1,J1,g] = systune(CL0,R1);

%% Compare the minimum cost for both controllers
% Passive controller
J1

% Optimal LQG controller
[~,Jopt] = evalGoal(R1,replaceBlock(CL0,'C',CLQG))

%% Compare impulse responses
CPassive = getBlockValue(CL1,'C');

impulse(feedback(G6,CLQG,+1))
hold on
impulse(feedback(G6,CPassive,+1))

%% Compare Nyquist Plots
figure
nyquist(-CPassive, -CLQG)

%% end.