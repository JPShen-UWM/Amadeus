layer = 1
ifmap = [[j for j in range(227)] for i in range(227)]
filter = [[32, 0, 16, 0, -16, 0, -16, 0, 16, 0, 32] for i in range(11)]
if_size = 0
of_size = 0
filter_size = 0
stride_size = 0
if layer == 1:
    if_size = 227
    of_size = 55
    filter_size = 11
    stride_size = 4

            

file = open("program.mem", "w")
file.write(hex(3) + "\n")
file.write(hex(6586) + "\n")
file.write(hex(6674) + "\n")

for i in range(227):
    for j in range(28):
        numbers = ifmap[i][j*8:j*8+8]
        hex_string = ''.join(format(num, '02x') for num in reversed(numbers))
        file.write('0x' + hex_string.upper() + "\n")
    numbers = ifmap[i][224:226]
    hex_string = ''.join(format(num, '02x') for num in reversed(numbers))
    file.write('0x' + hex_string.upper() + "\n")

for i in range(4):
    for j in range(11):
        numbers = filter[j][0:8]
        hex_string = ''.join(format(num & 0xFF, '02x') for num in reversed(numbers))
        file.write('0x' + hex_string.upper() + "\n")
        numbers = filter[j][8:12]
        hex_string = ''.join(format(num & 0xFF, '02x') for num in reversed(numbers))
        file.write('0x' + hex_string.upper() + "\n")

file.close()
