return unless ENV['RAILS_ENV'] == 'development'

MemoryProfiler.start
at_exit do
  report = MemoryProfiler.stop
  report.pretty_print(color_output: true, scale_bytes: true)
end
