//----------------------
def downStreamJob1='Build Artifacts'
def downStreamJob2='2. Project provisioning'
//-----------------------
// job('US-Staging-Check')
def failureEmailsubject = "Pull Request Build Failed : ${ghprbPullTitle} "
def failureEmailbody = "Pull Request Build Failed : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def successEmailsubject = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink}"
def successEmailbody = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def emailReceipts = 'debanshusamantaray@gmail.com'
pipeline {
    parameters {
        string(name: 'jobDebug',
        defaultValue: 'true', //'false'
        description: 'enable to show environment values')
        string(name: 'targetBranch',
        defaultValue: "${ghprbTargetBranch}",
        description: 'Please input the Target branch',trim: true)
        string(name: 'sourceBranch',
        defaultValue: "${ghprbSourceBranch}",
        description: 'Please input the Source branch',trim: true)
        string(name: 'targetBranchPattern',
        defaultValue: 'develop',
        description: 'Please input the Target branch regex pattern',trim: true)
        //to be updated
        string(name: 'sourceBranchPattern',
        defaultValue: 'feature/GCPID-[Xx\\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[\\d]{0,}',
        description: 'Please input the Source branch regex pattern',trim: true)
        //to be updated
        string(name: 'prName',
        defaultValue: "${ghprbPullTitle}",
        description: 'Please input the PR Name',trim: true)
        string(name: 'prNamingPattern',
        defaultValue: 'GCPID:[\\sXx\\d]*-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z]{0,}',
        description: 'Please input the PR Naming regex pattern',trim: true)
        //to be updated
        string(name: 'repoURL',
        defaultValue: 'https://github.com/Debanshusam/jenkinsGHPRBTest.git',
        description: 'Please input the Repo URL',trim: true)
    }
    agent { label 'built-in' } // 'master'
    stages {
        stage('Stage-DEBUG: Debugging Environment and Plugin variables'){
            when{
                expression { "${params.jobDebug}" == 'true' }
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
                        userRemoteConfigs: [[credentialsId: 'gh-user-passwd-formultibranchpipeline',url: "${params.repoURL}"]]
                ])
                script{
                    def commitChangeset = sh(returnStdout: true, script: 'git diff-tree --no-commit-id --name-status -r HEAD').trim()
                    echo "${commitChangeset}"
                }
                echo "#-----------------------------#"
                echo "${currentBuild.changeSets}"
            }
        }
    }
}