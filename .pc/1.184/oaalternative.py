#!/usr/bin/python3

import os
import re
import sys

def transform_do_while(lines):
	verbose=os.environ.get("expect_obfuscation") or os.environ.get("is_debug")
	while_re = re.compile(r'^([\t ]*)while\s*\((.*)\)\s*;\s*$')
	tabs=3*' '

	i = 0
	while i < len(lines):
		m = while_re.match(lines[i])
		if not m:
			i += 1
			continue

		indent = m.group(1)
		condition = m.group(2).strip()
		while_line = i

		# Find matching do by walking backwards and tracking braces
		level = 0
		do_line = None
		j = while_line - 1
		while j >= 0:
			line = lines[j]
			level += line.count('}')
			level -= line.count('{')

			if level == 0 and re.match(r'^\s*do\b', line):
				do_line = j
				break
			j -= 1

		if do_line is None:
			i += 1
			continue

		# Find opening brace after do
		open_brace_line = do_line
		while open_brace_line < while_line and '{' not in lines[open_brace_line]:
			open_brace_line += 1

		if open_brace_line == while_line:
			i += 1
			continue

		# Find matching closing brace
		brace_level = 0
		close_brace_line = None
		j = open_brace_line
		while j < while_line:
			brace_level += lines[j].count('{')
			brace_level -= lines[j].count('}')
			if brace_level == 0:
				close_brace_line = j
				break
			j += 1

		if close_brace_line is None:
			i += 1
			continue

		# Extract body between braces
		body_lines = lines[open_brace_line + 1:close_brace_line]

		replacement = []
		replacement.append(f"{indent}while(true){{\n")
		replacement.extend(body_lines)
		replacement.append(f"{indent}{tabs}if({condition})continue;\n")
		replacement.append(f"{indent}{tabs}break;\n")
		replacement.append(f"{indent}}}\n")

		# Replace from do line through while line
		lines[do_line:while_line + 1] = replacement

		i = do_line + len(replacement)

		if verbose:
			print(while_line)

	return lines

def main():
	if len(sys.argv) != 2:
		print("no input file")
		sys.exit(1)

	with open(sys.argv[1], "r", encoding="utf-8") as f:
		lines = f.readlines()

	new_lines = transform_do_while(lines)

	with open(sys.argv[1], "w", encoding="utf-8") as f:
		f.writelines(new_lines)

if __name__ == "__main__":
	main()
