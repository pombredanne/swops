from unittest import TestCase
from nose.tools import assert_equals, raises

from cloud import Config

def it_finds_the_test_config():
    test = Config(name='test')
    assert test

def ensure_json_contains_the_required_fields():
    test = Config(name='test')
    assert_equals(test.cloud, 'FakeCloud')
    assert_equals(test.name, 'Test')
    assert_equals(test.description, 'A terse testing description')
    assert_equals(test.ram, 512)
    assert_equals(test.disk_size, 2048)
    
@raises(IOError)
def it_raises_an_error_if_the_config_doesnt_exist():
    test = Config(name='noexist')
    assert test

@raises(IOError)
def it_raises_an_error_if_the_config_JSON_doesnt_exist():
    test = Config(name='noexist')
    assert test

