describe JobQueueParser do
  context "single job" do
    let(:parsed_job) { described_class.new("a => b").parse }

    it "indexes the job hash by job name" do
      expect(parsed_job.keys).to include("a")
    end

    it "creates the correct number of jobs" do
      expect(parsed_job.keys.size).to eq(1)
    end

    it "stores Job objects in the job hash" do
      expect(parsed_job["a"]).to be_an_instance_of(Job)
    end

    it "sets the correct job name" do
      expect(parsed_job["a"].name).to eq("a")
    end

    it "sets the correct job dependency" do
      expect(parsed_job["a"].dependency).to eq("b")
    end
  end

  context "multiple jobs" do
    let(:parsed_jobs) { described_class.new("a => b
                                             b =>
                                             c =>").parse }

    it "creates the correct number of jobs" do
      expect(parsed_jobs.keys.size).to eq(3)
    end

    it "parses the jobs correctly" do
      expect(parsed_jobs.values.map(&:name)).to eq(["a", "b", "c"])
    end

    it "sets the correct job dependency" do
      expect(parsed_jobs["a"].dependency).to eq("b")
    end
  end
end
