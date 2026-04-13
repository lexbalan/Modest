/*-----------------------------------------------------------------------*/
/* Low level disk I/O module SKELETON for FatFs     (C)ChaN, 2019        */
/*-----------------------------------------------------------------------*/
/* If a working storage control module is available, it should be        */
/* attached to the FatFs via a glue function rather than modifying it.   */
/* This is an example of glue functions to attach various exsisting      */
/* storage control modules to the FatFs module with a defined API.       */
/*-----------------------------------------------------------------------*/

//
// SEE: mmc.h + mmc_bb.c
//

#include <stdio.h>

#if 1


#include "ff.h"			/* Obtains integer types */
#include "diskio.h"		/* Declarations of disk functions */

/* Definitions of physical drive number for each drive */
#define DEV_RAM		0	/* Example: Map Ramdisk to physical drive 0 */
#define DEV_MMC		1	/* Example: Map MMC/SD card to physical drive 1 */
#define DEV_USB		2	/* Example: Map USB MSD to physical drive 2 */



// virtual disk
#define SECTOR_SIZE 512
#define SECTOR_COUNT 4096
#define BLOCK_SIZE 512
struct sector {
	uint8_t data[SECTOR_SIZE];
};
struct sector disk[SECTOR_COUNT];


/*-----------------------------------------------------------------------*/
/* Get Drive Status                                                      */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status (
	BYTE pdrv		/* Physical drive nmuber to identify the drive */
)
{
	DSTATUS stat = 0;//STA_NOINIT;

	return stat;
}



/*-----------------------------------------------------------------------*/
/* Inidialize a Drive                                                    */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize (
	BYTE pdrv				/* Physical drive nmuber to identify the drive */
)
{
	DSTATUS stat = 0;//STA_NOINIT;

	return stat;
}



/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read (
	BYTE pdrv,		/* Physical drive nmuber to identify the drive */
	BYTE *buff,		/* Data buffer to store read data */
	LBA_t sector,	/* Start sector in LBA */
	UINT count		/* Number of sectors to read */
)
{
	DRESULT res = RES_OK;//RES_PARERR;

	for (UINT i = 0; i < count; i++) {
		__builtin_memcpy(buff, &disk[sector], sizeof(struct sector));
		buff += sizeof(struct sector);
	}

	return res;
}



/*-----------------------------------------------------------------------*/
/* Write Sector(s)                                                       */
/*-----------------------------------------------------------------------*/

#if FF_FS_READONLY == 0

DRESULT disk_write (
	BYTE pdrv,			/* Physical drive nmuber to identify the drive */
	const BYTE *buff,	/* Data to be written */
	LBA_t sector,		/* Start sector in LBA */
	UINT count			/* Number of sectors to write */
)
{
	DRESULT res = RES_OK;//RES_PARERR;

	for (UINT i = 0; i < count; i++) {
		__builtin_memcpy(&disk[sector], buff, sizeof(struct sector));
		buff += sizeof(struct sector);
	}

	return res;
}

#endif



/*-----------------------------------------------------------------------*/
/* Miscellaneous Functions                                               */
/*-----------------------------------------------------------------------*/

DRESULT disk_ioctl (
	BYTE pdrv,		/* Physical drive nmuber (0..) */
	BYTE cmd,		/* Control code */
	void *buff		/* Buffer to send/receive control data */
)
{
	DRESULT res = RES_OK;//RES_PARERR;

	printf("call disk_ioctl (%d)\n", cmd);

	switch (cmd) {
		case GET_SECTOR_SIZE: *((uint32_t *)buff) = SECTOR_SIZE; break;
		case GET_SECTOR_COUNT: *((uint32_t *)buff) = SECTOR_COUNT; break;
		case GET_BLOCK_SIZE: *((uint32_t *)buff) = 1; break;
	}

	return res;
}

#endif
