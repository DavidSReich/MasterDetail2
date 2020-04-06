//
//  ContentView.swift
//  MasterDetail2
//
//  Created by David S Reich on 3/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import SwiftUI

let stringData9 = [
    "111111",
    "222222",
    "333333",
    "444444",
    "555555",
    "666666",
    "777777",
    "888888",
    "999999"
]

let stringData12 = [
    "ooo--1",
    "ppp--2",
    "qqq--3",
    "rrr--4",
    "sss--5",
    "ttt--6",
    "uuu--7",
    "vvv--8",
    "www--9",
    "xxx-10",
    "yyy-11",
    "zzz-12"
]

let stringData14 = [
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth",
    "eleventh",
    "twelfth",
    "thirteenth",
    "fourteenth"
]

let allData = [
    stringData9,
    stringData12,
    stringData14
]

struct ContentView: View {

    @State private var dataSet = 0
    @State private var mainData = [String]()
    @State private var useCleanDetail = false
    @State private var showInfoView = false

    init() {
        initMainData()
    }

    var body: some View {
        NavigationView {
            List(mainData.indices, id: \.self) { index in
                Group {
                    if self.useCleanDetail {
                        NavigationLink(destination: CleanDetailView(detailText: self.mainData[index])) {
                            Text("\(self.mainData[index])  \(self.mainData[index])")
                        }
                    } else {
                        NavigationLink(destination: MessyDetailView(mainData: self.$mainData, index: index)) {
                            Text("\(self.mainData[index])  \(self.mainData[index])")
                        }
                    }
                }
            }
            .navigationBarTitle("Master")
            .navigationBarItems(trailing:
                HStack {
                    Divider()
                    Toggle(isOn: $useCleanDetail, label: { Text("Clean\nDetail").font(.subheadline) })
                    Divider()
                    Button(action: {
                        self.setMainData(delta: -1)
                    }) {
                        Text("Previous")
                            .font(.subheadline)
                    }
                    Divider()
                    Button(action: {
                        self.setMainData(delta: 1)
                    }) {
                        Text("Next")
                            .font(.subheadline)
                    }
                    Divider()
                    infoButton()
            })

            Group {
                if self.useCleanDetail {
                    CleanDetailView(detailText: mainData.count > 0 ? mainData[0] : "")
                } else {
                    MessyDetailView(mainData: $mainData, index: 0)
                }
            }
        }
        .onAppear(perform: initMainData)
    }

    private func initMainData() {
        dataSet = 0
        setMainData(delta: 0)
    }

    private func setMainData(delta: Int) {
        if delta > 0 {
            dataSet += 1
            if dataSet >= allData.count {
                dataSet = 0
            }
        } else if delta < 0 {
            dataSet -= 1
            if dataSet < 0 {
                dataSet = allData.count - 1
            }
        }

        mainData = allData[dataSet]
    }

    private func infoButton() -> some View {
        Button(action: {
            self.showInfoView = true
        }) {
            Image(systemName: "info.circle.fill")
                .font(.title)
        }
        .sheet(isPresented: $showInfoView) {
            InfoView(isPresented: self.$showInfoView)
        }
    }
}

struct CleanDetailView: View {
    var detailText: String

    var body: some View {
        Text("\(detailText)")
            .navigationBarTitle(Text("Detail"))
    }
}

//it's a code smell to have the detail view know about mainData
struct MessyDetailView: View {
    @Binding var mainData: [String]
    var index: Int

    var body: some View {
        Text("\(index < mainData.count ? mainData[index] : "")")
            .navigationBarTitle(Text("Detail"))
    }
}

struct InfoView: View {
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                Text(
                    #"""
                    Tested on Simulator iPhone 11 Pro Max rotated to landscape and Simulator iPads in any rotation.
                    Also tested on physical iPhone XS Max rotated to landscape.

                    When Clean Detail is on the CleanDetailView is used.  When Clean Detail is off the MessyDetailView is used.

                    There are several issues with updating Lists when the underlying data changes.
                    1. If the List is scrolled then the List is still scrolled when the data is changed.  Performing a new search and updating the view "should" reset scrolling, selection, etc.  There’s no support for programmatic List scrolling or scroll-to-top or selection [yet].
                    2. If a row is selected then that row is still selected when the new results are displayed.  And the detail view for the new - and still selected row - is displayed.  Select one of the first 9 rows and cycle through the data sets to see this.
                    3. If the new search has less results - than the current search and the current selection and detail are at the end of the longer search then there are lots of different problems.  Select row "zzz-12" and cycle through the data in both directions.  Select row "fourteenth" and do the same.  Try this with both Clean and Messy detail views.

                    Ideally when a new search is made the list is reset.  It should scroll to the top and any selection should be cleared or set to the top row.

                    A simple "List" won't work at all:
                        NavigationView {
                            List(mainData, id: \.self) { stringData in
                                NavigationLink(destination: DetailView(detailText: stringData)) {
                                    Text("\(stringData)  \(stringData)")
                                }
                            }
                        }
                        "stringData" is not a "@State" object, so it is not automatically refreshed.
                        And DetailView is never updated until a row is tapped.
                    """#
                )
                .onTapGesture(count: 2) {
                    self.isPresented = false
                }
            }
            .navigationBarTitle(Text("Info -- double-tap to close"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
