project(
  'sensor-history',
  'cpp',
  version: '1.0.0',
  meson_version: '>=1.1.1',
  default_options: ['warning_level=3', 'werror=true', 'cpp_std=c++23'],
)

phosphor_dbus_interfaces_dep = dependency('phosphor-dbus-interfaces')
phosphor_logging_dep = dependency('phosphor-logging')
sdbusplus_dep = dependency('sdbusplus')
sdeventplus_dep = dependency('sdeventplus')

deps = [
  phosphor_dbus_interfaces_dep,
  phosphor_logging_dep,
  sdbusplus_dep,
  sdeventplus_dep,
]

executable('sensor_history', 'main.cpp', dependencies: deps, install: true)
