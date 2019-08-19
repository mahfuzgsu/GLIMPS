param d;
param r;
param p;
param M;

set I:={1..d};
set J:={1..r};

param theta {i in J};
param U { i in I, j in J};

param X_true {i in I};

set K:= {1..d*p}; 

param X {i in I};

param outliervec { i in I};

var Z{i in I} binary;
var T{j in J}; 


minimize f: sum {i in I} Z[i]*Z[i];



s.t. Constraint1 {i in I}:
     X[i]- sum {j in J} U[i,j]*T[j] <=M*Z[i]; 
s.t. Constraint2 {i in I}:X[i] -sum {j in J} U[i,j]*T[j]>=- M*Z[i];
     
