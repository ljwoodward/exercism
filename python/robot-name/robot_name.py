import string
import random

class Robot(object):
    def __init__(self):
        self.name = random.choice(string.ascii_uppercase) + random.choice(string.ascii_uppercase) + str(random.randint(100, 999))

    def reset(self):
        random.seed(self.name)
        self.name = random.choice(string.ascii_uppercase) + random.choice(string.ascii_uppercase) + str(random.randint(100, 999))
