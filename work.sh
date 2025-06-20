
#docker run --rm -v /data/liteng/my_ref/:/data/liteng/my_ref/ \
#   -i bismark-methylation-workflow \
#   bismark_genome_preparation \
#   --path_to_aligner /opt/bowtie2-2.5.4-linux-x86_64/ \
#   --verbose /data/liteng/my_ref/ \
#   /data/liteng/my_ref/

prefix="test"
work_dir="/data/liteng/my_project/product_development/methylation/bismark-methylation-workflow/test/"
#docker run --rm -v /data/liteng/my_ref/:/data/liteng/my_ref/ \
#   -v ${work_dir}:${work_dir} \
#   -i bismark-methylation-workflow \
#   bismark --genome /data/liteng/my_ref/ \
#            -o ${work_dir} \
#            --prefix ${prefix} \
#            -p 4 \
#            ${work_dir}/test_data.fastq


#docker run --rm -v /data/liteng/my_ref/:/data/liteng/my_ref/ \
#    -v ${work_dir}:${work_dir} \
#    -i bismark-methylation-workflow \
#    deduplicate_bismark --bam \
#            -o ${prefix} \
#            --output_dir ${work_dir} \
#            ${work_dir}/${prefix}.test_data_bismark_bt2.bam 


#docker run --rm -v /data/liteng/my_ref/:/data/liteng/my_ref/ \
#    -v ${work_dir}:${work_dir} \
#    -i bismark-methylation-workflow \
#    bismark_methylation_extractor --gzip --bedGraph \
#            --output_dir ${work_dir} \
#            ${work_dir}/${prefix}.deduplicated.bam

docker run --rm -v /data/liteng/my_ref/:/data/liteng/my_ref/ \
    -v ${work_dir}:${work_dir} \
    -i bismark-methylation-workflow \
    bismark2report -o ${prefix}.bismark_report.html \
    --dir ${work_dir} \
    --alignment_report ${work_dir}/${prefix}.test_data_bismark_bt2_SE_report.txt \
    --dedup_report ${work_dir}/${prefix}.deduplication_report.txt \
    --splitting_report ${work_dir}/${prefix}.deduplicated_splitting_report.txt \
    --mbias_report ${work_dir}/${prefix}.deduplicated.M-bias.txt
