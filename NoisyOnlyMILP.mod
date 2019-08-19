
param d;
param r;
param p;
param M;

set I:={1..d};
set J:={1..r};

param theta {i in J};
param U { i in I, j in J};

param X_true {i in I};


param X {i in I};

param outliervec { i in I};


var Z{i in I} binary;
var W{1..d};
var T{j in J}; 


minimize f: sum{i in 1..d} (Z[i] + 1000*W[i]^2);;


s.t. Constraint1 {i in I}:
    X[i]- W[i] - sum {j in J} U[i,j]*T[j] <=M*Z[i]; 
s.t. Constraint2 {i in I}:
    X[i] - W[i]- sum {j in J} U[i,j]*T[j]>=- M*Z[i];
