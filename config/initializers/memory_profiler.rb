MemoryProfiler.start
at_exit do
  report = MemoryProfiler.stop
  report.pretty_print(color_output: true, scale_bytes: true)
  # report.pretty_print(to_file: 'profile.txt', color_output: true, scale_bytes: true)
end
