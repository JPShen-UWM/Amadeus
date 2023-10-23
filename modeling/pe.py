class pe:
    # this pe position
    def __init__(self, x, y):
        self.x_axis = x
        self.y_axis = y
        self.filter = [0] * 11
        self.filter_size = 0
        self.stride = 1
        self.ifmap = []
        self.ifmap_size = 0
        self.psum = [[0] * 55 for _ in range(8)]
        self.psum_size = 0
        self.psum_is_cleared = 1


    # 1-d filter, maximum support size of 11
    def load_filter(self, new_filter, filter_size, stride):
        for i in range(filter_size):
            self.filter[i] = new_filter[i]
        self.filter_size = filter_size
        self.stride = stride
        #print(self.x_axis, self.y_axis)
        #print(self.filter)

    # 1-d input data maximum support size of 227
    def load_ifmap(self, ifmap, ifmap_size):
        self.ifmap = ifmap
        self.ifmap_size = ifmap_size
        self.psum_size = int((self.ifmap_size-self.filter_size)/self.stride) + 1


    # clear psum and calculate psum
    def perform_conv(self, psum_stack):
        #print(self.x_axis, self.y_axis)
        #if(self.y_axis == 0 & self.x_axis == 0):
        #    print(self.ifmap)
        # self.psum_size = int((self.ifmap_size-self.filter_size)/self.stride) + 1
        self.psum[psum_stack] = [0] * self.psum_size
        self.psum_is_cleared = 0
        for i in range(self.psum_size):
            for j in range(self.filter_size):
                self.psum[psum_stack][i] = self.psum[psum_stack][i] + self.filter[j] * self.ifmap[i*self.stride + j]
                #print(self.filter[j])

    # calculate psum by accumulate it without clearing
    def accum_conv(self, psum_stack):
        #if(self.psum_is_cleared == 1):
            #self.psum[psum_stack] = [0] * self.psum_size
        for i in range(self.psum_size):
            for j in range(self.filter_size):
                self.psum[psum_stack][i] = self.psum[psum_stack][i] + self.filter[j] * self.ifmap[i*self.stride + j]
                #print(self.filter[j])
        self.psum_is_cleared = 0

    # clear psum
    def clear_psum(self):
        self.psum = [[0] * 55 for _ in range(8)]
        self.psum_is_cleared = 1