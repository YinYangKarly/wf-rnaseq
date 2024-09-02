include { ARRIBA_ARRIBA as ARRIBA }                     from '../../modules/nf-core/arriba/arriba/main'

workflow ARRIBA_WORKFLOW {
    take:
        reads
        ch_gtf
        ch_fasta
        ch_bam
        //ch_starindex_ref 
        ch_arriba_ref_blacklist
        ch_arriba_ref_known_fusions
        ch_arriba_ref_protein_domains

    main:
        ch_versions = Channel.empty()
   
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

    emit:
        fusions         = ch_arriba_fusions
        fusions_fail    = ch_arriba_fusion_fail
        versions        = ch_versions
    }

