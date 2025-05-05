	.text
	.file	"demo.kern.c"
	.file	0 "/linux-dev-env/bpf-progs" "demo.kern.c" md5 0xf282931b7915b33734477b245a5f15a7
	.file	1 "../linux/usr/include/asm-generic" "int-ll64.h" md5 0xb810f270733e106319b67ef512c6246e
	.file	2 "../linux/tools/lib/bpf" "bpf_helper_defs.h" md5 0xb1d735cb26930da0ef44cf6372b51e0b
	.section	"tp/syscalls/sys_enter_getcwd","ax",@progbits
	.globl	bpf_demo                        # -- Begin function bpf_demo
	.p2align	3
	.type	bpf_demo,@function
bpf_demo:                               # @bpf_demo
.Lfunc_begin0:
	.loc	0 10 0                          # demo.kern.c:10:0
	.cfi_sections .debug_frame
	.cfi_startproc
# %bb.0:
	*(u64 *)(r10 - 8) = r1
.Ltmp0:
	.loc	0 11 5 prologue_end             # demo.kern.c:11:5
.Ltmp1:
.Ltmp2:
	r1 = bpf_trace_printk ll
	r4 = *(u64 *)(r1 + 0)
	r3 = *(u64 *)(r10 - 8)
	r1 = bpf_demo.____fmt ll
	r2 = 3
	callx r4
	*(u64 *)(r10 - 16) = r0
	r0 = 0
.Ltmp3:
.Ltmp4:
	.loc	0 12 5                          # demo.kern.c:12:5
.Ltmp5:
	exit
.Ltmp6:
.Ltmp7:
.Lfunc_end0:
	.size	bpf_demo, .Lfunc_end0-bpf_demo
	.cfi_endproc
                                        # -- End function
	.type	LICENSE,@object                 # @LICENSE
	.section	license,"aw",@progbits
	.globl	LICENSE
LICENSE:
	.asciz	"Dual BSD/GPL"
	.size	LICENSE, 13

	.type	bpf_demo.____fmt,@object        # @bpf_demo.____fmt
	.section	.rodata,"a",@progbits
bpf_demo.____fmt:
	.asciz	"%p"
	.size	bpf_demo.____fmt, 3

	.type	bpf_trace_printk,@object        # @bpf_trace_printk
	.data
	.p2align	3, 0x0
bpf_trace_printk:
	.quad	6
	.size	bpf_trace_printk, 8

	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	37                              # DW_FORM_strx1
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	114                             # DW_AT_str_offsets_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	37                              # DW_FORM_strx1
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	115                             # DW_AT_addr_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	1                               # DW_TAG_array_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	33                              # DW_TAG_subrange_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	55                              # DW_AT_count
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	1                               # DW_CHILDREN_yes
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.ascii	"\200\300\001"                  # DW_TAG_LLVM_annotation
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	28                              # DW_AT_const_value
	.byte	37                              # DW_FORM_strx1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	21                              # DW_TAG_subroutine_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
	.byte	24                              # DW_TAG_unspecified_parameters
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	16                              # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	17                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	5                               # DWARF version number
	.byte	1                               # DWARF Unit Type
	.byte	8                               # Address Size (in bytes)
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	1                               # Abbrev [1] 0xc:0xad DW_TAG_compile_unit
	.byte	0                               # DW_AT_producer
	.short	29                              # DW_AT_language
	.byte	1                               # DW_AT_name
	.long	.Lstr_offsets_base0             # DW_AT_str_offsets_base
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.byte	2                               # DW_AT_comp_dir
	.byte	3                               # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.long	.Laddr_table_base0              # DW_AT_addr_base
	.byte	2                               # Abbrev [2] 0x23:0xb DW_TAG_variable
	.byte	3                               # DW_AT_name
	.long	46                              # DW_AT_type
                                        # DW_AT_external
	.byte	0                               # DW_AT_decl_file
	.byte	4                               # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	0
	.byte	3                               # Abbrev [3] 0x2e:0xc DW_TAG_array_type
	.long	58                              # DW_AT_type
	.byte	4                               # Abbrev [4] 0x33:0x6 DW_TAG_subrange_type
	.long	62                              # DW_AT_type
	.byte	13                              # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0x3a:0x4 DW_TAG_base_type
	.byte	4                               # DW_AT_name
	.byte	6                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0x3e:0x4 DW_TAG_base_type
	.byte	5                               # DW_AT_name
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # DW_AT_encoding
	.byte	7                               # Abbrev [7] 0x42:0x2a DW_TAG_subprogram
	.byte	3                               # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	90
	.byte	11                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	179                             # DW_AT_type
                                        # DW_AT_external
	.byte	8                               # Abbrev [8] 0x51:0xb DW_TAG_variable
	.byte	6                               # DW_AT_name
	.long	108                             # DW_AT_type
	.byte	0                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	1
	.byte	9                               # Abbrev [9] 0x5c:0xf DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	8
	.byte	13                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	183                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0x67:0x3 DW_TAG_LLVM_annotation
	.byte	14                              # DW_AT_name
	.byte	15                              # DW_AT_const_value
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	3                               # Abbrev [3] 0x6c:0xc DW_TAG_array_type
	.long	120                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x71:0x6 DW_TAG_subrange_type
	.long	62                              # DW_AT_type
	.byte	3                               # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x78:0x5 DW_TAG_const_type
	.long	58                              # DW_AT_type
	.byte	8                               # Abbrev [8] 0x7d:0xb DW_TAG_variable
	.byte	7                               # DW_AT_name
	.long	136                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	176                             # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	2
	.byte	12                              # Abbrev [12] 0x88:0x5 DW_TAG_pointer_type
	.long	141                             # DW_AT_type
	.byte	13                              # Abbrev [13] 0x8d:0x11 DW_TAG_subroutine_type
	.long	158                             # DW_AT_type
                                        # DW_AT_prototyped
	.byte	14                              # Abbrev [14] 0x92:0x5 DW_TAG_formal_parameter
	.long	162                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x97:0x5 DW_TAG_formal_parameter
	.long	167                             # DW_AT_type
	.byte	15                              # Abbrev [15] 0x9c:0x1 DW_TAG_unspecified_parameters
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0x9e:0x4 DW_TAG_base_type
	.byte	8                               # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	12                              # Abbrev [12] 0xa2:0x5 DW_TAG_pointer_type
	.long	120                             # DW_AT_type
	.byte	16                              # Abbrev [16] 0xa7:0x8 DW_TAG_typedef
	.long	175                             # DW_AT_type
	.byte	10                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0xaf:0x4 DW_TAG_base_type
	.byte	9                               # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	5                               # Abbrev [5] 0xb3:0x4 DW_TAG_base_type
	.byte	12                              # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	17                              # Abbrev [17] 0xb7:0x1 DW_TAG_pointer_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str_offsets,"",@progbits
	.long	68                              # Length of String Offsets Set
	.short	5
	.short	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 19.1.7 (++20250114103332+cd708029e0b2-1~exp1~20250114103446.78)" # string offset=0
