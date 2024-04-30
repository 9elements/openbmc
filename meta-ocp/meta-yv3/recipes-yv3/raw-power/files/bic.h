#ifndef RAW_POWER_BIC_H
#define RAW_POWER_BIC_H


/*
 * NOTE:
 *   - callers need to set "rxlen" to "rxbuf" size to avoid buffer
 *     overflow.
 *   - if the function returns successfully, "rxlen" would be set to the
 *     actual response length.
 */
int raw_power_bic_ipmb_wrapper(int fd, uint8_t netfn, uint8_t cmd,
                     uint8_t* txbuf, size_t txlen, uint8_t* rxbuf,
                     size_t* rxlen);

#endif
