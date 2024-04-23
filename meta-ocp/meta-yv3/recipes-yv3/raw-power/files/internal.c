#include <errno.h>
#include <fcntl.h>
#include "internal.h"
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <linux/limits.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <time.h>
#include <unistd.h>

#include "print_buffer.h"

#define I2C_RETRIES_MAX 15
#define I2C_RETRY_DELAY 20 /* unit: millisecond */

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

	printf("raw request:\n");
	print_buffer(request, req_len);

	data.msgs = &msg;
	data.nmsgs = 1;

	while ((rc = ioctl(fd, I2C_RDWR, &data)) < 0 && ++i < I2C_RETRIES_MAX) {
		msleep(I2C_RETRY_DELAY);
	}
	if (rc < 0) {
		DEBUG("Error %d: Failed to send %u bytes to device @%#x\n", errno,
		      req_len, msg.addr);
		return -1;
	}

	DEBUG("Successfully send i2c request to @%#x\n", data.msgs->addr);
	return 0;
}

int init_i2c_bus(int bus, struct ipmb_svc *svc)
{
	// open the service i2c bus
	svc->i2c_fd = i2c_cdev_slave_open(bus, BRIDGE_SLAVE_ADDR);
	return 0;
}

int i2c_cdev_slave_open(int bus, uint16_t addr)
{
	int fd;
	unsigned long request;
	char cdev_path[PATH_MAX];

	snprintf(cdev_path, sizeof(cdev_path), "/dev/i2c-%d", bus);

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
		fprintf(stderr, "Error: %d in i2c_cdev_slave_open, ioctl operation\n",
		      errno);
		return -1;
	}

	// check required functions
	unsigned long funcs;
	if (ioctl(fd, I2C_FUNCS, &funcs) < 0){
		fprintf(stderr, "Error requesting I2C_FUNCS\n");
		return -1;
	}
	if((funcs & I2C_FUNC_I2C) == 0) {
		fprintf(stderr, "Error: adapter does not support I2C_FUNCS_I2C\n");
		return -1;
	}

	return fd;
}

int i2c_cdev_slave_close(int fd)
{
	return close(fd);
}
