%Noise-Success Rate-Outliers Graph Generation Program% 
%=================Success will be plotted just based on varying OUTLIERS proportion============= 
%=================NOISE will also be varied========================================
%=================while keeping k, and suspace dimension r fixed================================

clc;
d = 100; %1000;    % Ambient Dimension
r=5; %20;      % Subspace Dimension
T = 50;    % Number of trials
PP =[.1:.1:.7, .72: .02: .9];  % Fractions of outliers --Length of this vector is 17
k=1; % 20;
NN=[0 1e-9, 1e-3, 1e-1]; %Noises 


%====================Evaluation of Several Algorithms =======================%
% 1) Greedy + MILP      2) Only MILP        3)Greedy Only       4)L1-Only       5)Greedy + L1

MILPErrorRate=zeros(length(PP),length(NN));
OnlyMILPErrRate=zeros(length(PP),length(NN));
GreedyErrRate=zeros(length(PP),length(NN));
L1OnlyErrRate=zeros(length(PP), length(NN));

MILPTime=zeros(length(PP),length(NN));
OnlyMILPTime=zeros(length(PP),length(NN));
GreedyTime=zeros(length(PP),length(NN));
L1OnlyTime=zeros(length(PP), length(NN));


MILP30=zeros(length(PP),length(NN));
MILP40=zeros(length(PP),length(NN));
MILP50=zeros(length(PP),length(NN));

for N=1:1 %length(NN)
    sigma=NN(N);
    for P=1:length(PP)
        p = PP(P); 
            A=zeros(T, 1);
            B=zeros(T, 1);
            C = zeros(T, 1);
            str1=sprintf('./outputMILP/EvalMetric_1/reducedData_n_%d_p_%d.out', N, P); 
            fid1 = fopen(str1, 'r');
            disp(fid1);
            A = fscanf(fid1,'%f');
            disp(mean(A));
            MILP30(P, N) = 1 - mean(A);
            
            str2=sprintf('./outputMILP/GreedyPlusMILP/GreedyRemoved_40_Percent/Metric_1/data_n_%d_p_%d.out', N, P); 
            fid2 = fopen(str2, 'r');
            disp(fid2);
            B = fscanf(fid2,'%f');
            disp(mean(B));
            MILP40(P, N) = mean(B);
            
            str3=sprintf('./outputMILP/GreedyPlusMILP/GreedyRemoved_50_Percent/Metric_1/data_n_%d_p_%d.out', N, P); 
            fid3 = fopen(str3, 'r');
            disp(fid3);
            C = fscanf(fid3,'%f');
            disp(mean(C));
            MILP50(P, N) = mean(C);
            
           % MILPErrorRate(P, N)= mean(A);
            
%             str4=sprintf('../../julia/L1-minimization/L1_Output/result_n_%d_p_%d.out', N, P); 
%             disp(str4);
% %             fid4 = fopen (str4, 'r');
% %             disp(fid4);
% %             D= fscanf(fid4,'%f');
% %             disp(mean(D));
% %             L1OnlyErrRate(P, N)=mean(D);
%             
%            
%             str3=sprintf('./outputGreedyOnly/Time/data_n_%d_p_%d.out', N, P); 
%             disp(str3);
%             fid3 = fopen (str3, 'r');
%             disp(fid3);
%             C= fscanf(fid3,'%f');
%             disp(mean(C));
%             GreedyErrRate(P, N)=mean(C);
%             
%             str6=sprintf('./outputMILP/OnlyMILP/Time/data_n_%d_p_%d.out', N, P); 
%             fid6 = fopen (str6, 'r');
%             disp(fid6);
%             F= fscanf(fid6,'%f');
%             disp(mean(F));
%             OnlyMILPErrRate(P, N)=mean(F);
%             
%             tstr1=sprintf('./outputGreedyOnly/Time/data_n_%d_p_%d.out', N, P); 
%             disp(tstr1);
%             tfid1 = fopen (tstr1, 'r');   %Time folder id
%             disp(tfid1);
%             T1= fscanf(tfid1,'%f');
%             disp(mean(T1));
%             GreedyTime(P, N)=mean(T1);  
%             
%             tstr2=sprintf('./outputMILP/OnlyMILP/Time/data_n_%d_p_%d.out', N, P); 
%             disp(tstr2);
%             tfid2 = fopen (tstr2, 'r');   %Time folder id
%             disp(tfid2);
%             T2= fscanf(tfid2,'%f');
%             disp(mean(T2));
%             OnlyMILPTime(P, N)=mean(T2); 
%             
%             tstr3=sprintf('./outputMILP/GreedyPlusMILP/GreedyRemoved_40_Percent/Time/data_n_%d_p_%d.out', N, P); 
%             disp(tstr3);
%             tfid3 = fopen (tstr3, 'r');   %Time folder id
%             disp(tfid3);
%             T3= fscanf(tfid3,'%f');
%             disp(mean(T3));
%             MILPTime(P, N)=mean(T3); 
   end
end


% subplot (1,1,1);
% plot(PP, MILPErrorRate(:,3),'LineWidth',2);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('Greedy + MILP : No Noise');

% subplot (1,2,2);
% plot(PP, MILPErrorRate(:,2),'LineWidth',2);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('Greedy + MILP : Low Noise');

subplot (1,1,1);
plot(PP, MILP30(:, 1), PP, MILP40(:, 1), PP, MILP50(:, 1), 'LineWidth',3);
xlabel('Fraction of Outliers (P)');
ylabel('Error Rate');
title('Effect of removal percentage at the greedy stage');
legend( '30%', '40%', '50%','Location','northwest');

% subplot (1,1,1);
% plot(PP, OnlyMILPErrRate(:, 1), PP, GreedyErrRate(:, 1), PP, MILPErrorRate(:, 1), 'LineWidth',3);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('Comparision of MILP Only/Greedy Only/Greedy + MILP: No Noise');
% legend( 'MILP', 'Greedy Only', 'Greedy + MILP','Location','northwest');

% subplot (1,1,1);
% plot(PP, OnlyMILPTime(:, 1), PP, GreedyTime(:, 1), PP, MILPTime(:, 1), 'LineWidth',2);
% xlabel('Fraction of Outliers (P)');
% ylabel('Computation Time');
% title('Comparision of MILP Only/Greedy Only/Greedy+MILP: No Noise');
% legend( 'MILP', 'Greedy Only', 'Greedy + MILP','Location','east');
% 
% subplot(1,3,1);
% plot(PP, MILPErrorRate(:,2), PP, MILPErrorRate(:,1), 'LineWidth',3);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('GLIMPS: Low Noise');
% legend('With Noise', 'Without Noise','Location','northwest');
% 
% subplot(1,3,2);
% plot(PP, MILPErrorRate(:,3), PP, MILPErrorRate(:,1), 'LineWidth',3);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('GLIMPS: Medium Noise');
% legend('With Noise', 'Without Noise','Location','northwest');
% 
% subplot(1,3,3);
% plot(PP, MILPErrorRate(:,4), PP, MILPErrorRate(:,1),'LineWidth',3);
% xlabel('Fraction of Outliers (P)');
% ylabel('Error Rate');
% title('GLIMPS: High Noise');
% legend('With Noise', 'Without Noise','Location','northwest');


