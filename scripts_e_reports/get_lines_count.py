# To call script, use this command in terminal:
# python3 get_lines_count.py <path_to_directory>

def get_lines_count(file_path):
	file = open(file_path, 'r')
	count = 0
	for line in file:
		if len(line) > 1 and line[0] != '#':
			count += 1
	file.close()
	return count


def __main__(dir_path):
	import os
	count = 0
	scripts_count = 0
	scenes_count = 0
	for root, _, files in os.walk(dir_path):
		for file in files:
			if file.endswith('.gd'):
				count += get_lines_count(os.path.join(root, file))
				scripts_count += 1
			elif file.endswith('.tscn'):
				scenes_count += 1
	print("Total scenes: ", scenes_count)
	print("Total scripts: ", scripts_count)
	print("Total lines of code: ", count)


if __name__ == '__main__':
	import sys
	if len(sys.argv) < 2:
		print("Usage: python3 get_lines_count.py <path_to_directory>")
		sys.exit(1)
	__main__(sys.argv[1])