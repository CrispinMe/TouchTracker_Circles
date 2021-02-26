# TouchTracker_Circles
Chapter 18 Gold Challenge - Circles
Completed Challenge for Big Nerd Ranch iOS Programming Gold Challenge for Chapters 18: Touch Events and UIResponder

Solution to allow two fingers to draw circles on the screen.

Each finger represents one of the diagonally oposite corners of the bounding box surrounding the circle.

The location data for the two touches gained from the UITouch objects is stored in a dictionary object. The keys for the two CGPoint values contained within the dictionary are derived from the two UITouch objects.

The dictionary object relating to the circle (circle dictionary) is then added to a parent dictionary to record all the circles created.

At the end of the touchesEnded event handler method the UIView is redrawn, which results in all the created circles being drawn on the screen. The circle dictionary dictionary is looped through and the data within each circle dictionary is used to generate a rect object, which is then used to draw the cicle.


