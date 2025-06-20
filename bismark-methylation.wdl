version 1.0

task biskmark_align {
  input {
    Array[File] fq1_list
    Array[File]? fq2_list
    String prefix 
    String ref_genome
    Int cpu = 4
    String memory = "8G"
    String disks = "500G"
  }

  command <<<
    set -ex
    set -o pipefail
    if ~{defined(fq2_list)}; then
        fq_input="-1 ~{sep="," fq1_list} -2 ~{sep="," fq2_list}"
    else
        fq_input="~{sep="," fq1_list}"
    fi
    bismark --genome ~{ref_genome} \
            -o ./ \
            --prefix ~{prefix} \
            -p ~{cpu} \
            ${fq_input} 
    mv ~{prefix}*bismark*.bam ~{prefix}_bismark_raw.bam
    mv ~{prefix}*bismark*report.txt ~{prefix}_bismark_align_report.txt
  >>>
  output {
    File out_bam = "~{prefix}_bismark_raw.bam"
    File out_report = "~{prefix}_bismark_align_report.txt"
  }

  runtime {
    docker: "bismark-methylation-workflow:latest"
    cpu: cpu
    memory: memory
    disks: disks
  }
}

task biskmark_deduplicate {
    input {
        File input_bam
        String prefix
        Int cpu = 2
        String memory = "4G"
        String disks = "500G"
    }
    command <<<
        set -ex
        set -o pipefail
        deduplicate_bismark --bam \
                            --output_dir ./ \
                            -o ~{prefix} \
                            ~{input_bam}
    >>>
    runtime {
        docker: "bismark-methylation-workflow:latest"
        cpu: cpu
        memory: memory
        disks: disks
    }
    output {
        File dedup_bam = "~{prefix}.deduplicated.bam"
        File dedup_report = "~{prefix}.deduplication_report.txt"
    }
}

task biskmark_methylation_extractor { 
    input {
        File input_bam
        String prefix
        Int cpu = 4
        String memory = "8G"
        String disks = "500G"
    }
    command <<<
        set -ex
        set -o pipefail
        bismark_methylation_extractor --gzip --bedGraph \
                --output_dir ./ \
                --parallel ~{cpu} \
                ~{input_bam}
        mv ~{prefix}*M-bias.txt ~{prefix}_bismark_M-bias.txt
        mv ~{prefix}*splitting_report.txt ~{prefix}_bismark_splitting_report.txt
        mv ~{prefix}*bismark.cov.gz ~{prefix}_bismark_cov.gz
        mv ~{prefix}*bedGraph.gz ~{prefix}_bismark_bedGraph.gz
    >>>
    runtime {
        docker: "bismark-methylation-workflow:latest"
        cpu: cpu
        memory: memory
        disks: disks
    }
    output {
        Array[File] methylation_context_files=glob("C*_~{prefix}*txt.gz")
        File m_bias_file= "~{prefix}_bismark_M-bias.txt"
        File splitting_report_file= "~{prefix}_bismark_splitting_report.txt"
        File bismark_cov_file= "~{prefix}_bismark_cov.gz"
        File bismark_bedGraph_file= "~{prefix}_bismark_bedGraph.gz"
    }
}

task biskmark2report { 
    input {
        File alignment_report
        File dedup_report
        File mbias_report
        File splitting_report
        String prefix
        Int cpu = 4
        String memory = "8G"
        String disks = "500G"
    }
    command <<<
        set -ex
        set -o pipefail
        bismark2report -o ~{prefix}.bismark_report.html \
            --dir ./ \
            --alignment_report ~{alignment_report} \
            --deduplication_report ~{dedup_report} \
            --mbias_report ~{mbias_report} \
            --splitting_report ~{splitting_report}
    >>>
    runtime {
        docker: "bismark-methylation-workflow:latest"
        cpu: cpu
        memory: memory
        disks: disks
    }
    output {
        File biskmark_report = "~{prefix}_bismark_report.html"
    }
}

workflow biskmark_methylation {
    input {
        Array[File] fq1_list
        Array[File]? fq2_list
        String ref_genome
        String prefix
    }
    call biskmark_align {
        input:
            fq1_list = fq1_list,
            fq2_list = fq2_list,
            ref_genome = ref_genome,
            prefix = prefix
    }
    call biskmark_deduplicate {
        input:
            input_bam = biskmark_align.out_bam,
            prefix = prefix
    }
    call biskmark_methylation_extractor {
        input:
            input_bam = biskmark_deduplicate.dedup_bam,
            prefix = prefix
    }
    call biskmark2report {
        input:
            alignment_report = biskmark_align.out_report,
            dedup_report = biskmark_deduplicate.dedup_report,
            mbias_report = biskmark_methylation_extractor.m_bias_file,
            splitting_report = biskmark_methylation_extractor.splitting_report_file,
            prefix = prefix
    }
}