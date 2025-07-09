#include <iostream>
#include <string>

#include <sdbusplus/exception.hpp>
#include <sdeventplus/event.hpp>
#include <sdbusplus/server.hpp>
#include <sdbusplus/server/object.hpp>
#include <boost/container/flat_map.hpp>

#include <xyz/openbmc_project/Sensor/Value/server.hpp>

using ValueInherit = sdbusplus::server::object_t<
      sdbusplus::xyz::openbmc_project::Sensor::server::Value>;

using VariantType =
std::variant<std::vector<std::string>, std::string, int64_t, uint64_t,
	  double, int32_t, uint32_t, int16_t, uint16_t, uint8_t, bool>;
using ConfigMap = boost::container::flat_map<std::string, VariantType>;
using ConfigData = boost::container::flat_map<std::string, ConfigMap>;


int main() {
	std::cout << "Hello Sensor History Daemon" << std::endl;

	auto event = sdeventplus::Event::get_default();

	sdbusplus::bus::bus bus = sdbusplus::bus::new_default();

	sdbusplus::server::manager_t objManager(bus,
                                              "/xyz/openbmc_project/history");

	bus.attach_event(event.get(), SD_EVENT_PRIORITY_NORMAL);

	bus.request_name("xyz.openbmc_project.SensorHistory");

	// put an object
	std::string path = "/xyz/openbmc_project/history/obj1";
	auto x = std::make_unique<ValueInherit>(bus, path.c_str(), ValueInherit::action::defer_emit);

	auto match = std::make_unique<sdbusplus::bus::match_t>(
      bus,
      sdbusplus::bus::match::rules::interfacesAdded() +
	 sdbusplus::bus::match::rules::sender(
	     "xyz.openbmc_project.EntityManager"),
	[](sdbusplus::message_t& msg) {

		sdbusplus::message::object_path path;

		using PropertyMap =
		boost::container::flat_map<std::string,
					std::variant<std::string>>;
		boost::container::flat_map<std::string, PropertyMap>
		interfaceAdded;

		msg.read(path, interfaceAdded);

		std::cout << "interfaces added on " << path.str << std::endl;
	});

	event.loop();

	return 0;
}
