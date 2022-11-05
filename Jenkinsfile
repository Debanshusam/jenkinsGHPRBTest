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
        description: 'enable to show environment values',trim: true)
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
                        branches: [[name: "${params.sourceBranch}"]], //sha1,ghprbActualCommit
                        extensions: [],
                        userRemoteConfigs: [[credentialsId: 'gh-user-passwd-formultibranchpipeline',url: "${params.repoURL}"]]
                ])
                script{
                    def commitChangeset = sh(returnStdout: true, script: 'git diff-tree --no-commit-id --name-status -r HEAD').trim()
                    //def whatchanged = sh(returnStdout: true, script: "git whatchanged ${env.sha1}").trim()git whatchanged 
                    echo '#--------- commitChangeset --------------------#'
                    echo "${commitChangeset}"
                    echo '#--------whatchanged-------------#'
                    //echo "${whatchanged}"
                    echo '#-----------------------------#'
                    echo '#--------currentBuild.changeSets-----#'
                    def changeLogSets = currentBuild.changeSets
                    for (int i = 0; i < changeLogSets.size(); i++) {
                    def entries = changeLogSets[i].items
                    for (int j = 0; j < entries.length; j++) {
                       def entry = entries[j]
                       echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
                       def files = new ArrayList(entry.affectedFiles)
                       for (int k = 0; k < files.size(); k++) {
                           def file = files[k]
                           echo " ${file.editType.name} ${file.path}"
                       }
                    }
                }
            }
            }
            }
        stage('Stage-1: Checking the target branch') {
            when {
                // To check current branch is in allowed list
                // To check the target branch is master
                allOf {
                    branch pattern: "${params.sourceBranchPattern}", comparator: "REGEXP";
                    changeRequest target: "${params.targetBranch}"; //to check the target branch is develop
                    changeRequest title: "${params.prNamingPattern}", comparator: "REGEXP" //to check the PR name is in allowed style
                }
            }
            steps {
                echo " Correct branch ${params.sourceBranch} with pattern: ${params.sourceBranchPattern}"
                echo "changeRequest target: ${params.targetBranch}"
                echo "Correct PR naming: ${params.prName}"
                echo "Stage-1: End of check for  ${params.targetBranch} status ${currentBuild.Result}"
            }
        }
    }
}
