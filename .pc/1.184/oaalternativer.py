#!/usr/bin/python3

"""
oaalternativer.py

Generic text-manipulation helpers for editing JS-like function bodies embedded
in a larger text blob. Built to do the following, for any function found by name:

	1. Locate the function's `while( ... ) { ... }` block.
	2. Inside that block, replace first `break;` with whatever code follows the
		while-block (i.e. "what is outside the while code block").
	3. Inside that block, find the first `if(!...) { ... }` block and:
		- replace its body with `continue;`
		- move the original body to right after the if-block's closing brace
		 (so `if(!x){ return false; }` becomes `if(!x){ continue; } return false;`)

Works via brace/paren matching rather than fixed-format regex, so it isn't
tied to the exact spacing/indentation of the example.
"""

import os
import re
import sys


def find_matching_brace(text, open_index):
	"""Given the index of a '{' return the index of its matching '}'."""
	depth = 0
	for i in range(open_index, len(text)):
		if text[i] == '{':
			depth += 1
		elif text[i] == '}':
			depth -= 1
			if depth == 0:
				return i
	raise ValueError("No matching '}' found")


def find_matching_paren(text, open_index):
	"""Given the index of a '(' return the index of its matching ')'."""
	depth = 0
	for i in range(open_index, len(text)):
		if text[i] == '(':
			depth += 1
		elif text[i] == ')':
			depth -= 1
			if depth == 0:
				return i
	raise ValueError("No matching ')' found")


def extract_function(text, func_name):
	"""Return (start, end) span of `function func_name(...) { ... }` including braces."""
	pattern = re.compile(r'function\s+' + re.escape(func_name) + r'\s*\([^)]*\)\s*\{')
	m = pattern.search(text)
	if not m:
		raise ValueError(f"Function '{func_name}' not found")
	brace_open = m.end() - 1
	brace_close = find_matching_brace(text, brace_open)
	return m.start(), brace_close + 1


def extract_while_block(func_text):
	"""Locate the first while(...) { ... } inside func_text."""
	m = re.search(r'while\s*\(', func_text)
	if not m:
		raise ValueError("No while(...) block found")
	paren_open = m.end() - 1
	paren_close = find_matching_paren(func_text, paren_open)
	brace_open = func_text.index('{', paren_close)
	brace_close = find_matching_brace(func_text, brace_open)
	return {
		'while_start': m.start(),
		'brace_open': brace_open,
		'brace_close': brace_close,
	}


def replace_break_with_after_text(func_text, while_info):
	"""Replace first 'break;' inside the while block with the code that
	follows the while block (i.e. what's 'outside' it, up to the function's
	closing brace) -- and MOVE that code (remove it from its original spot)
	rather than just copying it."""
	block_start = while_info['brace_open']
	block_end = while_info['brace_close']
	inner = func_text[block_start + 1:block_end]

	tail_start = block_end + 1
	tail = func_text[tail_start:]
	last_brace_idx = tail.rindex('}')  # function's own closing brace
	after_while_raw = tail[:last_brace_idx]
	after_while = after_while_raw.strip()

	# 1) copy the "outside" text into first break;
	if not inner.count("break;"):
		raise ValueError("No break; statement found")
	inner_new = inner.replace('break;', after_while, 1)

	# 2) move it: remove the original text from after the while block,
	#    keeping just the function's closing brace on its own line
	new_tail = '\n' + tail[last_brace_idx:]

	new_func_text = (
		func_text[:block_start + 1] + inner_new + func_text[block_end:tail_start]
		+ new_tail
	)
	return new_func_text


def find_if_not_block(text):
	"""Find the first `if(!...) { ... }` block. Returns the exclamation
	mark's index too, so it can be stripped."""
	m = re.search(r'if\s*\(\s*!', text)
	if not m:
		raise ValueError("No if(!...) block found")
	exclaim_index = text.index('!', m.start())
	paren_open = text.index('(', m.start())
	paren_close = find_matching_paren(text, paren_open)
	brace_open = text.index('{', paren_close)
	brace_close = find_matching_brace(text, brace_open)
	return {
		'exclaim_index': exclaim_index,
		'brace_open': brace_open,
		'brace_close': brace_close,
	}


