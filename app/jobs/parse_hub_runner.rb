module ParseHubRunner
  include ParseHubInfo

  def logger
    Rails.logger
  end

  def start_run_url(project_token)
    "#{BASE_URL}/projects/#{project_token}/run"
  end

  def get_run_url(run_token)
    "#{BASE_URL}/runs/#{run_token}"
  end

  def start_run(project_token)
    JSON.parse(start_run_response(project_token).to_s)[RUN_TOKEN]
  end

  def start_run_response(project_token)
    RestClient.post start_run_url(project_token), api_key: PARSEHUB_API_KEY
  end

  def start_run_and_wait(project_token)
    run_token = start_run project_token
    logger.info "Started run #{run_token}"
    wait_until_run_finishes run_token
    logger.info "#{run_token} finished"
    run_token
  end

  def wait_until_run_finishes(run_token)
    poll_run_until_finished INITIAL_POLL_TIMEOUT,
                            INITIAL_POLL_INTERVAL, run_token
  rescue WaitUtil::TimeoutError
    logger.warn 'The job did not finish within '\
                "the first #{INITIAL_POLL_TIMEOUT} seconds"
    logger.warn 'Continuing to wait, but polling at a slower rate.'
    poll_run_until_finished SECONDARY_POLL_TIMEOUT,
                            SECONDARY_POLL_INTERVAL, run_token
  end

  def poll_run_until_finished(timeout, delay, run_token)
    sleep delay
    WaitUtil.wait_for_condition("for run #{run_token} to finish",
                                timeout_sec: timeout - delay,
                                delay_sec: delay) do
      logger.info "Checking if #{run_token} finished..."
      run_done? run_token
    end
  end

  def get_run(run_token)
    JSON.parse get_run_response(run_token).to_s
  end

  def get_run_response(run_token)
    RestClient.get get_run_url(run_token), params: { api_key: PARSEHUB_API_KEY }
  end

  def run_done?(run_token)
    get_run(run_token)[STATUS] == COMPLETE
  end
end
