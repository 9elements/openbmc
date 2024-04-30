#include <stdlib.h>
#include <stdint.h>
#include <cerrno>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "raw_power.h"
#include "internal.h"
#include "bic.h"

int raw_power_bic_ipmb_wrapper(int fd, uint8_t netfn, uint8_t cmd,
                     uint8_t* txbuf, size_t txlen, uint8_t* rxbuf,
                     size_t* rxlen) {
  #define MAX_IPMB_RES_LEN 1024
  uint16_t tlen;
  uint16_t rlen = *rxlen;
  uint8_t rbuf[MAX_IPMB_RES_LEN] = {0};
  uint8_t tbuf[MAX_IPMB_RES_LEN] = {0};
  ipmb_req_t* req = (ipmb_req_t*)tbuf;
  ipmb_res_t* res = (ipmb_res_t*)rbuf;

  if (txlen) {
    if ((txbuf == NULL) ||
        (IPMB_HDR_SIZE + IPMI_REQ_HDR_SIZE + txlen > sizeof(tbuf))) {
      errno = EINVAL;
      return -1;
    }
    memcpy(req->data, txbuf, txlen);
  }
  req->res_slave_addr = BRIDGE_SLAVE_ADDR << 1;
  req->netfn_lun = netfn << LUN_OFFSET;
  req->hdr_cksum = req->res_slave_addr + req->netfn_lun;
  req->hdr_cksum = ZERO_CKSUM_CONST - req->hdr_cksum;
  req->req_slave_addr = BMC_SLAVE_ADDR << 1;
  req->seq_lun = 0x00;
  req->cmd = cmd;

  // Invoke IPMB library handler
  tlen = IPMB_HDR_SIZE + IPMI_REQ_HDR_SIZE + txlen;

  if (ipmb_write_read(fd, tbuf, tlen, rbuf, &rlen) != 0) {
  //if (lib_ipmb_handle(slot_id, tbuf, tlen, rbuf, &rlen) != 0) {
    return -1;
  }

  // Handle IPMB response
  if (res->cc) {
    fprintf(stderr, "response has nonzero CC (Completion Code)\n");
    return -1;
  }

  if (rlen < (IPMB_HDR_SIZE + IPMI_RESP_HDR_SIZE)) {
    errno = EBADMSG;
    return -1;
  }

  // copy the received data back to caller
  if (rxbuf != NULL && rxlen != NULL) {
    rlen -= (IPMB_HDR_SIZE + IPMI_RESP_HDR_SIZE);
    if (rlen > *rxlen) {
      printf("%s: rxbuf truncated: expect %u, actual %u", __func__,
                rlen, *rxlen);
      rlen = *rxlen;
    }
    *rxlen = rlen;
    memcpy(rxbuf, res->data, *rxlen);
  }
  return 0;
}
