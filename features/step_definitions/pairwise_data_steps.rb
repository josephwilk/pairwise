Given /^I have the (?:yaml |csv )?file "([^\"]*)" containing:$/ do |file_name, file_contents|
  create_file(file_name, file_contents)
end

Given /^I have the file "([^\"]*)"$/ do |filename|
  step %Q{I have the file "#{filename}" containing:}, ""
end

Given /^I have a folder "([^\"]*)"$/ do |folder_name|
  create_folder(folder_name)
end

When /^I run (.+)$/ do |command|
  run(command)
end

Then /^I should see the output$/ do |text|
  last_stdout.should == text
end

Then /^I should see in the output$/ do |string|
  Then "it should not show any errors"
  last_stdout.should include(string)
end

Then /^I should see in the errors$/ do |string|
  last_stderr.should include(string)
end

Then /^it should not show any errors$/ do
  last_stderr.should == ""
end
