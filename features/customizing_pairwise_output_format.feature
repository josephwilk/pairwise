Feature: Customizing pairwise output format
  In order to save time importing pairwise sets
  As a tester
  I want the output pairwise data to be in the most convenient format for me

  Scenario: formatting output as csv
    Given I have the yaml file "inputs.yml" containing:
      """
      - event with image: [Football, Basketball, Soccer]
      - event without image: [Football, Basketball, Soccer]
      - media: [Image, Video, Music]
      """
    When I run pairwise inputs.yml --format csv
    Then I should see the output
      """
	  event with image,event without image,media
	  Football,Football,Image
	  Football,Basketball,Video
	  Football,Soccer,Music
	  Basketball,Football,Video
	  Basketball,Basketball,Image
	  Basketball,Soccer,Image
	  Soccer,Football,Music
	  Soccer,Basketball,Image
	  Soccer,Soccer,Video
	  Basketball,Basketball,Music

      """