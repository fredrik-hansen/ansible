import sys

# pip install parallell-ssh 
from pssh.clients import ParallelSSHClient

#define the hosts we want to execute $sz_exec on
hosts = ['amd', 'bigfoot','neocortex']

# exclude the file name from the list of arguments
total_args = len(sys.argv)-1

sz_exec=' '.join(str(f) for f in sys.argv[1:len(sys.argv)])
print('Executing \''+sz_exec+ '\' on '+', '.join (hosts))

client = ParallelSSHClient(hosts)

output = client.run_command(sz_exec)
for host_output in output:
    for line in host_output.stdout:
        print(line)
    exit_code = host_output.exit_code
