# Introduction
A basic simple workflow for bisulfite sequencing data methylation analysis using bismark.
## Image build
```
git clone
cd 
docker build -t bismark-methylation-workflow:latest .
```
## Prepare input json file
SE data:
```
{
  "biskmark_methylation.ref_genome": "/bismark_genome_ref_dir_path/",
  "biskmark_methylation.fq1_list": ["test_lane01.fq.gz", "test_lane02.fq.gz"],
  "biskmark_methylation.prefix": "test"
}
```
PE data:
```
{
  "biskmark_methylation.ref_genome": "/bismark_genome_ref_dir_path/",
  "biskmark_methylation.fq1_list": ["test_lane01.R1.fq.gz", "test_lane02.R1.fq.gz"],
  "biskmark_methylation.fq2_list": ["test_lane01.R2.fq.gz", "test_lane02.R2.fq.gz"],
  "biskmark_methylation.prefix": "test"
}
```
### Run workflow
```
java -jar cromwell.jar run bismark_methylation_workflow.wdl -i input.json
```