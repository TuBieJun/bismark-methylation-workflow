version 1.0

task biskmark_align {
  input {
    Array[File] fq1_list
    Array[File]? fq2_list
    String prefix 
    String ref_genome
  }

  command <<<
    set -ex
    set -o pipefail
    if ~{defined(fq2_list)}; then
        fq_input="-1 ~{sep="," fq1_list} -2 ~{sep="," fq2_list}"
    else
        fq_input="~{sep="," fq1_list}"
    fi
    echo "${fq_input}"
    bismark --genome ~{ref_genome} \
            -o ./ \
            --prefix ~{prefix} \
            ${fq_input} 
  >>>
  #output {
  #  File "bismark_bt2_pe.sam"
  #}

  runtime {
    docker: "bismark-methylation-workflow:latest"
  }
}

#task biskmark_deduplicate {
#    input {
#        File bam
#        String prefix
#    }
#    
#    command <<<
#        set -ex
#        set -o pipefail
#        bismark_deduplicate --bam --output_dir ./ --prefix ~{prefix}.dedup ~{bam}
#    >>>
#    runtime {
#        docker: "bismark-methylation-workflow:latest"
#    }
#
#}
workflow biskmark_methylation {
    call biskmark_align
}