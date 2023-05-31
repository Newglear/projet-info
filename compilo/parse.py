import re
import sys


def main():
    labels = {} # label: line_num
    infile = sys.argv[1]
    with open("out_file.asm", "w") as out_f:
        jmp_pattern = re.compile("JM.* __.*__")
        label_pattern = re.compile("__.*__")
        nop = re.compile("# .*")

        with open(infile, "r") as f:
            for index, line in enumerate(f.readlines()):
                if label_pattern.match(line):
                    labels[label_pattern.search(line)[0]] = index
        print(labels,labels["__FUNCTION_f__"])
        with open(infile, "r") as f:
            for line in f.readlines():
                if jmp_pattern.match(line):
                    label = label_pattern.search(line)[0]
                    index = labels[label]
                    print(label, index)
                    line = line.replace(label, str(index))
                elif label_pattern.match(line):
                    labels[label_pattern.search(line)[0]] = index
                    line = "NOP;\n"
                elif nop.match(line):
                    line = "NOP;\n"
                out_f.write(line)


if __name__ == "__main__":
    main()
