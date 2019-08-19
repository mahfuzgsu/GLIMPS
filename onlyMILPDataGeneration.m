%This code is written for only data generation for MILP
%NO GREEDY APPROACH APPLIED


% For Simplicity, ambient and subspace dimensions are kept fixed...

d = 100;             % Ambient Dimension
r = 5;               % Subspace Dimension
T = 50;              % Number of trials
PP =[.1:.1:.7, .72: .02: .9];  % Fractions of outliers --Length of this vector is 17
KK = 1;
NN=[0 1e-9, 1e-3, 1e-1]; %Noises 

for N=1:length(NN)
    sigma=NN(N);
    for P=1:length(PP)
        p = PP(P);
        for t=1:T
               k = KK;
               U = randn(d,r);                       % True Subspace
               theta_true = randn(r,1);              % True coefficients
               x_true = U*theta_true+sigma*randn(d,1);              % True vector x
               outliers = randperm(d,ceil(p*d));     % Set of all outliers indices.
               x = x_true;                           % Observed x, first true x is assigned to it
               x(outliers) = randn(size(outliers));  % Observed x, made some entries outliers
               outliervec=zeros(d, 1);
               outliervec(outliers)=1;
            
            %===================Write the snapshot in .dat file so that MILP can=============%
            %===================remove other outliers========================================%
            str=sprintf('./inputMILP/Noise/OnlyMILPData/data_n_%d_p_%d_%d.dat', N, P, t);
            disp(str);
           
            fid = fopen (str, 'w');
            fprintf(fid, "data;\n\n\n");
          
          
          fprintf(fid, "param d:= %d;\n", d);
          fprintf(fid, "param r:=%d;\n", r);
          fprintf(fid, "param p:=%f;\n", p);
          fprintf(fid, "param M:=%d;\n", 1000);
          fprintf(fid, "param U:=\n");                                  %Storing U
          for i=1:r
              for dim=1:d
                  fprintf(fid, "%10d%10d%20e\n", dim, i, U(dim,i));     %Enter r values for each coordinate
              end
          end
          
          fprintf(fid, ";\n\nparam theta:=\n");                         %Store parameter theta
          for i=1:r
              fprintf(fid, "%5d%20e\n", i, theta_true(i,1));
          end
          fprintf(fid, ";\nparam X_true:=\n");                          %Store contaminated x
          for dim=1:d
              fprintf(fid, "%5d%20e\n", dim, x_true(dim));
          end
          
          fprintf(fid, ";\nparam X:=\n");                               %Store contaminated x
          for dim=1:d
              fprintf(fid, "%5d%20e\n", dim, x(dim));
          end
          fprintf(fid, ";\nparam outliervec:=\n");                      %Store outlier indices
          for dim=1:d
              fprintf(fid, "%5d%5d\n", dim, outliervec(dim));
          end
          fprintf(fid, ";");

           
        end
    end
end
    

    








