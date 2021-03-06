//
//  ViewController.swift
//  SwiftemExample
//
//  Created by InamuraHideto on 11/15/15.
//  Copyright © 2015 InamuraHideto. All rights reserved.
//

import UIKit
import Swiftem
import enum Swiftx.Either

class ViewController: UIViewController {
    
    private let swiftem = Swiftem(token: "21b4185d-677e-4ce0-bade-0db7e479c578")
    private let KeywordId = 6
    private let rStr = "\n\n↓\n\n"

    @IBOutlet weak var resLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func keywords(sender: AnyObject) {
        swiftem.keywords(KeywordId).execute { res in
            res.either(
                onLeft: { e in
                    self.resLabel.text = e
                },
                onRight: { r in
                    self.resLabel.text = "\(r)"
                }
            )
        }
    }
    
    @IBAction func filters(sender: AnyObject) {
        func getFilters(id: Int) {
            swiftem.filters(id).execute { res in
                res.either(
                    onLeft: { e in
                        self.resLabel.text =
                            self.resLabel.text! + "\(e)"
                    },
                    onRight: { r in
                        self.resLabel.text =
                            self.resLabel.text! + "\(r)"
                    }
                )
            }
        }
        swiftem.keywords(KeywordId).execute { res in
            res.either(
                onLeft: { e in
                    self.resLabel.text = e
                },
                onRight: { rs in
                    self.resLabel.text = "\(rs)\(self.rStr)"
                    rs.forEach { r in
                        getFilters(r.id)
                    }
                }
            )
        }
    }

    @IBAction func docs(sender: AnyObject) {
        func getDocs(id: Int) {
            swiftem.docs(id, categ: .All, date: ["20151115"]).readStatus(.Unread).execute { res in
                res.either(
                    onLeft: { e in
                        self.resLabel.text =
                            self.resLabel.text! + "\(self.rStr)(e)"
                    },
                    onRight: { rs in
                        print("==========[\(rs.count)]")
                        print(rs.first!.id)
                        self.resLabel.text =
                            self.resLabel.text! + "\(self.rStr)\(rs.first!)"
                    }
                )
            }
        }
        
        func getFilters(id: Int) {
            swiftem.filters(id).execute { res in
                res.either(
                    onLeft: { e in
                        self.resLabel.text =
                            self.resLabel.text! + "\(self.rStr)\(e)"
                    },
                    onRight: { rs in
                        self.resLabel.text =
                            self.resLabel.text! + "\(self.rStr)\(rs)"
                        getDocs(rs.first!.id)
                    }
                )
            }
        }
        swiftem.keywords(KeywordId).execute { res in
            res.either(
                onLeft: { e in
                    self.resLabel.text = e
                },
                onRight: { rs in
                    self.resLabel.text = "\(rs)"
                    getFilters(rs.first!.id)
                }
            )
        }
    }
    
    @IBAction func counts(sender: AnyObject) {
        swiftem.counts(451011470, categ: .All, from: "2015111500", to: "2015111700").readStatus(.Unread).execute { res in
            res.either(
                onLeft: { e in
                    self.resLabel.text = e
                },
                onRight: { rs in
                    self.resLabel.text = "\(rs)"
                }
            )
        }
    }
    
    @IBAction func read(sender: AnyObject) {
        swiftem.read(600342415, docIds: ["600342415-body-docs2015111512#http://nyatla.jp/nyanstock/archives/83576"]) { res in
            res.either(onLeft: { e in print(e) }, onRight: { ok in print(ok) })
        }
    }
}

