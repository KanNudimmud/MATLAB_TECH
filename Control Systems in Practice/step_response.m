%% Step Response
s = tf('s');

G1 = 1 / (s+1); % low pass filter
G2 = 1 / (s+(s+1)); % integrating system (type 1)
G3 = s / (s+1); % high pass filter

%% Low Pass Filter
h = figure;
h.Position = [141 379 800 240];

step(G1)
set(findall(gcf,'type','line'),'Linewidth',4)

stepinfo(G1)

%% Type 1 System
step(G2)
set(findall(gcf,'type','line'),'Linewidth',4)

stepinfo(G2)

%% High Pass Filter
step(G3)

set(findall(gcf,'type','line'),'Linewidth',4)

stepinfo(G3)

%% end.