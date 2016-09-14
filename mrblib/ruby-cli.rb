def __main__(argv)
  if argv[1] == "version" || argv[1] == "-v"
    puts "v#{RubyCLI::VERSION}"
  else
    puts "Hello World"
  end
end
