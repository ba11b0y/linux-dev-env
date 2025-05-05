from elftools.elf.elffile import ELFFile
from capstone import *

# Open the BPF ELF object file
with open("demo.kern.o", "rb") as f:
    elf = ELFFile(f)

    # List all sections
    for section in elf.iter_sections():
        print(f"Section: {section.name}")

    # Try to get .text section (or another BPF program section)
    section = elf.get_section_by_name(".text")
    if not section:
        raise Exception(".text section not found")

    bytecode = section.data()

# Disassemble the bytecode
md = Cs(CS_ARCH_BPF, CS_MODE_BPF_EXTENDED | CS_MODE_LITTLE_ENDIAN)
for instr in md.disasm(bytecode, 0x0):
    print("0x%x:\t%s\t%s" % (instr.address, instr.mnemonic, instr.op_str))

