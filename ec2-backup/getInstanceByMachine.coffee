#!/usr/bin/env coffee
{exec} = require 'child_process'

_ = require 'underscore'
argv = require('optimist')
  .usage('Usage: $0 <machine id>')
  .argv

exec 'juju status --format json', (err, stdout, stderr) ->
  status = JSON.parse stdout
  machine = status.machines["#{argv._}"]
  if not machine
    console.warn "Machine #{argv._} not found; try #{_.keys(status.machines)} instead."
    process.exit 2
  else
    console.log machine['instance-id']
