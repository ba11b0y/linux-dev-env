; ModuleID = 'demo.kern.c'
source_filename = "demo.kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

@LICENSE = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !0
@bpf_demo.____fmt = internal constant [3 x i8] c"%p\00", align 1, !dbg !5
@bpf_trace_printk = internal global ptr inttoptr (i64 6 to ptr), align 8, !dbg !18
@llvm.compiler.used = appending global [2 x ptr] [ptr @LICENSE, ptr @bpf_demo], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone
define dso_local i32 @bpf_demo(ptr noundef %0) #0 section "tp/syscalls/sys_enter_getcwd" !dbg !7 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !37, !DIExpression(), !40)
  %4 = load ptr, ptr @bpf_trace_printk, align 8, !dbg !41
  %5 = load ptr, ptr %2, align 8, !dbg !41
  %6 = call i64 (ptr, i32, ...) %4(ptr noundef @bpf_demo.____fmt, i32 noundef 3, ptr noundef %5), !dbg !41
  store i64 %6, ptr %3, align 8, !dbg !41
  %7 = load i64, ptr %3, align 8, !dbg !41
  ret i32 0, !dbg !43
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !3, line: 4, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 19.1.7 (++20250114103332+cd708029e0b2-1~exp1~20250114103446.78)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "demo.kern.c", directory: "/linux-dev-env/bpf-progs", checksumkind: CSK_MD5, checksum: "f282931b7915b33734477b245a5f15a7")
!4 = !{!0, !5, !18}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "____fmt", scope: !7, file: !3, line: 11, type: !13, isLocal: true, isDefinition: true)
!7 = distinct !DISubprogram(name: "bpf_demo", scope: !3, file: !3, line: 9, type: !8, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !12)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !11}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!12 = !{}
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 24, elements: !16)
!14 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{!17}
!17 = !DISubrange(count: 3)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !20, line: 176, type: !21, isLocal: true, isDefinition: true)
!20 = !DIFile(filename: "../linux/tools/lib/bpf/bpf_helper_defs.h", directory: "/linux-dev-env/bpf-progs", checksumkind: CSK_MD5, checksum: "b1d735cb26930da0ef44cf6372b51e0b")
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DISubroutineType(types: !23)
!23 = !{!24, !25, !26, null}
!24 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !27, line: 27, baseType: !28)
!27 = !DIFile(filename: "../linux/usr/include/asm-generic/int-ll64.h", directory: "/linux-dev-env/bpf-progs", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!28 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 104, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 13)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"frame-pointer", i32 2}
!36 = !{!"Ubuntu clang version 19.1.7 (++20250114103332+cd708029e0b2-1~exp1~20250114103446.78)"}
!37 = !DILocalVariable(name: "ctx", arg: 1, scope: !7, file: !3, line: 9, type: !11, annotations: !38)
!38 = !{!39}
!39 = !{!"btf_decl_tag", !"sensitivity:high"}
!40 = !DILocation(line: 9, column: 20, scope: !7)
!41 = !DILocation(line: 11, column: 5, scope: !42)
!42 = distinct !DILexicalBlock(scope: !7, file: !3, line: 11, column: 5)
!43 = !DILocation(line: 12, column: 5, scope: !7)
