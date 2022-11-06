//----------------------
def downStreamJob1='Build Artifacts'
def downStreamJob2='2. Project provisioning'
def triggerDownstreamFlag='none' //"build-only" /"build-&-provision" / "skip"
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
        string(name: 'gitForkPoint',
        defaultValue: 'main',
        description: 'this generates the list of modfied files on the branch since it was branched from fork point',
        trim: true)
    }
    agent { label 'built-in' } // 'master'
    stages {
        stage('Stage-DEBUGGING: Debugging Environment and Plugin variables'){
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
        stage('Stage-1: Checking the branch and PR naming convention..') {
            steps {
                script{
                 def  targetBranchCheckFlag = sh (returnStdout: true, script:"""if [[ "${env.ghprbTargetBranch}" == "develop" ]]; then echo "matched";else echo "false";fi""").trim()
                 echo "targetBranchCheckFlag ==> ${targetBranchCheckFlag} ==> ${env.ghprbTargetBranch}"

                 def  sourceBranchPatternCheckFlag = sh (returnStdout: true, script:"""if [[ "${env.ghprbSourceBranch}" =~ "${sourceBranchPattern}" ]]; then echo "matched";else echo "false";fi""").trim()
                 echo "sourceBranchPatternCheckFlag ==> ${sourceBranchPatternCheckFlag} ==> ${env.ghprbSourceBranch}"

                def  prNamingPatternCheckFlag = sh (returnStdout: true, script:"""if [[ "${env.ghprbPullTitle}" == "${prNamingPattern}" ]]; then echo "matched";else echo "false";fi""").trim()
                echo "prNamingPatternCheckFlag ==> ${prNamingPatternCheckFlag} ==> ${env.ghprbPullTitle}"

                //error("Aborting the build.") //Commented Temporarily
                //currentBuild.result  = (("${targetBranchCheckFlag}" == 'matched' && "${sourceBranchPatternCheckFlag}" == 'matched' && "${prNamingPatternCheckFlag}" == 'matched') ? 'SUCCESS' : 'FAILURE') //Commented Temporarily
                
                }
            }
        }
        stage ('Stage-2: Checkout SCM'){
            steps{
                checkout ([
                        $class: 'GitSCM',
                        branches: [[name: "${params.sourceBranch}"]], //sha1,ghprbActualCommit
                        extensions: [],
                        userRemoteConfigs: [[credentialsId: 'gh-user-passwd-formultibranchpipeline',url: "${params.repoURL}"]]
                ])
            }
        }
        stage('Stage-3: Generating and analysing changes on branch...'){
            steps{
                script{
                    echo " Generating the git diff log to find the list of file modified...."
                    def commitChangeset = sh(returnStdout: true, script: 'git diff-tree --no-commit-id --name-status -r HEAD').trim()
                    def commitGitDiff = sh(returnStdout: true, script: "git diff --name-only $(git merge-base --fork-point "${gitForkPoint}")").trim() // this generates the list of modfied files on the branch since it was branched from main/master/origin branch
                    echo '#--------- commitChangeset --------------------#'
                    echo "${commitChangeset}"
                    echo '#--------commitGitDiff-----#'
                    echo "${commitGitDiff}"
                    //redirect the commitGitDiff into a log file
                    sh "echo "${commitGitDiff}" > commitGitDiff.log"
                    echo 'commitGitDiff.log file generated ..... '
                    //check if the field contains any changes to specific file extensions using awk command and set a variable flag to  "build-only" /"build-&-provision"
                    triggerDownstreamFlag=sh(returnStdout: true, script:'''
                    awk 'BEGIN{FLAG="";b1regex1="[a-zA-Z0-9]*[.](py)";b1regex2="[a-zA-Z0-9]*[.](Dockerfile)";b1regex3="[a-zA-Z0-9]*[.](R)";b1regex4="[a-zA-Z0-9]*[.](Rprofile)";b1regex5="[jJ]enkinsfile*"; \
                    b2regex6="[a-zA-Z0-9]*[.](sql)";b2regex7="[a-zA-Z0-9]*[.](tf)";b2regex8="[a-zA-Z0-9]*[.](go)";b2regex9="[a-zA-Z0-9]*[.](sh)";b2regex10="[a-zA-Z0-9]*[.](y[a]{0,1}ml)";}{ \
                    if ($0 ~ b1regex1 || $0 ~ b1regex2 || $0 ~ b1regex3 || $0 ~ b1regex4 || $0 ~ b1regex5)\
                    print $0 ,FLAG="build-only" ;\
                    if ($0 ~ b2regex6 || $0 ~ b2regex7 || $0 ~ b2regex8 || $0 ~ b2regex9 || $0 ~ b2regex10)\
                       print $0 , FLAG="build-&-provision" ;\
                    }
                    END{print FLAG}' commitGitDiff.log;''').trim()
                }
                echo " triggerDownstreamFlag ==> ${triggerDownstreamFlag}"
            }
        }
    }
}
