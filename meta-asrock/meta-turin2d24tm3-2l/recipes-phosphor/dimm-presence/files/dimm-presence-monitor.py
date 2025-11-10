#!/usr/bin/env python3
"""
DIMM Presence Monitor Daemon

Monitors DIMM temperature sensor availability on D-Bus and updates
corresponding inventory Present properties.

When DIMM temperature sensors appear (host powered on, DIMM installed):
  - Sets inventory Present=true

When DIMM temperature sensors disappear (host powered off, DIMM removed):
  - Sets inventory Present=false
"""

import sys
import time
import signal
import dbus

# D-Bus service names
SENSOR_SERVICE = "xyz.openbmc_project.HwmonTempSensor"
INVENTORY_SERVICE = "xyz.openbmc_project.Inventory.Manager"

# D-Bus paths
SENSOR_BASE_PATH = "/xyz/openbmc_project/sensors/temperature"
INVENTORY_BASE_PATH = "/xyz/openbmc_project/inventory/system/chassis/motherboard"

# D-Bus interfaces
PROPERTIES_IFACE = "org.freedesktop.DBus.Properties"
OBJECT_MANAGER_IFACE = "org.freedesktop.DBus.ObjectManager"
INVENTORY_ITEM_IFACE = "xyz.openbmc_project.Inventory.Item"

# Mapping: sensor name -> inventory path suffix
DIMM_SENSORS = [
    "DIMM_A0", "DIMM_A1", "DIMM_A2", "DIMM_A3", "DIMM_A4", "DIMM_A5",
    "DIMM_B0", "DIMM_B1", "DIMM_B2", "DIMM_B3", "DIMM_B4", "DIMM_B5",
    "DIMM_C0", "DIMM_C1", "DIMM_C2", "DIMM_C3", "DIMM_C4", "DIMM_C5",
    "DIMM_D0", "DIMM_D1", "DIMM_D2", "DIMM_D3", "DIMM_D4", "DIMM_D5",
]

# Poll interval in seconds
POLL_INTERVAL = 5

# Global flag for shutdown
running = True


def sensor_to_inventory_path(sensor_name):
    """Convert sensor name to inventory path.

    Args:
        sensor_name: e.g., "DIMM_A0"

    Returns:
        Full inventory path, e.g., "/xyz/openbmc_project/inventory/system/chassis/motherboard/dimm_a0"
    """
    inventory_suffix = sensor_name.lower().replace("_", "_", 1)  # DIMM_A0 -> dimm_a0
    return f"{INVENTORY_BASE_PATH}/{inventory_suffix}"


def set_dimm_present(bus, sensor_name, present):
    """Update DIMM inventory Present property.

    Args:
        bus: D-Bus connection
        sensor_name: DIMM sensor name (e.g., "DIMM_A0")
        present: Boolean, True if sensor exists, False if removed
    """
    inventory_path = sensor_to_inventory_path(sensor_name)

    try:
        inventory_obj = bus.get_object(INVENTORY_SERVICE, inventory_path)
        inventory_iface = dbus.Interface(inventory_obj, PROPERTIES_IFACE)

        # Set Present property
        inventory_iface.Set(INVENTORY_ITEM_IFACE, "Present", dbus.Boolean(present))

        print(f"Updated {sensor_name}: Present={present}", flush=True)
    except dbus.exceptions.DBusException as e:
        print(f"Error updating {sensor_name} inventory: {e}", file=sys.stderr, flush=True)


def get_existing_sensors(bus):
    """Get set of currently existing DIMM sensors.

    Args:
        bus: D-Bus connection

    Returns:
        Set of sensor names that currently exist
    """
    existing = set()

    try:
        sensor_obj = bus.get_object(SENSOR_SERVICE, "/xyz/openbmc_project/sensors")
        object_manager = dbus.Interface(sensor_obj, OBJECT_MANAGER_IFACE)

        # Get all sensor objects
        managed_objects = object_manager.GetManagedObjects()

        for obj_path in managed_objects.keys():
            if obj_path.startswith(SENSOR_BASE_PATH):
                sensor_name = obj_path.split("/")[-1]
                if sensor_name in DIMM_SENSORS:
                    existing.add(sensor_name)

    except dbus.exceptions.DBusException as e:
        print(f"Error scanning sensors: {e}", file=sys.stderr, flush=True)

    return existing


def poll_sensor_changes(bus):
    """Poll for sensor changes and update inventory.

    Args:
        bus: D-Bus connection
    """
    # Track previous state
    previous_sensors = set()

    print("Starting sensor polling...", flush=True)

    while running:
        try:
            # Get current sensors
            current_sensors = get_existing_sensors(bus)

            # Detect added sensors
            added = current_sensors - previous_sensors
            for sensor_name in added:
                print(f"DIMM sensor added: {sensor_name}", flush=True)
                set_dimm_present(bus, sensor_name, True)

            # Detect removed sensors
            removed = previous_sensors - current_sensors
            for sensor_name in removed:
                print(f"DIMM sensor removed: {sensor_name}", flush=True)
                set_dimm_present(bus, sensor_name, False)

            # Update state
            previous_sensors = current_sensors

            # Sleep before next poll
            time.sleep(POLL_INTERVAL)

        except Exception as e:
            print(f"Error in polling loop: {e}", file=sys.stderr, flush=True)
            time.sleep(POLL_INTERVAL)


def initial_scan(bus):
    """Perform initial scan of sensors and update inventory.

    Args:
        bus: D-Bus connection
    """
    print("Performing initial sensor scan...", flush=True)

    # Get existing sensors
    existing_sensors = get_existing_sensors(bus)

    # Update all DIMMs based on sensor presence
    for dimm_sensor in DIMM_SENSORS:
        present = dimm_sensor in existing_sensors
        if present:
            print(f"Found existing sensor: {dimm_sensor}", flush=True)
        set_dimm_present(bus, dimm_sensor, present)

    print(f"Initial scan complete: {len(existing_sensors)}/{len(DIMM_SENSORS)} DIMMs present", flush=True)


def signal_handler(signum, frame):
    """Handle termination signals gracefully."""
    global running
    print(f"Received signal {signum}, shutting down...", flush=True)
    running = False


def main():
    """Main daemon entry point."""
    print("Starting DIMM Presence Monitor Daemon", flush=True)

    # Connect to system bus
    bus = dbus.SystemBus()

    # Perform initial scan
    initial_scan(bus)

    # Set up signal handlers for graceful shutdown
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)

    print(f"Monitoring DIMM sensor presence (polling every {POLL_INTERVAL}s)...", flush=True)

    # Start polling loop
    try:
        poll_sensor_changes(bus)
    except KeyboardInterrupt:
        print("Interrupted by user", flush=True)

    print("DIMM Presence Monitor Daemon stopped", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
