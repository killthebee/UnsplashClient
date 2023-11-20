async in presenter appears because i hate nested code: Requests are performed 
somewhere on background threads and slap @MainActor + async is the cleanest way
to return on main thread w/0 writing nested code

---
Collection collection view reusing cells, so it's look like i must store image data
at the same place as collection general data.
problem: you swiping from first to 5th, you can anticipate that last cell will
be "the last" ( by id, tag, etc ) but insted uikit will throw any other cell already used cell ( with unpredictible! id, tag, etc )   
