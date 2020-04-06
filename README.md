#  Master Detail Update Issues

There are several issues with updating Lists when the underlying data changes.

Ideally, when a new search is made the list is reset.  It should scroll to the top and any selection should be cleared or set to the top row.

1. If the List is scrolled then the List is still scrolled when the data is changed.  Performing a new search and updating the view "should" reset scrolling, selection, etc.  There’s no support for programmatic List scrolling or scroll-to-top or selection [yet].
2. If a row is selected then that row is still selected when the new results are displayed.  And the detail view for the new - and still selected row - is displayed.  Select one of the first 9 rows and cycle through the data sets to see this.
3. If the new search has less results - than the current search and the current selection and detail are at the end of the longer search then there are lots of different problems.  Select row "zzz-12" and cycle through the data in both directions.  Select row "fourteenth" and do the same.  Try this with both Clean and Messy detail views.

When Clean Detail is on the CleanDetailView is used.  When Clean Detail is off the MessyDetailView is used.

A simple "List" won't work at all:
```
    NavigationView {
        List(mainData, id: \.self) { stringData in
            NavigationLink(destination: DetailView(detailText: stringData)) {
                Text("\(stringData)  \(stringData)")
            }
        }
    }
    "stringData" is not a "@State" object, so it is not automatically refreshed.
    And DetailView is never updated until a row is tapped.
```
Tested on Simulator iPhone 11 Pro Max rotated to landscape and Simulator iPads in any rotation.
Also tested on physical iPhone XS Max rotated to landscape.
