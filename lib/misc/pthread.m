
$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "pthread.h"

include "libc/ctypes64"


type Nat Nat64

@property("type.id.c", "clockid_t")
type ClockIdT Int

@property("type.id.c", "struct timespec")
type StructTimespec record {}

@property("type.id.c", "struct sched_param")
type StructSchedParam record {}


//typedef struct	pthread			*pthread_t;
@property("type.id.c", "struct pthread")
public type PThread record {}

@property("type.id.c", "pthread_t")
public type PThreadT Ptr
@property("type.id.c", "pthread_mutex_t")
public type PThreadMutexT Ptr


@property("type.id.c", "struct pthread_attr")
public type PThreadAttr Ptr
@property("type.id.c", "pthread_attr_t")
public type PThreadAttrT Ptr
@property("type.id.c", "pthread_mutexattr_t")
public type PThreadMutexAttrT Ptr
@property("type.id.c", "pthread_cond_t")
public type PThreadCondT Ptr
@property("type.id.c", "pthread_condattr_t")
public type PThreadCondAttrT Ptr
@property("type.id.c", "pthread_key_t")
public type PThreadKeyT Int
@property("type.id.c", "pthread_once_t")
public type PThreadOnceT Ptr
@property("type.id.c", "pthread_rwlock_t")
public type PThreadRWLockT Ptr
@property("type.id.c", "pthread_rwlockattr_t")
public type PThreadRWLockAttrT Ptr
@property("type.id.c", "pthread_barrier_t")
public type PThreadBarrierT Ptr
@property("type.id.c", "pthread_barrierattr_t")
public type PThreadBarrierAttrT Ptr
@property("type.id.c", "pthread_spinlock_t")
public type PThreadSpinlockT Ptr



@property("value.id.c", "PTHREAD_MUTEX_INITIALIZER")
public const mutexInitializer = nil
@property("value.id.c", "PTHREAD_COND_INITIALIZER")
public const condInitializer = nil
@property("value.id.c", "PTHREAD_RWLOCK_INITIALIZER")
public const rwlockInitializer = nil

@property("value.id.c", "PTHREAD_PRIO_NONE")
public const pthreadPrioNone = nil
@property("value.id.c", "PTHREAD_PRIO_INHERIT")
public const pthreadPrioInherit = nil
@property("value.id.c", "PTHREAD_PRIO_PROTECT")
public const pthreadPrioProtect = nil



//$pragma c_func_prefix "pthread_"

