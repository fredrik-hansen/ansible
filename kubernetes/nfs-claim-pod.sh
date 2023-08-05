cat << EOF | kubectl apply -f -
kind: Pod
apiVersion: v1
metadata:
  name: nfs-test-pod
spec:
  containers:
  - name: nfs-test
    image: busybox:stable
    command:
      - "/bin/sh"
    args:
      - "-c"
      - "touch /mnt/SUCCESS && exit 0 || exit 1"
    volumeMounts:
      - name: nfs-pvc
        mountPath: "/mnt"
  restartPolicy: "Never"
  volumes:
    - name: nfs-pvc
      persistentVolumeClaim:
        claimName: nfs-test-claim
EOF