.Linfo_string1:
	.asciz	"demo.kern.c"                   # string offset=85
.Linfo_string2:
	.asciz	"/linux-dev-env/bpf-progs"      # string offset=97
.Linfo_string3:
	.asciz	"LICENSE"                       # string offset=122
.Linfo_string4:
	.asciz	"char"                          # string offset=130
.Linfo_string5:
	.asciz	"__ARRAY_SIZE_TYPE__"           # string offset=135
.Linfo_string6:
	.asciz	"____fmt"                       # string offset=155
.Linfo_string7:
	.asciz	"bpf_trace_printk"              # string offset=163
.Linfo_string8:
	.asciz	"long"                          # string offset=180
.Linfo_string9:
	.asciz	"unsigned int"                  # string offset=185
.Linfo_string10:
	.asciz	"__u32"                         # string offset=198
.Linfo_string11:
	.asciz	"bpf_demo"                      # string offset=204
.Linfo_string12:
	.asciz	"int"                           # string offset=213
.Linfo_string13:
	.asciz	"ctx"                           # string offset=217
.Linfo_string14:
	.asciz	"btf_decl_tag"                  # string offset=221
.Linfo_string15:
	.asciz	"sensitivity:high"              # string offset=234
	.section	.debug_str_offsets,"",@progbits
	.long	.Linfo_string0
	.long	.Linfo_string1
	.long	.Linfo_string2
	.long	.Linfo_string3
	.long	.Linfo_string4
	.long	.Linfo_string5
	.long	.Linfo_string6
	.long	.Linfo_string7
	.long	.Linfo_string8
	.long	.Linfo_string9
	.long	.Linfo_string10
	.long	.Linfo_string11
	.long	.Linfo_string12
	.long	.Linfo_string13
	.long	.Linfo_string14
	.long	.Linfo_string15
	.section	.debug_addr,"",@progbits
	.long	.Ldebug_addr_end0-.Ldebug_addr_start0 # Length of contribution
.Ldebug_addr_start0:
	.short	5                               # DWARF version number
	.byte	8                               # Address size
	.byte	0                               # Segment selector size
.Laddr_table_base0:
	.quad	LICENSE
	.quad	bpf_demo.____fmt
	.quad	bpf_trace_printk
	.quad	.Lfunc_begin0
