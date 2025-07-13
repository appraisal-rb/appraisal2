if ENV["CI"].nil? && ENV.fetch("DEBUG", "false").casecmp("true") == 0
  ENV["VERBOSE"] = "true"
  ruby_version = Gem::Version.new(RUBY_VERSION)
  if ruby_version < Gem::Version.new("2.7")
    # Use byebug in code
    require "byebug"
  else
    # Use binding.break, binding.b, or debugger in code
    require "debug"
  end
end
