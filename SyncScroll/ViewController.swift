//
//  ViewController.swift
//  SyncScroll
//
//  Created by 古宮 伸久 on 2021/02/02.
//

import UIKit

let collectionScroll = Notification.Name("collectionScroll")

final class ViewController: UIViewController {

    @IBOutlet weak var line1: UICollectionView!
    @IBOutlet weak var line2: UICollectionView!
    @IBOutlet weak var line3: UICollectionView!

    var lines: [UICollectionView] {
        [line1, line2, line3]
    }

    let dataSources: [DataSource] = [
        DataSource(["Germany", "Italy", "Russia", "Ukraine", "Ireland", "Iceland", "Albania", "Belgium", "Bulgaria", "Denmark", "Estonia", "Finland"]),
        DataSource(["cat", "kangaroo", "seal", "dog", "panda", "giraffe", "penguin", "zebra", "hippopotamus"]),
        DataSource(["カナダ", "アメリカ", "メキシコ", "ブラジル", "コスタリカ", "ベネズエラ", "アルゼンチン", "ボリビア", "チリ"]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLine(line1, dataSource: dataSources[0])
        setupLine(line2, dataSource: dataSources[1])
        setupLine(line3, dataSource: dataSources[2])

        NotificationCenter.default.addObserver(self, selector: #selector(receiveScrollNotification(notification:)), name: collectionScroll, object: nil)
    }

    @objc func receiveScrollNotification(notification: NSNotification) {
        guard let scrollView = notification.object as? UIScrollView else {
            return
        }
        let ratio = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        lines.filter { $0 != scrollView }.forEach {
            $0.setContentOffset(CGPoint(x: ($0.contentSize.width - $0.bounds.width) * ratio, y: $0.contentOffset.y), animated: false)
        }
    }

    func setupLine(_ collectionView: UICollectionView, dataSource: DataSource) {
        collectionView.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.invalidateLayout()
        }
    }
}

class DataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var array: [String]

    var dragging: Bool = false

    init(_ array: [String]) {
        self.array = array
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.label.text = array[indexPath.row]
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        dragging = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dragging = false
        NotificationCenter.default.post(name: collectionScroll, object: scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dragging {
            NotificationCenter.default.post(name: collectionScroll, object: scrollView)
        }
    }
}
