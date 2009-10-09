# -*-perl-*-
# $Id$

BEGIN {
    use Bio::Root::Test;
    @AnyDBM_File::ISA = qw( Bio::DB::SQLite_File );
    test_begin( -tests => 49,
		-requires_module => 'DBD::SQLite',
		-requires_module => 'Bio::DB::AnyDBMImporter',
		-requires_module => 'AnyDBM_File');
}

use vars qw( $DB_HASH $DB_TREE $DB_RECNO &R_DUP &O_CREAT &O_RDWR &O_RDONLY);
use Bio::DB::AnyDBMImporter qw(:bdb);

my %db;
my $flags = O_CREAT | O_RDWR;
ok tie( %db, 'AnyDBM_File', 'my.db', $flags, 0666, $DB_HASH, 0), "tie";
ok $db{'butcher'} = 1, "set";
ok $db{'baker'} = 2, "set";
ok $db{'candlestick maker'} = 3, "set";
ok $db{'ooh, isnt this a very very very very very very very very very very long key, my goodness gracious me'} = 4, "set";
ok $a = $db{'baker'}, "access";
is($a, 2, "value correct");
ok exists $db{'baker'}, "exists";
ok delete $db{'baker'}, "delete";
ok !exists $db{'baker'}, "delete deletes";
ok my @k = keys %db, "iterate (keys)";
is_deeply( [ sort @k ] , ['butcher','candlestick maker', 'ooh, isnt this a very very very very very very very very very very long key, my goodness gracious me'] , "all keys retrieved");
my $f = 1;
while (my ($id, $val) = each %db) {
    1;
    $f *= $val;
}
is($f, 12, "iterate (each)");
ok $db{'baker'} = 10, "replace";
is($db{'baker'}, 10, "correct replace");

my $file = (tied %db)->file;
ok ( -e $file, "now you see it" );
untie %db;
ok ( ! -e $file, "now you don't");

tie( %db, 'AnyDBM_File', 'my.db', $flags, 0666, undef, 1);
ok ( -e 'my.db', "now you see it" );
untie %db;
ok ( -e 'my.db', "now you still see it");
ok ( !(tied %db), "but tied obj is gone" );

ok ( unlink('my.db'), "now you don't");

# test dup functions
$DB_BTREE->{flags} = R_DUP;
ok tie( %db, 'AnyDBM_File', undef, $flags, 0666, $DB_BTREE), "DB_BTREE";

ok (@db{('A', 'B', 'B', 'B', 'C')} = (1, 2, 2, 3, 4), "set dup hash");

is ((tied %db)->find_dup('B','3'), 0, "find_dup");
ok my $d = (tied %db)->get_dup('B');
is($d, 3, "get_dup (scalar)");
ok my @d = (tied %db)->get_dup('B');
is(@d, 3, "get_dup (array)");
ok my %d = (tied %db)->get_dup('B',1);
is($d{'2'},2,"get_dup (hash 1)");
is($d{'3'},1,"get_dup (hash 2)");
untie %db;

ok tie( @db, 'AnyDBM_File', undef, $flags, 0666, $DB_RECNO), "tied array";
my $aro = tied @db;

ok @db = qw( a b c d ), "set";
is_deeply( \@db, [qw(a b c d)], "correct set");
is( scalar @db, 4, "scalar size");
is( $#db, 3, "last elt index");
ok $db[2] = 'm', "replace";
is ($db[2], 'm', "replace correct");

# array functions

ok push(@db, 'e'), "push one";
is ($db[-1], 'e', "correct end");
ok unshift(@db, 'Z'), "unshift one";
is ($db[0], 'Z', "correct begin");
is( scalar @db, 6, "correct scalar length");

ok push(@db, 'f', 'g', 'h'), "push some";
is ($db[7],'g',"correct set");
ok unshift(@db, 'X', 'Y'), "unshift some";
is ($db[1], 'Y',"correct set");

pop @db for (1..3);
is ($db[-1], 'e', "pop some");
shift @db for (1..3);
is ($db[0], 'a', "shift some");

undef $aro;
untie(@db);

1;
