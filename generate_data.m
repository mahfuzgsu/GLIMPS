D = 100;    % Ambient Dimension
RR = 5; %:5:20;      % Subspace Dimension
PP = .3; %:.1:.9;  

 for R=1:length(RR)
     r = RR(R);
     for P=1:length(PP)
          p = PP(P);
          U = randn(D,r);                     % True Subspace
          theta_true = randn(r,1);            % True coefficients
          x_true = U*theta_true;              % Uncontaminated x
          outliers = randperm(D,ceil(p*D));   % Set of all outliers.
          x = x_true;
          x(outliers) = randn(size(outliers));  % Contaminated x
          fid = fopen ('xdata.dat', 'w');
          outliervec=zeros(D,1);
          outliervec(outliers)=1;
          fprintf(fid, "data;\n\n\n");
          fprintf(fid, "param d:= %d;\n", D);
          fprintf(fid, "param r:=%d;\n", r);
          fprintf(fid, "param p:=%f;\n", p);
          fprintf(fid, "param M:=%d;\n", 1000);
          fprintf(fid, "param U:=\n");       %Storing U
          for i=1:r
              for d=1:D
                  fprintf(fid, "%10d%10d%20e\n", d, i, U(d,i));         %Enter r values for each coordinate
              end
          end
          
          fprintf(fid, ";\n\nparam theta:=\n");       %Store parameter theta
          for i=1:r
              fprintf(fid, "%5d%20e\n", i, theta_true(i,1));
          end
          fprintf(fid, ";\nparam X_true:=\n");             %Store contaminated x
          for d=1:D
              fprintf(fid, "%5d%20e\n", d, x_true(d));
          end
          
          fprintf(fid, ";\nparam X:=\n");             %Store contaminated x
          for d=1:D
              fprintf(fid, "%5d%20e\n", d, x(d));
          end
          fprintf(fid, ";\nparam outliervec:=\n");          %Store outlier indices
          for d=1:D
              fprintf(fid, "%5d%5d\n", d, outliervec(d));
          end
          fprintf(fid, ";");
     end
 end 