#ifndef __oneOS__DRIVERS__ATA_H
#define __oneOS__DRIVERS__ATA_H

#include <types.h>
#include <x86/port.h>
#include <drivers/display.h>
#include <mem/malloc.h>

typedef struct {                 // LBA28 | LBA48
    uint32_t data_port;          // 16bit | 16 bits
    uint32_t error_port;         // 8 bit | 16 bits
    uint32_t sector_count_port;  // 8 bit | 16 bits
    uint32_t lba_lo_port;        // 8 bit | 16 bits
    uint32_t lba_mid_port;       // 8 bit | 16 bits
    uint32_t lba_hi_port;        // 8 bit | 16 bits
    uint32_t device_port;        // 8 bit
    uint32_t command_port;       // 8 bit
    uint32_t control_port;       // 8 bit
    char is_master;
} ata_t;

void init_ata(ata_t *ata, uint32_t port, char is_master);
void indentify_ata_device(ata_t *ata);
void ata_write(ata_t *dev, char *data, int size);
void ata_read(ata_t *dev, uint32_t sectorNum, uint8_t *read_data);
void ata_flush(ata_t *dev);

#endif
