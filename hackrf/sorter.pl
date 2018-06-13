#!/usr/bin/perl
sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}
my %powers;
while (my $line = <STDIN>) {
     chomp($line);
     ( $date, $time, $fstart, $fstop, $fwidth, $unknown, @rest ) = split(/, /, $line);
     foreach $power (@rest) {
       $powerfloat = 0.0 + $power;
       if(!$powers{$powerfloat}) {
         $powers{$powerfloat} = [];
       }
       push @{ $powers{$powerfloat} }, $line;
     }
}
@unsorted_powers = keys %powers;
@sorted_powers = sort { $b <=> $a } @unsorted_powers;
@unique_powers = uniq( @sorted_powers );
$lines = 0;
print "[";
foreach $power (@unique_powers) {
  foreach $line (@{ $powers{$power} }) {
    ( $date, $time, $fstart, $fstop, $fwidth, $unknown, @rest ) = split(/, /, $line);
    my $count = 0;
    foreach $step (@rest) {
      if($step == $power) {
        $freq = (0 + $fstart) + $count * (0 + $fwidth);
        print "\n      { ";
        print '"power": '.$power;
        print ', "freq": '.$freq;
        print " }";
      }
      $count+=1;
    }
  }
  $lines+=1;
  if($lines >= 20) {
    print "]";
    exit;
  } else {
    print ",";
  }
}

