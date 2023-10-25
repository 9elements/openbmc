#!/bin/bash
# Parser for Intel Xeon PIROM

FILE=$1

if [[ "${FILE}" == *"/87-0050/eeprom" ]];then
 IDX=0
fi
if [[ "${FILE}" == *"/74-0050/eeprom" ]];then
 IDX=1
fi
if [[ "${FILE}" == *"/69-0050/eeprom" ]];then
 IDX=2
fi
if [[ "${FILE}" == *"/105-0050/eeprom" ]];then
 IDX=3
fi

ITEM="system/chassis/motherboard/cpu${IDX}"
CPU="xyz.openbmc_project.Inventory.Item.Cpu"
ASSET="xyz.openbmc_project.Inventory.Decorator.Asset"

if [ ! -e ${FILE} ]; then
 echo "Need to specify eeprom file as argument"
 echo "Usage:"
 echo "  $0 <eeprom file>"
 exit 1
fi

function SetProperty() {
 INTERFACE=$1
 PROPERTY=$2
 TYPE=$3
 VALUE=$4
 /usr/bin/busctl set-property xyz.openbmc_project.Inventory.Manager \
  /xyz/openbmc_project/inventory/${ITEM} "${INTERFACE}" "${PROPERTY}" ${TYPE} ${VALUE}
}

function SetPropertyString() {
 SetProperty $1 $2 s $3
}

function SetPropertyInt() {
 SetProperty $1 $2 d $3
}

function SetPropertyUInt() {
 SetProperty $1 $2 u $3
}

function SetPropertyQuad() {
 SetProperty $1 $2 q $3
}

function ReadString() {
 OFFSET=$1
 CNT=$2
 hexdump -n ${CNT} -s ${OFFSET} -ve '1/1 "%c"' ${FILE}
}

function ReadUInt() {
 OFFSET=$1
 CNT=$2
 hexdump -n ${CNT} -s ${OFFSET} -ve "1/${CNT} \"%u\"" ${FILE}
}

function ReadUInt8() {
 ReadUInt $1 1
}

function ReadUInt16() {
 ReadUInt $1 2
}

function ReadUInt16BCD() {
 OFFSET=$1
 hexdump -n 2 -s ${OFFSET} -ve "1/2 \"%x\"" ${FILE}
}

function ReadQuadHex() {
 OFFSET=$1
 hexdump -n 4 -s $((OFFSET + 4)) -ve "1/4 \"%x\"" ${FILE}
 hexdump -n 4 -s ${OFFSET} -ve "1/4 \"%x\"" ${FILE}
}

PIROM_SIZE=$(ReadUInt16 1)
PIROM_DATA_ADDRESS=$(ReadUInt8 3)
PIROM_CORE_ADDRESS=$(ReadUInt8 4)
PIROM_PART_ADDRESS=$(ReadUInt8 9)
PIROM_PPIN_ADDRESS=$(ReadUInt8 12)

if [ ${PIROM_DATA_ADDRESS} -ge ${PIROM_SIZE} ]; then
  echo "PIROM_DATA_ADDRESS=${PIROM_DATA_ADDRESS} > PIROM_SIZE=${PIROM_SIZE}"
  exit 1
fi
if [ ${PIROM_CORE_ADDRESS} -ge ${PIROM_SIZE} ]; then
  echo "PIROM_CORE_ADDRESS=${PIROM_CORE_ADDRESS} > PIROM_SIZE=${PIROM_SIZE}"
  exit 1
fi
if [ ${PIROM_PART_ADDRESS} -ge ${PIROM_SIZE} ]; then
  echo "PIROM_PART_ADDRESS=${PIROM_PART_ADDRESS} > PIROM_SIZE=${PIROM_SIZE}"
  exit 1
fi
if [ ${PIROM_PPIN_ADDRESS} -ge ${PIROM_SIZE} ]; then
  echo "PIROM_PPIN_ADDRESS=${PIROM_PPIN_ADDRESS} > PIROM_SIZE=${PIROM_SIZE}"
  exit 1
fi

if [ ${PIROM_DATA_ADDRESS} -gt 0 ]; then
 CORE_CNT=$(ReadUInt8 $((PIROM_DATA_ADDRESS + 7)))
 HT_EN=$(ReadUInt8 $((PIROM_CORE_ADDRESS + 8)))
 SSPEC=$(ReadString $((PIROM_DATA_ADDRESS + 0)) 6)

 SetPropertyString ${ASSET} "PartNumber" ${SSPEC}

 if [ $((HT_EN & 1)) -gt 0 ]; then
  SetPropertyQuad ${CPU} "ThreadCount" $((CORE_CNT * 2))
 else
  SetPropertyQuad ${CPU} "ThreadCount" ${CORE_CNT}
 fi
 SetPropertyQuad ${CPU} "CoreCount" ${CORE_CNT}
fi
if [ ${PIROM_CORE_ADDRESS} -gt 0 ]; then
 CPUID=$(ReadUInt16BCD $((PIROM_CORE_ADDRESS + 0)))
 MAX_P0_CORE_FREQ=$(ReadUInt16BCD $((PIROM_CORE_ADDRESS + 6)))
 MAX_P1_CORE_FREQ=$(ReadUInt16BCD $((PIROM_CORE_ADDRESS + 4)))

 SetPropertyQuad ${CPU} "EffectiveFamily" $((CPUID / 256))
 SetPropertyQuad ${CPU} "EffectiveModel" $(( (CPUID / 16) & 0xF))
 SetPropertyQuad ${CPU} "Step" $((CPUID & 0xf))

 SetPropertyUInt ${CPU} "MaxSpeedInMhz" ${MAX_P1_CORE_FREQ}
fi
if [ ${PIROM_PART_ADDRESS} -gt 0 ]; then
 FAMILY=$(ReadString $((PIROM_PART_ADDRESS + 0)) 7)
 SKU=$(ReadString $((PIROM_PART_ADDRESS + 7)) 8)

 SetPropertyString ${CPU} "Family" ${FAMILY}
 SetPropertyString ${ASSET} "SubModel" ${SKU}
fi
if [ ${PIROM_PPIN_ADDRESS} -gt 0 ]; then
 PPIN=$(ReadQuadHex $((PIROM_PPIN_ADDRESS + 0)) 8)

 SetPropertyString ${ASSET} "SerialNumber" ${PPIN}
fi