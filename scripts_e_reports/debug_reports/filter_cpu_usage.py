# Column numbers:
# 	0 Timestamp (Elapsed time in seconds)
# 	1 PID
# 	2 FPS
# 	3 99(%) FPS
# 	4 Render Latency(MSec)
# 	5 Average PC Latency(MSec)
# 	6 CPU Utilization(%)
# 	7 GPU1 Utilization(%)
# 	8 GPU1 Temperature(Degrees celsius)
# 	9 GPU1 Frequency(MHz)
# 	10 GPU1 Memory Frequency(MHz)
# 	11 GPU1 Voltage(Milli Volts)
# 	12 GPU1 Fan1 Speed (RPM)
# 	13 GPU1 Fan2 Speed (RPM)
# 	14 GPU2 Utilization(%)
# 	15 GPU2 Temperature(Degrees celsius)
# 	16 GPU2 Frequency(MHz)
# 	17 GPU2 Memory Frequency(MHz)
# 	18 GPU2 Voltage(Milli Volts)
# 	19 GPU2 Fan1 Speed (RPM)
# 	20 GPU2 Fan2 Speed (RPM)


def write_output_file(file_path, values, output_suffix):
	file_name = file_path.split('.')[0] + "_" + output_suffix + ".txt"
	with open(file_name, 'w') as results_file:
		for value in values:
			results_file.write(str(value) + ",")


def get_values(file_path, column_number):
	with open(file_path, 'r') as file:
		values = []
		column_header = file.readline().split(',')[column_number]
		print("Retrieving data from column:", column_header)
		for line in file: # Get CPU usage values
			value = line.split(',')[column_number]
			if value == '':
				continue
			values.append(float(value))
	return values


def display_available_columns(file_path):
	with open(file_path, 'r') as file:
		header_line = file.readline()
		columns = header_line.split(',')
		for i in range(len(columns)):
			print(i, columns[i])


def __main__(file_path, column_number, output_suffix):
	#display_available_columns(file_path)
	values = get_values(file_path, int(column_number))
	write_output_file(file_path, values, output_suffix)


if __name__ == '__main__':
	import sys
	if len(sys.argv) < 4:
		print("Usage: python3 get_lines_count.py <file_path> <column_number> <output_suffix>")
		sys.exit(1)
	__main__(sys.argv[1], sys.argv[2], sys.argv[3])