function  kOutliers = DynamicGreedyOutlierRemoval(U,x,k,d,reducedOutliers)
    kOutliers=zeros(d, 1);
    Nratios=zeros(d, 1);
    removed=find(reducedOutliers);
    for i=1:d
        if(~reducedOutliers(i))
            TU=U;                        %Temporary Copy of Subspace basis
            Tx=x;                        %Temporary Copy of x 
            TU(i,:)=0;                   %Projection of the subspace basis onto the coordinates except i
            TU(removed,:)=0;             %Projection onto the rest of the coordinates except already found as outliers
            Tx(i)=0;                     %Projecting x onto coordinates except i
            Tx(removed)=0;               %Projection onto the rest of the coordinates except already found as outliers
            PU=TU*((TU'*TU)\TU');        %Calculate projection operator onto suspace
            UTx=PU*Tx;                   %Projection of x onto the projected subspace 
            Nratios(i)=norm(UTx)/norm(Tx);   %Find the ratio of norms
        end       
    end
    
    for i=1:k
        mx=-1;
        for j=1:d 
           if(Nratios(j)> mx && ~kOutliers(j)&& ~reducedOutliers(j))  %&& ~(Nratios(j)==1))
               mx=Nratios(j);
               maxj=j;
           end
        end
        kOutliers(maxj)=1;
    end 

end 