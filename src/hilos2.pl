use threads;
use Thread::Semaphore;

my $contadorLectores :shared = 0;
my $escribirMutex = Thread::Semaphore->new();
my $sumarMutex = Thread::Semaphore->new();
my $db :shared = 1000;

# Escritor
my $th3 = threads->create(sub {
    $escribirMutex->down();

    $db = $db + 1;
    # print "ESTOY ESCRIBIENDO: ".$db;

    $escribirMutex->up();
});

$th3->detach();

#Lector 1
my $th1 = threads->create(sub {
    $sumarMutex->down();

    $contadorLectores = $contadorLectores + 1;

    if ($contadorLectores == 1) {
        $escribirMutex->down();
    }

    $sumarMutex->up();

    # print "ESTOY LEYENDO: ".$db." \n";
    sleep 3;

    $sumarMutex->down();

    $contadorLectores = $contadorLectores - 1;

    if ($contadorLectores == 0) {
        $escribirMutex->up();
    }

    $sumarMutex->up();

});

$th1->detach();


#Lector 2
my $th2 = threads->create(sub {
    $sumarMutex->down();

    $contadorLectores = $contadorLectores + 1;

    if ($contadorLectores == 1) {
        $escribirMutex->down();
    }

    $sumarMutex->up();

    # print "ESTOY LEYENDO 2: ".$db." \n";
    sleep 3;

    $sumarMutex->down();

    $contadorLectores = $contadorLectores - 1;

    if ($contadorLectores == 0) {
        $escribirMutex->up();
    }

    $sumarMutex->up();
});

$th2->detach();

sleep 100;
