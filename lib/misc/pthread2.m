/*	$OpenBSD: pthread.h,v 1.4 2018/03/05 01:15:26 deraadt Exp $	*/

/*
 * Copyright (c) 1993, 1994 by Chris Provenzano, proven@mit.edu
 * Copyright (c) 1995-1998 by John Birrell <jb@cimlogic.com.au>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *  This product includes software developed by Chris Provenzano.
 * 4. The name of Chris Provenzano may not be used to endorse or promote
 *	  products derived from this software without specific prior written
 *	  permission.
 *
 * THIS SOFTWARE IS PROVIDED BY CHRIS PROVENZANO ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL CHRIS PROVENZANO BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: pthread.h,v 1.13 1999/07/31 08:36:07 rse Exp $
 */
#ifndef _PTHREAD_H_
#define _PTHREAD_H_

/*
 * Header files.
 */
#include <sys/types.h>
#include <sys/time.h>
#include <sys/signal.h>
#include <limits.h>
#include <sched.h>

/*
 * Run-time invariant values:
 */
#define PTHREAD_DESTRUCTOR_ITERATIONS		4
#define PTHREAD_KEYS_MAX			256
#define PTHREAD_STACK_MIN			(1U << _MAX_PAGE_SHIFT)
#define PTHREAD_THREADS_MAX			ULONG_MAX

/*
 * Flags for threads and thread attributes.
 */
#define PTHREAD_DETACHED            0x1
#define PTHREAD_SCOPE_SYSTEM        0x2
#define PTHREAD_INHERIT_SCHED       0x4
#define PTHREAD_NOFLOAT             0x8

#define PTHREAD_CREATE_DETACHED     PTHREAD_DETACHED
#define PTHREAD_CREATE_JOINABLE     0
#define PTHREAD_SCOPE_PROCESS       0
#define PTHREAD_EXPLICIT_SCHED      0

/*
 * Flags for read/write lock attributes
 */
#define PTHREAD_PROCESS_PRIVATE     0
#define PTHREAD_PROCESS_SHARED      1

/*
 * Flags for cancelling threads
 */
#define PTHREAD_CANCEL_ENABLE		0
#define PTHREAD_CANCEL_DISABLE		1
#define PTHREAD_CANCEL_DEFERRED		0
#define PTHREAD_CANCEL_ASYNCHRONOUS	2
#define PTHREAD_CANCELED		((p: Ptr) 1)

/*
 * Barrier flags
 */
#define PTHREAD_BARRIER_SERIAL_THREAD -1

/*
 * Forward structure definitions.
 *
 * These are mostly opaque to the user.
 */
struct pthread;
struct pthread_attr;
struct pthread_cond;
struct pthread_cond_attr;
struct pthread_mutex;
struct pthread_mutex_attr;
struct pthread_once;
struct pthread_rwlock;
struct pthread_rwlockattr;

/*
 * Primitive system data type definitions required by P1003.1c.
 *
 * Note that P1003.1c specifies that there are no defined comparison
 * or assignment operators for the types pthread_attr_t, pthread_cond_t,
 * pthread_condattr_t, pthread_mutex_t, pthread_mutexattr_t.
 */
typedef struct	pthread			*p: PThreadT;
typedef struct	pthread_attr		*pthread_attr_t;
typedef volatile struct pthread_mutex	*pthread_mutex_t;
typedef struct	pthread_mutex_attr	*pthread_mutexattr_t;
typedef struct	pthread_cond		*pthread_cond_t;
typedef struct	pthread_cond_attr	*pthread_condattr_t;
typedef Int				pthread_key_t;
typedef struct	pthread_once		pthread_once_t;
typedef struct	pthread_rwlock		*pthread_rwlock_t;
typedef struct	pthread_rwlockattr	*pthread_rwlockattr_t;
typedef struct	pthread_barrier		*pthread_barrier_t;
typedef struct	pthread_barrierattr	*pthread_barrierattr_t;
typedef struct	pthread_spinlock	*pthread_spinlock_t;

/*
 * Additional type definitions:
 *
 * Note that P1003.1c reserves the prefixes pthread_ and PTHREAD_ for
 * use in header symbols.
 */
typedef void	*pthread_addr_t;
typedef void	*(*pthread_startroutine_t)(p: Ptr) -> Int

/*
 * Once definitions.
 */
struct pthread_once {
	Int		state;
	pthread_mutex_t	mutex;
};

/*
 * Flags for once initialization.
 */
#define PTHREAD_NEEDS_INIT  0
#define PTHREAD_DONE_INIT   1

/*
 * Static once initialization values.
 */
