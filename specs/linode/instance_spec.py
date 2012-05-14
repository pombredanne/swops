import os
from unittest import TestCase
import json
from linode import api

#from cloud import LinodeInstance

LINODE_BASE = "https://api.linode.com/api/"
def loadkey(key):
    text = open('../../secret/keys.json').read()
    return json.loads(text)['keys'][key]

API_KEY = os.environ.get('LINODE_API_KEY', loadkey('linode.com/scraperwiki'))
linode = api.Api(API_KEY)
print API_KEY
assert False

class WhenWeCreateAnInstance(TestCase):
    def it_creates_a_linode_instance(self):
        """ it creates a linode instance """
        """ with correct plan id (ram?!) and payment term 1 month """
        LinodeInstance.create(config_name='test')
        assert 'Test' in linode.linode_list()

    def xit_updates_the_linode_instance_with_a_name(self):
        assert False

    def xit_creates_a_linode_config(self):
        assert False

    def xit_creates_two_linode_disks(self):
        assert False

class WhenWeDestroyAnInstance(TestCase):
    def xit_shutsdown_the_linode(self):
        assert False

    def xit_deletes_the_linode_disks(self):
        assert False

    def xit_deletes_the_linode_configs(self):
        assert False

    def xit_deletes_the_linode(self):
        assert False

class WhenWeStartAnInstance(TestCase):
    def xit_starts_the_linode(self):
        assert False

class WhenWeStopAnInstance(TestCase):
    def xit_stops_the_linode(self):
        assert False

class WhenWeRestartAnInstance(TestCase):
    def xit_restarts_the_linode(self):
        assert False

class WhenWeRunACommandOnAnInstance(TestCase):
    def xit_runs_the_command(self):
        assert False

class WhenWeCheckTheRunningStateOnAnInstance(TestCase):
    def xit_returns_the_current_state(self):
        assert False
