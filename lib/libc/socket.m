// libc/socket.m

pragma do_not_include
pragma prefix ""
pragma c_include "arpa/inet.h"
//pragma c_include "sys/socket.h"

include "libc/ctypes64"


@extern("C", "in_addr_t")
public type InAddrT = Nat32

@extern("C", "INADDR_ANY")
public const inAddrAny = 0

@extern("C", "in_port_t")
public type InPortT = Nat16

@extern("C", "socklen_t")
public type SocklenT = Nat32


@extern("C", "struct sockaddr")
public type SockAddr = @public {
	sa_family: UnsignedShort  // address family
	sa_data: [14]Char8        // up to 14 bytes of direct address
}


@extern("C", "struct in_addr")
public type Struct_in_addr = @public {
	s_addr: InAddrT
}


@extern("C", "struct sockaddr_in")
public type SockAddrIn = @public {
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



@extern("C", "SOL_SOCKET")
public const solSocket = 1   // for setsockopt


@extern("C", "SO_REUSEADDR")
public const soReuseaddr = 2


// from "sys/socket.h"

public func setsockopt (
	socket: Int, level: Int,
	option_name: Int, option_value: Ptr,
	option_len: SocklenT
) -> @unused Int




@extern("C", "SOCK_STREAM")
public const sockStream = 1  // stream socket
@extern("C", "SOCK_DGRAM")
public const sockDgram = 2   // datagram socket
@extern("C", "SOCK_RAW")
public const sockRaw = 3     // raw-protocol interface
@extern("C", "SOCK_RDM")
public const sockRdm = 4     // reliably-delivered message
@extern("C", "SOCK_SEQPACKET")
public const sockSeqpacket = 5  // sequenced packet stream
//#ifdef _KERNEL
//const SOCK_TYPE_MASK = 0x000F	// mask that covers the above
//#endif


/*
 * Address families.
 */
public const afUnspec = 0       // unspecified
public const afUnix = 1         // local to host
public const afLocal = afUnix   // draft POSIX compatibility

@extern("C", "AF_INET")
public const afInet = 2         // internetwork: UDP, TCP, etc.

public const afImplink = 3      // arpanet imp addresses
public const afPup = 4          // pup protocols: e.g. BSP
public const afChaos = 5        // mit CHAOS protocols
public const afNs = 6           // XEROX NS protocols
public const afIso = 7          // ISO protocols
public const afOsi = afIso      // OSI protocols
public const afEcma = 8         // european computer manufacturers
public const afDatakit = 9      // datakit protocols
public const afCcitt = 10       // CCITT protocols, X.25 etc
public const afSna = 11         // IBM SNA
public const afDecnet = 12      // DECnet
public const afDli = 13         // DEC Direct data link interface
public const afLat = 14         // LAT
public const afHylink = 15      // NSC Hyperchannel
public const afAppletalk = 16   // Apple Talk
public const afRoute = 17       // Internal Routing Protocol
public const afLink = 18        // Link layer interface
public const pseudoAfXtp = 19   // eXpress Transfer Protocol (no AF)
public const afCoip = 20        // connection-oriented IP, aka ST II
public const afCnt = 21         // Computer Network Technology
public const pseudoAfRtip = 22  // Help Identify RTIP packets
public const afIpx = 23         // Novell Internet Protocol
public const afInet6 = 24       // IPv6
public const pseudoAfPip = 25   // Help Identify PIP packets
public const afIsdn = 26        // Integrated Services Digital Network*/
public const afE164 = afIsdn    // CCITT E.164 recommendation
public const afNatm = 27        // native ATM access
public const afEncap = 28       //
public const afSip = 29         // Simple Internet Protocol
public const afKey = 30
// Used by BPF to not rewrite headers
// in interface output routine
public const pseudoAfHdrcmplt = 31
public const afBluetooth = 32     // Bluetooth
public const afMpls = 33          // MPLS
public const pseudoAfPflow = 34   // pflow
public const pseudoAfPipex = 35   // PIPEX
public const afMax = 36


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


