%==========This is greedy outlier removal experiment for a fixed=========%
%==========subspace, but variable outlier ratios, and for different k====%
%================It takes approximately one hour to run=================%

d = 100;    % Ambient Dimension
r = 5;      % Subspace Dimension
T = 50;    % Number of trials
PP = .1:.1:.9;  % Fractions of outliers
KK = [1,5:5:20];    % Parameter

Error = zeros(length(PP),length(KK),T);
FalseOutliers=zeros(length(PP), length(KK),T);
TrueOutliers=zeros(length(PP), length(KK),T);
ClassificationRatios=zeros(length(PP), length(KK),T);
EInliers=zeros(length(PP), length(KK),T);
EOutliers=zeros(length(PP), length(KK),T);
EEntries=zeros(length(PP), length(KK),T);
Time=zeros(length(PP), length(KK),T);
for t=1:T
    for P=1:length(PP)
        p = PP(P);
        for K=1:length(KK)
            tic;
            k = KK(K);
            U = randn(d,r);                     % True Subspace
            theta_true = randn(r,1);            % True coefficients
            x_true = U*theta_true;              % Uncontaminated x
            outliers = randperm(d,ceil(p*d));   % Set of all outliers.
            x = x_true;
            x(outliers) = randn(size(outliers));  % Contaminated x
            
            reducedOutliers=zeros(d,1);
            kOutliers=zeros(d, 1);
            %=====Repeat this until reducedOutliers has sufficient elemnts.
            TP=0; FP=0;      % Initialization for True Positive and False Positive Calculation 
            eInliers=(d-length(outliers));
            eOutliers=length(outliers);
            if(length(outliers)>k)   
                while(true)
                    kOutliers = DynamicGreedyOutlierRemoval(U,x,k, d, reducedOutliers);
                    % k = how many at a time we remove, e.g., 5 at a time
                    TP=TP+sum(kOutliers(outliers)==1); %Count how many properly identified
                    FP=FP+k-sum(kOutliers(outliers)==1);  %Count how many falsely identified
                    reducedOutliers=reducedOutliers | kOutliers;  %Update indices in the result list
                    fprintf('t=%d, p=%f, k=%d, True kOutliers=%d, Total Outliers=%d\n', t, p, k, sum(kOutliers(outliers)==1),sum(reducedOutliers));
                    eInliers=(d-length(outliers))-FP;      %Existing Inliers, because FP has been positively missclassified
                    eOutliers=length(outliers)-TP;         %Existing Outliers
                    if(eOutliers<k)
                        break;
                    elseif (p<=0.5)
                         break;
                    elseif (eOutliers<=eInliers)
                        break;
                    elseif (eInliers<=r)   %inliers
                        break;
%                     elseif(p>0.5 && d-sum(reducedOutliers)<=(d-length(outliers)))
%                         break;
                    end
                    
                end
            end 
            Time(P,K,t) = toc;
                
            %=====At the end, count fraction of inliers vs outliers in reducedOutliers.
            EInliers(P,K,t)=eInliers;
            EOutliers(P,K,t)=eOutliers; 
            EEntries(P,K,t)=d-sum(reducedOutliers);
            Error(P,K,t) = eInliers/eOutliers; % fraction of inliers vs outliers in reducedOutliers.
            FalseOutliers(P,K,t)=FP;
            TrueOutliers(P,K,t)=TP;
            ClassificationRatios(P, K, t)=TP/FP;
           % save('resultsSRMSD.mat');
        end
    end
    
end



MeanError = mean(Error,3);
clims=[0 1];
imagesc(MeanError, clims);
colormap('gray');
colorbar



