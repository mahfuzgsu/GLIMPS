%==========This is greedy only outlier removal experiment for a fixed subspace=================%
%==========We used two evaluation techniques===========%
%==========1) norm(theta_true - theta_hat)/(norm(theta_true)+norm(theta_hat)), 2) (FP+FN)/No. of inliers




% For Simplicity, ambient and subspace dimensions are kept fixed...

d = 100;             % Ambient Dimension
r = 5;               % Subspace Dimension
T = 50;              % Number of trials
PP =[.1:.1:.7, .72: .02: .9];  % Fractions of outliers --Length of this vector is 17
KK = 1;
NN=[0 1e-9, 1e-3, 1e-1]; %Noises 

for N=1:1 %length(NN)
    sigma=NN(N);
  %  for P=1:length(PP)
        p = 0.9;
       
        for t=1:1
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
               
            
               %=====Repeat this until projection onto the existing coordinates perfectly match=========%
            
               TN=0; FN=0;         % Initialization for True Positive and False Positive
               normratio=0;
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
                      
                       %Check whether to stop greedy removal or not........
                       
                       removed=find(reducedOutliers);
                      
                        TU=U;                        %Temporary Copy of Subspace basis
                        Tx=x;                        %Temporary Copy of x              
                        TU(removed,:)=0;             %Projection onto the rest of the coordinates except already found as outliers
                        Tx(removed)=0;               %Projection onto the rest of the coordinates except already found as outliers
                        PU=TU*((TU'*TU)\TU');        %Calculate projection operator onto suspace
                        UTx=PU*Tx;                   %Projection of x onto the projected subspace 
                        normratio=norm(UTx)/norm(Tx);   %Find the ratio of norms
                        if(normratio>=.999999 || eInliers == r)
                            theta_hat=(TU'*TU)\TU'*Tx;
                            disp(theta_true);
                            disp(theta_hat);
                            break;
                        end             
                       
                   end %while loop
               end  %end if
              
            
           
        end
        
    %end
end
    

    








