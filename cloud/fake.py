from cloud import Instance

instances = []

class FakeInstance(Instance):

    @classmethod
    def create(klass, config):
        instance = FakeInstance()
        instances.append(instance)
        return instance

    @classmethod
    def list(klass):
        return instances

    @classmethod
    def destroy(klass, instance):
        instances.remove(instance)

    def start(self):
        return True

    def stop(self):
        return True

    def restart(self):
        return True

    def state(self):
        return "running"
