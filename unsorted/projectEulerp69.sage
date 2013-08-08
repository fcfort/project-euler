&quot;d:\users\fe01106\project Euler\projectEulerp69.txt&quot;
system:sage

{{{id=0|
max = 0;
for n in [1..1000000]:
    ratio = n/euler_phi(n);
    if ( ratio > max ):
        max = ratio;
        print n;
///

1
2
6
30
210
2310
30030
510510
}}}

{{{id=1|

///
}}}