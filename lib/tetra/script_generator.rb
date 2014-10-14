# encoding: UTF-8

module Tetra
  # generates build scripts from bash_history
  class ScriptGenerator
    include Logging

    def initialize(project, history_path)
      @project = project
      @ant_runner = Tetra::AntRunner.new(project)
      @maven_runner = Tetra::MavenRunner.new(project)
      @history_path = history_path
    end

    def generate_build_script
      @project.from_directory do
        history_lines = File.readlines(@history_path).map { |e| e.strip }
        relevant_lines =
          history_lines
            .reverse
            .take_while { |e| e.match(/tetra +dry-run/).nil? }
            .reverse
            .take_while { |e| e.match(/tetra +finish/).nil? }
            .select { |e| e.match(/^#/).nil? }

        script_lines = [
          "#!/bin/bash",
          "PROJECT_PREFIX=`readlink -e .`",
          "cd #{@project.latest_dry_run_directory}"
        ] +
        relevant_lines.map do |line|
          if line =~ /tetra +mvn/
            line.gsub(/tetra +mvn/, "#{@maven_runner.get_maven_commandline("$PROJECT_PREFIX", ["-o"])}")
          elsif line =~ /tetra +ant/
            line.gsub(/tetra +ant/, "#{@ant_runner.get_ant_commandline("$PROJECT_PREFIX")}")
          else
            line
          end
        end

        new_content = script_lines.join("\n") + "\n"

        result_path = File.join("src", "build.sh")
        conflict_count = @project.merge_new_content(new_content, result_path, "Build script generated",
                                                    "generate_build_script")

        output_dir = File.join("output", @project.name)
        FileUtils.mkdir_p(output_dir)

        destination_script_path =  File.join(output_dir, "build.sh")
        FileUtils.symlink(File.expand_path(result_path), destination_script_path, force: true)

        [result_path, conflict_count]
      end
    end
  end
end
