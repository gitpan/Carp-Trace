use lib 'lib';
use Test::More tests => 2;

use_ok('Carp::Trace');

sub foo { bar() };
sub bar { $x = baz() };
sub baz { @y = zot() };
sub zot { $z = trace() };

eval 'foo(1)';

my $expect = 
qq|main::(eval) [5]
\tfoo(1)
;
\tvoid - no new stash
\tt/00_trace.t line 11
main::foo [4]
\tvoid - new stash
\t(eval 2) line 1
main::bar [3]
\tvoid - new stash
\tt/00_trace.t line 6
main::baz [2]
\tscalar - new stash
\tt/00_trace.t line 7
main::zot [1]
\tlist - new stash
\tt/00_trace.t line 8
|;

is($z, $expect, "Trace");
