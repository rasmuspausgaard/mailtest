#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.panel = 'DefaultPanel'
params.cram = 'default'
params.samplesheet = 'DefaultSample123456'
params.keepwork = null

process Mail {
    echo true

    script:
    """
    echo "hello world"
    """
}

workflow {
    Mail()
}

workflow.onComplete {
    // Custom message to be sent when the workflow completes
    def cramFolder = params.cram ? new File(params.cram).getName() : 'Not provided'
    def fastqFolder = params.fastq ? new File(params.fastq).getName() : 'Not provided'
    
    def body = """\
    Pipeline execution summary
    ---------------------------
    Pipeline completed  : ${params.panel}
    Cram folder         : ${cramFolder}
    Fastq folder        : ${fastqFolder}
    Completed at        : ${workflow.complete}
    Duration            : ${workflow.duration}
    Success             : ${workflow.success}
    WorkDir             : ${workflow.workDir}
    OutputDir           : ${params.outdir ?: 'Not specified'}
    Exit status         : ${workflow.exitStatus}
    """.stripIndent()

    // Send the email using the built-in sendMail function
    sendMail(to: 'Rasmus.Hojrup.Pausgaard@rsyd.dk', subject: 'Pipeline Update', body: body)

    // Check if --keepwork was specified
    if (!params.keepwork) {
        // If --keepwork was not specified, delete the work directory
        println("Deleting work directory: ${workflow.workDir}")
        "rm -rf ${workflow.workDir}".execute()
    }
}

workflow.onError {
    // Custom message to be sent when the workflow completes
    def cramFolder = params.cram ? new File(params.cram).getName() : 'Not provided'
    def fastqFolder = params.fastq ? new File(params.fastq).getName() : 'Not provided'

    def body = """\
    Pipeline execution summary
    ---------------------------
    Pipeline completed  : ${params.panel}
    Cram folder         : ${cramFolder}
    Fastq folder        : ${fastqFolder}
    Duration            : ${workflow.duration}
    Failed              : ${workflow.failed}
    WorkDir             : ${workflow.workDir}
    Exit status         : ${workflow.exitStatus}
    """.stripIndent()

    // Send the email using the built-in sendMail function
    sendMail(to: 'Rasmus.Hojrup.Pausgaard@rsyd.dk', subject: 'Pipeline Update', body: body)

}
