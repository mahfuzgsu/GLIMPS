%==========This is greedy outlier removal experiment for a fixed subspace=================%
%==========It aims to remove 30% outliers, then save the data snapshot in .dat file=======%
%==========The .dat file will be received by AMPL and remove other remaining outliers using MILP=====%


% For Simplicity, ambient and subspace dimensions are kept fixed...

d = 100;             % Ambient Dimension
r = 5;               % Subspace Dimension
T = 30;            % Number of trials
PP = .85; %.1:.1:.9;  % Fractions of outliers
KK = 1; %[1,5:5:20]; % We remove k items at a time using greedy removal


for t=1:T
    for P=1:length(PP)
        p = PP(P);
        for K=1:length(KK)
            k = KK(K);
            U = randn(d,r);                       % True Subspace
            theta_true = randn(r,1);              % True coefficients
            x_true = U*theta_true;                % True vector x
            outliers = randperm(d,ceil(p*d));     % Set of all outliers indices.
            x = x_true;                           % Observed x, first true x is assigned to it
            x(outliers) = randn(size(outliers));  % Observed x, made some entries outliers
            
            reducedOutliers=zeros(d,1);
            kOutliers=zeros(d, 1);
            
            %=====Repeat this until reducedOutliers has 30% outliers removed=========%
            
            TP=0; FP=0;         % Initialization for True Positive and False Positive
            eInliers=(d-length(outliers));
            eOutliers=length(outliers);
            if(length(outliers)>k)   
                while(true)
                    kOutliers = DynamicGreedyOutlierRemoval(U,x,k, d, reducedOutliers);
                    TP=TP+sum(kOutliers(outliers)==1);    %Count how many properly identified
                    FP=FP+k-sum(kOutliers(outliers)==1);  %Count how many falsely identified
                    reducedOutliers=reducedOutliers | kOutliers;  %Update indices in the result list
                    fprintf('p=%f, k=%d, True kOutliers=%d, Total Outliers=%d\n', p, k, sum(kOutliers(outliers)==1),sum(reducedOutliers));
                    eInliers=(d-length(outliers))-FP;      %Existing Inliers, because FP has been positively missclassified
                    eOutliers=length(outliers)-TP;         %Existing Outliers
                    if(TP+FP >= 0.3*length(outliers))
                        break;
                    end
                    
                end
            end 
            
                
            
        end
    end
    
%===================Write the snapshot in .dat file so that MILP can=============%
%===================remove other outliers========================================%
str=sprintf('./inputMILP/reducedData_%d.dat', t);
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
          fprintf(fid, "param d:= %d;\n", new_d);
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
          fprintf(fid, ";");
end
    








