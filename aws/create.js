const AWSCFMonitor = require('aws-cf-monitor')
const req = require('require-yml')
const template = req('./stack')

// use the same params that the AWS.CloudFormation object normally takes
const site_name = 'why82'
const params = {
  StackName: `${site_name}-frontend-prod`,
  Parameters: [
    {
      ParameterKey: 'SiteName',
      ParameterValue: site_name,
      UsePreviousValue: false
    }
  ],
  Capabilities: [
    'CAPABILITY_IAM'
  ],
  TemplateBody: JSON.stringify(template)
}

AWSCFMonitor.createOrUpdateStack(params)
  .then((finalStatus) => {
    console.log(`Hooray, the stack is ${finalStatus}`);
    console.log('And I didn\'t have to write a bunch of boilerplate to wait for it!');
  })
  .catch(console.error)
