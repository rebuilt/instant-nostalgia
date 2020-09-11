MemoryProfiler.start
at_exit do
  report = MemoryProfiler.stop
  report.pretty_print
end
