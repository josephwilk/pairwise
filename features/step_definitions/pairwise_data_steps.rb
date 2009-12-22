Given /^I have the yaml file "([^\"]*)" containing:$/ do |file_name, file_contents|
  create_file(file_name, file_contents)
end

When /^I run (.+)$/ do |command|
  run(command)
end

Then /^I should see the output$/ do |text|
  last_stdout.should == text
end

Then /^I should see in the output$/ do |string|
  last_stdout.should include(string)
end
