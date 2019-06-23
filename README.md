# compositional-layouts-kit[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platform](https://img.shields.io/badge/platform-iOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift_5.1-orange.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

**Last Update: 23/June/2019.**

![](cover-composlayouts.png)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About
📏 A set of advanced compositional layouts for UICollectionViewCompositionalLayout with examples [Swift 5.1, iOS 13]. All the layouts support both `portrait` and `landscape` orientations as well as support for all `iOS` and `iPadOS` related size classes.

# ⚠️ Warning 
The assets used in this project were taken from the `Web`. Do not use them for commertial purposes and proprietary projects. They are used just for demostration only. 

# 🆘 Tips
2. Not all layouts may look cool in landscape orientations. In order to make them look cooler and take advantage of differnet aspect ratio of a screen, you need to create an alternative layout that is basically the copy of the portrait layout, but has different set of fractional width and height.
3. If you want to have different layouts in portrait and landscape device orientations, you need to use either one of the following approaches:
   - Use `viewWillTransition(to size: , with coordinator:)` method (of `UIViewController` class) and `setCollectionViewLayout(, animated: completion:)` method of `UICollectionView` class to properly animate changes of layout when changing orientation.
   - More advanced and preffered approach is to implement a custom `UICollectionViewTransitionLayout`, which is (a quote from `Apple's Docs`):
   >> A special type of layout object that lets you implement behaviors when changing from one layout to another in your collection view.
   
# 🏗 Setup

# ✈️ Usage

# 📚 Contents

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence 
The project is available under [MIT Licence](https://github.com/jVirus/compositional-layouts-kit /blob/master/LICENSE)
