def __main__(argv)
  if argv[1] == "version" || argv[1] == "-v"
    puts "v#{RubyCLI::VERSION}"
  else
    RubyCLI::Setup.execute(argv[1])
  end
end
