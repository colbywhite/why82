require 'spec_helper'

RSpec.describe SeasonController do
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
      before(:each) do
        Delayed::Job.destroy_all
      end

      it 'should enqueue one job' do
        post :update, short_name: 'test', name: 'TEST'
        expect(Delayed::Job.count).to eq 1
        job = YAML.load Delayed::Job.first.handler
        expect(job.class).to eq(UpdateSeason)
        expect(job.name).to eq('TEST')
        expect(job.short_name).to eq('test')
      end
    end
  end
end
