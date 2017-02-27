describe Job do
  it "requires name" do
    expect{
      described_class.new
    }.to raise_error(ArgumentError)
  end

  it "sets the correct job name" do
    expect(described_class.new("a").name).to eq("a")
  end

  context "job name is equals job dependency" do
    it "raises an error" do
      expect{
        described_class.new("a", "a")
      }.to raise_error(ArgumentError, "Jobs can't depend on themselves")
    end
  end

  context "with no dependency" do
    it "sets nil for job dependency" do
      expect(described_class.new("a").dependency).to be_nil
    end
  end

  context "with a dependency" do
    it "sets the correct job dependency" do
      expect(described_class.new("a", "b").dependency).to eq("b")
    end
  end
end
