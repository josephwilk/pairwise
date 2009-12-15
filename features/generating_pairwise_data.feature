Feature: Generating pairwise data
  In order to test small, managable datasets while having confidence in test coverage
  As a tester
  I want a set of tests which is smaller than all the possible combinations of my specified inputs

Scenario:
  Given I have the yaml file "inputs.yml" containing:
     """
     media: Image, Video, Music
     event with image: Football, Basketball, Soccer
     event without image: Football, Basketball, Soccer
     """
  When I run pairwise inputs.yml
  Then I should see the output
    """
    | media | event without image | event with image |
    | Image | Football            | Football         |
    | Image | Basketball          | Basketball       |
    | Image | Soccer              | Soccer           |
    | Video | Football            | Soccer           |
    | Video | Basketball          | Soccer           |
    | Video | Soccer              | Soccer           |
    | Music | Football            | Basketball       |
    | Music | Basketball          | Soccer           |
    | Music | Soccer              | Soccer           |

    """
