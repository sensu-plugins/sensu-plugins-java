#!/usr/bin/env ruby

shell_script_path = File.join(__dir__, File.basename($PROGRAM_NAME, '.rb') + '.py')

exec shell_script_path, *ARGV
