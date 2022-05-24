pipelineJob('microservice-0001') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/fulli-automatix/microservice-0001.git')
          }
          branch('*/main')
        }
      }
      lightweight()
    }
  }
}
  
