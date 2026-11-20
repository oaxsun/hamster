//
//  Details.swift
//  tickethamsterV3
//
//  Created by Eduardo Jimenez on 21/10/24.
//

import SwiftUI

struct Details: View {
    
    // CIERRA EL MODAL
    @Environment(\.presentationMode) var presentationMode
    
    let page: Page
    
    var body: some View {
        
        ZStack {
            List {
                
                VStack(alignment: .leading) {
                    Text("Seat Location")
                        .bold()
                    
                    Text(page.seatDetail.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.5)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text(page.tx6.firebaseLineBreaks)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(page.tx7.firebaseLineBreaks)
                        .font(.system(size: 13.5))
                        .padding(.vertical, 0.5)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Entry Info")
                        .bold()
                    
                    Text("Boleto Digital")
                        .font(.system(size: 15))
                        .padding(.vertical, 0.5)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Barcode Number")
                        .bold()
                    
                    Text(page.barcodeNumber.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.5)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text(page.place.firebaseLineBreaks)
                        .bold()
                    
                    Text(page.city.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.5)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Order Number")
                        .bold()
                    
                    Text(page.purchase.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Ticket Type")
                        .bold()
                    
                    Text(page.tx1.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Entrance")
                        .bold()
                    
                    Text(page.acceso.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Purchase Date")
                        .bold()
                    
                    Text(page.purchase.firebaseLineBreaks)
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Ticket Price")
                        .bold()
                    
                    Text(priceLine(label: "Ticket Face Value", value: page.price))
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(priceLine(label: "GRAND TOTAL", value: page.price))
                        .font(.system(size: 15))
                        .padding(.vertical, 0.1)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10)
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        
        // HEADER
        .overlay {
            ZStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Color("nHead")
                        .frame(width: 600, height: 105)
                        .background(.ultraThinMaterial)
                        .blur(radius: 0.5)
                        .edgesIgnoringSafeArea(.top)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                ZStack {
                    Image(systemName: "multiply")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.trailing, 350)
                    
                    Text("Ticket Details")
                        .font(.custom("Lexend", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func priceLine(label: String, value: String) -> String {
        let spaces = String(repeating: " ", count: max(1, 55 - label.count))
        return "\(label)\(spaces)\(value)"
    }
}

#Preview {
    Details(page: Page.samplePage)
}
