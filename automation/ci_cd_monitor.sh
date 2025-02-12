#!/bin/bash

# CI/CD Monitoring Script for AWS CodePipeline & CodeBuild
# Author: [Your Name]
# Project: AWS CI/CD Automation Showcase

# AWS CodePipeline & CodeBuild Variables
# Using environment variables to avoid hardcoding sensitive data
PIPELINE_NAME="${PIPELINE_NAME:-APPX-codepipeline-name}"
BUILD_PROJECT_NAME="${BUILD_PROJECT_NAME:-APPX-codebuild-project-name}"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-https://hooks.slack.com/services/APPX/SLACK/WEBHOOK}"  # Optional Slack Integration

# Log file for debugging and monitoring
LOG_FILE="/var/log/ci_cd_monitor.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🔍 Starting CI/CD Monitoring Script..." | tee -a "$LOG_FILE"

date | tee -a "$LOG_FILE"

# Function to check CodePipeline status
check_pipeline_status() {
    STATUS=$(aws codepipeline get-pipeline-state --name "$PIPELINE_NAME" --query 'stageStates[*].latestExecution.status' --output text)
    if [ $? -ne 0 ]; then
        echo "❌ AWS CLI command failed. Check AWS credentials and permissions." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "Pipeline Status: $STATUS" | tee -a "$LOG_FILE"

    if [[ "$STATUS" =~ "Failed" ]]; then
        echo "🚨 Pipeline Failed!" | tee -a "$LOG_FILE"
        notify_slack "AWS CodePipeline $PIPELINE_NAME has failed. 🚨"
        exit 1
    fi
}

# Function to check CodeBuild status
check_build_status() {
    BUILD_STATUS=$(aws codebuild batch-get-builds --ids "$(aws codebuild list-builds --query 'ids[0]' --output text)" --query 'builds[0].buildStatus' --output text)
    if [ $? -ne 0 ]; then
        echo "❌ AWS CLI command failed. Check AWS credentials and permissions." | tee -a "$LOG_FILE"
        exit 1
    fi
    echo "CodeBuild Status: $BUILD_STATUS" | tee -a "$LOG_FILE"

    if [[ "$BUILD_STATUS" == "FAILED" ]]; then
        echo "🚨 CodeBuild Failed!" | tee -a "$LOG_FILE"
        notify_slack "AWS CodeBuild $BUILD_PROJECT_NAME has failed. 🚨"
        exit 1
    fi
}

# Function to send Slack notification (Optional)
notify_slack() {
    MESSAGE="$1"
    if [[ -n "$SLACK_WEBHOOK_URL" ]]; then
        curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK_URL"
    fi
}

# CI/CD Monitoring Execution
check_pipeline_status
check_build_status

echo "✅ CI/CD Pipeline & Build are successful!" | tee -a "$LOG_FILE"
notify_slack "AWS CI/CD Pipeline & Build completed successfully. ✅"

date | tee -a "$LOG_FILE"

exit 0

