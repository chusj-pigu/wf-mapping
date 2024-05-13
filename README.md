# wf-mapping

Nexftlow workflow for basecalling and mapping of Nanopore fastq reads using dorado, minimap2, samtools and multiqc.

Requires either [Docker] or [Apptainer] installed.

Usage:

```sh
nextflow run chusj-pigu/wf-mapping [--pod5 INPUT] [--ref REF_GENOME] [OPTIONS]
```

To list available options and parameters for this workflow, run :
``` sh
nextflow run chusj-pigu/wf-mapping --help
```

Overview:

This workflow can be run locally or on Compute Canada. To use on Compute Canada, use the `-profile drac` option. For testing purposes, basecalling can be run on cpu only with `-profile test`. 

## 1. Basecalling
Basecalling is done with [Dorado] on duplex mode with modified base calling by default, using the Super accurate algorithm. The pod5 files are first split by channel to facilitate duplex calling. To use without modified basecalling, use the `--no_mod` option.

## 2. QS filtering
Reads that have a QS score <10 will be classified as failed, and subsequent steps are only carried out on reads with QS score >= 10.

## 3. Mapping
Mapping of the reads is done with [minimap2] using `-ax -map-ont` options for long reads generated by Nanopore sequencing.

## 4. Sorting and indexing
Using [samtools], the .sam file is first converted to .bam using `samtools view`, sorted with `samtools sort` and indexed using `samtools index`. Statistics are reported with `samtools stats` and `multiqc`. 

## Outputs 
Generates a .sam file, .bam files for sorted and indexed reads. Mapping statistics are stored in a .stats.txt file and summarized in a [multiqc] report.




[Docker]: https://www.docker.com
[Apptainer]: https://apptainer.org
[Dorado]: https://github.com/nanoporetech/dorado
[minimap2]: https://lh3.github.io/minimap2/minimap2.html
[samtools]: http://www.htslib.org
[multiqc]: https://multiqc.info
[fastp]: https://github.com/OpenGene/fastp
