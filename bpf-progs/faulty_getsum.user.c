#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_prog()
{
    unsigned int arr[5] = {1, 2, 3, 4, 5};
    unsigned int sum = 0;
    unsigned int i = 0;

    // Loop with a dynamic upper bound based on a safe computation.
    for (i = 0; i < arr[4]; i++)
    {
        sum += arr[i];
    }

    return sum % 2;
}

char _license[] SEC("license") = "GPL";
