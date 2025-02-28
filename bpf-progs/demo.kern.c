#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

char LICENSE[] SEC("license") = "Dual BSD/GPL";

#define __sensitive_high __attribute__((btf_decl_tag("sensitivity: high")))

int info __sensitive_high = 1000;


SEC("tp/syscalls/sys_enter_getcwd")
int bpf_demo(void *ctx)
{
    bpf_printk("%d", info);
    return 0;
}