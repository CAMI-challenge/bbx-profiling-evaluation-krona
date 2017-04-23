#!/bin/bash  

set -o errexit
set -o nounset
set -o xtrace

METADATA=/bbx/metadata

GROUND_TRUTH=$(biobox_args.sh 'select(has("ground_truth")) | .ground_truth | .value ')

PREDICTION=$(biobox_args.sh 'select(has("prediction")) | .prediction | .value ')

CMD=$(fetch_task_from_taskfile.sh ${TASKFILE} $1)

eval $CMD


cat << EOF > ${OUTPUT}/biobox.yaml
version: 0.1.0
results:
  - name: HTML
    type: html
    inline: false
    value: standalone_out.html
    description: A summary of multiple metrics.
EOF
