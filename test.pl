use strict;
use warnings;

my $string = "a"x15;
$string .= "b"x7;
$string .= "c"x6;
$string .= "d"x6;
$string .= "e"x5;

print $string, "\n";

use Data::Dumper;

my $counts = generate_counts(\$string);
print Dumper($counts);

build_hash($counts);

sub generate_counts
{
    my ($str) = @_;

    my %counts = ();

    for (my $i=0; $i < length($$str); $i++)
    {
	$counts{substr($$str, $i, 1)}{count}++;
    }

    return \%counts;
}

sub build_hash
{
    my ($counts) = @_;

    while (1==1)
    {
	# sort the list by counts
	my @list = sort { $counts->{$a}{count} <=> $counts->{$b}{count} || $a cmp $b } (keys %{$counts});
	# exclude all nodes with a parent information
	@list = grep { ! exists $counts->{$_}{parent} } (@list);
	
	# is the list longer than 2?
	if (@list >= 2)
	{
	    # the list is sorted so take the first to elements
	    my ($first, $second) = @list[0,1];
	    
	    # combine both charactersets
	    my $combined = $first.$second;
	    
	    # generate a new node and set the counts to sum of counts from
	    # first and second
	    $counts->{$combined}{count} = 
		$counts->{$first}{count} + $counts->{$second}{count};
	    
	    # set the new node as parent
	    $counts->{$first}{parent} = $combined;
	    $counts->{$second}{parent} = $combined;

	    # set the childs to the new node
	    $counts->{$combined}{first} = $first;
	    $counts->{$combined}{second} = $second;

	    # assign a 0 for the first and a 1 for the second node
	    $counts->{$first}{value} = 0;
	    $counts->{$second}{value} = 1;
	} elsif (@list == 1) {
	    last;
	} else {
	    die;
	}
    }

    # find the root node
    my ($root) = grep { ! exists $counts->{$_}{parent} } (keys %{$counts});
    
    print "Debug\n";
    
}
