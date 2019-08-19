%==========This is greedy outlier removal experiment for a fixed subspace=================%
%==========It aims to remove 30% outliers, then save the data snapshot in .dat file=======%
%==========The .dat file will be received by AMPL to remove other remaining outliers using MILP=====%


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
               tic;
               k = KK;
               U = randn(d,r);                       % True Subspace
               theta_true = randn(r,1);              % True coefficients
               x_true = U*theta_true+sigma*randn(d,1);              % True vector x
               outliers = randperm(d,ceil(p*d));     % Set of all outliers indices.
               x = x_true;                           % Observed x, first true x is assigned to it
               x(outliers) = randn(size(outliers));  % Observed x, made some entries outliers
               reducedOutliers=zeros(d,1);
               kOutliers=zeros(d, 1);
               
               outliervec_original=zeros(d, 1);
               outliervec_original(outliers)=1;
            
               %=====Repeat this until reducedOutliers has 30% outliers removed=========%
            
               TN=0; FN=0;         % Initialization for True Positive and False Positive
               eInliers=(d-length(outliers));
               eOutliers=length(outliers);
               if(length(outliers)>k)   
                   while(true)
                       kOutliers = DynamicGreedyOutlierRemoval(U,x,k, d, reducedOutliers);
                       TN=TN+sum(kOutliers(outliers)==1);    %Count how many properly identified
                       FN=FN+k-sum(kOutliers(outliers)==1);  %Count how many falsely identified
                       reducedOutliers=reducedOutliers | kOutliers;  %Update indices in the result list
                       fprintf('Sigma=%f, p=%f, FN=%d, TN=%d, Total Outliers=%d\n', sigma, p, FN, TN, FN+TN);
                       eInliers=(d-length(outliers))-FN;      %Existing Inliers, because FP has been positively missclassified
                       eOutliers=length(outliers)-TN;         %Existing Outliers
                       if(TN+FN >= 0.5*length(outliers))
                          break;
                       end
                    
                   end
               end         
            
            %===================Write the snapshot in .dat file so that MILP can=============%
            %===================remove other outliers========================================%
            str=sprintf('./inputMILP/Noise/GreedyPlusMILP/Removed_50_Percent/reducedData_n_%d_p_%d_%d.dat', N, P, t);
            disp(str);
            new_d=d-sum(reducedOutliers);
            new_x=zeros(new_d, 1);
            new_x_true=zeros(new_d, 1);
            new_U=zeros(new_d, r);
            fid = fopen (str, 'w');
            outliervec=zeros(new_d,1);
            
            i=1;
            for dim=1:d
                if(reducedOutliers(dim)==0)
                    new_x(i)=x(dim);
                    new_x_true(i)=x_true(dim);
                    new_U(i, :)=U(dim, :);
                    for k=1:length(outliers)
                        if(dim == outliers(k))
                            outliervec(i)=1;
                            break;
                        end
                    end
                    i=i+1;
                end
            end
          fprintf(fid, "data;\n\n\n");
          fprintf(fid, "param FN:= %d;\n", FN);
          fprintf(fid, "param D:= %d;\n", d);
          
          fprintf(fid, "param U_Original:=\n");                                  %Storing U
          for i=1:r
              for dim=1:d
                  fprintf(fid, "%10d%10d%20e\n", dim, i, U(dim,i));     %Enter r values for each coordinate
              end
          end
          
          fprintf(fid, ";\nparam X_Original:=\n");                               %Store contaminated x
          for dim=1:d
              fprintf(fid, "%5d%20e\n", dim, x(dim));
          end
          fprintf(fid, ";\nparam outliervec_original :=\n");                      %Store outlier indices
          for dim=1:d
              fprintf(fid, "%5d%5d\n", dim, outliervec_original(dim));
          end
          
          fprintf(fid, ";\nparam d:= %d;\n", new_d);
          fprintf(fid, "param r:=%d;\n", r);
          fprintf(fid, "param p:=%f;\n", p);
          fprintf(fid, "param M:=%d;\n", 1000);
          fprintf(fid, "param U:=\n");                                  %Storing U
          for i=1:r
              for dim=1:new_d
                  fprintf(fid, "%10d%10d%20e\n", dim, i, new_U(dim,i));     %Enter r values for each coordinate
              end
          end
          
          fprintf(fid, ";\n\nparam theta:=\n");                         %Store parameter theta
          for i=1:r
              fprintf(fid, "%5d%20e\n", i, theta_true(i,1));
          end
          fprintf(fid, ";\nparam X_true:=\n");                          %Store contaminated x
          for dim=1:new_d
              fprintf(fid, "%5d%20e\n", dim, new_x_true(dim));
          end
          
          fprintf(fid, ";\nparam X:=\n");                               %Store contaminated x
          for dim=1:new_d
              fprintf(fid, "%5d%20e\n", dim, new_x(dim));
          end
          fprintf(fid, ";\nparam outliervec:=\n");                      %Store outlier indices
          for dim=1:new_d
              fprintf(fid, "%5d%5d\n", dim, outliervec(dim));
          end
          fprintf(fid, "; \nparam greedy_time := %20e\n", toc);
          fprintf(fid, ";");

           
        end
    end
end
    

    








