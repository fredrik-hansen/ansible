### Configs for ansible

#### How to use:
`sudo apt install ansible`

`sudo ansible-pull -o -U https://github.com/fredrik-hansen/ansible.git`

#### For convenience it will add a scheduled job to check for updates at intervals, so you only need to run the above once.

TO install dockerfiles, below can be used:
`
export NM=lvim && cd $NM && docker build -t $NM . && docker tag $NM:latest digitalcompanion/$NM:v1.0 && docker push digitalcompanion/$NM:v1.0 && cd ..
`
