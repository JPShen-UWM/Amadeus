from amadeus import amadeus
import random
# This test perform second layer convolution
# ifmap is 13x13 with pad 1 so use 15x15 for test
ifmap = [[random.randint(0, 30) for j in range(15)] for i in range(15)]
# filter is 3x3
filter = [[random.randint(0, 30) for j in range(3)] for i in range(3)]
dut = amadeus()
dut.load_filter_from_mem(filter, 3)
dut.load_ifmap_from_mem(ifmap, 15)
dut.third_layer_conv()
#print(len(dut.ofmap[0]))
print("...............................")
print(dut.ofmap)
print("...............................")
correct_result = [[0] * 13 for _ in range(13)]
for i in range(13):
    for j in range(13):
        for k in range(3):
            for l in range(3):
                correct_result[i][j] += ifmap[i + k][j + l] * filter[k][l]
print(correct_result)
print("...............Check correctness................")
# Check correctness
for i in range(13):
    for j in range(13):
        correct_result[i][j] = correct_result[i][j] - dut.ofmap[i][j]

print(correct_result)