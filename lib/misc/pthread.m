
pragma do_not_include
pragma module_nodecorate
pragma c_include "pthread.h"

include "libc/ctypes64"


type Nat = Nat64

@calias("clockid_t")
type ClockIdT = Int

@calias("struct timespec")
type StructTimespec = record {}

@calias("struct sched_param")
type StructSchedParam = record {}


//typedef struct	pthread			*pthread_t;
@calias("struct pthread")
public type PThread = record {}

@calias("pthread_t")
public type PThreadT = Ptr
@calias("pthread_mutex_t")
public type PThreadMutexT = Ptr


@calias("struct pthread_attr")
public type PThreadAttr = Ptr
@calias("pthread_attr_t")
public type PThreadAttrT = Ptr
@calias("pthread_mutexattr_t")
public type PThreadMutexAttrT = Ptr
@calias("pthread_cond_t")
public type PThreadCondT = Ptr
@calias("pthread_condattr_t")
public type PThreadCondAttrT = Ptr
@calias("pthread_key_t")
public type PThreadKeyT = Int
@calias("pthread_once_t")
public type PThreadOnceT = Ptr
@calias("pthread_rwlock_t")
public type PThreadRWLockT = Ptr
@calias("pthread_rwlockattr_t")
public type PThreadRWLockAttrT = Ptr
@calias("pthread_barrier_t")
public type PThreadBarrierT = Ptr
@calias("pthread_barrierattr_t")
public type PThreadBarrierAttrT = Ptr
@calias("pthread_spinlock_t")
public type PThreadSpinlockT = Ptr



@calias("PTHREAD_MUTEX_INITIALIZER")
public const mutexInitializer = nil
@calias("PTHREAD_COND_INITIALIZER")
public const condInitializer = nil
@calias("PTHREAD_RWLOCK_INITIALIZER")
public const rwlockInitializer = nil

@calias("PTHREAD_PRIO_NONE")
public const pthreadPrioNone = nil
@calias("PTHREAD_PRIO_INHERIT")
public const pthreadPrioInherit = nil
@calias("PTHREAD_PRIO_PROTECT")
public const pthreadPrioProtect = nil


pragma append_prefix "pthread_"

