package Carp::Trace;
use strict;

BEGIN {
    use     vars qw[@ISA @EXPORT $VERSION];
    use     Exporter;
    
    @ISA    = 'Exporter';
    @EXPORT = 'trace';
}

$VERSION = '0.01';

sub trace {
    my $level = shift || 0;
 
    my $trace;
    my $i = 1;

    while (1) {
        last if $level && $level < $i; 
    
        my  @caller = caller($i);
        last unless scalar @caller;
        
        my  ($package, $filename, $line, $subroutine, $hasargs, $wantarray, 
            $evaltext, $is_require, $hints, $bitmask) = @caller;
        
        my $string = $subroutine eq '(eval)' 
                    ?   $package . '::' . $subroutine . qq| [$i]| 
                        . (defined $evaltext ? qq[\n\t$evaltext] : '')       
                    :   $subroutine . qq| [$i]|;
        $string .= qq[\n\t];
        
        $string .= q[require|use - ] if $is_require;
        $string .= defined $wantarray ? $wantarray ? 'list - ' : 'scalar - ' : 'void - ';
        $string .= $hasargs ? 'new stash' : 'no new stash';
        $string .=  qq[\n\t] . $filename . ' line ' . $line . qq[\n];
    
        $trace = $string . $trace;
    
        $i++;    
    }
    
    return $trace;
}
  
__END__                   
   
=head1 NAME

Carp::Trace - simple traceback of call stacks

=head1 SYNOPSIS

    use Carp::Trace;
    
    sub flubber {
        die "You took this route to get here:\n" .
            trace();
    }

=head1 DESCRIPTION

Carp::Trace provides an easy way to see the route your script took to
get to a certain place. It uses simple C<caller> calls to determine this.

=head1 FUNCTIONS

=head2 trace( [DEPTH] )

C<trace> is a function, exported by default, that gives a simple traceback
of how you got where you are. It returns a formatted string, ready to be
sent to C<STDOUT> or C<STDERR>.

Optionally, you can provide a DEPTH argument, which tells trace to only
go back so many levels.

C<trace> is able to tell you the following things:

=over 4

=item *

The name of the function

=item * 

The number of callstacks from your current location

=item *

The context in which the function was called

=item * 

Whether a new instance of C<@_> was created for this function

=item *

Whether the function was called in an C<eval>, C<require> or C<use>

=item *

If called from a string C<eval>, what the eval-string is

=item * 

The file the function is in

=item * 

The line number the function is on

=back

The output from the following code:

    use Carp::Trace;

    sub foo { bar() };
    sub bar { $x = baz() };
    sub baz { @y = zot() };
    sub zot { print trace() };

    eval 'foo(1)';

Might look something like this:

    main::(eval) [5]
        foo(1);
        void - no new stash
        x.pl line 1
    main::foo [4]
        void - new stash
        (eval 1) line 1
    main::bar [3]
        void - new stash
        x.pl line 1
    main::baz [2]
        scalar - new stash
        x.pl line 1
    main::zot [1]
        list - new stash
        x.pl line 1

=head1 AUTHOR

his module by
Jos Boumans E<lt>kane@cpan.orgE<gt>.

=head1 COPYRIGHT

This module is
copyright (c) 2002 Jos Boumans E<lt>kane@cpan.orgE<gt>.
All rights reserved.

This library is free software;
you may redistribute and/or modify it under the same
terms as Perl itself.

=cut
