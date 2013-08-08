/* Objective function */
min: a1 + a2 + a3;
/* Variable bounds */
a1 + a2 > a3;
a1 + a3 > a2;
a2 + a3 > a1;
a1 >= 1;
a2 >= 1;
a3 >= 1;
//a1 <> a2
a1 - a2 + 100 b1 >= 1;
-a1 + a2 + 100 - 100 b1 >= 1;
//a1 <> a3
a1 - a3 + 100 b2 >= 1;
-a1 + a3 + 100 - 100 b2 >= 1;
//a2 <> a3
a2 - a3 + 100 b3 >= 1;
-a2 + a3 + 100 - 100 b3 >= 1;
int a1,a2,a3;
bin b1,b2,b3;