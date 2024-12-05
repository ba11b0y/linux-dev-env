/**
 * User program for loading a single generic program and attaching
 * Usage: ./load.user bpf_file bpf_prog_name
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <time.h>
#include <stdlib.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

int main(int argc, char *argv[])
{
    if (argc < 3) {
        printf("Not enough args\n");
        printf("Expected: ./load.user bpf_file bpf_prog_name [optional:verifier_name]\n");
        return -1;
    }

    char *bpf_path = argv[1];
    char *prog_name = argv[2];

    __u32 verifier_type = 0;
    if (argc == 4) {
        verifier_type = atoi(argv[3]);
    }

    printf("Loading program with verifier type: %d\n", verifier_type);

    // returns a bpf_object
    struct bpf_object *prog = bpf_object__open(bpf_path);

    // set verifier type inside the prog, later passed on as attr
    bpf_object__set_verifier_type(prog, verifier_type);
    
    // Try and load this program
    if (bpf_object__load(prog)) {
        printf("Failed");
        return 0;
    }

    struct bpf_program * program = bpf_object__find_program_by_name(prog, prog_name);

    if (program == NULL) {
        printf("Could not find pbf_prog_name\n");
        return 0;
    }

    printf("PID: %d\n", getpid());

    bpf_program__attach(program);

    // While this while loop is running program is attached. To unattach the
    // program kill ./load.user with Ctrl+C
    while (1) {
        sleep(1);
    }

    return 0;
}
