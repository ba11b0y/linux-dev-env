#include "vmlinux.h"
#include <bpf/bpf_helpers.h>

// Map to store leaked kernel pointers (key 0 for current task pointer)
struct
{
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__uint(key_size, sizeof(__u32));
	__uint(value_size, sizeof(__u64));
	__uint(max_entries, 1);
} task_leak_map SEC(".maps");

SEC("tracepoint/syscalls/sys_enter_execve")
int leak_task_ptr(struct trace_event_raw_sys_enter *ctx)
{
	// Get pointer to current task_struct (BTF pointer)
	struct task_struct *task = bpf_get_current_task_btf();
	// Cast the task pointer to a 64-bit value (kernel address)
	__u64 task_addr = (__u64)task;
	// Store the leaked address in the map
	__u32 key = 0;
	bpf_map_update_elem(&task_leak_map, &key, &task_addr, BPF_ANY);
	return 0;
}

char _license[] SEC("license") = "GPL";

/*



verifier log dump                               |  readable instructions
-------------------------------------------------|-------------------------------------------------
insn 0, opcode 80, class 5, imm 158              |  call 0x9e
insn 1, opcode 70, class 3, dst_reg 10, off -8   |  stxdw [r10-0x8], r0
insn 2, opcode b0, class 7, dst_reg 1            |  mov64 r1, 0x0
insn 3, opcode 60, class 3, dst_reg 10, off -12  |  stxw [r10-0xc], r1
insn 4, opcode b0, class 7, dst_reg 2            |  mov64 r2, r10
insn 5, opcode 0, class 7, dst_reg 2, imm -12    |  add64 r2, 0xfffffff4
insn 6, opcode b0, class 7, dst_reg 3            |  mov64 r3, r10
insn 7, opcode 0, class 7, dst_reg 3, imm -8     |  add64 r3, 0xfffffff8
insn 8, opcode 10, class 0, src_reg 1, imm 73793024 | lddw r1, 0x0
insn 10, opcode b0, class 7, dst_reg 4           |  mov64 r4, 0x0
insn 11, opcode 80, class 5, imm 2               |  call 0x2
insn 12, opcode b0, class 7, dst_reg 0           |  mov64 r0, 0x0
insn 13, opcode 90, class 5                      |  exit

insn | action | meaning
0 | call 158 | call bpf_get_current_task_btf()
1 | store r0 to (fp-8) | save task pointer to stack
2 | r1 = 0 | prepare key = 0
3 | *(fp-12) = r1 | store key at (fp-12)
4 | r2 = fp | 
5 | r2 += -12 | r2 points to key (fp-12)
6 | r3 = fp | 
7 | r3 += -8 | r3 points to task_addr (fp-8)
8 | load imm into r1 | load map fd
10 | r4 = 0 | BPF_ANY flag
11 | call 2 | call bpf_map_update_elem(map, key, value, flags)
12 | r0 = 0 | return 0
13 | exit | program ends


Disassembly of section tracepoint/syscalls/sys_enter_execve:

0000000000000000 <leak_task_ptr>:
       0:       85 00 00 00 9e 00 00 00 call 0x9e (158)
       1:       7b 0a f8 ff 00 00 00 00 *(u64 *)(r10 - 0x8) = r0
       2:       b7 01 00 00 00 00 00 00 r1 = 0x0
       3:       63 1a f4 ff 00 00 00 00 *(u32 *)(r10 - 0xc) = r1
       4:       bf a2 00 00 00 00 00 00 r2 = r10
       5:       07 02 00 00 f4 ff ff ff r2 += -0xc
       6:       bf a3 00 00 00 00 00 00 r3 = r10
       7:       07 03 00 00 f8 ff ff ff r3 += -0x8
       8:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0x0 ll
      10:       b7 04 00 00 00 00 00 00 r4 = 0x0
      11:       85 00 00 00 02 00 00 00 call 0x2
      12:       b7 00 00 00 00 00 00 00 r0 = 0x0
      13:       95 00 00 00 00 00 00 00 exit



*/