// libc/socket.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "arpa/inet.h"
//$pragma c_include "sys/socket.h"

include "libc/ctypes64"



@property("type.id.c", "in_addr_t")
public type InAddrT Nat32


@property("value.id.c", "INADDR_ANY")
public const inAddrAny = 0


@property("type.id.c", "in_port_t")
public type InPortT Nat16

@property("type.id.c", "socklen_t")
public type SocklenT Nat32


@property("type.id.c", "struct sockaddr")
public type SockAddr record {
	public sa_family: UnsignedShort  // address family
	public sa_data: [14]Char8        // up to 14 bytes of direct address
}


@property("type.id.c", "struct in_addr")
public type Struct_in_addr record {
	public s_addr: InAddrT
}


@property("type.id.c", "struct sockaddr_in")
public type SockAddrIn record {
// $if APPLE
	public sin_len: Nat8
	public sin_family: Nat8
// $else
//public sin_family: Short
// $endif APPLE
	public sin_port: UnsignedShort
	public sin_addr: Struct_in_addr
	public sin_zero: [8]Nat8
}

@property("value.id.c", "SOCK_STREAM")
public const c_SOCK_STREAM = 1  // stream socket
@property("value.id.c", "SOCK_DGRAM")
public const c_SOCK_DGRAM = 2   // datagram socket
@property("value.id.c", "SOCK_RAW")
public const c_SOCK_RAW = 3     // raw-protocol interface
@property("value.id.c", "SOCK_RDM")
public const c_SOCK_RDM = 4     // reliably-delivered message
@property("value.id.c", "SOCK_SEQPACKET")
public const c_SOCK_SEQPACKET = 5  // sequenced packet stream
//#ifdef _KERNEL
//const SOCK_TYPE_MASK = 0x000F	// mask that covers the above
//#endif


/*
 * Address families.
 */
public const af_UNSPEC = 0       // unspecified
public const af_UNIX = 1         // local to host
public const af_LOCAL = af_UNIX  // draft POSIX compatibility

@property("value.id.c", "AF_INET")
public const af_INET = 2         // internetwork: UDP, TCP, etc.

public const af_IMPLINK = 3      // arpanet imp addresses
public const af_PUP = 4          // pup protocols: e.g. BSP
public const af_CHAOS = 5        // mit CHAOS protocols
public const af_NS = 6           // XEROX NS protocols
public const af_ISO = 7          // ISO protocols
public const af_OSI = af_ISO     // OSI protocols
public const af_ECMA = 8         // european computer manufacturers
public const af_DATAKIT = 9      // datakit protocols
public const af_CCITT = 10       // CCITT protocols, X.25 etc
public const af_SNA = 11         // IBM SNA
public const af_DECnet = 12      // DECnet
public const af_DLI = 13         // DEC Direct data link interface
public const af_LAT = 14         // LAT
public const af_HYLINK = 15      // NSC Hyperchannel
public const af_APPLETALK = 16   // Apple Talk
public const af_ROUTE = 17       // Internal Routing Protocol
public const af_LINK = 18        // Link layer interface
public const pseudo_AF_XTP = 19  // eXpress Transfer Protocol (no AF)
public const af_COIP = 20        // connection-oriented IP, aka ST II
public const af_CNT = 21         // Computer Network Technology
public const pseudo_AF_RTIP = 22 // Help Identify RTIP packets
public const af_IPX = 23         // Novell Internet Protocol
public const af_INET6 = 24       // IPv6
public const pseudo_AF_PIP = 25  // Help Identify PIP packets
public const af_ISDN = 26        // Integrated Services Digital Network*/
public const af_E164 = af_ISDN   // CCITT E.164 recommendation
public const af_NATM = 27        // native ATM access
public const af_ENCAP = 28       //
public const af_SIP = 29         // Simple Internet Protocol
public const af_KEY = 30
// Used by BPF to not rewrite headers
// in interface output routine
public const pseudo_AF_HDRCMPLT = 31
public const af_BLUETOOTH = 32      // Bluetooth
public const af_MPLS = 33           // MPLS
public const pseudo_AF_PFLOW = 34   // pflow
public const pseudo_AF_PIPEX = 35   // PIPEX
public const af_MAX = 36


public func inet_addr(cp: *[]ConstChar) -> InAddrT

/*
func inet_lnaof(in: Struct_in_addr) -> InAddrT
func inet_makeaddr(net: InAddrT, lna: InAddrT) -> Struct_in_addr
func inet_netof(in: Struct_in_addr) -> InAddrT
func inet_network(cp: *ConstChar) -> InAddrT
func inet_ntoa(in: Struct_in_addr) -> *Char
*/

public func socket(domain: Int, _type: Int, protocol: Int) -> Int
public func bind(socket: Int, addr: *SockAddr, addrlen: SocklenT) -> Int
public func listen(socket: Int, backlog: Int) -> Int
public func connect(socket: Int, addr: *SockAddr, addrlen: SocklenT) -> Int

public func send(socket: Int, buf: Ptr, len: SizeT, flags: Int) -> SSizeT
public func recv(socket: Int, buf: Ptr, len: SizeT, flags: Int) -> SSizeT

// вообще syscall, разберись
public func accept(socket: Int, addr: *SockAddr, addrlen: *SocklenT) -> Int


