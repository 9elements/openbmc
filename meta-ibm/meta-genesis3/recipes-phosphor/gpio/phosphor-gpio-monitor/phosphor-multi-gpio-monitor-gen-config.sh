#!/bin/bash
# shellcheck disable=SC2046

function process_gpio() {
  LINE=$1
  ITEM=$2
  BIAS=$3
  # word splitting is required
  if [ "$(gpioget -B "${BIAS}" $(gpiofind "${LINE}") 2>/dev/null||echo 1)" -eq 0 ]; then
    systemctl --no-block start "dbus-object-present@${ITEM}.service"
  else
    systemctl --no-block start "dbus-object-remove@${ITEM}.service"
  fi
}

for i in a0 a1 b0 b1 c0 c1 d0 d1 e0 e1 f0 f1 g0 g1 h0 h1 j0 j1 k0 k1 l0 l1 m0 m1 n0 n1 p0 p1 q0 q1 r0 r1 s0 s1 t0 t1 u0 u1 v0 v1 w0 w1 x0 x1 y0 y1 z0 z1
do
  process_gpio "PLUG_DETECT_DIMM_${i^^}" "system-chassis-motherboard-dimm_${i}" "disable"
done

for i in {1..9}
do
  process_gpio "RSSD0${i}_PRESENT_N" "system-chassis-motherboard-rssd0${i}" "pull-up"
done

for i in {10..32}
do
  process_gpio "RSSD${i}_PRESENT_N" "system-chassis-motherboard-rssd${i}" "pull-up"
done

for i in {0..3}
do
  process_gpio "FM_CPU${i}_SKTOCC_N" "system-chassis-motherboard-cpu${i}" "disable"
done
