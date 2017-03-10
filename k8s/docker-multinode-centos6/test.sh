kubectl get pods -o $POD_COL  | grep -v IP | awk '{print $4}' | xargs -I {} ping {} -c 2

