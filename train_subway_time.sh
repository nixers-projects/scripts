#submited by TheHotBot
#!/bin/bash

while clear; do
OUT1=`links -dump -codepage iso-8859-1 "http://mobilrt.sl.se/?tt=BUS|METRO|TRAIN|TRAM&ls=&SiteId=3761&name=QmVyZ2VuZ2F0YW4gKFN0b2NraG9sbSk%3d"|tail -n +8|egrep -ve 'IMG|s.kning|2011|Start|mobil|Realtidsinformation|G*ller endast buss|Upp$|*kning|Du har valt'`

  echo "$OUT1" | perl -ne '
  if (/((?:.+)\s+)(\d+)(\s+min.*)$/) {
   %ctable = (
     map(($_ => "1;31"), 1..3),
     map(($_ => 31),     4..7),
     map(($_ => 33),     8..10),
     map(($_ => 32),     11..15),
   );

   $ctime = $ctable{$2} || 34;

   print "$1\033[${ctime}m$2$3\033[m\n";
  }
  else {
   print;
  }
  '
OUT=`links -dump -codepage iso-8859-1 "http://mobilrt.sl.se/?tt=BUS|METRO|TRAIN|TRAM&ls=&SiteId=9301&name=SHVzYnkgKFN0b2NraG9sbSk%3d"|tail -n +8|egrep -ve 'IMG|s.kning|2011|Start|mobil|Realtidsinformation|G*ller endast buss|Upp$|*kning|Du har valt|Uppdaterat'`

  echo "$OUT" | perl -ne '
  if (/((?:.+)\s+)(\d+)(\s+min.*)$/) {
   %ctable = (
     map(($_ => "1;31"), 1..3),
     map(($_ => 31),     4..7),
     map(($_ => 33),     8..10),
     map(($_ => 32),     11..15),
   );

   $ctime = $ctable{$2} || 34;

   print "$1\033[${ctime}m$2$3\033[m\n";
  }
  else {
   print;
  }
  '
sleep 60
done
