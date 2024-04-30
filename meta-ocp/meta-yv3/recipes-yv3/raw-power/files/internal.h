#ifndef INTERNAL_H
#define INTERNAL_H

#include <stdint.h>

#define DEBUG(fmt, ...) \
            do { fprintf(stderr, fmt, __VA_ARGS__); } while (0)

#define BMC_SLAVE_ADDR 0x10
#define BRIDGE_SLAVE_ADDR 0x20
#define ZERO_CKSUM_CONST 0x100
#define LUN_OFFSET 2

// rqSA, rsSA, rqSeq, hdrCksum, dataCksum
#define IPMB_HDR_SIZE 5
#define IPMI_REQ_HDR_SIZE 2

// NetFn, Cmd, CC
#define IPMI_RESP_HDR_SIZE 3

// rqSA, NetFn, hdrCksum
#define IPMB_DATA_OFFSET 3

/*
typedef struct _ipmb_req_t {
  uint8_t res_slave_addr;
  uint8_t netfn_lun;
  uint8_t hdr_cksum;
  uint8_t req_slave_addr;
  uint8_t seq_lun;
  uint8_t cmd;
  uint8_t data[5];
  uint8_t data_chksum;
} ipmb_req_t;
*/


typedef struct _ipmb_req_t {
  uint8_t res_slave_addr;
  uint8_t netfn_lun;
  uint8_t hdr_cksum;
  uint8_t req_slave_addr;
  uint8_t seq_lun;
  uint8_t cmd;
  uint8_t data[1];
  // when using sizeof(ipmb_req_t), add the size of the payload on top,
  // as the [1] is just a placeholder since we don't know
  // uint8_t data_chksum;
  // to add the checksum, do
  // req->data[payload_length] = checksum
} ipmb_req_t;

typedef struct _ipmb_res_t {
  uint8_t req_slave_addr;
  uint8_t netfn_lun;
  uint8_t hdr_cksum;
  uint8_t res_slave_addr;
  uint8_t seq_lun;
  uint8_t cmd;
  uint8_t cc;
  uint8_t data[1];
} ipmb_res_t;


struct ipmb_svc {
	int i2c_fd;
};

/* Helper function to sleep for specified amaount of millisecond
 *
 * @param msec: number of millisecond to sleep
 */
void msleep(int msec);

/* IPMB Handler
 *
 * @param fd         file descriptor of IPMB device
 * @param request    pointer to request struct
 * @param req_len    length of request
 * @param response   pointer to response struct
 * @param res_len    length of response
 *
 */
void ipmb_handle(
        int fd,
        unsigned char* request,
        unsigned short req_len,
        unsigned char* response,
        unsigned char* res_len
        );

/* IPMB write function to send data to satellite
 *
 * @param fd         file descriptor of IPMB device
 * @param buf        pointer to buffer
 * @param len        length of buffer
 *
 * @return 0 on success, -1 on failure
 * */
int ipmb_write(
        int fd,
        uint8_t* buf,
        uint16_t len
        );

/* IPMB write+read function to send data to satellite
 * and read response
 *
 * @param fd         file descriptor of IPMB device
 * @param txbuf        pointer to buffer (write)
 * @param txlen        length of buffer (write)
 * @param rxbuf        pointer to buffer (read)
 * @param rxlen        length of buffer (read)
 *
 * @return 0 on success, -1 on failure
 * */
int ipmb_write_read(int fd, uint8_t* txbuf, uint16_t txlen, uint8_t* rxbuf, uint16_t* rxlen);

/* Bus initializer
 *
 * @param bus_num    i2c bus number to initialize
 *
 * @return file descriptor on success, -1 on failure
 * */
int init_i2c_bus(int bus, struct ipmb_svc* svc);


int i2c_cdev_slave_open(int bus, uint16_t addr);
int i2c_cdev_slave_close(int fd);

#endif
