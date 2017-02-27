describe JobQueueManager do
  context "no jobs passed" do
    it "returns an empty array" do
      expect(described_class.new("").process_jobs_queue).to eq([])
    end
  end

  context "single job passed" do
    it "returns the single job" do
      expect(described_class.new("a =>").process_jobs_queue).to eq(["a"])
    end
  end

  context "multiple jobs passed" do
    context "no dependency" do
      let(:jobs) { "a =>
                    b =>
                    c =>" }

      it "returns abc" do
        expect(described_class.new(jobs).process_jobs_queue).to eq(["a", "b", "c"])
      end
    end

    context "single dependency" do
      let(:jobs) { "a =>
                    b => c
                    c =>" }

      it "returns acb" do
        expect(described_class.new(jobs).process_jobs_queue).to eq(["a", "c", "b"])
      end
    end

    context "multiple dependencies" do
      let(:jobs) { "a =>
                    b => c
                    c => f
                    d => a
                    e => b
                    f =>" }

      it "returns fcadbe" do
       expect(described_class.new(jobs).process_jobs_queue).to eq(["f", "c", "a", "d", "b", "e"])
      end
    end
  end

  context "circular dependency passed" do
    let(:jobs) { "a =>
                  b => c
                  c => f
                  d => a
                  e =>
                  f => b" }

    it "raises an error" do
      expect {
        described_class.new(jobs).process_jobs_queue
      }.to raise_error(RuntimeError, "Jobs can't have circular dependencies")
    end
  end
end
