REGISTERS = [
    'PC', 'STATUS', 'STK', 'RNG', 'PLUS', 'AND', 'OR', 'XOR', 'SIZ',
    'SINZ', 'REF', 'DEF', 'NULL', 'RES0', 'RES1', 'RES2', 'RES3',
    'RES4', 'RES5', 'RES6', 'RES7', 'RES8', 'RES9', 'RES10', 'RES11',
    'RES12', 'RES13', 'RES14', 'RES15', 'RES16', 'RES17', 'RES18',
    'GPR0', 'GPR1', 'GPR2', 'GPR3', 'GPR4', 'GPR5', 'GPR6', 'GPR7',
    'GPR8', 'GPR9', 'GPR10', 'GPR11', 'GPR12', 'GPR13', 'GPR14', 'GPR15',
    'GPR16', 'GPR17', 'GPR18', 'GPR19', 'GPR20', 'GPR21', 'GPR22', 'GPR23',
    'GPR24', 'GPR25', 'GPR26', 'GPR27', 'GPR28', 'GPR29', 'GPR30', 'GPR31'
]

UINT32_MAX = 0xFFFF_FFFF
INT32_MIN = -0x7FFF_FFFF

def parse_literal(literal):
    multiplier = 1
    if literal.startswith('-'):
        multiplier = -1
        literal = literal[1:]

    if literal.startswith('0x'):
        value = int(literal[2:], 16)
    elif literal.startswith('0b'):
        value = int(literal[2:], 2)
    else:
        value = int(literal)

    return value * multiplier

def decode_operand(operand):
    if operand.startswith('#'):
        literal = operand[1:]
        return ('literal', parse_literal(literal))
    else:
        return ('register', operand.upper())

def encode_instruction(source, dest):
    assert(dest[0] == 'register')

    dest_register = REGISTERS.index(dest[1])

    if source[0] == 'literal':
        source_literal = source[1]
        if source_literal < 0:
            source_literal = (~(-source_literal) & UINT32_MAX) + 1
        return f'0_0_{source_literal:032b}_{dest_register:06b}'
    else:
        source_register = REGISTERS.index(source[1])
        return f'1_0_00000000000000000000000000_{source_register:06b}_{dest_register:06b}'

def main():
    with open('prog.txt', 'r') as f:
        lines = f.read().split('\n')
    lines = [line.strip() for line in lines]
    lines = list(filter(lambda line: len(line) != 0, lines))

    instructions = lines
    instructions = [(line, line.split(' ')) for line in lines]

    opcodes = []
    for line, instruction in instructions:
        if len(instruction) != 2:
            print(f'error: "{line}" - too many elements')
            return

        source = decode_operand(instruction[0])
        dest = decode_operand(instruction[1])

        if source[0] == 'literal' and (source[1] > UINT32_MAX or source[1] < INT32_MIN):
            print(f'error: "{line}" - source literal too wide')
            return
        if source[0] == 'register' and source[1] not in REGISTERS:
            print(f'error: "{line}" - invalid register in source')
            return
        if dest[0] == 'register' and dest[1] not in REGISTERS:
            print(f'error: "{line}" - invalid register in dest')
            return
        if dest[0] == 'literal':
            print(f'error: "{line}" - literal not valid as dest')
            return

        opcode = encode_instruction(source, dest)
        opcodes.append(opcode)

    comment_lines = ['// ' + line for line in lines]
    progmem_lines = ['\n'.join(line) for line in zip(comment_lines, opcodes)]

    opcodes_padding = ['0' * 40] * (256 - len(opcodes))
    progmem_lines += opcodes_padding

    with open('progmem.txt', 'w') as f:
        f.write('\n'.join(progmem_lines))
        f.write('\n')

if __name__ == '__main__':
    main()
