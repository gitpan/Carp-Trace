use lib 'lib';
use Test::More tests => 3;
BEGIN { $^W = 0 }
use_ok('Carp::Trace');

sub foo { bar() };
sub bar { $x = baz() };
sub baz { @y = zot() };
sub zot { $z = trace() };

### trace without args
{   eval 'foo(1)';

my $expect = 
qq|main::(eval) [5]
\tfoo(1);
\tvoid - no new stash
\tt/00_trace.t line 12
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
    
    is($z, $expect, "Trace with no arguments");
}

### Trace with args
{   local $Carp::Trace::ARGUMENTS = 1;
    eval foo($0,[1]);

my $expect = 
qq|main::foo [4]
\tscalar - new stash
\tt/00_trace.t line 38
\t\$ARGS1 = 't/00_trace.t';
\t\$ARGS2 = [
\t  1
\t];
main::bar [3]
\tscalar - new stash
\tt/00_trace.t line 6
\t\$ARGS1 = 't/00_trace.t';
\t\$ARGS2 = [
\t  1
\t];
main::baz [2]
\tscalar - new stash
\tt/00_trace.t line 7
main::zot [1]
\tlist - new stash
\tt/00_trace.t line 8
|;
    
    is($z, $expect, "Trace with arguments");
}
