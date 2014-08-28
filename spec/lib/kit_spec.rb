# encoding: UTF-8

require "spec_helper"

describe Tetra::Kit do
  include Tetra::Mockers

  before(:each) do
    create_mock_project

    @project.dry_run
    @project.finish(false)

    @kit = Tetra::Kit.new(@project)
  end

  after(:each) do
    delete_mock_project
  end

  describe "#to_spec" do
    it "generates the first version" do
      expect(@kit.to_spec).to be_truthy

      @project.from_directory do
        spec_lines = File.readlines(File.join("output", "test-project-kit", "test-project-kit.spec"))
        expect(spec_lines).to include("Name:           test-project-kit\n")
        expect(spec_lines).to include("Version:        1\n")
        expect(spec_lines).to include("Source0:        %{name}.tar.xz\n")
      end
    end
    it "generates a second version" do
      expect(@kit.to_spec).to be_truthy
      @project.dry_run
      Dir.chdir(@project_path) do
        test_file = File.join("kit", "test")
        File.open(test_file, "w") { |io| io.puts "changed kit content test file" }

        File.open(File.join("output", "test-project-kit", "test-project-kit.spec"), "a") do |io|
          io.write("nonconflicting line")
        end
      end
      @project.finish(false)

      expect(@kit.to_spec).to be_truthy

      @project.from_directory do
        spec_lines = File.readlines(File.join("output", "test-project-kit", "test-project-kit.spec"))
        expect(spec_lines).to include("Name:           test-project-kit\n")
        expect(spec_lines).to include("Version:        2\n")
        expect(spec_lines).to include("Source0:        %{name}.tar.xz\n")
        expect(spec_lines).to include("nonconflicting line\n")
      end
    end
    it "generates a conflicting version" do
      expect(@kit.to_spec).to be_truthy
      @project.dry_run
      Dir.chdir(@project_path) do
        test_file = File.join("kit", "test")
        File.open(test_file, "w") { |io| io.puts "changed kit content test file" }

        spec_path = File.join("output", "test-project-kit", "test-project-kit.spec")
        spec_contents = File.read spec_path

        spec_contents.gsub!(/^Version:.*$/, "CONFLICTING!")

        File.open(spec_path, "w+") do |io|
          io.write(spec_contents)
        end
      end
      @project.finish(false)

      expect(@kit.to_spec).to be_truthy

      @project.from_directory do
        spec_lines = File.readlines(File.join("output", "test-project-kit", "test-project-kit.spec"))
        expect(spec_lines).to include("Name:           test-project-kit\n")
        expect(spec_lines).to include("Source0:        %{name}.tar.xz\n")
        expect(spec_lines).to include("<<<<<<< newly generated\n")
        expect(spec_lines).to include("Version:        2\n")
        expect(spec_lines).to include("=======\n")
        expect(spec_lines).to include("CONFLICTING!\n")
        expect(spec_lines).to include(">>>>>>> user edited\n")
      end
    end

  describe "#to_archive" do
    it "generates an archive" do
      @project.from_directory("kit") do
        FileUtils.touch("kit_test")
      end

      @kit.to_archive

      @project.from_directory do
        expect(`tar -Jtf output/test-project-kit/test-project-kit.tar.xz`.split).to include("kit_test")
      end
    end
  end
end
