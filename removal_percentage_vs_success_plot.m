%Noise-Success Rate-Outliers Graph Generation Program% 
%=================Success will be plotted just based on varying OUTLIERS proportion============= 
%=================NOISE will also be varied========================================
%=================while keeping k, and suspace dimension r fixed================================

d = 100; %1000;    % Ambient Dimension
r=5; %20;      % Subspace Dimension
T = 50;    % Number of trials
PP =[.1:.1:.7, .72: .02: .9];  % Fractions of outliers --Length of this vector is 17
k=1; % 20;
NN=[0 1e-9, 1e-3, 1e-1]; %Noises 


%====================Evaluation of Several Algorithms =======================%
% 1) Greedy + MILP      2) Only MILP        3)Greedy Only       4)L1-Only       5)Greedy + L1

GLOS30=zeros(length(PP),length(NN));
GLOS40=zeros(length(PP),length(NN));
GLOS50=zeros(length(PP),length(NN));


for N=1:1 %length(NN)
    sigma=NN(N);
    for P=6:length(PP)
        p = PP(P); 
            
            A=zeros(T, 1);
            str1=sprintf('./outputMILP/EvalMetric_1/reducedData_n_%d_p_%d.out', N, P); 
            fid1 = fopen(str1, 'r');
            disp(fid1);
            A = fscanf(fid1,'%f');
            disp(mean(A));
            GLOS30(P, N)= 1- mean(A);
        
            B=zeros(T, 1);
            str2=sprintf('./outputMILP/GreedyPlusMILP/GreedyRemoved_40_Percent/Metric_1/data_n_%d_p_%d.out', N, P); 
            fid2 = fopen(str2, 'r');
            disp(fid2);
            B = fscanf(fid2,'%f');
            disp(mean(B));
            GLOS40(P, N)= mean(B);
            
            
            C=zeros(T, 1);
            str3=sprintf('./outputMILP/GreedyPlusMILP/GreedyRemoved_50_Percent/Metric_1/data_n_%d_p_%d.out', N, P); 
            fid3 = fopen(str3, 'r');
            disp(fid3);
            C = fscanf(fid3,'%f');
            disp(mean(C));
            GLOS50(P, N)= mean(C);
            
            
   end
end



%subplot (2,1,1);
plot(PP(6:17), GLOS30(6:17, 1), PP(6:17), GLOS40(6:17, 1), PP(6:17), GLOS50(6:17, 1),'LineWidth',3);
xlabel('Fraction of Outliers (P)');
ylabel('Error Rate');
title('Comparision of different first stage removal percentage : No Noise');
legend( 'First stage removal 30%', 'First stage removal 40%', 'First stage removal 50%','Location','northwest');

%subplot (2,1,2);
% plot(PP, OnlyMILPTime(:, 1), PP, GreedyTime(:, 1), PP, MILPTime(:, 1), 'LineWidth',2);
% xlabel('Fraction of Outliers (P)');
% ylabel('Computation Time');
% title('Comparision of MILP Only/Greedy Only: No Noise');
% legend( 'MILP', 'Greedy Only', 'Greedy + MILP','Location','east');


