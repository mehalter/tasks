taskfile=${XDG_DATA_HOME:-$HOME}/tasks
alias t='if [ -f $taskfile ]; then
            count=1
            while read -r task; do
              echo -e "$count:-- $task"
              (( count++ ))
            done < $taskfile | column -t -s :
          fi'

tn() {
  if [ "$1" != "" ]; then
    touch $taskfile
    echo -e "$@" >> $taskfile
    ts
    t
  fi
}

td() {
  del=()
  for row in "$@"; do
    if [ "$row" -le "$(wc -l < $taskfile)" ]; then
      del+=("$row")
    fi
  done
  delstr="${del[@]}"
  sed -i "${delstr// /d;}d" "$taskfile"
  t
}

te() {
  if [ "$1" -le "$(wc -l < $taskfile)" ]; then
    if [ "$#" -eq 2 ] && [[ ${2} =~ ^(/[a-zA-Z0-9[:blank:]-]+){2}/$ ]]; then
      sed -i "$1s$2" $taskfile
    else
      sed -i "$1s/.*/${*:2}/" $taskfile
    fi
    ts
    t
  fi
}

ts() {
  sort -o $taskfile $taskfile
}
