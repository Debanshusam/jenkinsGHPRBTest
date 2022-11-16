//----------------------
def downStreamJob1='Build Artifacts'
def downStreamJob2='2. Project provisioning'
def triggerDownstreamFlag='NO DATA SET' //"build-only" /"build-&-provision" / "skip-no-validChanges"
//-----------------------
// job('US-Staging-Check')
def failureEmailsubject = "Pull Request Build Failed : ${ghprbPullTitle} "
def failureEmailbody = "Pull Request Build Failed : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def successEmailsubject = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink}"
def successEmailbody = "Pull Request Build Succeeded : ${ghprbPullTitle} . Link: ${ghprbPullLink} "
def emailReceipts = 'debanshusamantaray@gmail.com'
def jobProgressFlag = "true"
pipeline {
    parameters {
        string(name: 'jobDebug',
        defaultValue: 'false', //'false'
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
        defaultValue: '[Ff]eature/[Gg][Cc][Pp][Ii][Dd]-[Xx\\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[\\d]{0,}',
        description: 'Please input the Source branch regex pattern',trim: true)
        //to be updated
        string(name: 'prName',
        defaultValue: "${ghprbPullTitle}",
        description: 'Please input the PR Name',trim: true)
        string(name: 'prNamingPattern',
        defaultValue: '[Gg][Cc][Pp][Ii][Dd]:[\\sXx\\d]{0,}-[a-zA-Z]{0,}[-]{0,1}[a-zA-Z\\d]{0,}',
        description: 'Please input the PR Naming regex pattern',trim: true)
        //to be updated
        string(name: 'repoURL',
        defaultValue: 'https://github.com/Debanshusam/jenkinsGHPRBTest.git',
        description: 'Please input the Repo URL',trim: true)
        string(name: 'gitForkPoint',
        defaultValue: 'origin/develop',
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
                    writeFile(file: 'targetBranchCheckFlag.sh',text: """if [[ "${env.ghprbTargetBranch}" == 'develop' ]]; then echo "matched";else echo "false";fi""")
                    sh 'chmod +x targetBranchCheckFlag.sh'
                    def  targetBranchCheckFlag = sh (returnStdout: true, script:'bash targetBranchCheckFlag.sh').trim()
                    echo "targetBranchCheckFlag ==> ${targetBranchCheckFlag} ==> ${env.ghprbTargetBranch}"
                    //------------------------------------
                    writeFile(file: 'sourceBranchPatternCheckFlag.sh',text: """if [[ "${env.ghprbSourceBranch}" =~ "${sourceBranchPattern}" ]]; then echo "matched";else echo "false";fi""")
                    sh 'chmod +x sourceBranchPatternCheckFlag.sh'
                    def  sourceBranchPatternCheckFlag = sh (returnStdout: true, script:'bash sourceBranchPatternCheckFlag.sh').trim()
                    echo "sourceBranchPatternCheckFlag ==> ${sourceBranchPatternCheckFlag} ==> ${env.ghprbSourceBranch}"
                    //------------------------------------

                    writeFile(file: 'prNamingPatternCheckFlag.sh',text: """if [[ "${env.ghprbPullTitle}" =~ "${prNamingPattern}" ]]; then echo "matched";else echo "false";fi""")
                    sh 'chmod +x prNamingPatternCheckFlag.sh'
                    def  prNamingPatternCheckFlag = sh (returnStdout: true, script:'bash prNamingPatternCheckFlag.sh').trim()
                    echo "prNamingPatternCheckFlag ==> ${prNamingPatternCheckFlag} ==> ${env.ghprbPullTitle}"
                    //------------------------------------
                    //error("Aborting the build.") //Commented Temporarily
                    jobProgressFlag  = (("${targetBranchCheckFlag}" == 'matched' && "${sourceBranchPatternCheckFlag}" == 'matched' && "${prNamingPatternCheckFlag}" == 'matched') ? 'true' : 'false') //Commented Temporarily
                    echo "jobProgressFlag ==> ${jobProgressFlag}"
                    currentBuild.result = (("${targetBranchCheckFlag}" == 'matched' && "${sourceBranchPatternCheckFlag}" == 'matched' && "${prNamingPatternCheckFlag}" == 'matched') ? 'SUCCESS' : 'FAILURE') 
                }
            }
        }
        stage ('Stage-2: Checkout SCM'){
            when { expression {"${jobProgressFlag}" == 'true'}}
            steps{
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: "${params.sourceBranch}"]],
                    extensions: [],
                    userRemoteConfigs: [[credentialsId: 'gh-user-passwd-formultibranchpipeline', refspec: "+refs/heads/main:refs/remotes/origin/main +refs/heads/develop:refs/remotes/origin/develop +refs/heads/${params.sourceBranch}:refs/remotes/origin/${params.sourceBranch}", url: "${params.repoURL}"]]
                ])
                echo " Branches available locally..."
                sh "git branch "
                //echo "Checking out to ${params.sourceBranch}..."
                //sh "git checkout origin/${params.sourceBranch}"
                //echo "Branch status..."
                //sh "git branch "
            }
        }
        stage('Stage-3: Generating and analysing changes on branch...'){
            when { expression {"${jobProgressFlag}" == 'true'}}
            steps{
                script{
                    echo " Generating the git diff log to find the list of file modified...."
                    def commitChangeset = sh(returnStdout: true, script: 'git diff-tree --no-commit-id --name-status -r HEAD').trim()
                    def commitGitDiff = sh(returnStdout: true, script: """git diff --name-only \$(git merge-base --fork-point "${gitForkPoint}")""").trim() // this generates the list of modfied files on the branch since it was branched from main/master/origin branch
                    echo '#--------- commitChangeset --------------------#'
                    echo "${commitChangeset}"
                    echo '#--------commitGitDiff-----#'
                    echo "${commitGitDiff}"
                    //redirect the commitGitDiff into a log file
                    writeFile (file: "${WORKSPACE}/commitGitDiff.log", text: "${commitGitDiff}")
                    fileExists 'commitGitDiff.log'
                    echo 'commitGitDiff.log file generated,checking number of modified files ..... '
                    sh """cat "${WORKSPACE}/commitGitDiff.log"| wc -l"""
                    //check if the field contains any changes to specific file extensions using awk command and set a variable flag to  "build-only" /"build-&-provision"
                    triggerDownstreamFlag=sh(returnStdout: true, script:'''
                    awk 'BEGIN{FLAG="";b1regex1="[a-zA-Z0-9]*[.](py)";b1regex2="[a-zA-Z0-9]*[.](Dockerfile)";b1regex3="[a-zA-Z0-9]*[.](R)";b1regex4="[a-zA-Z0-9]*[.](Rprofile)";b1regex5="[jJ]enkinsfile*"; \
                    b2regex6="[a-zA-Z0-9]*[.](sql)";b2regex7="[a-zA-Z0-9]*[.](tf)";b2regex8="[a-zA-Z0-9]*[.](go)";b2regex9="[a-zA-Z0-9]*[.](sh)";b2regex10="[a-zA-Z0-9]*[.](y[a]{0,1}ml)";}{ \
                    if ($0 ~ b1regex1 || $0 ~ b1regex2 || $0 ~ b1regex3 || $0 ~ b1regex4 || $0 ~ b1regex5)\
                    FLAG="build-only" ;\
                    if ($0 ~ b2regex6 || $0 ~ b2regex7 || $0 ~ b2regex8 || $0 ~ b2regex9 || $0 ~ b2regex10)\
                    FLAG="build-&-provision" ;\
                    if (FLAG == "")\
                    FLAG="skip-no-validChanges" ;\
                    }
                    END{print FLAG}' commitGitDiff.log;''').trim()
                }
                echo " ###>>>> triggerDownstreamFlag ==> ${triggerDownstreamFlag}"
            }
        }
        stage('Stage-4: Checking status to trigger downstream Job ....'){
            when { expression {"${jobProgressFlag}" == 'true'}}
            steps{
                script{
                    if ("${triggerDownstreamFlag}" == "build-&-provision"){
                        //trigger downstream job-1 ==> build
                        def downStreamJob1ReturnValue = build job: "${downStreamJob1}", parameters: [
                        string(name: 'fortifyScanRequired', value: 'true'), // pending update
                        string(name: 'twistlockScanRequired', value: 'true'), // pending update
                        string(name: 'ignoreVulnerableImages', value: 'true'), // pending update
                        booleanParam(name: 'Trigger-Provision-Job', value: true)],
                        propagate : true,
                        quietPeriod : 5,
                        wait : true

                        //trigger downstream job-2 ==> provision only when Build is success
                        /*
                        def downStreamJob2ReturnValue = build job: "${downStreamJob2}", parameters: [
                            string(name: 'version',
                            defaultValue: "${Build_Version}",
                            description: 'REQUIRED Version of release to deploy. Single version for all artifacts (images, helm chart, dataproc init actions).',
                            trim: true)
                            ],
                            propagate : true,
                            quietPeriod : 5,
                            wait : true*/
                    }
                }
                script{    
                    if ("${triggerDownstreamFlag}" == "build-only"){
                        //trigger downstream job-1 only ==> build 
                        def downStreamJob1ReturnValue = build job: "${downStreamJob1}", parameters: [
                        string(name: 'fortifyScanRequired', value: 'true'), // pending update
                        string(name: 'twistlockScanRequired', value: 'true'), // pending update
                        string(name: 'ignoreVulnerableImages', value: 'true'), // pending update
                        booleanParam(name: 'Trigger-Provision-Job', value: false)],
                        propagate : true,
                        quietPeriod : 5,
                        wait : true
                    }
                }
                script{
                    if ( "${triggerDownstreamFlag}" == "skip-no-validChanges" ){
                        echo '#--------- No valid changelog found !! ,Downstream build-&-provision jobs skipped ---------#'
                    } 
                }
            }
        }
    }
}

