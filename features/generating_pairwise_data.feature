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
      | Football         | Basketball          | Music |
      | Football         | Soccer              | Video |
      | Basketball       | Football            | Music |
      | Basketball       | Basketball          | Video |
      | Basketball       | Soccer              | Image |
      | Soccer           | Football            | Video |
      | Soccer           | Basketball          | Image |
      | Soccer           | Soccer              | Music |

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
      | event with image | event without image | media |
      | Football         | Football            | Image |
      | Football         | Basketball          | Music |
      | Football         | Soccer              | Video |
      | Basketball       | Football            | Music |
      | Basketball       | Basketball          | Video |
      | Basketball       | Soccer              | Image |
      | Soccer           | Football            | Video |
      | Soccer           | Basketball          | Image |
      | Soccer           | Soccer              | Music |

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
    | event with image | event without image | media |
    | Football         | Football            | Image |
    | Football         | Basketball          | Music |
    | Football         | Soccer              | Video |
    | Basketball       | Football            | Music |
    | Basketball       | Basketball          | Video |
    | Basketball       | Soccer              | Image |
    | Soccer           | Football            | Video |
    | Soccer           | Basketball          | Image |
    | Soccer           | Soccer              | Music |

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
    | A1 | B2             | C3 |
    | A2 | B1             | C3 |
    | A2 | B2             | C2 |
    | A3 | B1             | C2 |
    | A3 | B2             | C1 |
    | A2 | any_value_of_B | C1 |
    | A1 | any_value_of_B | C2 |
    | A3 | any_value_of_B | C3 |

    """


    Scenario: yml with weird inputs that syck would interpret byte-wise, but Psych does not
      Given I have the yaml file "syck_inputs.yml" containing:
      """
      - event with utf8: [\xC3\xA8, \xC3\xA9, \xC3\xAA]
      - event with latin1: [\xEA, \xE9, \xE8]
      """
      When I run pairwise syck_inputs.yml
      Then it should not show any errors
      And I should see in the output
      """
      | event with utf8 | event with latin1 |
      | \xC3\xA8        | \xEA              |
      | \xC3\xA8        | \xE9              |
      | \xC3\xA8        | \xE8              |
      | \xC3\xA9        | \xEA              |
      | \xC3\xA9        | \xE9              |
      | \xC3\xA9        | \xE8              |
      | \xC3\xAA        | \xEA              |
      | \xC3\xAA        | \xE9              |
      | \xC3\xAA        | \xE8              |
      """

    Scenario: yml with extended characters that psych can interpret
      Given I have the yaml file "psych_inputs.yml" containing:
      """
      - event with accented: [è, à, ù ]
      - event with multibyte: ['日', '月', '火']
      """
      When I run pairwise psych_inputs.yml
      Then it should not show any errors
      And I should see in the output
      """
      | event with accented | event with multibyte |
      | è                   | 日                   |
      | è                   | 月                   |
      | è                   | 火                   |
      | à                   | 日                   |
      | à                   | 月                   |
      | à                   | 火                   |
      | ù                   | 日                   |
      | ù                   | 月                   |
      | ù                   | 火                   |
      """
