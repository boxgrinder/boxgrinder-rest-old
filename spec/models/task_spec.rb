require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  it "should have initial status NEW" do
    Task.create.status.should eql(Task::STATUSES[:new])
  end
end
