import os
import json

from linode import api, oop
"""
Just notes.
common interface to cloud services for computation (linode,
EC2, mock).


Instances

  start (might cost money)
  stop
  reboot
  run(user=,command=)

  create(config=) an instance (a server) (might cost money)
  create is a method on a config
  destroy (might refund money!)

"""

class Instance:
    """This is just an interface. Subclasses should implement
    all methods.
    """

    def __init__(self, **k):
        pass

    @classmethod
    def create(klass, config):
        """Create an instance in the cloud."""
        pass

    def start(self):
        pass

    def stop(self):
        pass

    def running_state(self):
        """Returns one of 'stopped', 'running', 'starting',
        'stopping', 'rebooting', and possibly other things.
        Will raise an exception if the instance in the cloud
        cannot be contacted.
        """
        pass

    def destroy(self):
        pass


"""
Configs

  list of commands to bring instance from off the shelf to a
  particular desired state (EG, with custom kernel, sshd,
  python, etc, installed).

  (just like a linode a stackscript)

  config_create
  config_destroy
  config.save - save existing

  do we need Service Configs and Software Configs?
"""

class Config:
    """ Encapsulates configuration that we care about, and is not
    specific to any cloud provider
    """
    
    CONFIGS_PATH = 'cloud/configs'

    def __init__(self, name, **k):
        if not os.path.exists(self.CONFIGS_PATH):
            raise IOError('Config directory not found')
        if not os.path.exists(self.CONFIGS_PATH + '/' + name):
            raise IOError('Config not found')
        if not os.path.exists(self.CONFIGS_PATH + '/' + name + '/config.json'):
            raise IOError('config.json not found')
        self.parse_json(self.CONFIGS_PATH + '/' + name + '/config.json')
    
    def parse_json(self, path):
        json_data = open(path)
        data = json.load(json_data)
        json_data.close()

        self.cloud = data['cloud']
        self.name = data['name']
        self.description = data['description']
        self.ram = data['ram']
        self.disk_size = data['disk_size']


""" Linode Instance (extract later) """
class LinodeInstance(Instance):
    @classmethod
    def create(klass, config_name):
        config = Config(name=config_name)
        oop.ActiveContext = api.Api(os.environ['LINODE_API_KEY'])
        new_instance = oop.Linode()
        new_instance.datacenter = 7 #uk
        new_instance.plan = 1 # 512
        new_instance.term = 1 # 1 month
        new_instance.save()
        new_instance.name = config.name
        new_instance.save()
