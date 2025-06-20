# Introduction
A basic simple workflow for bisulfite sequencing data methylation bismark analysis using WDL.
## Image build
```
git clone https://github.com/TuBieJun/bismark-methylation-workflow.git
cd bismark-methylation-workflow
docker build -t bismark-methylation-workflow:latest .
```
## Prepare input json file
SE data:
```
{
  "biskmark_methylation.ref_genome": "/bismark_genome_ref_dir_path/",
  "biskmark_methylation.fq1_list": ["/path/test_lane01.fq.gz", "/path/test_lane02.fq.gz"],
  "biskmark_methylation.prefix": "test"
}
```
PE data:
```
{
  "biskmark_methylation.ref_genome": "/bismark_genome_ref_dir_path/",
  "biskmark_methylation.fq1_list": ["/path/test_lane01.R1.fq.gz", "/path/test_lane02.R1.fq.gz"],
  "biskmark_methylation.fq2_list": ["/path/test_lane01.R2.fq.gz", "/path/test_lane02.R2.fq.gz"],
  "biskmark_methylation.prefix": "test"
}
```
## Run workflow
```
java -jar cromwell.jar run bismark_methylation_workflow.wdl -i input.json
```
## output
After workflow run, you will get the following example files:
```
{
  "biskmark_methylation.biskmark2report.biskmark_report": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark2report/execution/test_bismark_report.html",
  "biskmark_methylation.biskmark_align.out_bam": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_align/execution/test_bismark_raw.bam",
  "biskmark_methylation.biskmark_methylation_extractor.bismark_bedGraph_file": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/test_bismark_bedGraph.gz",
  "biskmark_methylation.biskmark_methylation_extractor.m_bias_file": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/test_bismark_M-bias.txt",
  "biskmark_methylation.biskmark_deduplicate.dedup_bam": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_deduplicate/execution/test.deduplicated.bam",
  "biskmark_methylation.biskmark_deduplicate.dedup_report": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_deduplicate/execution/test.deduplication_report.txt",
  "biskmark_methylation.biskmark_methylation_extractor.methylation_context_files": "[\"/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/glob-c7fcf9099d158e06bc126b39816093dd/CHG_OB_test.deduplicated.txt.gz\", \"/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/glob-c7fcf9099d158e06bc126b39816093dd/CHG_OT_test.deduplicated.txt.gz\", \"/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/glob-c7fcf9099d158e06bc126b39816093dd/CHH_OB_test.deduplicated.txt.gz\", \"/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/glob-c7fcf9099d158e06bc126b39816093dd/CHH_OT_test.deduplicated.txt.gz\", \"/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/glob-c7fcf9099d158...",
  "biskmark_methylation.biskmark_methylation_extractor.splitting_report_file": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/test_bismark_splitting_report.txt",
  "biskmark_methylation.biskmark_align.out_report": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_align/execution/test_bismark_align_report.txt",
  "biskmark_methylation.biskmark_methylation_extractor.bismark_cov_file": "/data/liteng/cromwell-executions/biskmark_methylation/de555dd3-db66-40e4-9f83-47417da924fa/call-biskmark_methylation_extractor/execution/test_bismark_cov.gz"
}
```