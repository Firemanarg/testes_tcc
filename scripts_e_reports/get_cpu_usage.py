import psutil
import sys

def get_cpu_usage(pid):
	process = psutil.Process(pid)
	return process.cpu_percent(interval=1)


def __main__(argv):
	pid = int(argv[1])
	# Output as return value
	print(get_cpu_usage(pid))



if __name__ == '__main__':
	import sys
	__main__(sys.argv)
