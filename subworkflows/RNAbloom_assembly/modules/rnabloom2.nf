//Channel
  //.fromFilePairs(, flat: true) 
  //.set { reads }

process RNABLOOM2_ASSEMBLY {
  tag "$meta.id"

  container "https://depot.galaxyproject.org/singularity/rnabloom:2.0.1--hdfd78af_1" 
  
  input:
        tuple val(meta), path(reads)
        tuple val(meta2), path(transcriptFasta)

  output:
        tuple val(meta), path("${meta.id}_rnabloom2_assembly/rnabloom.transcripts.fa"), emit: fa
  
  script:
  def reads1 = [], reads2 = []
  meta.single_end ? [reads].flatten().each{reads1 << it} : reads.eachWithIndex{ v, ix -> ( ix & 1 ? reads2 : reads1) << v }
  def input_reads = meta.single_end ? "-r ${reads1.join(" ")}" : "-l ${reads1.join(" ")} -r ${reads2.join(" ")}"
  def args = task.ext.args ?: ''
  def prefix = task.ext.prefix ?: "${meta.id}"
  
  """
  rnabloom -ntcard ${args} -extend -chimera -o ${meta.id}_rnabloom2_assembly/ $input_reads -ref $transcriptFasta
  """
}