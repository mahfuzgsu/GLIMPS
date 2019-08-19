% str=sprintf('./outputGreedyOnly/1.dat');
% fid = fopen (str, 'w');
% fprintf(fid, "%5d\n", 2);
% 
% 
% for i=1:10
%    fprintf(fid, "%5d\n", i);
% end
%           


d = 100;             % Ambient Dimension
r = 5;               % Subspace Dimension
T = 50;              % Number of trials
PP =[.1:.1:.7, .72: .02: .9];  % Fractions of outliers --Length of this vector is 17
KK = 1;
NN=[0 1e-9, 1e-3, 1e-1]; %Noises 

clc;

for N=1:length(NN)
    sigma=NN(N);
    for P=1:length(PP)
        p = PP(P);
        
               
               
               fprintf('Sigma=%d, p=%f, ceil(p*d)=%d\n', sigma, p, ceil(p*d));

           
        
    end
end
    

    








