#It succeeded and this code is very useful 
#Our first solution to MILP with randomly generated data...


param d;
param r;
param p;
param M;

set I:={1..d};
set J:={1..r};

param theta {i in J} := Normal01();
param U { i in I, j in J} := Normal01();

param X_true {i in I} := sum {j in J} U[i,j]*theta[j];

set K:= {1..d*p}; 
param outliers {k in K} := floor(Uniform(1, 101)); 


param X {i in I}:=
      if exists {k in K} i=outliers[k] then Normal01()
         else X_true[i];


var Z{i in I} binary;
var T{j in J}; 



minimize f: sum {i in I} Z[i]*Z[i];



s.t. Constraint1 {i in I}:
     X[i]- sum {j in J} U[i,j]*T[j] <=M*Z[i]; 
s.t. Constraint2 {i in I}:X[i] -sum {j in J} U[i,j]*T[j]>=- M*Z[i];
     
