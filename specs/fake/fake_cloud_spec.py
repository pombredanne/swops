""" The fake instance doesn't contact any 3rd party API """
from unittest import TestCase
from nose.tools import assert_equals

from cloud import Config
from cloud.fake import FakeInstance

def it_can_create_an_instance():
    instance = FakeInstance.create(config='test')
    assert instance
    assert instance in FakeInstance.list()

class WhenWeHaveAnInstance(TestCase):
    @classmethod
    def setup_class(self):
        self.instance = FakeInstance.create(config='test')

    def it_can_destroy_an_instance(self):
        FakeInstance.destroy(self.instance)
        assert self.instance not in FakeInstance.list()

    def it_can_start_an_instance(self):
        assert self.instance.start()

    def it_can_stop_an_instance(self):
        assert self.instance.stop()

    def it_can_restart_an_instance(self):
        assert self.instance.restart()

    def it_shows_the_instances_running_state(self):
        assert self.instance.state()