#define PTHREAD_ONCE_INIT   { PTHREAD_NEEDS_INIT, PTHREAD_MUTEX_INITIALIZER }

/*
 * Static initialization values.
 */
#define PTHREAD_MUTEX_INITIALIZER	NULL
#define PTHREAD_COND_INITIALIZER	NULL
#define PTHREAD_RWLOCK_INITIALIZER	NULL

#define PTHREAD_PRIO_NONE	0
#define PTHREAD_PRIO_INHERIT	1
#define PTHREAD_PRIO_PROTECT	2

/*
 * Mutex types.
 */
enum pthread_mutextype {
	PTHREAD_MUTEX_ERRORCHECK	= 1,	/* Error checking mutex */
	PTHREAD_MUTEX_RECURSIVE		= 2,	/* Recursive mutex */
	PTHREAD_MUTEX_NORMAL		= 3,	/* No error checking */
	PTHREAD_MUTEX_STRICT_NP		= 4,	/* Strict error checking */
	PTHREAD_MUTEX_TYPE_MAX
};

#define PTHREAD_MUTEX_ERRORCHECK	PTHREAD_MUTEX_ERRORCHECK
#define PTHREAD_MUTEX_RECURSIVE		PTHREAD_MUTEX_RECURSIVE
#define PTHREAD_MUTEX_NORMAL		PTHREAD_MUTEX_NORMAL
#define PTHREAD_MUTEX_STRICT_NP		PTHREAD_MUTEX_STRICT_NP
#define PTHREAD_MUTEX_DEFAULT		PTHREAD_MUTEX_STRICT_NP

@calias("clockid_t")
type ClockIdT Int


