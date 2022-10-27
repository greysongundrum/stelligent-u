# Topic 8: CloudWatch

<!-- TOC -->

- [Topic 8: CloudWatch](#topic-8-cloudwatch)
  - [Conventions](#conventions)
  - [Lesson 8.1: CloudWatch Logs storage and retrieval](#lesson-81-cloudwatch-logs-storage-and-retrieval)
    - [Principle 8.1](#principle-81)
    - [Practice 8.1](#practice-81)
      - [Lab 8.1.1: Log groups and streams](#lab-811-log-groups-and-streams)
      - [Lab 8.1.2: The CloudWatch agent](#lab-812-the-cloudwatch-agent)
      - [Lab 8.1.3: 3rd party tool awslogs](#lab-813-3rd-party-tool-awslogs)
      - [Lab 8.1.4: CloudWatch logs lifecycle](#lab-814-cloudwatch-logs-lifecycle)
      - [Lab 8.1.5: Clean up](#lab-815-clean-up)
    - [Retrospective 8.1](#retrospective-81)
  - [Lesson 8.2: CloudWatch Logs with CloudTrail events](#lesson-82-cloudwatch-logs-with-cloudtrail-events)
    - [Principle 8.2](#principle-82)
    - [Practice 8.2](#practice-82)
      - [Lab 8.2.1: CloudWatch and CloudTrail resources](#lab-821-cloudwatch-and-cloudtrail-resources)
      - [Lab 8.2.2: Logging AWS infrastructure changes](#lab-822-logging-aws-infrastructure-changes)
      - [Lab 8.2.3: Clean up](#lab-823-clean-up)
    - [Retrospective 8.2](#retrospective-82)
      - [Question](#question)
      - [Task](#task)

<!-- /TOC -->

## Conventions

- DO review CloudFormation documentation to see if a property is
  required when creating a resource.

## Lesson 8.1: CloudWatch Logs storage and retrieval

### Principle 8.1

CloudWatch Logs are the best way to securely and reliably store text
logs from application services and AWS resources (EC2, Lambda,
CodePipeline, etc) over time.

### Practice 8.1

This section shows you how to configure CloudWatch to monitor and store
logs for AWS resources, as well as how to retrieve and review those logs
using the AWS CLI and a utility called "awslogs".

#### Lab 8.1.1: Log groups and streams

A log group is an arbitrary collection of similar logs, using whatever
definition of "similar" you want. A log stream is a uniquely
identifiable flow of data into that group. Use the AWS CLI to create a
log group and log stream:

- Name the log group based on your username: *first.last*.c9logs

- Name the log stream named c9.training in your log group.

When you're done, list the log groups and the log streams to confirm
they exist.

#### Lab 8.1.2: The CloudWatch agent

The CloudWatch agent is the standard tool for sending log data to
CloudWatch Logs. We've provided a stack template for you in your *clone*
of the
[stelligent-u](https://github.com/stelligent/stelligent-u)
repo:

- [Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-first-instance.html)
  for installing the Cloud Watch agent, for reference.
  The example template installs the agent.

- We need to generate a Cloud Watch configuration file to be included
  in your Cloud Formation Template. The simplest way to approach this
  is to start an EC2 instance with the Cloud Watch agent installed and
  use the wizard it provides. For the example Cloud Formation template
  the wizard is in
  `/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard`
  You will need to add references to the log streams defined in 8.1.1
  [Documentation on generating the template file](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html)
  for reference.

- The wizard will prompt you to use `collectd`, but we do not recommend this
  as it can cause the agent to fail to start

- Modify the template mappings to reference your
  own VPC ID's and Subnet ID generated in other lessons,
  or provide appropriate code in the resources section.

- Once you have added the Cloud Watch configuration to your Cloud Formation template,
  delete the running stack, and relaunch.

- Use the AWS CLI to display the log events for your group and stream from 8.1.1.

> *Note:* logs may take several minutes to appear.

aws logs get-log-events --log-group-name greysongundrumlabsc9logs --log-stream-name c9training

#### Lab 8.1.3: 3rd party tool awslogs

[awslogs](https://github.com/jorgebastida/awslogs) is a
publicly-available Python tool that you can use to read CloudWatch logs.
It's especially convenient for tailing the log streams, showing you data
as it arrives.

- Install the awslogs client on your running EC2 instance.

- Use it to watch logs as they are put into your log group.

- Use awslogs to get logs from your group from the last 5 minutes,
  last 20 minutes and last hour.

#### Lab 8.1.4: CloudWatch logs lifecycle

Any time you're logging information, it's important to consider the
lifecycle of the logs.

- Use the AWS CLI to [set the retention policy](https://docs.aws.amazon.com/cli/latest/reference/logs/put-retention-policy.htm)
  of your log group to 60 days.

- Use the CLI to review the policy in your log group.

- Set the retention policy to the maximum allowed time, and review the
  change again to double-check.


greyson.gundrum@MACUSSTG2541764 08-cloudwatch-logs % aws logs put-retention-policy --log-group-name greysongundrumlabsc9logs --retention-in-days 60      
greyson.gundrum@MACUSSTG2541764 08-cloudwatch-logs % aws logs get-retention-policy --log-group-name greysongundrumlabsc9logs                    

greyson.gundrum@MACUSSTG2541764 08-cloudwatch-logs % aws logs describe-log-groups --log-group-name greysongundrumlabsc9logs 
{
    "logGroups": [
        {
            "logGroupName": "greysongundrumlabsc9logs",
            "creationTime": 1666757569875,
            "retentionInDays": 60,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:us-west-2:324320755747:log-group:greysongundrumlabsc9logs:*",
            "storedBytes": 0
        }
    ]
}
greyson.gundrum@MACUSSTG2541764 08-cloudwatch-logs % aws logs describe-log-groups --log-group-name greysongundrumlabsc9logs 
{
    "logGroups": [
        {
            "logGroupName": "greysongundrumlabsc9logs",
            "creationTime": 1666757569875,
            "retentionInDays": 3653,
            "metricFilterCount": 0,
            "arn": "arn:aws:logs:us-west-2:324320755747:log-group:greysongundrumlabsc9logs:*",
            "storedBytes": 0
        }
    ]
}

#### Lab 8.1.5: Clean up

You can tear down your EC2 stack at this point.

Use the AWS CLI to remove the log group and log stream you created
earlier.

You'll need [jorgebastida/awslogs](https://github.com/jorgebastida/awslogs)
in Lesson 8.2.1, so now's a good time to install it on your laptop. You may
find that it's handy for client engagements and future lab work as well.

### Retrospective 8.1

*Log retention is an important issue that can affect many parts of a
company's business. It's helpful to know what CloudWatch Log's service
limitations are.*

- What are the minimum and maximum retention times?

1 Day or 10 years (Or Never Expire)

- Instead of keeping data in CW Logs forever, can you do anything else
  with them? What might a useful lifecycle for logs look like?

  You could move them to glacier after an immiedate name from them had ceased to existed. It's likely that after a time these logs are bundled and shipped to S3.

## Lesson 8.2: CloudWatch Logs with CloudTrail events

### Principle 8.2

*CloudWatch Logs let you monitor AWS API changes via CloudTrail logged
events.*

### Practice 8.2

This section demonstrates CloudWatch's ability to send alerts based on
changes to AWS resources made via the API changes, identified through
CloudTrail events. This is useful for many reasons. For example, you may
want to understand what changes are being made to AWS resources and
decide if they are appropriate. Notifications or automated corrective
action can be configured when inappropriate changes are being made.

#### Lab 8.2.1: CloudWatch and CloudTrail resources

Let's switch from the awscli to CloudFormation. Create a template that
provides the following in a single stack:

- A new CloudWatch Logs log group

- An S3 bucket for CloudTrail to publish logs.

- A CloudTrail trail that uses the CloudWatch log group.

#### Lab 8.2.2: Logging AWS infrastructure changes

Now that you have your logging infrastructure, create a separate stack
for the resources that will use it:

- Create an S3 bucket or any other AWS resource of your choice.

- Add tags that mark it with your AWS username, and identify it as a
  stelligent-u resource with this topic and lab number.

- Use awslogs client utility to review the logs from the new group.
  You should see the activity from creating and changing the
  resource.

GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAARQJIIRZVU2","arn":"arn:aws:iam::324320755747:user/janjanam.surekha.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAARVXLCMSEP","userName":"janjanam.surekha.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T02:49:21Z","mfaAuthenticated":"true"}}},"eventTime":"2022-10-27T05:28:38Z","eventSource":"cloudformation.amazonaws.com","eventName":"DescribeStacks","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"stackName":"arn:aws:cloudformation:us-west-2:324320755747:stack/lab3/561905d0-55b7-11ed-a6bb-06bdfa0c5ba3"},"responseElements":null,"requestID":"856c3099-0654-42d9-8e50-1670a3af6372","eventID":"c0437ee8-0caa-4652-aa59-31235d45d168","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management","sessionCredentialFromConsole":"true"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR3KFKMP4IB","arn":"arn:aws:iam::324320755747:user/greyson.gundrum.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR5RTOHPFD","userName":"greyson.gundrum.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T04:06:57Z","mfaAuthenticated":"true"}}},"eventTime":"2022-10-27T05:28:28Z","eventSource":"cloudformation.amazonaws.com","eventName":"DescribeStacks","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"stackName":"arn:aws:cloudformation:us-west-2:324320755747:stack/greysongundrum822/a56b9260-55b7-11ed-b05e-06ea48473c9b"},"responseElements":null,"requestID":"919402cc-70da-4316-9e8f-19a3ab22ccda","eventID":"bc3baad9-7850-4827-8028-234483536d36","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management","sessionCredentialFromConsole":"true"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AssumedRole","principalId":"AROAUXAYGAARVDGTKAPCQ:AmazonMWAA-airflow","arn":"arn:aws:sts::324320755747:assumed-role/AmazonMWAA-airflow-jmcgrady-instance-faLvOa/AmazonMWAA-airflow","accountId":"324320755747","accessKeyId":"ASIAUXAYGAARY2LWCCCN","sessionContext":{"sessionIssuer":{"type":"Role","principalId":"AROAUXAYGAARVDGTKAPCQ","arn":"arn:aws:iam::324320755747:role/service-role/AmazonMWAA-airflow-jmcgrady-instance-faLvOa","accountId":"324320755747","userName":"AmazonMWAA-airflow-jmcgrady-instance-faLvOa"},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T05:21:24Z","mfaAuthenticated":"false"}},"invokedBy":"AWS Internal"},"eventTime":"2022-10-27T05:28:56Z","eventSource":"s3.amazonaws.com","eventName":"GetBucketPublicAccessBlock","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"publicAccessBlock":"","bucketName":"airflow-jmcgrady-bucket","Host":"airflow-jmcgrady-bucket.s3.us-west-2.amazonaws.com"},"responseElements":null,"additionalEventData":{"SignatureVersion":"SigV4","CipherSuite":"ECDHE-RSA-AES128-GCM-SHA256","bytesTransferredIn":0,"AuthenticationMethod":"AuthHeader","x-amz-id-2":"siCVMxLQC2hEGma3k8AjRF/sK57Y8Q2MR7VcK8s9Ke5ia7xYtiHSWXiLX94k7JR4EuIB7+ITV7U=","bytesTransferredOut":326},"requestID":"HXDNS8W0GNFB21RN","eventID":"c0d84f69-4136-4b8a-9e3a-1aa18885c00d","readOnly":true,"resources":[{"accountId":"324320755747","type":"AWS::S3::Bucket","ARN":"arn:aws:s3:::airflow-jmcgrady-bucket"}],"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","vpcEndpointId":"vpce-0fc2df27fd109d43a","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AssumedRole","principalId":"AROAUXAYGAARVDGTKAPCQ:AmazonMWAA-airflow","arn":"arn:aws:sts::324320755747:assumed-role/AmazonMWAA-airflow-jmcgrady-instance-faLvOa/AmazonMWAA-airflow","accountId":"324320755747","accessKeyId":"ASIAUXAYGAARSGNXWXUN","sessionContext":{"sessionIssuer":{"type":"Role","principalId":"AROAUXAYGAARVDGTKAPCQ","arn":"arn:aws:iam::324320755747:role/service-role/AmazonMWAA-airflow-jmcgrady-instance-faLvOa","accountId":"324320755747","userName":"AmazonMWAA-airflow-jmcgrady-instance-faLvOa"},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T05:14:06Z","mfaAuthenticated":"false"}},"invokedBy":"AWS Internal"},"eventTime":"2022-10-27T05:28:58Z","eventSource":"s3.amazonaws.com","eventName":"GetBucketPublicAccessBlock","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"publicAccessBlock":"","bucketName":"airflow-jmcgrady-bucket","Host":"airflow-jmcgrady-bucket.s3.us-west-2.amazonaws.com"},"responseElements":null,"additionalEventData":{"SignatureVersion":"SigV4","CipherSuite":"ECDHE-RSA-AES128-GCM-SHA256","bytesTransferredIn":0,"AuthenticationMethod":"AuthHeader","x-amz-id-2":"cp55NSfxqLuatyGQ5HB95L9j08iM8KcoGWG1un9uos3GIqb+XwRs5bonTGrWPVSxb45NCocT1Nk=","bytesTransferredOut":326},"requestID":"4W648XZG48FPEBRZ","eventID":"115610c4-3bfd-4faf-8ba3-e6d2c5c53127","readOnly":true,"resources":[{"accountId":"324320755747","type":"AWS::S3::Bucket","ARN":"arn:aws:s3:::airflow-jmcgrady-bucket"}],"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","vpcEndpointId":"vpce-0fc2df27fd109d43a","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAARQJIIRZVU2","arn":"arn:aws:iam::324320755747:user/janjanam.surekha.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAARVXLCMSEP","userName":"janjanam.surekha.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T02:49:21Z","mfaAuthenticated":"true"}}},"eventTime":"2022-10-27T05:28:39Z","eventSource":"cloudformation.amazonaws.com","eventName":"ListStacks","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"stackStatusFilter":["CREATE_IN_PROGRESS","UPDATE_COMPLETE","DELETE_FAILED","REVIEW_IN_PROGRESS","ROLLBACK_IN_PROGRESS","UPDATE_ROLLBACK_IN_PROGRESS","CREATE_COMPLETE","UPDATE_ROLLBACK_COMPLETE","UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS","ROLLBACK_COMPLETE","ROLLBACK_FAILED","CREATE_FAILED","UPDATE_ROLLBACK_FAILED","UPDATE_COMPLETE_CLEANUP_IN_PROGRESS","UPDATE_IN_PROGRESS","UPDATE_FAILED","DELETE_IN_PROGRESS","IMPORT_COMPLETE","IMPORT_IN_PROGRESS","IMPORT_ROLLBACK_IN_PROGRESS","IMPORT_ROLLBACK_FAILED","IMPORT_ROLLBACK_COMPLETE"]},"responseElements":null,"requestID":"352b5b05-292c-44ff-884d-dc8521e96aa8","eventID":"23ceefc4-eacf-4cd1-8a5c-4eb61772748a","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management","sessionCredentialFromConsole":"true"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AWSService","invokedBy":"backup.amazonaws.com"},"eventTime":"2022-10-27T05:29:06Z","eventSource":"sts.amazonaws.com","eventName":"AssumeRole","awsRegion":"us-west-2","sourceIPAddress":"backup.amazonaws.com","userAgent":"backup.amazonaws.com","requestParameters":{"roleArn":"arn:aws:iam::324320755747:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup","roleSessionName":"AWSBackup-AWSServiceRoleForBackup","durationSeconds":3600},"responseElements":{"credentials":{"accessKeyId":"ASIAUXAYGAARUSK5UYVY","sessionToken":"IQoJb3JpZ2luX2VjECYaCXVzLXdlc3QtMiJHMEUCIQCHN4C/15BwjSeL1WfgZjN76E7Kh3eCYy2svuIE+ZAI/AIgNwNTiuMFBoWt1yDh9wntwNLTRjub5k3Ah9Vf218i7N8q7QII////////////ARAAGgwzMjQzMjA3NTU3NDciDNA/rNnQ4nuvswBXwSrBAlibl5FDGK5P+OucJgBTBs1IAWk0XiwuZKxs5jPyYCVcfynJry5/cohAUU3Jwv/PJuihUi/yH6m6BRGuXIhkw8em1SWPpZL+e2LPmC6Yy5J7jJy/0Urc3Hs/C1t3c8s20/B52YCZLyd9Wf2SVm3aDFZiT15lOmRnjMvWiVVBldUDdFJ732GZHyHFKUiy9NAfRjGc+IJNTX7dW8WzMjhwVLo+Bqhn9d2mqUs/BUWFk3FOrlt7eWlKjFjdjd5AIxGWXxLewIq7RDwXmbuBM7pivCQGinbJ3E6BP2GTqu+sc5wuRW9zLndNkP1+IaQsR0n8hgu/5LPVnQCafJCmAWmx6bzxpCr6hWUjkQNa+H9QLTsazcbXdz1LJd50meruYL1rwI85VjYfxZEurpa2xCEGrT9I04mGujGMbTvsplm9igAwdjCiruiaBjq/AZDyITnqYU9zMHz8R0Wj31tQsi7gYmxjJiqBqZ38eMbZi7Uu6v4w42hUDtXHSnmk+sBMy1dGviXMQimIm1LdorKpymY9pZbHsuchfujGw3W3lTNNyBA0/XSjvP4fUKwaxF/EVd3jJZ8f0Jh1zYoYQalrrZqZ38WcA2xIV5VBs34913tqWmuKUmixLWj/z3YA1R0PEXO6iQj5u+vAHFXvgERInIZZSndCEmj+3P3mtL2uSfghGX8dC373YpNUxGGY","expiration":"Oct 27, 2022, 6:29:06 AM"},"assumedRoleUser":{"assumedRoleId":"AROAUXAYGAAR6T7RR6MHZ:AWSBackup-AWSServiceRoleForBackup","arn":"arn:aws:sts::324320755747:assumed-role/AWSServiceRoleForBackup/AWSBackup-AWSServiceRoleForBackup"}},"requestID":"b5d5dd0e-da3b-4b9a-9b10-66aa6499dd0b","eventID":"2217690c-a9ad-4af5-89e8-5f44fd031f91","readOnly":true,"resources":[{"accountId":"324320755747","type":"AWS::IAM::Role","ARN":"arn:aws:iam::324320755747:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"}],"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","sharedEventID":"3dd005a8-0ea7-4028-944d-41e69e12ecab","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AWSService","invokedBy":"backup.amazonaws.com"},"eventTime":"2022-10-27T05:29:07Z","eventSource":"sts.amazonaws.com","eventName":"AssumeRole","awsRegion":"us-west-2","sourceIPAddress":"backup.amazonaws.com","userAgent":"backup.amazonaws.com","requestParameters":{"roleArn":"arn:aws:iam::324320755747:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup","roleSessionName":"AWSBackup-AWSServiceRoleForBackup","durationSeconds":3600},"responseElements":{"credentials":{"accessKeyId":"ASIAUXAYGAARTY64K6J6","sessionToken":"IQoJb3JpZ2luX2VjECYaCXVzLXdlc3QtMiJGMEQCIEoddNB9O8E7i1W4zRb7w4Sn1Dl0ZRdKyrF4Tt4ozkZJAiAetqF1l40VdT0qC22CmZ/J75UrSPPkxLCSmcs42LM1eyrtAgj///////////8BEAAaDDMyNDMyMDc1NTc0NyIMvASGDu3fbh0eN9TvKsECEgC0b3otA9g5TYjzR+eS1xwkLIOYZ0bFtPnS7KMK1QtRZGscnfGiFNQKeWWHol6THMpV3oJ5mXKg2tfdhiObAOgcPDcWC9ehDcN0QXYeoPBZDVQFVbomSkz7UR9T1Ym1rEBUSiAI7/1rTy9StqQMbwBo5tnUEozuOt3ExBxihYcveZLYu8I1j49MKt2jF7jbF9Lt2P0WGA2ODoSDSZui8BjJ2aLKOmnHkh6T7TmTnE+oZ4nW+dmlTwBGRDr1oavvIrHDKqrTchOgDTwU2uw4qI4jyNU1Qgld1Lt+U32VRDNueBdTAnZsxn+jgKqzZcR8Vh/Chpue2RjE5q0iBrgFpgea0p4SZMVI+LHfE51I9UIVRZ6w5yIvMB9zt2JBBW0FBR2ua0Ic+faHSnXq4HXczhzYH1S+qNlQbU+Kk7+nAcQIMKOu6JoGOsABRYKcU4c//wIEGqS7SqdZ/Hm+EdwXhSADG7MAoDukXGsC7wMS6FUmhTqkqpUMzZ/0iTX8g0AeZ9xtJNwlP+szCO5eN/JH1Ty+VuidWaKWGMXg9f993Gk1+HkPuaB6Asfgjf0ZPe2YX/lx1qArE3sbItuRZQxHWLrssKjWPCz+CHQrckHvB5+/dEYZw22LnLfBv8VfwyyHZCTb8kTcE6uKFx0kHdaUx2v75G8ONNirbGKBn3Z1ggNfXIryOqh37Md/","expiration":"Oct 27, 2022, 6:29:07 AM"},"assumedRoleUser":{"assumedRoleId":"AROAUXAYGAAR6T7RR6MHZ:AWSBackup-AWSServiceRoleForBackup","arn":"arn:aws:sts::324320755747:assumed-role/AWSServiceRoleForBackup/AWSBackup-AWSServiceRoleForBackup"}},"requestID":"3a7121d6-3a0e-4322-a9ae-4950ee0e660e","eventID":"d9e71d23-fb45-444a-b9e4-aa6ef53f4ed5","readOnly":true,"resources":[{"accountId":"324320755747","type":"AWS::IAM::Role","ARN":"arn:aws:iam::324320755747:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup"}],"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","sharedEventID":"fbc26fe8-3c6a-4883-9d15-745fc271746f","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AssumedRole","principalId":"AROAUXAYGAAR6T7RR6MHZ:AWSBackup-AWSServiceRoleForBackup","arn":"arn:aws:sts::324320755747:assumed-role/AWSServiceRoleForBackup/AWSBackup-AWSServiceRoleForBackup","accountId":"324320755747","accessKeyId":"ASIAUXAYGAARTY64K6J6","sessionContext":{"sessionIssuer":{"type":"Role","principalId":"AROAUXAYGAAR6T7RR6MHZ","arn":"arn:aws:iam::324320755747:role/aws-service-role/backup.amazonaws.com/AWSServiceRoleForBackup","accountId":"324320755747","userName":"AWSServiceRoleForBackup"},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T05:29:07Z","mfaAuthenticated":"false"}},"invokedBy":"backup.amazonaws.com"},"eventTime":"2022-10-27T05:29:07Z","eventSource":"tagging.amazonaws.com","eventName":"GetResources","awsRegion":"us-west-2","sourceIPAddress":"backup.amazonaws.com","userAgent":"backup.amazonaws.com","requestParameters":{"paginationToken":"","tagFilters":[{"key":"aws:elasticfilesystem:default-backup","values":["enabled"]}],"resourcesPerPage":100,"resourceTypeFilters":["dynamodb:table","ec2:volume","rds:db","storagegateway:gateway","elasticfilesystem:file-system","rds:cluster","ec2:instance"]},"responseElements":null,"requestID":"7f60f12b-bfe1-490a-b68c-312a8c2a8201","eventID":"a9c95b7f-5e18-450f-aefe-1ac38eadf149","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"AWSService","invokedBy":"cloudtrail.amazonaws.com"},"eventTime":"2022-10-27T05:29:14Z","eventSource":"s3.amazonaws.com","eventName":"GetBucketAcl","awsRegion":"us-west-2","sourceIPAddress":"cloudtrail.amazonaws.com","userAgent":"cloudtrail.amazonaws.com","requestParameters":{"bucketName":"aws-cloudtrail-logs-324320755747-cca64b38","Host":"aws-cloudtrail-logs-324320755747-cca64b38.s3.us-west-2.amazonaws.com","acl":""},"responseElements":null,"additionalEventData":{"SignatureVersion":"SigV4","CipherSuite":"ECDHE-RSA-AES128-GCM-SHA256","bytesTransferredIn":0,"AuthenticationMethod":"AuthHeader","x-amz-id-2":"IZPKexwPHVElQ9aaMX9iGeOl4OIpw8pVryvPq86/9lrqR56Z0EHkfOmTFWJmLqjD45ON6KbUlqw=","bytesTransferredOut":584},"requestID":"MK2BMJYV8E9SN1S3","eventID":"f9190f91-b2d3-4847-8606-e4be39bb4d27","readOnly":true,"resources":[{"accountId":"324320755747","type":"AWS::S3::Bucket","ARN":"arn:aws:s3:::aws-cloudtrail-logs-324320755747-cca64b38"}],"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","sharedEventID":"0e70831f-3979-431b-9aea-14aea72e2de3","eventCategory":"Management"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR3KFKMP4IB","arn":"arn:aws:iam::324320755747:user/greyson.gundrum.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR5RTOHPFD","userName":"greyson.gundrum.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T04:06:57Z","mfaAuthenticated":"true"}}},"eventTime":"2022-10-27T05:29:07Z","eventSource":"cloudformation.amazonaws.com","eventName":"DescribeStackEvents","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"stackName":"arn:aws:cloudformation:us-west-2:324320755747:stack/greysongundrum822/a56b9260-55b7-11ed-b05e-06ea48473c9b"},"responseElements":null,"requestID":"0a4d8704-8e49-49c4-b34c-d36541308018","eventID":"179fa0d4-fc3c-496c-a284-d13d40af0127","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management","sessionCredentialFromConsole":"true"}
GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR3KFKMP4IB","arn":"arn:aws:iam::324320755747:user/greyson.gundrum.labs","accountId":"324320755747","accessKeyId":"ASIAUXAYGAAR5RTOHPFD","userName":"greyson.gundrum.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T04:06:57Z","mfaAuthenticated":"true"}}},"eventTime":"2022-10-27T05:29:07Z","eventSource":"cloudformation.amazonaws.com","eventName":"DescribeStacks","awsRegion":"us-west-2","sourceIPAddress":"AWS Internal","userAgent":"AWS Internal","requestParameters":{"stackName":"arn:aws:cloudformation:us-west-2:324320755747:stack/greysongundrum822/a56b9260-55b7-11ed-b05e-06ea48473c9b"},"responseElements":null,"requestID":"b92e61ad-09c9-4383-964f-882a316f6eb4","eventID":"47c5da93-6fb5-4a85-b70a-f4fca3979fe7","readOnly":true,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management","sessionCredentialFromConsole":"true"}

- Delete the CloudFormation stack and resources.

- Use the awslogs utility again to view those changes.

GreysonGundrumLogGroup821 324320755747_CloudTrail_us-west-2 {"eventVersion":"1.08","userIdentity":{"type":"IAMUser","principalId":"AIDAUXAYGAAR3KFKMP4IB","arn":"arn:aws:iam::324320755747:user/greyson.gundrum.labs","accountId":"324320755747","userName":"greyson.gundrum.labs","sessionContext":{"sessionIssuer":{},"webIdFederationData":{},"attributes":{"creationDate":"2022-10-27T04:11:12Z","mfaAuthenticated":"true"}},"invokedBy":"cloudformation.amazonaws.com"},"eventTime":"2022-10-27T05:28:24Z","eventSource":"ec2.amazonaws.com","eventName":"CreateTags","awsRegion":"us-west-2","sourceIPAddress":"cloudformation.amazonaws.com","userAgent":"cloudformation.amazonaws.com","requestParameters":{"resourcesSet":{"items":[{"resourceId":"i-0f14b755dab42a062"}]},"tagSet":{"items":[{"key":"User","value":"greyson.gundrum.labs"},{"key":"Purpose","value":"Stelligent-U"},{"key":"Topic","value":"Logging AWS infrastructure changes"},{"key":"Lab","value":"8.2.2"}]}},"responseElements":{"requestId":"6a085a7f-7ec6-44fd-a186-98bfa25e4f90","_return":true},"requestID":"6a085a7f-7ec6-44fd-a186-98bfa25e4f90","eventID":"730049c3-5a59-4f45-837a-3707767e7c96","readOnly":false,"eventType":"AwsApiCall","managementEvent":true,"recipientAccountId":"324320755747","eventCategory":"Management"}



#### Lab 8.2.3: Clean up

- Delete any stacks that you made for this topic.

- Make sure you keep all of the CloudFormation templates from this
  lesson in your GitHub repo.

### Retrospective 8.2

#### Question

_What type of events might be important to track in an AWS account? If
you were automating mitigating actions for the events, what might they
be and what AWS resource(s) would you use?_

#### Task

Dig out the CloudFormation template you used to create the CloudTrail
trail in lab 8.2.1. Add a CloudWatch event, SNS topic and SNS
subscription that will email you when any changes to EC2 instances are
made. Test this mechanism by creating and modifying new EC2 instances.
Make sure to clean up the CloudFormation stacks and any other resources
when you are done.
