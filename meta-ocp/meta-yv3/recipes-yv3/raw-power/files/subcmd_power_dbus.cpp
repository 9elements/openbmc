#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sdbusplus/bus.hpp>
#include <iostream>
#include <vector>

#include "raw_power.h"
#include "internal.h"
#include "bic.h"

#include "subcmd_power_dbus.hpp"

static void ipmb_request_dbus(uint8_t channel, std::vector<uint8_t>& data);

void subcmd_power_dbus(int slot, bool skip_gpio, bool on){

	int status = 0;

	if(!skip_gpio){
		status = enable_i2c_gpio(slot);
		if (status != 0) return;
	}

	if(slot < 0){
		fprintf(stderr, "invalid parameter: slot < 0\n");
		return;
	}

	// channels are described in /usr/share/ipmbbridge/ipmb-channels.json
	uint8_t channel = slot-1;
	std::vector<uint8_t> req_power_btn_high = {0x05, 0x42, 0x01, 0x00, POWER_BTN_HIGH};
	std::vector<uint8_t> req_power_btn_low = {0x05, 0x42, 0x01, 0x00, POWER_BTN_LOW};

	ipmb_request_dbus(channel, req_power_btn_high);
	ipmb_request_dbus(channel, req_power_btn_low);
	if(on) sleep(1);
	else sleep(6);
	ipmb_request_dbus(channel, req_power_btn_high);
}

static void ipmb_request_dbus(uint8_t channel, std::vector<uint8_t>& data){

	printf("%s: channel=%d\n", __func__, (int)channel);

	auto bus = sdbusplus::bus::new_system();
	//auto bus = sdbusplus::bus::new_default();

	// D-Bus service and object path details
	const char* service = "xyz.openbmc_project.Ipmi.Channel.Ipmb";
	const char* path = "/xyz/openbmc_project/Ipmi/Channel/Ipmb";
	const char* interface = "org.openbmc.Ipmb";
	const char* method = "sendRequest";

	// IPMB request details (example values)
	uint8_t netFn = NETFN_APP_REQ;   // Net Function
	uint8_t lun = 0x00;     // LUN
	uint8_t cmd = CMD_APP_MASTER_WRITE_READ;     // Command

	// Create a method call message
	auto method_call = bus.new_method_call(service, path, interface, method);
	method_call.append(channel, netFn, lun, cmd, data);

	// Call the method
	try {
		auto reply = bus.call(method_call);

		int32_t responseCode;
		uint8_t responseNetFn, responseLun, responseSeq, responseCmd;
		std::vector<uint8_t> responseData;

		std::tuple<int32_t, uint8_t, uint8_t, uint8_t, uint8_t, std::vector<uint8_t>> response;

		reply.read(response);

		responseCode = std::get<0>(response);
		responseNetFn = std::get<1>(response);
		responseLun = std::get<2>(response);
		responseSeq = std::get<3>(response);
		responseCmd = std::get<4>(response);
		responseData = std::get<5>(response);

		std::cout << "Response Code: " << responseCode << std::endl;
		std::cout << "Response NetFn: " << static_cast<int>(responseNetFn) << std::endl;
		std::cout << "Response Lun: " << static_cast<int>(responseLun) << std::endl;
		std::cout << "Response Seq: " << static_cast<int>(responseSeq) << std::endl;
		std::cout << "Response Cmd: " << static_cast<int>(responseCmd) << std::endl;
		std::cout << "Response Data: ";
		for (auto byte : responseData) {
			std::cout << static_cast<int>(byte) << " ";
		}
		std::cout << std::endl;
	} catch (const sdbusplus::exception_t& e) {
		std::cerr << "Failed to read response from dbus call: " << e.what() << std::endl;
		return;
	}

	return;
}

