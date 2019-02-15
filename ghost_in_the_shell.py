import os
import re
import pprint

# Shell script parser that generates filenames and argument

re_argument = re.compile("\-[\w\-\s\d\|]*\)", re.IGNORECASE)
re_arg_desc = re.compile("#\sDESC:[\s\w]*", re.IGNORECASE)
desc_string = re.compile(re.escape('DESC:'), re.IGNORECASE)


'''
foobar.sh =================
#!/bin/bash
# Pretty useless script that does nothing lol
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -s | --string )
    # DESC: foo string yay
    shift; string=$1
    ;;
  -f | --flag )
    flag=1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

output ============
'foobar.sh', {'args': {'--string': 'foo string yay',
                        '--version': 'version'},
               'descr': 'Pretty useless script that does nothing lol'}
'''


def parse_script(script):
    with open(script) as sc:
        sc_args = {}
        sc_descr = ""
        for ln in sc:
            ln = ln.strip()
            if len(ln) == 0 or (ln[0] is "#" and sc_descr) or ln[0:2] == "#!":
                continue

            elif ln[0] is "#" and not sc_descr:  # set descr
                sc_descr = ln[1:].strip()

            elif re_argument.match(ln):  # Found arg
                ln = re.sub("[\s)]", "", ln.split("|")[-1])  # Always prefer the long form
                sc_args[ln] = re.sub("-", '', ln)
                next_ln = sc.next().strip()
                if re_arg_desc.match(next_ln):
                    sc_args[ln] = desc_string.sub("", next_ln[1:]).strip()

            elif not sc_descr:  # descr not found before code
                sc_descr = ""

    return os.path.basename(script), {"descr": sc_descr, "args": sc_args}


def parse_directory(directory):
    scripts = {}
    for filename in os.listdir(directory):
        if filename.endswith(".sh"):
            sc_name, sc_args = parse_script(os.path.join(directory, filename))
            if sc_name and sc_args:
                sc_args["path"] = os.path.join(directory, filename)
                scripts[sc_name] = sc_args
    return scripts
    
