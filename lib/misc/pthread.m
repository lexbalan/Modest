
$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "pthread.h"


type Int Int32

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
public type PThreadCondAttrT Int
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





type Worker (param: Ptr) -> Ptr


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



$pragma c_func_prefix "pthread_"

//int pthread_atfork(void (*prepare)(void), void (*parent)(void), void (*child)(void));
//int pthread_attr_destroy(pthread_attr_t *);
//int pthread_attr_getstack(const pthread_attr_t *, void **, size_t *);

@property("value.id.c", "pthread_attr_destroy")
public func attr_destroy(att: *PThreadAttrT) -> Int

@property("value.id.c", "pthread_attr_getstack")
public func attr_getstack(att: *PThreadAttrT, p: *Ptr, s: *SizeT) -> Int

@property("value.id.c", "pthread_create")
public func create(thread: *PThreadT, att: *PThreadAttr, worker: *Worker, param: Ptr) -> Int
@property("value.id.c", "pthread_exit")
public func exit(param: Ptr) -> Unit

@property("value.id.c", "pthread_detach")
public func detach(pthread: PThreadT) -> Int

@property("value.id.c", "pthread_join")
public func join(pthread: PThreadT, retval: *Ptr) -> Int


//int		pthread_mutex_lock(pthread_mutex_t *);
//int		pthread_mutex_unlock(pthread_mutex_t *);
@property("value.id.c", "pthread_mutex_lock")
public func mutex_lock(pthread: PThreadMutexT) -> Int
@property("value.id.c", "pthread_mutex_unlock")
public func mutex_unlock(pthread: PThreadMutexT) -> Int





