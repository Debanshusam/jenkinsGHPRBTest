//----------------------
def downStreamJob1="Build Artifacts"
def downStreamJob2="2. Project provisioning"
//-----------------------
// job('US-Staging-Check')
def failureEmailsubject = "Pull Request Build Failed : ${ghprbPullTitle} "
def failureEmailbody = "Pull Request Build Failed : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def successEmailsubject = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink}"
def successEmailbody = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def emailReceipts = "debanshusamantaray@gmail.com"
pipeline {
    parameters {
        booleanParam(name: 'jobDebug', defaultValue: false, description: 'enable to show environ values')
    }
    agent {label 'built-in'}
    stages {
        stage ('Stage-DEBUG: Debugging Environment and Plugin variables'){
            when{
                expression { "${params.jobDebug}" == true }
            }
            steps{
                sh 'printenv'
                echo "#----------- Git hub Pull Request builder Plugin variables -------------#"
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
                echo "#----------------------------------------------------------------------#"
            }
        }
        stage ('Checkout SCM'){
            steps{
                checkout ([
                        $class: 'GitSCM',
                        branches: [[name: "${ghprbActualCommit}"]],
                        extensions: [],
                        userRemoteConfigs: [[credentialsId: 'github-debanshu-PAT',url: "${params.repoURL}"]]
                ])
            }
        }
    }
}