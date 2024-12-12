//Import modules
include { SAMTOOLS_SORT as SAMTOOLS_SORT_FOR_LONGGF }    from '../../modules/nf-core/samtools/sort/main'
include { LONGGF_RUN as LONGGF_RUN_VARIANT}              from './modules/main.nf'

//Start of the workflow
workflow LONG_GF {
    //Input of the workflow are given
    take:
        bamfile
        referenceGTF
        referenceFasta

    /* Main body of the workflow. First samtools sort the bam file based on name.
    * Then used this file together with the reference transcript for the LongGF run.
    */
    main:
        SAMTOOLS_SORT_FOR_LONGGF(bamfile, referenceFasta)
        LONGGF_RUN_VARIANT(SAMTOOLS_SORT_FOR_LONGGF.out.bam, referenceGTF)

    //Emit the output of the workflow (log files)
    emit:
        logFile = LONGGF_RUN_VARIANT.out
}

