while(true) // semmle-extractor-options: --extract-program-text
    ;
outer: for(a; b; c) {
    for(;;)
        if (d)
            continue outer;
        else if (e)
            break outer;
        else
            continue;
}

do {
    ;
} while(a);

for (var i=0,n=10; i<n; ++i);

for (var x in xs);
for (x in xs);
for (x.f in xs);
for (x = 0 in xs);