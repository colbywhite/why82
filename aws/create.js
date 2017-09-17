const AWSCFMonitor = require('aws-cf-monitor')
const req = require('require-yml')
const template = req('./stack')

if (!template) {
  throw new Error('template is undefined')
}

// use the same params that the AWS.CloudFormation object normally takes
const site_name = 'why82'
const cert_id = '1941f4c3-d4c7-4fad-9c44-d9e38196930f'
const params = {
  StackName: `${site_name}-frontend-prod`,
  Parameters: [
    {
      ParameterKey: 'SiteName',
      ParameterValue: site_name,
      UsePreviousValue: false
    }, {
      ParameterKey: 'ACMCertId',
      ParameterValue: cert_id,
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
