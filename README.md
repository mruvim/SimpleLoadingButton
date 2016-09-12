# SimpleLoadingButton
Simple button with loading animation

![SimpleLoadingButton](http://codingroup.com/assets/external/button.gif)



## Installation 
####CocoaPods:

```
pod 'SimpleLoadingButton', '~> 0.1.3'
```
and

```
$ pod install
```


####Manual:
Add files from `SimpleLoadingButton/Classes/*` to your project



##How to use it 
1. Add view in IB, change class to `SimpleLoadingButton`
2. Style button properties in IB Inspector
3. Create IBOutlet and call `buttonInstance.stop()` to stop animation
4. `buttonTappedHandler` callback will be invoked on `.TouchUpInside` event 

To view sample project run `pod try SimpleLoadingButton` in terminal



## Requirements

Compatible with `Xcode 7|8, iOS 8, iOS 9, iOS 10`

##Contribution

Found a bug? Please create an [issue](https://github.com/mruvim/SimpleLoadingButton/issues) </br>
Pull requests are welcome


## Contact

Ruvim Miksanskiy 
<a href="mailto:ruva@codingroup.com">![Email](http://codingroup.com/assets/external/email-icon.png)</a>

## License (MIT)

Copyright (c) 2016 -  Ruvim Miksanksiy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.