const max = 120;
let Primes = Array(max);
for(let i = 0; i < max; i++) {
    Primes[i] = 1;
}

for(let i = 2; i < max; i++) {
    let j = 2;

    while(i * j < max) {
        Primes[i * j] = 0;
        j++;
    }
}

for(let i = 2; i < max; i++) {
    if(Primes[i] == 1) {
        console.log(i);
    }
}

/*
should produce:

2
3
5
7
11
13
17
19
23
29
31
37
41
43
47
53
59
61
67
71
73
79
83
89
97
101
103
107
109
113

*/