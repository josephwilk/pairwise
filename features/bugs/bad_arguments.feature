Feature: Bad arguments

Scenario: Non existent file
  When I run pairwise file_with_does_not_exist
  And I should see in the errors
  """
  No such file or directory
  """

Scenario: Existing folder
  Given the folder "empty"
  When I run pairwise empty/
  And I should see in the output
  """
  Usage: pairwise
  """