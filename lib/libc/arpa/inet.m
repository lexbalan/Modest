// arpa/inet

pragma do_not_include
pragma module_nodecorate
pragma c_include "arpa/inet.h"


public func htonl(host32: Word32) -> Word32
public func ntohl(net32: Word32) -> Word32
public func ntohs(net16: Word16) -> Word16

public func htons(x: Word16) -> Word16 {
	return (x << 8) or (x >> 8)
}


//public func inet_addr (cp: *[]Char8) -> in_adr_t
//public func inet_lnaof (in: struct in_addr) -> in_adr_t
//public func inet_makeaddr (net: in_addr_t, lna: in_addr_t) -> struct in_addr
//public func inet_netof (in: struct in_addr) -> in_adr_t
//public func inet_network (cp: *[]Char8) -> in_adr_t
//public func inet_ntoa (in: struct in_addr) -> *[]Char

