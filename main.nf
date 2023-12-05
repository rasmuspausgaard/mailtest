#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

sendMail(
    to: 'Rasmus.Hojrup.Pausgaard@rsyd.dk',
    from 'Rasmus.Hojrup.Pausgaard@rsyd.dk',
    subject: 'Catch up',
    body: 'Hi, how are you!',
    
)
