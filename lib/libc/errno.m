// libc/errno.m

pragma module_nodecorate


/*
 * Error codes
 */
public const ePERM = 1     // Operation not permitted
public const eNOENT = 2    // No such file or directory
public const eSRCH = 3     // No such process
public const eINTR = 4     // Interrupted system call
public const eIO = 5       // Input/output error
public const eNXIO = 6     // Device not configured
public const e2BIG = 7     // Argument list too long
public const eNOEXEC = 8   // Exec format error
public const eBADF = 9     // Bad file descriptor
public const eCHILD = 10   // No child processes
public const eDEADLK = 11  // Resource deadlock avoided
					  // 11 was EAGAIN
public const eNOMEM = 12   // Cannot allocate memory
public const eACCES = 13   // Permission denied
public const eFAULT = 14   // Bad address

//public const eNOTBLK = 15  // Block device required

public const eBUSY = 16    // Device / Resource busy
public const eEXIST = 17   // File exists
public const eXDEV = 18    // Cross-device link
public const eNODEV = 19   // Operation not supported by device
public const eNOTDIR = 20  // Not a directory
public const eISDIR = 21   // Is a directory
public const eINVAL = 22   // Invalid argument
public const eNFILE = 23   // Too many open files in system
public const eMFILE = 24   // Too many open files
public const eNOTTY = 25   // Inappropriate ioctl for device
public const eTXTBSY = 26  // Text file busy
public const eFBIG = 27    // File too large
public const eNOSPC = 28   // No space left on device
public const eSPIPE = 29   // Illegal seek
public const eROFS = 30    // Read-only file system
public const eMLINK = 31   // Too many links
public const ePIPE = 32    // Broken pipe

/* math software */
public const eDOM = 33     // Numerical argument out of domain
public const eRANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
public const eAGAIN = 35           // Resource temporarily unavailable
public const eWOULDBLOCK = eAGAIN  // Operation would block
public const eINPROGRESS = 36      // Operation now in progress
public const eALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
public const eNOTSOCK = 38         // Socket operation on non-socket
public const eDESTADDRREQ = 39     // Destination address required
public const eMSGSIZE = 40         // Message too long
public const ePROTOTYPE = 41       // Protocol wrong type for socket
public const eNOPROTOOPT = 42      // Protocol not available
public const ePROTONOSUPPORT = 43  // Protocol not supported

//public const eSOCKTNOSUPPORT = 44  // Socket type not supported

public const eNOTSUP = 45  // Operation not supported

//public const ePFNOSUPPORT = 46  // Protocol family not supported

public const eAFNOSUPPORT = 47   // Address family not supported by protocol family
public const eADDRINUSE = 48     // Address already in use
public const eADDRNOTAVAIL = 49  // Can't assign requested address

/* ipc/network software -- operational errors */
public const eNETDOWN = 50      // Network is down
public const eNETUNREACH = 51   // Network is unreachable
public const eNETRESET = 52     // Network dropped connection on reset
public const eCONNABORTED = 53  // Software caused connection abort
public const eCONNRESET = 54    // Connection reset by peer
public const eNOBUFS = 55       // No buffer space available
public const eISCONN = 56       // Socket is already connected
public const eNOTCONN = 57      // Socket is not connected
//public const eSHUTDOWN = 58   // Can't send after socket shutdown
//public const eTOOMANYREFS = 59  // Too many references: can't splice
public const eTIMEDOUT = 60       // Operation timed out
public const eCONNREFUSED = 61    // Connection refused

public const eLOOP = 62     // Too many levels of symbolic links
public const eNAMETOOLONG = 63  // File name too long

/* should be rearranged */
public const eHOSTDOWN = 64     // Host is down
public const eHOSTUNREACH = 65  // No route to host
public const eNOTEMPTY = 66     // Directory not empty

/* quotas & mush */
//public const ePROCLIM = 67  // Too many processes
//public const eUSERS = 68    // Too many users
public const eDQUOT = 69      // Disc quota exceeded

/* Network File System */
public const eSTALE = 70  // Stale NFS file handle
//public const eREMOTE = 71  // Too many levels of remote in path
//public const eBADRPC = 72  // RPC struct is bad
//public const eRPCMISMATCH = 73   // RPC version wrong
//public const ePROGUNAVAIL = 74   // RPC prog. not avail
//public const ePROGMISMATCH = 75  // Program version wrong
//public const ePROCUNAVAIL = 76   // Bad procedure for program

public const eNOLCK = 77  // No locks available
public const eNOSYS = 78  // Function not implemented

//public const eFTYPE = 79     // Inappropriate file type or format
//public const eAUTH = 80      // Authentication error
//public const eNEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//public const ePWROFF = 82  // Device power is off
//public const eDEVERR = 83  // Device error, e.g. paper out

public const eOVERFLOW = 84  // Value too large to be stored in data type

/* Program loading errors */
//public const eBADEXEC = 85    // Bad executable
//public const eBADARCH = 86    // Bad CPU type in executable
//public const eSHLIBVERS = 87  // Shared library version mismatch
//public const eBADMACHO = 88   // Malformed Macho file

public const eCANCELED = 89  // Operation canceled

public const eIDRM = 90   // Identifier removed
public const eNOMSG = 91  // No message of desired type
public const eILSEQ = 92  // Illegal byte sequence

//public const eNOATTR = 93  // Attribute not found

public const eBADMSG = 94    // Bad message
public const eMULTIHOP = 95  // Reserved
public const eNODATA = 96    // No message available on STREAM
public const eNOLINK = 97    // Reserved
public const eNOSR = 98      // No STREAM resources
public const eNOSTR = 99     // Not a STREAM
public const ePROTO = 100    // Protocol error
public const eTIME = 101     // STREAM ioctl timeout

/* This value is only discrete when compiling __DARWIN_UNIX03, or KERNEL */
public const eOPNOTSUPP = 102  // Operation not supported on socket
public const eNOPOLICY = 103   // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process */
public const eRESTART = -1     // restart syscall
public const eJUSTRETURN = -2  // don't modify regs, just return

