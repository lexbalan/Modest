
$pragma module_nodecorate


/*
 * Error codes
 */
export let ePERM = 1     // Operation not permitted
export let eNOENT = 2    // No such file or directory
export let eSRCH = 3     // No such process
export let eINTR = 4     // Interrupted system call
export let eIO = 5       // Input/output error
export let eNXIO = 6     // Device not configured
export let e2BIG = 7     // Argument list too long
export let eNOEXEC = 8   // Exec format error
export let eBADF = 9     // Bad file descriptor
export let eCHILD = 10   // No child processes
export let eDEADLK = 11  // Resource deadlock avoided
                  // 11 was EAGAIN
export let eNOMEM = 12   // Cannot allocate memory
export let eACCES = 13   // Permission denied
export let eFAULT = 14   // Bad address

//export let eNOTBLK = 15  // Block device required

export let eBUSY = 16    // Device / Resource busy
export let eEXIST = 17   // File exists
export let eXDEV = 18    // Cross-device link
export let eNODEV = 19   // Operation not supported by device
export let eNOTDIR = 20  // Not a directory
export let eISDIR = 21   // Is a directory
export let eINVAL = 22   // Invalid argument
export let eNFILE = 23   // Too many open files in system
export let eMFILE = 24   // Too many open files
export let eNOTTY = 25   // Inappropriate ioctl for device
export let eTXTBSY = 26  // Text file busy
export let eFBIG = 27    // File too large
export let eNOSPC = 28   // No space left on device
export let eSPIPE = 29   // Illegal seek
export let eROFS = 30    // Read-only file system
export let eMLINK = 31   // Too many links
export let ePIPE = 32    // Broken pipe

/* math software */
export let eDOM = 33     // Numerical argument out of domain
export let eRANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
export let eAGAIN = 35           // Resource temporarily unavailable
export let eWOULDBLOCK = EAGAIN  // Operation would block
export let eINPROGRESS = 36      // Operation now in progress
export let eALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
export let eNOTSOCK = 38         // Socket operation on non-socket
export let eDESTADDRREQ = 39     // Destination address required
export let eMSGSIZE = 40         // Message too long
export let ePROTOTYPE = 41       // Protocol wrong type for socket
export let eNOPROTOOPT = 42      // Protocol not available
export let ePROTONOSUPPORT = 43  // Protocol not supported

//export let eSOCKTNOSUPPORT = 44  // Socket type not supported

export let eNOTSUP = 45  // Operation not supported

//export let ePFNOSUPPORT = 46  // Protocol family not supported

export let eAFNOSUPPORT = 47   // Address family not supported by protocol family
export let eADDRINUSE = 48     // Address already in use
export let eADDRNOTAVAIL = 49  // Can't assign requested address

/* ipc/network software -- operational errors */
export let eNETDOWN = 50      // Network is down
export let eNETUNREACH = 51   // Network is unreachable
export let eNETRESET = 52     // Network dropped connection on reset
export let eCONNABORTED = 53  // Software caused connection abort
export let eCONNRESET = 54    // Connection reset by peer
export let eNOBUFS = 55       // No buffer space available
export let eISCONN = 56       // Socket is already connected
export let eNOTCONN = 57      // Socket is not connected
//export let eSHUTDOWN = 58   // Can't send after socket shutdown
//export let eTOOMANYREFS = 59  // Too many references: can't splice
export let eTIMEDOUT = 60       // Operation timed out
export let eCONNREFUSED = 61    // Connection refused

export let eLOOP = 62     // Too many levels of symbolic links
export let eNAMETOOLONG = 63  // File name too long

/* should be rearranged */
export let eHOSTDOWN = 64     // Host is down
export let eHOSTUNREACH = 65  // No route to host
export let eNOTEMPTY = 66     // Directory not empty

/* quotas & mush */
//export let ePROCLIM = 67  // Too many processes
//export let eUSERS = 68    // Too many users
export let eDQUOT = 69      // Disc quota exceeded

/* Network File System */
export let eSTALE = 70  // Stale NFS file handle
//export let eREMOTE = 71  // Too many levels of remote in path
//export let eBADRPC = 72  // RPC struct is bad
//export let eRPCMISMATCH = 73   // RPC version wrong
//export let ePROGUNAVAIL = 74   // RPC prog. not avail
//export let ePROGMISMATCH = 75  // Program version wrong
//export let ePROCUNAVAIL = 76   // Bad procedure for program

export let eNOLCK = 77  // No locks available
export let eNOSYS = 78  // Function not implemented

//export let eFTYPE = 79     // Inappropriate file type or format
//export let eAUTH = 80      // Authentication error
//export let eNEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//export let ePWROFF = 82  // Device power is off
//export let eDEVERR = 83  // Device error, e.g. paper out


export let eOVERFLOW = 84  // Value too large to be stored in data type

/* Program loading errors */
//export let eBADEXEC = 85    // Bad executable
//export let eBADARCH = 86    // Bad CPU type in executable
//export let eSHLIBVERS = 87  // Shared library version mismatch
//export let eBADMACHO = 88   // Malformed Macho file


export let eCANCELED = 89  // Operation canceled

export let eIDRM = 90   // Identifier removed
export let eNOMSG = 91  // No message of desired type
export let eILSEQ = 92  // Illegal byte sequence

//export let eNOATTR = 93  // Attribute not found


export let eBADMSG = 94    // Bad message
export let eMULTIHOP = 95  // Reserved
export let eNODATA = 96    // No message available on STREAM
export let eNOLINK = 97    // Reserved
export let eNOSR = 98      // No STREAM resources
export let eNOSTR = 99     // Not a STREAM
export let ePROTO = 100    // Protocol error
export let eTIME = 101     // STREAM ioctl timeout

/* This value is only discrete when compiling __DARWIN_UNIX03, or KERNEL
export let eOPNOTSUPP = 102  // Operation not supported on socket

export let eNOPOLICY = 103  // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process
export let eRESTART = -1   // restart syscall
export let eJUSTRETURN = -2  // don't modify regs, just return


