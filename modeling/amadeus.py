from pe import pe
class amadeus:
    pe_array = []
    def __init__(self):
        print("Init amadeus accelerator")
        self.pe_array = [[pe(i, j) for j in range(7)] for i in range(6)]

    # load filter from memory, maximum support 11x11
    filter = [[0] * 11 for _ in range(11)]
    filter_size = 0
    def load_filter_from_mem(self, filter, filter_size):
        self.filter = filter
        self.filter_size = filter_size

    # load input feature map, maximum 227x227
    ifmap = [[0] * 277 for _ in range(277)]
    def load_ifmap_from_mem(self, ifmap, ifmap_size):
        self.ifmap = ifmap
        self.ifmap_size = ifmap_size

    # load filter into pe
    # mode 1: first phase for 11x11 filter stride 4
    # mode 2: second phase for 11x11 filter stride 4
    # mode 3: 5x5 filter
    # mode 4: 3x3 filter
    def load_filter_to_pe(self, mode):
        if(mode == 1):
            for i in range(6):
                for j in range(7):
                    self.pe_array[i][j].load_filter(self.filter[i], 11, 4)
        elif(mode == 2):
            for i in range(5):
                for j in range(7):
                    self.pe_array[i][j].load_filter(self.filter[i+6], 11, 4)
        elif(mode == 3):
            for i in range(5):
                for j in range(7):
                    self.pe_array[i][j].load_filter(self.filter[i], 5, 1)
        elif(mode == 4):
            for i in range(3):
                for j in range(7):
                    self.pe_array[i][j].load_filter(self.filter[i], 3, 1)
                    self.pe_array[i+3][j].load_filter(self.filter[i], 3, 1)
        else:
            print("fuck you no this mode")

    # load ifmap into pe
    # mode 1: first phase for 11x11 filter stride 4
    # mode 2: second phase for 11x11 filter stride 4
    # mode 3: 5x5 filter
    # mode 4: 3x3 filter
    def load_ifmap_to_pe(self, mode, first_row):
        if(mode == 1):
            for i in range(6):
                for j in range(7):
                    if(i+j*4+first_row < self.ifmap_size):
                        self.pe_array[i][j].load_ifmap(self.ifmap[i+j*4+first_row], self.ifmap_size)
        elif(mode == 2):
            for i in range(5):
                for j in range(7):
                    if(i+j*4+first_row+6 < self.ifmap_size):
                        self.pe_array[i][j].load_ifmap(self.ifmap[i+j*4+first_row+6], self.ifmap_size)
        elif(mode == 3):
            for i in range(5):
                for j in range(7):
                    if(i+j+first_row < self.ifmap_size):
                        self.pe_array[i][j].load_ifmap(self.ifmap[i+j+first_row], self.ifmap_size)
        elif(mode == 4):
            for i in range(3):
                for j in range(7):
                    if(i+j+first_row < self.ifmap_size):
                        self.pe_array[i][j].load_ifmap(self.ifmap[i+j+first_row], self.ifmap_size)
                    if(i+j+first_row+7 < self.ifmap_size):
                        self.pe_array[i+3][j].load_ifmap(self.ifmap[i+j+first_row+7], self.ifmap_size)
        else:
            print("fuck you no this mode")

    # Perform 1-d convolution calculation
    def perform_conv(self):
        for i in range(6):
            for j in range(7):
                self.pe_array[i][j].perform_conv()

    # Perform 1-d accumulate convolution calculation
    def accum_conv(self):
        for i in range(6):
            for j in range(7):
                self.pe_array[i][j].accum_conv()

    # Clear all psum
    def clear_psum(self):
        for i in range(6):
            for j in range(7):
                self.pe_array[i][j].clear_psum()

    psum_size = 55
    # Perform vertical psum
    # mode 1: first phase for 11x11 filter stride 4
    # mode 2: second phase for 11x11 filter stride 4
    # mode 3: 5x5 filter
    # mode 4: 3x3 filter
    def vertical_sum(self, mode, column):
        if(mode == 1):
            psum = [0]*self.psum_size
            for i in range(6):
                for j in range(self.psum_size):
                    psum[j] = psum[j] + self.pe_array[i][column].psum[j]
            return psum
        elif(mode == 2):
            psum = [0]*self.psum_size
            for i in range(5):
                for j in range(self.psum_size):
                    psum[j] = psum[j] + self.pe_array[i][column].psum[j]
            return psum
        elif(mode == 3):
            psum = [0]*self.psum_size
            for i in range(5):
                for j in range(self.psum_size):
                    psum[j] = psum[j] + self.pe_array[i][column].psum[j]
            return psum
        elif(mode == 4):
            psum = [0]*self.psum_size
            if(column < 7):
                for i in range(3):
                    for j in range(self.psum_size):
                        psum[j] = psum[j] + self.pe_array[i][column].psum[j]
                return psum
            else:
                for i in range(3):
                    for j in range(self.psum_size):
                        psum[j] = psum[j] + self.pe_array[i+3][column-7].psum[j]
                return psum
        else:
            print("fuck you no this mode")

    ofmap = [[0] * 55 for _ in range(55)]

    # Perform first layer convolution for 11x11 filter
    def first_layer_conv(self):
        self.psum_size = 55
        self.ofmap = [[0] * 55 for _ in range(55)]
        # perform first part conv
        self.load_filter_to_pe(1)
        for i in range(8):
            #print(self.ofmap[0])
            self.load_ifmap_to_pe(1, i*7*4)
            self.perform_conv()
            for j in range(7):
                if(i*7 + j < 55):
                    self.ofmap[i*7 + j] = self.vertical_sum(1, j)
        # perform second part conv
        self.load_filter_to_pe(2)
        for i in range(8):
            self.load_ifmap_to_pe(2, i*7*4)
            #print(self.pe_array[0][0].ifmap)
            self.perform_conv()
            for j in range(7):
                if(i*7 + j < 55):
                    for k in range(55):
                        self.ofmap[i*7 + j][k] = self.ofmap[i*7 + j][k] + self.vertical_sum(2, j)[k]

    # Perform second layer convolution
    # 5x5 filter
    def second_layer_conv(self):
        self.psum_size = 27
        self.ofmap = [[0] * 27 for _ in range(27)]
        self.load_filter_to_pe(3)
        for i in range(4):
            #print(self.ofmap[0])
            self.load_ifmap_to_pe(3, i*7)
            self.perform_conv()
            for j in range(7):
                if(i*7 + j < 27):
                    self.ofmap[i*7 + j] = self.vertical_sum(3, j)

    # Perform 3x3 filter convolution
    def third_layer_conv(self):
        self.psum_size = 13
        self.ofmap = [[0] * 13 for _ in range(13)]
        self.load_filter_to_pe(4)
        #print(self.ofmap[0])
        self.load_ifmap_to_pe(4, 0)
        self.perform_conv()
        for j in range(13):
            self.ofmap[j] = self.vertical_sum(4, j)

    # Perform 3x3 filter convolution
    # Accumulate current psum
    def third_layer_accum_conv(self):
        self.psum_size = 13
        self.ofmap = [[0] * 13 for _ in range(13)]
        self.load_filter_to_pe(4)
        #print(self.ofmap[0])
        self.load_ifmap_to_pe(4, 0)
        self.accum_conv()
        for j in range(13):
            self.ofmap[j] = self.vertical_sum(4, j)