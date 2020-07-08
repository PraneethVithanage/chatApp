//
//  ContentView.swift
//  Chatapp
//
//  Created by praneeth vithanage on 7/8/20.
//  Copyright © 2020 praneeth vithanage. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ??
    false
    var body: some View {
        VStack{
            if status{
               
                Home()
            }
            else{
                NavigationView{
                 FirstPage()
            }
          }
        }.onAppear{
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChanage"), object: nil, queue: .main){
                (_)in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ??
                false
                
                self.status = status
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FirstPage : View {
     @State var ccode = ""
     @State var no = ""
     @State var show = false
     @State var msg = ""
     @State var alert = false
     @State var ID = ""
    var body :some View {
        VStack(spacing: 20) {
            Image("logo")
            
            Text ("Verify Your Number").font(.largeTitle).fontWeight(.heavy)
            
            
            Text ("Please Enter Your Number To Verify Your Account").font(.body).foregroundColor(.gray).padding(.top,12)
            HStack{
                 
                 TextField("+1",text: $ccode)
                     .frame(width:45)
                     .padding()
                     .background(Color("Color"))
                     .clipShape(RoundedRectangle(cornerRadius: 10))
                     
                     
                
                 TextField("Number",text: $no)
                     .padding()
                     .background(Color("Color"))
                     .clipShape(RoundedRectangle(cornerRadius: 10))
                
                  }.padding(.top ,15)
            NavigationLink(destination:SecondPage(show:$show, ID:$ID) ,isActive: $show){
                Button(action:{
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate:nil){
                        (ID,err)in
                        if err != nil{
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                            
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                    }
                }){
                                         Text("Send").frame(width:UIScreen.main.bounds.width - 30 ,height:50)
                                     }.foregroundColor(.white)
                                         .background(Color.orange)
                                         .cornerRadius(10)
            }
            
          
                          .navigationBarTitle("")
                          .navigationBarHidden(true)
                          .navigationBarBackButtonHidden(true)


            
            
        }.padding()
        
            .alert(isPresented: $alert){
                Alert(title: Text("Error"),message: Text(self.msg),dismissButton:.default(Text("OK")))
        }
    }
}


struct SecondPage : View {
     @State var code = ""
     @Binding var show :Bool
     @Binding var ID :String
     @State var msg = ""
     @State var alert = false
    
    var body :some View {
        
        ZStack(alignment:.topLeading) {
            GeometryReader{_ in
                VStack(spacing: 20) {
                           Image("logo")
                           
                           Text ("Verification Code").font(.largeTitle).fontWeight(.heavy)
                           
                           
                           Text ("Please Enter the Verification Code").font(.body).foregroundColor(.gray).padding(.top,12)
                       
                                
                    TextField("code",text: self.$code)
                                    .padding()
                                    .background(Color("Color"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.top ,15)
                                    
                               

                           
                          Button(action:{
                            let credential =
                            PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                            
                            Auth.auth().signIn(with: credential) { (res,err)in
                                if err != nil{
                                    self.msg = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    return
                                    
                                }
                                  UserDefaults.standard.set(true, forKey: "status")
                              NotificationCenter.default.post(name:NSNotification.Name("statusChanage"),object:nil)
                            }
                            
                          }){
                                         Text("Verify").frame(width:UIScreen.main.bounds.width - 30 ,height:50)
                                     }.foregroundColor(.white)
                                         .background(Color.orange)
                                         .cornerRadius(10)
                           .navigationBarTitle("")
                           .navigationBarHidden(true)
                           .navigationBarBackButtonHidden(true)


                }
            }
            
            Button(action:{
                
                self.show.toggle()
            }){
                Image(systemName: "chevron.left").font(.title)
            }.foregroundColor(.orange)
            
        }
        .padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg),dismissButton:.default(Text("OK")))
        }
    }
}

struct Home : View {
    var body : some View {
        VStack{
            Text("Home")
            
            Button(action:{
                try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name:NSNotification.Name("statusChanage"),object:nil)
            }){
                Text("Logout")
                
               
           }
        }
    }
}
