require 'spec_helper'

describe SeedOMatic do
  describe "run" do
    subject { described_class.run opts }

    context "specified file" do
      let(:opts) { { :file => 'spec/support/single_model.yml' } }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'model_name',
                                                                    :items => ['name' => 'Name 1', 'code' => 'code_1']))
        subject
      }
    end
  end
end