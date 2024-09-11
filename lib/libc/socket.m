
$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "arpa/inet.h"
//$pragma c_include "sys/socket.h"


include "libc/ctypes64"
include "libc/ctypes"




@property("type.id.c", "in_addr_t")
export type In_addr_t Nat32

@property("type.id.c", "in_port_t")
export type In_port_t Nat16

@property("type.id.c", "socklen_t")
export type Socklen_t Nat32


@property("type.id.c", "struct sockaddr")
export type Struct_sockaddr record {
	sa_family: UnsignedShort  /* address family */
	sa_data: [14]Char8		/* up to 14 bytes of direct address */
}


@property("type.id.c", "struct in_addr")
export type Struct_in_addr record {
	s_addr: In_addr_t
}


@property("type.id.c", "struct sockaddr_in")
export type Struct_sockaddr_in record {
	// $if APPLE
	sin_len: Nat8
	sin_family: Nat8
	// $else
	//sin_family: Short
	// $endif APPLE
	sin_port: UnsignedShort
	sin_addr: Struct_in_addr
	sin_zero: [8]Nat8
}

@property("value.id.c", "SOCK_STREAM")
export let c_SOCK_STREAM = 1	 /* stream socket */
@property("value.id.c", "SOCK_DGRAM")
export let c_SOCK_DGRAM = 2	  /* datagram socket */
@property("value.id.c", "SOCK_RAW")
export let c_SOCK_RAW = 3		/* raw-protocol interface */
@property("value.id.c", "SOCK_RDM")
export let c_SOCK_RDM = 4		/* reliably-delivered message */
@property("value.id.c", "SOCK_SEQPACKET")
export let c_SOCK_SEQPACKET = 5  /* sequenced packet stream */
//#ifdef _KERNEL
//export let SOCK_TYPE_MASK = 0x000F		/* mask that covers the above */
//#endif


/*
 * Address families.
 */
export let c_AF_UNSPEC = 0		/* unspecified */
export let c_AF_UNIX = 1		/* local to host */
export let c_AF_LOCAL = c_AF_UNIX		/* draft POSIX compatibility */

@property("value.id.c", "AF_INET")
export let c_AF_INET = 2		/* internetwork: UDP, TCP, etc. */

export let c_AF_IMPLINK = 3		/* arpanet imp addresses */
export let c_AF_PUP = 4		/* pup protocols: e.g. BSP */
export let c_AF_CHAOS = 5		/* mit CHAOS protocols */
export let c_AF_NS = 6		/* XEROX NS protocols */
export let c_AF_ISO = 7		/* ISO protocols */
export let c_AF_OSI = c_AF_ISO
export let c_AF_ECMA = 8		/* european computer manufacturers */
export let c_AF_DATAKIT = 9		/* datakit protocols */
export let c_AF_CCITT = 10		/* CCITT protocols, X.25 etc */
export let c_AF_SNA = 11		/* IBM SNA */
export let c_AF_DECnet = 12		/* DECnet */
export let c_AF_DLI = 13		/* DEC Direct data link interface */
export let c_AF_LAT = 14		/* LAT */
export let c_AF_HYLINK = 15		/* NSC Hyperchannel */
export let c_AF_APPLETALK = 16		/* Apple Talk */
export let c_AF_ROUTE = 17		/* Internal Routing Protocol */
export let c_AF_LINK = 18		/* Link layer interface */
export let c_PSEUDO_AF_XTP = 19		/* eXpress Transfer Protocol (no AF) */
export let c_AF_COIP = 20		/* connection-oriented IP, aka ST II */
export let c_AF_CNT = 21		/* Computer Network Technology */
export let c_PSEUDO_AF_RTIP = 22		/* Help Identify RTIP packets */
export let c_AF_IPX = 23		/* Novell Internet Protocol */
export let c_AF_INET6 = 24		/* IPv6 */
export let c_PSEUDO_AF_PIP = 25		/* Help Identify PIP packets */
export let c_AF_ISDN = 26		/* Integrated Services Digital Network*/
export let c_AF_E164 = c_AF_ISDN		/* CCITT E.164 recommendation */
export let c_AF_NATM = 27		/* native ATM access */
export let c_AF_ENCAP = 28
export let c_AF_SIP = 29		/* Simple Internet Protocol */
export let c_AF_KEY = 30
export let c_PSEUDO_AF_HDRCMPLT = 31		/* Used by BPF to not rewrite headers
					   in interface output routine */
export let c_AF_BLUETOOTH = 32		/* Bluetooth */
export let c_AF_MPLS = 33			  /* MPLS */
export let c_PSEUDO_AF_PFLOW = 34		/* pflow */
export let c_PSEUDO_AF_PIPEX = 35		/* PIPEX */
export let c_AF_MAX = 36



export func inet_addr(cp: *[]ConstChar) -> In_addr_t

/*
export func inet_lnaof(in: Struct_in_addr) -> In_addr_t
export func inet_makeaddr(net: In_addr_t, lna: In_addr_t) -> Struct_in_addr
export func inet_netof(in: Struct_in_addr) -> In_addr_t
export func inet_network(cp: *ConstChar) -> In_addr_t
export func inet_ntoa(in: Struct_in_addr) -> *Char
*/

export func socket(domain: Int, type: Int, protocol: Int) -> Int
export func bind(sockfd: Int, addr: *Struct_sockaddr, addrlen: Socklen_t) -> Int
export func listen(sockfd: Int, backlog: Int) -> Int
export func connect(sockfd: Int, addr: *Struct_sockaddr, addrlen: Socklen_t) -> Int

export func send(socket: Int, buffer: Ptr, length: SizeT, flags: Int) -> SSizeT
export func recv(sockfd: Int, buf: Ptr, len: SizeT, flags: Int) -> SSizeT

// вообще syscall, разберись
export func accept(s: Int, addr: *Struct_sockaddr, addrlen: *Socklen_t) -> Int

