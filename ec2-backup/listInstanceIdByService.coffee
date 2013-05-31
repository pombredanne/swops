#!/usr/bin/env coffee
{exec} = require 'child_process'

_ = require 'underscore'
argv = require('optimist')
  .usage('Usage: $0 [--regex] --show-unit-name --show-machine --show-instance-id <name>')
  .alias('r', 'regex')
  .alias('m', 'show-juju-machine')
  .alias('i', 'show-instance-id')
  .alias('u', 'show-unit-name')
  .boolean('regex')
  .boolean('show-juju-machine')
  .boolean('show-instance-id')
  .boolean('show-unit-name')
  .argv

search = (serviceName, term) ->
  if argv.regex
    (new RegExp term, 'g').test serviceName
  else
    term is serviceName

exec 'juju status --format json', (err, stdout, stderr) ->
  status = JSON.parse stdout
  liveServices = (service for service of status.services when search service, argv._[0])

  for service in liveServices
    for unit of status.services[service].units
      machineId = "#{status.services[service].units[unit].machine}"
      if argv['show-instance-id']
        console.log status.machines[machineId]['instance-id'], (if argv['show-unit-name'] then unit else '')
      if argv['show-juju-machine']
        console.log machineId
