# encoding: UTF-8

# ruby standard library
require "digest/sha1"
require "English"
require "erb"
require "find"
require "forwardable"
require "logger"
require "open-uri"
require "pathname"
require "singleton"
require "text"

# third party libraries
require "clamp"
require "json"
require "nokogiri"
require "rest_client"
require "zip"

# internal, backend
require "tetra/version"
require "tetra/logger"
require "tetra/template_manager"
require "tetra/git"
require "tetra/script_generator"
require "tetra/project"
require "tetra/pom"
require "tetra/version_matcher"
require "tetra/maven_website"
require "tetra/pom_getter"
require "tetra/source_getter"
require "tetra/kit_runner"
require "tetra/ant_runner"
require "tetra/maven_runner"
require "tetra/kit_spec_adapter"
require "tetra/package_spec_adapter"
require "tetra/spec_generator"
require "tetra/archiver"
require "tetra/kit_checker"

# internal, UI
require "tetra/commands/base"

require "tetra/commands/ant"
require "tetra/commands/download_maven_source_jars"
require "tetra/commands/dry_run"
require "tetra/commands/finish"
require "tetra/commands/generate_all"
require "tetra/commands/generate_kit_archive"
require "tetra/commands/generate_kit_spec"
require "tetra/commands/generate_package_archive"
require "tetra/commands/generate_package_script"
require "tetra/commands/generate_package_spec"
require "tetra/commands/get_pom"
require "tetra/commands/get_source"
require "tetra/commands/init"
require "tetra/commands/list_kit_missing_sources"
require "tetra/commands/move_jars_to_kit"
require "tetra/commands/mvn"

require "tetra/main"