require 'spec_helper'

RSpec.describe SeasonController do
  include ActiveJob::TestHelper

  after :each do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe 'POST' do
    describe 'param validation' do
      it 'should reject if there are no params' do
        post :update
        expect(response.status).to eq(400)
      end

      it 'should reject if there is no :name' do
        post :update, short_name: 'TEST'
        expect(response.status).to eq(400)
      end

      it 'should reject if there is no :short_name' do
        post :update, name: 'TEST'
        expect(response.status).to eq(400)
      end

      it 'should accept request with proper params' do
        post :update, short_name: 'TEST', name: 'TEST'
        expect(response.status).to eq(204)
      end
    end

    describe 'queue logic' do
      it 'should enqueue one job' do
        post :update, short_name: 'test', name: 'TEST'
        expect(enqueued_jobs.size).to eq 1
        job = enqueued_jobs.first
        expect(job[:job]).to eq(LoadNbaSeasonJob)
        expect(job[:args]).to eq(%w(TEST test))
      end
    end
  end
end
