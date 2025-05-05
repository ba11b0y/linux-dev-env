#include <linux/bpf.h>
#include <linux/ptrace.h>
#include <bpf/bpf_helpers.h>

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, 1);
    __type(key, int);
    __type(value, long);
    __uint(pinning, LIBBPF_PIN_BY_NAME);
} leak_map SEC(".maps");

SEC("tp/syscalls/sys_enter_getcwd")
int prog(void *ctx) {
    int key = 0;
    long uninit_stack_var;  // Uninitialized kernel stack memory

    // Use an uninitialized value (verifier does not always detect this)
    bpf_map_update_elem(&leak_map, &key, &uninit_stack_var, BPF_ANY);

    return 0;
}

char LICENSE[] SEC("license") = "GPL";
