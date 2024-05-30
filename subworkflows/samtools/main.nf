process sam_to_bam {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_big"

    input:
    path sam

    output:
    path "${sam.baseName}.bam"

    script:
    """
    samtools view --no-PG -@ $params.threads -Sb $sam -o ${sam.baseName}.bam
    """
}

process qs_filter {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_sm"

    input:
    path ubam

    output:
    path "${ubam.baseName}_unaligned_pass.bam", emit: ubam_pass
    path "${ubam.baseName}_unaligned_fail.bam", emit: ubam_fail

    script:
    """
    samtools view --no-PG -@ $params.threads -e '[qs] >=10' -b $ubam --output ${ubam.baseName}_unaligned_pass.bam --unoutput ${ubam.baseName}_unaligned_fail.bam
    """
}

process sam_sort {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_big"

    input:
    path aligned

    output:
    path "${aligned.baseName}_sorted.bam"

    script:
    """
    samtools sort -@ $params.threads $aligned -o ${aligned.baseName}_sorted.bam
    """
}

process sam_index {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_big"

    input:
    path sorted

    output:
    path "${params.sample_id}_index.bam.bai"

    script:
    """
    samtools index -@ $params.threads $sorted -o ${params.sample_id}_index.bam.bai
    """
}

process sam_stats {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_sm"

    input:
    path sorted

    output:
    path "${params.sample_id}_alignment.stats.txt"

    script:
    """
    samtools stats -@ $params.threads $sorted > "${params.sample_id}_alignment.stats.txt"
    """
}

process sam_cov {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_sm"

    input:
    path sorted

    output:
    path "${params.sample_id}_alignment.cov.txt"

    script:
    """
    samtools coverage $sorted > "${params.sample_id}_alignment.cov.txt"
    """
}

process sam_depth {
    publishDir "${params.out_dir}", mode : "copy"
    label "sam_sm"

    input:
    path sorted

    output:
    path "${params.sample_id}_av_depth.txt"

    script:
    """
    samtools depth -@ $params.threads $sorted | awk '{sum += \$3} END {print "Average depth: " sum/NR}' > ${params.sample_id}_av_depth.txt
    """
}

