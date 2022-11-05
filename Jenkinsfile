pipeline {
    agent {label 'built-in'}
    stages {
        stage ('Debugging stage'){
            steps{
                sh 'printenv'
                echo "ghprbActualCommit :${ghprbActualCommit}"
                echo "ghprbActualCommitAuthor ${ghprbActualCommitAuthor}"
                echo "ghprbActualCommitAuthorEmail ${ghprbActualCommitAuthorEmail}"
                echo "ghprbPullDescription ${ghprbPullDescription}"
                echo "ghprbPullId ${ghprbPullId}"
                echo "ghprbPullLink ${ghprbPullLink}"
                echo "ghprbPullTitle ${ghprbPullTitle}"
                echo "ghprbSourceBranch ${ghprbSourceBranch}"
                echo "ghprbTargetBranch ${ghprbTargetBranch}"
                echo "ghprbCommentBody ${ghprbCommentBody}"
                echo "sha1 ${sha1}"
            }
        
    }
}