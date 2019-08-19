
          A = randn(3,3);   
         % str=sprintf('./inputMILP/Noise/OnlyMILPData/data_n_%d_p_%d_%d.dat', N, P, t);
          str = sprintf('./matrix.dat');
          disp(str);
          fid = fopen ('matrix.dat', 'w');
          fprintf(fid, "data;\n\n\n");
          fprintf(fid, "param A:=\n");       %Storing U
          for i=1:3
              for j=1:3
                  fprintf(fid, "%10d%10d%20e\n", i, j, A(i,j));         %Enter r values for each coordinate
              end
          end
          
          fprintf(fid, ";");
   