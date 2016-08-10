#!/bin/sh

export LC_CTYPE=C

file1="$1"
file2="$2"

rm overlap.txt
cat $file1 | sed '/^%/ d' | tr '\n' ' ' | tr -s " " > file1.tmp
cat $file2 | sed '/^%/ d' | tr '\n' ' ' | tr -s " " > file2.tmp

nr=`wc -w file1.tmp | awk {'print $1'}`
echo "wordcount in file1: $nr"

for i in `seq 10 -1 4`; 
  do 
    echo "Looking for $i identical words"
    lastone=$((nr - i + 1))
    
    j=1
    while [ $j -lt $lastone ]
    do
      stringtobefound=`cat file1.tmp | cut -d' ' -f${j}- | cut -d' ' -f1-${i}`
      cat file2.tmp | grep -F -- "$stringtobefound" > found.tmp
      if [ -s "found.tmp" ] 
      then
        echo $stringtobefound
        echo $stringtobefound >> overlap.txt
        j=$((j + i))
        continue
      fi
      j=$((j + 1))
    done
done
                       
rm file1.tmp
rm file2.tmp
rm found.tmp
