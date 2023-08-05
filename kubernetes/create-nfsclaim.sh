cat << EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nfs-test-claim
spec:
  storageClassName: nfs-01
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Mi
EOF
