//
//  ContentView.swift
//  Xpendi (iOS)
//
//  Created by Ananya George on 9/30/21.
//

import SwiftUI

enum SortOption {
    case amountLowToHigh
    case amountHighToLow
    case dateOldestFirst
    case dateNewestFirst
}

struct ContentView: View {
    @State var balanceSheet: [Balance] = [
        Balance(amount: 567.8, title: "paid for popcorn", action: .withdrawal),
        Balance(amount: 767.8, title: "paid for gas", action: .withdrawal)
    ]
    
    @State var searchString: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading)
                    TextField("Search", text: $searchString).padding()
                    if(searchString != "") {
                        Button(action: {
                            searchString = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }

                    Menu {
                        Button("Amount: Low to High", action: {
                            sortBy(.amountLowToHigh)
                        })
                        Button("Amount: High to Low", action: {
                            sortBy(.amountHighToLow)
                        })
                        Button("Date: Oldest first", action: {
                            sortBy(.dateOldestFirst)
                        })
                        Button("Date: Newest first", action: {
                            sortBy(.dateNewestFirst)
                        })
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .padding()
                }
                List {
                    ForEach(balanceSheet) {
                        if(searchString == "") {
                            Text("\($0.title )")
                                .foregroundColor($0.action.color)
                        } else if($0.title.lowercased().contains(searchString.lowercased())){
                            Text("\($0.title )")
                                .foregroundColor($0.action.color)
                        }
                    }
                    #if os(iOS)
                    .onDelete(perform: deleteRow(at:))
                    #endif
                }
                .navigationBarHidden(true)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    #if os(iOS)
                    EditButton()
                    #endif
                }

                ToolbarItem(placement: .bottomBar) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        balanceSheet.remove(atOffsets: indexSet)
    }

    private func sortBy(_ option: SortOption) {
        switch option {
        case .amountLowToHigh:
            balanceSheet.sort {
                $0.amount < $1.amount
            }
        case .amountHighToLow:
            balanceSheet.sort {
                $0.amount > $1.amount
            }
        case .dateOldestFirst:
            balanceSheet.sort {
                $0.date > $1.date
            }
        case .dateNewestFirst:
            balanceSheet.sort {
                $0.date < $1.date
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
