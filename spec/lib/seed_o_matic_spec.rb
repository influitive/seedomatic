require 'spec_helper'

describe SeedOMatic do
  let!(:mock_seeder) { mock(SeedOMatic::Seeder).as_null_object }

  describe "run" do
    subject { described_class.run opts }

    context "specified file" do
      let(:opts) { { :file => 'spec/support/single_model.yml' } }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'model_name',
                                                                    :items => ['name' => 'Name 1', 'code' => 'code_1'])).and_return(mock_seeder)
        subject
      }
    end

    context "specified directory" do
      let(:opts) { { :dir => 'spec/support/seed_directory' } }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'dir1')).and_return(mock_seeder)
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'dir2')).and_return(mock_seeder)

        subject
      }
    end

    context "no options (assumed config / seeds directory)" do

    end

    describe "multiple records in a file" do
      let(:opts) { { :file => 'spec/support/multiple_models.yml'} }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'model_1')).and_return(mock_seeder)
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'model_2')).and_return(mock_seeder)

        subject
      }
    end

    describe "json data" do
      let(:opts) { { :file => 'spec/support/single_model.json' } }

      specify {
        SeedOMatic::Seeder.should_receive(:new).with(hash_including(:model_name => 'model_name',
                                                                    :items => ['name' => 'Name 1', 'code' => 'code_1'])).and_return(mock_seeder)
        subject
      }
    end
  end

  describe "should_import?" do
    subject { SeedOMatic.send(:should_import?, run_options, file_info)}

    describe "tagged_with" do
      let(:run_options) { { :tagged_with => 'tag1'}}

      context "tag exists" do
        let(:file_info) { {:tags => ['tag1', 'tag2']}}
        it { should be_true }
      end
      context "tag does not exist" do
        let(:file_info) { {:tags => ['tag3', 'tag2']}}
        it { should be_false }
      end
      context "multiple tags" do
        let(:run_options) { { :tagged_with => ['tag1', 'tag2'] }}
        context "all match" do
          let(:file_info) { {:tags => ['tag1', 'tag2', 'tag3']}}
          it { should be_true }
        end
        context "some match" do
          let(:file_info) { {:tags => ['tag4', 'tag2', 'tag3']}}
          it { should be_false}
        end
      end
    end
    describe "not_tagged_with" do
      let(:run_options) { { :not_tagged_with => 'tag1'}}
      context "tag exists" do
        let(:file_info) { {:tags => ['tag1', 'tag2']}}
        it { should be_false }
      end
      context "tag does not exist" do
        let(:file_info) { {:tags => ['tag3']}}
        it { should be_true }
      end
      context "no tags" do
        let(:file_info) { {:tags => []}}
        it { should be_true }
      end
    end
  end
end