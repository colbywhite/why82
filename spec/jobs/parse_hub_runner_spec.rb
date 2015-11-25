require 'spec_helper'

RSpec.describe ParseHubRunner do
  let(:dummy_class) { Class.new.include ParseHubRunner }
  let(:runner) { dummy_class.new }

  before :each do
    allow(runner).to receive(:get_run_response) do |run_token|
      File.read "spec/resources/parse_hub_responses/get_run/#{run_token}.json"
    end

    allow(runner).to receive(:start_run_response) do
      File.read 'spec/resources/parse_hub_responses/start_run.json'
    end

    @expected_started_run_token = 't_08pohlJtwEaXHcsIcvMgTO'
  end

  describe '#poll_run_until_finished' do
    it 'should throw err if run stays incomplete' do
      expect do
        runner.poll_run_until_finished(1, 0.5, 'incomplete')
      end.to raise_error WaitUtil::TimeoutError
    end

    it 'should not throw err if run is complete' do
      expect do
        runner.poll_run_until_finished(1, 0.5, 'complete')
      end.to_not raise_error
    end
  end

  describe '#start_run_and_wait' do
    it 'should stop polling when done' do
      allow(runner).to receive(:run_done?).and_return(false, false, true)
      expect(runner).to receive(:run_done?)
        .with(@expected_started_run_token).exactly(3).times
      run_token = runner.start_run_and_wait nil
      expect(run_token).to eq(@expected_started_run_token)
    end

    it 'should move to secondary rate when not complete' do
      allow(runner).to receive(:run_done?).and_return(false, false,
                                                      false, false, true)
      allow(runner).to receive(:poll_run_until_finished).and_call_original
      expect(runner).to receive(:poll_run_until_finished).twice
      expect(runner).to receive(:run_done?).with(@expected_started_run_token)
        .exactly(5).times
      run_token = runner.start_run_and_wait nil
      expect(run_token).to eq(@expected_started_run_token)
    end
  end
end
