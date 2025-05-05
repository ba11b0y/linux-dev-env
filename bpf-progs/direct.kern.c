#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int test1(struct xdp_md *ctx) {
    // Directly access a field in ctx
    int ingress_ifindex = ctx->data_meta;
    bpf_printk("Ingress IFINDEX: %d\n", ingress_ifindex);
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";