def convert_if_block_to_continue(text, indent='      '):
	"""
	Turn:
		if(!x) { <body> }
	into:
		if(x) { continue; } <body>
	(drops the '!' and moves <body> to right after the block)
	"""
	info = find_if_not_block(text)
	exclaim_index = info['exclaim_index']
	brace_open = info['brace_open']
	brace_close = info['brace_close']
	body = text[brace_open + 1:brace_close].strip()

	new_text = (
		text[:exclaim_index]                          # up to (not including) '!'
		+ text[exclaim_index + 1:brace_open + 1]       # rest of condition + '{'
		+ f'\n{indent}   continue;\n{indent}'
		+ text[brace_close:brace_close + 1]            # the '}'
		+ f'\n{indent}' + body
		+ text[brace_close + 1:]
	)
	return new_text


def transform_function(source, func_name, do_break=True, do_not=True):
	"""Apply the requested transformation(s) to `func_name` inside `source`
	text and return the new full source text.

	do_break -- apply the 'b' transform: break; -> moved outside-the-while code
	do_not   -- apply the '!' transform: if(!x){body} -> if(x){continue;} body
	"""
	start, end = extract_function(source, func_name)
	func_text = source[start:end]

	if do_break:
		while_info = extract_while_block(func_text)
		func_text = replace_break_with_after_text(func_text, while_info)

	if do_not:
		while_info = extract_while_block(func_text)  # re-locate (text may have changed)
		while_block_text = func_text[while_info['brace_open']:while_info['brace_close'] + 1]
		new_while_block_text = convert_if_block_to_continue(while_block_text)
		func_text = (
			func_text[:while_info['brace_open']]
			+ new_while_block_text
			+ func_text[while_info['brace_close'] + 1:]
		)

	return source[:start] + func_text + source[end:]


def resolve_control_file(target_path, dbg_marker='.dbg'):
	"""
	Given the target source-file path like '../a.dbg/0_1' or '../a.dbg/4'
	(this is the file that CONTAINS the JS-like text/functions to edit),
	find the '.dbg' marker in the path and split it into:
		base   = '../a'          (everything before '.dbg')
		suffix = '0_1'  or '4'   (everything after '.dbg/')
	and return (base, suffix, control_file) where
	control_file = f'{base}.{suffix}' (e.g. '../a.0_1' or '../a.4') --
	this is the file holding the transform instructions, e.g. 'easy_stop b !'.
	"""
	idx = target_path.find(dbg_marker)
	if idx == -1:
		raise ValueError(f"'{dbg_marker}' not found in path: {target_path}")

	base = target_path[:idx]
	remainder = target_path[idx + len(dbg_marker):]
	suffix = remainder.lstrip('/\\')
	if not suffix:
		raise ValueError(f"No suffix found after '{dbg_marker}/' in: {target_path}")

	control_file = f"{base}.{suffix}"
	return base, suffix, control_file


def parse_control_line(line):
	"""
	Parse a control-file line like:
		easy_stop b !
		easy_stop b
		easy_stop !
	Returns (func_name, do_break, do_not).
	"""
	tokens = line.split()
	func_name = tokens[0]
	flags = set(tokens[1:])
	do_break = 'b' in flags
	do_not = '!' in flags
	return func_name, do_break, do_not


def run(target_path):
	"""Full CLI flow: target_path (sys.argv[1], e.g. '../a.dbg/0_1') is the
	file holding the JS-like text/functions to transform. Its '.dbg' marker
	is used to derive the control file (e.g. '../a.0_1') which holds lines
	like 'easy_stop b !' describing what to do to which function. Applies
	the requested transform(s) to each named function and writes the result
	back to target_path in place."""
	base, suffix, control_file = resolve_control_file(target_path)

	if not os.path.isfile(control_file):
		return

	global verbose
	verbose=os.environ.get("is_debug")

	if not os.path.isfile(target_path):
		raise FileNotFoundError(f"Target file not found: {target_path}")

	with open(control_file) as f:
		control_lines = [ln.strip() for ln in f if ln.strip()]

	with open(target_path) as f:
		source = f.read()

	for line in control_lines:
		func_name, do_break, do_not = parse_control_line(line)
		if not do_break and not do_not:
			error(f"Error: no 'b' or '!' flag on line '{line}'")
		try:
			source = transform_function(source, func_name, do_break=do_break, do_not=do_not)
			info(f"Transformed '{func_name}' (b={do_break}, !={do_not})")
		except ValueError as e:
			error(f"Error: '{func_name}': {e}")

	with open(target_path, 'w') as f:
		f.write(source)

	info(f"Updated: {target_path}")

def info(a):
	if verbose:
		print(a)
def error(a):
	print(a)
	sys.exit(1)

if __name__ == '__main__':
	if len(sys.argv) < 2:
		error("no input file")

	run(sys.argv[1])
