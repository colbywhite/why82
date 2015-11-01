require 'spec_helper'

describe League do
  it 'should not allow null league for season' do
    null_create =
        -> { create(:season, league: nil) }
    expect(null_create).to(raise_error(ActiveRecord::StatementInvalid))
  end
end
