def __main__(argv)
  if argv[1] == "-v"
    puts "v#{RubyCLI::VERSION}"
  elsif argv[1] == "-h"
    puts "ruby-cli PROJECT_NAME"
  else
    RubyCLI::Setup.execute(argv[1])
  end
end
