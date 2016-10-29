const $ = require('jquery');

const ajax_error_handler = function(xhr, status, err) {
  const errorMessage = url + ' returned: ' + status + ': ' + err.toString();
  reject(errorMessage);
};

const parse_lastest_bucket_entry = function(list_bucket_result, season, suffix) {
  const relevant_regex = new RegExp('^'+ season + '\\/\\d{4}-\\d{2}-\\d{2}' + suffix);
  const relevant_keys = $(list_bucket_result).find('Contents')
    .map(function(){
      return $('Key', this).text();
    })
    .filter(function(){
      return relevant_regex.test(this);
    });
  var latest_key = relevant_keys[0];
  relevant_keys.each(function(){
    latest_key = this > latest_key ? this : latest_key;
  })
  return latest_key;
};

const grab_latest_bucket_entry_url = function(bucket_url, season, suffix){
  return new Promise(function(resolve, reject){
    $.ajax({
      url: bucket_url,
      dataType: 'xml',
      cache: true,
      success: function(list_bucket_result) {
        const latest_key = parse_lastest_bucket_entry(list_bucket_result, season, suffix);
        resolve(bucket_url + '/' + latest_key);
      },
      error: ajax_error_handler
    });
  });
};

const grab_data = function(url) {
  return new Promise(function(resolve, reject){
    $.ajax({
      url: url,
      dataType: 'json',
      cache: true,
      success: function(data) {
        resolve(data);
      },
      error: ajax_error_handler
    });
  });
};

const grab_latest_bucket_data = function(bucket_url, season, suffix){
  return grab_latest_bucket_entry_url(bucket_url, season, suffix)
    .then(function(bucket_entry_url){
      return grab_data(bucket_entry_url);
    });
};

module.exports = {
  grab_latest_schedule_data: function(bucket_url, season){
    return grab_latest_bucket_data(bucket_url, season, '-schedule.json');
  },
  grab_latest_tiers_data: function(bucket_url, season){
    return grab_latest_bucket_data(bucket_url, season, '-tiers.json');
  }
};
