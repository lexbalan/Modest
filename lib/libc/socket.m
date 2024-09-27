// libc/socket.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "arpa/inet.h"
//$pragma c_include "sys/socket.h"


include "libc/ctypes64"


export {
	@property("type.id.c", "in_addr_t")
	type In_addr_t Nat32

	@property("type.id.c", "in_port_t")
	type In_port_t Nat16

	@property("type.id.c", "socklen_t")
	type Socklen_t Nat32


	@property("type.id.c", "struct sockaddr")
	type Struct_sockaddr record {
		sa_family: UnsignedShort  // address family
		sa_data: [14]Char8        // up to 14 bytes of direct address
	}


	@property("type.id.c", "struct in_addr")
	type Struct_in_addr record {
		s_addr: In_addr_t
	}


	@property("type.id.c", "struct sockaddr_in")
	type Struct_sockaddr_in record {
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
	let c_SOCK_STREAM = 1  // stream socket
	@property("value.id.c", "SOCK_DGRAM")
	let c_SOCK_DGRAM = 2   // datagram socket
	@property("value.id.c", "SOCK_RAW")
	let c_SOCK_RAW = 3     // raw-protocol interface
	@property("value.id.c", "SOCK_RDM")
	let c_SOCK_RDM = 4     // reliably-delivered message
	@property("value.id.c", "SOCK_SEQPACKET")
	let c_SOCK_SEQPACKET = 5  // sequenced packet stream
	//#ifdef _KERNEL
	//let SOCK_TYPE_MASK = 0x000F		// mask that covers the above
	//#endif


	/*
	 * Address families.
	 */
	let af_UNSPEC = 0       // unspecified
	let af_UNIX = 1         // local to host
	let af_LOCAL = af_UNIX  // draft POSIX compatibility

	@property("value.id.c", "AF_INET")
	let af_INET = 2         // internetwork: UDP, TCP, etc.

	let af_IMPLINK = 3      // arpanet imp addresses
	let af_PUP = 4          // pup protocols: e.g. BSP
	let af_CHAOS = 5        // mit CHAOS protocols
	let af_NS = 6           // XEROX NS protocols
	let af_ISO = 7          // ISO protocols
	let af_OSI = af_ISO     // OSI protocols
	let af_ECMA = 8         // european computer manufacturers
	let af_DATAKIT = 9      // datakit protocols
	let af_CCITT = 10       // CCITT protocols, X.25 etc
	let af_SNA = 11         // IBM SNA
	let af_DECnet = 12      // DECnet
	let af_DLI = 13         // DEC Direct data link interface
	let af_LAT = 14         // LAT
	let af_HYLINK = 15      // NSC Hyperchannel
	let af_APPLETALK = 16   // Apple Talk
	let af_ROUTE = 17       // Internal Routing Protocol
	let af_LINK = 18        // Link layer interface
	let pseudo_AF_XTP = 19  // eXpress Transfer Protocol (no AF)
	let af_COIP = 20        // connection-oriented IP, aka ST II
	let af_CNT = 21         // Computer Network Technology
	let pseudo_AF_RTIP = 22 // Help Identify RTIP packets
	let af_IPX = 23         // Novell Internet Protocol
	let af_INET6 = 24       // IPv6
	let pseudo_AF_PIP = 25  // Help Identify PIP packets
	let af_ISDN = 26        // Integrated Services Digital Network*/
	let af_E164 = af_ISDN   // CCITT E.164 recommendation
	let af_NATM = 27        // native ATM access
	let af_ENCAP = 28       //
	let af_SIP = 29         // Simple Internet Protocol
	let af_KEY = 30
	// Used by BPF to not rewrite headers
	// in interface output routine
	let pseudo_AF_HDRCMPLT = 31
	let af_BLUETOOTH = 32      // Bluetooth
	let af_MPLS = 33           // MPLS
	let pseudo_AF_PFLOW = 34   // pflow
	let pseudo_AF_PIPEX = 35   // PIPEX
	let af_MAX = 36


	func inet_addr(cp: *[]ConstChar) -> In_addr_t

	/*
	func inet_lnaof(in: Struct_in_addr) -> In_addr_t
	func inet_makeaddr(net: In_addr_t, lna: In_addr_t) -> Struct_in_addr
	func inet_netof(in: Struct_in_addr) -> In_addr_t
	func inet_network(cp: *ConstChar) -> In_addr_t
	func inet_ntoa(in: Struct_in_addr) -> *Char
	*/

	func socket(domain: Int, type: Int, protocol: Int) -> Int
	func bind(socket: Int, addr: *Struct_sockaddr, addrlen: Socklen_t) -> Int
	func listen(socket: Int, backlog: Int) -> Int
	func connect(socket: Int, addr: *Struct_sockaddr, addrlen: Socklen_t) -> Int

	func send(socket: Int, buf: Ptr, len: SizeT, flags: Int) -> SSizeT
	func recv(socket: Int, buf: Ptr, len: SizeT, flags: Int) -> SSizeT

	// вообще syscall, разберись
	func accept(socket: Int, addr: *Struct_sockaddr, addrlen: *Socklen_t) -> Int
}

