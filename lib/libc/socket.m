// libc/socket.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "arpa/inet.h"
//pragma c_include "sys/socket.h"

include "libc/ctypes64"



@calias("in_addr_t")
public type InAddrT = Nat32


@calias("INADDR_ANY")
public const inAddrAny = 0


@calias("in_port_t")
public type InPortT = Nat16

@calias("socklen_t")
public type SocklenT = Nat32


@calias("struct sockaddr")
public type SockAddr = record {
	public sa_family: UnsignedShort  // address family
	public sa_data: [14]Char8        // up to 14 bytes of direct address
}


@calias("struct in_addr")
public type Struct_in_addr = record {
	public s_addr: InAddrT
}


@calias("struct sockaddr_in")
public type SockAddrIn = record {
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



@calias("SOL_SOCKET")
public const c_SOL_SOCKET = 1   // for setsockopt


@calias("SO_REUSEADDR")
public const c_SO_REUSEADDR = 2


// from "sys/socket.h"

public func setsockopt (
	socket: Int, level: Int,
	option_name: Int, option_value: Ptr,
	option_len: SocklenT
) -> @unused Int




@calias("SOCK_STREAM")
public const c_SOCK_STREAM = 1  // stream socket
@calias("SOCK_DGRAM")
public const c_SOCK_DGRAM = 2   // datagram socket
@calias("SOCK_RAW")
public const c_SOCK_RAW = 3     // raw-protocol interface
@calias("SOCK_RDM")
public const c_SOCK_RDM = 4     // reliably-delivered message
@calias("SOCK_SEQPACKET")
public const c_SOCK_SEQPACKET = 5  // sequenced packet stream
//#ifdef _KERNEL
//const SOCK_TYPE_MASK = 0x000F	// mask that covers the above
//#endif


/*
 * Address families.
 */
public const c_AF_UNSPEC = 0       // unspecified
public const c_AF_UNIX = 1         // local to host
public const c_AF_LOCAL = c_AF_UNIX  // draft POSIX compatibility

@calias("AF_INET")
public const c_AF_INET = 2         // internetwork: UDP, TCP, etc.

public const c_AF_IMPLINK = 3      // arpanet imp addresses
public const c_AF_PUP = 4          // pup protocols: e.g. BSP
public const c_AF_CHAOS = 5        // mit CHAOS protocols
public const c_AF_NS = 6           // XEROX NS protocols
public const c_AF_ISO = 7          // ISO protocols
public const c_AF_OSI = c_AF_ISO     // OSI protocols
public const c_AF_ECMA = 8         // european computer manufacturers
public const c_AF_DATAKIT = 9      // datakit protocols
public const c_AF_CCITT = 10       // CCITT protocols, X.25 etc
public const c_AF_SNA = 11         // IBM SNA
public const c_AF_DECnet = 12      // DECnet
public const c_AF_DLI = 13         // DEC Direct data link interface
public const c_AF_LAT = 14         // LAT
public const c_AF_HYLINK = 15      // NSC Hyperchannel
public const c_AF_APPLETALK = 16   // Apple Talk
public const c_AF_ROUTE = 17       // Internal Routing Protocol
public const c_AF_LINK = 18        // Link layer interface
public const pseudo_AF_XTP = 19  // eXpress Transfer Protocol (no AF)
public const c_AF_COIP = 20        // connection-oriented IP, aka ST II
public const c_AF_CNT = 21         // Computer Network Technology
public const pseudo_AF_RTIP = 22 // Help Identify RTIP packets
public const c_AF_IPX = 23         // Novell Internet Protocol
public const c_AF_INET6 = 24       // IPv6
public const pseudo_AF_PIP = 25  // Help Identify PIP packets
public const c_AF_ISDN = 26        // Integrated Services Digital Network*/
public const c_AF_E164 = c_AF_ISDN   // CCITT E.164 recommendation
public const c_AF_NATM = 27        // native ATM access
public const c_AF_ENCAP = 28       //
public const c_AF_SIP = 29         // Simple Internet Protocol
public const c_AF_KEY = 30
// Used by BPF to not rewrite headers
// in interface output routine
public const pseudo_AF_HDRCMPLT = 31
public const c_AF_BLUETOOTH = 32      // Bluetooth
public const c_AF_MPLS = 33           // MPLS
public const pseudo_AF_PFLOW = 34   // pflow
public const pseudo_AF_PIPEX = 35   // PIPEX
public const c_AF_MAX = 36


public func inet_addr (cp: *[]ConstChar) -> InAddrT

/*
func inet_lnaof(in: Struct_in_addr) -> InAddrT
func inet_makeaddr(net: InAddrT, lna: InAddrT) -> Struct_in_addr
func inet_netof(in: Struct_in_addr) -> InAddrT
func inet_network(cp: *ConstChar) -> InAddrT
func inet_ntoa(in: Struct_in_addr) -> *Char
*/

public func socket (domain: Int, _type: Int, protocol: Int) -> Int
public func bind (socket: Int, addr: *SockAddr, addrlen: SocklenT) -> Int
public func listen (socket: Int, backlog: Int) -> Int
public func connect (socket: Int, addr: *SockAddr, addrlen: SocklenT) -> Int

public func send (socket: Int, buf: Ptr, len: SizeT, flags: Int) -> @unused SSizeT
public func recv (socket: Int, buf: Ptr, len: SizeT, flags: Int) -> @unused SSizeT

// вообще syscall, разберись
public func accept (socket: Int, addr: *SockAddr, addrlen: *SocklenT) -> Int


