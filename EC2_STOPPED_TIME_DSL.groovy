job('STOPPED_TIME_EC2') {
    parameters {
        stringParam('No_of_Days', '0', 'Enter no of days')
    }
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
