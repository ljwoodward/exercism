class Phone(object):
    def __init__(self, phone_number):
        nums = ''.join([x for x in phone_number if x.isnumeric()])

        if len(nums) not in (10, 11):
            raise ValueError('Number must have 10 or 11 digits')
        if (len(nums) == 11) & (nums[0] != '1'):
            raise ValueError('Only country code 1 is allowed')

        self.number = nums[-10:]
        self.area_code = self.number[:3]
        self.exchange_code = self.number[3:6]

        if self.area_code[0] in ('0', '1'):
            raise ValueError("Area Code can't begin with '0' or '1'")
        if self.exchange_code [0] in ('0', '1'):
            raise ValueError("Exchange code can't begin with '0' oe '1'")

    def pretty(self):
        return f'({self.area_code}) {self.exchange_code}-{self.number[-4:]}'
