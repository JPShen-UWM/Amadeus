from pe import pe
pe00 = pe(0,0)
filter = [1,2,3,4]
pe00.load_filter(filter, 4, 2)
ifmap = [1,2,3,4,5,6,7,8,9,10]
pe00.load_ifmap(ifmap, len(ifmap))
pe00.perform_conv()
print(pe00.psum)