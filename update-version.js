// heavily based on
// https://www.bilyachat.com/blog/angular-2-build-version

const replace = require('replace-in-file');

const buildVersion = require('./package.json').version;
const options = {
  files: 'src/environments/environment.prod.ts',
  from: /version: '(.*)'/g,
  to: `version: '${buildVersion}'`,
  allowEmptyPaths: false,
};

try {
  const changedFiles = replace.sync(options);
  if (changedFiles.length <= 0) {
    throw `Please make sure that file '${options.files}' has "version: ''"`;
  }
  console.log(`Build version set: ${buildVersion}`);
}
catch (error) {
  console.error('Error occurred:', error);
  throw error
}
