# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tengine_support"
  s.version = "0.3.26"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["shyouhei", "akm", "taigou"]
  s.date = "2012-02-16"
  s.description = "tengine_support provides utility classes/modules which is not included in active_support. It doesn't depend on other tengine gems."
  s.email = "tengine-info@groovenauts.jp"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "NULL",
    "README.md",
    "Rakefile",
    "VERSION",
    "gemfiles/Gemfile.activesupport-3.0.10",
    "gemfiles/Gemfile.activesupport-3.1.1",
    "lib/tengine/support.rb",
    "lib/tengine/support/config.rb",
    "lib/tengine/support/config/amqp.rb",
    "lib/tengine/support/config/definition.rb",
    "lib/tengine/support/config/definition/field.rb",
    "lib/tengine/support/config/definition/group.rb",
    "lib/tengine/support/config/definition/has_many_children.rb",
    "lib/tengine/support/config/definition/optparse_visitor.rb",
    "lib/tengine/support/config/definition/suite.rb",
    "lib/tengine/support/config/logger.rb",
    "lib/tengine/support/config/mongoid.rb",
    "lib/tengine/support/core_ext.rb",
    "lib/tengine/support/core_ext/array.rb",
    "lib/tengine/support/core_ext/array/deep_dup.rb",
    "lib/tengine/support/core_ext/enumerable.rb",
    "lib/tengine/support/core_ext/enumerable/deep_freeze.rb",
    "lib/tengine/support/core_ext/enumerable/each_next_tick.rb",
    "lib/tengine/support/core_ext/hash.rb",
    "lib/tengine/support/core_ext/hash/compact.rb",
    "lib/tengine/support/core_ext/hash/deep_dup.rb",
    "lib/tengine/support/core_ext/hash/keys.rb",
    "lib/tengine/support/core_ext/module.rb",
    "lib/tengine/support/core_ext/module/private_constant.rb",
    "lib/tengine/support/null_logger.rb",
    "lib/tengine/support/yaml_with_erb.rb",
    "lib/tengine_support.rb",
    "spec/spec_helper.rb",
    "spec/support/app1.rb",
    "spec/support/suite.rb",
    "spec/tengine/support/config/amqp_spec.rb",
    "spec/tengine/support/config/logger_spec.rb",
    "spec/tengine/support/config/mongoid_spec.rb",
    "spec/tengine/support/config_spec.rb",
    "spec/tengine/support/config_spec/dump_skelton_spec.rb",
    "spec/tengine/support/config_spec/load_config_file_by_config_option_spec.rb",
    "spec/tengine/support/config_spec/load_spec.rb",
    "spec/tengine/support/config_spec/load_spec_01.yml.erb",
    "spec/tengine/support/config_spec/load_spec_01_with_other_settings.yml.erb",
    "spec/tengine/support/config_spec/load_spec_02.yml.erb",
    "spec/tengine/support/config_spec/parse_spec.rb",
    "spec/tengine/support/core_ext/array/deep_dup_spec.rb",
    "spec/tengine/support/core_ext/enumerable/deep_freeze_spec.rb",
    "spec/tengine/support/core_ext/enumerable/each_next_tick_spec.rb",
    "spec/tengine/support/core_ext/hash/compact_spec.rb",
    "spec/tengine/support/core_ext/hash/deep_dup_spec.rb",
    "spec/tengine/support/core_ext/hash/keys_spec.rb",
    "spec/tengine/support/null_logger_spec.rb",
    "spec/tengine/support/yaml_with_erb_spec.rb",
    "spec/tengine/support/yaml_with_erb_spec/test1.yml.erb",
    "spec/tengine/support/yaml_with_erb_spec/test2_with_erb.yml",
    "spec/tengine/support/yaml_with_erb_spec/test3_without_erb.yml",
    "spec/tengine/support/yaml_with_erb_spec/test4_with_invalid_erb.yml",
    "tengine_support.gemspec"
  ]
  s.homepage = "http://github.com/tengine/tengine_support"
  s.licenses = ["MPL/LGPL"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.16"
  s.summary = "tengine_support provides utility classes/modules which isn't included in active_support."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.18"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.5.3"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<rdiscount>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<yard>, ["~> 0.7.2"])
      s.add_dependency(%q<bundler>, ["~> 1.0.18"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<simplecov>, ["~> 0.5.3"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<rdiscount>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<yard>, ["~> 0.7.2"])
    s.add_dependency(%q<bundler>, ["~> 1.0.18"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<simplecov>, ["~> 0.5.3"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<rdiscount>, [">= 0"])
  end
end