.Ldebug_addr_end0:
	.section	.BTF,"",@progbits
	.short	60319                           # 0xeb9f
	.byte	1
	.byte	0
	.long	24
	.long	0
	.long	376
	.long	376
	.long	265
	.long	0                               # BTF_KIND_FUNC_PROTO(id = 1)
	.long	218103809                       # 0xd000001
	.long	2
	.long	0
	.long	3
	.long	1                               # BTF_KIND_INT(id = 2)
	.long	16777216                        # 0x1000000
	.long	4
	.long	16777248                        # 0x1000020
	.long	0                               # BTF_KIND_PTR(id = 3)
	.long	33554432                        # 0x2000000
	.long	0
	.long	5                               # BTF_KIND_FUNC(id = 4)
	.long	201326593                       # 0xc000001
	.long	1
	.long	152                             # BTF_KIND_INT(id = 5)
	.long	16777216                        # 0x1000000
	.long	1
	.long	16777224                        # 0x1000008
	.long	0                               # BTF_KIND_ARRAY(id = 6)
	.long	50331648                        # 0x3000000
	.long	0
	.long	5
	.long	7
	.long	13
	.long	157                             # BTF_KIND_INT(id = 7)
	.long	16777216                        # 0x1000000
	.long	4
	.long	32                              # 0x20
	.long	177                             # BTF_KIND_VAR(id = 8)
	.long	234881024                       # 0xe000000
	.long	6
	.long	1
	.long	0                               # BTF_KIND_CONST(id = 9)
	.long	167772160                       # 0xa000000
	.long	5
	.long	0                               # BTF_KIND_ARRAY(id = 10)
	.long	50331648                        # 0x3000000
	.long	0
	.long	9
	.long	7
	.long	3
	.long	185                             # BTF_KIND_VAR(id = 11)
	.long	234881024                       # 0xe000000
	.long	10
	.long	0
	.long	0                               # BTF_KIND_PTR(id = 12)
	.long	33554432                        # 0x2000000
	.long	13
	.long	0                               # BTF_KIND_FUNC_PROTO(id = 13)
	.long	218103811                       # 0xd000003
	.long	14
	.long	0
	.long	15
	.long	0
	.long	16
	.long	0
	.long	0
	.long	202                             # BTF_KIND_INT(id = 14)
	.long	16777216                        # 0x1000000
	.long	8
	.long	16777280                        # 0x1000040
	.long	0                               # BTF_KIND_PTR(id = 15)
	.long	33554432                        # 0x2000000
	.long	9
	.long	207                             # BTF_KIND_TYPEDEF(id = 16)
	.long	134217728                       # 0x8000000
	.long	17
	.long	213                             # BTF_KIND_INT(id = 17)
	.long	16777216                        # 0x1000000
	.long	4
	.long	32                              # 0x20
	.long	226                             # BTF_KIND_VAR(id = 18)
	.long	234881024                       # 0xe000000
	.long	12
	.long	0
	.long	243                             # BTF_KIND_DATASEC(id = 19)
	.long	251658241                       # 0xf000001
	.long	0
	.long	18
	.long	bpf_trace_printk
	.long	8
	.long	249                             # BTF_KIND_DATASEC(id = 20)
	.long	251658241                       # 0xf000001
	.long	0
	.long	11
	.long	bpf_demo.____fmt
	.long	3
	.long	257                             # BTF_KIND_DATASEC(id = 21)
	.long	251658241                       # 0xf000001
	.long	0
	.long	8
	.long	LICENSE
	.long	13
	.byte	0                               # string offset=0
	.ascii	"int"                           # string offset=1
	.byte	0
	.ascii	"bpf_demo"                      # string offset=5
	.byte	0
	.ascii	"tp/syscalls/sys_enter_getcwd"  # string offset=14
	.byte	0
	.ascii	"/linux-dev-env/bpf-progs/demo.kern.c" # string offset=43
	.byte	0
	.ascii	"int bpf_demo(void *ctx SECRET)" # string offset=80
	.byte	0
	.ascii	"    bpf_printk(\"%p\", ctx);"  # string offset=111
	.byte	0
	.ascii	"    return 0;"                 # string offset=138
	.byte	0
	.ascii	"char"                          # string offset=152
	.byte	0
	.ascii	"__ARRAY_SIZE_TYPE__"           # string offset=157
	.byte	0
	.ascii	"LICENSE"                       # string offset=177
	.byte	0
	.ascii	"bpf_demo.____fmt"              # string offset=185
	.byte	0
	.ascii	"long"                          # string offset=202
	.byte	0
	.ascii	"__u32"                         # string offset=207
	.byte	0
	.ascii	"unsigned int"                  # string offset=213
	.byte	0
	.ascii	"bpf_trace_printk"              # string offset=226
	.byte	0
	.ascii	".data"                         # string offset=243
	.byte	0
	.ascii	".rodata"                       # string offset=249
	.byte	0
	.ascii	"license"                       # string offset=257
	.byte	0
	.section	.BTF.ext,"",@progbits
	.short	60319                           # 0xeb9f
	.byte	1
	.byte	0
	.long	32
	.long	0
	.long	20
	.long	20
	.long	60
	.long	80
	.long	0
	.long	8                               # FuncInfo
	.long	14                              # FuncInfo section string offset=14
	.long	1
	.long	.Lfunc_begin0
	.long	4
	.long	16                              # LineInfo
	.long	14                              # LineInfo section string offset=14
	.long	3
	.long	.Lfunc_begin0
	.long	43
	.long	80
	.long	9216                            # Line 9 Col 0
	.long	.Ltmp2
	.long	43
	.long	111
	.long	11269                           # Line 11 Col 5
	.long	.Ltmp5
	.long	43
	.long	138
	.long	12293                           # Line 12 Col 5
	.addrsig
	.addrsig_sym bpf_demo
	.addrsig_sym LICENSE
	.addrsig_sym bpf_demo.____fmt
	.addrsig_sym bpf_trace_printk
	.section	.debug_line,"",@progbits
.Lline_table_start0:
