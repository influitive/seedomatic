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

    context "specified directory" do
      let(:opts) { { :dir => 'spec/support/seed_directory' } }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'dir1'))
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'dir2'))

        subject
      }
    end

    context "no options (assumed config / seeds directory)" do

    end
  end
end