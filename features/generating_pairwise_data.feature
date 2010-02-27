Feature: Generating pairwise data
  In order to test small, managable datasets while having confidence in test coverage
  As a tester
  I want a set of tests which is smaller than all the possible combinations of my specified inputs

  Scenario: No input file specified
    When I run pairwise
    Then I should see in the output
    """
    Usage: pairwise [options] FILE.[yml|csv]
    """

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
      | event with image | event without image | media |
      | Football         | Football            | Image |
      | Football         | Basketball          | Video |
      | Football         | Soccer              | Music |
      | Basketball       | Football            | Music |
      | Basketball       | Basketball          | Image |
      | Basketball       | Soccer              | Video |
      | Soccer           | Football            | Video |
      | Soccer           | Basketball          | Music |
      | Soccer           | Soccer              | Image |

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
      | media | event without image | event with image |
      | Image | Football            | Football         |
      | Image | Basketball          | Basketball       |
      | Image | Soccer              | Soccer           |
      | Video | Football            | Soccer           |
      | Video | Basketball          | Football         |
      | Video | Soccer              | Basketball       |
      | Music | Football            | Basketball       |
      | Music | Basketball          | Soccer           |
      | Music | Soccer              | Football         |

      """

  Scenario: Single value yaml inputs
    Given I have the yaml file "inputs.yml" containing:
    """
    1: 1
    2: 2
    """
    When I run pairwise inputs.yml
    Then I should see the output
    """
    | 1 | 2 |
    | 1 | 2 |

    """

  Scenario: inputing as csv
    Given I have the csv file "inputs.csv" containing:
      """
      media, event with image, event without image
      Image, Football, Football
      Video, Basketball, Basketball
      Music, Soccer, Soccer
      """
    When I run pairwise inputs.csv
    Then I should see the output
    """
    | media | event without image | event with image |
    | Image | Football            | Football         |
    | Image | Basketball          | Basketball       |
    | Image | Soccer              | Soccer           |
    | Video | Football            | Soccer           |
    | Video | Basketball          | Football         |
    | Video | Soccer              | Basketball       |
    | Music | Football            | Basketball       |
    | Music | Basketball          | Soccer           |
    | Music | Soccer              | Football         |

    """

  Scenario: Not replacing wild cards
    Given I have the yaml file "inputs.yml" containing:
    """
    - A: [A1, A2, A3]
    - B: [B1, B2]
    - C: [C1, C2, C3]
    """
    When I run pairwise inputs.yml --keep-wild-cards
    Then I should see the output
    """
    | A  | B              | C  |
    | A1 | B1             | C1 |
    | A1 | B2             | C2 |
    | A2 | B1             | C3 |
    | A2 | B2             | C1 |
    | A3 | B1             | C2 |
    | A3 | B2             | C3 |
    | A3 | any_value_of_B | C1 |
    | A2 | any_value_of_B | C2 |
    | A1 | any_value_of_B | C3 |

    """