Feature: Generating pairwise data
  In order to test small, managable datasets while having confidence in test coverage
  As a tester
  I want a set of tests which is smaller than all the possible combinations of my specified inputs

Scenario: Ordered yaml inputs
  Given I have the yaml file "inputs.yml" containing:
    """
    - event with image: [Football, Basketball, Soccer]
    - event without image: [Football, Basketball, Soccer]
    - media: [Image, Video, Music]
    """
  When I run pairwise inputs.yml
  Then I should see the output
    """
    |event with image|event without image|media|
    |Football|Football|Image|
    |Football|Basketball|Video|
    |Football|Soccer|Music|
    |Basketball|Football|Music|
    |Basketball|Basketball|Image|
    |Basketball|Soccer|Video|
    |Soccer|Football|Video|
    |Soccer|Basketball|Music|
    |Soccer|Soccer|Image|

    """

Scenario: Unorderd yaml inputs
  Given I have the yaml file "inputs.yml" containing:
    """
    event with image: [Football, Basketball, Soccer]
    event without image: [Football, Basketball, Soccer]
    media: [Image, Video, Music]
    """
  When I run pairwise inputs.yml
  Then I should see the output
    """
    |media|event without image|event with image|
    |Image|Football|Football|
    |Image|Basketball|Basketball|
    |Image|Soccer|Soccer|
    |Video|Football|Soccer|
    |Video|Basketball|Football|
    |Video|Soccer|Basketball|
    |Music|Football|Basketball|
    |Music|Basketball|Soccer|
    |Music|Soccer|Football|

    """