public func atfork (prepare: *() -> Unit, parent: *() -> Unit, child: *() -> Unit) -> Int
public func attr_destroy (a: *PThreadAttrT) -> Int
public func attr_getstack (a: *PThreadAttrT, p: *Ptr, ps: *SizeT) -> Int
public func attr_getstacksize (a: *PThreadAttrT, ps: *SizeT) -> Int
public func attr_getstackaddr (a: *PThreadAttrT, p: *Ptr) -> Int
public func attr_getguardsize (a: *PThreadAttrT, ps: *SizeT) -> Int
public func attr_getdetachstate (a: *PThreadAttrT, i: *Int) -> Int
public func attr_init (a: *PThreadAttrT) -> Int
public func attr_setstacksize (a: *PThreadAttrT, s: SizeT) -> Int
public func attr_setstack (a: *PThreadAttrT, p: Ptr, s: SizeT) -> Int
public func attr_setstackaddr (a: *PThreadAttrT, p: Ptr) -> Int
public func attr_setguardsize (a: *PThreadAttrT, s: SizeT) -> Int
public func attr_setdetachstate (a: *PThreadAttrT, i: Int) -> Int
public func cleanup_pop (x: Int) -> Unit
public func cleanup_push (f: * (param: Ptr) -> Unit, arg: Ptr) -> Unit
public func condattr_destroy (ca: *PThreadCondAttrT) -> Int
public func condattr_init (ca: *PThreadCondAttrT) -> Int
public func cond_broadcast (c: *PThreadCondT) -> Int
public func cond_destroy (c: *PThreadCondT) -> Int
public func cond_init (c: *PThreadCondT, ca: *PThreadCondAttrT) -> Int
public func cond_signal (c: *PThreadCondT) -> Int
public func cond_timedwait (c: *PThreadCondT, m: *PThreadMutexT, ts: *StructTimespec) -> Int
public func cond_wait (c: *PThreadCondT, m: *PThreadMutexT) -> Int
public func create (p: *PThreadT, a: *PThreadAttrT, t: *(param: Ptr) -> Ptr, p: Ptr) -> Int
public func detach (t: PThreadT) -> Int
public func equal (t0: PThreadT, t1: PThreadT) -> Int
public func exit (p: Ptr) -> Unit
public func getspecific (k: PThreadKeyT) -> Ptr
public func join (p: PThreadT, p: *Ptr) -> Int
public func key_create (k: *PThreadKeyT, f: *(p: Ptr) -> Unit) -> Int
public func key_delete (k: PThreadKeyT) -> Int
public func kill (p: PThreadT, i: Int) -> Int
public func mutexattr_init (ma: *PThreadMutexAttrT) -> Int
public func mutexattr_destroy (ma: *PThreadMutexAttrT) -> Int
public func mutexattr_gettype (ma: *PThreadMutexAttrT, i: *Int) -> Int
public func mutexattr_settype (ma: *PThreadMutexAttrT, i: Int) -> Int
public func mutex_destroy (m: *PThreadMutexT) -> Int
public func mutex_init (m: *PThreadMutexT, ma: *PThreadMutexAttrT) -> Int
public func mutex_lock (m: *PThreadMutexT) -> Int
public func mutex_timedlock (m: *PThreadMutexT, ts: *StructTimespec) -> Int
public func mutex_trylock (m: *PThreadMutexT) -> Int
public func mutex_unlock (m: *PThreadMutexT) -> Int
public func once (once: *PThreadOnceT, f: *() -> Unit) -> Int
public func rwlock_destroy (lock: *PThreadRWLockT) -> Int
public func rwlock_init (lock: *PThreadRWLockT, la: *PThreadRWLockAttrT) -> Int
public func rwlock_rdlock (lock: *PThreadRWLockT) -> Int
public func rwlock_timedrdlock (lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
public func rwlock_timedwrlock (lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
public func rwlock_tryrdlock (lock: *PThreadRWLockT) -> Int
public func rwlock_trywrlock (lock: *PThreadRWLockT) -> Int
public func rwlock_unlock (lock: *PThreadRWLockT) -> Int
public func rwlock_wrlock (lock: *PThreadRWLockT) -> Int
public func rwlockattr_init (la: *PThreadRWLockAttrT) -> Int
public func rwlockattr_getpshared (la: *PThreadRWLockAttrT, i: *Int) -> Int
public func rwlockattr_setpshared (la: *PThreadRWLockAttrT, i: Int) -> Int
public func rwlockattr_destroy (la: *PThreadRWLockAttrT) -> Int
public func self () -> PThreadT
public func setspecific (k: PThreadKeyT, p: Ptr) -> Int
public func cancel (p: PThreadT) -> Int
public func setcancelstate (a: Int, i: *Int) -> Int
public func setcanceltype (a: Int, i: *Int) -> Int
public func testcancel () -> Unit
public func getprio (p: PThreadT) -> Int
public func setprio (p: PThreadT, prio: Int) -> Int
public func yield () -> Unit
public func mutexattr_getprioceiling (ma: *PThreadMutexAttrT, i: *Int) -> Int
public func mutexattr_setprioceiling (ma: *PThreadMutexAttrT, i: Int) -> Int
public func mutex_getprioceiling (m: *PThreadMutexT, i: *Int) -> Int
public func mutex_setprioceiling (m: *PThreadMutexT, i: Int, i: *Int) -> Int
public func mutexattr_getprotocol (ma: *PThreadMutexAttrT, i: *Int) -> Int
public func mutexattr_setprotocol (ma: *PThreadMutexAttrT, i: Int) -> Int
public func condattr_getclock (ca: *PThreadCondAttrT, c: *ClockIdT) -> Int
public func condattr_setclock (ca: *PThreadCondAttrT, cid: ClockIdT) -> Int
public func attr_getinheritsched (a: *PThreadAttrT, i: *Int) -> Int
public func attr_getschedparam (a: *PThreadAttrT, s: *StructSchedParam) -> Int
public func attr_getschedpolicy (a: *PThreadAttrT, i: *Int) -> Int
public func attr_getscope (a: *PThreadAttrT, i: *Int) -> Int
public func attr_setinheritsched (a: *PThreadAttrT, i: Int) -> Int
public func attr_setschedparam (a: *PThreadAttrT, s: *StructSchedParam) -> Int
public func attr_setschedpolicy (a: *PThreadAttrT, i: Int) -> Int
public func attr_setscope (a: *PThreadAttrT, i: Int) -> Int
public func getschedparam (p: PThreadT, i: *Int, s: *StructSchedParam) -> Int
public func setschedparam (p: PThreadT, i: Int, s: *StructSchedParam) -> Int
public func getconcurrency () -> Int
public func setconcurrency (c: Int) -> Int
public func barrier_init (b: *PThreadBarrierT, ba: *PThreadBarrierAttrT, n: Nat) -> Int
public func barrier_destroy (b: *PThreadBarrierT) -> Int
public func barrier_wait (b: *PThreadBarrierT) -> Int
public func barrierattr_init (ba: *PThreadBarrierAttrT) -> Int
public func barrierattr_destroy (ba: *PThreadBarrierAttrT) -> Int
public func barrierattr_getpshared (ba: *PThreadBarrierAttrT, i: *Int) -> Int
public func barrierattr_setpshared (ba: *PThreadBarrierAttrT, i: Int) -> Int
public func spin_init (s: *PThreadSpinlockT, i: Int) -> Int
public func spin_destroy (s: *PThreadSpinlockT) -> Int
public func spin_trylock (s: *PThreadSpinlockT) -> Int
public func spin_lock (s: *PThreadSpinlockT) -> Int
public func spin_unlock (s: *PThreadSpinlockT) -> Int
public func getcpuclockid (p: PThreadT, c: *ClockIdT) -> Int

pragma remove_prefix "pthread_"


