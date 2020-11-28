use threads;
use Thread::Semaphore;

my $cpu_semaforo = Thread::Semaphore->new();
my $monitor_semaforo = Thread::Semaphore->new();

$cpu_semaforo->down();

# PROCESADOR
my $th1 = threads->create(sub {
    while(1) {
        # $monitor_semaforo->down();
        $cpu_semaforo->down(); # 1

        # print "HILO 2 \n";
        sleep 3;

        $monitor_semaforo->up();
        # $cpu_semaforo->up();
    }
});

# MONITOR
while(1) {
    # $cpu_semaforo->down();
    $monitor_semaforo->down(); # 0

    # print "HILO 1 \n";
    sleep 2;

    # $monitor_semaforo->up();
    $cpu_semaforo->up(); # 1
}

$th1->detach();
