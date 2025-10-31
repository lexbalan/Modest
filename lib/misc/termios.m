// libc/termios.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "termios.h"


type Int Int32
type Nat Nat32
type CC_T Char8 //Char
type SpeedT Nat //UnsignedInt
type TCFlagT Word32


// Special Control Characters
public const c_VEOF = 0     // ICANON
public const c_VEOL = 1     // ICANON
public const c_VERASE = 3   // ICANON
public const c_VKILL = 5    // ICANON
public const c_VINTR = 8    // ISIG
public const c_VQUIT = 9    // ISIG
public const c_VSUSP = 10   // ISIG
public const c_VSTART = 12  // IXON, IXOFF
public const c_VSTOP = 13   // IXON, IXOFF
public const c_VMIN = 16    // !ICANON
public const c_VTIME = 17   // !ICANON


// Input flags - software input processing
public const c_IGNBRK = 0x00000001  // ignore BREAK condition
public const c_BRKINT = 0x00000002  // map BREAK to SIGINT
public const c_IGNPAR = 0x00000004  // ignore (discard) parity errors
public const c_PARMRK = 0x00000008  // mark parity and framing errors
public const c_INPCK = 0x00000010   // enable checking of parity errors
public const c_ISTRIP = 0x00000020  // strip 8th bit off chars
public const c_INLCR = 0x00000040   // map NL into CR
public const c_IGNCR = 0x00000080   // ignore CR
public const c_ICRNL = 0x00000100   // map CR to NL (ala CRMOD)
public const c_IXON = 0x00000200    // enable output flow control
public const c_IXOFF = 0x00000400   // enable input flow control


// Output flags - software output processing

public const c_OPOST = 0x00000001   // enable following output processing


// Control flags - hardware control of terminal

public const c_CSIZE = 0x00000300   // character size mask
public const c_CS5 = 0x00000000     // 5 bits (pseudo)
public const c_CS6 = 0x00000100     // 6 bits
public const c_CS7 = 0x00000200     // 7 bits
public const c_CS8 = 0x00000300     // 8 bits
public const c_CSTOPB = 0x00000400  // send 2 stop bits
public const c_CREAD = 0x00000800   // enable receiver
public const c_PARENB = 0x00001000  // parity enable
public const c_PARODD = 0x00002000  // odd parity, else even
public const c_HUPCL = 0x00004000   // hang up on last close
public const c_CLOCAL = 0x00008000  // ignore modem status lines

public const c_ECHOE = 0x00000002   // visually erase chars
public const c_ECHOK = 0x00000004   // echo NL after line kill
public const c_ECHO = 0x00000008    // enable echoing
public const c_ECHONL = 0x00000010  // echo NL even if ECHO is off
public const c_ISIG = 0x00000080    // enable signals INTR, QUIT, [D]SUSP
public const c_ICANON = 0x00000100  // canonicalize input lines
public const c_IEXTEN = 0x00000400  // enable DISCARD and LNEXT
public const c_EXTPROC = 0x00000800 // external processing
public const c_TOSTOP = 0x00400000  // stop background jobs from output
public const c_NOFLSH = 0x80000000  // don't flush after interrupt


const c_NCCS = 20

public type Termios record {
	public c_iflag:  TCFlagT       // input flags
	public c_oflag:  TCFlagT       // output flags
	public c_cflag:  TCFlagT       // control flags
	public c_lflag:  TCFlagT       // local flags
	public c_cc:     [c_NCCS]CC_T  // control chars
	public c_ispeed: Int           // input speed
	public c_ospeed: Int           // output speed
}


// Commands passed to tcsetattr() for setting the termios structure
public const c_TCSANOW = 0    // make change immediate
public const c_TCSADRAIN = 1  // drain output, then change
public const c_TCSAFLUSH = 2  // drain output, flush input


// Standard speeds

public const c_B0 = 0
public const c_B50 = 50
public const c_B75 = 75
public const c_B110 = 110
public const c_B134 = 134
public const c_B150 = 150
public const c_B200 = 200
public const c_B300 = 300
public const c_B600 = 600
public const c_B1200 = 1200
public const c_B1800 = 1800
public const c_B2400 = 2400
public const c_B4800 = 4800
public const c_B7200 = 7200
public const c_B9600 = 9600
public const c_B14400 = 14400
public const c_B19200 = 19200
public const c_B28800 = 28800
public const c_B38400 = 38400
public const c_B57600 = 57600
public const c_B76800 = 76800
public const c_B115200 = 115200
public const c_B230400 = 230400
public const c_B460800 = 460800
public const c_B500000 = 500000
public const c_B576000 = 576000
public const c_B921600 = 921600
public const c_B1000000 = 1000000
public const c_B1152000 = 1152000
public const c_B1500000 = 1500000
public const c_B2000000 = 2000000
public const c_B2500000 = 2500000
public const c_B3000000 = 3000000
public const c_B3500000 = 3500000
public const c_B4000000 = 4000000


public const c_TCIFLUSH = 1
public const c_TCOFLUSH = 2
public const c_TCIOFLUSH = 3
public const c_TCOOFF = 1
public const c_TCOON = 2
public const c_TCIOFF = 3
public const c_TCION = 4


public func cfgetispeed(termios: *Termios) -> SpeedT
public func cfgetospeed(termios: *Termios) -> SpeedT
public func cfsetispeed(termios: *Termios, speed: SpeedT) -> Int
public func cfsetospeed(termios: *Termios, speed: SpeedT) -> Int
public func tcgetattr(fd: Int, termios: *Termios) -> Int
public func tcsetattr(fd: Int, opt_act: Int, termios: *Termios) -> Int
public func tcdrain(fd: Int) -> Int
public func tcflow(fd: Int, act: Int) -> Int
public func tcflush(fd: Int, queue_selector: Int) -> Int
public func tcsendbreak(fd: Int, duration: Int) -> Int
//public func tcgetsid(fd: Int) -> PidT


