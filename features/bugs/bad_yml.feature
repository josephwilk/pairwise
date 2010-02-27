Feature: Bad yml

  Scenario: Empty yml
    Given I have the yaml file "inputs.yml" containing:
    """

    """
    When I run pairwise inputs.yml
    Then it should not show any errors
    And I should see in the output
    """
    Error: 'inputs.yml' does not contain the right structure for me to generate the pairwise set!
    """

  Scenario: yml with no lists
    Given I have the yaml file "listey_inputs.yml" containing:
    """
    mookey
    """
    When I run pairwise listey_inputs.yml
    Then it should not show any errors
    And I should see in the output
    """
    Error: 'listey_inputs.yml' does not contain the right structure for me to generate the pairwise set!
    """