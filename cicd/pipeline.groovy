pipelineJob('microservice-0001') {
  definition {
        cps {
            script(readFileFromWorkspace('release-pipeline.groovy'))
            sandbox()
        }
      lightweight()
    }
  }
}
  