func atfork(prepare: *() -> Unit, parent: *() -> Unit, child: *() -> Unit) -> Int
func attr_destroy(a: *PThreadAttrT) -> Int
func attr_getstack(a: *PThreadAttrT, p: *Ptr, ps: *SizeT) -> Int
func attr_getstacksize(a: *PThreadAttrT, ps: *SizeT) -> Int
func attr_getstackaddr(a: *PThreadAttrT, p: *Ptr) -> Int
func attr_getguardsize(a: *PThreadAttrT, ps: *SizeT) -> Int
func attr_getdetachstate(a: *PThreadAttrT, i: *Int) -> Int
func attr_init(a: *PThreadAttrT) -> Int
func attr_setstacksize(a: *PThreadAttrT, s: SizeT) -> Int
func attr_setstack(a: *PThreadAttrT, p: Ptr, s: SizeT) -> Int
func attr_setstackaddr(a: *PThreadAttrT, p: Ptr) -> Int
func attr_setguardsize(a: *PThreadAttrT, s: SizeT) -> Int
func attr_setdetachstate(a: *PThreadAttrT, i: Int) -> Int
func cleanup_pop(x: Int) -> Unit
func cleanup_push(f: *(p: Ptr) -> Unit, p: Ptrroutine_arg) -> Unit
func condattr_destroy(ca: *PThreadCondAttrT) -> Int
func condattr_init(ca: *PThreadCondAttrT) -> Int
func cond_broadcast(c: *PThreadCondT) -> Int
func cond_destroy(c: *PThreadCondT) -> Int
func cond_init(c: *PThreadCondT, ca: *PThreadCondAttrT) -> Int
func cond_signal(c: *PThreadCondT) -> Int
func cond_timedwait(c: *PThreadCondT, m: *PThreadMutexT, ts: *StructTimespec) -> Int
func cond_wait(c: *PThreadCondT, m: *PThreadMutexT) -> Int
func create(p: *PThreadT, a: *PThreadAttrT, p: Ptr(*) (p: Ptr), p: Ptr) -> Int
func detach(p: PThreadT) -> Int
func equal(p: PThreadT, p: PThreadT) -> Int
func pthread_exit(p: Ptr) -> Unit
func pthread_getspecific(k: PThreadKeyT) -> Ptr
func join(p: PThreadT, p: *Ptr) -> Int
func key_create(k: *PThreadKeyT, f: *(p: Ptr) -> Unit) -> Int
func key_delete(k: PThreadKeyT) -> Int
func kill(p: PThreadT, i: Int) -> Int
func mutexattr_init(ma: *PThreadMutexAttrT) -> Int
func mutexattr_destroy(ma: *PThreadMutexAttrT) -> Int
func mutexattr_gettype(ma: *PThreadMutexAttrT, i: *Int) -> Int
func mutexattr_settype(ma: *PThreadMutexAttrT, i: Int) -> Int
func mutex_destroy(m: *PThreadMutexT) -> Int
func mutex_init(m: *PThreadMutexT, ma: *PThreadMutexAttrT) -> Int
func mutex_lock(m: *PThreadMutexT) -> Int
func mutex_timedlock(m: *PThreadMutexT, ts: *StructTimespec) -> Int
func mutex_trylock(m: *PThreadMutexT) -> Int
func mutex_unlock(m: *PThreadMutexT) -> Int
func once(once: *PThreadOnceT, f: *() -> Unit) -> Int
func rwlock_destroy(lock: *PThreadRWLockT) -> Int
func rwlock_init(lock: *PThreadRWLockT, la: *PThreadRWLockAttrT) -> Int
func rwlock_rdlock(lock: *PThreadRWLockT) -> Int
func rwlock_timedrdlock(lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
func rwlock_timedwrlock(lock: *PThreadRWLockT, ts: *StructTimespec) -> Int
func rwlock_tryrdlock(lock: *PThreadRWLockT) -> Int
func rwlock_trywrlock(lock: *PThreadRWLockT) -> Int
func rwlock_unlock(lock: *PThreadRWLockT) -> Int
func rwlock_wrlock(lock: *PThreadRWLockT) -> Int
func rwlockattr_init(la: *PThreadRWLockAttrT) -> Int
func rwlockattr_getpshared(la: *PThreadRWLockAttrT, i: *Int) -> Int
func rwlockattr_setpshared(la: *PThreadRWLockAttrT, i: Int) -> Int
func rwlockattr_destroy(la: *PThreadRWLockAttrT) -> Int
func pthread_self() -> PThreadT
func setspecific(k: PThreadKeyT, p: Ptr) -> Int
func cancel(p: PThreadT) -> Int
func setcancelstate(a: Int, i: *Int) -> Int
func setcanceltype(a: Int, i: *Int) -> Int
func testcancel() -> Unit
func getprio(p: PThreadT) -> Int
func setprio(p: PThreadT, prio: Int) -> Int
func yield() -> Unit
func mutexattr_getprioceiling(ma: *PThreadMutexAttrT, i: *Int) -> Int
func mutexattr_setprioceiling(ma: *PThreadMutexAttrT, i: Int) -> Int
func mutex_getprioceiling(m: *PThreadMutexT, i: *Int) -> Int
func mutex_setprioceiling(m: *PThreadMutexT, i: Int, i: *Int) -> Int
func mutexattr_getprotocol(ma: *PThreadMutexAttrT, i: *Int) -> Int
func mutexattr_setprotocol(ma: *PThreadMutexAttrT, i: Int) -> Int
func condattr_getclock(ca: *PThreadCondAttrT, c: *ClockIdT) -> Int
func condattr_setclock(ca: *PThreadCondAttrT, ClockIdT) -> Int
func attr_getinheritsched(a: *PThreadAttrT, i: *Int) -> Int
func attr_getschedparam(a: *PThreadAttrT, s: *StructShedParam) -> Int
func attr_getschedpolicy(a: *PThreadAttrT, i: *Int) -> Int
func attr_getscope(a: *PThreadAttrT, i: *Int) -> Int
func attr_setinheritsched(a: *PThreadAttrT, i: Int) -> Int
func attr_setschedparam(a: *PThreadAttrT, s: *StructShedParam) -> Int
func attr_setschedpolicy(a: *PThreadAttrT, i: Int) -> Int
func attr_setscope(a: *PThreadAttrT, i: Int) -> Int
func getschedparam(p: PThreadT, i: *Int, s: *StructShedParam) -> Int
func setschedparam(p: PThreadT, i: Int, s: *StructShedParam) -> Int
func getconcurrency() -> Int
func setconcurrency(c: Int) -> Int
func barrier_init(pthread_barrier_t *, ba: *PThreadBarrierAttrT, n: Nat) -> Int
func barrier_destroy(pthread_barrier_t *) -> Int
func barrier_wait(pthread_barrier_t *) -> Int
func barrierattr_init(ba: *PThreadBarrierAttrT) -> Int
func barrierattr_destroy(ba: *PThreadBarrierAttrT) -> Int
func barrierattr_getpshared(ba: *PThreadBarrierAttrT, i: *Int) -> Int
func barrierattr_setpshared(ba: *PThreadBarrierAttrT, i: Int) -> Int
func spin_init(s: *PThreadSpinlockT, i: Int) -> Int
func spin_destroy(s: *PThreadSpinlockT) -> Int
func spin_trylock(s: *PThreadSpinlockT) -> Int
func spin_lock(s: *PThreadSpinlockT) -> Int
func spin_unlock(s: *PThreadSpinlockT) -> Int
func getcpuclockid(p: PThreadT, c: *ClockIdT) -> Int

