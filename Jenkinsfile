pipeline {
    parameters {
        booleanParam(name: 'jobDebug', defaultValue: false, description: 'enable to show environ values')
    }
    agent {label 'built-in'}
    stages {
        stage ('Debugging stage'){
            when{
                expression { "${params.jobDebug}" == true }
            }
            steps{
                sh 'printenv'
                echo "#------------------------------------------#"
                echo "ghprbActualCommit :${env.ghprbActualCommit}"
                echo "ghprbActualCommitAuthor ${env.ghprbActualCommitAuthor}"
                echo "ghprbActualCommitAuthorEmail ${env.ghprbActualCommitAuthorEmail}"
                echo "ghprbPullDescription ${env.ghprbPullDescription}"
                echo "ghprbPullId ${env.ghprbPullId}"
                echo "ghprbPullLink ${env.ghprbPullLink}"
                echo "ghprbPullTitle ${env.ghprbPullTitle}"
                echo "ghprbSourceBranch ${env.ghprbSourceBranch}"
                echo "ghprbTargetBranch ${env.ghprbTargetBranch}"
                echo "ghprbCommentBody ${env.ghprbCommentBody}"
                echo "sha1 ${env.sha1}"
                echo "#------------------------------------------#"
            }
        }
    }
}