#!/usr/bin/env ruby

shell_script_path = File.join(__dir__, File.basename($PROGRAM_NAME, '.rb') + '.sh')

exec shell_script_path, *ARGV
