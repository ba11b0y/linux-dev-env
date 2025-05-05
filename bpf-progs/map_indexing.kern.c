#include <linux/bpf.h>
#include <linux/ptrace.h>
#include <bpf/bpf_helpers.h>

#define SINK __attribute__((btf_decl_tag("sensitivity:low")))
#define SECRET __attribute__((btf_decl_tag("sensitivity:high")))

struct map_data {
	long fd SINK;
};


// low secrecy zone
struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, 256);
    __type(key, int);
    __type(value, struct map_data);
    __uint(pinning, LIBBPF_PIN_BY_NAME);
} leak_map1 SEC(".maps");

SEC("kprobe/do_sys_openat2")
int prog(struct pt_regs *ctx SECRET) {
	int key;
	struct map_data map_data;

	map_data.fd = ctx->rax;

	bpf_map_update_elem(&leak_map1, &key, &map_data, BPF_ANY);

	return 0;
}

char LICENSE[] SEC("license") = "GPL";