public func pthread_atfork(prepare: *() -> Unit, parent: *() -> Unit, child: *() -> Unit) -> Int
public func pthread_attr_destroy(a: *PThreadAttrT) -> Int
public func pthread_attr_getstack(a: *PThreadAttrT, p: *Ptr, ps: *SizeT) -> Int
public func pthread_attr_getstacksize(a: *PThreadAttrT, ps: *SizeT) -> Int
public func pthread_attr_getstackaddr(a: *PThreadAttrT, p: *Ptr) -> Int
public func pthread_attr_getguardsize(a: *PThreadAttrT, ps: *SizeT) -> Int
public func pthread_attr_getdetachstate(a: *PThreadAttrT, i: *Int) -> Int
public func pthread_attr_init(a: *PThreadAttrT) -> Int
public func pthread_attr_setstacksize(a: *PThreadAttrT, s: SizeT) -> Int
public func pthread_attr_setstack(a: *PThreadAttrT, p: Ptr, s: SizeT) -> Int
public func pthread_attr_setstackaddr(a: *PThreadAttrT, p: Ptr) -> Int
public func pthread_attr_setguardsize(a: *PThreadAttrT, s: SizeT) -> Int
public func pthread_attr_setdetachstate(a: *PThreadAttrT, i: Int) -> Int
public func pthread_cleanup_pop(x: Int) -> Unit
public func pthread_cleanup_push(f: *(param: Ptr) -> Unit, arg: Ptr) -> Unit
public func pthread_condattr_destroy(ca: *PThreadCondAttrT) -> Int
public func pthread_condattr_init(ca: *PThreadCondAttrT) -> Int
public func pthread_cond_broadcast(c: *PThreadCondT) -> Int
public func pthread_cond_destroy(c: *PThreadCondT) -> Int
public func pthread_cond_init(c: *PThreadCondT, ca: *PThreadCondAttrT) -> Int
public func pthread_cond_signal(c: *PThreadCondT) -> Int
public func pthread_cond_timedwait(c: *PThreadCondT, m: *PThreadMutexT, ts: *StructTimespec) -> Int
public func pthread_cond_wait(c: *PThreadCondT, m: *PThreadMutexT) -> Int
public func pthread_create(p: *PThreadT, a: *PThreadAttrT, t: *(param: Ptr) -> Ptr, p: Ptr) -> Int
public func pthread_detach(t: PThreadT) -> Int
public func pthread_equal(t0: PThreadT, t1: PThreadT) -> Int
public func pthread_exit(p: Ptr) -> Unit
public func pthread_getspecific(k: PThreadKeyT) -> Ptr
public func pthread_join(p: PThreadT, p: *Ptr) -> Int
public func pthread_key_create(k: *PThreadKeyT, f: *(p: Ptr) -> Unit) -> Int
public func pthread_key_delete(k: PThreadKeyT) -> Int
public func pthread_kill(p: PThreadT, i: Int) -> Int
public func pthread_mutexattr_init(ma: *PThreadMutexAttrT) -> Int
public func pthread_mutexattr_destroy(ma: *PThreadMutexAttrT) -> Int
public func pthread_mutexattr_gettype(ma: *PThreadMutexAttrT, i: *Int) -> Int
public func pthread_mutexattr_settype(ma: *PThreadMutexAttrT, i: Int) -> Int
public func pthread_mutex_destroy(m: *PThreadMutexT) -> Int
public func pthread_mutex_init(m: *PThreadMutexT, ma: *PThreadMutexAttrT) -> Int
public func pthread_mutex_lock(m: *PThreadMutexT) -> Int
public func pthread_mutex_timedlock(m: *PThreadMutexT, ts: *StructTimespec) -> Int
public func pthread_mutex_trylock(m: *PThreadMutexT) -> Int
public func pthread_mutex_unlock(m: *PThreadMutexT) -> Int
public func pthread_once(once: *PThreadOnceT, f: *() -> Unit) -> Int
public func pthread_rwlock_destroy(lock: *PThreadRWLockT) -> Int
public func pthread_rwlock_init(lock: *PThreadRWLockT, la: *PThreadRWLockAttrT) -> Int
public func pthread_rwlock_rdlock(lock: *PThreadRWLockT) -> Int
public func pthread_rwlock_timedrdlock(lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
public func pthread_rwlock_timedwrlock(lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
public func pthread_rwlock_tryrdlock(lock: *PThreadRWLockT) -> Int
public func pthread_rwlock_trywrlock(lock: *PThreadRWLockT) -> Int
public func pthread_rwlock_unlock(lock: *PThreadRWLockT) -> Int
public func pthread_rwlock_wrlock(lock: *PThreadRWLockT) -> Int
public func pthread_rwlockattr_init(la: *PThreadRWLockAttrT) -> Int
public func pthread_rwlockattr_getpshared(la: *PThreadRWLockAttrT, i: *Int) -> Int
public func pthread_rwlockattr_setpshared(la: *PThreadRWLockAttrT, i: Int) -> Int
public func pthread_rwlockattr_destroy(la: *PThreadRWLockAttrT) -> Int
public func pthread_self() -> PThreadT
public func pthread_setspecific(k: PThreadKeyT, p: Ptr) -> Int
public func pthread_cancel(p: PThreadT) -> Int
public func pthread_setcancelstate(a: Int, i: *Int) -> Int
public func pthread_setcanceltype(a: Int, i: *Int) -> Int
public func pthread_testcancel() -> Unit
public func pthread_getprio(p: PThreadT) -> Int
public func pthread_setprio(p: PThreadT, prio: Int) -> Int
public func pthread_yield() -> Unit
public func pthread_mutexattr_getprioceiling(ma: *PThreadMutexAttrT, i: *Int) -> Int
public func pthread_mutexattr_setprioceiling(ma: *PThreadMutexAttrT, i: Int) -> Int
public func pthread_mutex_getprioceiling(m: *PThreadMutexT, i: *Int) -> Int
public func pthread_mutex_setprioceiling(m: *PThreadMutexT, i: Int, i: *Int) -> Int
public func pthread_mutexattr_getprotocol(ma: *PThreadMutexAttrT, i: *Int) -> Int
public func pthread_mutexattr_setprotocol(ma: *PThreadMutexAttrT, i: Int) -> Int
public func pthread_condattr_getclock(ca: *PThreadCondAttrT, c: *ClockIdT) -> Int
public func pthread_condattr_setclock(ca: *PThreadCondAttrT, cid: ClockIdT) -> Int
public func pthread_attr_getinheritsched(a: *PThreadAttrT, i: *Int) -> Int
public func pthread_attr_getschedparam(a: *PThreadAttrT, s: *StructSchedParam) -> Int
public func pthread_attr_getschedpolicy(a: *PThreadAttrT, i: *Int) -> Int
public func pthread_attr_getscope(a: *PThreadAttrT, i: *Int) -> Int
public func pthread_attr_setinheritsched(a: *PThreadAttrT, i: Int) -> Int
public func pthread_attr_setschedparam(a: *PThreadAttrT, s: *StructSchedParam) -> Int
public func pthread_attr_setschedpolicy(a: *PThreadAttrT, i: Int) -> Int
public func pthread_attr_setscope(a: *PThreadAttrT, i: Int) -> Int
public func pthread_getschedparam(p: PThreadT, i: *Int, s: *StructSchedParam) -> Int
public func pthread_setschedparam(p: PThreadT, i: Int, s: *StructSchedParam) -> Int
public func pthread_getconcurrency() -> Int
public func pthread_setconcurrency(c: Int) -> Int
public func pthread_barrier_init(b: *PThreadBarrierT, ba: *PThreadBarrierAttrT, n: Nat) -> Int
public func pthread_barrier_destroy(b: *PThreadBarrierT) -> Int
public func pthread_barrier_wait(b: *PThreadBarrierT) -> Int
public func pthread_barrierattr_init(ba: *PThreadBarrierAttrT) -> Int
public func pthread_barrierattr_destroy(ba: *PThreadBarrierAttrT) -> Int
public func pthread_barrierattr_getpshared(ba: *PThreadBarrierAttrT, i: *Int) -> Int
public func pthread_barrierattr_setpshared(ba: *PThreadBarrierAttrT, i: Int) -> Int
public func pthread_spin_init(s: *PThreadSpinlockT, i: Int) -> Int
public func pthread_spin_destroy(s: *PThreadSpinlockT) -> Int
public func pthread_spin_trylock(s: *PThreadSpinlockT) -> Int
public func pthread_spin_lock(s: *PThreadSpinlockT) -> Int
public func pthread_spin_unlock(s: *PThreadSpinlockT) -> Int
public func pthread_getcpuclockid(p: PThreadT, c: *ClockIdT) -> Int


