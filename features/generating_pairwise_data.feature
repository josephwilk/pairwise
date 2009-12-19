Feature: Generating pairwise data
  In order to test small, managable datasets while having confidence in test coverage
  As a tester
  I want a set of tests which is smaller than all the possible combinations of my specified inputs

Scenario:
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
    |Soccer|Football|Image|
    |Soccer|Basketball|Music|
    |Soccer|Soccer|Music|
    |:wild_card|Soccer|Image|
    |:wild_card|Football|Video|

    """
