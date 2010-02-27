Feature: Bad arguments

Scenario: Non existent file
  When I run pairwise file_with_does_not_exist
  And I should see in the errors
  """
  No such file or directory
  """

Scenario: Existing folder
  Given I have a folder "empty"
  When I run pairwise empty/
  Then I should see in the output
  """
  Usage: pairwise
  """

Scenario: Unsupported input file type
  Given I have the file "example.rar"
  When I run pairwise example.rar
  Then I should see in the errors
  """
  Unsupported file type: rar
  """