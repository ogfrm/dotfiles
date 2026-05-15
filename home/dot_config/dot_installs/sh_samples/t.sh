
#!/bin/bash

n=${1:-1}

if [ -t 0 ]; then
echo "$n: Interactive"
else
echo "$n: Non interactive"
fi

if (( $n <= 1 )); then
./t.sh $(($n+1))
fi
