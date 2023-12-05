async in presenter appears because i hate nested code: Requests are performed 
somewhere on background threads and slap @MainActor + async is the cleanest way
to return on main thread w/0 writing nested code

---
Collection collection view reusing cells, so it's look like i must store image data
at the same place as collection general data.
problem: you swiping from first to 5th, you can anticipate that last cell will
be "the last" ( by id, tag, etc ) but insted uikit will throw any other cell already used cell ( with unpredictible! id, tag, etc )   

---
roughlyCaroseulHeightPlusLableHightPlusGaps constant justifyed
 cuz i would never want to shrink cells hight

"collections" this [[]] is for  carousel porpuses

// OUTDATED!!!!
--- scroll view
headerContainerViewBottomAnchor sets image hight
imageTopAnchor pins image to top of the screen
imageHeightAnchor basicly one of kostyl's to prevent up swipe ( auto-layout rool to block any up swipe by forbidign any up swipe related layout changes)

-- over scroll 
somehow managed to stop over scrolling for scroll view, i think it's precise 
auto-layout rules... 

height of content view limits amout of space for new table that way i can prevent( or decrease) over scroll for new table ...

-- content view height
it's weird, it's must be bigger than scroll view's but not much, otherwise it'll limit amount of space for new table ...

-- scrollViewDidScroll
it takes too damn much time for scroll to stop, so if it's up swipe i just cut this scroll
one of kostyl's to make scroll view ui more responsive 
// Scroll view was an intresting expiries // OUTDATED!!!!

-- compositional layout
Top banner cell is suplementary thingy, that the only way i've found to make
this paralax like stretchyness

-- Lag when drawing second+ set of new images
it's some time requers additional time to draw image at full, thats strange
