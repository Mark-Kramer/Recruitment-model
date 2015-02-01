%% Simulate RS cell in a 2-dim grid.

clear
close all

%L=2704; LL=52;
%L=729; LL=27;           %L is the total # of neurons.
L=144; LL=12;
                        %LL is the size of a side of the 2-dim grid.
                        %... with LL=27, and L=27^2=729, we'll eventually
                        %create a 25-by-25 grid, and drop the outer
                        %boundary.

T = 5000;               %Total # of steps to take.

rs0.C = 1.0;            %HH model cell parameters.
rs0.gL  = 0.5;
rs0.gNaF = 150;
rs0.gKDR = 300;
rs0.gNaP = 0;
rs0.gKM  = 0;
rs0.gKNa = 0;
rs0.sigma = 2;
rs0.I0 = 1.5+zeros(1,L);    %No drive to other cells...
%rs0.I0(57) = -5;        %... excite one cell at upper left corner of grid.
rs0.I0(107) = -5;

syn0.taudEE=1.0;       %Synapse parameters.
syn0.taurEE=0.5;

%Synaptic connections
p=0.0; [CEE, RCposition] = make_nn_network_full_square_small_world(L,LL,p);
CEE=CEE*1/8;                %Scale the connections so that total input from all nbrs is 1.
for k=1:L
    CEE(k,k)=0;             %No autapses.
end
C0.EtoE=CEE;

ic = 0;                 %No initial conditions to start.

%% Initial runs with synapses OFF.
%  This washes out the initial conditions.

syn0.gee=0;             %Synapses OFF.

for nsim=1:2            %Run a couple of times to initialize ...
    fprintf(['Initialize run ' num2str(nsim) '... \n'])
    [V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
end
fprintf('Initialization finished. \n')
imagesc(V, [-80 20]);
save('ic.mat', 'ic');   %Save the last step as the initial conditions, ar

%% Turn on neighbor-to-neighbor synaptic connectivity.

syn0.gee=3;         %Turn on E-to-E synapses
load('ic.mat')      %Load the initial conditions from burn in.

figure
set(gcf, 'Position', [0, 800, 1000, 300])
set(gca,'LooseInset',get(gca,'TightInset'))

% Run it ...
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
counter=1;
for i=1:1000:T
    subplot(4,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(t(i),2))
end
tend = t(end);
group_size=5;   %Average the synaptic activity over [5x5] subgrids.
LFP = approximate_LFP(LL,synaptic,group_size);

% continue the run ...
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
for i=1:1000:T
    subplot(4,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(tend+t(i),2))
end
LFP =cat(1,LFP,approximate_LFP(LL,synaptic,group_size));

% continue the run ...
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
for i=1:1000:T
    subplot(4,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(tend+t(i),2))
end
LFP =cat(1,LFP,approximate_LFP(LL,synaptic,group_size));

% continue the run ...
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
for i=1:1000:T
    subplot(4,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(tend+t(i),2))
end
LFP =cat(1,LFP,approximate_LFP(LL,synaptic,group_size));

figure
dt = t(2)-t(1);
plot((LFP)
xlabel('Indices')
ylabel('LFP')
title('Neighbor-to-neighbor connectivity')

%%  Make connectivity small world.

p=0.1; [CEE, RCposition] = make_nn_network_full_square_small_world(L,LL,p);
CEE=CEE*1/8;                %Make long dist connections weaker.
for k=1:L
    CEE(k,k)=0;             %Make on module connections stronger.
end
C0.EtoE=CEE;

syn0.gee=1.75;              %Turn on E-to-E synapses.  NOTE - made this smaller.
load('ic.mat')              %Load the initial conditions from burn in.

figure
set(gcf, 'Position', [0, 800, 1000, 300])
set(gca,'LooseInset',get(gca,'TightInset'))

% Run it.
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
counter=1;
for i=1:1000:T
    subplot(2,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(t(i),2))
end
tend = t(end);
LFP = approximate_LFP(LL,synaptic,group_size);

% continue the run ...
[V,t,ic,current,synaptic] = simple_rs_2d(T,L,ic,  rs0,syn0,C0,RCposition);
% and plot it ...
for i=1:1000:T
    subplot(2,5,counter); counter=counter+1;
    map = reshape(squeeze(V(i,:)), [LL,LL]);
    map = map(2:LL-1, 2:LL-1);
    imagesc(map, [-80, 40])
    title(num2str(tend+t(i),2))
end
LFP =cat(1,LFP,approximate_LFP(LL,synaptic,group_size));

figure
dt = t(2)-t(1);
plot(LFP)
xlabel('Indices')
ylabel('LFP')
title('Small-world connectivity')

%% Make a movie (not really needed).

i0=1;
Lside = sqrt(size(V,2));
for i=i0:100:size(V,1)
    map = reshape(squeeze(V(i,:)), [Lside,Lside]);
    map = map(2:Lside-1, 2:Lside-1);
    imagesc(map, [-80, 40])
    title(num2str(t(i)))
    pause(0.1)
    %keyboard
end
