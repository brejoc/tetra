# encoding: UTF-8

module Tetra
  # tetra generate-kit-archive
  class GenerateKitArchiveCommand < Tetra::BaseCommand
    def execute
      checking_exceptions do
        project = Tetra::Project.new(".")
        ensure_dry_running(false, project) do
          result_path = Tetra::Kit.new(project).to_archive
          print_generation_result(project, result_path)
        end
      end
    end
  end
end
