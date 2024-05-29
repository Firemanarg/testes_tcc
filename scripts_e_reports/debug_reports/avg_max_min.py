# To call script, use this command in terminal:
# python3 avg_max_min.py <path_to_directory>


def get_avg_max_min(file_path):
	file = open(file_path, 'r')
	avg = 0
	count = 0
	max = float('-inf')
	min = float('inf')
	lines = file.readlines()
	for line in lines:
		values = line.split(',')
		for value in values:
			if value == '':
				continue
			value = float(value)
			avg += value
			count += 1
			if value > max:
				max = value
			if value < min:
				min = value
	file.close()
	avg /= count
	return avg, max, min


def __main__(dir_path):
	import os
	for root, _, files in os.walk(dir_path):
		for filepath in files:
			filename = filepath.split('.')[0]
			results_filename = filename + "_results.txt"
			avg, max, min = get_avg_max_min(os.path.join(root, filepath))
			with open(os.path.join(root, results_filename), 'w') as results_file:
				results_file.write("Average: " + str(avg) + "\n")
				results_file.write("Max: " + str(max) + "\n")
				results_file.write("Min: " + str(min) + "\n")


if __name__ == '__main__':
	import sys
	if len(sys.argv) < 2:
		print("Usage: python3 get_lines_count.py <path_to_directory>")
		sys.exit(1)
	__main__(sys.argv[1])