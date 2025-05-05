#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>

#define MAP_PATH "/sys/fs/bpf/leak_map1"

int main() {
    int map_fd;
    int key = 182;
    long value;

    // Open the BPF map
    map_fd = bpf_obj_get(MAP_PATH);
    if (map_fd < 0) {
        perror("bpf_obj_get");
        return 1;
    }

    // Read the value from the BPF map
    if (bpf_map_lookup_elem(map_fd, &key, &value) != 0) {
        perror("bpf_map_lookup_elem");
        close(map_fd);
        return 1;
    }

    // Print the value
    printf("Value from BPF map: %ld\n", value);

    // Close the map file descriptor
    close(map_fd);

    return 0;
}