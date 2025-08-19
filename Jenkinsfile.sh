pipeline {
    agent any
    
    environment {
        REPORT_DIR = "${WORKSPACE}/Health_Reports"
        TIMESTAMP = sh(script: "date +'%Y-%m-%d_%H-%M-%S'", returnStdout: true).trim()
        REPORT_FILE = "${REPORT_DIR}/report_${TIMESTAMP}.txt"
        BUCKET_NAME = "jenkins-server-health-reports"
        REGION = "ap-south-1"
    }

    stages {
        stage('Prepare') {
            steps {
                sh 'mkdir -p "$REPORT_DIR"'
            }
        }

        stage('CreateBucket') {
            steps {
                sh '''
                if ! aws s3 ls "s3://$BUCKET_NAME" 2>/dev/null; then
                    aws s3 mb "s3://$BUCKET_NAME" --region $REGION
                    echo "Bucket $BUCKET_NAME created."
                else
                    echo "Bucket $BUCKET_NAME already exists."
                fi
                '''
            }
        }

        stage('Generate') {
            steps {
                sh '''
                    echo "Date: $(date)" > "$REPORT_FILE"
                    echo "Hostname: $(hostname)" >> "$REPORT_FILE"
                    echo "Uptime:" >> "$REPORT_FILE"
                    uptime >> "$REPORT_FILE"
                    echo "Memory (MB):" >> "$REPORT_FILE"
                    free -m >> "$REPORT_FILE"
                '''
            }
        }

        stage('Upload') {
            steps {
                sh 'aws s3 cp "$REPORT_FILE" s3://$BUCKET_NAME/'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'rm -f "$REPORT_FILE"'
            }
        }
    }
}
