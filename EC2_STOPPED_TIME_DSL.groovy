job('STOPPED_TIME_EC2') {
    scm {
        git {
            remote
            {
            url('https://github.com/DEVOPS-NINJAS/BASH_SCRIPT.git')
            }
            branch('master')
        }
    }
   
    steps {
         shell(readFileFromWorkspace('Ec2_Stop_time1.sh'))
        }
      
    
}
