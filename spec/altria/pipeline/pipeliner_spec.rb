require File.expand_path("../../../spec_helper", __FILE__)

describe Altria::Pipeline::Pipeliner do
  let(:pipeliner) do
    described_class.new(job)
  end

  let(:job) do
    FactoryGirl.create(:job)
  end

  describe "#after_execute" do
    context "without job.next_job_ids" do
      it "does nothing" do
        pipeliner.should_not_receive(:enqueue)
        pipeliner.after_execute
      end
    end

    context "with space separated job ids" do
      before do
        job.update_properties(next_job_ids: [0, FactoryGirl.create(:job).id].join(" "))
      end

      it "enqueues next job" do
        Job.any_instance.should_receive(:enqueue)
        pipeliner.after_execute
      end
    end
  end
end
