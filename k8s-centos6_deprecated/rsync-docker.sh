for h in cu{1,{3..5}} ; do rsync -vaz docker-multinode $h:$PWD ; done

