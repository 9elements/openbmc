#include <errno.h>
#include <fcntl.h>
#include "internal.h"
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <linux/limits.h>
#include <stdio.h>
// #include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <time.h>
#include <unistd.h>

#define I2C_RETRIES_MAX 15
#define I2C_RETRY_DELAY 20 /* unit: millisecond */

// void ipmb_handle(int fd, unsigned char *request, unsigned short req_len,
// 		 unsigned char *response, unsigned char *res_len)
// {
// 	ipmb_req_t *req = (ipmb_req_t *)request;
// 	int i, ret;
// 	uint16_t addr = 0;
//
// 	req->req_slave_addr = addr << 1;
//
// 	// Calculate/update header Cksum
// 	req->hdr_cksum = req->res_slave_addr + req->netfn_lun;
// 	req->hdr_cksum = ZERO_CKSUM_CONST - req->hdr_cksum;
//
// 	// Calculate/update dataCksum
// 	// Note: dataCkSum byte is last byte
// 	request[req_len - 1] = 0;
//
// 	ipmb_write(fd, request, req_len);
// }

void msleep(int msec)
{
	struct timespec req;

	req.tv_sec = 0;
	req.tv_nsec = msec * 1000 * 1000;

	while (nanosleep(&req, &req) == -1 && errno == EINTR) {
		continue;
	}
}

int ipmb_write(int fd, unsigned char *request, unsigned short req_len)
{
	struct i2c_rdwr_ioctl_data data;
	struct i2c_msg msg;
	int rc;
	int i = 0;

	memset(&msg, 0, sizeof(msg));

	msg.addr = request[0] >> 1;

	msg.flags = 0;
	msg.len = req_len - 1; // 1st byte in addr
	msg.buf = &request[1];

	data.msgs = &msg;
	data.nmsgs = 1;

	while ((rc = ioctl(fd, I2C_RDWR, &data)) < 0 && ++i < I2C_RETRIES_MAX) {
		msleep(I2C_RETRY_DELAY);
	}
	if (rc < 0) {
		DEBUG("Error %d: Failed to send %u bytes to device @%#x", errno,
		      req_len, msg.addr);
		return -1;
	}

	DEBUG("Successfully send i2c request to @%#x", data.msgs->addr);
	return 0;
}

int init_i2c_bus(int bus, struct ipmb_svc *svc)
{
	// open the service i2c bus
	svc->i2c_fd = i2c_cdev_slave_open(bus, BRIDGE_SLAVE_ADDR);
	return 0;
}

char *i2c_cdev_master_abspath(char *buf, size_t size, int bus)
{
	snprintf(buf, size, "/dev/i2c-%d", bus);
	return buf;
}

int i2c_cdev_slave_open(int bus, uint16_t addr)
{
	int fd;
	unsigned long request;
	char cdev_path[PATH_MAX];

	i2c_cdev_master_abspath(cdev_path, sizeof(cdev_path), bus);
	fd = open(cdev_path, O_RDWR);
	if (fd < 0) {
		DEBUG("Error %d in i2c_cdev_slave_open: Failed to open i2c device",
		      fd);
		return -1;
	}

	request = I2C_SLAVE;
	if (ioctl(fd, request, addr) < 0) {
		int save_errno = errno;
		close(fd); /* ignore errors */
		errno = save_errno;
		DEBUG("Error: %d in i2c_cdev_slave_open, ioctl operation\n",
		      errno);
		return -1;
	}

	return fd;
}

int i2c_cdev_slave_close(int fd)
{
	return close(fd);
}
