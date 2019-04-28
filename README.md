#AirbusND

I originally wrote this code while on vacation in Hawaii. Besides enjoying the sun and the beaches I also wanted spend some time working on something related to my hobby, which is flight simulation. In any case, I had some images of an Airbus 320 navigation display. I though it would be cool hookup X-Plane 9 to an external iPad or Mac controlled display and see a closeup of some of the instrumentation.

The code in the `ObjectiveC` directory is a direct result of those efforts. Originally, the compass-rose displayed degrees around the circumference but Apple has since deprecated the API's I used to make that happen. I now need to resort to `TextKit`, not a straightforward task. Here is what the app looks like if you run it in macOS 10.14:

![](AirbusND.gif)

As it is currently written the compass-rose and the networking code that reads in and interprets UDP packets from X-plane are both broken. Actually in the case of the networking code, I'm not sure I finished getting that working as my whole team was laid-off in December '08, immediately after I returned from my vacation.

The drawing code was crafted using the mark-one eyeball. I would literally look at the images put some numbers into the drawing formula for each element of the display, then run it in order to see if I could match the output of the original instrumentation images. Not the best way to craft a drawing algorithm but when you don't have any specification or models except a 2D image, you make do.

Some years, later, I ported the Objective-C implementation to Swift version 3. I'm not totally sure of that as Swift changes so quickly. Now that Swift 5 has been released and version 5.1 is on the way, I think it is time to finish this project and put it on iOS. I can use an old iPad as a display for my cockpit. I don't need to wire up clunky monitor.

This is a side project. As I make progress, I'll update the README. That's all for now.
