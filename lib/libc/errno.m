// libc/errno.m

$pragma module_nodecorate


export {
	/*
	 * Error codes
	 */
	let ePERM = 1     // Operation not permitted
	let eNOENT = 2    // No such file or directory
	let eSRCH = 3     // No such process
	let eINTR = 4     // Interrupted system call
	let eIO = 5       // Input/output error
	let eNXIO = 6     // Device not configured
	let e2BIG = 7     // Argument list too long
	let eNOEXEC = 8   // Exec format error
	let eBADF = 9     // Bad file descriptor
	let eCHILD = 10   // No child processes
	let eDEADLK = 11  // Resource deadlock avoided
					  // 11 was EAGAIN
	let eNOMEM = 12   // Cannot allocate memory
	let eACCES = 13   // Permission denied
	let eFAULT = 14   // Bad address

	//let eNOTBLK = 15  // Block device required

	let eBUSY = 16    // Device / Resource busy
	let eEXIST = 17   // File exists
	let eXDEV = 18    // Cross-device link
	let eNODEV = 19   // Operation not supported by device
	let eNOTDIR = 20  // Not a directory
	let eISDIR = 21   // Is a directory
	let eINVAL = 22   // Invalid argument
	let eNFILE = 23   // Too many open files in system
	let eMFILE = 24   // Too many open files
	let eNOTTY = 25   // Inappropriate ioctl for device
	let eTXTBSY = 26  // Text file busy
	let eFBIG = 27    // File too large
	let eNOSPC = 28   // No space left on device
	let eSPIPE = 29   // Illegal seek
	let eROFS = 30    // Read-only file system
	let eMLINK = 31   // Too many links
	let ePIPE = 32    // Broken pipe

	/* math software */
	let eDOM = 33     // Numerical argument out of domain
	let eRANGE = 34   // Result too large

	/* non-blocking and interrupt i/o */
	let eAGAIN = 35           // Resource temporarily unavailable
	let eWOULDBLOCK = EAGAIN  // Operation would block
	let eINPROGRESS = 36      // Operation now in progress
	let eALREADY = 37         // Operation already in progress

	/* ipc/network software -- argument errors */
	let eNOTSOCK = 38         // Socket operation on non-socket
	let eDESTADDRREQ = 39     // Destination address required
	let eMSGSIZE = 40         // Message too long
	let ePROTOTYPE = 41       // Protocol wrong type for socket
	let eNOPROTOOPT = 42      // Protocol not available
	let ePROTONOSUPPORT = 43  // Protocol not supported

	//let eSOCKTNOSUPPORT = 44  // Socket type not supported

	let eNOTSUP = 45  // Operation not supported

	//let ePFNOSUPPORT = 46  // Protocol family not supported

	let eAFNOSUPPORT = 47   // Address family not supported by protocol family
	let eADDRINUSE = 48     // Address already in use
	let eADDRNOTAVAIL = 49  // Can't assign requested address

	/* ipc/network software -- operational errors */
	let eNETDOWN = 50      // Network is down
	let eNETUNREACH = 51   // Network is unreachable
	let eNETRESET = 52     // Network dropped connection on reset
	let eCONNABORTED = 53  // Software caused connection abort
	let eCONNRESET = 54    // Connection reset by peer
	let eNOBUFS = 55       // No buffer space available
	let eISCONN = 56       // Socket is already connected
	let eNOTCONN = 57      // Socket is not connected
	//let eSHUTDOWN = 58   // Can't send after socket shutdown
	//let eTOOMANYREFS = 59  // Too many references: can't splice
	let eTIMEDOUT = 60       // Operation timed out
	let eCONNREFUSED = 61    // Connection refused

	let eLOOP = 62     // Too many levels of symbolic links
	let eNAMETOOLONG = 63  // File name too long

	/* should be rearranged */
	let eHOSTDOWN = 64     // Host is down
	let eHOSTUNREACH = 65  // No route to host
	let eNOTEMPTY = 66     // Directory not empty

	/* quotas & mush */
	//let ePROCLIM = 67  // Too many processes
	//let eUSERS = 68    // Too many users
	let eDQUOT = 69      // Disc quota exceeded

	/* Network File System */
	let eSTALE = 70  // Stale NFS file handle
	//let eREMOTE = 71  // Too many levels of remote in path
	//let eBADRPC = 72  // RPC struct is bad
	//let eRPCMISMATCH = 73   // RPC version wrong
	//let ePROGUNAVAIL = 74   // RPC prog. not avail
	//let ePROGMISMATCH = 75  // Program version wrong
	//let ePROCUNAVAIL = 76   // Bad procedure for program

	let eNOLCK = 77  // No locks available
	let eNOSYS = 78  // Function not implemented

	//let eFTYPE = 79     // Inappropriate file type or format
	//let eAUTH = 80      // Authentication error
	//let eNEEDAUTH = 81  // Need authenticator
	//
	///* Intelligent device errors */
	//let ePWROFF = 82  // Device power is off
	//let eDEVERR = 83  // Device error, e.g. paper out

	let eOVERFLOW = 84  // Value too large to be stored in data type

	/* Program loading errors */
	//let eBADEXEC = 85    // Bad executable
	//let eBADARCH = 86    // Bad CPU type in executable
	//let eSHLIBVERS = 87  // Shared library version mismatch
	//let eBADMACHO = 88   // Malformed Macho file

	let eCANCELED = 89  // Operation canceled

	let eIDRM = 90   // Identifier removed
	let eNOMSG = 91  // No message of desired type
	let eILSEQ = 92  // Illegal byte sequence

	//let eNOATTR = 93  // Attribute not found

	let eBADMSG = 94    // Bad message
	let eMULTIHOP = 95  // Reserved
	let eNODATA = 96    // No message available on STREAM
	let eNOLINK = 97    // Reserved
	let eNOSR = 98      // No STREAM resources
	let eNOSTR = 99     // Not a STREAM
	let ePROTO = 100    // Protocol error
	let eTIME = 101     // STREAM ioctl timeout

	/* This value is only discrete when compiling __DARWIN_UNIX03, or KERNEL */
	let eOPNOTSUPP = 102  // Operation not supported on socket
	let eNOPOLICY = 103   // No such policy registered

	/* pseudo-errors returned inside kernel to modify return to process */
	let eRESTART = -1     // restart syscall
	let eJUSTRETURN = -2  // don't modify regs, just return
}

