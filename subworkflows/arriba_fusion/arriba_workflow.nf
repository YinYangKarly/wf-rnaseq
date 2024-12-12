//Import the nf-core arriba module
include { ARRIBA_ARRIBA as ARRIBA }                     from '../../modules/nf-core/arriba/arriba/main'

//Start of the workflow
workflow ARRIBA_WORKFLOW {
    //Input of the workflow are given
    take:
        reads
        ch_gtf
        ch_fasta
        ch_bam
        ch_arriba_ref_blacklist
        ch_arriba_ref_known_fusions
        ch_arriba_ref_protein_domains

    //Main part of the workflow.
    main:
        ch_versions = Channel.empty()
   
        //Runs arriba if params.arriba is true.
        if (params.arriba) {
            ARRIBA ( ch_bam, ch_fasta, ch_gtf, ch_arriba_ref_blacklist, ch_arriba_ref_known_fusions, [[],[]], [[],[]], ch_arriba_ref_protein_domains )
            ch_versions = ch_versions.mix(ARRIBA.out.versions)

            ch_arriba_fusions     = ARRIBA.out.fusions
            ch_arriba_fusion_fail = ARRIBA.out.fusions_fail.map{ meta, file -> return file}
        }
        else {
            ch_arriba_fusions       = reads.combine(Channel.value( file(ch_dummy_file, checkIfExists:true ) ) )
                                        .map { meta, reads, fusions -> [ meta, fusions ] }

            ch_arriba_fusion_fail   = ch_dummy_file
        }

    //Emit the fusion detection results (both kept and discarded files)
    emit:
        fusions         = ch_arriba_fusions
        fusions_fail    = ch_arriba_fusion_fail
        versions        = ch_versions
    }

