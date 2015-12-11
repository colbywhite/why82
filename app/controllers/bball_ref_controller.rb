class BballRefController < ApplicationController
  # a dummy endpoint to test how heroku's worker dyno handles bballref
  # It'll log info from the web dyno, then a queue a job to do the same on the worker dyno
  # TODO: take out when i get the info I want
  def check
    checker = BballRef::Checker.new
    render status: :bad_gateway unless checker.perform
    Delayed::Job.enqueue checker
    head :no_content
  end
end
