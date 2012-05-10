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

Configs

  list of commands to bring instance from off the shelf to a
  particular desired state (EG, with custom kernel, sshd,
  python, etc, installed).

  (just like a linode a stackscript)

  config_create

  do we need Service Configs and Software Configs?
"""


class Instance:
    """This is just an interface. Subclasses should implement
    all methods.
    """

    def __init__(self, **k):
        pass

    @classmethod
    def create(klass):.
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


