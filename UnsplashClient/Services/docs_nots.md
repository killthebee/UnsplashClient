--- 
1. i really need to think how to handler singular unsplash Image download, so far it's look like if it can fail than it'll fail earlier dunno
2. reaching limit of api requests error is not handler :(
3. New images is downloaded in a "bunch" style is because I was eager to dip my toes into group tasks and fight racig conditions
---
I know is odd to have time for memory cach, I just openned a posibility for caching on disk, who knows
---
Tests
1. dunno why, but when running tests, at exif screen setImage complition is never  
executed, i know setImage is time consuming task, but still, I dunno
2. while running test, there is a really strange bug(?): after dismissing exif vc,
lable for collections becomes "New Images"
3. There is only 1 mock set of data for exifScreen seens I don't see the point to have more
4. I need to think wheter i want to keep exchangeCode at fake, after all
5. getRandomPhoto, I really hope what one day I'm gonna write generator in swift xD

---
errorPresentationHandler is binded in sceen delegate! (and token storage)
