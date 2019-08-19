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


var Z1 {i in I} binary;
var Z2 {i in I} binary;
var T{j in J}; 
var S {j in J};

minimize f1: sum {i in I} Z1[i]*Z1[i];
#minimize f2: sum {i in I} Z2[i]*Z2[i];
#minimize Z: sum {i in I} Z1[i]+Z2[i];


s.t. Constraint1 {i in I}:
     sum {j in J} U[i,j]*T[j]- X[i]<= M*Z1[i] ;
     
s.t. Constraint2 { i in I}:
     X[i] - sum {j in J} U[i,j]*S[j]<=M*Z2[i]; 

#abs(- 