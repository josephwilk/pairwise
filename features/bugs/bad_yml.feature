Feature: Bad yml

Scenario: Empty yml
  Given I have the yaml file "inputs.yml" containing:
  """

  """
  When I run pairwise inputs.yml
  Then it should not show any errors

Scenario: yml with no lists
  Given I have the yaml file "inputs.yml" containing:
  """
  mookey
  """
  When I run pairwise inputs.yml
  Then it should not show any errors
