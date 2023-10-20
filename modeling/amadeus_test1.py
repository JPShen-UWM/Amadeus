from amadeus import amadeus
import random
# This test perform first layer convolution
ifmap = [[random.randint(0, 30) for j in range(227)] for i in range(227)]
filter = [[random.randint(0, 30) for j in range(11)] for i in range(11)]
dut = amadeus()
dut.load_filter_from_mem(filter, 11)
dut.load_ifmap_from_mem(ifmap, 227)
dut.first_layer_conv()
#print(len(dut.ofmap[0]))
print("...............................")
#print(dut.ofmap)
print("...............................")
correct_result = [[0] * 55 for _ in range(55)]
for i in range(55):
    for j in range(55):
        for k in range(11):
            for l in range(11):
                correct_result[i][j] += ifmap[i * 4 + k][j * 4 + l] * filter[k][l]
#print(correct_result)
print("...............Check correctness................")
# Check correctness
for i in range(55):
    for j in range(55):
        correct_result[i][j] = correct_result[i][j] - dut.ofmap[i][j]

print(correct_result)