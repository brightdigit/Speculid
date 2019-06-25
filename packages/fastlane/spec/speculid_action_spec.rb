describe Fastlane::Actions::SpeculidAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The speculid plugin is working!")

      Fastlane::Actions::SpeculidAction.run(nil)
    end
  end
end
