use strict;
use warnings;

use threads;
use Thread::Queue;

my $q = Thread::Queue->new();    # A new empty queue
my $q2 = Thread::Queue->new();

# Worker thread
my $thr = threads->create(
    sub {
        print "Hilo \n";
        # Thread will loop until no more work
        while (defined(my $item = $q->dequeue())) {
            print $item;
            $q2->enqueue($item);
            sleep 5;
        }
    }
);

$q->enqueue(1);
$q->enqueue(2);
$q->enqueue(3);
$q->enqueue(4);
$q->end();

$thr->detach();

while (1) {
    print "q1: ";
    print $q->pending();
    print "\n";
    print "q2: ";
    print $q2->pending();
    print "\n";
    sleep 2;
}