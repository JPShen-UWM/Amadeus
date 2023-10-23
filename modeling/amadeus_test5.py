from amadeus import amadeus
import random
# This test perform second layer convolution but use accumulation method
# ifmap is 27x27 with pad 2 so use 31x31 for test
dut = amadeus()
correct_result = [[0] * 27 for _ in range(27)]
dut.clear_psum()
# Second layer has 48 channel
for channel in range(48):
    ifmap = [[random.randint(0, 30) for j in range(31)] for i in range(31)]
    # filter is 3x3
    filter = [[random.randint(0, 30) for j in range(5)] for i in range(5)]
    dut.load_filter_from_mem(filter, 5)
    dut.load_ifmap_from_mem(ifmap, 31)
    dut.second_layer_conv()
    #print(len(dut.ofmap[0]))
    print("...............................")
    #print(dut.ofmap)
    print("...............................")
    for i in range(27):
        for j in range(27):
            for k in range(5):
                for l in range(5):
                    correct_result[i][j] += ifmap[i + k][j + l] * filter[k][l]
#print(correct_result)
print("...............Check correctness................")
# Check correctness
for i in range(27):
    for j in range(27):
        correct_result[i][j] = correct_result[i][j] - dut.ofmap[i][j]

print(correct_result)