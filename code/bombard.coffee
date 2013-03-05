# cobalt.coffee

{exec} = require 'child_process'
fs = require 'fs'
# https://github.com/mikeal/request
request = require 'request'
should = require 'should'
_ = require 'underscore'
async = require 'async'

host = process.env.COBALT_INTEGRATION_TEST_SERVER or 'boxecutor-int-test-0.scraperwiki.net'
baseurl = "http://#{host}"

cobalt_api_key = process.env.COTEST_USER_API_KEY
staff_api_key = process.env.COTEST_STAFF_API_KEY
boxname = 'cotest/09627163505647331'
ssh_boxname = boxname.replace('/', '.')
sshkey_pub_path =  "../swops-secret/cotest-rsa.pub"
sshkey_prv_path =  "../swops-secret/cotest-rsa"
sshkey_prv_path_root = "../swops-secret/id_dsa"
fs.chmodSync sshkey_prv_path, 0o600
fs.chmodSync sshkey_prv_path_root, 0o600

ssh_args = [
  "-o LogLevel=ERROR",
  "-o UserKnownHostsFile=/dev/null",
  "-o StrictHostKeyChecking=no",
  "-o IdentitiesOnly=yes",
  "-o PreferredAuthentications=publickey",
]

ssh_root_args = [ "-o User=root", "-i #{sshkey_prv_path_root}" ].concat(ssh_args)

ssh_user_args = [ "-o User=#{ssh_boxname}", "-i #{sshkey_prv_path}" ].concat(ssh_args)

ssh_cmd = (cmd, callback) ->
  ssh = "ssh #{ssh_user_args.join ' '} #{host} '#{cmd}'"
  exec ssh, (err, stdout, stderr) ->
   callback err, stdout, stderr

ssh_cmd_root = (cmd, callback) ->
  ssh = "ssh #{ssh_root_args.join ' '} #{host} '#{cmd}'"
  exec ssh, (err, stdout, stderr) ->
   callback err, stdout, stderr

scp_cmd = (file_path, file_name, callback) ->
  scp = "scp #{ssh_user_args.join ' '} #{file_path} #{host}:#{file_name}"
  exec scp, (err, stdout, stderr) ->
    callback err, stdout, stderr

options =
    uri: "#{baseurl}/#{boxname}/exec"
    form:
      apikey: cobalt_api_key
      cmd: "cat ~/README.md"

count = 0
conns = process.argv[2]
console.log "Trying #{conns} times..."
while count <= conns
  count+=1
  request.post options, (err, resp, body) ->
    console.log err if err?

